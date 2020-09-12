library(winch)

options(error = rlang::entrace, rlang_backtrace_on_error = "full")

foo <- function() {
  winch_call(function() bar())
}

bar <- function() {
  stop("oops")
}

foo()
