# Diagramas por grupos

Obtencion de los diagramas de distribucion segmentados, o no, por factor
de agrupacion

## Usage

``` r
grpsggp(
  x = NULL,
  f = NULL,
  se = NULL,
  ggid = 1,
  lbls = NULL,
  bins = NULL,
  hnmin = 50
)
```

## Arguments

- x:

  vector: variable cuantitativa a resumir

- f:

  vector: factor cuyos niveles segmentan a la variable cuantitativa (si
  falta se da la descriptiva de x)

- se:

  valor real: error estandar a representar

- ggid:

  valor entero: indicador del grafico a representar

- lbls:

  vector de caracteres: nombres de los ejees

- bins:

  entero: numero de intervalos para el histograma

- hnmin:

  entero: tamano minimo/maximo de muestra para representar el
  histograma/diagrama de puntos

## Value

Representacion grafica

## References

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## See also

freq, grps

## Examples

``` r
data(osteo)
grpsggp(x = osteo$imc, f = osteo$osteo_cue, ggid = 3)
```
