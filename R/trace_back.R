#' @export
winch_trace_back <- function() {
  print(rlang::trace_back())
  print(sys.calls())
  .Call(winch_c_trace_back)
}
