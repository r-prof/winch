#' Enrich an rlang traceback with details on native calls
#'
#' This function uses the native stack trace returned from [winch_trace_back()]
#' to add details on native function calls to an rlang traceback object.
#' It is intended to be called by rlang.
#'
#' @param trace An rlang traceback as returned by [rlang::trace_back()].
#'
#' @export
#' @examplesIf requireNamespace("rlang", quietly = TRUE)
#' foo <- function() {
#'   winch_call(bar)
#' }
#'
#' bar <- function() {
#'   trace <- rlang::trace_back()
#'   winch_add_trace_back(trace)
#' }
#'
#' foo()
winch_add_trace_back <- function(trace = rlang::trace_back(bottom = parent.frame())) {
  if (!winch_available()) {
    return(trace)
  }

  # Avoid recursion
  old_options <- options(rlang_trace_use_winch = NULL)
  on.exit(options(old_options))
  rlang_trace <- trace

  native_trace <- winch_trace_back()
  # Remove __libc_start_main because it comes between two entries pointing to
  # .../bin/exec/R
  native_trace <- native_trace[is.na(native_trace$func) | native_trace$func != "__libc_start_main", ]

  # FIXME: This is artificial, remove when done
  #native_trace <- rep(native_trace, each = 3)

  is_libr <- procmaps::path_is_libr(native_trace$pathname)
  is_libr_idx <- which(is_libr)

  if (length(is_libr_idx) == 0) {
    warning("winch: libR not found in backtrace, can't merge.", call. = FALSE)
    return(rlang_trace)
  }

  first_libr <- is_libr_idx[[length(is_libr_idx)]]

  native_trace <- native_trace[seq_len(first_libr), ]
  is_libr <- is_libr[seq_len(first_libr)]

  # No native code called?
  if (all(is_libr)) {
    return(rlang_trace)
  }

  # Compute chunks of native stack traces between libR.so traces
  is_libr_rle <- rle(cumsum(is_libr))
  is_native_rle_idx <- which(is_libr_rle$lengths != 1)
  native_idx_len <- is_libr_rle$lengths[is_native_rle_idx] - 1L
  native_idx_end <- cumsum(is_libr_rle$lengths)[is_native_rle_idx]
  native_trace_chunks <- rev(Map(native_idx_end, native_idx_len, f = function(end, len) {
    native_trace[seq.int(end, by = -1L, length.out = len), ]
  }))

  # Find all functions in the stack trace that call .Call(),
  # .External() or .External2()
  r_funs <- sys_functions()
  # The sys_functions() call must be separate, it is very brittle

  # At this point the frames after bottom have been chopped off, if any.
  # We're doing the same here with head()
  r_funs <- utils::head(r_funs, rlang::trace_length(trace))

  # Find calls in functions' bodies
  r_fun_bodies <- lapply(r_funs, body)
  r_fun_calls <- lapply(r_fun_bodies, find_calls)

  r_fun_has_call_idx <- which(lengths(r_fun_calls) > 0)
  if (length(r_fun_has_call_idx) == 0) {
    # No .Call() found? Append at end
    r_fun_has_call_idx <- length(r_funs)
  }

  if (length(r_fun_has_call_idx) > length(native_trace_chunks)) {
    # Are there too many occurrences of .Call() etc.? Omit
    length(r_fun_has_call_idx) <- length(native_trace_chunks)
  } else if (length(r_fun_has_call_idx) < length(native_trace_chunks)) {
    # Did we miss a call into native? Append at end
    end_idx <- seq.int(length(r_fun_has_call_idx), length(native_trace_chunks), by = 1L)
    native_trace_chunks[[length(r_fun_has_call_idx)]] <-
      do.call(rbind, native_trace_chunks[end_idx])
    length(native_trace_chunks) <- length(r_fun_has_call_idx)
  }

  # Insert native stack trace chunks into R stack trace
  # Reverse order is important to avoid index shifts after inserting
  # into the trace
  for (i in rev(seq_along(r_fun_has_call_idx))) {
    rlang_trace <- insert_native_chunk(rlang_trace, r_fun_has_call_idx[[i]], native_trace_chunks[[i]])
  }

  class(rlang_trace) <- c("winch_trace", class(rlang_trace))
  rlang_trace
}

lag <- function(x, default = NA) {
  c(default, x[-length(x)])
}

sys_functions <- function() {
  idx <- seq_len(sys.nframe() - 2L)
  lapply(idx, sys.function)
}

