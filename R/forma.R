#' @title Medidas de forma de una distribucion
#' @description Obtencion de los coeficientes de asimetria y de apuntamiento (curtosis) de una
#' variable cuantitativa, junto con su interpretacion y una prueba de normalidad.
#' La asimetria y la curtosis se calculan en su version muestral corregida (insesgada).
#' (Texto intencionadamente sin tildes u otros caracteres especiales.)
#' @param x vector de datos numerico cuya forma se va a describir
#' @param decs valor entero: numero de decimales a mostrar en la salida. Por defecto = 3.
#' @param normal valor logico: si normal=TRUE anade la prueba de Shapiro-Wilk cuando n < 5000
#'   y la de Kolmogorov-Smirnov (Lilliefors) en caso contrario. Por defecto = TRUE.
#' @param eco valor logico: si eco=TRUE la funcion genera un informe, si eco=FALSE devuelve
#'   una lista con los valores calculados. Por defecto = TRUE.
#' @return Si eco=TRUE, un informe con el coeficiente de asimetria, el de curtosis, su
#'   interpretacion cualitativa y la prueba de normalidad. Si eco=FALSE, una lista con los
#'   elementos \code{n}, \code{media}, \code{dt}, \code{asimetria}, \code{error_tipico_asimetria},
#'   \code{curtosis}, \code{error_tipico_curtosis}, \code{z_asimetria}, \code{z_curtosis},
#'   \code{p_normalidad} y \code{test_normalidad}.
#' @details El coeficiente de asimetria (g1) mide la falta de simetria de la distribucion.
#'   Valores proximos a 0 indican simetria; valores positivos indican asimetria hacia la
#'   derecha (cola derecha) y valores negativos asimetria hacia la izquierda.
#'   La curtosis (g2) mide el apuntamiento relativo a la distribucion normal: g2 = 0 es
#'   mesocurtica (equivalente a la normal), g2 > 0 leptocurtica (mas apuntada) y g2 < 0
#'   platicurtica (mas aplanada).
#'   Los errores tipicos permiten valorar la significacion estadistica de ambos coeficientes
#'   mediante un estadistico z que se contrasta con la normal estandar.
#' @seealso grps, freq, grpsggp, descriptiva
#' @references Joanes, D. N., & Gill, C. A. (1998). Comparing measures of sample skewness and
#'   kurtosis. Journal of the Royal Statistical Society: Series D (The Statistician), 47(1), 183-189.
#' @references Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.
#' @importFrom stats sd shapiro.test na.omit
#' @export forma
#' @examples
#' # Distribucion simetrica: asimetria y curtosis proximas a 0
#' set.seed(1)
#' forma(x = rnorm(200, mean = 100, sd = 15))
#'
#' # Distribucion asimetrica hacia la derecha
#' forma(x = c(1, 1, 1, 2, 2, 3, 4, 5, 8, 13, 21, 34, 55, 89, 144))
#'
#' # Uso silencioso para reutilizar los valores
#' res <- forma(x = c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, NA), eco = FALSE)
#' res$asimetria
#' res$curtosis
#'
#' # Los datos del estudio sobre osteoporosis
#' data(osteo)
#' forma(x = osteo$imc, decs = 2)
#'
forma <- function(x = NULL, decs = 3, normal = TRUE, eco = TRUE) {
  if (is.null(x)) stop("No se han indicado datos validos")
  if (!is.numeric(x)) stop("x debe ser una variable numerica")

  xv <- x[!is.na(x)]
  n <- length(xv)
  if (n < 3) stop("Se necesitan al menos 3 observaciones validas")

  m <- mean(xv)
  s <- sd(xv)
  if (s == 0) stop("La desviacion tipica es 0: la variable es constante")

  # Momentos centrados
  dif <- xv - m
  m2 <- mean(dif^2)
  m3 <- mean(dif^3)
  m4 <- mean(dif^4)

  # Asimetria y curtosis muestrales corregidas (insesgadas)
  # G1 y G2 siguen la definicion de SPSS/Excel, identica a e1071::skewness(type=2)
  # y e1071::kurtosis(type=2). G2 es la curtosis en exceso (0 para la normal).
  # Nota: se usan los momentos centrados m2, m3 y m4 (divisor n), no s.
  g1 <- (sqrt(n * (n - 1)) / (n - 2)) * (m3 / m2^1.5)
  # La curtosis insesgada G2 requiere n >= 4; con n < 4 se devuelve NA
  if (n >= 4) {
    g2 <- ((n * (n + 1)) / ((n - 1) * (n - 2) * (n - 3))) * (sum(dif^4) / s^4) -
      (3 * (n - 1)^2) / ((n - 2) * (n - 3))
  } else {
    g2 <- NA_real_
  }

  # Errores tipicos para el contraste z
  se_g1 <- sqrt((6 * n * (n - 1)) / ((n - 2) * (n + 1) * (n + 3)))
  se_g2 <- if (n >= 4) {
    sqrt((24 * n * (n - 1)^2) / ((n - 3) * (n - 2) * (n + 3) * (n + 5)))
  } else {
    NA_real_
  }
  z_g1 <- if (!is.na(se_g1) && se_g1 > 0) g1 / se_g1 else NA_real_
  z_g2 <- if (!is.na(se_g2) && se_g2 > 0) g2 / se_g2 else NA_real_

  # Prueba de normalidad
  p_norm <- NA_real_
  test_norm <- NA_character_
  if (normal) {
    if (n <= 5000) {
      sw <- try(shapiro.test(xv), silent = TRUE)
      if (!inherits(sw, "try-error")) {
        p_norm <- sw$p.value
        test_norm <- "Shapiro-Wilk"
      }
    } else {
      ks <- try(stats::ks.test(xv, "pnorm", mean = m, sd = s), silent = TRUE)
      if (!inherits(ks, "try-error")) {
        p_norm <- ks$p.value
        test_norm <- "Kolmogorov-Smirnov"
      }
    }
  }

  # Interpretacion cualitativa
  lim <- 0.5
  asim_txt <- if (abs(g1) < lim) {
    "simetrica"
  } else if (g1 > 0) {
    "asimetria positiva (cola derecha)"
  } else {
    "asimetria negativa (cola izquierda)"
  }
  curt_txt <- if (is.na(g2)) {
    "no calculable (n < 4)"
  } else if (abs(g2) < 0.5) {
    "mesocurtica (como la normal)"
  } else if (g2 > 0) {
    "leptocurtica (mas apuntada que la normal)"
  } else {
    "platicurtica (mas aplanada que la normal)"
  }

  if (!eco) {
    return(invisible(list(
      n = n, media = m, dt = s,
      asimetria = g1, error_tipico_asimetria = se_g1, z_asimetria = z_g1,
      curtosis = g2, error_tipico_curtosis = se_g2, z_curtosis = z_g2,
      p_normalidad = p_norm, test_normalidad = test_norm
    )))
  }

  cat("\n# Medidas de forma ---\n\n")
  cat("  n = ", n, "   media = ", roundf(m, decs), "   dt = ", roundf(s, decs), "\n\n",
    sep = ""
  )
  cat("  Asimetria (g1) = ", roundf(g1, decs),
    "   (error tipico = ", roundf(se_g1, decs), ")\n", sep = ""
  )
  cat("    Interpretacion: ", asim_txt, "\n", sep = "")
  if (!is.na(z_g1)) {
    pz1 <- 2 * (1 - pnorm(abs(z_g1)))
    cat("    z = ", roundf(z_g1, decs), "  p = ", roundf(pz1, decs + 1),
      if (pz1 < 0.05) "  (asimetria significativa)" else "  (asimetria no significativa)",
      "\n", sep = ""
    )
  }
  cat("\n  Curtosis (g2) = ", roundf(g2, decs),
    "   (error tipico = ", roundf(se_g2, decs), ")\n", sep = ""
  )
  cat("    Interpretacion: ", curt_txt, "\n", sep = "")
  if (!is.na(z_g2)) {
    pz2 <- 2 * (1 - pnorm(abs(z_g2)))
    cat("    z = ", roundf(z_g2, decs), "  p = ", roundf(pz2, decs + 1),
      if (pz2 < 0.05) "  (curtosis significativa)" else "  (curtosis no significativa)",
      "\n", sep = ""
    )
  }
  if (normal && !is.na(p_norm)) {
    cat("\n  Prueba de normalidad (", test_norm, "): p = ", roundf(p_norm, decs + 1),
      if (p_norm < 0.05) "  -> se rechaza la normalidad" else "  -> no se rechaza la normalidad",
      "\n", sep = ""
    )
  }
  cat("\n")

  invisible(list(
    n = n, media = m, dt = s,
    asimetria = g1, curtosis = g2, p_normalidad = p_norm
  ))
}
