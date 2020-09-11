library(winch)
library(magrittr)

options(error = rlang::entrace, rlang_backtrace_on_error = "full")

foo <- function() {
  winch_call(function() bar())
}

bar <- function() {
  winch_stop("oops")
}

foo() %>% identity()
