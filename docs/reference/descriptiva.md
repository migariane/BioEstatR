# Analisis descriptivo completo de una o varias variables

Rutina global de estadistica descriptiva. Para cada variable de un
vector o de un data.frame devuelve, segun su naturaleza: el tamano
muestral valido y el numero de valores faltantes, las medidas de
tendencia central y de dispersion, los cuantiles, el coeficiente de
variacion, las medidas de forma y la deteccion de valores atipicos. En
las variables cualitativas devuelve la tabla de frecuencias absolutas y
relativas. (Texto intencionadamente sin tildes u otros caracteres
especiales.)

## Usage

``` r
descriptiva(
  x = NULL,
  f = NULL,
  decs = 3,
  ic = FALSE,
  conf = 0.95,
  normal = FALSE,
  maxcat = 10,
  eco = TRUE
)
```

## Arguments

- x:

  vector o data.frame a describir

- f:

  vector opcional: factor de agrupacion. Si se indica, la descriptiva de
  cada variable cuantitativa se segmenta por sus niveles. Por defecto =
  NULL.

- decs:

  valor entero: numero de decimales a mostrar en la salida. Por defecto
  = 3.

- ic:

  valor logico: si ic=TRUE anade el intervalo de confianza para la media
  de las variables cuantitativas. Por defecto = FALSE.

- conf:

  valor real entre 0 y 1: nivel de confianza para los intervalos. Por
  defecto = 0.95.

- normal:

  valor logico: si normal=TRUE anade la prueba de normalidad de las
  variables cuantitativas. Por defecto = FALSE.

- maxcat:

  valor entero: umbral de codificacion. Una variable numerica entera con
  tres valores distintos como maximo y cuyo valor maximo no supera
  maxcat se trata como cualitativa (por ejemplo una escala 0/1/2). Por
  defecto = 10.

- eco:

  valor logico: si eco=TRUE la funcion imprime el informe, si eco=FALSE
  devuelve una lista con los resultados sin imprimirlos. Por defecto =
  TRUE.

## Value

Si eco=TRUE, imprime el informe y devuelve de forma invisible una lista
con dos elementos: `cuantitativas` (lista por variable con medidas de
centralizacion, dispersion, posicion, forma y atipicos) y `cualitativas`
(lista por variable con la tabla de frecuencias). Si eco=FALSE devuelve
esa misma lista sin imprimir nada.

## Details

