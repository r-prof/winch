default_method <- NULL

#' @export
winch_available <- function() {
  default_method != 0L
}

set_default_method <- function() {
  default_method <<- .Call(winch_c_trace_back_default_method)
}
