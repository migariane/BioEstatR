# Test con proporciones

Test para una proporcion o estudio de la homogeneidad de dos
proporciones binomiales independientes o dos proporciones apareadas.
(Texto intencionadamente sin tildes u otros caracteres especiales por la
incompatibilidad de los mapas de caracteres)

## Usage

``` r
testp(
  x = NULL,
  n = 0,
  x1 = NULL,
  n1 = 0,
  x2 = NULL,
  n2 = 0,
  grupos = NULL,
  x0 = NA,
  p0 = 0.5,
  par = FALSE,
  alfa = 0.05,
  conf = 1 - alfa,
  delta = 0,
  beta = 0.2,
  potencia = 1 - beta,
  decs = 3
)
```

## Arguments

- x:

  valor entero de casos favorables cuando se trata de una unica muestra
  o vector binario de observaciones .

- n:

  valor entero = tamano de muestra cuando esta es unica o vector con la
  tabla para test de McNemar

- x1:

  valor entero o vector: casos favorables en la muestra 1 o vector de
  observaciones.

- n1:

  valor entero: tamano de la muestra 1.

- x2:

  valor entero o vector: casos favorables en la muestra 2 o vector de
  observaciones

- n2:

  valor entero: tamano de la muestra 2.

- grupos:

  vector: variable de agrupacion o indicacion a la variable x1 o x2 que
  haga esta funcion

- x0:

  indicador de la categoria a analizar

- p0:

  valor de la proporcion para estimar n exclusivamente

- par:

  valor logico: indicador de muestras apareadas

- alfa:

  real en (0,1): Nivel de error de los intervalos (alternativa a conf)

- conf:

  real en (0,1): Nivel de confianza de los intervalos (alternativa a
  alfa)

- delta:

  real en (0,1): Diferencia a detectar (tamano del efecto)

- beta:

  real en (0,1): Nivel de error de tipo II (alternativa a indicar la
  potencia)

- potencia:

  real en (0,1): Nivel de potencia (alternativa a indicar el error de
  tipo II)

- decs:

  entero: Numero de decimales en las salidas

## Value

Informe con test e IC, estudio de la fiabilidad de la no significacion y
tamano de muestra

## References

Forthofer, R. N., & Lee, E. S. (1995). Introduction to Biostatistics.

## Examples

