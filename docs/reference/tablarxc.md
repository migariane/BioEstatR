# Analisis de una tabla de contingencia RxC

Analisis de tablas de contingencia RxC (con R y/o C mayores a 2. No
valido para tablas 2x2). (Texto intencionadamente sin tildes u otros
caracteres especiales por la incompatibilidad de los mapas de
caracteres)

## Usage

``` r
tablarxc(
  frecs = NULL,
  fvar = NULL,
  cvar = NULL,
  o = NULL,
  fnum = 0,
  fcat = NULL,
  ccat = NULL,
  tablas = "",
  decs = 3
)
```

## Arguments

- frecs:

  data.frame: data.frame con frecuencias observadas

- fvar:

  vector de enteros o factores: Variable por filas

- cvar:

  vector de enteros o factores: Variable por columnas

- o:

  vector de enteros: frecuencias de la tabla de contingencia. Requiere
  especificar el numero de filas con fnum

- fnum:

  valor entero: numero de filas cuando se indican las frecuencias a
  traves del parametro o

- fcat:

  vector de cadenas de texto: Nombres de fila

- ccat:

  vector de cadenas de texto: Nombres de columna

- tablas:

  vector de caracter: "E"=frecuencias esperadas, "R","S","X", residuos
  de Pearson, estandarizados y contribucion X2; "F", "C", "T"
  porcentajes por filas, columnas y totales

- decs:

  entero: Numero de decimales en las salidas

## Value

Informe test para analisis de tablas RxC mediante test Chi2

## References

Agresti, A. (2013). Categorical Data Analysis.

## Examples

``` r
# [1] Introduccion de datos como variables
v1<-c(1,1,2,1,2,1,1,1,1,2,1,1,1,1,1,1,1,1,2,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)
v2<-c(1,2,3,3,3,2,1,2,1,3,1,2,3,3,3,1,2,1,3,1,2,1,2,3,2,3,1,2,1,1,3,1,1,3,3,1,2,1,1,2,1,2,2,2)
tablarxc(fvar=v1,cvar=v2)
#> 
#> # Test Chi-cuadrado para tablas RxC
#> # ---------------------------------
#> 
#> # Frecuencias observadas
#>          A  B  C Total
#> A        8  6  4    18
#> B        9  8  9    26
#>   Total 17 14 13    44
#> 
#> # Test chi-cuadrado 
#>   Validez: Frecuencia mínima esperada = 5.32 
#>            0 frecuencias esperadas son menores a 1
#>            0 son menores a 5 (el 0% de la tabla) 
#>   χ²(2 gl) = 0.841, p = 0.657 
#> 
# Obtencion de tablas de frecuencias esperadas y porcentajes por filas
tablarxc(fvar=v1,cvar=v2, tablas=c("E","F"))
#> 
#> # Test Chi-cuadrado para tablas RxC
#> # ---------------------------------
#> 
#> # Frecuencias observadas
#>          A  B  C Total
#> A        8  6  4    18
#> B        9  8  9    26
#>   Total 17 14 13    44
#> 
#> # Frecuencias esperadas
#>             A     B     C Total
#> A        6.95  5.73  5.32 18.00
#> B       10.05  8.27  7.68 26.00
#>   Total 17.00 14.00 13.00 44.00
#> 
#> # Test chi-cuadrado 
#>   Validez: Frecuencia mínima esperada = 5.32 
#>            0 frecuencias esperadas son menores a 1
#>            0 son menores a 5 (el 0% de la tabla) 
#>   χ²(2 gl) = 0.841, p = 0.657 
#> 
#> # Porcentajes por filas
#>             A     B     C Total
#> A       0.444 0.333 0.222 1.000
#> B       0.346 0.308 0.346 1.000
#>   Total 0.386 0.318 0.295 1.000
#> 
# Uso de nombres de categoria
tablarxc(fvar=v1,cvar=v2, tablas=c("E","F"), fcat=c("Trat1","Trat2"),ccat=c("peor","igual","mejor"))
#> 
#> # Test Chi-cuadrado para tablas RxC
#> # ---------------------------------
#> 
#> # Frecuencias observadas
#>           peor   igual   mejor Total
#>   Trat1      8       6       4    18
#>   Trat2      9       8       9    26
#>   Total     17      14      13    44
#> 
#> # Frecuencias esperadas
#>           peor   igual   mejor Total
#>   Trat1   6.95    5.73    5.32 18.00
#>   Trat2  10.05    8.27    7.68 26.00
#>   Total  17.00   14.00   13.00 44.00
#> 
#> # Test chi-cuadrado 
#>   Validez: Frecuencia mínima esperada = 5.32 
#>            0 frecuencias esperadas son menores a 1
#>            0 son menores a 5 (el 0% de la tabla) 
#>   χ²(2 gl) = 0.841, p = 0.657 
#> 
#> # Porcentajes por filas
#>           peor   igual   mejor Total
#>   Trat1  0.444   0.333   0.222 1.000
#>   Trat2  0.346   0.308   0.346 1.000
#>   Total  0.386   0.318   0.295 1.000
#> 

# [2] Introduccion directa de las frecuencias (previamente construir por columnas un dataframe)
peor <-c(8,9,10)
igual<-c(6,8,12)
mejor<-c(4,9,10)
tabla<-data.frame(peor,igual,mejor)
tablarxc(frecs=tabla, tablas=c("E","F","S"), fcat=c("Trat1","Trat2"))
#> 
#> # Test Chi-cuadrado para tablas RxC
#> # ---------------------------------
#> 
#> # Frecuencias observadas
#>           peor   igual   mejor Total
#>   1          8       6       4    18
#>   2          9       8       9    26
#>   3         10      12      10    32
#>   Total     27      26      23    76
#> 
#> # Frecuencias esperadas
#>           peor   igual   mejor Total
#>   1       6.39    6.16    5.45 18.00
#>   2       9.24    8.89    7.87 26.00
#>   3      11.37   10.95    9.68 32.00
#>   Total  27.00   26.00   23.00 76.00
#> 
#> # Test chi-cuadrado 
#>   Validez: Frecuencia mínima esperada = 5.45 
#>            0 frecuencias esperadas son menores a 1
#>            0 son menores a 5 (el 0% de la tabla) 
#>   χ²(4 gl) = 1.327, p = 0.857 
#> 
#> # Residuos estandarizados
#>       peor   igual   mejor
#>   1  0.905  -0.090  -0.850
#>   2 -0.120  -0.456   0.596
#>   3 -0.664   0.516   0.160
#> 
#> # Porcentajes por filas
#>           peor   igual   mejor Total
#>   1      0.444   0.333   0.222 1.000
#>   2      0.346   0.308   0.346 1.000
#>   3      0.312   0.375   0.312 1.000
#>   Total  0.355   0.342   0.303 1.000
#> 

# [3] Introduccion de frecuencias observadas como vector
obs<-c(12,35,13,25,8,10)
tablarxc(o=obs, fnum=2)
#> 
#> # Test Chi-cuadrado para tablas RxC
#> # ---------------------------------
#> 
#> # Frecuencias observadas
#>           C1   C2   C3 Total
#>   F1      12   35   13    60
#>   F2      25    8   10    43
#>   Total   37   43   23   103
#> 
#> # Test chi-cuadrado 
#>   Validez: Frecuencia mínima esperada = 9.6 
#>            0 frecuencias esperadas son menores a 1
#>            0 son menores a 5 (el 0% de la tabla) 
#>   χ²(2 gl) = 19.642, p < 0.001 
#> 


```
