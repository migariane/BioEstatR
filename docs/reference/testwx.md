# Test no parametricos con dos muestras independientes (Wilcoxon/Mann-Whitney) y apareadas (Wilcoxon)

Test de homogeneidad no parametricos para dos muestras independientes
(test de Wilcoxont/Mann-Whitney con aprox. a la normal) y con dos
muestras apareadas (Wilcoxon). Se dan algunas medidas de tamano del
efecto. (Omision deliberada de tildes por compatibilidad)

## Usage

``` r
testwx(
  m1 = NULL,
  m2 = NULL,
  par = FALSE,
  m = NULL,
  grupos = NA,
  grf = TRUE,
  alfa = 0.05,
  conf = 1 - alfa,
  decs = 3,
  mess = -1
)
```

## Arguments

- m1:

  vector: vector de datos de la primera muestra cuando se indican dos
  muestras apareadas y tambien valido para muestras independientes.

- m2:

  vector: vector de datos de la segunda muestra cuando se indican dos
  muestras apareadas y tambien valido para muestras independientes.

- par:

  valor logico: si los tamanos de m1 y m2 son iguales se asumen muestras
  apareadas, pero si par=FALSE se asumen independientes

- m:

  vector: vector de datos a contrastar en formato longitudinal. Es
  preciso especificar el vector grupos para segmentar a este vector

- grupos:

  vector factor con dos niveles: variable de agrupacion en la
  comparacion de dos muestras independientes con valores dados en m

- grf:

  valor logico: si grf=FALSE se omite la salida grafica

- alfa:

  valor real \< 1: error alfa (parametro alternativamente al nivel de
  confianza, en tanto por uno). Por defecto =.05.

- conf:

  valor real \< 1: nivel de confianza para la elaboracion del IC para la
  estimacion del efecto

- decs:

  valor entero: precision decimal para la salida de resultados. Por
  defecto = 4.

- mess:

  valor entero: -1 desactiva mensajes de aviso (ver documentacion de Rs
  para options(warn = valor))

## Value

Informe con estadisticos de orden, rangos, resultado del test y
estimacion del tamano del efecto

## References

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## Examples

