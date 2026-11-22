# Datos sobre pacientes diabeticos

Archivo de datos con informacion sobre algunas variables antropometricas
denigraficas y clinicas de un conjunto de 94 diabeticos (por
compatibilidad se omiten acentos y caracteres no anglosajones)

## Usage

``` r
osteo
```

## Format

data frame con 27 variables y 94 casos:

- num:

  numero de historia,

- edad:

  edad del paciente, en anos

- grupo_edad:

  categoria de edad del paciente, en anos

- sexo:

  sexo del paciente

- peso:

  peso del paciente, en kg

- talla:

  talla del paciente, en cm

- imc:

  indice de masa corporal de Quetelet

- tevol:

  tiempo de evolucion de la enfermedad, en anos

- tabaco:

  variable binaria, indicadora de si el paciente es fumador

- alcohol:

  variable binaria, indicadora de si el paciente bebe alcohol o no

- ingca:

  variable binaria, indicadora de si el paciente toma suficiente calcio
  o no

- acfis:

  variable binaria, indicadora de la realizacion de actividad fisica
  regular

- retin:

  presencia y gravedad de retinopatia

- nefro:

  presencia y gravedad de nefropatia

- neuro:

  presencia y gravedad de neuropatia

- hba1c:

  porcentaje de hemoglobina glicosilada

- ca:

  nivel de calcio, mg/dL

- p:

  nivel de fosforo, mg/dL

- cr:

  nivel de creatinina, mg/dL

- pthm:

  nivel de hormona paratiroidea media, ng/ml

- pthi:

  nivel de hormona paratiroidea intacta, pg/ml

- bmdcue:

  densidad de masa osea en el cuello del femur

- szl24:

  densidad de masa osea tipificada en l24

- szl24:

  densidad de masa osea tipificada en el triangulo de Ward

- szcue:

  densidad de masa osea tipificada en el cuello del femur

- osteo_cue:

  presencia de osteoporosis en el cuello del femur

- osteo_tri:

  presencia de osteoporosis en el triangulo

## Source

<http://www.ugr.es/local/bioest/osteo.RData>

## Examples

``` r
data(osteo)
dim(osteo)
#> [1] 94 27
head(osteo)
#>   num edad grupo_edad   sexo peso talla      imc tevol tabaco  alcohol
#> 1   1   23       < 25 Hombre 72.3   175 23.60816     2     Sí Moderado
#> 2   2   35       > 33 Hombre 82.5   173 27.56524     4     No Moderado
#> 3   3   51       > 33 Hombre 61.0   170 21.10727    17     Sí Moderado
#> 4   4   44       > 33 Hombre 67.0   167 24.02381    17     Sí Moderado
#> 5   5   54       > 33  Mujer 51.0   168 18.06973    30     Sí Moderado
#> 6   6   36       > 33  Mujer 61.5   158 24.63548     2     Sí Moderado
#>          ingca acfis retin nefro neuro hba1c  ca   p   cr pthm pthi bmdcue
#> 1   Suficiente    Sí    No    No    No   4.6 9.6 4.2 1.02  2.9 49.0   22.0
#> 2   Suficiente    No    No    No    No   6.1 9.5 3.4 1.07  3.1   NA     NA
#> 3   Suficiente    Sí    No    No    No   6.7 9.9 4.7 1.35   NA 54.3   23.7
#> 4 Insuficiente    Sí  Leve    No Grave   8.2 8.3 3.2 0.99   NA   NA     NA
#> 5   Suficiente    Sí    No    No    No   9.7 9.5 3.7 0.86  3.1 49.8   35.7
#> 6   Suficiente    Sí    No    No    No   8.4 9.9 4.7 0.80  1.1 59.9   38.3
#>   szl24 sztri szcue osteo_cue osteo_tri
#> 1  1.07  0.55  1.44        No        No
#> 2  0.83 -1.62 -0.93        No        No
#> 3  0.83 -1.28 -0.07        No        No
#> 4  0.72 -1.11 -2.07        Sí        No
#> 5  0.56 -1.68 -3.10        Sí        No
#> 6  0.92  2.05  0.35        No        No

# Descriptiva de una variable cuantitativa
grps(x = osteo$imc)
#>    n  media    dt
#> 1 94 23.921 3.748

# Descriptiva del imc segmentada por presencia de osteoporosis
grps(x = osteo$imc, f = osteo$osteo_cue, grf = FALSE)
#>     n  media    dt
#> No 70 24.451 4.013
#> Sí 24 22.372 2.264
```
