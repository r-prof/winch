#' Joint stack traces:
#'
#' - In R: find functions that contain .Call() or .External()
#' - In native: look for entries outside libR.so

library(winch)

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  winch_call(baz)
}

baz <- function() {
  trace <- rlang::trace_back()
  winch_add_trace_back(trace)
}

foo()
