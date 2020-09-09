test_that("winch_stop() works", {
  expect_error(winch_stop("foo"), "foo")
  expect_error(winch_stop("\u2026"), enc2native("\u2026"))
})
