#' @export
winch_trace_back <- function() {
  .Call(winch_c_trace_back)
  print(rlang::trace_back())
  print(sys.calls())
  invisible()
}
