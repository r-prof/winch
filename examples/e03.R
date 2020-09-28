#' Stack trace:  sequence of code locations
#' that describes the execution path
#' from a program’s main entry point
#' to a specific point of interest.
#'
#' - For inspection

foo <- function() {
  bar()
}

bar <- function() {
  baz()
}

baz <- function() {
  sys.calls()
}

foo()
