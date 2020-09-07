#' @export
winch_stop <- function(message) {
  .Call(winch_c_stop, enc2utf8(message))
}
