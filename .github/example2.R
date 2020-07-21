foo <- function() {
  rlang::eval_bare(quote(bar()))
}

bar <- function() {
  calls <- sys.calls()
  fun <- lapply(calls, `[[`, 1L)
  is_fun <- vapply(fun, identical, quote(foo), FUN.VALUE = logical(1L))
  limit <- which(is_fun)[[1]]
  sys.calls()[-seq_len(limit - 1)]
}

# Calls look good
calls <- foo()
calls

# Last call also looks good
bar_call <- calls[[length(calls)]]
bar_call

# When we convert to list, the results are surprising
as.list(bar_call)

# The results only look good because of the srcref attribute
attributes(bar_call)
attributes(bar_call) <- NULL
bar_call
