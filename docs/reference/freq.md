# Obtencion de la tabla de frecuencias absolutas y relativas de las categorias de una variable

Permite obtener la tabla de frecuencias observadas para un vector de
datos x o cada columna de un data.frame x (Texto intencionadamente sin
tildes u otros caracteres especiales por la incompatibilidad de los
mapas de caracteres).

## Usage

``` r
freq(x = NULL, acum = TRUE, cuts = 0, agrup = TRUE, decs = 3, grf = TRUE, ...)
```

## Arguments

- x:

  vector: vector o data.frame a describir

- acum:

  valor logico: TRUE=proporciona la frecuencia relativa acumulada

- cuts:

  valor entero: numero de intervalos a realizar. Si se omite se utiliza
  el criterio de Sturges

- agrup:

  valor logico: si agrup=FALSE no se hace agrupacion en intervalos
  aunque haya mas de 10 categorias

- decs:

  valor entero: numero de decimales a mostrar en la salida

- grf:

  valor logico: si TRUE/FALSE se proporciona/omite salida grafica

- ...:

  parametros de configuracion de la funcion grpsggp

## Value

si x es un vector, se devuelve un data.frame con la tabla de
frecuencias. Si x es un data.frame, se muestra la tabla de frecuencias
de cada columna, pero la funcion no devuelve ningun objeto

## References

Agresti, A. (2013). Categorical Data Analysis.

## See also

grps, grpsggp

## Examples

``` r
dat<-c(12,15,13,12,11,14,15,15,15,12,11,13,14,15,NA)
freq(dat)
#> 
#> Distribución de frecuencias
#> --------------------------------
#> Variable:  dat 
#> Valores faltantes: 1 
#> n= 14 
#>  
#>    x Freq  Prop Prop.Acum
#> 1 11    2 0.143     0.143
#> 2 12    3 0.214     0.357
#> 3 13    2 0.143     0.500
#> 4 14    2 0.143     0.643
#> 5 15    5 0.357     1.000


cats<-c('a','b','c','b','c','b','c','a','c','c','a','a','a')
freq(cats,acum=FALSE,grf=TRUE)
#> 
#> Distribución de frecuencias
#> --------------------------------
#> Variable:  cats 
#> n= 13 
#>  
#>   x Freq  Prop
#> 1 a    5 0.385
#> 2 b    3 0.231
#> 3 c    5 0.385


dat2<-rnorm(550,212.3,6.3)
freq(dat2, agrup=TRUE,cuts=5)
#> 
#> Distribución de frecuencias
#> --------------------------------
#> Variable:  dat2 
#> n = 550 
#>  
#>           x Freq  Prop Prop.Acum
#> 1 (193,202]   40 0.073     0.073
#> 2 (202,211]  223 0.405     0.478
#> 3 (211,220]  226 0.411     0.889
#> 4 (220,229]   59 0.107     0.996
#> 5 (229,238]    1 0.002     0.998


t<-rbinom(25,20,0.65)
freq(t,agrup=FALSE,cuts=5,decs=2)
#> 
#> Distribución de frecuencias
#> --------------------------------
#> Variable:  t 
#> n= 25 
#>  
#>    x Freq Prop Prop.Acum
#> 1  9    2 0.08      0.08
#> 2 11    5 0.20      0.28
#> 3 12    5 0.20      0.48
#> 4 13    3 0.12      0.60
#> 5 14    4 0.16      0.76
#> 6 15    1 0.04      0.80
#> 7 16    4 0.16      0.96
#> 8 17    1 0.04      1.00


nrm<-rnorm(50,250,2)
bnm<-rbinom(50,80,0.5)
df<-data.frame(nrm,bnm)
freq(nrm)
#> 
#> Distribución de frecuencias
#> --------------------------------
#> Variable:  nrm 
#> n = 50 
#>  
#>           x Freq Prop Prop.Acum
#> 1 (243,245]    1 0.02      0.02
#> 2 (245,247]    6 0.12      0.14
#> 3 (247,249]   12 0.24      0.38
#> 4 (249,251]   14 0.28      0.66
#> 5 (251,253]   14 0.28      0.94
#> 6 (253,255]    3 0.06      1.00

freq(bnm,agrup=TRUE,grf=TRUE)
#> 
#> Distribución de frecuencias
#> --------------------------------
#> Variable:  bnm 
#> n = 50 
#>  
#>         x Freq Prop Prop.Acum
#> 1 (27,31]    1 0.02      0.02
#> 2 (31,35]    5 0.10      0.12
#> 3 (35,39]   19 0.38      0.50
#> 4 (39,43]   19 0.38      0.88
#> 5 (43,47]    4 0.08      0.96
#> 6 (47,51]    2 0.04      1.00

freq(df,acum=FALSE,grf=TRUE,hnmin=60)
#> 
#> Distribución de frecuencias
#> --------------------------------
#> 
#> Variable:  nrm 
#> n = 50 
#>  
#>           x Freq Prop
#> 1 (243,245]    1 0.02
#> 2 (245,247]    6 0.12
#> 3 (247,249]   12 0.24
#> 4 (249,251]   14 0.28
#> 5 (251,253]   14 0.28
#> 6 (253,255]    3 0.06

#> 
#> Variable:  bnm 
#> n = 50 
#>  
#>         x Freq Prop
#> 1 (27,31]    1 0.02
#> 2 (31,35]    5 0.10
#> 3 (35,39]   19 0.38
#> 4 (39,43]   19 0.38
#> 5 (43,47]    4 0.08
#> 6 (47,51]    2 0.04


```
