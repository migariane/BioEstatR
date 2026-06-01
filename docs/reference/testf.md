# Test de Fisher (F-test) para comparar dos varianzas

Permite obtener el intervalo de confianza a partir de una variable o
bien de las medidas resumidas (Texto intencionadamente sin tildes u
otros caracteres especiales por la incompatibilidad de los mapas de
caracteres)

## Usage

``` r
testf(s1 = 0, n1 = 0, s2 = 0, n2 = 0)
```

## Arguments

- s1:

  valor real: desviacion tipica de la muestra 1

- n1:

  valor entero: tamano muestra 1

- s2:

  valor real: desviacion tipica de la muestra 2

- n2:

  valor entero: tamano muestra 2

## Value

Fexp, gl1, gl2 y valor p del test de Fisher para el cociente de
varianzas

## References

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## Examples

``` r
testf(s1=15, n1=120, s2=12, n2=65)
#> [[1]]
#> [1] 1.5625
#> 
#> [[2]]
#> [1] 119
#> 
#> [[3]]
#> [1] 64
#> 
#> [[4]]
#> [1] 0.05037974
#> 
```
