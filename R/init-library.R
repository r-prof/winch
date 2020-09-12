library_env <- new.env(parent = emptyenv())

#' @export
winch_init_library <- function(path = NULL, force = FALSE) {
  stopifnot(is.logical(force), length(force) == 1)

  # Windows: give message only for the first call and only if path is NULL
  # Linux: never give message

  if (is.null(path)) {
    # Default to our library, which is compiled with debug info.
    path <- winch_c_init_library$dll[["path"]]
    need_path_message <- is.null(library_env$path)
  } else {
    need_path_message <- FALSE
  }

  if (identical(path, library_env$path) && !force) {
    return(invisible())
  }

  library_env$path <- path

  work_done <- .Call(winch_c_init_library, path, force)
  if (isTRUE(work_done) && need_path_message) {
    message(paste0(
      "On this platform, native symbols can be deduced for only one shared library at a time. ",
      "Initialized with ", path, ", use `winch_init_library()` to override."
    ))
  }

  invisible()
}
