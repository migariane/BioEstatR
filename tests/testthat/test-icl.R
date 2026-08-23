test_that("icl borde sumax=0 es bilateral y coincide con poisson.test", {
  res <- icl(x = 0, eco = FALSE)
  pt <- as.numeric(poisson.test(0, 1)$conf.int)
  expect_equal(as.numeric(res[1:2]), pt, tolerance = 1e-6)
})

test_that("icl interior coincide con poison.test (Garwood)", {
  xx <- c(3, 6, 3, 1, 2, 5)
  res <- icl(xx, eco = FALSE)
  pt <- as.numeric(poisson.test(sum(xx), length(xx))$conf.int)
  expect_equal(as.numeric(res[1:2]), pt, tolerance = 1e-6)
})
