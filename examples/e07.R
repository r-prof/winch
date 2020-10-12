#' Integration with rlang:
#'
#' - https://github.com/r-lib/rlang/pull/1039

library(winch)

options(rlang_trace_use_winch = TRUE)

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  winch_call(baz)
}

baz <- function() {
  rlang::trace_back()
}

foo()
