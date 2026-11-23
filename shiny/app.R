# =============================================================================
# BioEstatR - Interfaz grafica para estudiantes
# -----------------------------------------------------------------------------
# Aplicacion Shiny que permite usar las rutinas del paquete BioEstatR sin
# necesidad de escribir codigo. Pensada como material docente de Bioestadistica
# (Facultad de Medicina - Universidad de Granada).
#
# Uso:  shiny::runApp("Scripts/BioEstatR/shiny")
#   o dentro de RStudio: abrir este fichero y pulsar "Run App".
#
# Autor de la aplicacion:
#   Miguel Angel Luque-Fernandez, MA - MSc - MPH - PhD
#   Catedratico - Dpto. de Estadistica e Investigacion Operativa
#   Universidad de Granada (UGR)
# Coautores del paquete BioEstatR:
#   Pedro Jesus Femia Marzo, Miguel Angel Montero Alonso y
#   Juan Manuel Melchor Rodriguez
# =============================================================================

library(shiny)

# -----------------------------------------------------------------------------
# Instalacion del paquete BioEstatR
# -----------------------------------------------------------------------------
# BioEstatR no esta en CRAN. Si no esta instalado, se instala desde el fichero
# .tar.gz que se incluye en la carpeta BioEstatR_pkg/ (necesario al desplegar en
# shinyapps.io, donde el paquete no esta disponible por defecto).
if (!requireNamespace("BioEstatR", quietly = TRUE)) {
  candidatos <- c(
    file.path("BioEstatR_pkg", "BioEstatR_1.0.3.tar.gz"),
    file.path("shiny", "BioEstatR_pkg", "BioEstatR_1.0.3.tar.gz")
  )
  tarball <- candidatos[file.exists(candidatos)][1]
  if (!is.na(tarball)) {
    utils::install.packages(tarball, repos = NULL, type = "source")
  } else {
    stop("El paquete BioEstatR no esta instalado.\n",
         "Instalelo con: remotes::install_github('migariane/BioEstatR')")
  }
}
library(BioEstatR)

# -----------------------------------------------------------------------------
# Utilidades
# -----------------------------------------------------------------------------

# Formatea un numero para mostrarlo dentro del codigo R generado.
num_fmt <- function(x) {
  format(x, trim = TRUE, scientific = FALSE, digits = 10)
}

# Ejecuta una llamada al paquete capturando la salida por consola (las funciones
# de BioEstatR imprimen informes con cat()). Devuelve texto listo para mostrar.
capturar <- function(expr) {
  out <- character()
  warn <- character()
  res <- tryCatch(
    withCallingHandlers(
      {
        out <- capture.output(force(expr))
        NULL
      },
      warning = function(w) {
        warn <<- c(warn, conditionMessage(w))
        invokeRestart("muffleWarning")
      },
      message = function(m) invokeRestart("muffleMessage")
    ),
    error = function(e) e
  )
  if (inherits(res, "error")) {
    return(list(ok = FALSE, texto = conditionMessage(res)))
  }
  txt <- paste(out, collapse = "\n")
  if (length(warn)) {
    txt <- paste0(txt, "\n\n# Avisos:\n#  ", paste(unique(warn), collapse = "\n#  "))
  }
  list(ok = TRUE, texto = txt)
}

# Caja de resultado reutilizable: informe en texto + codigo R equivalente +
# botones de descarga (Word y texto plano).
caja_resultado <- function(id_salida, id_codigo, id_descarga) {
  div(
    class = "result-card",
    verbatimTextOutput(id_salida),
    div(
      class = "d-flex gap-2 mt-2 mb-2",
      downloadButton(id_descarga, "Descargar informe (.docx)",
                     class = "btn-sm btn-success"),
      downloadButton(paste0(id_descarga, "_txt"), "Texto (.txt)",
                     class = "btn-sm btn-outline-secondary")
    ),
    tags$details(
      tags$summary("Ver el codigo R equivalente (para aprender)"),
      verbatimTextOutput(id_codigo)
    )
  )
}

# Construye un .docx con el informe de texto, respetando titulos (#) y lineas.
escribir_docx <- function(texto, codigo = NULL, titulo = "BioEstatR",
                          fichero) {
  doc <- officer::read_docx()
  doc <- officer::body_add_par(doc, titulo, style = "heading 1")
  doc <- officer::body_add_par(
    doc,
    paste("Generado con BioEstatR",
          format(Sys.time(), "%d/%m/%Y %H:%M")),
    style = "Normal")

  lineas <- strsplit(texto, "\n", fixed = TRUE)[[1]]
  for (ln in lineas) {
    ln_limpia <- trimws(ln)
    if (identical(ln_limpia, "")) {
      doc <- officer::body_add_par(doc, "", style = "Normal")
    } else if (grepl("^#{1,3} ", ln_limpia)) {
      doc <- officer::body_add_par(doc,
        sub("^#{1,3} ", "", ln_limpia), style = "heading 2")
    } else {
      doc <- officer::body_add_par(doc, ln, style = "Normal")
    }
  }

  if (!is.null(codigo) && nzchar(codigo)) {
    doc <- officer::body_add_par(doc, "Codigo R equivalente",
                                 style = "heading 2")
    for (ln in strsplit(codigo, "\n", fixed = TRUE)[[1]]) {
      doc <- officer::body_add_par(doc, ln, style = "Normal")
    }
  }

  print(doc, target = fichero)
  invisible(fichero)
}

# Variables numericas y factores del data.frame activo.
vars_num <- function(df) names(df)[vapply(df, is.numeric, logical(1))]
vars_cat <- function(df) names(df)[vapply(df, function(v) is.factor(v) || is.character(v), logical(1))]
vars_num_con_cat <- function(df) {
  # numericas con pocos valores distintos: candidatas a variable respuesta 0/1
  names(df)[vapply(df, function(v) {
    is.numeric(v) && length(unique(stats::na.omit(v))) <= 2
  }, logical(1))]
}

