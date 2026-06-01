# Estimacion de la media de una variable aleatoria con distribucion normal

Permite obtener el intervalo de confianza a partir de una variable o
bien de las medidas resumidas. Texto intencionadamente sin tildes u
otros caracteres especiales por la incompatibilidad de los mapas de
caracteres.

## Usage

``` r
icm(
  x = 0,
  n = 0,
  m = 0,
  s = 0,
  conf = 0.95,
  alfa = 0.05,
  decs = 3,
  d = 0,
  vac = TRUE,
  eco = TRUE
)
```

## Arguments

- x:

  vector de datos cuya media se va a estimar

- n:

  valor entero: tamano muestral cuando se indican los datos resumidos

- m:

  valor real: media de la variable (previamente calculada)

- s:

  valor real: desviacion tipica de la variable (previamente calculada)

- conf:

  valor \< 1: nivel de confianza (parametro alternativo al error alfa,
  en tanto por uno). Por defecto =.95.

- alfa:

  valor \< 1: error alfa (parametro alternativo al nivel de confianza,
  en tanto por uno). Por defecto =.05.

- decs:

  valor entero: precision decimal para la salida de resultados. Por
  defecto = 4.

- d:

  valor real \< 1: precision deseada para el intervalo de confianza. Si
  d\>0 se invoca a la funcion nm() para estimar el tamano de muestra

- vac:

  valor logico: TRUE=se trata de una variable aleatoria continua; FALSE=
  la variable es discreta y se aplica cpc. Por defecto = TRUE.

- eco:

  valor logico: si eco=TRUE la funcion genera un informe (no devuelve
  valores), si eco=FALSE devuelve los limites del IC y su precision

## Value

Informe (si eco=T) con el intervalo de confianza para estimar la media
poblacional de una variable aleatoria normal. Limites inferior y
superior del IC y su precision.

## References

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## Examples

``` r
icm(x=c(25.4, 14.6, 23.1, 26.0, 14.4, 24.3, 36.1, 21.0, NA, 41.9))
#> 
#> Intervalo de confianza bilateral para la media de una VA normal 
#> ----------------------------------------------------------------
#> Información muestral: 
#>   Declarados  10 casos. Hay 1 valor faltante 
#>   Tamaño muestral: n =  9 
#>   Media: m =  25.200 
#>   Desviación típica: s =  9.016 
#>   Error estándar de la media: sem =  3.005 
#> 
#> Estimación: 
#>  95%-IC(µ):  (18.27, 32.13)
#>   Precisión obtenida: 6.93 
#> 
icm(x=c(25,14,23,26,14,24,36,21,NA,41), vac=FALSE)
#> 
#> Intervalo de confianza bilateral para la media de una VA normal 
#> ----------------------------------------------------------------
#> Información muestral: 
#>   Declarados  10 casos. Hay 1 valor faltante 
#>   Tamaño muestral: n =  9 
#>   Media: m =  24.889 
#>   Desviación típica: s =  8.950 
#>   Error estándar de la media: sem =  2.983 
#> 
#> Estimación: 
#>   Se aplica cpc = ±1/(2n) = 0.056 para variable discreta 
#>  95%-IC(µ):  (17.953, 31.824)
#>   Precisión obtenida: 6.936 
#> 
icm(n=100, m=25.3, s=4.1)
#> 
#> Intervalo de confianza bilateral para la media de una VA normal 
#> ----------------------------------------------------------------
#> Información muestral: 
#>   Tamaño muestral: n =  100 
#>   Media: m =  25.300 
#>   Desviación típica: s =  4.100 
#>   Error estándar de la media: sem =  0.410 
#> 
#> Estimación: 
#>  95%-IC(µ):  (24.486, 26.114)
#>   Precisión obtenida: 0.814 
#> 
icm(n=100, m=25.3, s=4.1, conf=0.99)
#> 
#> Intervalo de confianza bilateral para la media de una VA normal 
#> ----------------------------------------------------------------
#> Información muestral: 
#>   Tamaño muestral: n =  100 
#>   Media: m =  25.300 
#>   Desviación típica: s =  4.100 
#>   Error estándar de la media: sem =  0.410 
#> 
#> Estimación: 
#>  99%-IC(µ):  (24.223, 26.377)
#>   Precisión obtenida: 1.077 
#> 
icm(n=100, m=25.3, s=4.1, alfa=0.01)
#> 
#> Intervalo de confianza bilateral para la media de una VA normal 
#> ----------------------------------------------------------------
#> Información muestral: 
#>   Tamaño muestral: n =  100 
#>   Media: m =  25.300 
#>   Desviación típica: s =  4.100 
#>   Error estándar de la media: sem =  0.410 
#> 
#> Estimación: 
#>  99%-IC(µ):  (24.223, 26.377)
#>   Precisión obtenida: 1.077 
#> 

icm(n=100, m=25.3, s=4.1, alfa=.01, eco=FALSE)->IC
IC
#> [[1]]
#> [1] 24.22317
#> 
#> [[2]]
#> [1] 26.37683
#> 
#> [[3]]
#> [1] 1.076826
#> 
```
