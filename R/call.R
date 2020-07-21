#' @export
winch_call <- function(fun, env = parent.frame()) {
  #.Call(winch_c_call, deparse(substitute(fun)), env);
  .Call(winch_c_call, fun, env);
}
