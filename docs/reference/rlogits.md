# Regresion logistica simple

Ajuste del modelo de regresion logistica simple de acuerdo a la
especificacion y ~ x

## Usage

``` r
rlogits(
  f,
  data = NULL,
  pred = NULL,
  grf = FALSE,
  alfa = 0.05,
  conf = 1 - alfa,
  decs = 3
)
```

## Arguments

- f:

  formula: especificacion del modelo (ej. y ~ x)

- data:

  data.frame: tabla de datos

- pred:

  data.frame: valores de los regresores para realizar pronosticos a
  partir del modelo

- grf:

  valor logico: si grf=TRUE se incluye el grafico de la curva ROC. Por
  defecto = FALSE.

- alfa:

  valor real \< 1: error alfa (parametro alternativamente al nivel de
  confianza, en tanto por uno). Por defecto =.05.

- conf:

  valor real \< 1: nivel de confianza para la elaboracion del IC para la
  estimacion del efecto. Por defecto = 1-alfa.

- decs:

  valor entero: precision decimal para la salida de resultados. Por
  defecto = 3.

## Value

Informe con medidas de asociacion (OR), estimacion de los parametros de
regr. logistica, bondad de ajuste (Hosmer-Lemeshow) y curva ROC.

## References

Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). Applied
Logistic Regression.

## Examples

``` r
# Ejemplo 1 - Uso basico
data(osteo)
rlogits(osteo_cue ~ imc, data = osteo)
#> Waiting for profiling to be done...
#> 
#> Regresión logística  simple
#> ----------------------------------------------------------------
#> # Información muestral --- 
#> 
#>    Tamaño muestral (N inicial) :  94 
#>    Tamaño muestral tras eliminar valores perdidos (Casos completos) :  94 
#>    Mínima frecuencia de eventos (n efectivo) :  24 
#> 
#> # Distribución de la variable respuesta (osteo_cue) ---
#> 
#>   Categoria  n Porcentaje
#> 1        No 70     74.468
#> 2        Sí 24     25.532
#> 
#> # Modelo logístico ---  --- 
#> 
#>    Modelo :  osteo_cue ~ imc 
#>   Devianza residual:  100.176  (Nula:  106.804 )
#>   AIC:  104.176 
#>   R² de Nagelkerke:  0.1 
#> 
#>    Test de bondad de ajuste de Hosmer-Lemeshow :
#>   X² =  7.041 , gl =  8 ,   = 0.532 
#> 
#>    Capacidad discriminante :
#>    AUC (Area bajo la curva ROC)  =  0.649 
#> 
#>    Coeficientes del modelo :
#> 
#>       Termino Estimacion Error_Std  z_exp      sig     OR OR_inf   OR_sup
#> 1 (Intercept)      3.620     2.044  1.771  = 0.077 37.348  0.937 3055.247
#> 2         imc     -0.202     0.089 -2.256  = 0.024  0.817  0.672    0.957
#> 

# Ejemplo 2 - Con predicciones
data(osteo)
nuevos_datos <- data.frame(imc = c(22, 25))
rlogits(osteo_cue ~ imc, data = osteo, pred = nuevos_datos)
#> Waiting for profiling to be done...
#> 
#> Regresión logística  simple
#> ----------------------------------------------------------------
#> # Información muestral --- 
#> 
#>    Tamaño muestral (N inicial) :  94 
#>    Tamaño muestral tras eliminar valores perdidos (Casos completos) :  94 
#>    Mínima frecuencia de eventos (n efectivo) :  24 
#> 
#> # Distribución de la variable respuesta (osteo_cue) ---
#> 
#>   Categoria  n Porcentaje
#> 1        No 70     74.468
#> 2        Sí 24     25.532
#> 
#> # Modelo logístico ---  --- 
#> 
#>    Modelo :  osteo_cue ~ imc 
#>   Devianza residual:  100.176  (Nula:  106.804 )
#>   AIC:  104.176 
#>   R² de Nagelkerke:  0.1 
#> 
#>    Test de bondad de ajuste de Hosmer-Lemeshow :
#>   X² =  7.041 , gl =  8 ,   = 0.532 
#> 
#>    Capacidad discriminante :
#>    AUC (Area bajo la curva ROC)  =  0.649 
#> 
#> # Pronósticos con el modelo ---
#> 
#>   imc Probabilidad
#> 1  22        0.307
#> 2  25        0.195
#> 
#>    Coeficientes del modelo :
#> 
#>       Termino Estimacion Error_Std  z_exp      sig     OR OR_inf   OR_sup
#> 1 (Intercept)      3.620     2.044  1.771  = 0.077 37.348  0.937 3055.247
#> 2         imc     -0.202     0.089 -2.256  = 0.024  0.817  0.672    0.957
#> 
```
