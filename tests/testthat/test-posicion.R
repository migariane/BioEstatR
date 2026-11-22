test_that("posicion coincide con quantile e IQR de stats", {
  x <- c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, 11, 13, 14, 45, 60)
  r <- posicion(x = x, eco = FALSE)
  expect_equal(as.numeric(r$cuantiles), as.numeric(quantile(x, c(0, .25, .5, .75, 1))))
  expect_equal(r$ric, IQR(x))
})

test_that("posicion detecta los mismos atipicos que boxplot.stats", {
  x <- c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, 11, 13, 14, 45, 60)
  r <- posicion(x = x, eco = FALSE)
  expect_equal(sort(as.numeric(r$atipicos_leves)), sort(as.numeric(boxplot.stats(x)$out)))
})

test_that("posicion distingue atipicos leves y graves", {
  x <- c(rep(50, 20), 70, 200)
  r <- posicion(x = x, eco = FALSE)
  expect_true(70 %in% r$atipicos_leves)
  expect_true(200 %in% r$atipicos_graves)
  expect_true(all(r$atipicos_graves %in% r$atipicos_leves))
})

test_that("posicion acepta cuantiles arbitrarios", {
  x <- 1:100
  r <- posicion(x = x, probs = seq(0, 1, by = 0.1), eco = FALSE)
  expect_length(r$cuantiles, 11)
})

test_that("posicion ignora valores faltantes", {
  x <- c(1:10, NA, NA)
  r <- posicion(x = x, eco = FALSE)
  expect_equal(r$n, 10)
  expect_equal(as.numeric(r$cuantiles[3]), median(1:10))
})

test_that("posicion valida sus argumentos", {
  expect_error(posicion(x = c(1, 2)))
  expect_error(posicion(x = 1:10, probs = c(-0.1, 0.5)))
  expect_error(posicion(x = NULL))
})
