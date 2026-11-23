# News

# BioEstatR 1.0.3
* Nuevas funciones de analisis descriptivo:
  * `descriptiva`: rutina global de estadistica descriptiva. Para cada variable de un vector o
    de un data.frame devuelve, segun su naturaleza, el tamano muestral valido, los valores
    faltantes, las medidas de tendencia central y de dispersion (incluido el coeficiente de
    variacion), los cuantiles, el rango intercuartilico, las medidas de forma, el numero de
    valores atipicos y, opcionalmente, el intervalo de confianza para la media y la prueba de
    normalidad. Admite un factor de agrupacion y variables cualitativas, de las que devuelve la
    tabla de frecuencias absolutas y relativas.
  * `forma`: coeficientes de asimetria y curtosis muestrales corregidos (insesgados), con sus
    errores tipicos, el contraste z de significacion, la interpretacion cualitativa y la prueba
    de normalidad. Los valores coinciden con `e1071::skewness(type = 2)` y
    `e1071::kurtosis(type = 2)` (definicion de SPSS/Excel).
  * `posicion`: cuantiles configurables (cuartiles, deciles o percentiles), rango intercuartilico
    y deteccion de valores atipicos leves y graves por el criterio de Tukey, coherente con
    `boxplot.stats`.
* Documentacion: `osteo` incorpora ejemplos de uso; se corrigen ejemplos que faltaban.
* Se elimina de la documentacion la funcion interna `get_msg` (marcada como `@noRd`).
* Pruebas de regresion (`testthat`) para las tres funciones nuevas, contrastadas contra
  `e1071`, `t.test`, `quantile`, `IQR` y `boxplot.stats`.

## Aplicacion interactiva (Shiny)

* Nueva pestana **Mis datos** como segunda entrada de la barra superior y reordenacion de la navegacion.
* **Prueba t para muestras relacionadas** (medidas repetidas): admite medias, desviaciones estandar y correlacion, o directamente la media y DE de la diferencia.
* **Estudio de potencia y tamano muestral** (`delta`, `potencia`) integrado en las pruebas t de una y dos muestras y de medidas repetidas.
* Las pruebas t pueden ejecutarse directamente sobre **variables de un `data.frame`** cargado (variable unica, respuesta + factor de grupo, o dos variables apareadas).
* Nueva imagen corporativa UGR (logotipo, colores y cabecera) y creditos de autoria y coautoria.
* Descarga de informes en Word (`.docx`) y texto (`.txt`) y visualizacion del codigo R reproducible.

# BioEstatR 1.0.2
* `tabla2x2`: correccion de bug — el valor de p mostrado para el chi-cuadrado sin correccion por continuidad se calculaba a partir del estadistico con correccion de Yates.
* `icpexact` (IC exacto de Clopper-Pearson): grados de libertad corregidos en el limite inferior (`2*(n-x+1)`); los bordes x=0 y x=n pasan a ser bilaterales (alfa/2), consistentes con `stats::binom.test`.
* `icl` (IC exacto de Poisson): el limite superior cuando la suma de observaciones es 0 pasa a ser bilateral (alfa/2), consistente con `stats::poisson.test`.
* `rls`: admite valores faltantes en los vectores de entrada (se analizan las parejas completas, coherente con `lm()`).
* `rlm`: la tabla descriptiva inicial admite predictores factor.
* `nl`: el modo silencioso (`eco=FALSE`) devuelve valores tambien cuando solo se indica `lmax`.
* Pruebas de regresion numerica (testthat) para los procedimientos corregidos y los ICs principales, contrastadas contra `binom.test`, `prop.test`, `poisson.test`, `lm` y valores de referencia.
* Vignette introductoria actualizada.

# BioEstatR 1.0.1
* Corrección de error en `grpsggp` al manejar escalares en el parámetro `se`.
* Actualización de terminología: "multivariable" a "multiple" en `rlogitm` y "regresión lineal múltiple" en `rlm`.
* Añadidas referencias cruzadas (`@seealso`) en toda la documentación de funciones exportadas.
* Inclusión de referencias científicas (`@references`) para todas las funciones exportadas.
* Estructura de pruebas unitarias (`testthat`) para todas las funciones exportadas.
* Actualización de la viñeta introductoria.

# BioEstatR 1.0.0
* Versión inicial del paquete.
