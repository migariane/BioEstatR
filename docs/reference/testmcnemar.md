# test de homogeneidad de dos proporciones apareadas (McNemar)

Comparacion de dos proporciones apareadas. Texto intencionadamente sin
tildes u otros caracteres especiales por la incompatibilidad de los
mapas de caracteres.

## Usage

``` r
testmcnemar(
  pre = NULL,
  post = NULL,
  n = NULL,
  n11 = 0,
  n12 = 0,
  n21 = 0,
  n22 = 0,
  fcat = c("+", "-"),
  ccat = c("+", "-"),
  alfa = 0.05,
  conf = 0.95,
  decs = 4,
  delta = NULL,
  beta = 0.2,
  potencia = 1 - beta,
  lbls = NULL
)
```

## Arguments

- pre:

  vector de observaciones en el pretest

- post:

  vector de observaciones en el posttest

- n:

  vector de enteros: frecuencias observadas con el formato
  n=c(n11,n12,n21,n22)

- n11:

  entero: frecuencia observada en la fila 1 y columna 1

- n12:

  entero: frecuencia observada en la fila 1 y columna 2

- n21:

  entero: frecuencia observada en la fila 2 y columna 1

- n22:

  entero: frecuencia observada en la fila 2 y columna 2

- fcat:

  vector de cadenas de texto: Nombres de fila

- ccat:

  vector de cadenas de texto: Nombres de columna

- alfa:

  real en (0,1): Nivel de error de los intervalos (alternativa a conf) y
  error de tipo I para la determinacion de n

- conf:

  real en (0,1): Nivel de confianza de los intervalos (alternativa a
  alfa)

- decs:

  entero: Numero de decimales en las salidas

- delta:

  real: diferencia a detectar

- beta:

  real en (0,1): Nivel de error de tipo II para la determinacion de n

- potencia:

  real en (0,1): Nivel de potencia deseada (alternativa a beta)

- lbls:

  vector de los nombres de variable pre- y post- (llamada desde testp)

## Value

Informe analisis de dos proporciones apareadas mediante test de McNemar,
intervalo de conf. para la diferencia y estimacion de tamano muestral

## References

McNemar, Q. (1947). Note on the sampling error of the difference between
correlated proportions or percentages. Psychometrika.

## Examples

