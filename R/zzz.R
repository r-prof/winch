.onLoad <- function(libname, pkgname) {
  default_method <<- .Call(winch_c_trace_back_default_method)
}
