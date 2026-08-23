test_that("rlm admite predictores factor", {
  set.seed(3)
  d <- data.frame(
    y = rnorm(60),
    x1 = rnorm(60),
    sexo = factor(rep(c("M", "H"), each = 30))
  )
  out <- capture.output(rlm(y ~ x1 + sexo, data = d, grf = FALSE))
  expect_gt(length(out), 0)
})

test_that("rlm solo numerico sigue funcionando", {
  set.seed(4)
  d <- data.frame(y = rnorm(40), x1 = rnorm(40), x2 = rnorm(40))
  expect_error(capture.output(rlm(y ~ x1 + x2, data = d, grf = FALSE)), NA)
})
