#!/bin/bash
echo "============================================"
echo "Instalador de BioEstatR para macOS"
echo "============================================"
echo ""
echo "Este script instalará el paquete BioEstatR desde GitHub."
echo "Requisito: R instalado (https://cran.r-project.org/bin/macosx/)"
echo ""

echo "[1/3] Instalando dependencia 'remotes'..."
Rscript -e 'install.packages("remotes", repos="https://cran.r-project.org")'

echo "[2/3] Instalando BioEstatR desde GitHub..."
Rscript -e 'remotes::install_github("migariane/BioEstatR", dependencies=TRUE, upgrade="never")'

echo "[3/3] Verificando instalación..."
Rscript -e 'library(BioEstatR); cat("BioEstatR v", as.character(packageVersion("BioEstatR")), " instalado correctamente\n")'

echo ""
echo "Instalación completada. Abre R o RStudio y ejecuta: library(BioEstatR)"