find_calls <- function(x) {
  if (is.call(x)) {
    fun <- x[[1L]]
    if (identical(fun, quote(.Call))) {
      x[[2L]]
    } else if (identical(fun, quote(.External))) {
      x[[2L]]
    } else if (identical(fun, quote(.External2))) {
      x[[2L]]
    } else {
      out <- lapply(as.list(x)[-1], find_calls)
      unlist(out)
    }
  } else {
    NULL
  }
}

insert_native_chunk <- function(trace, idx, native) {
  # Check for trace version
  if (identical(attr(trace, "version"), 1L)) {
    # pre 1.0.0
    return(insert_native_chunk_0(trace, idx, native))
  }

  added_namespaces <- paste0("/", basename(native$pathname))
  added_calls <- lapply(native$func, function(func) call(func))

  old_size <- length(trace$call)
  new_size <- old_size + length(added_calls)
  if (old_size == new_size) {
    # Nothing to do
    return(native)
  }

  # Prepare for pasting
  added_idx <- seq.int(idx + 1L, length.out = length(added_calls))
  added_parents <- lag(added_idx, default = idx)
  rechain_idx <- added_idx[[length(added_idx)]]

  # Create translation table
  xlat <- c(
    seq_len(idx),
    seq.int(idx + length(added_calls) + 1L, length.out = old_size - idx)
  )
  xlat1 <- c(0L, xlat)

  # Move
  new_parents <- rep(-1L, new_size)
  new_parents[xlat] <- xlat1[trace$parent + 1L]

  new_calls <- rep(NULL, new_size)
  new_calls[xlat] <- trace$call

  new_visible <- rep(TRUE, new_size)
  new_visible[xlat] <- trace$visible

  new_namespace <- rep(NA_character_, new_size)
  new_namespace[xlat] <- trace$namespace

  new_scope <- rep(NA_character_, new_size)
  new_scope[xlat] <- trace$scope

  new_idx <- seq_len(new_size)

  # Rechain existing
  parents_fix_idx <- (new_parents == idx)
  grandparents_fix_idx <- (new_parents == new_parents[[idx]] & seq_along(new_parents) > idx)
  new_parents[parents_fix_idx | grandparents_fix_idx] <- rechain_idx

  # Paste (after rechaining!)
  new_parents[added_idx] <- added_parents
  new_calls[added_idx] <- added_calls
  new_namespace[added_idx] <- added_namespaces
  new_scope[added_idx] <- "::"

  # Use new
  new <- data.frame(
    call = new_parents, parent = new_parents,
    visible = new_visible, namespace = new_namespace, scope = new_scope,
    stringsAsFactors = FALSE
  )
  # Can't pass in constructor
  new$call <- new_calls

  # Clumsy way of replacing the contents of `trace` without touching the attributes
  new_idx <- seq_len(nrow(new))
  trace[new_idx, ] <- trace[new_idx, ]
  trace[] <- new

  trace
}

insert_native_chunk_0 <- function(trace, idx, native) {
  added_calls <- Map(
    basename(native$pathname),
    native$func,
    f = function(basename, func) as.call(list(call(
      "::",
      as.name(paste0("/", basename)),
      as.name(func)
    )))
  )

  old_size <- length(trace$calls)
  new_size <- old_size + length(added_calls)
  if (old_size == new_size) {
    # Nothing to do
    return(native)
  }

  # Prepare for pasting
  added_idx <- seq.int(idx + 1L, length.out = length(added_calls))
  added_parents <- lag(added_idx, default = idx)
  rechain_idx <- added_idx[[length(added_idx)]]

  # Create translation table
  xlat <- c(
    seq_len(idx),
    seq.int(idx + length(added_calls) + 1L, length.out = old_size - idx)
  )
  xlat1 <- c(0L, xlat)

  # Move
  new_parents <- rep(-1L, new_size)
  new_parents[xlat] <- xlat1[trace$parents + 1L]

  new_calls <- rep(NULL, new_size)
  new_calls[xlat] <- trace$calls

  new_idx <- seq_len(new_size)

  # Rechain existing
  parents_fix_idx <- new_parents == idx
  grandparents_fix_idx <- (new_parents == new_parents[[idx]] & seq_along(new_parents) > idx)
  new_parents[parents_fix_idx | grandparents_fix_idx] <- rechain_idx

  # Paste (after rechaining!)
  new_parents[added_idx] <- added_parents
  new_calls[added_idx] <- added_calls

  # Use new
  trace$calls <- new_calls
  trace$parents <- new_parents
  trace$indices <- new_idx

  trace
}
