#' Native stack trace:
#'
#' > ... esoteric topic lies at the intersection of
#' > compilers, linkers, loaders, debuggers, ABIs,
#' > and language runtimes.
#'
#' Specialized libraries provide _portable_ stack trace.

library(winch)

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  winch_call(baz)
}

baz <- function() {
  winch_trace_back()
}

foo()
View(foo())
