#' @title Analisis descriptivo completo de una o varias variables
#' @description Rutina global de estadistica descriptiva. Para cada variable de un vector o de
#' un data.frame devuelve, segun su naturaleza: el tamano muestral valido y el numero de valores
#' faltantes, las medidas de tendencia central y de dispersion, los cuantiles, el coeficiente de
#' variacion, las medidas de forma y la deteccion de valores atipicos. En las variables
#' cualitativas devuelve la tabla de frecuencias absolutas y relativas.
#' (Texto intencionadamente sin tildes u otros caracteres especiales.)
#' @param x vector o data.frame a describir
#' @param f vector opcional: factor de agrupacion. Si se indica, la descriptiva de cada variable
#'   cuantitativa se segmenta por sus niveles. Por defecto = NULL.
#' @param decs valor entero: numero de decimales a mostrar en la salida. Por defecto = 3.
#' @param ic valor logico: si ic=TRUE anade el intervalo de confianza para la media de las
#'   variables cuantitativas. Por defecto = FALSE.
#' @param conf valor real entre 0 y 1: nivel de confianza para los intervalos. Por defecto = 0.95.
#' @param normal valor logico: si normal=TRUE anade la prueba de normalidad de las variables
#'   cuantitativas. Por defecto = FALSE.
#' @param maxcat valor entero: umbral de codificacion. Una variable numerica entera con tres
#'   valores distintos como maximo y cuyo valor maximo no supera maxcat se trata como
#'   cualitativa (por ejemplo una escala 0/1/2). Por defecto = 10.
#' @param eco valor logico: si eco=TRUE la funcion imprime el informe, si eco=FALSE devuelve
#'   una lista con los resultados sin imprimirlos. Por defecto = TRUE.
#' @return Si eco=TRUE, imprime el informe y devuelve de forma invisible una lista con dos
#'   elementos: \code{cuantitativas} (lista por variable con medidas de centralizacion,
#'   dispersion, posicion, forma y atipicos) y \code{cualitativas} (lista por variable con la
#'   tabla de frecuencias). Si eco=FALSE devuelve esa misma lista sin imprimir nada.
#' @details Se trata de una rutina de resumen pensada como primer paso de cualquier analisis.
#'   Detecta automaticamente el tipo de cada variable: las de tipo \code{factor} o
#'   \code{character}, y las numericas con \code{maxcat} valores distintos o menos, se tratan
#'   como cualitativas; el resto como cuantitativas.
#'   Las medidas de forma se calculan con \code{\link{forma}} y las de posicion y los valores
#'   atipicos con \code{\link{posicion}}, de modo que los resultados son coherentes con esas
#'   funciones cuando se aplican por separado.
#' @seealso grps, freq, forma, posicion, grpsggp
#' @references Tukey, J. W. (1977). Exploratory Data Analysis. Addison-Wesley.
#' @references Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.
#' @importFrom stats sd median quantile IQR na.omit shapiro.test
#' @export descriptiva
#' @examples
#' # Descriptiva de un vector cuantitativo
#' descriptiva(x = c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, 11, 13, NA))
#'
#' # Descriptiva de un data.frame con variables cuantitativas y cualitativas
#' set.seed(1)
#' df <- data.frame(
#'   edad = c(rnorm(40, 45, 12), NA, NA),
#'   sexo = factor(sample(c("hombre", "mujer"), 42, replace = TRUE)),
#'   imc = rnorm(42, 25, 4)
#' )
#' descriptiva(x = df)
#'
#' # Anadiendo intervalos de confianza y prueba de normalidad
#' descriptiva(x = df$imc, ic = TRUE, normal = TRUE, decs = 2)
#'
#' # Descriptiva segmentada por un factor de agrupacion
#' descriptiva(x = df$imc, f = df$sexo)
#'
#' # Recuperar los resultados sin imprimir el informe
#' res <- descriptiva(x = df, eco = FALSE)
#' names(res)
#' res$cuantitativas$imc$media
#' res$cualitativas$sexo
#'
#' # El conjunto de datos sobre osteoporosis
#' data(osteo)
#' descriptiva(x = osteo[, c("edad", "imc", "hba1c", "sexo")], decs = 2)
#'
descriptiva <- function(x = NULL, f = NULL, decs = 3, ic = FALSE, conf = 0.95,
                        normal = FALSE, maxcat = 10, eco = TRUE) {
  if (is.null(x)) stop("No se han indicado datos validos")

  # --- Normalizacion de la entrada -------------------------------------
  if (is.data.frame(x)) {
    df <- x
  } else if (is.atomic(x) || is.factor(x)) {
    df <- data.frame(x)
    # Nombre de columna: el del vector si lo tiene; si no, el de la expresion
    # que se paso a la funcion (evita nombres largos del tipo c(1, 2, 3)).
    nm <- names(x)
    if (is.null(nm)) {
      nm <- deparse(substitute(x))
      if (length(nm) > 1 || nchar(nm) > 40) nm <- "x"
    }
    names(df) <- nm[1]
  } else {
    stop("x debe ser un vector o un data.frame")
  }

  if (nrow(df) == 0) stop("El objeto de entrada no contiene observaciones")

  agrupado <- !is.null(f)
  if (agrupado) {
    if (length(f) != nrow(df)) {
      stop("El factor de agrupacion f debe tener la misma longitud que las observaciones")
    }
    f <- as.factor(f)
  }

  cuanti <- list()
  cuali <- list()

  for (v in names(df)) {
    col <- df[[v]]
    es_cuali <- is.factor(col) || is.character(col) || is.logical(col)

    if (!es_cuali && is.numeric(col)) {
      xv0 <- col[!is.na(col)]
      n_dist <- length(unique(xv0))
      todos_enteros <- length(xv0) > 0 && all(xv0 == round(xv0))
      # Una variable numerica solo se trata como cualitativa cuando es binaria
      # codificada (0/1, 1/2) o cuando tiene muy pocos valores distintos y todos
      # son enteros. En cualquier otro caso se trata como cuantitativa, de modo
      # que una variable discreta con varios valores recibe la descriptiva completa.
      if (n_dist == 0) {
        es_cuali <- TRUE # sin datos: se informa como tabla vacia
      } else if (n_dist <= 2 && todos_enteros) {
        es_cuali <- TRUE
      } else if (n_dist <= 3 && todos_enteros && max(xv0) <= maxcat) {
        es_cuali <- TRUE
      }
    }

    if (es_cuali) {
      colf <- as.factor(col)
      tab <- table(colf, useNA = "no")
      prop <- prop.table(tab)
      acum <- cumsum(prop)
      cuali[[v]] <- list(
        n = sum(!is.na(col)),
        n_faltante = sum(is.na(col)),
        n_categorias = nlevels(colf),
        tabla = data.frame(
          categoria = names(tab),
          n = as.integer(tab),
          porcentaje = round(as.numeric(prop) * 100, decs),
          porcentaje_acumulado = round(as.numeric(acum) * 100, decs),
          row.names = NULL,
          stringsAsFactors = FALSE
        ),
        moda = if (length(tab) > 0) names(tab)[which.max(tab)] else NA_character_
      )
    } else if (is.numeric(col)) {
      xv <- col[!is.na(col)]
      n <- length(xv)
      if (n < 3) {
        cuanti[[v]] <- list(n = n, n_faltante = sum(is.na(col)), aviso = "n insuficiente")
        next
      }
      m <- mean(xv)
      s <- sd(xv)
      cu <- quantile(xv, c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE)
      q1 <- as.numeric(cu[2])
      q3 <- as.numeric(cu[4])
      ric <- q3 - q1
      cv <- if (m != 0) s / abs(m) else NA_real_

      n_out <- sum(xv < q1 - 1.5 * ric | xv > q3 + 1.5 * ric)

      res_v <- list(
        n = n,
        n_faltante = sum(is.na(col)),
        media = m,
        dt = s,
        error_tipico = s / sqrt(n),
        mediana = as.numeric(cu[3]),
        min = as.numeric(cu[1]),
        max = as.numeric(cu[5]),
        q1 = q1,
        q3 = q3,
        ric = ric,
        cv = cv,
        n_atipicos = n_out
      )

      if (!is.na(cv)) {
        res_v$cv_pct <- round(cv * 100, decs)
      }

      if (ic) {
        alfa <- 1 - conf
        tcrit <- qt(1 - alfa / 2, df = n - 1)
        ee <- s / sqrt(n)
        res_v$ic_inf <- m - tcrit * ee
        res_v$ic_sup <- m + tcrit * ee
        res_v$conf <- conf
      }

      # forma
      fo <- try(forma(x = xv, decs = decs, normal = FALSE, eco = FALSE), silent = TRUE)
      if (!inherits(fo, "try-error")) {
        res_v$asimetria <- fo$asimetria
        res_v$curtosis <- fo$curtosis
      }

      if (normal) {
        if (n <= 5000) {
          sw <- try(shapiro.test(xv), silent = TRUE)
          if (!inherits(sw, "try-error")) {
            res_v$p_normalidad <- sw$p.value
            res_v$test_normalidad <- "Shapiro-Wilk"
          }
        } else {
          ks <- try(stats::ks.test(xv, "pnorm", mean = m, sd = s), silent = TRUE)
          if (!inherits(ks, "try-error")) {
            res_v$p_normalidad <- ks$p.value
            res_v$test_normalidad <- "Kolmogorov-Smirnov"
          }
        }
      }

      if (agrupado) {
        grp_res <- lapply(levels(f), function(lv) {
          sel <- f == lv & !is.na(f)
          xg <- col[sel]
          xg <- xg[!is.na(xg)]
          if (length(xg) < 2) {
            return(data.frame(nivel = lv, n = length(xg), media = NA, dt = NA))
          }
          data.frame(
            nivel = lv, n = length(xg),
            media = mean(xg), dt = sd(xg),
            mediana = median(xg)
          )
        })
        res_v$por_grupos <- do.call(rbind, grp_res)
      }

      cuanti[[v]] <- res_v
    }
  }

  resultado <- list(cuantitativas = cuanti, cualitativas = cuali)

  if (!eco) {
    return(invisible(resultado))
  }

  # --- Informe ----------------------------------------------------------
  cat("\n# Analisis descriptivo ---\n")
  cat("  Observaciones: ", nrow(df), "\n", sep = "")
  if (agrupado) {
    cat("  Agrupacion: ", paste(levels(f), collapse = ", "), "\n", sep = "")
  }

  if (length(cuanti) > 0) {
    cat("\n## Variables cuantitativas ---\n\n")
    for (v in names(cuanti)) {
      r <- cuanti[[v]]
      cat("### ", v, " ---\n", sep = "")
      if (!is.null(r$aviso)) {
        cat("  ", r$aviso, " (n = ", r$n, ")\n\n", sep = "")
        next
      }
      cat("  n = ", r$n, "   faltantes = ", r$n_faltante, "\n", sep = "")
      cat("  media = ", roundf(r$media, decs), "   dt = ", roundf(r$dt, decs),
        "   ee = ", roundf(r$error_tipico, decs), "\n",
        sep = ""
      )
      if (!is.null(r$cv_pct)) {
        cat("  CV = ", roundf(r$cv_pct, decs), "%\n", sep = "")
      }
      if (!is.null(r$ic_inf)) {
        cat("  IC ", roundf(r$conf * 100, 0), "% = (", roundf(r$ic_inf, decs), ", ",
          roundf(r$ic_sup, decs), ")\n",
          sep = ""
        )
      }
      cat("  mediana = ", roundf(r$mediana, decs), "   Q1 = ", roundf(r$q1, decs),
        "   Q3 = ", roundf(r$q3, decs), "\n",
        sep = ""
      )
      cat("  min = ", roundf(r$min, decs), "   max = ", roundf(r$max, decs),
        "   RIC = ", roundf(r$ric, decs), "\n",
        sep = ""
      )
      if (!is.null(r$asimetria)) {
        cat("  asimetria = ", roundf(r$asimetria, decs), "   curtosis = ",
          roundf(r$curtosis, decs), "\n",
          sep = ""
        )
      }
      cat("  valores atipicos (Tukey 1.5 x RIC) = ", r$n_atipicos, "\n", sep = "")
      if (!is.null(r$p_normalidad)) {
        cat("  normalidad (", r$test_normalidad, ") p = ",
          roundf(r$p_normalidad, decs + 1), "\n",
          sep = ""
        )
      }
      if (!is.null(r$por_grupos)) {
        cat("  por grupos:\n")
        pg <- r$por_grupos
        for (i in seq_len(nrow(pg))) {
          cat("    ", pg$nivel[i], ": n = ", pg$n[i],
            ", media = ", roundf(pg$media[i], decs),
            ", dt = ", roundf(pg$dt[i], decs), "\n",
            sep = ""
          )
        }
      }
      cat("\n")
    }
  }

  if (length(cuali) > 0) {
    cat("## Variables cualitativas ---\n\n")
    for (v in names(cuali)) {
      r <- cuali[[v]]
      cat("### ", v, " ---\n", sep = "")
      cat("  n = ", r$n, "   faltantes = ", r$n_faltante,
        "   categorias = ", r$n_categorias,
        "   moda = ", ifelse(is.na(r$moda), "(sin datos)", r$moda), "\n",
        sep = ""
      )
      tb <- r$tabla
      if (nrow(tb) == 0) {
        cat("    (sin observaciones validas)\n")
      } else {
        for (i in seq_len(nrow(tb))) {
          cat("    ", tb$categoria[i], ": n = ", tb$n[i], " (",
            roundf(tb$porcentaje[i], decs), "%)\n",
            sep = ""
          )
        }
      }
      cat("\n")
    }
  }

  invisible(resultado)
}
