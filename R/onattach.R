.onAttach <- function(libname, pkgname) {
  msg <- paste(
    "--------------------------------------------------------------",
    "BioEstatR",
    "  Biostatistics Routines in R",
    "",
    "  Authors: Pedro Femia*, Miguel Angel Luque Fernandez",
    "  Biostatistics Faculty of Medicine - University of Granada",
    "",
    "  * Contacto: pfemia@ugr.es, mluquefe@ugr.es",
    "--------------------------------------------------------------",
    sep = "\n"
  )
  packageStartupMessage(msg)
}
