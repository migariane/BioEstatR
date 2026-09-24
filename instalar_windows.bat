@echo off
echo ============================================
echo Instalador de BioEstatR para Windows
echo ============================================
echo.
echo Este script instalara el paquete BioEstatR desde GitHub.
echo Requisito: R instalado (https://cran.r-project.org/bin/windows/base/)
echo.

cd %~dp0

echo [1/3] Instalando dependencia 'remotes'...
Rscript -e "install.packages('remotes', repos='https://cran.r-project.org')"

echo [2/3] Instalando BioEstatR desde GitHub...
Rscript -e "remotes::install_github('migariane/BioEstatR', dependencies=TRUE, upgrade='never')"

echo [3/3] Verificando instalacion...
Rscript -e "library(BioEstatR); cat('BioEstatR v', as.character(packageVersion('BioEstatR')), ' instalado correctamente\n')"

echo.
echo Instalacion completada. Abre R o RStudio y ejecuta: library(BioEstatR)
pause
