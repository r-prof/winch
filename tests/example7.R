library(winch)

foo <- function() {
  purrr::map(1, ~ bar())
}

bar <- function() {
  winch_call(baz)
}

baz <- function() {
  winch_add_trace_back()
}

if (winch_available() && requireNamespace("purrr")) {
  tryCatch(foo(), error = identity)
}
