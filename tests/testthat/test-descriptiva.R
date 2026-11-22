test_that("descriptiva clasifica variables cuantitativas y cualitativas", {
  set.seed(1)
  df <- data.frame(
    edad = rnorm(40, 45, 12),
    sexo = factor(sample(c("hombre", "mujer"), 40, replace = TRUE)),
    imc = rnorm(40, 25, 4)
  )
  r <- descriptiva(x = df, eco = FALSE)
  expect_setequal(names(r$cuantitativas), c("edad", "imc"))
  expect_setequal(names(r$cualitativas), "sexo")
})

test_that("descriptiva reproduce media, dt y cuantiles de R base", {
  x <- c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, 11, 13, 14)
  r <- descriptiva(x = x, eco = FALSE)$cuantitativas[[1]]
  expect_equal(r$media, mean(x))
  expect_equal(r$dt, sd(x))
  expect_equal(r$mediana, median(x))
  expect_equal(r$q1, as.numeric(quantile(x, .25)))
  expect_equal(r$q3, as.numeric(quantile(x, .75)))
  expect_equal(r$min, min(x))
  expect_equal(r$max, max(x))
})

test_that("descriptiva calcula el intervalo de confianza como t.test", {
  set.seed(7)
  x <- rnorm(60, 50, 8)
  r <- descriptiva(x = x, ic = TRUE, eco = FALSE)$cuantitativas[[1]]
  tt <- t.test(x, conf.level = 0.95)
  expect_equal(c(r$ic_inf, r$ic_sup), as.numeric(tt$conf.int), tolerance = 1e-9)
})

test_that("descriptiva cuenta los valores faltantes", {
  x <- c(1:20, NA, NA, NA)
  r <- descriptiva(x = x, eco = FALSE)$cuantitativas[[1]]
  expect_equal(r$n, 20)
  expect_equal(r$n_faltante, 3)
})

test_that("descriptiva segmenta por factor de agrupacion", {
  df <- data.frame(v = c(1, 2, 3, 10, 11, 12), g = factor(rep(c("a", "b"), each = 3)))
  r <- descriptiva(x = df$v, f = df$g, eco = FALSE)$cuantitativas[[1]]
  expect_equal(nrow(r$por_grupos), 2)
  expect_equal(r$por_grupos$media[r$por_grupos$nivel == "a"], 2)
  expect_equal(r$por_grupos$media[r$por_grupos$nivel == "b"], 11)
})

test_that("descriptiva trata los codigos binarios como cualitativos", {
  r <- descriptiva(x = c(0, 1, 1, 0, 1, 1, 0), eco = FALSE)
  expect_length(r$cualitativas, 1)
  expect_length(r$cuantitativas, 0)
})

test_that("descriptiva no degrada a cualitativa una variable discreta con varios valores", {
  x <- c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, 11, 13)
  r <- descriptiva(x = x, eco = FALSE)
  expect_length(r$cuantitativas, 1)
  expect_length(r$cualitativas, 0)
})

test_that("descriptiva se ejecuta sin errores con casos limite", {
  expect_silent(descriptiva(x = c(5, 5, 5, 5), eco = FALSE))
  expect_silent(descriptiva(x = c(NA, NA, NA), eco = FALSE))
  expect_silent(descriptiva(x = c(3), eco = FALSE))
})

test_that("descriptiva devuelve las medidas de forma", {
  set.seed(11)
  x <- rnorm(100, 30, 5)
  r <- descriptiva(x = x, eco = FALSE)$cuantitativas[[1]]
  expect_false(is.null(r$asimetria))
  expect_false(is.null(r$curtosis))
  expect_equal(r$asimetria, forma(x = x, eco = FALSE)$asimetria, tolerance = 1e-10)
})

test_that("descriptiva anade la prueba de normalidad cuando se pide", {
  set.seed(3)
  x <- rnorm(80)
  r <- descriptiva(x = x, normal = TRUE, eco = FALSE)$cuantitativas[[1]]
  expect_equal(r$test_normalidad, "Shapiro-Wilk")
  expect_true(r$p_normalidad >= 0 && r$p_normalidad <= 1)
})

test_that("descriptiva valida la entrada", {
  expect_error(descriptiva(x = NULL))
  df <- data.frame(a = 1:5)
  expect_error(descriptiva(x = df, f = c("a", "b")))
})
