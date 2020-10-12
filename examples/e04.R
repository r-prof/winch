#' Native code is not part of R's stack trace
#'
#' - winch_call(fun) does the same as fun(), via native code

library(winch)

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  winch_call(baz)
}

baz <- function() {
  sys.calls()
}

foo()
