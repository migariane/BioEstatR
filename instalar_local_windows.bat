@echo off
setlocal enabledelayedexpansion
echo ============================================
echo Instalador LOCAL de BioEstatR para Windows
echo ============================================
echo.
echo Este script instala BioEstatR desde el archivo binario .zip incluido
echo en esta misma carpeta (sin necesidad de conexion a internet).
echo.

set SCRIPT_DIR=%~dp0
set PKG_FILE=
for /f "delims=" %%f in ('dir /b /o-n "%SCRIPT_DIR%BioEstatR_*.zip" 2^>nul') do if not defined PKG_FILE set PKG_FILE=%SCRIPT_DIR%%%f

if not defined PKG_FILE (
    echo ERROR: No se encuentra ningun archivo BioEstatR_*.zip
    echo Descargue el binario de Windows generado por GitHub Actions.
    pause
    exit /b 1
)

echo [1/2] Instalando dependencias (requiere internet solo esta vez)...
Rscript -e "install.packages(c('ggplot2','dplyr','tidyr','tibble','broom','survival','survminer','epiR','MASS','car','lmtest','sandwich'), repos='https://cran.r-project.org')"

echo [2/2] Instalando BioEstatR desde archivo local...
R CMD INSTALL "%PKG_FILE%"

echo.
echo Instalacion completada. Abre R o RStudio y ejecuta: library(BioEstatR)
pause
