#' @export
winch_trace_back <- function() {
  native_trace <- .Call(winch_c_trace_back)

  native_trace
}
