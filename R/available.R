#' Are native tracebacks available?
#'
#' Returns `TRUE` if [winch_trace_back()] is supported on this platform.
#'
#' @return A scalar logical.
#' @export
#' @examples
#' winch_available()
winch_available <- function() {
  # in zzz.R
  default_method != 0L
}
