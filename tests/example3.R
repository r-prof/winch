options(error = rlang::entrace, rlang_backtrace_on_error = "full")

winch::winch_init_library(vctrs:::vctrs_init$dll[["path"]])

vctrs::vec_as_location(quote, 2)
