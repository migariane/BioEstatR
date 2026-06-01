# Analisis de una tabla de contingencia 2x2

Analisis de tablas 2x2. Texto intencionadamente sin tildes u otros
caracteres especiales por la incompatibilidad de los mapas de
caracteres.

## Usage

``` r
tabla2x2(
  frecs = NULL,
  fvar = NULL,
  cvar = NULL,
  o = NULL,
  o11 = 0,
  o12 = 0,
  o21 = 0,
  o22 = 0,
  fcat = c("F1", "F2"),
  ccat = c("C1", "C2"),
  estudio = "T",
  tablas = "",
  medidas = TRUE,
  alfa = 0.05,
  conf = 0.95,
  decs = 3,
  ptol = 0.001
)
```

## Arguments

- frecs:

  data.frame: data.frame con frecuencias observadas

- fvar:

  vector de enteros o factores: Variable por filas

- cvar:

  vector de enteros o factores: Variable por columnas

- o:

  vector de enteros: Vector de frecuencias observadas con la
  organizacion (o11,o12,o21,o22)

- o11:

  entero: frecuencia observada en la fila 1 y columna 1

- o12:

  entero: frecuencia observada en la fila 1 y columna 2

- o21:

  entero: frecuencia observada en la fila 2 y columna 1

- o22:

  entero: frecuencia observada en la fila 2 y columna 2

- fcat:

  vector de cadenas de texto: Nombres de fila

- ccat:

  vector de cadenas de texto: Nombres de columna

- estudio:

  caracter: Tipo de estudio "T"=transversal, "P"=prospectivo,
  "R"=retrospectivo

- tablas:

  vector de caracter: "E"=frecs. esperadas, "R","S","X", residuos de
  Pearson, estandarizados y contribucion X2; "F", "C", "T" porcentajes
  por filas, columnas y totales

- medidas:

  valor logico: si es TRUE/FALSE se muestran/omiten las medidas de
  asociacion

- alfa:

  real en (0,1): Nivel de error de los intervalos (alternativa a conf)

- conf:

  real en (0,1): Nivel de confianza de los intervalos (alternativa a
  alfa)

- decs:

  entero: Numero de decimales en las salidas

- ptol:

  decimal en (0,1): Tolerancia para resumir el valor de p

## Value

Informe analisis de tablas 2x2 mediante tests Chi2 y exacto de Fisher
con medidas de asociacion

## References

Agresti, A. (2013). Categorical Data Analysis.

## Examples

