library(winch)

foo <- function() {
  winch_call(bar)
}

bar <- function() {
  list(winch_context(), sys.calls())
}

# Call looks good
bar_call <- foo()
bar_call
