#' @title Medidas de posicion y deteccion de valores atipicos
#' @description Obtencion de los cuantiles (cuartiles, deciles o percentiles) de una variable
#' cuantitativa, del rango intercuartilico y de la deteccion de valores atipicos por el criterio
#' de Tukey (vallas de 1.5 y 3 veces el rango intercuartilico).
#' (Texto intencionadamente sin tildes u otros caracteres especiales.)
#' @param x vector de datos numerico cuya posicion se va a describir
#' @param probs vector numerico entre 0 y 1: cuantiles a calcular. Por defecto los cuartiles
#'   (0, 0.25, 0.5, 0.75, 1).
#' @param tipo valor entero entre 1 y 9: tipo de calculo de cuantiles tal como los define
#'   \code{stats::quantile}. Por defecto = 7 (el que usa R por omision).
#' @param decs valor entero: numero de decimales a mostrar en la salida. Por defecto = 3.
#' @param eco valor logico: si eco=TRUE la funcion genera un informe, si eco=FALSE devuelve
#'   una lista con los valores calculados. Por defecto = TRUE.
#' @return Si eco=TRUE, un informe con los cuantiles, el rango intercuartilico, las vallas de
#'   Tukey y el listado de valores atipicos. Si eco=FALSE, una lista con los elementos
#'   \code{n}, \code{cuantiles}, \code{ric}, \code{valla_inf}, \code{valla_sup},
#'   \code{atipicos_leves}, \code{atipicos_graves}, \code{valores_atipicos} y \code{n_atipicos}.
#' @details Se considera valor atipico leve todo valor situado fuera del intervalo
#'   [Q1 - 1.5 * RIC, Q3 + 1.5 * RIC] y valor atipico grave (extremo) el situado fuera de
#'   [Q1 - 3 * RIC, Q3 + 3 * RIC], siendo RIC = Q3 - Q1 el rango intercuartilico.
#' @seealso grps, freq, forma, descriptiva
#' @references Tukey, J. W. (1977). Exploratory Data Analysis. Addison-Wesley.
#' @references Hyndman, R. J., & Fan, Y. (1996). Sample quantiles in statistical packages.
#'   The American Statistician, 50(4), 361-365.
#' @importFrom stats quantile median IQR
#' @export posicion
#' @examples
#' # Cuartiles y deteccion de atipicos en una serie con dos valores extremos
#' datos <- c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, 11, 13, 14, 45, 60)
#' posicion(x = datos)
#'
#' # Deciles en lugar de cuartiles
#' posicion(x = datos, probs = seq(0, 1, by = 0.1))
#'
#' # Recuperar los valores para reutilizarlos
#' res <- posicion(x = datos, eco = FALSE)
#' res$atipicos_graves
#' res$valla_sup
#'
#' # Datos del estudio sobre osteoporosis
#' data(osteo)
#' posicion(x = osteo$imc, decs = 2)
#'
posicion <- function(x = NULL, probs = c(0, 0.25, 0.5, 0.75, 1), tipo = 7,
                     decs = 3, eco = TRUE) {
  if (is.null(x)) stop("No se han indicado datos validos")
  if (!is.numeric(x)) stop("x debe ser una variable numerica")
  if (any(probs < 0 | probs > 1)) stop("Los valores de probs deben estar entre 0 y 1")

  xv <- x[!is.na(x)]
  n <- length(xv)
  if (n < 3) stop("Se necesitan al menos 3 observaciones validas")

  cu <- quantile(xv, probs = probs, type = tipo, na.rm = TRUE)
  q1 <- as.numeric(quantile(xv, 0.25, type = tipo, na.rm = TRUE))
  q3 <- as.numeric(quantile(xv, 0.75, type = tipo, na.rm = TRUE))
  ric <- q3 - q1

  valla_inf <- q1 - 1.5 * ric
  valla_sup <- q3 + 1.5 * ric
  valla_inf_grave <- q1 - 3 * ric
  valla_sup_grave <- q3 + 3 * ric

  atip_leves <- xv[xv < valla_inf | xv > valla_sup]
  atip_graves <- xv[xv < valla_inf_grave | xv > valla_sup_grave]

  if (!eco) {
    return(invisible(list(
      n = n, cuantiles = cu, ric = ric,
      valla_inf = valla_inf, valla_sup = valla_sup,
      atipicos_leves = atip_leves, atipicos_graves = atip_graves,
      valores_atipicos = atip_leves, n_atipicos = length(atip_leves)
    )))
  }

  cat("\n# Medidas de posicion ---\n\n")
  cat("  n = ", n, "\n\n", sep = "")
  cat("  Cuantiles (tipo ", tipo, "):\n", sep = "")
  pnames <- paste0(format(probs * 100, trim = TRUE), "%")
  for (i in seq_along(cu)) {
    cat("    ", pnames[i], " = ", roundf(as.numeric(cu[i]), decs), "\n", sep = "")
  }
  cat("\n  Rango intercuartilico (RIC) = ", roundf(ric, decs), "\n", sep = "")
  cat("  Vallas de Tukey (1.5 x RIC): [", roundf(valla_inf, decs), ", ",
    roundf(valla_sup, decs), "]\n", sep = ""
  )
  cat("  Vallas extremas   (3.0 x RIC): [", roundf(valla_inf_grave, decs), ", ",
    roundf(valla_sup_grave, decs), "]\n", sep = ""
  )

  cat("\n  Valores atipicos leves (n = ", length(atip_leves), ")", sep = "")
  if (length(atip_leves) > 0) {
    cat(": ", paste(roundf(atip_leves, decs), collapse = ", "), sep = "")
  }
  cat("\n  Valores atipicos graves (n = ", length(atip_graves), ")", sep = "")
  if (length(atip_graves) > 0) {
    cat(": ", paste(roundf(atip_graves, decs), collapse = ", "), sep = "")
  }
  cat("\n\n")

  invisible(list(
    n = n, cuantiles = cu, ric = ric,
    valla_inf = valla_inf, valla_sup = valla_sup,
    atipicos_leves = atip_leves, atipicos_graves = atip_graves,
    valores_atipicos = atip_leves, n_atipicos = length(atip_leves)
  ))
}
