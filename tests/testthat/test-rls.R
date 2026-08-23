test_that("rls admite NAs y reproduce lm() sobre parejas completas", {
  set.seed(1)
  xv <- rnorm(40)
  yv <- 2 + 3 * xv + rnorm(40)
  yv[c(3, 17)] <- NA
  out <- capture.output(tab <- rls(yv ~ xv, grf = FALSE, dfout = TRUE))
  ok <- !is.na(yv)
  mod <- lm(yv ~ xv, subset = ok)
  expect_equal(nrow(tab), sum(ok))
  expect_true(all(complete.cases(tab[, 1:2])))
})

test_that("rls sin NAs sigue funcionando", {
  set.seed(2)
  pre <- rnorm(30, 100, 15)
  post <- 5 + 0.8 * pre + rnorm(30, sd = 4)
  expect_error(capture.output(rls(post ~ pre, grf = FALSE)), NA)
})
