# Tamano de muestra para estimar una proporcion binomial

Obtencion del tamano muestral para estimar una proporcion binomial con
la precision deseada a partir de informacion piloto (metodo de Wald
ajustado) o sin ella. Texto intencionadamente sin tildes u otros
caracteres especiales por la incompatibilidad de los mapas de
caracteres.

## Usage

``` r
np(
  x = 0,
  n = 0,
  d = 0,
  v = 0,
  level = "",
  conf = 0.95,
  alfa = 0.05,
  decs = 4,
  eco = TRUE
)
```

## Arguments

- x:

  valor entero: numerador de la proporcion binomial (si se da la
  informacion resumida) o valor de seleccion (si se da un vector)

- n:

  valor entero: denominador de la proporcion binomial (si se da la
  informacion resumida)

- d:

  valor real \< 1: precision deseada para el intervalo de confianza

- v:

  vector: numero de casos favorables (numerador de la proporcion
  binomial)

- level:

  texto: si se indica v como factor, level es la etiqueta del nivel de
  seleccisn

- conf:

  valor \< 1: nivel de confianza (parametro alternativo al error alfa,
  en tanto por uno). Por defecto =.95.

- alfa:

  valor \< 1: error alfa (parametro alternativo al nivel de confianza,
  en tanto por uno). Por defecto =.05.

- decs:

  valor entero: precision decimal para la salida de resultados. Por
  defecto = 4.

- eco:

  valor logico: si eco=TRUE devuelve informe, de lo contrario, los
  valores estimados de n con y sin informacion

## Value

Informe con el tamano de muestra necesario para estimar un proporcion
binomial con la precision deseada

## References

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## Examples

``` r
np(x=25, n=210, d=.05,decs=3)
#> 
#> Tamaño de muestra para estimar una proporción binomial 
#> -------------------------------------------------------
#> 
#> Información muestral 
#>   Tamaño de la muestra: n = 210
#>   Casos: x = 25
#>   Inferencia para la proporción basada en el método de Wald ajustado: 
#>   95%-IC(π): (0.082, 0.171) 
#>   precisión observada: d = 0.044 (4.45%) 
#> 
#> Tamaño muestral requerido para δ = 0.05 (5.00%), conf.= 95% 
#>   - Basado en la muestra actual (po = 0.171):   n ≥ 218
#>   - Sin considerar la información previa: n ≥ 385
#> 
np(x=115, n=210, d=.10)
#> 
#> Tamaño de muestra para estimar una proporción binomial 
#> -------------------------------------------------------
#> 
#> Información muestral 
#>   Tamaño de la muestra: n = 210
#>   Casos: x = 115
#>   Inferencia para la proporción basada en el método de Wald ajustado: 
#>   95%-IC(π): (0.4800, 0.6134) 
#>   precisión observada: d = 0.0667 (6.67%) 
#> 
#> Tamaño muestral requerido para δ = 0.1 (10.00%), conf.= 95% 
#>   - Basado en la muestra actual (po = 0.6134):   n ≥ 92
#>   - Sin considerar la información previa: n ≥ 97
#> 
np(x=25, n=210, d=.05, conf=.90, decs=5)
#> 
#> Tamaño de muestra para estimar una proporción binomial 
#> -------------------------------------------------------
#> 
#> Información muestral 
#>   Tamaño de la muestra: n = 210
#>   Casos: x = 25
#>   Inferencia para la proporción basada en el método de Wald ajustado: 
#>   90%-IC(π): (0.08883, 0.16350) 
#>   precisión observada: d = 0.03733 (3.73%) 
#> 
#> Tamaño muestral requerido para δ = 0.05 (5.00%), conf.= 90% 
#>   - Basado en la muestra actual (po = 0.16350):   n ≥ 149
#>   - Sin considerar la información previa: n ≥ 271
#> 
np(x=25, n=210, d=.05, conf=.90, decs=5, eco=FALSE)
#> [[1]]
#> [1] 148.0144
#> 
#> [[2]]
#> [1] 270.5543
#> 
```
