
library(winch)

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  purrr::map(1, ~ baz())
}

baz <- function() {
  winch_call(boo)
}

boo <- function() {
  winch_add_trace_back()
}

if (winch_available() && requireNamespace("purrr")) {
  tryCatch(foo(), error = identity)
}
