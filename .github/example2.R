foo <- function() {
  rlang::eval_bare(quote(bar()))
}

bar <- function() {
  sys.call(0)
}

# Call looks good
bar_call <- foo()
bar_call

# When we convert to list, the results are surprising
as.list(bar_call)

# The results only look good because of the srcref attribute
attributes(bar_call)
attributes(bar_call) <- NULL
bar_call
