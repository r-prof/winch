#' @export
winch_trace_back <- function() {
  rlang_trace <- rlang::trace_back(bottom = parent.frame())

  native_trace <- .Call(winch_c_trace_back)
  # Better results on Ubuntu
  native_trace <- sub("^/[^ ]+/", "", native_trace)
  # Better results on macOS
  native_trace <- gsub("[[:space:]]+", " ", native_trace)

  # FIXME: This is artificial, remove when done
  #native_trace <- rep(native_trace, each = 3)

  is_libr <- grepl("libR[.]", native_trace)
  is_libr_idx <- which(is_libr)

  first_libr <- is_libr_idx[[length(is_libr_idx)]]

  native_trace <- native_trace[seq_len(first_libr)]
  is_libr <- is_libr[seq_len(first_libr)]

  if (all(is_libr)) {
    return(rlang_trace)
  }

  is_libr_rle <- rle(cumsum(is_libr))
  is_native_rle_idx <- which(is_libr_rle$lengths != 1)
  native_idx_len <- is_libr_rle$lengths[is_native_rle_idx] - 1L
  native_idx_end <- cumsum(is_libr_rle$lengths)[is_native_rle_idx]
  native_trace_chunks <- Map(native_idx_end, native_idx_len, f = function(end, len) {
    native_trace[seq.int(end, by = -1L, length.out = len)]
  })

  r_funs <- sys_functions()[-1]
  # Must be separate, sys_functions() is very brittle
  r_funs <- rev(r_funs)
  r_fun_bodies <- lapply(r_funs, body)
  r_fun_calls <- lapply(r_fun_bodies, find_calls)

  # r_fun_ids <- Map(r_fun_calls, r_funs, f = function(calls, fun) {
  #   lapply(calls, eval, environment(fun))
  # })
  #
  # r_fun_names <- lapply(r_fun_ids, lapply, `[[`, "name")
  # r_fun_names_chr <- lapply(r_fun_names, unlist)

  r_fun_has_call_idx <- which(lengths(r_fun_calls) > 0)
  if (length(r_fun_has_call_idx) == 0) {
    # No .Call() found? Append at end
    r_fun_has_call_idx <- length(r_funs)
  }

  if (length(r_fun_has_call_idx) > length(native_trace_chunks)) {
    length(r_fun_has_call_idx) <- length(native_trace_chunks)
  } else if (length(r_fun_has_call_idx) < length(native_trace_chunks)) {
    # Did we miss a call into native? Append at end
    end_idx <- seq.int(length(r_fun_has_call_idx), length(native_trace_chunks), by = 1L)
    native_trace_chunks[[length(r_fun_has_call_idx)]] <-
      unlist(native_trace_chunks[end_idx])
    length(native_trace_chunks) <- length(r_fun_has_call_idx)
  }

  append_native_chunk <- function(trace, idx, native) {
    new_calls <- lapply(native, function(x) call(x))
    trace$calls <- c(trace$calls, new_calls)
    new_idx <- max(trace$indices) + seq_along(new_calls)

    # Rechain existing
    parents_fix_idx <- trace$parents == idx
    grandparents_fix_idx <- (trace$parents == trace$parents[[idx]] & seq_along(trace$parents) > idx)
    trace$parents[parents_fix_idx | grandparents_fix_idx] <- new_idx[[length(new_idx)]]

    # Chain new
    trace$parents <- c(trace$parents, lag(new_idx, default = idx))

    trace$ids <- c(trace$ids, paste0(trace$ids[[idx]], "-", new_idx))
    trace$indices <- c(trace$indices, new_idx)

    trace
  }

  for (i in seq_along(r_fun_has_call_idx)) {
    rlang_trace <- append_native_chunk(rlang_trace, r_fun_has_call_idx[[i]], native_trace_chunks[[i]])
  }

  class(rlang_trace) <- c("winch_trace", class(rlang_trace))
  rlang_trace
}

lag <- function(x, default = NA) {
  c(default, x[-length(x)])
}

sys_functions <- function() {
  idx <- seq(-2, -sys.nframe(), by = -1)
  lapply(idx, sys.function)
}

find_calls <- function(x) {
  if (is.call(x)) {
    fun <- x[[1L]]
    if (identical(fun, quote(.Call))) {
      x[[2L]]
    } else {
      out <- lapply(as.list(x)[-1], find_calls)
      unlist(out)
    }
  } else {
    NULL
  }
}
