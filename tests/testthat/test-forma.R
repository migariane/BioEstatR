test_that("forma devuelve la asimetria y curtosis corregidas de e1071", {
  skip_if_not_installed("e1071")
  sets <- list(
    c(1, 1, 1, 2, 2, 3, 4, 5, 8, 13, 21, 34, 55, 89, 144),
    c(2, 4, 4, 4, 5, 5, 7, 9, 12, 14, 17, 20, 21, 23, 25, 28, 31, 33, 35, 40),
    c(10, 12, 11, 13, 12, 14, 13, 15, 12, 11, 10, 16, 14, 13, 12, 11),
    c(1, 2, 3, 4)
  )
  for (x in sets) {
    r <- forma(x = x, eco = FALSE)
    expect_equal(r$asimetria, e1071::skewness(x, type = 2), tolerance = 1e-10)
    expect_equal(r$curtosis, e1071::kurtosis(x, type = 2), tolerance = 1e-10)
  }
})

test_that("forma de una normal es simetrica y mesocurtica", {
  set.seed(123)
  r <- forma(x = rnorm(500), eco = FALSE)
  expect_lt(abs(r$asimetria), 0.2)
  expect_lt(abs(r$curtosis), 0.4)
})

test_that("forma ignora los valores faltantes", {
  x <- c(1, 2, 3, 4, 5, 6, 7, 8, NA, NA)
  r1 <- forma(x = x, eco = FALSE)
  r2 <- forma(x = x[!is.na(x)], eco = FALSE)
  expect_equal(r1$asimetria, r2$asimetria)
  expect_equal(r1$curtosis, r2$curtosis)
})

test_that("forma requiere al menos 3 observaciones y variable numerica", {
  expect_error(forma(x = c(1, 2)))
  expect_error(forma(x = c("a", "b", "c")))
  expect_error(forma(x = NULL))
})

test_that("forma informa curtosis no calculable con n = 3", {
  r <- forma(x = c(1, 2, 10), eco = FALSE)
  expect_true(is.na(r$curtosis))
  expect_false(is.na(r$asimetria))
})

test_that("forma detecta la prueba de normalidad", {
  set.seed(5)
  r <- forma(x = rnorm(100), eco = FALSE)
  expect_equal(r$test_normalidad, "Shapiro-Wilk")
  expect_true(r$p_normalidad >= 0 && r$p_normalidad <= 1)
})
