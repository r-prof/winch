test_that("winch_stop() works", {
  expect_error(winch_stop("foo"), "foo")

  skip_if_not(l10n_info()$"UTF-8")
  expect_error(winch_stop("\u2026"), enc2native(glob2rx("*\u2026*", trim.head = TRUE)))
})
