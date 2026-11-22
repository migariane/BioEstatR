# BioEstatR · Interfaz grafica para estudiantes

Aplicacion Shiny que permite usar las funciones del paquete **BioEstatR** sin
escribir codigo. Pensada para estudiantes de Bioestadistica (Facultad de
Medicina, Universidad de Granada).

## Acceso directo (sin instalar nada)

**https://watzile.shinyapps.io/bioestatr/**

Los estudiantes pueden abrirla desde cualquier navegador, sin R ni RStudio.

## Como abrirla en local

Desde R o RStudio:

```r
# 1. Instalar el paquete (si no esta instalado)
remotes::install_github("migariane/BioEstatR")

# 2. Instalar Shiny (si no esta instalado)
install.packages("shiny")

# 3. Lanzar la aplicacion
shiny::runApp("Scripts/BioEstatR/shiny")
```

En RStudio tambien puede abrir `app.R` y pulsar el boton **Run App**.

## Pestanas

| Pestana | Funciones | Para que sirve |
| --- | --- | --- |
| Inicio | — | Introduccion y guia de uso |
| Descriptiva | `descriptiva`, `freq` | Resumen de variables y tabla de frecuencias |
| Normalidad | `testnormal` | Shapiro-Wilk + histograma y QQ-plot |
| Medias | `testt` | t de Student, una y dos muestras |
| Proporciones | `testp` | Contraste de una proporcion |
| Intervalos | `icm`, `icp` | IC para media y proporcion |
| Tablas 2x2 | `tabla2x2` | Chi-cuadrado, OR, RR (transversal o casos-controles) |
| McNemar | `testmcnemar` | Datos apareados |
| Regresion | `rls`, `rlm`, `rlogits` | Lineal simple, multiple y logistica |
| Tamano muestral | `nm`, `np`, `nl` | n necesario a partir de muestra piloto |
| Mis datos | — | Cargar CSV / Excel o usar el dataset `osteo` |
| Ayuda | — | Conceptos basicos de inferencia |

## Detalles de uso

- **Codigo R en cada resultado.** Cada analisis tiene un desplegable
  *Ver el codigo R equivalente* para que el estudiante aprenda la instruccion
  que produce ese resultado y pueda reproducirlo en un script.
- **Datos.** Por defecto usa `osteo` (94 pacientes, 27 variables) incluido en el
  paquete. En *Mis datos* puede subir un CSV o Excel con sus propios datos.
- **Ficheros Excel.** La aplicacion lee `.xlsx` y `.xls` con el paquete `readxl`
  (incluido en el despliegue). Las columnas de texto se convierten
  automaticamente en factores para que funcionen las tablas de contingencia y la
  regresion logistica.
- **Tamano muestral.** `nm` y `np` requieren una *muestra piloto* (necesitan
  estimar la variabilidad); no aceptan una desviacion tipica supuesta.

## Descargar informes

Cada analisis tiene dos botones de descarga:

- **Descargar informe** — genera un `.docx` (Word) con el informe y el codigo R.
- **Texto (.txt)** — version en texto plano.

El fichero se nombra con la pestana y la fecha, por ejemplo
`BioEstatR_reg_20261122_2318.docx`, para que los estudiantes lo adjunten
facilmente a sus practicas.

## Despliegue en shinyapps.io

La aplicacion esta desplegada en `https://watzile.shinyapps.io/bioestatr/`.

Para volver a desplegar tras un cambio:

```r
rsconnect::deployApp("Scripts/BioEstatR/shiny", appName = "bioestatr")
```

**Nota importante:** BioEstatR no esta en CRAN, por lo que shinyapps.io no
puede instalarlo por si solo. La carpeta `BioEstatR_pkg/` incluye el tarball
`BioEstatR_1.0.3.tar.gz` y `app.R` lo instala al arrancar si falta. Si publica
una nueva version del paquete, regenere el tarball y sustituyalo:

```bash
cd Scripts/BioEstatR && R CMD build . --no-build-vignettes --no-manual
cp BioEstatR_<version>.tar.gz shiny/BioEstatR_pkg/
```

## Notas tecnicas

- Las funciones de BioEstatR imprimen informes con `cat()`, por lo que la
  aplicacion captura la salida por consola (`capture.output`) y la muestra como
  texto. Los `warning` se recogen y se anaden al final del informe.
- El grafico de normalidad usa graficos base de R, de modo que solo se necesita
  el paquete `shiny` ademas de `BioEstatR`.
