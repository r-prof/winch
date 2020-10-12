#' Error handling
#'
#' - options(error = rlang::entrace)

library(winch)

options(
  error = rlang::entrace,
  rlang_backtrace_on_error = "full",
  rlang_trace_use_winch = TRUE
)

foo <- function() {
  purrr::map(list(bar), winch_call) # winch_call(bar)
}

bar <- function() {
  vctrs::vec_as_location(quote, 2)
}

foo()
