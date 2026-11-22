# Medidas de posicion y deteccion de valores atipicos

Obtencion de los cuantiles (cuartiles, deciles o percentiles) de una
variable cuantitativa, del rango intercuartilico y de la deteccion de
valores atipicos por el criterio de Tukey (vallas de 1.5 y 3 veces el
rango intercuartilico). (Texto intencionadamente sin tildes u otros
caracteres especiales.)

## Usage

``` r
posicion(
  x = NULL,
  probs = c(0, 0.25, 0.5, 0.75, 1),
  tipo = 7,
  decs = 3,
  eco = TRUE
)
```

## Arguments

- x:

  vector de datos numerico cuya posicion se va a describir

- probs:

  vector numerico entre 0 y 1: cuantiles a calcular. Por defecto los
  cuartiles (0, 0.25, 0.5, 0.75, 1).

- tipo:

  valor entero entre 1 y 9: tipo de calculo de cuantiles tal como los
  define [`stats::quantile`](https://rdrr.io/r/stats/quantile.html). Por
  defecto = 7 (el que usa R por omision).

- decs:

  valor entero: numero de decimales a mostrar en la salida. Por defecto
  = 3.

- eco:

  valor logico: si eco=TRUE la funcion genera un informe, si eco=FALSE
  devuelve una lista con los valores calculados. Por defecto = TRUE.

## Value

Si eco=TRUE, un informe con los cuantiles, el rango intercuartilico, las
vallas de Tukey y el listado de valores atipicos. Si eco=FALSE, una
lista con los elementos `n`, `cuantiles`, `ric`, `valla_inf`,
`valla_sup`, `atipicos_leves`, `atipicos_graves`, `valores_atipicos` y
`n_atipicos`.

## Details

Se considera valor atipico leve todo valor situado fuera del intervalo
\[Q1 - 1.5 \* RIC, Q3 + 1.5 \* RIC\] y valor atipico grave (extremo) el
situado fuera de \[Q1 - 3 \* RIC, Q3 + 3 \* RIC\], siendo RIC = Q3 - Q1
el rango intercuartilico.

## References

Tukey, J. W. (1977). Exploratory Data Analysis. Addison-Wesley.

Hyndman, R. J., & Fan, Y. (1996). Sample quantiles in statistical
packages. The American Statistician, 50(4), 361-365.

## See also

grps, freq, forma, descriptiva

## Examples

``` r
# Cuartiles y deteccion de atipicos en una serie con dos valores extremos
datos <- c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, 11, 13, 14, 45, 60)
posicion(x = datos)
#> 
#> # Medidas de posicion ---
#> 
#>   n = 15
#> 
#>   Cuantiles (tipo 7):
#>     0% = 11.000
#>     25% = 12.000
#>     50% = 14.000
#>     75% = 15.000
#>     100% = 60.000
#> 
#>   Rango intercuartilico (RIC) = 3.000
#>   Vallas de Tukey (1.5 x RIC): [7.500, 19.500]
#>   Vallas extremas   (3.0 x RIC): [3.000, 24.000]
#> 
#>   Valores atipicos leves (n = 2): 45.000, 60.000
#>   Valores atipicos graves (n = 2): 45.000, 60.000
#> 

# Deciles en lugar de cuartiles
posicion(x = datos, probs = seq(0, 1, by = 0.1))
#> 
#> # Medidas de posicion ---
#> 
#>   n = 15
#> 
#>   Cuantiles (tipo 7):
#>     0% = 11.000
#>     10% = 11.400
#>     20% = 12.000
#>     30% = 12.200
#>     40% = 13.000
#>     50% = 14.000
#>     60% = 14.400
#>     70% = 15.000
#>     80% = 15.000
#>     90% = 33.000
#>     100% = 60.000
#> 
#>   Rango intercuartilico (RIC) = 3.000
#>   Vallas de Tukey (1.5 x RIC): [7.500, 19.500]
#>   Vallas extremas   (3.0 x RIC): [3.000, 24.000]
#> 
#>   Valores atipicos leves (n = 2): 45.000, 60.000
#>   Valores atipicos graves (n = 2): 45.000, 60.000
#> 

# Recuperar los valores para reutilizarlos
res <- posicion(x = datos, eco = FALSE)
res$atipicos_graves
#> [1] 45 60
res$valla_sup
#> [1] 19.5

# Datos del estudio sobre osteoporosis
data(osteo)
posicion(x = osteo$imc, decs = 2)
#> 
#> # Medidas de posicion ---
#> 
#>   n = 94
#> 
#>   Cuantiles (tipo 7):
#>     0% = 18.07
#>     25% = 21.34
#>     50% = 23.22
#>     75% = 25.54
#>     100% = 37.33
#> 
#>   Rango intercuartilico (RIC) = 4.20
#>   Vallas de Tukey (1.5 x RIC): [15.04, 31.84]
#>   Vallas extremas   (3.0 x RIC): [8.75, 38.14]
#> 
#>   Valores atipicos leves (n = 6): 32.32, 32.46, 37.33, 32.47, 34.26, 32.00
#>   Valores atipicos graves (n = 0)
#> 
```
