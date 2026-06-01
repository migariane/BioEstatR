# Estimacion del parametro de la distribucion de Poisson

Obtencion del intervalo de confianza para el parametro de la
distribucion de Poisson por los metodos exacto y aproximando a la normal
(transformacion de la raiz).

## Usage

``` r
icl(x = 0, n = 0, conf = 0.95, alfa = 1 - conf, decs = 4, d = 0, eco = TRUE)
```

## Arguments

- x:

  valor entero: vector de observaciones de una v.a. con distribucion de
  Poisson o valor medio observado en una muestra de tamano n.

- n:

  valor entero: tamano de la muestra piloto cuando x representa su
  media.

- conf:

  valor \< 1: nivel de confianza (alternativo al error alfa, en tanto
  por uno). Por defecto =.95.

- alfa:

  valor \< 1: error alfa (alternativo al nivel de confianza, en tanto
  por uno). Por defecto =.05.

- decs:

  valor entero: precision decimal para la salida de resultados. Por
  defecto = 4.

- d:

  valor real \< 1: precision deseada para el intervalo de confianza. Si
  d\>0 se invoca a la funcion nl()

- eco:

  valor logico: si eco=TRUE la funcion genera un informe (no devuelve
  valores), si eco=FALSE devuelve el IC exacto y el basado en la aprox
  normal con su precision respectiva

## Value

Informe con intervalos de confianza exacto y aproximado a la normal (con
cpc) (eco=TRUE) o los limites y precision correspondientes a cada
intervalo

## References

Garwood, F. (1936). Fiducial Limits for the Poisson Distribution.
Biometrika.

## See also

nl

## Examples

``` r
# Introduciendo datos observados
# Una sola observacion (muestra de tamano n=1)
icl(3)
#> 
#> Intervalo de confianza bilateral para el parámetro  λ de una VA con distribución de Poisson 
#> ----------------------------------------------------------------------------------------------
#> Información muestral: 
#>   Muestra de una sola observación  
#>   Tamaño muestral: n =  1 
#>   Media observada: m =  3 
#> 
#> Estimación: 
#>   [1] Método exacto: 
#>       95 %-IC(λ):  ( 0.6187 ,  8.7673 )
#>       Semiamplitud del intervalo: 4.0743 
#> 
#>   [2] Aproximación a la normal (transformación de la raiz): 
#>       Validez de la aproximación: Σx =  3  < 15 --- NO es válida --- 
#>       95 %-IC(λ):  ( 0.5656 ,  8.8803 )
#>       Precisión obtenida: 4.1573 
#> 
# muestra con mas de una observacion
icl(c(3,6,3,1,2,5))
#> 
#> Intervalo de confianza bilateral para el parámetro  λ de una VA con distribución de Poisson 
#> ----------------------------------------------------------------------------------------------
#> Información muestral: 
#>   No hay valores faltantes 
#>   Tamaño muestral: n =  6 
#>   Media observada: m =  3.3333 
#> 
#> Estimación: 
#>   [1] Método exacto: 
#>       95 %-IC(λ):  ( 2.0361 ,  5.1481 )
#>       Semiamplitud del intervalo: 1.556 
#> 
#>   [2] Aproximación a la normal (transformación de la raiz): 
#>       Validez de la aproximación: Σx =  20  ⩾ 15 (válida) 
#>       95 %-IC(λ):  ( 2.0325 ,  5.157 )
#>       Precisión obtenida: 1.5622 
#> 
# Introduciendo media x de n datos observados
icl(x=25, n=210)
#> 
#> Intervalo de confianza bilateral para el parámetro  λ de una VA con distribución de Poisson 
#> ----------------------------------------------------------------------------------------------
#> Información muestral: 
#>   Se indica una única observación muestral 210  
#>   Tamaño muestral: n =  210 
#>   Media observada: m =  25 
#> 
#> Estimación: 
#>   [1] Método exacto: 
#>       95 %-IC(λ):  ( 24.3283 ,  25.6856 )
#>       Semiamplitud del intervalo: 0.6787 
#> 
#>   [2] Aproximación a la normal (transformación de la raiz): 
#>       Validez de la aproximación: Σx =  5250  ⩾ 15 (válida) 
#>       95 %-IC(λ):  ( 24.3283 ,  25.6857 )
#>       Precisión obtenida: 0.6787 
#> 

icl(x=25, n=210, eco=FALSE)->IC
IC
#> [[1]]
#> [1] 24.32827
#> 
#> [[2]]
#> [1] 25.68558
#> 
#> [[3]]
#> [1] 0.6786537
#> 
#> [[4]]
#> [1] 24.32832
#> 
#> [[5]]
#> [1] 25.68565
#> 
#> [[6]]
#> [1] 0.678665
#> 

# solicitud del tamano de muestra necesario para estimar con una precision d=1 unidad
icl(x=25, n=210, d=1)
#> 
#> Intervalo de confianza bilateral para el parámetro  λ de una VA con distribución de Poisson 
#> ----------------------------------------------------------------------------------------------
#> Información muestral: 
#>   Se indica una única observación muestral 210  
#>   Tamaño muestral: n =  210 
#>   Media observada: m =  25 
#> 
#> Estimación: 
#>   [1] Método exacto: 
#>       95 %-IC(λ):  ( 24.3283 ,  25.6856 )
#>       Semiamplitud del intervalo: 0.6787 
#> 
#>   [2] Aproximación a la normal (transformación de la raiz): 
#>       Validez de la aproximación: Σx =  5250  ⩾ 15 (válida) 
#>       95 %-IC(λ):  ( 24.3283 ,  25.6857 )
#>       Precisión obtenida: 0.6787 
#> 
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
#>      Precisión deseada: δ =  1  
#>      Tamano muestral sin cpc: n ⩾  99 
#>      Tamano muestral con cpc: n ⩾  100 
#> 
```
