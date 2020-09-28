#' Stack trace:  sequence of code locations
#' that describes the execution path
#' from a program’s main entry point
#' to a specific point of interest.
#'
#' - For profiling

foo <- function() {
  for (i in 1:10000) bar()
}

bar <- function() {
  for (i in 1:100) baz()
}

baz <- function() {
  runif(1)
}

profvis::profvis(foo())

# Rprof(line.profiling = TRUE, filter.callframes = TRUE)
# foo()
# Rprof(NULL)
