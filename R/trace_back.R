#' Native stack trace
#'
#' This function returns the native stack trace as a data frame.
#' Each native stack frame corresponds to one row in the returned data frame.
#' Deep function calls come first, the last row corresponds to the
#' running process's entry point.
#'
#' On Windows, call [winch_init_library()] to return function names
#' for a specific package.
#'
#' @return A data frame with the columns:
#'
#' - `func`: function name
#' - `ip`: instruction pointer
#' - `pathname`: path to shared library
#'
#' @seealso [sys.calls()] for the R equivalent.
#'
#' @export
#' @examplesIf winch_available()
#' winch_trace_back()
#'
#' foo <- function() {
#'   winch_call(bar)
#' }
#'
#' bar <- function() {
#'   winch_trace_back()
#' }
#'
#' foo()
winch_trace_back <- function() {
  winch_init_library()

  native_trace <- .Call(winch_c_trace_back, default_method)

  ip <- native_trace[[2]]

  map <- procmaps::procmap_get(as_tibble = FALSE)

  gte <- outer(ip, map$from, `>=`)
  lt <- outer(ip, map$to, `<`)
  inside <- apply(gte & lt, 1, function(x) which(x)[1])

  native_trace[[3]] <- map$pathname[inside]

  attr(native_trace, "row.names") <- .set_row_names(length(native_trace[[1]]))
  names(native_trace) <- c("func", "ip", "pathname")
  class(native_trace) <- "data.frame"

  native_trace
}
