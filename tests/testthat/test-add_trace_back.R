test_that("traceback unchanged if no native code", {
  skip_if_not(winch_available())

  trace <- rlang::trace_back()
  expect_identical(unclass(winch_add_trace_back(trace)), unclass(trace))
})

test_that("traceback changed if native code", {
  skip_if_not(winch_available())

  foo <- function(fun) {
    winch_call(fun)
  }

  bar <- function() {
    rlang::trace_back()
  }

  baz <- function() {
    winch_add_trace_back(rlang::trace_back())
  }

  foo_bar <- foo(bar)
  foo_baz <- foo(baz)

  expect_false(identical(foo_bar, foo_baz))
  expect_true(any(grepl("/winch", foo_baz$calls)))
})
