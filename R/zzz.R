.onLoad <- function(libname, pkgname) {
  .Call(winch_c_init_library, get_argv0())

  tryCatch(default_method <<- .Call(winch_c_trace_back_default_method), error = identity)
}

get_argv0 <- function() {
  # For libbacktrace's purposes, argv0 is our shared library, which is compiled
  # with debug info.
  # This allows libbacktrace to perform correct initialization for this and
  # for subsequent libraries, hopefully.
  winch_c_init_library$dll[["path"]]
}
