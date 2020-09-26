library(winch)

foo <- function() {
  winch_call(function() bar())
}

bar <- function() {
  winch_stop("oops")
}

if (winch_available() && requireNamespace("rlang")) {
  options(
    error = rlang::entrace,
    rlang_backtrace_on_error = "full",
    rlang_trace_use_winch = 1L
  )

  foo()
}
