# Medidas de forma de una distribucion

Obtencion de los coeficientes de asimetria y de apuntamiento (curtosis)
de una variable cuantitativa, junto con su interpretacion y una prueba
de normalidad. La asimetria y la curtosis se calculan en su version
muestral corregida (insesgada). (Texto intencionadamente sin tildes u
otros caracteres especiales.)

## Usage

``` r
forma(x = NULL, decs = 3, normal = TRUE, eco = TRUE)
```

## Arguments

- x:

  vector de datos numerico cuya forma se va a describir

- decs:

  valor entero: numero de decimales a mostrar en la salida. Por defecto
  = 3.

- normal:

  valor logico: si normal=TRUE anade la prueba de Shapiro-Wilk cuando n
  \< 5000 y la de Kolmogorov-Smirnov (Lilliefors) en caso contrario. Por
  defecto = TRUE.

- eco:

  valor logico: si eco=TRUE la funcion genera un informe, si eco=FALSE
  devuelve una lista con los valores calculados. Por defecto = TRUE.

## Value

Si eco=TRUE, un informe con el coeficiente de asimetria, el de curtosis,
su interpretacion cualitativa y la prueba de normalidad. Si eco=FALSE,
una lista con los elementos `n`, `media`, `dt`, `asimetria`,
`error_tipico_asimetria`, `curtosis`, `error_tipico_curtosis`,
`z_asimetria`, `z_curtosis`, `p_normalidad` y `test_normalidad`.

## Details

El coeficiente de asimetria (g1) mide la falta de simetria de la
distribucion. Valores proximos a 0 indican simetria; valores positivos
indican asimetria hacia la derecha (cola derecha) y valores negativos
asimetria hacia la izquierda. La curtosis (g2) mide el apuntamiento
relativo a la distribucion normal: g2 = 0 es mesocurtica (equivalente a
la normal), g2 \> 0 leptocurtica (mas apuntada) y g2 \< 0 platicurtica
(mas aplanada). Los errores tipicos permiten valorar la significacion
estadistica de ambos coeficientes mediante un estadistico z que se
contrasta con la normal estandar.

## References

Joanes, D. N., & Gill, C. A. (1998). Comparing measures of sample
skewness and kurtosis. Journal of the Royal Statistical Society: Series
D (The Statistician), 47(1), 183-189.

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## See also

grps, freq, grpsggp, descriptiva

## Examples

``` r
# Distribucion simetrica: asimetria y curtosis proximas a 0
set.seed(1)
forma(x = rnorm(200, mean = 100, sd = 15))
#> 
#> # Medidas de forma ---
#> 
#>   n = 200   media = 100.533   dt = 13.936
#> 
#>   Asimetria (g1) = 0.198   (error tipico = 0.172)
#>     Interpretacion: simetrica
#>     z = 1.150  p = 0.2500  (asimetria no significativa)
#> 
#>   Curtosis (g2) = -0.190   (error tipico = 0.342)
#>     Interpretacion: mesocurtica (como la normal)
#>     z = -0.556  p = 0.5782  (curtosis no significativa)
#> 
#>   Prueba de normalidad (Shapiro-Wilk): p = 0.4272  -> no se rechaza la normalidad
#> 

# Distribucion asimetrica hacia la derecha
forma(x = c(1, 1, 1, 2, 2, 3, 4, 5, 8, 13, 21, 34, 55, 89, 144))
#> 
#> # Medidas de forma ---
#> 
#>   n = 15   media = 25.533   dt = 41.226
#> 
#>   Asimetria (g1) = 2.160   (error tipico = 0.580)
#>     Interpretacion: asimetria positiva (cola derecha)
#>     z = 3.724  p = 2e-04  (asimetria significativa)
#> 
#>   Curtosis (g2) = 4.464   (error tipico = 1.121)
#>     Interpretacion: leptocurtica (mas apuntada que la normal)
#>     z = 3.983  p = 1e-04  (curtosis significativa)
#> 
#>   Prueba de normalidad (Shapiro-Wilk): p = 1e-04  -> se rechaza la normalidad
#> 

# Uso silencioso para reutilizar los valores
res <- forma(x = c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, NA), eco = FALSE)
res$asimetria
#> [1] -0.1952533
res$curtosis
#> [1] -1.835197

# Los datos del estudio sobre osteoporosis
data(osteo)
forma(x = osteo$imc, decs = 2)
#> 
#> # Medidas de forma ---
#> 
#>   n = 94   media = 23.92   dt = 3.75
#> 
#>   Asimetria (g1) = 1.22   (error tipico = 0.25)
#>     Interpretacion: asimetria positiva (cola derecha)
#>     z = 4.90  p = 0.000  (asimetria significativa)
#> 
#>   Curtosis (g2) = 1.46   (error tipico = 0.49)
#>     Interpretacion: leptocurtica (mas apuntada que la normal)
#>     z = 2.96  p = 0.003  (curtosis significativa)
#> 
#>   Prueba de normalidad (Shapiro-Wilk): p = 0.000  -> se rechaza la normalidad
#> 
```