``` r
#[A] Muestras independientes
#[A.1] Como vectores independientes (distinto tamano)
y1<-c(78,64,75,45,82,55,48)
y2<-c(110,70,53,51,63,87)
testwx(m1=y1,m2=y2)
#> 
#> Test de Wilcoxon/Mann-Whithney para dos muestras independientes 
#> ----------------------------------------------------------------
#> # Información muestral ---
#> 
#>   Muestra n    min     Q1     Q2     Q3     max    RIQ
#> 1      y1 7 45.000 51.500 64.000 76.500  82.000 25.000
#> 2      y2 6 51.000 55.500 66.500 82.750 110.000 27.250
#> 
#> # Rangos ---
#> 
#>   Muestra n Suma_rangos Rango_medio      U
#> 1      y1 7          45       6.429 25.000
#> 2      y2 6          46       7.667 17.000
#> 
#> # Test ---
#> 
#>   U = 17.000; Z = 0.571; W = 17.000; p = 0.628
#> 
#> # Tamaño del efecto ---
#> 
#>   Diferencia de localización: -6.000    95%-IC = (-35.000, 19.000) 
#>   r = 0.158  (criterio: 0.1 pequeño; 0.3 mediano; >0.5 grande)
#>   Probabilidad de superioridad PS = 0.595
#>   (probabilidad de que un valor al azar de M1 sea < a un valor al azar de M2) 



#[A.2] Como vectores independientes (con el mismo tamano)
y1<-c(78,64,75,45,82,55,48)
y2<-c(110,70,53,51,63,87,99)
testwx(m1=y1,m2=y2,par=FALSE)
#> 
#> Test de Wilcoxon/Mann-Whithney para dos muestras independientes 
#> ----------------------------------------------------------------
#> # Información muestral ---
#> 
#>   Muestra n    min     Q1     Q2     Q3     max    RIQ
#> 1      y1 7 45.000 51.500 64.000 76.500  82.000 25.000
#> 2      y2 7 51.000 58.000 70.000 93.000 110.000 35.000
#> 
#> # Rangos ---
#> 
#>   Muestra n Suma_rangos Rango_medio      U
#> 1      y1 7          45       6.429 32.000
#> 2      y2 7          60       8.571 17.000
#> 
#> # Test ---
#> 
#>   U = 17.000; Z = 0.958; W = 17.000; p = 0.383
#> 
#> # Tamaño del efecto ---
#> 
#>   Diferencia de localización: -9.000    95%-IC = (-39.000, 13.000) 
#>   r = 0.256  (criterio: 0.1 pequeño; 0.3 mediano; >0.5 grande)
#>   Probabilidad de superioridad PS = 0.653
#>   (probabilidad de que un valor al azar de M1 sea < a un valor al azar de M2) 



#[A.3] En formato longitudinal (vector de valores y vector de agrupacion)
y<-c(78,64,75,45,82,55,48,  110,70,53,51,63,87)
g<-c(1,1,1,1,1,1,1,2,2,2,2,2,2)
testwx(m=y,grupos=g)
#> 
#> Test de Wilcoxon/Mann-Whithney para dos muestras independientes 
#> ----------------------------------------------------------------
#> # Información muestral ---
#> 
#>   Muestra n    min     Q1     Q2     Q3     max    RIQ
#> 1  y[g=1] 7 45.000 51.500 64.000 76.500  82.000 25.000
#> 2  y[g=2] 6 51.000 55.500 66.500 82.750 110.000 27.250
#> 
#> # Rangos ---
#> 
#>   Muestra n Suma_rangos Rango_medio      U
#> 1  y[g=1] 7          45       6.429 25.000
#> 2  y[g=2] 6          46       7.667 17.000
#> 
#> # Test ---
#> 
#>   U = 17.000; Z = 0.571; W = 17.000; p = 0.628
#> 
#> # Tamaño del efecto ---
#> 
#>   Diferencia de localización: -6.000    95%-IC = (-35.000, 19.000) 
#>   r = 0.158  (criterio: 0.1 pequeño; 0.3 mediano; >0.5 grande)
#>   Probabilidad de superioridad PS = 0.595
#>   (probabilidad de que un valor al azar de M1 sea < a un valor al azar de M2) 



#[B] Muestras apareadas (y1 e y2 deben tener el mismo tamano)
y1<-c(78,64,75,45,82,55,48)
y2<-c(110,70,53,51,63,87,99)
testwx(m1=y1,m2=y2)
#> 
#> Test de Wilcoxon/Mann-Whithney para dos muestras independientes 
#> ----------------------------------------------------------------
#> # Información muestral ---
#> 
#>   Muestra n    min     Q1     Q2     Q3     max    RIQ
#> 1      y1 7 45.000 51.500 64.000 76.500  82.000 25.000
#> 2      y2 7 51.000 58.000 70.000 93.000 110.000 35.000
#> 
#> # Rangos ---
#> 
#>   Muestra n Suma_rangos Rango_medio      U
#> 1      y1 7          45       6.429 32.000
#> 2      y2 7          60       8.571 17.000
#> 
#> # Test ---
#> 
#>   U = 17.000; Z = 0.958; W = 17.000; p = 0.383
#> 
#> # Tamaño del efecto ---
#> 
#>   Diferencia de localización: -9.000    95%-IC = (-39.000, 13.000) 
#>   r = 0.256  (criterio: 0.1 pequeño; 0.3 mediano; >0.5 grande)
#>   Probabilidad de superioridad PS = 0.653
#>   (probabilidad de que un valor al azar de M1 sea < a un valor al azar de M2) 


```
