.onLoad <- function(libname, pkgname) {
  tryCatch(default_method <<- .Call(winch_c_trace_back_default_method), error = identity)
}
