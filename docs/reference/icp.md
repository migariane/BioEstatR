# Estimacion de una proporcion binomial por los metodos: Wilson (con cpc), Wald (con cpc) y Wald ajustado

Obtencion del intervalo de confianza para una proporcion binomial
considerando los metodos de Wilson (con cpc), Wald (con cpc) y Wald
ajustado. Texto intencionadamente sin tildes u otros caracteres
especiales por la incompatibilidad de los mapas de caracteres

## Usage

``` r
icp(
  x = 0,
  n = 0,
  level = "",
  conf = 0.95,
  alfa = 0.05,
  decs = 4,
  d = 0,
  tabla = FALSE
)
```

## Arguments

- x:

  valor entero: numerador de la proporcion binomial (si se da la
  informacion resumida) o valor a seleccionar del vector v (si se ha
  dado un vector de datos)

- n:

  valor entero: denominador de la proporcion binomial (si se da la
  informacion resumida)

- level:

  entero o texto: es el valor o la etiqueta del nivel de seleccion de x
  cuando este ultimo es un vector

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
  d\>0 se invoca a la funcion np()

- tabla:

  valor logico: si tabla=TRUE el informe tiene forma de tabla. En
  cualquier caso devuelve los limites del IC y su precision

## Value

Informe con los intervalos de confianza de Wilson, Wald (ambos con cpc)
y Wald ajustado. Limites de cada intervalo y su precision en forma de
tabla.

## References

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## Examples

