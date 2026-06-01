## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(BioEstatR)
data(osteo)

## ----rls----------------------------------------------------------------------
# Ejemplo de regresión lineal simple
rls(imc ~ peso, data = osteo, grf=F)

## ----rlm----------------------------------------------------------------------
# Ejemplo de regresión lineal múltiple
new_data <- data.frame(peso = c(70, 80), talla = c(170, 180))
rlm(imc ~ peso + talla, data = osteo, pred = new_data, grf=F)

## ----rlogits------------------------------------------------------------------
# Ejemplo de regresión logística simple
rlogits(osteo_cue ~ imc, data = osteo)

## ----rlogitm, warning=F-------------------------------------------------------
# Ejemplo de regresión logística múltiple
rlogitm(osteo_cue ~ imc + edad + tevol, data = osteo, grf=T)

