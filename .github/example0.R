library(winch)

foo0 <- function() {
  winch_call(bar0)
}

bar0 <- function() {
  winch_call(baz0)
}

baz0 <- function() {
  winch_trace_back()
}

foo0()

winch_get_proc_map()
read.delim(text = winch_get_proc_map(), sep = " ", header = FALSE)
