#!/bin/bash
echo "============================================"
echo "Instalador LOCAL de BioEstatR para macOS"
echo "============================================"
echo ""
echo "Este script instala BioEstatR desde el archivo .tgz incluido"
echo "en esta misma carpeta (sin necesidad de conexión a internet)."
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PKG_FILE="$(ls -t "$SCRIPT_DIR"/BioEstatR_*.tgz 2>/dev/null | head -1)"

if [ ! -f "$PKG_FILE" ]; then
    echo "ERROR: No se encuentra $PKG_FILE"
    echo "Ejecuta primero 'R CMD build .' en la carpeta del paquete."
    exit 1
fi

echo "[1/2] Instalando dependencias (requiere internet solo esta vez)..."
Rscript -e '
  pkgs <- c("ggplot2", "dplyr", "tidyr", "tibble", "broom", "survival", 
            "survminer", "epiR", "MASS", "car", "lmtest", "sandwich")
  installed <- rownames(installed.packages())
  missing <- setdiff(pkgs, installed)
  if (length(missing) > 0) {
    cat("Instalando", length(missing), "dependencias...\n")
    install.packages(missing, repos = "https://cran.r-project.org")
  } else {
    cat("Todas las dependencias ya instaladas.\n")
  }
'

echo "[2/2] Instalando BioEstatR desde archivo local..."
R CMD INSTALL "$PKG_FILE"

echo ""
echo "Instalación completada. Abre R y ejecuta: library(BioEstatR)"
