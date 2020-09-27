test_that("data structure", {
  skip_if_not(winch_available())

  out <- winch_trace_back()
  expect_s3_class(out, "data.frame")
  expect_identical(names(out), c("func", "ip", "pathname"))
})
