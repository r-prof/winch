#' @export
winch_get_proc_map <- function(path = "/proc/self/maps") {
  lines <- readLines(path)
  lines
}
