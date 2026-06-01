# Tamano de muestra para estimar la media de una variable aleatoria con distribucion normal con una precision determinada

Permite estimar el tamano muestral para estimar una media con una
precision deseada a partir de la informacion dada por una muestra
piloto, que puede aparecer como variable o bien dando sus medidas
resumidas. Texto intencionadamente sin tildes u otros caracteres
especiales por la incompatibilidad de los mapas de caracteres.

## Usage

``` r
nm(
  x = 0,
  n = 0,
  m = 0,
  s = 0,
  d = 0,
  conf = 0.95,
  alfa = 0.05,
  decs = 4,
  vac = TRUE,
  eco = TRUE
)
```

## Arguments

- x:

  vector de datos de la muestra piloto

- n:

  valor entero: tamano muestral de la muestra piloto cuando se indican
  sus parametros muestrales resumidos

- m:

  valor real: media de la de la muestra piloto (previamente calculada)

- s:

  valor real: desviacion tipica de la muestra piloto (previamente
  calculada)

- d:

  valor real: precision deseada para el intervalo de confianza

- conf:

  valor real \< 1: nivel de confianza (parametro alternativo al error
  alfa, en tanto por uno). Por defecto =.95.

- alfa:

  valor real \< 1: error alfa (parametro alternativo al nivel de
  confianza, en tanto por uno). Por defecto =.05.

- decs:

  valor entero: precision decimal para la salida de resultados. Por
  defecto = 4.

- vac:

  valor logico: TRUE=se trata de una variable aleatoria continua; FALSE=
  la variable es discreta y se aplica cpc. Por defecto = TRUE.

- eco:

  valor logico: si eco=TRUE la funcion genera un informe (no devuelve
  valores), si eco=FALSE devuelve el tama?o de muestra estimado

## Value

Informe (si eco=T) con el tamano de muestra estimado para obtener un
intervalo de confianza para estimar una media con la precision deseada

## References

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## Examples

``` r
nm(x=c(25.4, 14.6, 23.1, 26.0, 14.4, 24.3, 36.1, 21.0, NA, 41.9,NA), d=1.5)
#> 
#> 
#> # Tamaño de muestra para la estimación de la media de una VA normal o su aproximación
#> # -----------------------------------------------------------------------------------
#> 
#> # Muestra piloto:
#>   Declarados 11 casos, hay 2 valores faltantes 
#>   Tamaño muestral válido:  n = 9 
#>   Media: m = 25.2000 
#>   Desviación típica: s = 9.0155 
#>   Error estandar de la media: sem = 3.0052 
#>   Precisión observada: d = 6.9300 
#> 
#> # Estimación del tamaño muestral:
#>   Precisión deseada: δ = 1.5000 
#>   Tamaño muestral necesario: n ≥ 193 
#> 
nm(d=1.0, n=100, m=25.3, s=4.1)
#> 
#> 
#> # Tamaño de muestra para la estimación de la media de una VA normal o su aproximación
#> # -----------------------------------------------------------------------------------
#> 
#> # Muestra piloto:
#>   Tamaño muestral:  n = 100 
#>   Media: m = 25.3000 
#>   Desviación típica: s = 4.1000 
#>   Error estandar de la media: sem = 0.4100 
#>   Precisión observada: d = 0.8135 
#> 
#> # Estimación del tamaño muestral:
#>   Precisión deseada: δ = 1.0000 
#>   Tamaño muestral necesario: n ≥ 67 
#>   La muestra actual es suficiente para obtener una precisión de1 unidades 
#> 
nm(d=1.0, n=100, m=25.3, s=4.1, conf=.99)
#> 
#> 
#> # Tamaño de muestra para la estimación de la media de una VA normal o su aproximación
#> # -----------------------------------------------------------------------------------
#> 
#> # Muestra piloto:
#>   Tamaño muestral:  n = 100 
#>   Media: m = 25.3000 
#>   Desviación típica: s = 4.1000 
#>   Error estandar de la media: sem = 0.4100 
#>   Precisión observada: d = 1.0768 
#> 
#> # Estimación del tamaño muestral:
#>   Precisión deseada: δ = 1.0000 
#>   Tamaño muestral necesario: n ≥ 116 
#> 
nm(d=1.0, n=100, m=25.3, s=4.1, alfa=.01)
#> 
#> 
#> # Tamaño de muestra para la estimación de la media de una VA normal o su aproximación
#> # -----------------------------------------------------------------------------------
#> 
#> # Muestra piloto:
#>   Tamaño muestral:  n = 100 
#>   Media: m = 25.3000 
#>   Desviación típica: s = 4.1000 
#>   Error estandar de la media: sem = 0.4100 
#>   Precisión observada: d = 1.0768 
#> 
#> # Estimación del tamaño muestral:
#>   Precisión deseada: δ = 1.0000 
#>   Tamaño muestral necesario: n ≥ 116 
#> 
```
