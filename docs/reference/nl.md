# Tamano de muestra para estimar el parametro de la distribucion de Poisson

Estimacion del tamano de muestra para estimar el parametro de la
distribucion de Poisson con la precision deseada

## Usage

``` r
nl(
  x = NA,
  n = 0,
  d = 0,
  lmax = 0,
  conf = 0.95,
  alfa = 0.05,
  decs = 3,
  eco = TRUE
)
```

## Arguments

- x:

  valor entero: observacion o vector de observaciones de una v.a. con
  distribucion de Poisson o valor medio observado en una muestra de
  tamano n

- n:

  valor entero: tamano de la muestra piloto cuando x representa su media

- d:

  valor real entero: precision deseada para estimar el parametro de la
  distribucion de Poisson

- lmax:

  valor real: maximo valor del parametro de la Poisson cuando se cuenta
  con esta informacion

- conf:

  valor \< 1: nivel de confianza (alternativo al error alfa, en tanto
  por uno). Por defecto =.95.

- alfa:

  valor \< 1: error alfa (alternativo al nivel de confianza, en tanto
  por uno). Por defecto =.05.

- decs:

  valor entero: precision decimal para la salida de resultados.

- eco:

  valor logico: si eco=TRUE devuelve informe, de lo contrario valores
  estimados de n, sin y con cpc

## Value

Estimacion del tamano de muestra sin y con correccion por continuidad
(cpc)

## References

Garwood, F. (1936). Fiducial Limits for the Poisson Distribution.
Biometrika.

## Examples

``` r
# Introduciendo datos observados
# una observacion (muestra de tamano 1). Precision deseada de 1 unidad
nl(3, d=1)
#> 
#> Tamaño de muestra necesario para estimar el parámetro λ
#> de una VA con distribución de Poisson con precisión δ 
#> ----------------------------------------------------------------------
#> Muestra piloto: 
#>   Muestra de una sola observación  
#>   Tamaño muestral: n =  1 
#>   Media observada: m =  3 
#> 
#>   Estimación considerando la información muestral: 
#>      95 %-max(λ) =  7.754  (método exacto) 
#>      Precisión deseada: δ =  1  
#>      Tamano muestral sin cpc: n ⩾  30 
#>      Tamano muestral con cpc: n ⩾  31 
#> 
# si se dispone del valor maximo del parametro (precision = 1 unidad)
nl(lmax=4.5, d=1)
#> 
#> Tamaño de muestra necesario para estimar el parámetro λ
#> de una VA con distribución de Poisson con precisión δ 
#> ----------------------------------------------------------------------
#> Estimación con el valor máximo propuesto para el parámetro: 
#>   Valor máximo propuesto: λ =  4.5  
#>   Precisión deseada: δ =  1  
#>   Tamano muestral sin cpc: n ⩾  18 
#>   Tamano muestral con cpc: n ⩾  19 
#> 
#> 
# muestra con mas de una observacion
nl(c(3,6,3,1,2,5),d=1)
#> 
#> Tamaño de muestra necesario para estimar el parámetro λ
#> de una VA con distribución de Poisson con precisión δ 
#> ----------------------------------------------------------------------
#> Muestra piloto: 
#>   No hay valores faltantes 
#>   Tamaño muestral: n =  6 
#>   Media observada: m =  3.333 
#> 
#>   Estimación considerando la información muestral: 
#>      95 %-max(λ) =  4.844  (método exacto) 
#>      Precisión deseada: δ =  1  
#>      Tamano muestral sin cpc: n ⩾  19 
#>      Tamano muestral con cpc: n ⩾  20 
#> 
# Introduciendo media x de n datos observados
nl(x=25, n=210, d=2)
#> 
#> Tamaño de muestra necesario para estimar el parámetro λ
#> de una VA con distribución de Poisson con precisión δ 
#> ----------------------------------------------------------------------
#> Muestra piloto: 
#>   Se indica una única observación muestral 210  
#>   Tamaño muestral: n =  210 
#>   Media observada: m =  25 
#> 
#>   Estimación considerando la información muestral: 
#>      95 %-max(λ) =  25.575  (método exacto) 
#>      Precisión deseada: δ =  2  
#>      Tamano muestral sin cpc: n ⩾  25 
#>      Tamano muestral con cpc: n ⩾  26 
#> 

```
