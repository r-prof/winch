default_method <- NULL

.onLoad <- function(libname, pkgname) {
  # Update the default method
  ns <- asNamespace("winch")
  ns[["default_method"]] <- .Call(winch_c_trace_back_default_method)
}
