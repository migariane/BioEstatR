# Estudio de la normalidad de una variable

Representa el histograma de una variable x, superponiendo la densidad
normal ajustada asi como un estimador del nucleo de la densidad. Permite
obtener el diagrama QQ y el resultado del test de Shapiro-Wilk

## Usage

``` r
testnormal(
  x,
  obs = TRUE,
  mod = TRUE,
  dens = TRUE,
  ks = 1,
  ky = 1.2,
  qq = FALSE,
  sw = TRUE,
  decs = 3,
  ...
)
```

## Arguments

- x:

  vector de datos a analizar

- obs:

  valor logico: TRUE=representar el histograma

- mod:

  valor logico: TRUE=representar el modelo ajustado de densidad normal

- dens:

  valor logico: TRUE=Superponer estimador de nucleo de la densidad

- ks:

  valor real: factor multiplicador del numero de intervalos calculados
  (el calculo se hace por la regla de Sturges o la de Freedman-Diaconis)

- ky:

  valor real: factor multiplicador de la escala del eje de ordenadas

- qq:

  valor logico: representa el diagrama QQ normal

- sw:

  valor logico: realiza el test de Shapiro-Wilk

- decs:

  valor entero: numero de decimales en la salida

- ...:

  parametros de configuracion de la funcion grpsggp

## Value

Histograma con densidad normal superpuesta, diagrama probabilistico
normal, test de Shapiro-Wilk

## References

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## Examples

``` r
x=rnorm(500,10,2)
testnormal(x);

#> 
#> # Test de normalidad de Shapiro-Wilk  
#>  ------------------------------------- 
#>    n = 500,  W = 0.998,  p = 0.827 
testnormal(x,ks=3);

#> 
#> # Test de normalidad de Shapiro-Wilk  
#>  ------------------------------------- 
#>    n = 500,  W = 0.998,  p = 0.827 
testnormal(x,dens=FALSE)

#> 
#> # Test de normalidad de Shapiro-Wilk  
#>  ------------------------------------- 
#>    n = 500,  W = 0.998,  p = 0.827 
testnormal(x,mod=FALSE,dens=FALSE,ks=3)

#> 
#> # Test de normalidad de Shapiro-Wilk  
#>  ------------------------------------- 
#>    n = 500,  W = 0.998,  p = 0.827 
testnormal(x,obs=FALSE)

#> 
#> # Test de normalidad de Shapiro-Wilk  
#>  ------------------------------------- 
#>    n = 500,  W = 0.998,  p = 0.827 
testnormal(x,col="white")

#> 
#> # Test de normalidad de Shapiro-Wilk  
#>  ------------------------------------- 
#>    n = 500,  W = 0.998,  p = 0.827 
testnormal(x,sw=TRUE)

#> 
#> # Test de normalidad de Shapiro-Wilk  
#>  ------------------------------------- 
#>    n = 500,  W = 0.998,  p = 0.827 
testnormal(x,sw=TRUE,qq=TRUE,ks=3)


#> 
#> # Test de normalidad de Shapiro-Wilk  
#>  ------------------------------------- 
#>    n = 500,  W = 0.998,  p = 0.827 
testnormal(x,sw=TRUE,qq=TRUE,ks=3)


#> 
#> # Test de normalidad de Shapiro-Wilk  
#>  ------------------------------------- 
#>    n = 500,  W = 0.998,  p = 0.827 
```
