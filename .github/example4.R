library(winch)

options(error = winch_trace_back, rlang_backtrace_on_error = "full")

foo <- function() {
  winch_call(function() bar())
}

bar <- function() {
  winch_stop("oops")
}

foo()
