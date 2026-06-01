# Tabla de medias y desviaciones por niveles de un factor

Obtencion de las medidas descriptivas, n, media, desviacion tipica para
de una variable para cada nivel de un factor.

## Usage

``` r
grps(
  x = NULL,
  f = NULL,
  ic = FALSE,
  grf = TRUE,
  alfa = 0.05,
  conf = 0.95,
  decs = 3,
  ...
)
```

## Arguments

- x:

  vector: variable cuantitativa a resumir

- f:

  vector: factor cuyos niveles segmentan a la variable cuantitativa

- ic:

  valor logico: si ic=TRUE, proporciona el intervalo de confianza para
  la media

- grf:

  valor logico: indica si se requiere salida grafica o no

- alfa:

  valor real entre 0 y 1: nivel de error

- conf:

  valor real entre 0 y 1: nivel de confianza

- decs:

  entero: precision decimal

- ...:

  parametros de configuracion de la funcion grpsggp