# -----------------------------------------------------------------------------
# Hoja de estilos (identidad corporativa UGR: azul marino + dorado)
# -----------------------------------------------------------------------------
estilos_ugr <- tags$style(HTML("
  :root {
    --ugr-blue:  #002855;
    --ugr-blue2: #003d7c;
    --ugr-gold:  #FFB81C;
    --ugr-bg:    #f6f5f1;
  }

  body {
    background-color: var(--ugr-bg);
    color: #2d3748;
    padding-bottom: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
  }

  /* --- Cabecera de marca --- */
  .ugr-hero {
    background: linear-gradient(135deg, #002855 0%, #003d7c 100%);
    color: #ffffff;
    padding: 26px 32px;
    margin: 0 0 18px 0;
    border-bottom: 4px solid var(--ugr-gold);
    box-shadow: 0 4px 16px rgba(0,0,0,0.18);
  }
  .ugr-hero h1 {
    margin: 0;
    font-size: 30px;
    font-weight: 800;
    letter-spacing: -0.5px;
  }
  .ugr-hero .sub {
    color: var(--ugr-gold);
    font-weight: 600;
    font-size: 15px;
    margin: 6px 0 0 0;
  }
  .ugr-hero .author {
    color: #cbd5e1;
    font-size: 13.5px;
    line-height: 1.5;
    margin: 12px 0 0 0;
  }
  .ugr-logo-container {
    display: flex;
    align-items: center;
    justify-content: flex-end;
  }
  .ugr-logo {
    height: 74px;
    background-color: rgba(255,255,255,0.96);
    padding: 6px 14px;
    border-radius: 8px;
    border: 2px solid var(--ugr-gold);
    box-shadow: 0 2px 8px rgba(0,0,0,0.20);
  }

  /* --- Barra de navegacion (ribbon) --- */
  .navbar {
    background: linear-gradient(135deg, #002855 0%, #003d7c 100%) !important;
    border: none !important;
    border-bottom: 3px solid var(--ugr-gold) !important;
    border-radius: 0 !important;
    box-shadow: 0 2px 8px rgba(0,0,0,0.12);
    margin-bottom: 0;
  }
  .ugr-subbar {
    background: #ffffff;
    border-bottom: 1px solid #e2e8f0;
    padding: 9px 22px;
    font-size: 12.5px;
    color: #64748b;
    margin-bottom: 16px;
  }
  .ugr-subbar strong { color: var(--ugr-blue); }
  .ugr-subbar .dot { color: var(--ugr-gold); font-weight: 700; }
  .navbar .navbar-brand,
  .navbar .navbar-nav > li > a {
    color: #ffffff !important;
    font-weight: 600;
    font-size: 14px;
  }
  .navbar .navbar-nav > li > a:hover,
  .navbar .navbar-nav > li > a:focus {
    color: var(--ugr-gold) !important;
    background: rgba(255,255,255,0.06) !important;
  }
  .navbar .navbar-nav > .active > a,
  .navbar .navbar-nav > .active > a:hover,
  .navbar .navbar-nav > .active > a:focus {
    background: rgba(255,184,28,0.20) !important;
    color: var(--ugr-gold) !important;
    box-shadow: inset 0 -3px 0 var(--ugr-gold);
  }

  /* --- Tarjetas de contenido --- */
  .well {
    background-color: #ffffff;
    border: 1px solid #e2e8f0;
    border-top: 3px solid var(--ugr-blue2);
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
  }
  .sidebar-panel-scroll {
    overflow-y: auto;
    max-height: 86vh;
  }
  .result-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-left: 5px solid var(--ugr-blue2);
    border-radius: 10px;
    padding: 16px 20px;
    margin-bottom: 18px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.05);
  }
  .card-ugr {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-left: 5px solid var(--ugr-blue2);
    border-radius: 10px;
    padding: 18px 22px;
    margin-bottom: 18px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.05);
  }
  .card-ugr > h3,
  .card-ugr > h4 {
    margin-top: 0;
    color: var(--ugr-blue);
    font-weight: 700;
    border-bottom: 2px solid var(--ugr-gold);
    padding-bottom: 8px;
  }

  /* --- Tipografia de titulos de panel --- */
  h2, h3 {
    color: var(--ugr-blue);
    font-weight: 700;
  }
  h4 {
    color: var(--ugr-blue);
    font-weight: 700;
  }

  /* --- Salida de resultados --- */
  pre {
    background: #0f1b2d;
    color: #e6edf3;
    border: none;
    border-radius: 8px;
    padding: 14px 16px;
    font-size: 12.5px;
    line-height: 1.5;
    max-height: 540px;
    overflow-y: auto;
    white-space: pre-wrap;
    word-break: break-word;
  }
  details {
    margin-top: 14px;
  }
  details summary {
    cursor: pointer;
    color: var(--ugr-blue2);
    font-weight: 600;
  }
  details pre {
    background: #f1f5f9;
    color: #1e293b;
  }

  .ayuda {
    color: #6c757d;
    font-size: 13px;
    margin-bottom: 10px;
  }

  /* --- Botones --- */
  .btn-primary {
    background-color: var(--ugr-blue2);
    border-color: var(--ugr-blue2);
    font-weight: 600;
  }
  .btn-primary:hover,
  .btn-primary:focus {
    background-color: var(--ugr-blue);
    border-color: var(--ugr-blue);
  }
  .btn-success {
    background-color: #157347;
    border-color: #157347;
  }

  /* --- Tablas --- */
  .table > thead > tr > th {
    background: #eef2f7;
    color: var(--ugr-blue);
    font-weight: 700;
  }

  /* --- Pie de pagina --- */
  .footer-ugr {
    text-align: center;
    color: #718096;
    font-size: 12.5px;
    line-height: 1.6;
    padding: 18px 10px 26px 10px;
    border-top: 3px solid var(--ugr-gold);
    margin-top: 10px;
    background: #ffffff;
  }
  .footer-ugr a { color: var(--ugr-blue2); font-weight: 600; }
"))

# -----------------------------------------------------------------------------
# Cabecera de marca (logo UGR + titulo + autoria)
# -----------------------------------------------------------------------------
cabecera_ugr <- div(
  class = "ugr-hero",
  fluidRow(
    column(
      8,
      h1("BioEstatR"),
      p(class = "sub",
        "Bioestadistica con R, sin escribir codigo - Docencia e investigacion"),
      p(class = "author",
        strong("Miguel Angel Luque-Fernandez, MA \u00b7 MSc \u00b7 MPH \u00b7 PhD"),
        br(),
        "Catedratico - Dpto. de Estadistica e Investigacion Operativa, Universidad de Granada",
        br(),
        tags$span(style = "color:#cbd5e1;",
          "Coautores: Pedro Jesus Femia Marzo, Miguel Angel Montero Alonso y Juan Manuel Melchor Rodriguez")
      )
    ),
    column(
      4, class = "ugr-logo-container",
      tags$img(src = "logo_ugr.png", class = "ugr-logo",
               alt = "Logo Universidad de Granada")
    )
  )
)

barra_autor <- div(
  class = "ugr-subbar",
  tags$span(strong("Universidad de Granada"),
            " - Dpto. de Estadistica e Investigacion Operativa"),
  tags$span(class = "dot", " \u00b7 "),
  tags$span(strong("Miguel Angel Luque-Fernandez"), ", PhD - Catedratico"),
  tags$span(class = "dot", " \u00b7 "),
  tags$span("Coautores: Pedro Jesus Femia Marzo, Miguel Angel Montero Alonso y ",
            "Juan Manuel Melchor Rodriguez")
)

pie_ugr <- tags$footer(
  class = "footer-ugr",
  HTML("BioEstatR &middot; Rutinas de bioestadistica en R &middot; "),
  tags$a(href = "https://migariane.github.io/BioEstatR/", target = "_blank",
         "migariane.github.io/BioEstatR"),
  HTML(" &middot; "),
  tags$a(href = "https://www.ugr.es", target = "_blank", "Universidad de Granada"),
  tags$br(),
  "Miguel Angel Luque-Fernandez, MA \u00b7 MSc \u00b7 MPH \u00b7 PhD - ",
  "Catedratico, Dpto. de Estadistica e Investigacion Operativa, UGR",
  tags$br(),
  tags$span(style = "color:#94a3b8;",
    "Coautores: Pedro Jesus Femia Marzo, Miguel Angel Montero Alonso y Juan Manuel Melchor Rodriguez")
)

# -----------------------------------------------------------------------------
# Interfaz
# -----------------------------------------------------------------------------

ui <- navbarPage(
  title = tagList(
    tags$img(src = "logo_ugr.png",
             style = "height:26px; background:#fff; padding:2px 6px; border-radius:4px; margin-right:8px; vertical-align:middle;",
             alt = "UGR"),
    "BioEstatR"
  ),
  windowTitle = "BioEstatR - Bioestadistica con R (UGR)",
  collapsible = TRUE,
  inverse = TRUE,

  header = tagList(estilos_ugr, barra_autor),
  footer = pie_ugr,

  # ------------------------------------------------------- Introduccion ----
  tabPanel(
    "Introduccion",
    cabecera_ugr,
    fluidRow(
      column(
        8,
        div(
          class = "card-ugr",
          h3("Bioestadistica con R, sin escribir codigo"),
          p(class = "ayuda",
            "Esta aplicacion permite usar las funciones del paquete ",
            strong("BioEstatR"), " seleccionando opciones con el raton. ",
            "En cada resultado puede desplegar ", em("Ver el codigo R equivalente"),
            " para aprender la instruccion que produce ese analisis."),
          hr(),
          h4("Como funciona"),
          tags$ol(
            tags$li("Elija un conjunto de datos en la pestana ", strong("Mis datos"),
                    " (por defecto ", code("osteo"),
                    ", que acompana al paquete: 94 pacientes con 27 variables)."),
            tags$li("Vaya a la pestana del analisis que necesite."),
            tags$li("Seleccione las variables y pulse el boton de calcular."),
            tags$li("Copie el informe, o abra el codigo R para reproducirlo.")
          ),
          hr(),
          h4("Analisis de medias con potencia y tamano muestral"),
          p(class = "ayuda",
            "La pestana ", strong("Medias"), " incluye el ",
            strong("t-test para medidas repetidas"), " (dos muestras relacionadas) ",
            "y, para cualquiera de los contrastes de medias, el ",
            strong("estudio de potencia y la estimacion del tamano muestral"),
            " mediante los parametros ", code("delta"), " (efecto a detectar) y ",
            code("potencia"),
            ", tal y como los ofrece la funcion ", code("testt"), ".")
        )
      ),
      column(
        4,
        div(
          class = "card-ugr",
          h4("Pestanas disponibles"),
          tags$table(
            class = "table table-sm table-striped",
            tags$thead(tags$tr(tags$th("Pestana"), tags$th("Funcion"))),
            tags$tbody(
              tags$tr(tags$td("Mis datos"),       tags$td(code("osteo / CSV / Excel"))),
              tags$tr(tags$td("Descriptiva"),     tags$td(code("descriptiva, freq"))),
              tags$tr(tags$td("Normalidad"),      tags$td(code("testnormal"))),
              tags$tr(tags$td("Medias"),          tags$td(code("testt"))),
              tags$tr(tags$td("Proporciones"),    tags$td(code("testp"))),
              tags$tr(tags$td("Intervalos"),      tags$td(code("icm, icp"))),
              tags$tr(tags$td("Tablas 2x2"),      tags$td(code("tabla2x2"))),
              tags$tr(tags$td("McNemar"),         tags$td(code("testmcnemar"))),
              tags$tr(tags$td("Regresion"),       tags$td(code("rls, rlm, rlogits"))),
              tags$tr(tags$td("Tamano muestral"), tags$td(code("nm, np, nl")))
            )
          ),
          hr(),
          p(class = "ayuda",
            "Version del paquete instalada: ",
            textOutput("version_pkg", inline = TRUE))
        )
      )
    )
  ),

  # ----------------------------------------------------------- Mis datos ----
  tabPanel(
    "Mis datos",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        p(class = "ayuda",
          "Cargue un fichero CSV, Excel o los datos incluidos en el paquete."),
        radioButtons("src", "Origen de los datos",
          choices = c("Incluidos en el paquete" = "pkg",
                      "Subir fichero" = "file"),
          selected = "pkg"),
        conditionalPanel(
          "input.src == 'pkg'",
          selectInput("pkg_data", "Conjunto de datos",
            choices = c("osteo" = "osteo"))
        ),
        conditionalPanel(
          "input.src == 'file'",
          fileInput("fichero", "Fichero (.csv, .txt, .xlsx)",
            accept = c(".csv", ".txt", ".xlsx", ".xls")),
          checkboxInput("cabecera", "La primera fila contiene los nombres", TRUE),
          selectInput("sep", "Separador",
            choices = c("Coma" = ",", "Punto y coma" = ";", "Tabulador" = "\t"),
            selected = ","),
          checkboxInput("decimal_coma", "Usar coma como separador decimal", FALSE)
        ),
        hr(),
        verbatimTextOutput("resumen_datos")
      ),
      mainPanel(
        width = 9,
        div(
          class = "card-ugr",
          h4("Vista de los datos"),
          tableOutput("tabla_datos")
        ),
        div(
          class = "card-ugr",
          h4("Estructura"),
          verbatimTextOutput("str_datos")
        )
      )
    )
  ),

  # ----------------------------------------------------------- Descriptiva ----
  tabPanel(
    "Descriptiva",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        uiOutput("ui_descr_dataset"),
        uiOutput("ui_descr_vars"),
        checkboxInput("descr_ic", "Anadir intervalos de confianza", FALSE),
        checkboxInput("descr_normal", "Anadir prueba de normalidad", FALSE),
        numericInput("descr_decs", "Decimales", 3, 0, 6, 1),
        actionButton("descr_go", "Calcular", class = "btn-primary w-100"),
        hr(),
        h5("Tabla de frecuencias"),
        uiOutput("ui_freq_var"),
        checkboxInput("freq_acum", "Frecuencias acumuladas", TRUE),
        actionButton("freq_go", "Frecuencias", class = "btn-outline-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Analisis descriptivo"),
            caja_resultado("descr_out", "descr_code", "descr_dl")),
        div(class = "card-ugr", h4("Distribucion de frecuencias"),
            caja_resultado("freq_out", "freq_code", "freq_dl"))
      )
    )
  ),

  # ------------------------------------------------------------ Normalidad ----
  tabPanel(
    "Normalidad",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        uiOutput("ui_norm_dataset"),
        uiOutput("ui_norm_var"),
        p(class = "ayuda", "Contrasta si la variable sigue una distribucion normal (Shapiro-Wilk)."),
        actionButton("norm_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Test de normalidad"),
            caja_resultado("norm_out", "norm_code", "norm_dl"),
            plotOutput("norm_plot", height = "420px"))
      )
    )
  ),

  # ---------------------------------------------------------------- Medias ----
  tabPanel(
    "Medias",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        radioButtons("t_tipo", "Tipo de contraste",
          choices = c(
            "Una muestra" = "una",
            "Dos muestras independientes" = "dos",
            "Dos muestras relacionadas (medidas repetidas)" = "rel"
          ),
          selected = "una"),
        radioButtons("t_fuente", "Origen de los datos",
          choices = c(
            "Datos resumidos (manual)" = "manual",
            "Variables de los datos cargados" = "datos"
          ),
          selected = "manual"),

        # ---- Una muestra: datos manuales
        conditionalPanel(
          "input.t_tipo == 'una' && input.t_fuente == 'manual'",
          numericInput("t_m", "Media muestral", 25, step = 0.1),
          numericInput("t_s", "Desviacion tipica", 4, min = 0, step = 0.1),
          numericInput("t_n", "Tamano muestral", 30, min = 2, step = 1),
          numericInput("t_m0", "Media hipotetica (H0)", 23, step = 0.1)
        ),
        # ---- Una muestra: variable del dataset
        conditionalPanel(
          "input.t_tipo == 'una' && input.t_fuente == 'datos'",
          uiOutput("ui_t_una_var"),
          numericInput("t_data_una_m0", "Media hipotetica (H0)", 0, step = 0.1)
        ),

        # ---- Dos independientes: datos manuales
        conditionalPanel(
          "input.t_tipo == 'dos' && input.t_fuente == 'manual'",
          numericInput("t_m1", "Media grupo 1", 25, step = 0.1),
          numericInput("t_s1", "Desv. tipica grupo 1", 4, min = 0, step = 0.1),
          numericInput("t_n1", "n grupo 1", 30, min = 2, step = 1),
          numericInput("t_m2", "Media grupo 2", 23, step = 0.1),
          numericInput("t_s2", "Desv. tipica grupo 2", 3.5, min = 0, step = 0.1),
          numericInput("t_n2", "n grupo 2", 30, min = 2, step = 1),
          numericInput("t_m0_dos", "Diferencia hipotetica (H0: m1-m2)", 0, step = 0.1)
        ),
        # ---- Dos independientes: variables del dataset
        conditionalPanel(
          "input.t_tipo == 'dos' && input.t_fuente == 'datos'",
          uiOutput("ui_t_dos_y"),
          uiOutput("ui_t_dos_g"),
          numericInput("t_data_dos_m0", "Diferencia hipotetica (H0: m1-m2)", 0, step = 0.1)
        ),

        # ---- Relacionadas: datos manuales
        conditionalPanel(
          "input.t_tipo == 'rel' && input.t_fuente == 'manual'",
          p(class = "ayuda",
            "Dos medidas sobre los mismos sujetos (antes / despues). ",
            "El contraste se realiza sobre la diferencia intra-sujeto."),
          radioButtons("t_rel_modo", "Datos de partida",
            choices = c(
              "Medias pre/post + correlacion" = "prepost",
              "Diferencia resumida (media y DT)" = "dif"
            ),
            selected = "prepost"),
          conditionalPanel(
            "input.t_rel_modo == 'prepost'",
            numericInput("t_pre_m", "Media pre", 24, step = 0.1),
            numericInput("t_pre_s", "Desv. tipica pre", 4, min = 0, step = 0.1),
            numericInput("t_post_m", "Media post", 25, step = 0.1),
            numericInput("t_post_s", "Desv. tipica post", 4.5, min = 0, step = 0.1),
            numericInput("t_rel_r", "Correlacion pre-post (r)", 0.5, -0.99, 0.99, 0.01),
            numericInput("t_rel_n", "Numero de parejas (n)", 30, min = 2, step = 1),
            numericInput("t_rel_m0", "Diferencia hipotetica (H0)", 0, step = 0.1)
          ),
          conditionalPanel(
            "input.t_rel_modo == 'dif'",
            numericInput("t_dif_m", "Media de la diferencia", 1, step = 0.1),
            numericInput("t_dif_s", "Desv. tipica de la diferencia", 3, min = 0, step = 0.1),
            numericInput("t_dif_n", "Numero de parejas (n)", 30, min = 2, step = 1),
            numericInput("t_dif_m0", "Diferencia hipotetica (H0)", 0, step = 0.1)
          )
        ),
        # ---- Relacionadas: variables del dataset
        conditionalPanel(
          "input.t_tipo == 'rel' && input.t_fuente == 'datos'",
          p(class = "ayuda",
            "Dos variables numericas medidas sobre los mismos sujetos ",
            "(cada fila es un sujeto; se aparean v1 y v2)."),
          uiOutput("ui_t_rel_v1"),
          uiOutput("ui_t_rel_v2"),
          numericInput("t_data_rel_m0", "Diferencia hipotetica (H0)", 0, step = 0.1)
        ),
        numericInput("t_alfa", "Nivel de significacion (alfa)", 0.05, 0.001, 0.2, 0.001),
        hr(),
        checkboxInput("t_estudio", "Estudiar potencia y tamano muestral", FALSE),
        conditionalPanel(
          "input.t_estudio == true",
          p(class = "ayuda",
            "Efecto a detectar (", code("delta"), ") y potencia deseada (",
            code("potencia"), "), igual que en ", code("testt"), "."),
          numericInput("t_delta", "Efecto a detectar (delta)", 0.5, min = 0.001, step = 0.1),
          numericInput("t_potencia", "Potencia deseada (1 - beta)", 0.8, 0.5, 0.999, 0.05)
        ),
        actionButton("t_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr",
            h4("Comparacion de medias (t de Student)"),
            caja_resultado("t_out", "t_code", "t_dl"))
      )
    )
  ),

  # ---------------------------------------------------------- Proporciones ----
  tabPanel(
    "Proporciones",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        numericInput("p_x", "Numero de exitos", 40, min = 0, step = 1),
        numericInput("p_n", "Tamano muestral", 100, min = 1, step = 1),
        numericInput("p_p0", "Proporcion hipotetica (H0)", 0.5, 0.001, 0.999, 0.001),
        numericInput("p_alfa", "Nivel de significacion (alfa)", 0.05, 0.001, 0.2, 0.001),
        actionButton("p_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Contraste de una proporcion"),
            caja_resultado("p_out", "p_code", "p_dl"))
      )
    )
  ),

  # ----------------------------------------------------------- Intervalos ----
  tabPanel(
    "Intervalos",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        radioButtons("ic_tipo", "Que desea estimar",
          choices = c("Media" = "media", "Proporcion" = "prop")),
        conditionalPanel(
          "input.ic_tipo == 'media'",
          numericInput("ic_m", "Media muestral", 25, step = 0.1),
          numericInput("ic_s", "Desviacion tipica", 4, min = 0, step = 0.1),
          numericInput("ic_n", "Tamano muestral", 30, min = 2, step = 1)
        ),
        conditionalPanel(
          "input.ic_tipo == 'prop'",
          numericInput("ic_x", "Numero de exitos", 40, min = 0, step = 1),
          numericInput("ic_np", "Tamano muestral", 100, min = 1, step = 1)
        ),
        numericInput("ic_conf", "Nivel de confianza", 0.95, 0.5, 0.999, 0.001),
        actionButton("ic_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Estimacion por intervalo"),
            caja_resultado("ic_out", "ic_code", "ic_dl"))
      )
    )
  ),

  # ------------------------------------------------------------ Tablas 2x2 ----
  tabPanel(
    "Tablas 2x2",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        p(class = "ayuda", "Introduzca las cuatro frecuencias observadas."),
        numericInput("x2_o11", "Fila 1 - Columna 1", 25, min = 0, step = 1),
        numericInput("x2_o12", "Fila 1 - Columna 2", 10, min = 0, step = 1),
        numericInput("x2_o21", "Fila 2 - Columna 1", 12, min = 0, step = 1),
        numericInput("x2_o22", "Fila 2 - Columna 2", 23, min = 0, step = 1),
        selectInput("x2_estudio", "Diseno del estudio",
          choices = c("Transversal / cohorte" = "T",
                      "Casos y controles" = "C")),
        actionButton("x2_go", "Calcular", class = "btn-primary w-100"),
        hr(),
        h5("O usar un dataset"),
        uiOutput("ui_x2_fvar"),
        uiOutput("ui_x2_cvar"),
        actionButton("x2_go_data", "Tabular variables", class = "btn-outline-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Analisis de tabla 2x2"),
            caja_resultado("x2_out", "x2_code", "x2_dl"))
      )
    )
  ),

  # -------------------------------------------------------------- McNemar ----
  tabPanel(
    "McNemar",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        p(class = "ayuda", "Datos apareados (antes / despues). Introduzca las 4 casillas."),
        numericInput("mc_n11", "Antes + / Despues +", 20, min = 0, step = 1),
        numericInput("mc_n12", "Antes + / Despues -", 15, min = 0, step = 1),
        numericInput("mc_n21", "Antes - / Despues +", 3, min = 0, step = 1),
        numericInput("mc_n22", "Antes - / Despues -", 12, min = 0, step = 1),
        numericInput("mc_alfa", "Nivel de significacion", 0.05, 0.001, 0.2, 0.001),
        actionButton("mc_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Test de McNemar"),
            caja_resultado("mc_out", "mc_code", "mc_dl"))
      )
    )
  ),

  # ------------------------------------------------------------ Regresion ----
  tabPanel(
    "Regresion",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        uiOutput("ui_reg_dataset"),
        radioButtons("reg_tipo", "Modelo",
          choices = c("Lineal simple" = "rls",
                      "Lineal multiple" = "rlm",
                      "Logistica" = "rlogits"),
          selected = "rls"),
        uiOutput("ui_reg_y"),
        uiOutput("ui_reg_x"),
        actionButton("reg_go", "Ajustar modelo", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Modelo de regresion"),
            caja_resultado("reg_out", "reg_code", "reg_dl"))
      )
    )
  ),

  # ------------------------------------------------------ Tamano muestral ----
  tabPanel(
    "Tamano muestral",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        radioButtons("n_tipo", "Que desea calcular",
          choices = c("Media" = "nm",
                      "Proporcion" = "np",
                      "Normalidad / 1 muestra" = "nl"),
          selected = "nm"),
        conditionalPanel(
          "input.n_tipo == 'nm'",
          p(class = "ayuda",
            "La funcion ", code("nm"), " parte de una ",
            strong("muestra piloto"), " para estimar la desviacion tipica. ",
            "Seleccione una variable numerica de los datos cargados."),
          uiOutput("ui_nm_var"),
          numericInput("n_d", "Precision deseada (margen de error)", 1, min = 0.001, step = 0.1)
        ),
        conditionalPanel(
          "input.n_tipo == 'np'",
          p(class = "ayuda", "Estima n para una proporcion a partir de una muestra piloto."),
          numericInput("n_px", "Casos favorables en la muestra piloto", 40, min = 0, step = 1),
          numericInput("n_pn", "Tamano de la muestra piloto", 100, min = 1, step = 1),
          numericInput("n_dp", "Precision deseada", 0.05, 0.001, 0.5, 0.001)
        ),
        conditionalPanel(
          "input.n_tipo == 'nl'",
          numericInput("n_lmax", "Valor maximo esperado", 100, min = 1, step = 1),
          numericInput("n_dl", "Precision deseada", 1, min = 0.001, step = 0.1)
        ),
        numericInput("n_conf", "Nivel de confianza", 0.95, 0.5, 0.999, 0.001),
        actionButton("n_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Tamano muestral necesario"),
            caja_resultado("n_out", "n_code", "n_dl"))
      )
    )
  ),

  # --------------------------------------------------------------- Ayuda ----
  tabPanel(
    "Ayuda",
    fluidRow(column(
      12,
      div(
        class = "card-ugr",
        h3("Ayuda rapida"),
        h4("Que es un contraste de hipotesis"),
        p("Un contraste compara lo que observamos en la muestra con lo que ",
          "esperariamos si cierta hipotesis nula (H0) fuese cierta. Si el ",
          strong("valor p"), " es menor que el nivel de significacion alfa ",
          "(habitualmente 0,05), rechazamos H0."),
        h4("Como interpretar el valor p"),
        tags$ul(
          tags$li("p < 0,05: hay evidencia estadistica contra H0."),
          tags$li("p >= 0,05: no hay evidencia suficiente para rechazar H0 ",
                  "(no es lo mismo que demostrar que H0 es cierta).")
        ),
        h4("Intervalos de confianza"),
        p("Un IC al 95% es un rango de valores plausibles para el parametro ",
          "poblacional. Si el IC del 95% para una diferencia de medias incluye ",
          "el 0, el contraste correspondiente no sera significativo al 5%."),
        h4("Medidas repetidas"),
        p("Cuando las dos medidas se toman sobre los mismos sujetos (antes / ",
          "despues), las observaciones no son independientes. El t-test para ",
          "muestras relacionadas se aplica sobre la diferencia intra-sujeto ",
          "(post - pre). A partir de las medias y desviaciones tipicas de cada ",
          "medida y de su correlacion r, la desviacion tipica de la diferencia ",
          "es s_d = sqrt(s1^2 + s2^2 - 2*r*s1*s2)."),
        h4("Potencia y tamano muestral"),
        p("La potencia (1 - beta) es la probabilidad de detectar un efecto real ",
          "de magnitud delta. Con ", code("testt"), " puede fijar delta y la ",
          "potencia deseada para estimar cuantos sujetos se necesitan. Un ",
          "estudio con baja potencia puede no detectar diferencias reales."),
        h4("Normalidad"),
        p("Muchos contrastes (t de Student, regresion lineal) suponen que los ",
          "datos siguen una distribucion normal. Use la pestana Normalidad para ",
          "comprobarlo antes de aplicarlos."),
        h4("Regresion logistica"),
        p("Se usa cuando la variable respuesta es binaria (si/no). El modelo ",
          "estima como cambia el logaritmo de la odds (log-odds) al aumentar una ",
          "unidad la variable explicativa; exp(beta) es la odds ratio."),
        hr(),
        h4("Documentacion completa"),
        p("Cada funcion esta documentada en R con ", code("?nombre_funcion"),
          ", y en el sitio web del paquete: ",
          tags$a(href = "https://migariane.github.io/BioEstatR/",
                 target = "_blank", "migariane.github.io/BioEstatR")),
        h4("Reproducir en R"),
        p("En cada resultado puede desplegar el codigo R equivalente. Copielo en ",
          "la consola de R o en un script para reproducir el analisis exacto.")
      )
    ))
  )
)

