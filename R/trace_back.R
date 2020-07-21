#' @export
winch_trace_back <- function() {
  print(rlang::trace_back())
  print(sys.calls())
  trace <- .Call(winch_c_trace_back)

  eval <- grepl("Rf_eval", trace)
  apply_closure <- grepl("Rf_applyClosure", trace)

  which(eval & lag(apply_closure))
}

lag <- function(x) {
  c(NA, x[-length(x)])
}
