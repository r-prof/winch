#' Call an R function from native code
#'
#' Primarily intended for testing.
#'
#' @param fun A function callable without arguments.
#' @param env The environment in which to evaluate the function call.
#'
#' @seealso [winch_stop()]
#'
#' @return
#' @export
#' @examples
#' foo <- function() {
#'   winch_call(bar)
#' }
#'
#' bar <- function() {
#'   writeLines("Hi!")
#' }
#'
#' foo()
winch_call <- function(fun, env = parent.frame()) {
  .Call(winch_c_call, fun, env)
}
