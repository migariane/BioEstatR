#' @title Tabla de medias y desviaciones por niveles de un factor
#' @description Obtencion de las medidas descriptivas, n, media, desviacion tipica para de una variable para cada nivel de un factor.
#' @param x vector: variable cuantitativa a resumir
#' @param f vector: factor cuyos niveles segmentan a la variable cuantitativa
#' @param ic valor logico: si ic=TRUE, proporciona el intervalo de confianza para la media
#' @param grf valor logico: indica si se requiere salida grafica o no
#' @param alfa valor real entre 0 y 1: nivel de error
#' @param conf valor real entre 0 y 1: nivel de confianza
#' @param decs entero: precision decimal
#' @param ... parametros de configuracion de la funcion grpsggp
#' @export grps
#' @examples
#' nivel <- c(1.1,2.1,2.2,3.2,0.1,.2,1.0,0.4,0.7,1.3,1.5,3.1,2.4,3.6,1.1,2.4,
#'            3.2,2.6,1.5,6.1,2.1,1.9,1,2.1,1.3,4.1,1.2)
#' grupo <- c("A","A","A","A","A","A","A","B","B","B","B","B","B","C","C","C",
#'            "C","C","C","C","C","C","D","D","D","D","D")
#' grps(x=nivel)
#' grps(x=nivel, f=grupo)
#' \donttest{
#' grps(x=nivel, f=grupo, ic=TRUE)
#' grps(x=nivel, hnmin=10)
#' }
grps <- function(x=NULL, f=NULL, ic=FALSE, grf=TRUE, alfa=0.05, conf=0.95, decs=3, ...) {
  if(is.null(x)) stop("No se han indicado datos validos")
  
  nx <- length(x)
  validx <- x[!is.na(x)]
  haymiss <- (length(validx) < nx)
  
  if (is.null(f)) {
    k <- 1
    f <- factor(rep(1, nx))
    dataf <- na.exclude(data.frame(f, x))
    t <- data.frame(n=length(validx), media=roundf(mean(validx), decs), dt=roundf(sd(validx), decs))
  } else {
    f <- as.factor(f)
    k <- nlevels(f)
    dataf <- na.exclude(data.frame(f, x))
    
    ntotal <- tapply(x, f, length)
    n <- tapply(dataf$x, dataf$f, length)
    m <- roundf(tapply(x, f, mean, na.rm = TRUE), decs)
    s <- roundf(tapply(x, f, sd, na.rm = TRUE), decs)
    
    t <- if(haymiss) data.frame(n_total=ntotal, n_valido=n, n_faltante=ntotal-n, media=m, dt=s) else data.frame(n=n, media=m, dt=s)
  }
  
  if(ic && k > 1) {
    se <- tapply(dataf$x, dataf$f, sd, na.rm = TRUE)
    ic_inf <- ic_sup <- vector(length = length(se))
    for(i in 1:length(se)) {
      group_name <- names(se)[i]
      gsize <- if(haymiss) t[group_name, "n_valido"] else t[group_name, "n"]
      interv <- icm(n=as.numeric(gsize), m=as.numeric(t[group_name, "media"]), s=as.numeric(se[i]), decs=decs, conf=conf, eco=FALSE)
      ic_inf[i] <- round(interv[[1]], decs)
      ic_sup[i] <- round(interv[[2]], decs)
    }
    t <- data.frame(t, ic_inf, ic_sup)
  }
  
  print(t)
  if(grf && k > 1) {
    se_vec <- tapply(dataf$x, dataf$f, sd, na.rm = TRUE)
    grpsggp(x=dataf$x, f=dataf$f, se=se_vec, ...)
  }
  invisible(t)
}