``` r
#
#Uso basico de la funcion introduciendo frecuencias observadas conforme a la tabla
#           post+ post-  |
# pre+      n11     n12  |
# pre-      n21     n22  |
#          -----------------
#                        |n
#
# Tabla de frecuencias. Son equivalentes las llamadas
testmcnemar(n=c(27,35,43,20))
#> 
#> 
#> # Inferencia con dos proporciones (muestras apareadas)
#> # ----------------------------------------------------
#> 
#> # Frecuencias observadas pretest x posttest
#>             +    - Total
#>    +       27   35    62
#>    -       43   20    63
#>    Total   70   55   125
#> 
#> 
#> # Proporciones observadas pretest x posttest
#>              +     - Total
#>    +     0.216 0.280 0.496
#>    -     0.344 0.160 0.504
#>    Total 0.560 0.440 1.000
#> 
#> # Test de McNemar: H₀:π₁₂=π₂₁
#>    Validez: n₁₂+n₂₁ = 78 > 10 el test es válido 
#>    Zexp =  0.8492 
#>                valor.p Alternativa
#>     Bilateral   0.3958  H₁:π₁₂≠π₂₁
#>     Unilateral  0.1979  H₁:π₁₂<π₂₁
#> 
#> 
#> # Test exacto de Fisher:
#>   H₀:π₁₂=0.5 para n₁₂ ~ B(n₁₂+n₂₁, π₁₂) 
#>                Valor.p Alternativa
#>     Bilateral   0.4426  H₁:π₁₂≠0.5
#>     Unilateral  0.2141  H₁:π₁₂<0.5
#>   ____
#>   * Aquí se alude a la probabilidad total de la discordancia, es decir que π₁₂+π₂₁=1
#> 
#> # Estimación de las proporciones individuales de discordancias π₁₂ y π₂₁ (método de Wald ajustado)
#>    [1] p₁₂ = 0.2868, 95%-IC(π₁₂) = (0.2088, 0.3649) 
#>    [2] p₂₁ = 0.3488, 95%-IC(π₂₁) = (0.2666, 0.4311) 
#> 
#> 
#> # Intervalo de confianza para la diferencia de 2 proporciones apareadas
#>    [1] Método de Wald (clásico con cpc):
#>       Estimación puntual de π₁₂-π₂₁ = -0.0640 
#>       Validez: n₁₂+n₂₁ = 78 > 5, el IC es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.2025, 0.0745) 
#> 
#>    [2] Método de Agresti-Min:
#>       Estimación puntual de π₁₂-π₂₁ = -0.0630 
#>       Validez: siempre es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.1997, 0.0737) 
testmcnemar(n11=27,n12=35,n21=43,n22=20)
#> 
#> 
#> # Inferencia con dos proporciones (muestras apareadas)
#> # ----------------------------------------------------
#> 
#> # Frecuencias observadas pretest x posttest
#>             +    - Total
#>    +       27   35    62
#>    -       43   20    63
#>    Total   70   55   125
#> 
#> 
#> # Proporciones observadas pretest x posttest
#>              +     - Total
#>    +     0.216 0.280 0.496
#>    -     0.344 0.160 0.504
#>    Total 0.560 0.440 1.000
#> 
#> # Test de McNemar: H₀:π₁₂=π₂₁
#>    Validez: n₁₂+n₂₁ = 78 > 10 el test es válido 
#>    Zexp =  0.8492 
#>                valor.p Alternativa
#>     Bilateral   0.3958  H₁:π₁₂≠π₂₁
#>     Unilateral  0.1979  H₁:π₁₂<π₂₁
#> 
#> 
#> # Test exacto de Fisher:
#>   H₀:π₁₂=0.5 para n₁₂ ~ B(n₁₂+n₂₁, π₁₂) 
#>                Valor.p Alternativa
#>     Bilateral   0.4426  H₁:π₁₂≠0.5
#>     Unilateral  0.2141  H₁:π₁₂<0.5
#>   ____
#>   * Aquí se alude a la probabilidad total de la discordancia, es decir que π₁₂+π₂₁=1
#> 
#> # Estimación de las proporciones individuales de discordancias π₁₂ y π₂₁ (método de Wald ajustado)
#>    [1] p₁₂ = 0.2868, 95%-IC(π₁₂) = (0.2088, 0.3649) 
#>    [2] p₂₁ = 0.3488, 95%-IC(π₂₁) = (0.2666, 0.4311) 
#> 
#> 
#> # Intervalo de confianza para la diferencia de 2 proporciones apareadas
#>    [1] Método de Wald (clásico con cpc):
#>       Estimación puntual de π₁₂-π₂₁ = -0.0640 
#>       Validez: n₁₂+n₂₁ = 78 > 5, el IC es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.2025, 0.0745) 
#> 
#>    [2] Método de Agresti-Min:
#>       Estimación puntual de π₁₂-π₂₁ = -0.0630 
#>       Validez: siempre es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.1997, 0.0737) 

# Determinacion del tamano de muestra para declarar significativa una
# diferencia delta con potencia 1-beta y error alfa
testmcnemar(n11=27,n12=35,n21=43,n22=20,delta=0.05,alfa=0.05,beta=0.15)
#> 
#> 
#> # Inferencia con dos proporciones (muestras apareadas)
#> # ----------------------------------------------------
#> 
#> # Frecuencias observadas pretest x posttest
#>             +    - Total
#>    +       27   35    62
#>    -       43   20    63
#>    Total   70   55   125
#> 
#> 
#> # Proporciones observadas pretest x posttest
#>              +     - Total
#>    +     0.216 0.280 0.496
#>    -     0.344 0.160 0.504
#>    Total 0.560 0.440 1.000
#> 
#> # Test de McNemar: H₀:π₁₂=π₂₁
#>    Validez: n₁₂+n₂₁ = 78 > 10 el test es válido 
#>    Zexp =  0.8492 
#>                valor.p Alternativa
#>     Bilateral   0.3958  H₁:π₁₂≠π₂₁
#>     Unilateral  0.1979  H₁:π₁₂<π₂₁
#> 
#> 
#> # Test exacto de Fisher:
#>   H₀:π₁₂=0.5 para n₁₂ ~ B(n₁₂+n₂₁, π₁₂) 
#>                Valor.p Alternativa
#>     Bilateral   0.4426  H₁:π₁₂≠0.5
#>     Unilateral  0.2141  H₁:π₁₂<0.5
#>   ____
#>   * Aquí se alude a la probabilidad total de la discordancia, es decir que π₁₂+π₂₁=1
#> 
#> # Estimación de las proporciones individuales de discordancias π₁₂ y π₂₁ (método de Wald ajustado)
#>    [1] p₁₂ = 0.2868, 95%-IC(π₁₂) = (0.2088, 0.3649) 
#>    [2] p₂₁ = 0.3488, 95%-IC(π₂₁) = (0.2666, 0.4311) 
#> 
#> 
#> # Intervalo de confianza para la diferencia de 2 proporciones apareadas
#>    [1] Método de Wald (clásico con cpc):
#>       Estimación puntual de π₁₂-π₂₁ = -0.0640 
#>       Validez: n₁₂+n₂₁ = 78 > 5, el IC es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.2025, 0.0745) 
#> 
#>    [2] Método de Agresti-Min:
#>       Estimación puntual de π₁₂-π₂₁ = -0.0630 
#>       Validez: siempre es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.1997, 0.0737) 
#> 
#> 
#> # Estudio de la potencia: δ = 0.05 -> ±δ=[-0.05, 0.05], potencia θ = 0.85, α = 0.05
#>   70%-IC(π₁₂-π₂₁) = (-0.1353, 0.0093) (método de Agresti-Min) 
#> 
#>      -(--[--|)---]---    potencia < 85% 
#> 
#>     Leyenda:   --(---)--    --[---|---]--  
#>                 IC- IC+      -δ   0  +δ 
#> 
#> 
#> # Tamaño de muestra necesario para declarar significativa una diferencia δ
#>   Diferencia: δ = 0.05 
#>   Potencia: θ = 0.850 
#>   Error de tipo I: α = 0.050 
#> 
#>    [1] Estimación para la varianza máxima:  
#>       Asumiendo p₁₂ = 0.4750   p₂₁ = 0.5250 
#>       n ⩾ 3589 
#> 
#>    [2] Basado en la información muestral:  
#>       Asumiendo p₁₂ = 0.3649   p₂₁ = 0.4149 
#>       n ⩾ 2798 
#>   ____
#>   *Si se desea la estimación de n para el test unilateral, repetir
#>    el análisis indicando alfa=0.1000 y asumir el n obtenido.

# Informacion en forma de vector
xpre<- c(1,1,2,2,1,2,1,2,2,2,1,1,2,2,1,1,2,2,1,1,1,1,1,1,1,NA,2)
xpost<-c(1,2,2,1,2,1,2,2,2,1,1,2,2,1,1,2,2,1,2,NA,1,1,1,2,2,2,1)
testmcnemar(xpre,xpost)
#> 
#> 
#> # Inferencia con dos proporciones (muestras apareadas)
#> # ----------------------------------------------------
#> 
#> # Frecuencias observadas pretest x posttest
#>   Detectado 1 caso faltante en pretest 
#>   Detectado 1 caso faltante en posttest 
#>   Se eliminan las parejas con algún valor faltante 
#> 
#>             +    - Total
#>    +        6    8    14
#>    -        6    5    11
#>    Total   12   13    25
#> 
#> 
#> # Proporciones observadas pretest x posttest
#>             +    - Total
#>    +     0.24 0.32  0.56
#>    -     0.24 0.20  0.44
#>    Total 0.48 0.52  1.00
#> 
#> # Test de McNemar: H₀:π₁₂=π₂₁
#>    Validez: n₁₂+n₂₁ = 14 > 10 el test es válido 
#>    Zexp =  0.4009 
#>                valor.p Alternativa
#>     Bilateral   0.6885  H₁:π₁₂≠π₂₁
#>     Unilateral  0.3442  H₁:π₁₂>π₂₁
#> 
#> 
#> # Test exacto de Fisher:
#>   H₀:π₁₂=0.5 para n₁₂ ~ B(n₁₂+n₂₁, π₁₂) 
#>                Valor.p Alternativa
#>     Bilateral   0.7905  H₁:π₁₂≠0.5
#>     Unilateral  0.3953  H₁:π₁₂>0.5
#>   ____
#>   * Aquí se alude a la probabilidad total de la discordancia, es decir que π₁₂+π₂₁=1
#> 
#> # Estimación de las proporciones individuales de discordancias π₁₂ y π₂₁ (método de Wald ajustado)
#>    [1] p₁₂ = 0.3448, 95%-IC(π₁₂) = (0.1718, 0.5178) 
#>    [2] p₂₁ = 0.2759, 95%-IC(π₂₁) = (0.1132, 0.4385) 
#> 
#> 
#> # Intervalo de confianza para la diferencia de 2 proporciones apareadas
#>    [1] Método de Wald (clásico con cpc):
#>       Estimación puntual de π₁₂-π₂₁ = 0.0800 
#>       Validez: n₁₂+n₂₁ = 14 > 5, el IC es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.2169, 0.3769) 
#> 
#>    [2] Método de Agresti-Min:
#>       Estimación puntual de π₁₂-π₂₁ = 0.0741 
#>       Validez: siempre es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.2057, 0.3538) 

# Determinacion del tamano muestral
testmcnemar(xpre,xpost,delta=0.05, beta=0.15)
#> 
#> 
#> # Inferencia con dos proporciones (muestras apareadas)
#> # ----------------------------------------------------
#> 
#> # Frecuencias observadas pretest x posttest
#>   Detectado 1 caso faltante en pretest 
#>   Detectado 1 caso faltante en posttest 
#>   Se eliminan las parejas con algún valor faltante 
#> 
#>             +    - Total
#>    +        6    8    14
#>    -        6    5    11
#>    Total   12   13    25
#> 
#> 
#> # Proporciones observadas pretest x posttest
#>             +    - Total
#>    +     0.24 0.32  0.56
#>    -     0.24 0.20  0.44
#>    Total 0.48 0.52  1.00
#> 
#> # Test de McNemar: H₀:π₁₂=π₂₁
#>    Validez: n₁₂+n₂₁ = 14 > 10 el test es válido 
#>    Zexp =  0.4009 
#>                valor.p Alternativa
#>     Bilateral   0.6885  H₁:π₁₂≠π₂₁
#>     Unilateral  0.3442  H₁:π₁₂>π₂₁
#> 
#> 
#> # Test exacto de Fisher:
#>   H₀:π₁₂=0.5 para n₁₂ ~ B(n₁₂+n₂₁, π₁₂) 
#>                Valor.p Alternativa
#>     Bilateral   0.7905  H₁:π₁₂≠0.5
#>     Unilateral  0.3953  H₁:π₁₂>0.5
#>   ____
#>   * Aquí se alude a la probabilidad total de la discordancia, es decir que π₁₂+π₂₁=1
#> 
#> # Estimación de las proporciones individuales de discordancias π₁₂ y π₂₁ (método de Wald ajustado)
#>    [1] p₁₂ = 0.3448, 95%-IC(π₁₂) = (0.1718, 0.5178) 
#>    [2] p₂₁ = 0.2759, 95%-IC(π₂₁) = (0.1132, 0.4385) 
#> 
#> 
#> # Intervalo de confianza para la diferencia de 2 proporciones apareadas
#>    [1] Método de Wald (clásico con cpc):
#>       Estimación puntual de π₁₂-π₂₁ = 0.0800 
#>       Validez: n₁₂+n₂₁ = 14 > 5, el IC es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.2169, 0.3769) 
#> 
#>    [2] Método de Agresti-Min:
#>       Estimación puntual de π₁₂-π₂₁ = 0.0741 
#>       Validez: siempre es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.2057, 0.3538) 
#> 
#> 
#> # Estudio de la potencia: δ = 0.05 -> ±δ=[-0.05, 0.05], potencia θ = 0.85, α = 0.05
#>   70%-IC(π₁₂-π₂₁) = (-0.0739, 0.222) (método de Agresti-Min) 
#> 
#>      -(-[---|---]-)--    potencia < 85% 
#> 
#>     Leyenda:   --(---)--    --[---|---]--  
#>                 IC- IC+      -δ   0  +δ 
#> 
#> 
#> # Tamaño de muestra necesario para declarar significativa una diferencia δ
#>   Diferencia: δ = 0.05 
#>   Potencia: θ = 0.850 
#>   Error de tipo I: α = 0.050 
#> 
#>    [1] Estimación para la varianza máxima:  
#>       Asumiendo p₁₂ = 0.5250   p₂₁ = 0.4750 
#>       n ⩾ 3589 
#> 
#>    [2] Basado en la información muestral:  
#>       Asumiendo p₁₂ = 0.4885   p₂₁ = 0.4385 
#>       n ⩾ 3327 
#>   ____
#>   *Si se desea la estimación de n para el test unilateral, repetir
#>    el análisis indicando alfa=0.1000 y asumir el n obtenido.
```
