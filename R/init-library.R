library_env <- new.env(parent = emptyenv())

#' Set library to collect symbols for native stack traces
#'
#' On Windows, function names in native stack traces can be obtained
#' for only one library at a time.
#' Call this function to set the library for which to obtain symbols.
#'
#' @param path Path to the DLL.
#' @param force Reinitialize even if the path to the DLL is unchanged
#'   from the last call.
#'
#' @return This function is called for its side effects.
#'
#' @seealso [winch_call()]
#'
#' @export
#' @examplesIf requireNamespace("rlang", quietly = TRUE)
#' winch_init_library(rlang:::.__NAMESPACE__.$DLLs[[1]]$path)
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
