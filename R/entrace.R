#' @export
winch_entrace <- function() {
  rlang::local_options("rlang:::trace_hook" = winch_trace_back)
  rlang::entrace()
}
