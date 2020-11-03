#' Are native tracebacks available?
#'
#' Returns `TRUE` if [winch_trace_back()] is supported on this platform.
#'
#' @return A scalar logical.
#' @export
#' @examples
#' winch_available()
winch_available <- function() {
  # https://stackoverflow.com/a/62364698/946850
  if (grepl("/valgrind/|/vgpreload_", Sys.getenv("LD_PRELOAD"))) {
    return(FALSE)
  }
  # in zzz.R
  default_method != 0L
}
