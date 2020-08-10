library(winch)

foo0 <- function() {
  winch_call(bar0)
}

bar0 <- function() {
  winch_call(baz0)
}

baz0 <- function() {
  .Call(winch:::winch_c_trace_back)
}

foo0()
