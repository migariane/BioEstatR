test_that("icpexact coincide con binom.test (interior y bordes)", {
  for (caso in list(c(8, 10), c(15, 20), c(25, 210), c(0, 10), c(10, 10))) {
    ci <- BioEstatR:::icpexact(x = caso[1], n = caso[2])
    bt <- as.numeric(binom.test(caso[1], caso[2])$conf.int)
    expect_equal(unlist(ci), bt, tolerance = 5e-4,
                 info = sprintf("x=%d, n=%d", caso[1], caso[2]))
  }
})

test_that("icpwilson coincide con prop.test (Wilson con cpc)", {
  expect_equal(unlist(BioEstatR:::icpwilson(25, 210)),
               as.numeric(prop.test(25, 210)$conf.int),
               tolerance = 1e-6)
})

test_that("icpwaldajustado es Agresti-Coull plus-four", {
  x <- 25; n <- 210
  z <- qnorm(0.975)
  p <- (x + 2) / (n + 4)
  se <- sqrt(p * (1 - p) / (n + 4))
  expect_equal(unlist(BioEstatR:::icpwaldajustado(x, n)),
               c(p - z * se, p + z * se),
               tolerance = 1e-9)
})
