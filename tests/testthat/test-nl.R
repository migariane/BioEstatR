test_that("nl modo silencioso devuelve valores basados en lmax", {
  lmax <- 4.5; d <- 1
  z <- qnorm(0.975)
  n0 <- lmax * (z / d)^2
  nc <- (n0 / 4) * (1 + sqrt(1 + 2 / (d * n0)))^2
  res <- nl(lmax = lmax, d = d, eco = FALSE)
  expect_equal(unlist(res), c(trunc(n0 + 1), trunc(nc + 1)))
})

test_that("nl modo silencioso con muestra piloto", {
  res <- nl(x = 25, n = 210, d = 2, eco = FALSE)
  expect_true(is.finite(res[[1]]) && is.finite(res[[2]]))
  expect_true(res[[2]] >= res[[1]])
})
