test_that("la p del chi-cuadrado sin cpc corresponde a su estadistico", {
  o <- c(30, 33, 37, 100)
  adbc <- 30 * 100 - 33 * 37
  pn <- pchisq(200 * adbc^2 / (63 * 137 * 67 * 133), 1, lower.tail = FALSE)
  out <- capture.output(tabla2x2(o = o))
  lin_sin <- grep("sin cpc", out, value = TRUE)
  expect_length(lin_sin, 1)
  expect_match(lin_sin, "p = 0.004", fixed = TRUE)
  expect_false(grepl("p = 0.007", lin_sin))
})

test_that("el chi-cuadrado sin cpc coincide con chisq.test sin correccion", {
  o <- c(20, 26, 60, 294)
  m <- matrix(o, nrow = 2, byrow = TRUE)
  ref <- chisq.test(m, correct = FALSE)$statistic
  out <- capture.output(tabla2x2(o = o))
  lin_sin <- grep("sin cpc", out, value = TRUE)
  expect_match(lin_sin, sub("\\s$", "", format(round(as.numeric(ref), 3))), fixed = TRUE)
})
