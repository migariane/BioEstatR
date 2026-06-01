# Regresion lineal simple

Ajuste del modelo de regresion lineal simple de acuerdo a la
especificacion y~x

## Usage

``` r
rls(
  y = NULL,
  x = NULL,
  data = NULL,
  pred = NULL,
  grf = TRUE,
  dfout = F,
  alfa = 0.05,
  conf = 1 - alfa,
  decs = 3
)
```

## Arguments

- y:

  vector: variable explicada o formula del modelo lineal

- x:

  vector: variable explicativa

- data:

  data.frame: tabla de datos (necesaria si se indica y como formula)

- pred:

  vector: valores del regresor para realizar pronosticos a partir del
  modelo

- grf:

  valor logico: si grf=FALSE se omite la salida grafica

- dfout:

  valor logico: si dfout=TRUE el procedimiento devuelve la matriz de
  datos con valores residuales y pronosticos

- alfa:

  valor real \< 1: error alfa (parametro alternativamente al nivel de
  confianza, en tanto por uno). Por defecto =.05.

- conf:

  valor real \< 1: nivel de confianza para la elaboracion del IC para la
  estimacion del efecto

- decs:

  valor entero: precision decimal para la salida de resultados. Por
  defecto = 4.

## Value

Informe con medidas descriptivas, correlaciones, estimacion de los
parametros de regr. lineal, descriptiva residual y graficos de
dispersion y de la distribucion residual

## References

Montgomery, D. C., Peck, E. A., & Vining, G. G. (2012). Introduction to
Linear Regression Analysis.

## Examples