# -----------------------------------------------------------------------------
# Servidor
# -----------------------------------------------------------------------------

server <- function(input, output, session) {

  # Almacena el ultimo informe y codigo de cada pestana para las descargas.
  ultimo <- shiny::reactiveValues()

  output$version_pkg <- renderText({
    as.character(utils::packageVersion("BioEstatR"))
  })

  # ---- Datos activos --------------------------------------------------------
  # Devuelve el data.frame seleccionado en la pestana "Mis datos".
  datos <- reactive({
    if (identical(input$src, "file")) {
      req(input$fichero)
      ext <- tolower(tools::file_ext(input$fichero$name))
      if (ext %in% c("xlsx", "xls")) {
        if (!requireNamespace("readxl", quietly = TRUE)) {
          validate(need(FALSE, "Para leer Excel instale el paquete readxl: install.packages('readxl')"))
        }
        df <- as.data.frame(readxl::read_excel(input$fichero$datapath))
      } else {
        dec <- if (isTRUE(input$decimal_coma)) "," else "."
        df <- utils::read.table(
          input$fichero$datapath,
          header = isTRUE(input$cabecera),
          sep = input$sep,
          dec = dec,
          stringsAsFactors = TRUE,
          fileEncoding = "UTF-8",
          check.names = TRUE
        )
      }
      # Las columnas de texto se convierten en factores para que funcionen
      # las tablas de contingencia y la regresion logistica.
      df <- as.data.frame(df)
      chr <- vapply(df, is.character, logical(1))
      if (any(chr)) {
        df[chr] <- lapply(df[chr], function(v) {
          if (length(unique(stats::na.omit(v))) <= 50) as.factor(v) else v
        })
      }
      validate(need(nrow(df) > 0, "El fichero no contiene datos legibles."))
      df
    } else {
      osteo
    }
  })

  # Resumen corto del dataset activo
  output$resumen_datos <- renderText({
    df <- datos()
    paste0(nrow(df), " filas x ", ncol(df), " variables")
  })

  output$tabla_datos <- renderTable({
    utils::head(datos(), 15)
  })

  output$str_datos <- renderPrint({
    utils::str(datos())
  })

  # ---- Selectores dependientes del dataset ---------------------------------
  output$ui_descr_dataset <- renderUI({
    p(class = "ayuda", paste("Datos:", nrow(datos()), "filas"))
  })

  output$ui_descr_vars <- renderUI({
    df <- datos()
    selectInput("descr_vars", "Variables a describir",
      choices = names(df), multiple = TRUE,
      selected = utils::head(names(df), min(3, ncol(df))))
  })

  output$ui_freq_var <- renderUI({
    df <- datos()
    selectInput("freq_var", "Variable (cualitativa o numerica)",
      choices = names(df), selected = names(df)[1])
  })

  output$ui_norm_dataset <- renderUI({
    p(class = "ayuda", paste("Datos:", nrow(datos()), "filas"))
  })

  output$ui_norm_var <- renderUI({
    df <- datos()
    num <- vars_num(df)
    selectInput("norm_var", "Variable numerica",
      choices = if (length(num)) num else names(df),
      selected = if (length(num)) num[1] else names(df)[1])
  })

  output$ui_x2_fvar <- renderUI({
    df <- datos()
    cats <- c(vars_cat(df), vars_num_con_cat(df))
    if (!length(cats)) cats <- names(df)
    selectInput("x2_fvar", "Variable fila", choices = cats, selected = cats[1])
  })

  output$ui_x2_cvar <- renderUI({
    df <- datos()
    cats <- c(vars_cat(df), vars_num_con_cat(df))
    if (!length(cats)) cats <- names(df)
    selectInput("x2_cvar", "Variable columna",
      choices = cats,
      selected = if (length(cats) > 1) cats[2] else cats[1])
  })

  output$ui_reg_dataset <- renderUI({
    p(class = "ayuda", paste("Datos:", nrow(datos()), "filas"))
  })

  output$ui_reg_y <- renderUI({
    df <- datos()
    if (identical(input$reg_tipo, "rlogits")) {
      cand <- c(vars_num_con_cat(df), vars_cat(df))
      if (!length(cand)) cand <- names(df)
      selectInput("reg_y", "Variable respuesta (binaria)", choices = cand)
    } else {
      num <- vars_num(df)
      if (!length(num)) num <- names(df)
      selectInput("reg_y", "Variable respuesta (Y)", choices = num)
    }
  })

  output$ui_reg_x <- renderUI({
    df <- datos()
    num <- vars_num(df)
    if (!length(num)) num <- names(df)
    selectInput("reg_x", "Variable(s) explicativa(s) (X)",
      choices = num, multiple = TRUE,
      selected = num[min(2, length(num))])
  })

  output$ui_nm_var <- renderUI({
    df <- datos()
    num <- vars_num(df)
    if (!length(num)) num <- names(df)
    selectInput("nm_var", "Variable de la muestra piloto",
      choices = num, selected = num[1])
  })

  # ---- Selectores para el t-test sobre variables del data.frame ------------
  output$ui_t_una_var <- renderUI({
    df <- datos()
    num <- vars_num(df)
    if (!length(num)) num <- names(df)
    selectInput("t_una_var", "Variable numerica (muestra)",
      choices = num,
      selected = if ("peso" %in% num) "peso" else num[1])
  })

  output$ui_t_dos_y <- renderUI({
    df <- datos()
    num <- vars_num(df)
    if (!length(num)) num <- names(df)
    selectInput("t_dos_y", "Variable respuesta (numerica)",
      choices = num,
      selected = if ("peso" %in% num) "peso" else num[1])
  })

  output$ui_t_dos_g <- renderUI({
    df <- datos()
    cats <- vars_cat(df)
    if (!length(cats)) cats <- names(df)
    bin <- cats[vapply(df[cats], function(v) {
      nlevels(droplevels(as.factor(v))) == 2
    }, logical(1))]
    choices <- c(bin, setdiff(cats, bin))
    selectInput("t_dos_g", "Variable de agrupacion (2 niveles)",
      choices = choices,
      selected = if ("sexo" %in% choices) "sexo" else choices[1])
  })

  output$ui_t_rel_v1 <- renderUI({
    df <- datos()
    num <- vars_num(df)
    if (!length(num)) num <- names(df)
    selectInput("t_rel_v1", "Variable 1 (medida inicial)",
      choices = num, selected = num[1])
  })

  output$ui_t_rel_v2 <- renderUI({
    df <- datos()
    num <- vars_num(df)
    if (!length(num)) num <- names(df)
    selectInput("t_rel_v2", "Variable 2 (medida final)",
      choices = num,
      selected = if (length(num) > 1) num[2] else num[1])
  })

  # ---- Descriptiva ----------------------------------------------------------
  observeEvent(input$descr_go, {
    req(input$descr_vars)
    df <- datos()
    vars <- input$descr_vars
    validate(need(all(vars %in% names(df)), "Seleccione al menos una variable valida."))

    r <- capturar(
      descriptiva(df[, vars, drop = FALSE],
        ic = isTRUE(input$descr_ic),
        normal = isTRUE(input$descr_normal),
        decs = input$descr_decs)
    )
    ultimo$descr_out <- r$texto
    output$descr_out <- renderText(r$texto)

    output$descr_code <- renderText({
      ultimo$descr_code <- (function() {
      paste0(
        "library(BioEstatR)\n",
        "descriptiva(", deparse_subset(df, vars), ",\n",
        "            ic = ", isTRUE(input$descr_ic), ",\n",
        "            normal = ", isTRUE(input$descr_normal), ",\n",
        "            decs = ", input$descr_decs, ")"
      )
      })()
      ultimo$descr_code
    })
  })

  observeEvent(input$freq_go, {
    req(input$freq_var)
    df <- datos()
    validate(need(input$freq_var %in% names(df), "Variable no valida."))
    r <- capturar(freq(df[[input$freq_var]],
                       acum = isTRUE(input$freq_acum),
                       grf = FALSE))
    ultimo$freq_out <- r$texto
    output$freq_out <- renderText(r$texto)
    output$freq_code <- renderText({
      ultimo$freq_code <- (function() {
      paste0("library(BioEstatR)\n",
             "freq(", code_var(df, input$freq_var), ",\n",
             "     acum = ", isTRUE(input$freq_acum), ", grf = FALSE)")
      })()
      ultimo$freq_code
    })
  })

  # ---- Normalidad -----------------------------------------------------------
  observeEvent(input$norm_go, {
    req(input$norm_var)
    df <- datos()
    validate(need(input$norm_var %in% names(df), "Variable no valida."))

    r <- capturar(testnormal(df[[input$norm_var]]))
    ultimo$norm_out <- r$texto
    output$norm_out <- renderText(r$texto)

    output$norm_code <- renderText({
      ultimo$norm_code <- (function() {
      paste0("library(BioEstatR)\n",
             "testnormal(", code_var(df, input$norm_var), ")")
      })()
      ultimo$norm_code
    })

    output$norm_plot <- renderPlot({
      x <- df[[input$norm_var]]
      graf_normal(x, input$norm_var)
    })
  })

  # ---- t de Student (1 muestra, 2 independientes, 2 relacionadas) -----------
  observeEvent(input$t_go, {
    estudio <- isTRUE(input$t_estudio)
    potencia <- if (estudio) input$t_potencia else 0.8
    beta <- 1 - potencia
    delta <- if (estudio) input$t_delta else 0

    if (estudio) {
      validate(
        need(is.finite(input$t_delta) && input$t_delta > 0,
             "El efecto a detectar (delta) debe ser > 0."),
        need(is.finite(input$t_potencia) && input$t_potencia > 0.5 &&
               input$t_potencia < 1,
             "La potencia deseada debe estar entre 0.5 y 1.")
      )
    }

    # Argumentos y comentario para el codigo R generado
    args <- character()
    comentario <- ""

    if (identical(input$t_fuente, "datos")) {
      # ---- El test se calcula sobre variables del data.frame cargado ----
      df <- datos()
      if (identical(input$t_tipo, "una")) {
        req(input$t_una_var)
        validate(
          need(input$t_una_var %in% names(df), "Variable no valida."),
          need(is.numeric(df[[input$t_una_var]]), "La variable debe ser numerica."),
          need(sum(is.finite(df[[input$t_una_var]])) >= 2,
               "La variable necesita al menos 2 valores no faltantes.")
        )
        r <- capturar(testt(m = df[[input$t_una_var]],
                            m0 = input$t_data_una_m0, alfa = input$t_alfa,
                            delta = delta, potencia = potencia, beta = beta,
                            grf = FALSE))
        comentario <- paste0("# Contraste de una media sobre la variable ",
                             input$t_una_var)
        args <- c(paste0("m = datos$", input$t_una_var),
                  paste0("m0 = ", num_fmt(input$t_data_una_m0)),
                  paste0("alfa = ", num_fmt(input$t_alfa)))

      } else if (identical(input$t_tipo, "dos")) {
        req(input$t_dos_y, input$t_dos_g)
        validate(
          need(all(c(input$t_dos_y, input$t_dos_g) %in% names(df)),
               "Variables no validas."),
          need(is.numeric(df[[input$t_dos_y]]), "La variable respuesta debe ser numerica.")
        )
        g <- droplevels(as.factor(df[[input$t_dos_g]]))
        validate(need(nlevels(g) == 2,
          "La variable de agrupacion debe tener exactamente 2 niveles."))
        r <- capturar(testt(m = df[[input$t_dos_y]], grupos = g,
                            m0 = input$t_data_dos_m0, alfa = input$t_alfa,
                            delta = delta, potencia = potencia, beta = beta,
                            grf = FALSE))
        comentario <- paste0("# Dos muestras independientes: ", input$t_dos_y,
                             " segun ", input$t_dos_g)
        args <- c(paste0("m = datos$", input$t_dos_y),
                  paste0("grupos = datos$", input$t_dos_g),
                  paste0("m0 = ", num_fmt(input$t_data_dos_m0)),
                  paste0("alfa = ", num_fmt(input$t_alfa)))

      } else {
        req(input$t_rel_v1, input$t_rel_v2)
        validate(
          need(all(c(input$t_rel_v1, input$t_rel_v2) %in% names(df)),
               "Variables no validas."),
          need(is.numeric(df[[input$t_rel_v1]]) && is.numeric(df[[input$t_rel_v2]]),
               "Ambas variables deben ser numericas."),
          need(!identical(input$t_rel_v1, input$t_rel_v2),
               "Seleccione dos variables distintas.")
        )
        v1 <- df[[input$t_rel_v1]]
        v2 <- df[[input$t_rel_v2]]
        validate(need(sum(stats::complete.cases(cbind(v1, v2))) >= 2,
                      "Se necesitan al menos 2 parejas completas."))
        r <- capturar(testt(m1 = df[[input$t_rel_v1]],
                            m2 = df[[input$t_rel_v2]], par = TRUE,
                            m0 = input$t_data_rel_m0, alfa = input$t_alfa,
                            delta = delta, potencia = potencia, beta = beta,
                            grf = FALSE))
        comentario <- paste0("# Dos muestras relacionadas: ", input$t_rel_v1,
                             " y ", input$t_rel_v2, " (par = TRUE)")
        args <- c(paste0("m1 = datos$", input$t_rel_v1),
                  paste0("m2 = datos$", input$t_rel_v2),
                  "par = TRUE",
                  paste0("m0 = ", num_fmt(input$t_data_rel_m0)),
                  paste0("alfa = ", num_fmt(input$t_alfa)))
      }

      # Mostrar los nombres reales de las variables en el informe
      if (identical(input$t_tipo, "una")) {
        r$texto <- gsub("df[[input$t_una_var]]", input$t_una_var,
                        r$texto, fixed = TRUE)
      } else if (identical(input$t_tipo, "dos")) {
        r$texto <- gsub("df[[input$t_dos_y]]", input$t_dos_y,
                        r$texto, fixed = TRUE)
      } else {
        r$texto <- gsub("df[[input$t_rel_v1]]", input$t_rel_v1,
                        r$texto, fixed = TRUE)
        r$texto <- gsub("df[[input$t_rel_v2]]", input$t_rel_v2,
                        r$texto, fixed = TRUE)
      }

    } else if (identical(input$t_tipo, "una")) {
      validate(
        need(is.finite(input$t_m), "Indique la media."),
        need(is.finite(input$t_s) && input$t_s > 0, "La desviacion tipica debe ser > 0."),
        need(input$t_n >= 2, "El tamano muestral debe ser al menos 2.")
      )
      r <- capturar(testt(m = input$t_m, s = input$t_s, n = input$t_n,
                          m0 = input$t_m0, alfa = input$t_alfa,
                          delta = delta, potencia = potencia, beta = beta,
                          grf = FALSE))
      comentario <- "# Contraste de una media (t de Student)"
      args <- c(paste0("m = ", num_fmt(input$t_m)),
                paste0("s = ", num_fmt(input$t_s)),
                paste0("n = ", input$t_n),
                paste0("m0 = ", num_fmt(input$t_m0)),
                paste0("alfa = ", num_fmt(input$t_alfa)))

    } else if (identical(input$t_tipo, "dos")) {
      validate(
        need(input$t_n1 >= 2 && input$t_n2 >= 2, "Los tamanos muestrales deben ser al menos 2."),
        need(is.finite(input$t_s1) && input$t_s1 > 0, "Desv. tipica grupo 1 > 0."),
        need(is.finite(input$t_s2) && input$t_s2 > 0, "Desv. tipica grupo 2 > 0.")
      )
      r <- capturar(testt(m1 = input$t_m1, s1 = input$t_s1, n1 = input$t_n1,
                          m2 = input$t_m2, s2 = input$t_s2, n2 = input$t_n2,
                          m0 = input$t_m0_dos, alfa = input$t_alfa,
                          delta = delta, potencia = potencia, beta = beta,
                          grf = FALSE))
      comentario <- "# Dos muestras independientes"
      args <- c(paste0("m1 = ", num_fmt(input$t_m1)),
                paste0("s1 = ", num_fmt(input$t_s1)),
                paste0("n1 = ", input$t_n1),
                paste0("m2 = ", num_fmt(input$t_m2)),
                paste0("s2 = ", num_fmt(input$t_s2)),
                paste0("n2 = ", input$t_n2),
                paste0("m0 = ", num_fmt(input$t_m0_dos)),
                paste0("alfa = ", num_fmt(input$t_alfa)))

    } else {
      # Dos muestras relacionadas (medidas repetidas)
      if (identical(input$t_rel_modo, "prepost")) {
        validate(
          need(is.finite(input$t_pre_s) && input$t_pre_s > 0, "Desv. tipica pre > 0."),
          need(is.finite(input$t_post_s) && input$t_post_s > 0, "Desv. tipica post > 0."),
          need(input$t_rel_r > -1 && input$t_rel_r < 1,
               "La correlacion r debe estar entre -1 y 1."),
          need(input$t_rel_n >= 2, "El numero de parejas debe ser al menos 2.")
        )
        d_m <- input$t_post_m - input$t_pre_m
        var_d <- input$t_pre_s^2 + input$t_post_s^2 -
          2 * input$t_rel_r * input$t_pre_s * input$t_post_s
        validate(need(var_d > 0,
          "La combinacion de desviaciones tipicas y correlacion produce una varianza de la diferencia no positiva."))
        s_d <- sqrt(var_d)
        m0 <- input$t_rel_m0
        n_par <- input$t_rel_n
        r <- capturar(testt(m = d_m, s = s_d, n = n_par, m0 = m0,
                            alfa = input$t_alfa, delta = delta,
                            potencia = potencia, beta = beta, grf = FALSE))
        comentario <- paste0(
          "# Dos muestras relacionadas (medidas repetidas): diferencia post - pre\n",
          "d_media <- ", num_fmt(input$t_post_m), " - ", num_fmt(input$t_pre_m), "\n",
          "s_dif <- sqrt(", num_fmt(input$t_pre_s), "^2 + ",
          num_fmt(input$t_post_s), "^2 - 2 * ", num_fmt(input$t_rel_r), " * ",
          num_fmt(input$t_pre_s), " * ", num_fmt(input$t_post_s), ")\n",
          "# t-test sobre la diferencia (equivalente a muestras apareadas)")
        args <- c(paste0("m = ", num_fmt(d_m)),
                  paste0("s = ", num_fmt(s_d)),
                  paste0("n = ", n_par),
                  paste0("m0 = ", num_fmt(m0)),
                  paste0("alfa = ", num_fmt(input$t_alfa)))
      } else {
        validate(
          need(is.finite(input$t_dif_s) && input$t_dif_s > 0,
               "La desviacion tipica de la diferencia debe ser > 0."),
          need(input$t_dif_n >= 2, "El numero de parejas debe ser al menos 2.")
        )
        d_m <- input$t_dif_m
        s_d <- input$t_dif_s
        m0 <- input$t_dif_m0
        n_par <- input$t_dif_n
        r <- capturar(testt(m = d_m, s = s_d, n = n_par, m0 = m0,
                            alfa = input$t_alfa, delta = delta,
                            potencia = potencia, beta = beta, grf = FALSE))
        comentario <- paste0(
          "# Dos muestras relacionadas (medidas repetidas)\n",
          "# Datos resumidos de la diferencia intra-sujeto")
        args <- c(paste0("m = ", num_fmt(d_m)),
                  paste0("s = ", num_fmt(s_d)),
                  paste0("n = ", n_par),
                  paste0("m0 = ", num_fmt(m0)),
                  paste0("alfa = ", num_fmt(input$t_alfa)))
      }

      # El paquete rotula este caso como "una muestra"; se reetiqueta para
      # reflejar que el analisis es de medidas repetidas sobre la diferencia.
      r$texto <- sub("t-Test con una muestra",
                     "t-test para dos muestras relacionadas (medidas repetidas: post - pre)",
                     r$texto, fixed = TRUE)
      r$texto <- paste0(
        "# Nota: contraste sobre la diferencia intra-sujeto. ",
        "Media de la diferencia = ", round(d_m, 4),
        "; DT de la diferencia = ", round(s_d, 4),
        "; n parejas = ", n_par, "; m0 = ", round(m0, 4), ".\n\n",
        r$texto)
    }

    if (delta > 0) {
      args <- c(args,
                paste0("delta = ", num_fmt(delta)),
                paste0("potencia = ", num_fmt(potencia)))
    }

    code <- paste0("library(BioEstatR)\n", comentario, "\n",
                   "testt(", paste(args, collapse = ",\n      "),
                   ", grf = FALSE)")

    ultimo$t_out <- r$texto
    output$t_out <- renderText(r$texto)
    ultimo$t_code <- code
    output$t_code <- renderText(code)
  })

  # ---- Proporcion -----------------------------------------------------------
  observeEvent(input$p_go, {
    validate(
      need(input$p_n >= 1, "El tamano muestral debe ser >= 1."),
      need(input$p_x >= 0 && input$p_x <= input$p_n,
           "Los exitos deben estar entre 0 y n."),
      need(input$p_p0 > 0 && input$p_p0 < 1, "La proporcion H0 debe estar entre 0 y 1.")
    )
    r <- capturar(testp(x = input$p_x, n = input$p_n, p0 = input$p_p0,
                        alfa = input$p_alfa))
    ultimo$p_out <- r$texto
    output$p_out <- renderText(r$texto)
    output$p_code <- renderText({
      ultimo$p_code <- (function() {
      paste0("library(BioEstatR)\n",
             "testp(x = ", input$p_x, ", n = ", input$p_n, ",\n",
             "      p0 = ", input$p_p0, ", alfa = ", input$p_alfa, ")")
      })()
      ultimo$p_code
    })
  })

  # ---- Intervalos -----------------------------------------------------------
  observeEvent(input$ic_go, {
    if (identical(input$ic_tipo, "media")) {
      validate(
        need(input$ic_n >= 2, "El tamano muestral debe ser al menos 2."),
        need(is.finite(input$ic_s) && input$ic_s > 0, "Desv. tipica > 0.")
      )
      r <- capturar(icm(m = input$ic_m, s = input$ic_s, n = input$ic_n,
                        conf = input$ic_conf))
      code <- paste0("library(BioEstatR)\n",
                     "icm(m = ", input$ic_m, ", s = ", input$ic_s, ", n = ", input$ic_n, ",\n",
                     "    conf = ", input$ic_conf, ")")
    } else {
      validate(
        need(input$ic_np >= 1, "n >= 1."),
        need(input$ic_x >= 0 && input$ic_x <= input$ic_np, "Exitos entre 0 y n.")
      )
      r <- capturar(icp(x = input$ic_x, n = input$ic_np, conf = input$ic_conf))
      code <- paste0("library(BioEstatR)\n",
                     "icp(x = ", input$ic_x, ", n = ", input$ic_np, ",\n",
                     "    conf = ", input$ic_conf, ")")
    }
    ultimo$ic_out <- r$texto
    output$ic_out <- renderText(r$texto)
    ultimo$ic_code <- code
    output$ic_code <- renderText(code)
  })

  # ---- Tablas 2x2 -----------------------------------------------------------
  observeEvent(input$x2_go, {
    r <- capturar(tabla2x2(
      o11 = input$x2_o11, o12 = input$x2_o12,
      o21 = input$x2_o21, o22 = input$x2_o22,
      estudio = input$x2_estudio))
    ultimo$x2_out <- r$texto
    output$x2_out <- renderText(r$texto)
    output$x2_code <- renderText({
      ultimo$x2_code <- (function() {
      paste0("library(BioEstatR)\n",
             "tabla2x2(o11 = ", input$x2_o11, ", o12 = ", input$x2_o12, ",\n",
             "         o21 = ", input$x2_o21, ", o22 = ", input$x2_o22, ",\n",
             "         estudio = \"", input$x2_estudio, "\")")
      })()
      ultimo$x2_code
    })
  })

  observeEvent(input$x2_go_data, {
    req(input$x2_fvar, input$x2_cvar)
    df <- datos()
    validate(need(all(c(input$x2_fvar, input$x2_cvar) %in% names(df)),
                  "Variables no validas."))
    f <- droplevels(as.factor(df[[input$x2_fvar]]))
    c <- droplevels(as.factor(df[[input$x2_cvar]]))
    validate(need(nlevels(f) == 2 && nlevels(c) == 2,
                  "Ambas variables deben tener exactamente 2 categorias para una tabla 2x2."))
    r <- capturar(tabla2x2(fvar = f, cvar = c))
    ultimo$x2_out <- r$texto
    output$x2_out <- renderText(r$texto)
    output$x2_code <- renderText({
      ultimo$x2_code <- (function() {
      paste0("library(BioEstatR)\n",
             "tabla2x2(fvar = ", code_var(df, input$x2_fvar), ",\n",
             "         cvar = ", code_var(df, input$x2_cvar), ")")
      })()
      ultimo$x2_code
    })
  })

  # ---- McNemar --------------------------------------------------------------
  observeEvent(input$mc_go, {
    r <- capturar(testmcnemar(
      n11 = input$mc_n11, n12 = input$mc_n12,
      n21 = input$mc_n21, n22 = input$mc_n22,
      alfa = input$mc_alfa))
    ultimo$mc_out <- r$texto
    output$mc_out <- renderText(r$texto)
    output$mc_code <- renderText({
      ultimo$mc_code <- (function() {
      paste0("library(BioEstatR)\n",
             "testmcnemar(n11 = ", input$mc_n11, ", n12 = ", input$mc_n12, ",\n",
             "             n21 = ", input$mc_n21, ", n22 = ", input$mc_n22, ",\n",
             "             alfa = ", input$mc_alfa, ")")
      })()
      ultimo$mc_code
    })
  })

  # ---- Regresion ------------------------------------------------------------
  observeEvent(input$reg_go, {
    req(input$reg_y, input$reg_x)
    df <- datos()
    xs <- input$reg_x
    validate(
      need(input$reg_y %in% names(df), "Variable respuesta no valida."),
      need(length(xs) > 0, "Seleccione al menos una variable explicativa."),
      need(all(xs %in% names(df)), "Variables explicativas no validas.")
    )
    form <- stats::as.formula(paste(input$reg_y, "~", paste(xs, collapse = " + ")))

    r <- switch(input$reg_tipo,
      "rls" = {
        validate(need(length(xs) == 1,
                      "La regresion lineal simple admite una sola variable X. Use 'Lineal multiple'."))
        capturar(rls(form, data = df, grf = FALSE))
      },
      "rlm" = capturar(rlm(form, data = df, grf = FALSE)),
      "rlogits" = capturar(rlogits(form, data = df, grf = FALSE))
    )

    ultimo$reg_out <- r$texto
    output$reg_out <- renderText(r$texto)
    output$reg_code <- renderText({
      ultimo$reg_code <- (function() {
      fun <- input$reg_tipo
      paste0("library(BioEstatR)\n",
             "# Ajuste del modelo\n",
             fun, "(", deparse(form), ", data = ", "datos", ", grf = FALSE)")
      })()
      ultimo$reg_code
    })
  })

  # ---- Tamano muestral ------------------------------------------------------
  observeEvent(input$n_go, {
    if (identical(input$n_tipo, "nm")) {
      req(input$nm_var)
      df <- datos()
      validate(
        need(input$nm_var %in% names(df), "Variable no valida."),
        need(sum(is.finite(df[[input$nm_var]])) > 2, "La variable necesita al menos 3 valores."),
        need(input$n_d > 0, "La precision debe ser > 0.")
      )
      r <- capturar(nm(x = df[[input$nm_var]], d = input$n_d, conf = input$n_conf))
      code <- paste0("library(BioEstatR)\n",
                     "# n para estimar una media a partir de una muestra piloto\n",
                     "nm(x = datos$", input$nm_var, ", d = ", input$n_d, ",\n",
                     "   conf = ", input$n_conf, ")")
    } else if (identical(input$n_tipo, "np")) {
      validate(
        need(input$n_pn >= 1, "El tamano de la muestra piloto debe ser >= 1."),
        need(input$n_px >= 0 && input$n_px <= input$n_pn, "Los casos deben estar entre 0 y n."),
        need(input$n_dp > 0, "La precision debe ser > 0.")
      )
      r <- capturar(np(x = input$n_px, n = input$n_pn, d = input$n_dp,
                       conf = input$n_conf))
      code <- paste0("library(BioEstatR)\n",
                     "# n para estimar una proporcion a partir de una muestra piloto\n",
                     "np(x = ", input$n_px, ", n = ", input$n_pn, ",\n",
                     "   d = ", input$n_dp, ", conf = ", input$n_conf, ")")
    } else {
      validate(need(input$n_lmax > 0 && input$n_dl > 0, "Los valores deben ser > 0."))
      r <- capturar(nl(lmax = input$n_lmax, d = input$n_dl, conf = input$n_conf))
      code <- paste0("library(BioEstatR)\n",
                     "nl(lmax = ", input$n_lmax, ", d = ", input$n_dl, ",\n",
                     "   conf = ", input$n_conf, ")")
    }
    ultimo$n_out <- r$texto
    output$n_out <- renderText(r$texto)
    ultimo$n_code <- code
    output$n_code <- renderText(code)
  })

  # ---- Descargas ------------------------------------------------------------
  registrar_descarga <- function(id, titulo) {
    salida_id <- paste0(sub("_dl$", "", id), "_out")
    codigo_id <- paste0(sub("_dl$", "", id), "_code")

    output[[id]] <- downloadHandler(
      filename = function() {
        paste0("BioEstatR_", sub("_dl$", "", id), "_",
               format(Sys.time(), "%Y%m%d_%H%M"), ".docx")
      },
      content = function(fichero) {
        txt <- ultimo[[salida_id]]
        cod <- ultimo[[codigo_id]]
        if (is.null(txt) || !nzchar(txt)) {
          txt <- "Todavia no se ha calculado ningun resultado en esta pestana."
        }
        if (!requireNamespace("officer", quietly = TRUE)) {
          writeLines(c(txt, "", if (!is.null(cod)) c("Codigo R:", cod)),
                     fichero)
          return(invisible(NULL))
        }
        escribir_docx(txt, cod, titulo = titulo, fichero = fichero)
      }
    )

    output[[paste0(id, "_txt")]] <- downloadHandler(
      filename = function() {
        paste0("BioEstatR_", sub("_dl$", "", id), "_",
               format(Sys.time(), "%Y%m%d_%H%M"), ".txt")
      },
      content = function(fichero) {
        txt <- ultimo[[salida_id]]
        cod <- ultimo[[codigo_id]]
        if (is.null(txt) || !nzchar(txt)) {
          txt <- "Todavia no se ha calculado ningun resultado en esta pestana."
        }
        writeLines(c(txt, "", "--- Codigo R equivalente ---",
                     if (is.null(cod)) "" else cod), fichero)
      }
    )
  }

  for (par in list(
    c("descr_dl", "Analisis descriptivo"),
    c("freq_dl", "Tabla de frecuencias"),
    c("norm_dl", "Test de normalidad"),
    c("t_dl", "Comparacion de medias"),
    c("p_dl", "Contraste de una proporcion"),
    c("ic_dl", "Estimacion por intervalo"),
    c("x2_dl", "Tabla 2x2"),
    c("mc_dl", "Test de McNemar"),
    c("reg_dl", "Modelo de regresion"),
    c("n_dl", "Tamano muestral")
  )) {
    registrar_descarga(par[1], par[2])
  }
}

