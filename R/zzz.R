.onLoad <- function(libname, pkgname) {
  .Call(winch_c_init_library, get_argv0())

  tryCatch(default_method <<- .Call(winch_c_trace_back_default_method), error = identity)
}

get_argv0 <- function() {
  argv0 <- commandArgs()[[1]]
  if (!file.exists(argv0)) return(NULL)
  argv0
}
