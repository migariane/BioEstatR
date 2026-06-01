# Regresion logistica multiple

Ajuste del modelo de regresion logistica multiple de acuerdo a la
especificacion y ~ x1 + x2 + ...

## Usage

``` r
rlogitm(
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

  formula: especificacion del modelo (ej. y ~ x1 + x2)

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
regr. logistica multiple, bondad de ajuste (Hosmer-Lemeshow) y curva
ROC.

## References

Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). Applied
Logistic Regression.

## Examples

``` r
# Ejemplo 1 - Uso basico
data(osteo)
rlogitm(osteo_cue ~ imc + edad, data = osteo)
#> Waiting for profiling to be done...
#> 
#> Regresión logística  multiple
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
#>    Modelo :  osteo_cue ~ imc + edad 
#>   Devianza residual:  98.102  (Nula:  106.804 )
#>   AIC:  104.102 
#>   R² de Nagelkerke:  0.13 
#> 
#>    Test de bondad de ajuste de Hosmer-Lemeshow :
#>   X² =  11.249 , gl =  8 ,   = 0.188 
#> 
#>    Capacidad discriminante :
#>    AUC (Area bajo la curva ROC)  =  0.667 
#> 
#>    Coeficientes del modelo :
#> 
#>       Termino Estimacion Error_Std  z_exp      sig     OR OR_inf   OR_sup
#> 1 (Intercept)      3.180     2.015  1.578  = 0.115 24.035  0.627 1852.638
#> 2         imc     -0.238     0.094 -2.543  = 0.011  0.788  0.643    0.931
#> 3        edad      0.043     0.030  1.417  = 0.156  1.044  0.985    1.111
#> 

# Ejemplo 2 - Con predicciones
data(osteo)
nuevos_datos <- data.frame(imc = c(22, 25), edad = c(30, 50))
rlogitm(osteo_cue ~ imc + edad, data = osteo, pred = nuevos_datos)
#> Waiting for profiling to be done...
#> 
#> Regresión logística  multiple
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
#>    Modelo :  osteo_cue ~ imc + edad 
#>   Devianza residual:  98.102  (Nula:  106.804 )
#>   AIC:  104.102 
#>   R² de Nagelkerke:  0.13 
#> 
#>    Test de bondad de ajuste de Hosmer-Lemeshow :
#>   X² =  11.249 , gl =  8 ,   = 0.188 
#> 
#>    Capacidad discriminante :
#>    AUC (Area bajo la curva ROC)  =  0.667 
#> 
#> # Pronósticos con el modelo ---
#> 
#>   imc edad Probabilidad
#> 1  22   30        0.316
#> 2  25   50        0.348
#> 
#>    Coeficientes del modelo :
#> 
#>       Termino Estimacion Error_Std  z_exp      sig     OR OR_inf   OR_sup
#> 1 (Intercept)      3.180     2.015  1.578  = 0.115 24.035  0.627 1852.638
#> 2         imc     -0.238     0.094 -2.543  = 0.011  0.788  0.643    0.931
#> 3        edad      0.043     0.030  1.417  = 0.156  1.044  0.985    1.111
#> 
```