# -----------------------------------------------------------------------------
# Auxiliares de presentacion
# -----------------------------------------------------------------------------

# Representa un subconjunto de columnas de forma legible para el codigo mostrado.
deparse_subset <- function(df, vars) {
  paste0("datos[, c(", paste0('"', vars, '"', collapse = ", "), ")]")
}

# Referencia a una variable del dataset para el codigo mostrado.
code_var <- function(df, var) {
  paste0("datos$", var)
}

# Grafico QQ-plot + histograma con densidad normal superpuesta (base graphics,
# para no exigir ggplot2 en el estudiante).
graf_normal <- function(x, nombre) {
  x <- x[is.finite(x)]
  op <- graphics::par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
  on.exit(graphics::par(op), add = TRUE)

  hist(x, probability = TRUE, col = "#e9ecef", border = "white",
       main = paste("Histograma:", nombre), xlab = nombre)
  if (length(x) > 2 && stats::sd(x) > 0) {
    curve <- stats::dnorm
    graphics::curve(curve(x, mean = mean(x), sd = stats::sd(x)),
                    add = TRUE, col = "#0d6efd", lwd = 2)
  }

  stats::qqnorm(x, main = paste("QQ-plot:", nombre), pch = 19,
                col = "#0d6efd", cex = 0.8)
  stats::qqline(x, col = "#dc3545", lwd = 2)
}

shinyApp(ui, server)
