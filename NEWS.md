# News

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