``` r
pre  <-c(200.1, 190.9, 192.7, 213, 241.4, 196.9, 172.2, 185.5, 205.2, 193.7)
post <-c(392.9, 393.2, 345.1, 393, 434, 427.9, 422, 383.9, 392.3, 352.2)
# Ejemplo 1 - entrada como vectores individuales
rls(post, pre) #ajusta el modelo post~pre
#> 
#> Regresión lineal simple 
#> ----------------------------------------------------------------
#> # Información muestral --- 
#> 
#>   variable  n  media     dt   Min   Max Rango
#> 1     <NA> 10 393.65 29.398 345.1 434.0  88.9
#> 2     <NA> 10 199.16 18.474 172.2 241.4  69.2
#> 
#>   Cov(NA,NA) = 169.073
#> 
#> # Correlación de Pearson --- 
#> 
#>       r IC_inf IC_sup gl  texp     sig
#>   0.311 -0.396  0.787  8 0.927 = 0.381
#> 
#> # Modelo lineal --- 
#> 
#>   Modelo:  NA ~ NA 
#>   R² =  0.097 
#>   S²residual =  878.04 
#>   :
#> 
#>          Coef   estim      se ic_inf  ic_sup  texp   sig
#> 1 (Constante) 294.982 106.896 48.478 541.485 2.760 0.025
#> 2        <NA>   0.495   0.535 -0.738   1.728 0.927 0.381
#> 
#> # Distribución residual --- 
#>   Error estándar residual: 29.632 
#>         res   zres
#> min -45.350 -1.626
#> Q1   -6.716 -0.246
#> Q2   -2.099 -0.077
#> Q3   15.478  0.903
#> max  41.707  1.728
#> 
#>   Test de normalidad residual (Shapiro-Wilk): 
#>   w =0.938, p= 0.526
#> 









# Ejemplo 2 - entrada como formula
datos<-data.frame(pre,post)
rls(post~pre, data=datos)
#> 
#> Regresión lineal simple 
#> ----------------------------------------------------------------
#> # Información muestral --- 
#> 
#>   variable  n  media     dt   Min   Max Rango
#> 1     post 10 393.65 29.398 345.1 434.0  88.9
#> 2      pre 10 199.16 18.474 172.2 241.4  69.2
#> 
#>   Cov(post,pre) = 169.073
#> 
#> # Correlación de Pearson --- 
#> 
#>       r IC_inf IC_sup gl  texp     sig
#>   0.311 -0.396  0.787  8 0.927 = 0.381
#> 
#> # Modelo lineal --- 
#> 
#>   Modelo:  post ~ pre 
#>   R² =  0.097 
#>   S²residual =  878.04 
#>   :
#> 
#>          Coef   estim      se ic_inf  ic_sup  texp   sig
#> 1 (Constante) 294.982 106.896 48.478 541.485 2.760 0.025
#> 2         pre   0.495   0.535 -0.738   1.728 0.927 0.381
#> 
#> # Distribución residual --- 
#>   Error estándar residual: 29.632 
#>         res   zres
#> min -45.350 -1.626
#> Q1   -6.716 -0.246
#> Q2   -2.099 -0.077
#> Q3   15.478  0.903
#> max  41.707  1.728
#> 
#>   Test de normalidad residual (Shapiro-Wilk): 
#>   w =0.938, p= 0.526
#> 









# Ejemplo 3 - Pronosticos
rls(post~pre, data=datos,pred=c(197,205))
#> 
#> Regresión lineal simple 
#> ----------------------------------------------------------------
#> # Información muestral --- 
#> 
#>   variable  n  media     dt   Min   Max Rango
#> 1     post 10 393.65 29.398 345.1 434.0  88.9
#> 2      pre 10 199.16 18.474 172.2 241.4  69.2
#> 
#>   Cov(post,pre) = 169.073
#> 
#> # Correlación de Pearson --- 
#> 
#>       r IC_inf IC_sup gl  texp     sig
#>   0.311 -0.396  0.787  8 0.927 = 0.381
#> 
#> # Modelo lineal --- 
#> 
#>   Modelo:  post ~ pre 
#>   R² =  0.097 
#>   S²residual =  878.04 
#>   :
#> 
#>          Coef   estim      se ic_inf  ic_sup  texp   sig
#> 1 (Constante) 294.982 106.896 48.478 541.485 2.760 0.025
#> 2         pre   0.495   0.535 -0.738   1.728 0.927 0.381
#> 
#> # Pronósticos con el modelo --- 
#>   Pronosticos puntuales y bandas al 95 % de confianza para 
#>   promedios IC(m), y para una nueva observación: IC(obs)   
#> 
#>   Predictor  Puntual IC(m)_inf IC(m)_sup IC(obs)_inf IC(obs)_sup
#> 1       197 392.5799  370.8083  414.3515    320.8643    464.2954
#> 2       205 396.5433  373.7670  419.3195    324.5164    468.5702
#> 
#> # Distribución residual --- 
#>   Error estándar residual: 29.632 
#>         res   zres
#> min -45.350 -1.626
#> Q1   -6.716 -0.246
#> Q2   -2.099 -0.077
#> Q3   15.478  0.903
#> max  41.707  1.728
#> 
#>   Test de normalidad residual (Shapiro-Wilk): 
#>   w =0.938, p= 0.526
#> 









# Ejemplo 4 - Obtencion de la matriz con residuos y pronosticos
tabla<-rls(post~pre, data=datos,dfout=TRUE)
#> 
#> Regresión lineal simple 
#> ----------------------------------------------------------------
#> # Información muestral --- 
#> 
#>   variable  n  media     dt   Min   Max Rango
#> 1     post 10 393.65 29.398 345.1 434.0  88.9
#> 2      pre 10 199.16 18.474 172.2 241.4  69.2
#> 
#>   Cov(post,pre) = 169.073
#> 
#> # Correlación de Pearson --- 
#> 
#>       r IC_inf IC_sup gl  texp     sig
#>   0.311 -0.396  0.787  8 0.927 = 0.381
#> 
#> # Modelo lineal --- 
#> 
#>   Modelo:  post ~ pre 
#>   R² =  0.097 
#>   S²residual =  878.04 
#>   :
#> 
#>          Coef   estim      se ic_inf  ic_sup  texp   sig
#> 1 (Constante) 294.982 106.896 48.478 541.485 2.760 0.025
#> 2         pre   0.495   0.535 -0.738   1.728 0.927 0.381
#> 
#> # Distribución residual --- 
#>   Error estándar residual: 29.632 
#>         res   zres
#> min -45.350 -1.626
#> Q1   -6.716 -0.246
#> Q2   -2.099 -0.077
#> Q3   15.478  0.903
#> max  41.707  1.728
#> 
#>   Test de normalidad residual (Shapiro-Wilk): 
#>   w =0.938, p= 0.526
#> 









head(tabla)
#>       x     y        res        zres      pre      lwr      upr    lwr.1
#> 1 200.1 392.9  -1.215696 -0.04325299 394.1157 372.4765 415.7549 322.4402
#> 2 190.9 393.2   3.642183  0.13119284 389.5578 365.6700 413.4457 317.1717
#> 3 192.7 345.1 -45.349576 -1.62554113 390.4496 367.4202 413.4789 318.3423
#> 4 213.0 393.0  -7.506636 -0.27679634 400.5066 372.9731 428.0401 326.8370
#> 5 241.4 434.0  19.423388  1.16040040 414.5766 358.1920 470.9612 325.9858
#> 6 196.9 427.9  35.369653  1.25937173 392.5303 370.7433 414.3174 320.8101
#>      upr.1
#> 1 465.7911
#> 2 461.9439
#> 3 462.5569
#> 4 474.1762
#> 5 503.1675
#> 6 464.2506
```
