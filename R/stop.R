#' Raise an error from native code
#'
#' Primarily intended for testing.
#'
#' @param message The error message.
#'
#' @seealso [winch_call()]
#'
#' @return This function throws an error and does not return.
#' @export
#' @examples
#' try(winch_stop("Test"))
winch_stop <- function(message) {
  .Call(winch_c_stop, enc2native(message))
}
