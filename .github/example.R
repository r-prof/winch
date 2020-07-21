library(winch)

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

baz(boo())