``` r

# test con una muestra
testp(x=30,n=70,p0=0.4)
#> 
#> # Test para contrastar una proporción binomial
#> # --------------------------------------------
#> 
#> # Información muestral
#>   n = 70
#>   x = 30   n-x=40
#>   p = 0.429; q = (1-p) = 0.571
#> 
#> # Test Ho:π=0.400
#>   [1] Método exacto
#>                       H1  Fexp Valor.p
#>     Cola derecha π>0.400 1.098   0.355
#>     Bilateral    π≠0.400     -   0.709
#> 
#>     95%-IC(π) = (0.315, 0.553) (método de Clooper-Pearson)
#> 
#>   [2] Método aproximado a la distribución normal
#>     Validez: min(nπ₀, n(1-π₀)) = 28.0 (>5, el método es válido)
#>     zexp = 0.366,  p  = 0.714
#> 
#>     95%-IC(π) = (0.313, 0.552) (método de Wilson)
#> 
testp(x=30,n=70,p0=0.4,delta=0.05,potencia=0.9)
#> 
#> # Test para contrastar una proporción binomial
#> # --------------------------------------------
#> 
#> # Información muestral
#>   n = 70
#>   x = 30   n-x=40
#>   p = 0.429; q = (1-p) = 0.571
#> 
#> # Test Ho:π=0.400
#>   [1] Método exacto
#>                       H1  Fexp Valor.p
#>     Cola derecha π>0.400 1.098   0.355
#>     Bilateral    π≠0.400     -   0.709
#> 
#>     95%-IC(π) = (0.315, 0.553) (método de Clooper-Pearson)
#> 
#>   [2] Método aproximado a la distribución normal
#>     Validez: min(nπ₀, n(1-π₀)) = 28.0 (>5, el método es válido)
#>     zexp = 0.366,  p  = 0.714
#> 
#>     95%-IC(π) = (0.313, 0.552) (método de Wilson)
#> 
#> 
#> # Tamaño de muestra para detectar |π-p₀|=δ
#>   p₀ = 0.400;  δ = 0.05
#>   Casos (cpc = corrección por continuidad):
#>                             p1    n n_cpc
#>   1 Unilateral π<0.400   0.350  804   824
#>   2 Unilateral π>0.400   0.450  804   824
#>   3 Bilateral  π≠0.400   0.450 1022  1042
#> 

modos<-c("A","A","A","A","A","A","A","A","A","A","B","B","B","B")
edad <-c(5,4,8,6,7,4,5,4,5,6,9,6,5,4,5,6,4)

testp(x=modos, p0=0.4,delta=0.05,potencia=0.9)
#> 
#> # Test para contrastar una proporción binomial
#> # --------------------------------------------
#> 
#> # Información muestral
#>   No se ha especificado un criterio en x0. Se considera modos = 'A'
#>   n = 14
#>   x = 10   n-x=4
#>   p = 0.714; q = (1-p) = 0.286
#> 
#> # Test Ho:π=0.400
#>   [1] Método exacto
#>                       H1  Fexp Valor.p
#>     Cola derecha π>0.400 3.000   0.018
#>     Bilateral    π≠0.400     -   0.035
#> 
#>     95%-IC(π) = (0.446, 0.916) (método de Clooper-Pearson)
#> 
#>   [2] Método aproximado a la distribución normal
#>     Validez: min(nπ₀, n(1-π₀)) = 5.6 (>5, el método es válido)
#>     zexp = 2.128,  p  = 0.033
#> 
#>     95%-IC(π) = (0.449, 0.884) (método de Wald ajustado)
#> 
#> 
#> # Tamaño de muestra para detectar |π-p₀|=δ
#>   p₀ = 0.400;  δ = 0.05
#>   Casos (cpc = corrección por continuidad):
#>                             p1    n n_cpc
#>   1 Unilateral π<0.400   0.350  804   824
#>   2 Unilateral π>0.400   0.450  804   824
#>   3 Bilateral  π≠0.400   0.450 1022  1042
#> 
testp(x=edad, x0=6,p0=0.5, delta=0.05,potencia=0.9)
#> 
#> # Test para contrastar una proporción binomial
#> # --------------------------------------------
#> 
#> # Información muestral
#>   Inferencia sobre la proporción π de valores edad ⩽ 6
#>   n = 17
#>   x = 14   n-x=3
#>   p = 0.824; q = (1-p) = 0.176
#> 
#> # Test Ho:π=0.500
#>   [1] Método exacto
#>                       H1  Fexp Valor.p
#>     Cola derecha π>0.500 3.500   0.006
#>     Bilateral    π≠0.500     -   0.013
#> 
#>     95%-IC(π) = (0.612, 0.962) (método de Clooper-Pearson)
#> 
#>   [2] Método aproximado a la distribución normal
#>     Validez: min(nπ₀, n(1-π₀)) = 8.5 (>5, el método es válido)
#>     zexp = 2.425,  p  = 0.015
#> 
#>     95%-IC(π) = (0.580, 0.944) (método de Wald ajustado)
#> 
#> 
#> # Tamaño de muestra para detectar |π-p₀|=δ
#>   p₀ = 0.500;  δ = 0.05
#>   Casos (cpc = corrección por continuidad):
#>                             p1    n n_cpc
#>   1 Unilateral π<0.500   0.450  853   873
#>   2 Unilateral π>0.500   0.550  853   873
#>   3 Bilateral  π≠0.500   0.450 1047  1067
#> 
testp(x=as.factor(edad), x0=6,p0=0.5, delta=0.05,potencia=0.9)
#> 
#> # Test para contrastar una proporción binomial
#> # --------------------------------------------
#> 
#> # Información muestral
#>   Inferencia sobre la proporción π de valores as.factor(edad) = '6'
#>   n = 17
#>   x = 4   n-x=13
#>   p = 0.235; q = (1-p) = 0.765
#> 
#> # Test Ho:π=0.500
#>   [1] Método exacto
#>                         H1  Fexp Valor.p
#>     Cola izquierda π<0.500 2.600   0.025
#>     Bilateral      π≠0.500     -   0.049
#> 
#>     95%-IC(π) = (0.068, 0.499) (método de Clooper-Pearson)
#> 
#>   [2] Método aproximado a la distribución normal
#>     Validez: min(nπ₀, n(1-π₀)) = 8.5 (>5, el método es válido)
#>     zexp = 1.940,  p  = 0.052
#> 
#>     95%-IC(π) = (0.092, 0.479) (método de Wald ajustado)
#> 
#> 
#> # Tamaño de muestra para detectar |π-p₀|=δ
#>   p₀ = 0.500;  δ = 0.05
#>   Casos (cpc = corrección por continuidad):
#>                             p1    n n_cpc
#>   1 Unilateral π<0.500   0.450  853   873
#>   2 Unilateral π>0.500   0.550  853   873
#>   3 Bilateral  π≠0.500   0.450 1047  1067
#> 

testp(p0=0.65,delta=0.05,potencia=0.9)  #solo tamano de muestra
#> 
#> # Tamaño de muestra para detectar |π-p₀|=δ
#> # ----------------------------------------
#>   p₀ = 0.650;  δ = 0.05
#>   Casos (cpc = corrección por continuidad):
#>                             p1   n n_cpc
#>   1 Unilateral π<0.650   0.600 798   818
#>   2 Unilateral π>0.650   0.700 798   818
#>   3 Bilateral  π≠0.650   0.600 977   997
#> 
testp(p0=0.5,delta=0.05,alfa=0.05,potencia=0.9)
#> 
#> # Tamaño de muestra para detectar |π-p₀|=δ
#> # ----------------------------------------
#>   p₀ = 0.500;  δ = 0.05
#>   Casos (cpc = corrección por continuidad):
#>                             p1    n n_cpc
#>   1 Unilateral π<0.500   0.450  853   873
#>   2 Unilateral π>0.500   0.550  853   873
#>   3 Bilateral  π≠0.500   0.450 1047  1067
#> 

# 2 muestras independientes ---
fumaH=c("S","N","N","N","N","N","S","N","S","N","S","N","S","N","S","N","N")
fumaM=c("N","N","N","N","N","N","S","S","S","S","S","N","N","S","N","N","S")
testp(x1=fumaH,x2=fumaM)
#> 
#> [!] Las muestras m1 y m2 tienen el mismo tamaño, pero no se ha indicado 
#>     par=TRUE. Se asume que las muestras son independientes. 
#> 
#> # Test para contrastar la diferencia de dos proporciones independientes
#> # ---------------------------------------------------------------------
#> 
#> # Información muestral
#> 
#>   [!] No se ha especificado la categoría a estudiar. Se considera 'N'
#> 
#> 
#>   Tabla de contingencia de Respuesta['N','S'] x Muestra['fumaH','fumaM'] 
#>   Muestra Respuesta
#>           N   S Total
#>   fumaH  11   6    17
#>   fumaM  10   7    17
#>   Total  21  13    34
#> 
#> 
#> # Estimación para Respuesta = 'N' 
#> 
#>   Muestra = fumaH
#>   p₁ = 0.647  (q₁=1-p₁ = 0.353) 
#>   95%-IC(π₁) = (0.411, 0.827)
#> 
#>   Muestra = fumaM
#>   p₂ = 0.588  (q₂=1-p₂ = 0.412)
#>   95%-IC(π₂) = (0.36, 0.783)
#>   ____
#>   * Intervalos obtenidos por el método de Wald ajustado (Agresti-Coull)
#> 
#> 
#> # Test de homogeneidad para contrastar Ho:π₁=π₂ (π₁-π₂=0)
#>   p|H₀ = 0.618  (q|H₀ = 0.382) 
#>   Método: 
#>                                 Zexp   cpc   cdv p.bilat b p.unilat u
#>   Condicionado exacto (Fisher)     -     -     -   1.000 ✓    0.500 ✓
#>   Condicionado adn (Yates)     0.000 0.059 E<8.8   1.000 ✓    0.500 x
#>   Incondicionado adn           0.311 0.007 E<7.7   0.756 x    0.378 x
#>   ____
#>   *   Alternativas: bilateral H₁:π₁≠π₂; unilateral H₁:π₁>π₂
#>   **  E=6.5 es la frecuencia mínima esperada bajo H₀
#>   *** adn = aproximación a la distribución normal
#> 
#> 
#> # Estimación de la diferencia p₁-p₂=0.059
#>   Aproximación a la distribución normal (válido): 
#>   95%-IC(π₁-π₂) = (-0.326, 0.444) 
#> 
#>   Método de Agresti-Caffo: 
#>   95%-IC(π₁-π₂) = (-0.258, 0.364) 
#> 
#> 
testp(x1=fumaH,x2=fumaM,x0="S")
#> 
#> [!] Las muestras m1 y m2 tienen el mismo tamaño, pero no se ha indicado 
#>     par=TRUE. Se asume que las muestras son independientes. 
#> 
#> # Test para contrastar la diferencia de dos proporciones independientes
#> # ---------------------------------------------------------------------
#> 
#> # Información muestral
#> 
#>   Tabla de contingencia de Respuesta['S','N'] x Muestra['fumaH','fumaM'] 
#>   Muestra Respuesta
#>           S   N Total
#>   fumaH   6  11    17
#>   fumaM   7  10    17
#>   Total  13  21    34
#> 
#> 
#> # Estimación para Respuesta = 'S' 
#> 
#>   Muestra = fumaH
#>   p₁ = 0.353  (q₁=1-p₁ = 0.647) 
#>   95%-IC(π₁) = (0.173, 0.589)
#> 
#>   Muestra = fumaM
#>   p₂ = 0.412  (q₂=1-p₂ = 0.588)
#>   95%-IC(π₂) = (0.217, 0.64)
#>   ____
#>   * Intervalos obtenidos por el método de Wald ajustado (Agresti-Coull)
#> 
#> 
#> # Test de homogeneidad para contrastar Ho:π₁=π₂ (π₂-π₁=0)
#>   p|H₀ = 0.382  (q|H₀ = 0.618) 
#>   Método: 
#>                                 Zexp   cpc   cdv p.bilat b p.unilat u
#>   Condicionado exacto (Fisher)     -     -     -   1.000 ✓    0.500 ✓
#>   Condicionado adn (Yates)     0.000 0.059 E<8.8   1.000 ✓    0.500 x
#>   Incondicionado adn           0.311 0.007 E<7.7   0.756 x    0.378 x
#>   ____
#>   *   Alternativas: bilateral H₁:π₁≠π₂; unilateral H₁:π₁<π₂
#>   **  E=6.5 es la frecuencia mínima esperada bajo H₀
#>   *** adn = aproximación a la distribución normal
#> 
#> 
#> # Estimación de la diferencia p₂-p₁=0.059
#>   Aproximación a la distribución normal (válido): 
#>   95%-IC(π₂-π₁) = (-0.444, 0.326) 
#> 
#>   Método de Agresti-Caffo: 
#>   95%-IC(π₂-π₁) = (-0.364, 0.258) 
#> 
#> 

sexo=c("H","H","H","M","M","H","M","M","H","H","M","M","M","M","H","M",
       "M","M","M","M","H","M","H","H","H","H")
fuma=c("S","N","S","S","N","N","S","N","S","S","N","N","N","N","S","N",
       "N","N","S","N","S","N","S","N","N","N")
testp(x=fuma,grupos=sexo, x0="S")
#> 
#> # Test para contrastar la diferencia de dos proporciones independientes
#> # ---------------------------------------------------------------------
#> 
#> # Información muestral
#> 
#>   Tabla de contingencia de fuma['S','N'] x sexo['H','M'] 
#>   sexo    fuma
#>           S   N Total
#>   H       7   5    12
#>   M       3  11    14
#>   Total  10  16    26
#> 
#> 
#> # Estimación para fuma = 'S' 
#> 
#>   sexo = H
#>   p₁ = 0.583  (q₁=1-p₁ = 0.417) 
#>   95%-IC(π₁) = (0.319, 0.806)
#> 
#>   sexo = M
#>   p₂ = 0.214  (q₂=1-p₂ = 0.786)
#>   95%-IC(π₂) = (0.071, 0.485)
#>   ____
#>   * Intervalos obtenidos por el método de Wald ajustado (Agresti-Coull)
#> 
#> 
#> # Test de homogeneidad para contrastar Ho:π₁=π₂ (π₁-π₂=0)
#>   p|H₀ = 0.385  (q|H₀ = 0.615) 
#>   Método: 
#>                                 Zexp   cpc   cdv p.bilat b p.unilat u
#>   Condicionado exacto (Fisher)     -     -     -   0.105 ✓    0.063 ✓
#>   Condicionado adn (Yates)     1.524 0.077 E<8.8   0.128 ✓    0.064 x
#>   Incondicionado adn           1.897 0.006 E<7.7   0.058 x    0.029 x
#>   ____
#>   *   Alternativas: bilateral H₁:π₁≠π₂; unilateral H₁:π₁>π₂
#>   **  E=4.6 es la frecuencia mínima esperada bajo H₀
#>   *** adn = aproximación a la distribución normal
#> 
#> 
#> # Estimación de la diferencia p₁-p₂=0.369
#>   Aproximación a la distribución normal (NO es válido): 
#>   95%-IC(π₁-π₂) = (-0.06, 0.799) 
#> 
#>   Método de Agresti-Caffo: 
#>   95%-IC(π₁-π₂) = (-0.013, 0.659) 
#> 
#> 
testp(x=fuma,grupos=sexo, x0="N")
#> 
#> # Test para contrastar la diferencia de dos proporciones independientes
#> # ---------------------------------------------------------------------
#> 
#> # Información muestral
#> 
#>   Tabla de contingencia de fuma['N','S'] x sexo['H','M'] 
#>   sexo    fuma
#>           N   S Total
#>   H       5   7    12
#>   M      11   3    14
#>   Total  16  10    26
#> 
#> 
#> # Estimación para fuma = 'N' 
#> 
#>   sexo = H
#>   p₁ = 0.417  (q₁=1-p₁ = 0.583) 
#>   95%-IC(π₁) = (0.194, 0.681)
#> 
#>   sexo = M
#>   p₂ = 0.786  (q₂=1-p₂ = 0.214)
#>   95%-IC(π₂) = (0.515, 0.929)
#>   ____
#>   * Intervalos obtenidos por el método de Wald ajustado (Agresti-Coull)
#> 
#> 
#> # Test de homogeneidad para contrastar Ho:π₁=π₂ (π₂-π₁=0)
#>   p|H₀ = 0.615  (q|H₀ = 0.385) 
#>   Método: 
#>                                 Zexp   cpc   cdv p.bilat b p.unilat u
#>   Condicionado exacto (Fisher)     -     -     -   0.105 ✓    0.063 ✓
#>   Condicionado adn (Yates)     1.524 0.077 E<8.8   0.128 ✓    0.064 x
#>   Incondicionado adn           1.897 0.006 E<7.7   0.058 x    0.029 x
#>   ____
#>   *   Alternativas: bilateral H₁:π₁≠π₂; unilateral H₁:π₁<π₂
#>   **  E=4.6 es la frecuencia mínima esperada bajo H₀
#>   *** adn = aproximación a la distribución normal
#> 
#> 
#> # Estimación de la diferencia p₂-p₁=0.369
#>   Aproximación a la distribución normal (NO es válido): 
#>   95%-IC(π₂-π₁) = (-0.799, 0.06) 
#> 
#>   Método de Agresti-Caffo: 
#>   95%-IC(π₂-π₁) = (-0.659, 0.013) 
#> 
#> 

a<-rbinom(250,1,0.4)
b<-rbinom(250,1,0.6)
testp(x1=a,x2=b,x0=1)
#> 
#> [!] Las muestras m1 y m2 tienen el mismo tamaño, pero no se ha indicado 
#>     par=TRUE. Se asume que las muestras son independientes. 
#> 
#> # Test para contrastar la diferencia de dos proporciones independientes
#> # ---------------------------------------------------------------------
#> 
#> # Información muestral
#> 
#>   Tabla de contingencia de Respuesta['1','0'] x Muestra['a','b'] 
#>   Muestra Respuesta
#>           1   0 Total
#>   a      93 157   250
#>   b     142 108   250
#>   Total 235 265   500
#> 
#> 
#> # Estimación para Respuesta = '1' 
#> 
#>   Muestra = a
#>   p₁ = 0.372  (q₁=1-p₁ = 0.628) 
#>   95%-IC(π₁) = (0.315, 0.434)
#> 
#>   Muestra = b
#>   p₂ = 0.568  (q₂=1-p₂ = 0.432)
#>   95%-IC(π₂) = (0.506, 0.628)
#>   ____
#>   * Intervalos obtenidos por el método de Wald ajustado (Agresti-Coull)
#> 
#> 
#> # Test de homogeneidad para contrastar Ho:π₁=π₂ (π₂-π₁=0)
#>   p|H₀ = 0.470  (q|H₀ = 0.530) 
#>   Método: 
#>                                 Zexp    cpc   cdv  p.bilat b p.unilat u
#>   Condicionado exacto (Fisher)     -      -     -  < 0.001 ✓  < 0.001 ✓
#>   Condicionado adn (Yates)     4.301  0.004 E>8.8  < 0.001 ✓  < 0.001 ✓
#>   Incondicionado adn           4.390 <0.001 E>7.7  < 0.001 ✓  < 0.001 ✓
#>   ____
#>   *   Alternativas: bilateral H₁:π₁≠π₂; unilateral H₁:π₁<π₂
#>   **  E=117.5 es la frecuencia mínima esperada bajo H₀
#>   *** adn = aproximación a la distribución normal
#> 
#> 
#> # Estimación de la diferencia p₂-p₁=0.196
#>   Aproximación a la distribución normal (válido): 
#>   95%-IC(π₂-π₁) = (-0.286, -0.106) 
#> 
#>   Método de Agresti-Caffo: 
#>   95%-IC(π₂-π₁) = (-0.28, -0.109) 
#> 
#> 



#'# 2 muestras apareadas ----
testp(n=c(12,35,43,20), par=TRUE, delta=0.05)
#> 
#> 
#> # Inferencia con dos proporciones (muestras apareadas)
#> # ----------------------------------------------------
#> 
#> # Frecuencias observadas pretest x posttest
#>             +    - Total
#>    +       12   35    47
#>    -       43   20    63
#>    Total   55   55   110
#> 
#> 
#> # Proporciones observadas pretest x posttest
#>              +     - Total
#>    +     0.109 0.318 0.427
#>    -     0.391 0.182 0.573
#>    Total 0.500 0.500 1.000
#> 
#> # Test de McNemar: H₀:π₁₂=π₂₁
#>    Validez: n₁₂+n₂₁ = 78 > 10 el test es válido 
#>    Zexp =  0.849 
#>                valor.p Alternativa
#>     Bilateral    0.396  H₁:π₁₂≠π₂₁
#>     Unilateral   0.198  H₁:π₁₂<π₂₁
#> 
#> 
#> # Test exacto de Fisher:
#>   H₀:π₁₂=0.5 para n₁₂ ~ B(n₁₂+n₂₁, π₁₂) 
#>                Valor.p Alternativa
#>     Bilateral    0.443  H₁:π₁₂≠0.5
#>     Unilateral   0.214  H₁:π₁₂<0.5
#>   ____
#>   * Aquí se alude a la probabilidad total de la discordancia, es decir que π₁₂+π₂₁=1
#> 
#> # Estimación de las proporciones individuales de discordancias π₁₂ y π₂₁ (método de Wald ajustado)
#>    [1] p₁₂ = 0.325, 95%-IC(π₁₂) = (0.239, 0.411) 
#>    [2] p₂₁ = 0.395, 95%-IC(π₂₁) = (0.305, 0.484) 
#> 
#> 
#> # Intervalo de confianza para la diferencia de 2 proporciones apareadas
#>    [1] Método de Wald (clásico con cpc):
#>       Estimación puntual de π₁₂-π₂₁ = -0.073 
#>       Validez: n₁₂+n₂₁ = 78 > 5, el IC es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.230, 0.085) 
#> 
#>    [2] Método de Agresti-Min:
#>       Estimación puntual de π₁₂-π₂₁ = -0.071 
#>       Validez: siempre es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.226, 0.084) 
#> 
#> 
#> # Estudio de la potencia: δ = 0.05 -> ±δ=[-0.05, 0.05], potencia θ = 0.8, α = 0.05
#>   60%-IC(π₁₂-π₂₁) = (-0.138, -0.005) (método de Agresti-Min) 
#> 
#>      -(--[-)-|---]---    potencia < 80% 
#> 
#>     Leyenda:   --(---)--    --[---|---]--  
#>                 IC- IC+      -δ   0  +δ 
#> 
#> 
#> # Tamaño de muestra necesario para declarar significativa una diferencia δ
#>   Diferencia: δ = 0.05 
#>   Potencia: θ = 0.800 
#>   Error de tipo I: α = 0.050 
#> 
#>    [1] Estimación para la varianza máxima:  
#>       Asumiendo p₁₂ = 0.475   p₂₁ = 0.525 
#>       n ⩾ 3138 
#> 
#>    [2] Basado en la información muestral:  
#>       Asumiendo p₁₂ = 0.411   p₂₁ = 0.461 
#>       n ⩾ 2733 
#>   ____
#>   *Si se desea la estimación de n para el test unilateral, repetir
#>    el análisis indicando alfa=0.100 y asumir el n obtenido.
testp(x1=150,n1=450,x2=34,n2=49, par=TRUE)
#> 
#> 
#> # Inferencia con dos proporciones (muestras apareadas)
#> # ----------------------------------------------------
#> 
#> # Frecuencias observadas pretest x posttest
#>             +    - Total
#>    +      150  300   450
#>    -       34   15    49
#>    Total  184  315   499
#> 
#> 
#> # Proporciones observadas pretest x posttest
#>              +     - Total
#>    +     0.301 0.601 0.902
#>    -     0.068 0.030 0.098
#>    Total 0.369 0.631 1.000
#> 
#> # Test de McNemar: H₀:π₁₂=π₂₁
#>    Validez: n₁₂+n₂₁ = 334 > 10 el test es válido 
#>    Zexp =  14.528 
#>                 valor.p Alternativa
#>     Bilateral   < 0.001  H₁:π₁₂≠π₂₁
#>     Unilateral  < 0.001  H₁:π₁₂>π₂₁
#> 
#> 
#> # Test exacto de Fisher:
#>   H₀:π₁₂=0.5 para n₁₂ ~ B(n₁₂+n₂₁, π₁₂) 
#>                 Valor.p Alternativa
#>     Bilateral   < 0.001  H₁:π₁₂≠0.5
#>     Unilateral  < 0.001  H₁:π₁₂>0.5
#>   ____
#>   * Aquí se alude a la probabilidad total de la discordancia, es decir que π₁₂+π₂₁=1
#> 
#> # Estimación de las proporciones individuales de discordancias π₁₂ y π₂₁ (método de Wald ajustado)
#>    [1] p₁₂ = 0.600, 95%-IC(π₁₂) = (0.558, 0.643) 
#>    [2] p₂₁ = 0.072, 95%-IC(π₂₁) = (0.049, 0.094) 
#> 
#> 
#> # Intervalo de confianza para la diferencia de 2 proporciones apareadas
#>    [1] Método de Wald (clásico con cpc):
#>       Estimación puntual de π₁₂-π₂₁ = 0.533 
#>       Validez: n₁₂+n₂₁ = 334 > 5, el IC es válido 
#>       95%-IC(π₁₂-π₂₁) = (0.479, 0.588) 
#> 
#>    [2] Método de Agresti-Min:
#>       Estimación puntual de π₁₂-π₂₁ = 0.531 
#>       Validez: siempre es válido 
#>       95%-IC(π₁₂-π₂₁) = (0.476, 0.585) 

fuma1<-c("S","S","S","N","S","N","S","S","S","N","S","N","S","N","S","N","N",
         "N","N","S","N","N","N","S","S","S","S","S","N","N","S","N","N","S")
fuma2<-c("N","N","S","N","N","S","S","N","S","N","S","N","S","N","N","N","N",
         "N","N","N","N","N","S","N","N","N","N","N","N","N","N","N","N","S")
testp(x1=fuma1,x2=fuma2,par=TRUE)
#> 
#> 
#> # Inferencia con dos proporciones (muestras apareadas)
#> # ----------------------------------------------------
#> 
#> # Frecuencias observadas fuma1 x fuma2
#>             +    - Total
#>    +       14    2    16
#>    -       12    6    18
#>    Total   26    8    34
#> 
#> 
#> # Proporciones observadas fuma1 x fuma2
#>              +     - Total
#>    +     0.412 0.059 0.471
#>    -     0.353 0.176 0.529
#>    Total 0.765 0.235 1.000
#> 
#> # Test de McNemar: H₀:π₁₂=π₂₁
#>    Validez: n₁₂+n₂₁ = 14 > 10 el test es válido 
#>    Zexp =  2.539 
#>                valor.p Alternativa
#>     Bilateral    0.011  H₁:π₁₂≠π₂₁
#>     Unilateral   0.006  H₁:π₁₂<π₂₁
#> 
#> 
#> # Test exacto de Fisher:
#>   H₀:π₁₂=0.5 para n₁₂ ~ B(n₁₂+n₂₁, π₁₂) 
#>                Valor.p Alternativa
#>     Bilateral    0.107  H₁:π₁₂≠0.5
#>     Unilateral   0.006  H₁:π₁₂<0.5
#>   ____
#>   * Aquí se alude a la probabilidad total de la discordancia, es decir que π₁₂+π₂₁=1
#> 
#> # Estimación de las proporciones individuales de discordancias π₁₂ y π₂₁ (método de Wald ajustado)
#>    [1] p₁₂ = 0.105, 95%-IC(π₁₂) = (0.008, 0.203) 
#>    [2] p₂₁ = 0.368, 95%-IC(π₂₁) = (0.215, 0.522) 
#> 
#> 
#> # Intervalo de confianza para la diferencia de 2 proporciones apareadas
#>    [1] Método de Wald (clásico con cpc):
#>       Estimación puntual de π₁₂-π₂₁ = -0.294 
#>       Validez: n₁₂+n₂₁ = 14 > 5, el IC es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.490, -0.098) 
#> 
#>    [2] Método de Agresti-Min:
#>       Estimación puntual de π₁₂-π₂₁ = -0.278 
#>       Validez: siempre es válido 
#>       95%-IC(π₁₂-π₂₁) = (-0.468, -0.087) 
```
