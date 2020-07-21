#' @export
winch_entrace <- function(cnd) {
  if (!missing(cnd) && inherits(cnd, "rlang_error")) {
    return()
  }

  trace <- winch_trace_back()

  if (missing(cnd)) {
    last_error_env <- rlang:::last_error_env
    last_error_env$cnd$trace <- trace
    rlang:::entrace_handle_top(trace)
  } else {
    abort(conditionMessage(cnd) %||% "", error = cnd, trace = trace)
  }
}
