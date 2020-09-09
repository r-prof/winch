default_method <- NULL

#' @export
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
