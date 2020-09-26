default_method <- NULL

#' Are native tracebacks available?
#'
#' Returns `TRUE` if [winch_trace_back()] is supported on this platform.
#'
#' @return A scalar logical.
#' @export
#' @examples
#' winch_available()
winch_available <- function() {
  default_method != 0L
}

set_default_method <- function() {
  default_method <<- .Call(winch_c_trace_back_default_method)
}
