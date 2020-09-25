library(winch)

foo0 <- function() {
  winch_call(bar0)
}

bar0 <- function() {
  winch_call(baz0)
}

baz0 <- function() {
  winch_trace_back()
}

if (winch_available()) {
  foo0()
}
