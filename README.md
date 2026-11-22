# BioEstatR (ver 1.0.3 - 11/2026)

## Biostatistics Routines in R

[![Aplicación interactiva](https://img.shields.io/badge/%E2%96%B6%20Abrir%20la%20aplicaci%C3%B3n%20interactiva-Shiny%20(online)-4c9f70?style=for-the-badge)](https://watzile.shinyapps.io/bioestatr/)
[![Sitio web](https://img.shields.io/badge/Sitio-web%20del%20paquete-0d6efd?style=for-the-badge)](https://migariane.github.io/BioEstatR/)
[![Libro](https://img.shields.io/badge/Libro-Matem%C3%A1tica%20Estad%C3%ADstica%20M%C3%A9dica%20con%20R-6f42c1?style=for-the-badge)](https://migariane.github.io/MatematicaEstadisticaMedicinaR/)

**Authors**: Pedro Femia, Miguel Angel Luque Fernandez
**Biostatistics Faculty of Medicine - University of Granada**

* Contacto: pfemia@ugr.es, mluquefe@ugr.es

**BioEstatR**: Bioestadística con R ha sido desarrollado como soporte docente para el libro [Matemática Estadística Médica con R](https://migariane.github.io/MatematicaEstadisticaMedicinaR/)
que es un texto de referencia para la estadística médica con R que cubre los conceptos básicos con rigor matemático y un enfoque computacional aplicado a la práctica de la medicina y las ciencias de la salud.
Para mayor informacion sobre el libro, visite el sitio web del libro o consulte el repositorio de GitHub del libro. 
La función principal de este paquete es proporcionar rutinas de bioestadística que se utilizan en el libro, pero también se pueden usar de forma independiente para análisis estadísticos en medicina y ciencias de la salud.
Para información sobre **BioEstatR** visite: [https://migariane.github.io/BioEstatR/](https://migariane.github.io/BioEstatR/)

### Aplicación interactiva para estudiantes (sin instalar R)

**https://watzile.shinyapps.io/bioestatr/**

Interfaz gráfica que permite usar todas las rutinas de BioEstatR seleccionando opciones con el ratón — pensada para prácticas y para estudiantes que no programán. Incluye descarga de informes en Word y carga de datos propios (CSV/Excel). El código de la aplicación está en [`shiny/`](shiny/).

## Introducción y Tutorial

Puede consultar la viñeta (tutorial) introductoria del paquete en: [Introducción a BioEstatR](https://migariane.github.io/BioEstatR/articles/BioEstatR-overview.html)  
Puede instalar la versión de desarrollo de BioEstatR desde [GitHub](https://github.com/migariane/BioEstatR) con:

```r
# install.packages("remotes")
remotes::install_github("migariane/BioEstatR")
```

*Nota: Se recomienda este metodo ya que construye automáticamente el paquete para su sistema operativo específico (Windows, macOS o Linux).*

## Cómo citar este paquete

Para obtener la referencia bibliográfica del paquete en R, ejecute:

```r
citation("BioEstatR")
```

Si necesita la referencia en formato BibTeX para su artículo académico, puede usar la siguiente estructura:

### Cita del paquete
```bibtex
@Manual{,
  title = {BioEstatR: Rutinas de bioestadística},
  author = {Pedro Jesús Femia Marzo & Miguel Ángel Luque Fernández},
  year = {2026},
  note = {R package version 1.0.3},
  url = {https://github.com/migariane/BioEstatR},
}
```

### Cita del libro de soporte
Si utiliza este paquete en su investigación, le agradeceríamos que cite también el libro de texto de soporte:

*   **Referencia:** Miguel Ángel Luque Fernández. *Matemática Estadística Médica con R*. 2026
*   **Enlace:** [Matemática Estadística Médica con R](https://migariane.github.io/MatematicaEstadisticaMedicinaR/)