``` r
# Introduciendo frecuencias
icp(x=25, n=210)
#> 
#> Intervalo de confianza para una proporción binomial 
#> --------------------------------------------------- 
#> 
#> Información muestral: 
#>   Tamaño de muestra: n = 210
#>   Estimación puntual clásica: p=x/n = 0.119, q=(1-p)=0.881
#>   Casos observados: x = 25
#> 
#> # Método exacto (Clooper-Pearson):
#>   Pseudo-estimación puntual: p' = 0.1247, q'=(1-p')=0.8753
#>   95%-IC(π): (0.0786, 0.1707) 
#>   Semiamplitud: 0.046
#> 
#> # Método de Wilson (con cpc):
#>   Pseudo-estimación puntual: p' = 0.1263, q'=(1-p')=0.8737
#>   95%-IC(π): (0.08, 0.1725) 
#>   Semiamplitud: 0.0463
#> 
#> # Método de Wald (con cpc):
#>   Estimación puntual (clásica): p=x/n = 0.119, q=(1-p)=0.881
#>   95%-IC(π): (0.0729, 0.1652) 
#>   Precisión: 0.0462
#> 
#> # Método de Wald ajustado (Agresti-Coull):
#>   Estimación puntual: p=(x+2)/(n+4) = 0.1262, q=(1-p)=0.8738
#>   95%-IC(π): (0.0817, 0.1707) 
#>   Precisión: 0.0445
#> 
icp(x=25, n=210, conf=0.90, decs=8)
#> 
#> Intervalo de confianza para una proporción binomial 
#> --------------------------------------------------- 
#> 
#> Información muestral: 
#>   Tamaño de muestra: n = 210
#>   Estimación puntual clásica: p=x/n = 0.1190476, q=(1-p)=0.8809524
#>   Casos observados: x = 25
#> 
#> # Método exacto (Clooper-Pearson):
#>   Pseudo-estimación puntual: p' = 0.1232511, q'=(1-p')=0.8767489
#>   90%-IC(π): (0.08421205, 0.1622901) 
#>   Semiamplitud: 0.03903903
#> 
#> # Método de Wilson (con cpc):
#>   Pseudo-estimación puntual: p' = 0.1242024, q'=(1-p')=0.8757976
#>   90%-IC(π): (0.08501027, 0.1633945) 
#>   Semiamplitud: 0.0391921
#> 
#> # Método de Wald (con cpc):
#>   Estimación puntual (clásica): p=x/n = 0.1190476, q=(1-p)=0.8809524
#>   90%-IC(π): (0.07990847, 0.1581868) 
#>   Precisión: 0.03913915
#> 
#> # Método de Wald ajustado (Agresti-Coull):
#>   Estimación puntual: p=(x+2)/(n+4) = 0.1261682, q=(1-p)=0.8738318
#>   90%-IC(π): (0.08883382, 0.1635026) 
#>   Precisión: 0.03733441
#> 

# Introduciendo datos
datos<-c(1,1,1,2,2,2,2,2,1,1,1,2,1,2,2,2,2,2,1,1,1,2,1,2,1,2,1,2,2,2,2,2,1,1)
  icp(x=datos, level=1)
#> 
#> Intervalo de confianza para una proporción binomial 
#> --------------------------------------------------- 
#> 
#> Información muestral: 
#>   Tamaño de muestra: n = 34
#>   Estimación puntual clásica: p=x/n = 0.4412, q=(1-p)=0.5588
#>   Casos observados: (nivel =1)x = 15
#> 
#> # Método exacto (Clooper-Pearson):
#>   Pseudo-estimación puntual: p' = 0.4492, q'=(1-p')=0.5508
#>   95%-IC(π): (0.2772, 0.6211) 
#>   Semiamplitud: 0.172
#> 
#> # Método de Wilson (con cpc):
#>   Pseudo-estimación puntual: p' = 0.4476, q'=(1-p')=0.5524
#>   95%-IC(π): (0.2762, 0.6191) 
#>   Semiamplitud: 0.1715
#> 
#> # Método de Wald (con cpc):
#>    No aplicable: x= 15 <20 , n-x= 19 <20 
#> 
#> # Método de Wald ajustado (Agresti-Coull):
#>   Estimación puntual: p=(x+2)/(n+4) = 0.4474, q=(1-p)=0.5526
#>   95%-IC(π): (0.2893, 0.6055) 
#>   Precisión: 0.1581
#> 
  icp(x=datos, level=1, conf=.99)
#> 
#> Intervalo de confianza para una proporción binomial 
#> --------------------------------------------------- 
#> 
#> Información muestral: 
#>   Tamaño de muestra: n = 34
#>   Estimación puntual clásica: p=x/n = 0.4412, q=(1-p)=0.5588
#>   Casos observados: (nivel =1)x = 15
#> 
#> # Método exacto (Clooper-Pearson):
#>   Pseudo-estimación puntual: p' = 0.4525, q'=(1-p')=0.5475
#>   99%-IC(π): (0.2351, 0.67) 
#>   Semiamplitud: 0.2174
#> 
#> # Método de Wilson (con cpc):
#>   Pseudo-estimación puntual: p' = 0.4514, q'=(1-p')=0.5486
#>   99%-IC(π): (0.2383, 0.6645) 
#>   Semiamplitud: 0.2131
#> 
#> # Método de Wald (con cpc):
#>    No aplicable: x= 15 <20 , n-x= 19 <20 
#> 
#> # Método de Wald ajustado (Agresti-Coull):
#>   Estimación puntual: p=(x+2)/(n+4) = 0.4474, q=(1-p)=0.5526
#>   99%-IC(π): (0.2396, 0.6551) 
#>   Precisión: 0.2078
#> 
sexo<-as.factor(c("H","H","M","M","H","M","M","H","H","M","H","M","H"))
  icp(x=sexo, level="M")
#> 
#> Intervalo de confianza para una proporción binomial 
#> --------------------------------------------------- 
#> 
#> Información muestral: 
#>   Tamaño de muestra: n = 13
#>   Estimación puntual clásica: p=x/n = 0.4615, q=(1-p)=0.5385
#>   Casos observados: (nivel =M)x = 6
#> 
#> # Método exacto (Clooper-Pearson):
#>   Pseudo-estimación puntual: p' = 0.4728, q'=(1-p')=0.5272
#>   95%-IC(π): (0.197, 0.7487) 
#>   Semiamplitud: 0.2758
#> 
#> # Método de Wilson (con cpc):
#>   Pseudo-estimación puntual: p' = 0.4714, q'=(1-p')=0.5286
#>   95%-IC(π): (0.204, 0.7388) 
#>   Semiamplitud: 0.2674
#> 
#> # Método de Wald (con cpc):
#>    No aplicable: x= 6 <20 , n-x= 7 <20 
#> 
#> # Método de Wald ajustado (Agresti-Coull):
#>   Estimación puntual: p=(x+2)/(n+4) = 0.4706, q=(1-p)=0.5294
#>   95%-IC(π): (0.2333, 0.7079) 
#>   Precisión: 0.2373
#> 

# Cambiar la salida por una tabla resumen (manejable como data.frame)
icp(x=sexo, level="M",tabla=TRUE)
#> 
#> 
#> # Intervalos de confianza para una proporción binomial 
#> # -----------------------------------------------------
#>   Método (conf.=95%) 
#>                   puntual  icinf  icsup precision
#>   Clooper-Pearson  0.4728 0.1970 0.7487    0.2758
#>   Wilson           0.4714 0.2040 0.7388    0.2674
#>   Wald             0.4615     NA     NA        NA
#>   Agresti-Coull    0.4706 0.2333 0.7079    0.2373

# Invocacion a la estimacion del tamano muestral
icp(x=sexo, level="M", d=0.1)
#> 
#> Intervalo de confianza para una proporción binomial 
#> --------------------------------------------------- 
#> 
#> Información muestral: 
#>   Tamaño de muestra: n = 13
#>   Estimación puntual clásica: p=x/n = 0.4615, q=(1-p)=0.5385
#>   Casos observados: (nivel =M)x = 6
#> 
#> # Método exacto (Clooper-Pearson):
#>   Pseudo-estimación puntual: p' = 0.4728, q'=(1-p')=0.5272
#>   95%-IC(π): (0.197, 0.7487) 
#>   Semiamplitud: 0.2758
#> 
#> # Método de Wilson (con cpc):
#>   Pseudo-estimación puntual: p' = 0.4714, q'=(1-p')=0.5286
#>   95%-IC(π): (0.204, 0.7388) 
#>   Semiamplitud: 0.2674
#> 
#> # Método de Wald (con cpc):
#>    No aplicable: x= 6 <20 , n-x= 7 <20 
#> 
#> # Método de Wald ajustado (Agresti-Coull):
#>   Estimación puntual: p=(x+2)/(n+4) = 0.4706, q=(1-p)=0.5294
#>   95%-IC(π): (0.2333, 0.7079) 
#>   Precisión: 0.2373
#> 
#> 
#> Tamaño de muestra para estimar una proporción binomial 
#> -------------------------------------------------------
#> 
#> Información muestral 
#>   Tamaño de la muestra: n = 13
#>   Casos: x = 6
#>   Inferencia para la proporción basada en el método de Wald ajustado: 
#>   95%-IC(π): (0.2333, 0.7079) 
#>   precisión observada: d = 0.2373 (23.73%) 
#> 
#> Tamaño muestral requerido para δ = 0.1 (10.00%), conf.= 95% 
#>   - Basado en la muestra actual (po = 0.7079):   n ≥ 80
#>   - Sin considerar la información previa: n ≥ 97
#> 
```
