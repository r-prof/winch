library(winch)

foo0 <- function() {
  winch_call(bar0)
}

bar0 <- function() {
  winch_trace_back()
}

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  baz(winch_trace_back())
}

baz <- function(call) {
  force(call)
}

qoo <- function() {
  boo()
}

boo <- function() {
  winch_trace_back()
}

tb <- function() {
  rlang::trace_back()
}

out <- foo0()
