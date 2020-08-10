#' @export
winch_trace_back <- function() {
  native_trace <- .Call(winch_c_trace_back)

  ip <- native_trace[[2]]

  map <- winch_get_proc_map()

  gte <- (ip >= map$from)
  lt <- (ip < map$to)
  inside <- which(gte & lt)

  if (length(inside) > 0) {
    native_trace[[3]] <- map$pathname[ inside[[1]] ]
  }

  native_trace
}