``` r
# [1] Formato esperado de la tabla (presencia de enfermedad
# (variable respuesta) vs exposicion a factor de riesgo (var. factor))
#
#             Expuestos      No Expuestos
#--------------------------------------------
# Enfermos        o11           o12
# Sanos           o21           o22
# --------------------------------------------
#
#[1a] Introduccion de frecuencias individuales en estudio transversal,
#     se piden porcentajes por filas
tabla2x2(o11=20, o12=26, o21=60, o22=294, estudio = "T", tablas="F")
#> 
#> # Análisis de tablas 2x2
#> # ----------------------
#> 
#> # Frecuencias observadas
#>           C1   C2 Total
#>   F1      20   26    46
#>   F2      60  294   354
#>   Total   80  320   400
#> 
#> 
#> # Test Chi-cuadrado para un estudio transversal
#> 
#>   χ² = 17.903,   gl = 1,  p < 0.001, (cpc = 0.5) 
#>   Validez: Frecuencia mínima esperada = 9.20  > 3.9  
#> 
#>   Test exacto de Fisher (bilateral): p < 0.001 
#> 
#>   --- Otros criterios χ²:  
#>   χ² = 17.907,   gl = 1,  p < 0.001, (sin cpc) 
#>   χ² = 16.287,   gl = 1,  p < 0.001, (cpc de Yates = 200.00) 
#> 
#> # Porcentajes por filas
#>            C1    C2 Total
#>   F1    0.435 0.565 1.000
#>   F2    0.169 0.831 1.000
#>   Total 0.200 0.800 1.000
#> 
#> # Estimación de la prevalenciaπ en un estudio transversal
#>   Método de Wald ajustado: 
#>   p=0.119; 95%-IC(π)=(0.087, 0.150) 
#> 
#> # Medidas de asociación para un estudio transversal
#>   [!] Las medidas de riesgo se calculan como riesgo de la categoría  
#>       en la 1a columna (frente a la 2a) para la categoría en la 1a 
#>       fila (frente a la 2a)
#> 
#>   Riesgo absoluto (diferencia de Berkson; método de Agresti-Caffo): 
#>   d=0.169; 95%-IC(d)=(0.073, 0.271) 
#> 
#>   Riesgo relativo: 
#>   Rr=3.077; 95%-IC(Rr)=(1.818, 5.169) 
#> 
#>   Riesgo atribuible:
#>   Ra=0.293; 95%-IC(Ra)= (0.104, 0.443) 
#> 
#>   Razón del producto cruzado (odds ratio):
#>   OR=3.769; 95%-IC(OR)= (1.987, 7.137) 

#[1b] Los mismos datos introducidos como vector, pidiendo tambien
#     las frecuencias esperadas
tabla2x2(o=c(20, 26, 60,294), estudio = "T",fcat=c("Peso normal","Peso bajo"),
        ccat=c("fuma","No fuma"), tablas=c("F","E","S"))
#> 
#> # Análisis de tablas 2x2
#> # ----------------------
#> 
#> # Frecuencias observadas
#>                 fuma   No fuma Total
#>   Peso normal     20        26    46
#>   Peso bajo       60       294   354
#>   Total           80       320   400
#> 
#> # Frecuencias esperadas
#>                 fuma   No fuma Total
#>   Peso normal    9.2      36.8  46.0
#>   Peso bajo     70.8     283.2 354.0
#>   Total         80.0     320.0 400.0
#> 
#> 
#> # Test Chi-cuadrado para un estudio transversal
#> 
#>   χ² = 17.903,   gl = 1,  p < 0.001, (cpc = 0.5) 
#>   Validez: Frecuencia mínima esperada = 9.20  > 3.9  
#> 
#>   Test exacto de Fisher (bilateral): p < 0.001 
#> 
#>   --- Otros criterios χ²:  
#>   χ² = 17.907,   gl = 1,  p < 0.001, (sin cpc) 
#>   χ² = 16.287,   gl = 1,  p < 0.001, (cpc de Yates = 200.00) 
#> 
#> # Residuos estandarizados
#>                 fuma   No fuma
#>   Peso normal  4.232    -4.232
#>   Peso bajo   -4.232     4.232
#> 
#> # Porcentajes por filas
#>                 fuma   No fuma Total
#>   Peso normal  0.435     0.565 1.000
#>   Peso bajo    0.169     0.831 1.000
#>   Total        0.200     0.800 1.000
#> 
#> # Estimación de la prevalenciaπ en un estudio transversal
#>   Método de Wald ajustado: 
#>   p=0.119; 95%-IC(π)=(0.087, 0.150) 
#> 
#> # Medidas de asociación para un estudio transversal
#>   [!] Las medidas de riesgo se calculan como riesgo de la categoría  
#>       en la 1a columna (frente a la 2a) para la categoría en la 1a 
#>       fila (frente a la 2a)
#> 
#>   Riesgo absoluto (diferencia de Berkson; método de Agresti-Caffo): 
#>   d=0.169; 95%-IC(d)=(0.073, 0.271) 
#> 
#>   Riesgo relativo: 
#>   Rr=3.077; 95%-IC(Rr)=(1.818, 5.169) 
#> 
#>   Riesgo atribuible:
#>   Ra=0.293; 95%-IC(Ra)= (0.104, 0.443) 
#> 
#>   Razón del producto cruzado (odds ratio):
#>   OR=3.769; 95%-IC(OR)= (1.987, 7.137) 
tabla2x2(frecs=c(20, 26, 60,294), estudio = "T", tablas=c("F","E"))
#> 
#> # Análisis de tablas 2x2
#> # ----------------------
#> 
#> # Frecuencias observadas
#>           C1   C2 Total
#>   F1      20   26    46
#>   F2      60  294   354
#>   Total   80  320   400
#> 
#> # Frecuencias esperadas
#>            C1    C2 Total
#>   F1      9.2  36.8  46.0
#>   F2     70.8 283.2 354.0
#>   Total  80.0 320.0 400.0
#> 
#> 
#> # Test Chi-cuadrado para un estudio transversal
#> 
#>   χ² = 17.903,   gl = 1,  p < 0.001, (cpc = 0.5) 
#>   Validez: Frecuencia mínima esperada = 9.20  > 3.9  
#> 
#>   Test exacto de Fisher (bilateral): p < 0.001 
#> 
#>   --- Otros criterios χ²:  
#>   χ² = 17.907,   gl = 1,  p < 0.001, (sin cpc) 
#>   χ² = 16.287,   gl = 1,  p < 0.001, (cpc de Yates = 200.00) 
#> 
#> # Porcentajes por filas
#>            C1    C2 Total
#>   F1    0.435 0.565 1.000
#>   F2    0.169 0.831 1.000
#>   Total 0.200 0.800 1.000
#> 
#> # Estimación de la prevalenciaπ en un estudio transversal
#>   Método de Wald ajustado: 
#>   p=0.119; 95%-IC(π)=(0.087, 0.150) 
#> 
#> # Medidas de asociación para un estudio transversal
#>   [!] Las medidas de riesgo se calculan como riesgo de la categoría  
#>       en la 1a columna (frente a la 2a) para la categoría en la 1a 
#>       fila (frente a la 2a)
#> 
#>   Riesgo absoluto (diferencia de Berkson; método de Agresti-Caffo): 
#>   d=0.169; 95%-IC(d)=(0.073, 0.271) 
#> 
#>   Riesgo relativo: 
#>   Rr=3.077; 95%-IC(Rr)=(1.818, 5.169) 
#> 
#>   Riesgo atribuible:
#>   Ra=0.293; 95%-IC(Ra)= (0.104, 0.443) 
#> 
#>   Razón del producto cruzado (odds ratio):
#>   OR=3.769; 95%-IC(OR)= (1.987, 7.137) 

#[2]  Datos como variables o columnas de un data.frame
w1<-c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)
w2<-c(1,1,1,2,1,1,1,1,2,1,1,1,1,1,2,1,2,2,1,2,2,1,2,2,1,2,2,1,2,2,1,2,1,2,2,2)
tabla2x2(fvar=w1,cvar=w2)
#> 
#> # Análisis de tablas 2x2
#> # ----------------------
#> 
#> # Frecuencias observadas
#>           C1   C2 Total
#>   F1      12    2    14
#>   F2       7   15    22
#>   Total   19   17    36
#> 
#> 
#> # Test Chi-cuadrado para un estudio transversal
#> 
#>   χ² = 9.912,   gl = 1,  p = 0.002, (cpc = 0.5) 
#>   Validez: Frecuencia mínima esperada = 6.61  > 3.9  
#> 
#>   Test exacto de Fisher (bilateral): p = 0.002 
#> 
#>   --- Otros criterios χ²:  
#>   χ² = 9.972,   gl = 1,  p = 0.005, (sin cpc) 
#>   χ² = 7.926,   gl = 1,  p = 0.005, (cpc de Yates = 18.00) 
#> 
#> # Estimación de la prevalenciaπ en un estudio transversal
#>   Método de Wald ajustado: 
#>   p=0.400; 95%-IC(π)=(0.248, 0.552) 
#> 
#> # Medidas de asociación para un estudio transversal
#>   [!] Las medidas de riesgo se calculan como riesgo de la categoría  
#>       en la 1a columna (frente a la 2a) para la categoría en la 1a 
#>       fila (frente a la 2a)
#> 
#>   Riesgo absoluto (diferencia de Berkson; método de Agresti-Caffo): 
#>   d=0.514; 95%-IC(d)=(0.198, 0.728) 
#> 
#>   Riesgo relativo: 
#>   Rr=5.368; 95%-IC(Rr)=(1.356, 14.931) 
#> 
#>   Riesgo atribuible:
#>   Ra=0.697; 95%-IC(Ra)= (0.021, 0.906) 
#> 
#>   Razón del producto cruzado (odds ratio):
#>   OR=12.857; 95%-IC(OR)= (2.058, 51.886) 
#     Estudio retrospectivo solicitando porcentajes por filas
v1<-c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)
v2<-c(1,1,1,2,1,1,1,1,2,1,1,1,1,1,2,1,2,2,1,2,2,1,2,2,1,2,2,1,2,2,1,2,1,2,2,2)
tabla2x2(fvar=v1,cvar=v2, estudio="R", tablas="F")
#> 
#> # Análisis de tablas 2x2
#> # ----------------------
#> 
#> # Frecuencias observadas
#>           C1   C2 Total
#>   F1      12    2    14
#>   F2       7   15    22
#>   Total   19   17    36
#> 
#> 
#> # Test Chi-cuadrado para un estudio retrospectivo
#> 
#>   χ² = 9.852,   gl = 1,  p = 0.002, (cpc = 1) 
#>   Validez: Frecuencia mínima esperada = 6.61  < 7.7  Test χ² no valido 
#> 
#>   Test exacto de Fisher (bilateral): p = 0.002 
#> 
#>   --- Otros criterios χ²:  
#>   χ² = 9.972,   gl = 1,  p = 0.005, (sin cpc) 
#>   χ² = 7.926,   gl = 1,  p = 0.005, (cpc de Yates = 18.00) 
#> 
#> # Porcentajes por filas
#>            C1    C2 Total
#>   F1    0.857 0.143 1.000
#>   F2    0.318 0.682 1.000
#>   Total 0.528 0.472 1.000
#> 
#> # Medidas de asociación para un estudio retrospectivo
#> 
#>   Riesgo atribuible*: 
#>   Ra=0.582; 95%-IC(Ra)= (0.229, 0.774) 
#>   * La estimación de Ra para estudios retrospectivos es una aproximación válida si la prevalencia de la enfermedad es baja: P(E) < 10% 
#> 
#>   Razón del producto cruzado (odds ratio):
#>   OR=12.857; 95%-IC(OR)= (2.058, 51.886) 
#>   * La estimación para OR sirve de aproximación al riesgo relativo siempre que la prevalencia de la enfermedad sea P(E) < 10% 
```
