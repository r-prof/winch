if (winch::winch_available() && require(vctrs)) {
  options(
    error = rlang::entrace,
    rlang_backtrace_on_error = "full",
    rlang_trace_use_winch = TRUE
  )

  winch::winch_init_library(vctrs:::vctrs_init$dll[["path"]])

  tryCatch(vctrs::vec_as_location(quote, 2), error = identity)
}
