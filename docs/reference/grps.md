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

## Examples

``` r
nivel <- c(1.1,2.1,2.2,3.2,0.1,.2,1.0,0.4,0.7,1.3,1.5,3.1,2.4,3.6,1.1,2.4,
           3.2,2.6,1.5,6.1,2.1,1.9,1,2.1,1.3,4.1,1.2)
grupo <- c("A","A","A","A","A","A","A","B","B","B","B","B","B","C","C","C",
           "C","C","C","C","C","C","D","D","D","D","D")
grps(x=nivel)
#>    n media    dt
#> 1 27 1.981 1.322
grps(x=nivel, f=grupo)
#>   n media    dt
#> A 7 1.414 1.136
#> B 6 1.567 1.023
#> C 9 2.722 1.488
#> D 5 1.940 1.278

# \donttest{
grps(x=nivel, f=grupo, ic=TRUE)
#>   n media    dt ic_inf ic_sup
#> A 7 1.414 1.136  0.363  2.465
#> B 6 1.567 1.023  0.493  2.641
#> C 9 2.722 1.488  1.578  3.866
#> D 5 1.940 1.278  0.353  3.527

grps(x=nivel, hnmin=10)
#>    n media    dt
#> 1 27 1.981 1.322
# }
```
