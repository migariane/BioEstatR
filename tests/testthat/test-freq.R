context("Test for freq function")

test_that("freq works with basic vector", {
  dat <- c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, 11, 13, 14, 15, NA)
  expect_error(freq(dat), NA)
})

test_that("freq works with categorical vector", {
  cats <- c('a', 'b', 'c', 'b', 'c', 'b', 'c', 'a', 'c', 'c', 'a', 'a', 'a')
  expect_error(freq(cats, acum = FALSE, grf = FALSE), NA)
})
