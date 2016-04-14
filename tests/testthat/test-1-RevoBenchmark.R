if(interactive()) library(testthat)
context("RevoBenchmark")

describe("Activates MKL if it exists",{
  test_that("RevoBencmark takes single threads argument",{
    it("tests for correct class", {
      p1 <- RevoBenchmark(threads = 1, scale.factor = 0.05)
      p2 <- RevoBenchmark(threads = 2, scale.factor = 0.05)

      expect_is(p1, c("RevoBenchmark", "matrix"))
      expect_is(p1, c("RevoBenchmark", "matrix"))
      expect_is(plot(p1), "ggplot")
      expect_is(plot(p2), "ggplot")

    })
  })
  test_that("RevoBencmark takes multiple threads arguments",{
    it("tests for correct class", {
      p <- RevoBenchmark(threads = c(1, 2), scale.factor = 0.05)

      expect_is(p, c("RevoBenchmark", "matrix"))
      expect_is(plot(p), "ggplot")

    })
  })
})