Se trata de una rutina de resumen pensada como primer paso de cualquier
analisis. Detecta automaticamente el tipo de cada variable: las de tipo
`factor` o `character`, y las numericas con `maxcat` valores distintos o
menos, se tratan como cualitativas; el resto como cuantitativas. Las
medidas de forma se calculan con
[`forma`](https://migariane.github.io/BioEstatR/reference/forma.md) y
las de posicion y los valores atipicos con
[`posicion`](https://migariane.github.io/BioEstatR/reference/posicion.md),
de modo que los resultados son coherentes con esas funciones cuando se
aplican por separado.

## References

Tukey, J. W. (1977). Exploratory Data Analysis. Addison-Wesley.

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## See also

grps, freq, forma, posicion, grpsggp

## Examples

``` r
# Descriptiva de un vector cuantitativo
descriptiva(x = c(12, 15, 13, 12, 11, 14, 15, 15, 15, 12, 11, 13, NA))
#> 
#> # Analisis descriptivo ---
#>   Observaciones: 13
#> 
#> ## Variables cuantitativas ---
#> 
#> ### x ---
#>   n = 12   faltantes = 1
#>   media = 13.167   dt = 1.586   ee = 0.458
#>   CV = 12.045%
#>   mediana = 13.000   Q1 = 12.000   Q3 = 15.000
#>   min = 11.000   max = 15.000   RIC = 3.000
#>   asimetria = 0.003   curtosis = -1.659
#>   valores atipicos (Tukey 1.5 x RIC) = 0
#> 

# Descriptiva de un data.frame con variables cuantitativas y cualitativas
set.seed(1)
df <- data.frame(
  edad = c(rnorm(40, 45, 12), NA, NA),
  sexo = factor(sample(c("hombre", "mujer"), 42, replace = TRUE)),
  imc = rnorm(42, 25, 4)
)
descriptiva(x = df)
#> 
#> # Analisis descriptivo ---
#>   Observaciones: 42
#> 
#> ## Variables cuantitativas ---
#> 
#> ### edad ---
#>   n = 40   faltantes = 2
#>   media = 46.104   dt = 10.640   ee = 1.682
#>   CV = 23.078%
#>   mediana = 46.549   Q1 = 40.206   Q3 = 53.934
#>   min = 18.424   max = 64.143   RIC = 13.728
#>   asimetria = -0.684   curtosis = 0.431
#>   valores atipicos (Tukey 1.5 x RIC) = 1
#> 
#> ### imc ---
#>   n = 42   faltantes = 0
#>   media = 25.052   dt = 3.570   ee = 0.551
#>   CV = 14.250%
#>   mediana = 25.140   Q1 = 22.658   Q3 = 27.340
#>   min = 17.780   max = 33.690   RIC = 4.682
#>   asimetria = 0.180   curtosis = -0.247
#>   valores atipicos (Tukey 1.5 x RIC) = 0
#> 
#> ## Variables cualitativas ---
#> 
#> ### sexo ---
#>   n = 42   faltantes = 0   categorias = 2   moda = hombre
#>     hombre: n = 21 (50.000%)
#>     mujer: n = 21 (50.000%)
#> 

# Anadiendo intervalos de confianza y prueba de normalidad
descriptiva(x = df$imc, ic = TRUE, normal = TRUE, decs = 2)
#> 
#> # Analisis descriptivo ---
#>   Observaciones: 42
#> 
#> ## Variables cuantitativas ---
#> 
#> ### df$imc ---
#>   n = 42   faltantes = 0
#>   media = 25.05   dt = 3.57   ee = 0.55
#>   CV = 14.25%
#>   IC 95% = (23.94, 26.16)
#>   mediana = 25.14   Q1 = 22.66   Q3 = 27.34
#>   min = 17.78   max = 33.69   RIC = 4.68
#>   asimetria = 0.18   curtosis = -0.25
#>   valores atipicos (Tukey 1.5 x RIC) = 0
#>   normalidad (Shapiro-Wilk) p = 0.969
#> 

# Descriptiva segmentada por un factor de agrupacion
descriptiva(x = df$imc, f = df$sexo)
#> 
#> # Analisis descriptivo ---
#>   Observaciones: 42
#>   Agrupacion: hombre, mujer
#> 
#> ## Variables cuantitativas ---
#> 
#> ### df$imc ---
#>   n = 42   faltantes = 0
#>   media = 25.052   dt = 3.570   ee = 0.551
#>   CV = 14.250%
#>   mediana = 25.140   Q1 = 22.658   Q3 = 27.340
#>   min = 17.780   max = 33.690   RIC = 4.682
#>   asimetria = 0.180   curtosis = -0.247
#>   valores atipicos (Tukey 1.5 x RIC) = 0
#>   por grupos:
#>     hombre: n = 21, media = 26.057, dt = 3.385
#>     mujer: n = 21, media = 24.046, dt = 3.542
#> 

# Recuperar los resultados sin imprimir el informe
res <- descriptiva(x = df, eco = FALSE)
names(res)
#> [1] "cuantitativas" "cualitativas" 
res$cuantitativas$imc$media
#> [1] 25.05152
res$cualitativas$sexo
#> $n
#> [1] 42
#> 
#> $n_faltante
#> [1] 0
#> 
#> $n_categorias
#> [1] 2
#> 
#> $tabla
#>   categoria  n porcentaje porcentaje_acumulado
#> 1    hombre 21         50                   50
#> 2     mujer 21         50                  100
#> 
#> $moda
#> [1] "hombre"
#> 

# El conjunto de datos sobre osteoporosis
data(osteo)
descriptiva(x = osteo[, c("edad", "imc", "hba1c", "sexo")], decs = 2)
#> 
#> # Analisis descriptivo ---
#>   Observaciones: 94
#> 
#> ## Variables cuantitativas ---
#> 
#> ### edad ---
#>   n = 94   faltantes = 0
#>   media = 30.19   dt = 9.37   ee = 0.97
#>   CV = 31.02%
#>   mediana = 28.00   Q1 = 22.25   Q3 = 35.00
#>   min = 18.00   max = 56.00   RIC = 12.75
#>   asimetria = 0.93   curtosis = 0.16
#>   valores atipicos (Tukey 1.5 x RIC) = 1
#> 
#> ### imc ---
#>   n = 94   faltantes = 0
#>   media = 23.92   dt = 3.75   ee = 0.39
#>   CV = 15.67%
#>   mediana = 23.22   Q1 = 21.34   Q3 = 25.54
#>   min = 18.07   max = 37.33   RIC = 4.20
#>   asimetria = 1.22   curtosis = 1.46
#>   valores atipicos (Tukey 1.5 x RIC) = 6
#> 
#> ### hba1c ---
#>   n = 94   faltantes = 0
#>   media = 8.56   dt = 1.80   ee = 0.19
#>   CV = 21.00%
#>   mediana = 8.40   Q1 = 7.43   Q3 = 9.70
#>   min = 4.60   max = 13.80   RIC = 2.27
#>   asimetria = 0.37   curtosis = 0.35
#>   valores atipicos (Tukey 1.5 x RIC) = 1
#> 
#> ## Variables cualitativas ---
#> 
#> ### sexo ---
#>   n = 94   faltantes = 0   categorias = 2   moda = Mujer
#>     Hombre: n = 45 (47.87%)
#>     Mujer: n = 49 (52.13%)
#> 
```
