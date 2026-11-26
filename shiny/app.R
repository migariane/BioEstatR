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
#   Miguel \u00c1ngel Luque-Fern\u00e1ndez, MA - MSc - MPH - PhD
#   Catedr\u00e1tico - Dpto. de Estad\u00edstica e Investigaci\u00f3n Operativa
#   Universidad de Granada (UGR)
# Coautores del paquete BioEstatR:
#   Pedro Jes\u00fas Femia Marzo, Miguel \u00c1ngel Montero Alonso y
#   Juan Manuel Melchor Rodr\u00edguez
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
    div(class = "result-eyebrow",
        icon("chart-bar"), " Resultado del an\u00e1lisis"),
    div(class = "result-body",
        verbatimTextOutput(id_salida)),
    div(
      class = "result-actions",
      downloadButton(id_descarga, "Informe Word",
                     class = "btn-sm btn-success"),
      downloadButton(paste0(id_descarga, "_txt"), "Texto plano",
                     class = "btn-sm btn-outline-secondary")
    ),
    tags$details(
      class = "code-details",
      tags$summary(icon("code"), " Ver el c\u00f3digo R equivalente"),
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
    /* Marca UGR */
    --ugr-blue:  #002855;
    --ugr-blue2: #003d7c;
    --ugr-blue3: #0a4f9e;
    --ugr-gold:  #FFB81C;
    /* Superficies y texto */
    --bg:        #f6f5f1;
    --surface:   #ffffff;
    --surface-2: #f8fafc;
    --border:    #e2e8f0;
    --text:      #24303f;
    --text-muted:#64748b;
    --text-soft: #8a97a8;
    /* Semanticos */
    --success:   #157347;
    --danger:    #b42318;
    --warning:   #b45309;
    /* Escala de espaciado (8px) */
    --s1: 4px;  --s2: 8px;  --s3: 12px;
    --s4: 16px; --s5: 24px; --s6: 32px;
    /* Radios y sombras */
    --r-sm: 6px; --r-md: 10px; --r-lg: 14px;
    --shadow-1: 0 1px 2px rgba(15,27,45,.06), 0 1px 3px rgba(15,27,45,.05);
    --shadow-2: 0 6px 18px rgba(15,27,45,.10);
    --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    --font-mono: ui-monospace, SFMono-Regular, Menlo, Consolas, 'Liberation Mono', monospace;
  }

  html { font-size: 16px; }
  body {
    background-color: var(--bg);
    color: var(--text);
    font-family: var(--font-sans);
    line-height: 1.55;
    -webkit-font-smoothing: antialiased;
  }
  h1, h2, h3, h4, h5 {
    color: var(--ugr-blue);
    font-weight: 700;
    letter-spacing: -0.01em;
  }
  h2 { font-size: 1.45rem; }
  h3 { font-size: 1.2rem; }
  h4 { font-size: 1.05rem; }
  p { max-width: 78ch; }
  a { color: var(--ugr-blue2); }

  :focus-visible {
    outline: 3px solid var(--ugr-gold);
    outline-offset: 2px;
    border-radius: 4px;
  }

  /* --- Cabecera de marca --- */
  .ugr-hero {
    background: linear-gradient(135deg, var(--ugr-blue) 0%, var(--ugr-blue2) 100%);
    color: #fff;
    padding: var(--s6);
    margin: 0 0 var(--s5) 0;
    border-bottom: 4px solid var(--ugr-gold);
    border-radius: 0 0 var(--r-lg) var(--r-lg);
  }
  .ugr-hero h1 {
    margin: 0;
    font-size: 2rem;
    font-weight: 700;
    color: #fff;
    letter-spacing: -0.02em;
  }
  .ugr-hero .sub {
    color: var(--ugr-gold);
    font-weight: 600;
    font-size: .95rem;
    margin: var(--s2) 0 0 0;
  }
  .ugr-hero .author {
    color: #cbd5e1;
    font-size: .84rem;
    line-height: 1.6;
    margin: var(--s4) 0 0 0;
  }
  .ugr-logo-container {
    display: flex;
    align-items: center;
    justify-content: flex-end;
  }
  .ugr-logo {
    height: 64px;
    width: auto;
    background: #fff;
    padding: 6px 12px;
    border-radius: var(--r-sm);
    box-shadow: var(--shadow-1);
  }

  /* --- Barra de navegacion (Bootstrap 5) --- */
  .navbar {
    background: linear-gradient(135deg, var(--ugr-blue), var(--ugr-blue2)) !important;
    border: none !important;
    border-bottom: 3px solid var(--ugr-gold) !important;
    border-radius: 0 !important;
    box-shadow: var(--shadow-1);
    padding-top: var(--s2);
    padding-bottom: var(--s2);
    margin-bottom: 0 !important;
  }
  .navbar .navbar-brand { color: #fff !important; font-weight: 700; letter-spacing: -0.01em; }
  .navbar .nav-link {
    color: rgba(255,255,255,.88) !important;
    font-weight: 500;
    font-size: .93rem;
    padding: .5rem .8rem !important;
    border-radius: var(--r-sm);
  }
  .navbar .nav-link:hover,
  .navbar .nav-link:focus {
    color: #fff !important;
    background: rgba(255,255,255,.08) !important;
  }
  .navbar .nav-link.active,
  .navbar .nav-item.active > .nav-link {
    color: var(--ugr-gold) !important;
    background: rgba(255,184,28,.14) !important;
  }
  .navbar .dropdown-menu {
    border: 1px solid var(--border);
    border-radius: var(--r-md);
    box-shadow: var(--shadow-2);
    padding: var(--s1);
  }
  .navbar .dropdown-item { border-radius: var(--r-sm); padding: .45rem .7rem; font-size: .92rem; }
  .navbar .dropdown-item:hover,
  .navbar .dropdown-item:focus { background: #eef4fc; color: var(--ugr-blue); }
  .navbar .dropdown-item.active,
  .navbar .dropdown-item:active { background: var(--ugr-blue2); color: #fff; }
  .ugr-subbar {
    background: var(--surface);
    border-bottom: 1px solid var(--border);
    padding: 10px var(--s5);
    font-size: .78rem;
    color: var(--text-muted);
    margin-bottom: var(--s5);
  }
  .ugr-subbar strong { color: var(--ugr-blue); }
  .ugr-subbar .dot { color: var(--ugr-gold); font-weight: 700; }

  /* --- Tarjetas --- */
  .card-ugr,
  .result-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--r-lg);
    padding: var(--s5);
    margin-bottom: var(--s4);
    box-shadow: var(--shadow-1);
  }
  .card-ugr { border-top: 3px solid var(--ugr-blue2); }
  .card-ugr > h3,
  .card-ugr > h4 {
    margin: 0 0 var(--s3) 0;
    color: var(--ugr-blue);
    font-weight: 700;
    padding-bottom: var(--s2);
    border-bottom: 1px solid var(--border);
  }
  .result-card { border-left: 4px solid var(--ugr-gold); }
  .result-eyebrow {
    display: flex;
    align-items: center;
    gap: var(--s2);
    font-size: .72rem;
    font-weight: 700;
    letter-spacing: .08em;
    text-transform: uppercase;
    color: var(--text-muted);
    margin-bottom: var(--s2);
  }
  .result-actions {
    display: flex;
    flex-wrap: wrap;
    gap: var(--s2);
    margin: var(--s3) 0 var(--s2) 0;
  }

  /* --- Salida de resultados --- */
  pre, pre.shiny-text-output {
    background: var(--surface-2);
    color: var(--text);
    border: 1px solid var(--border);
    border-radius: var(--r-md);
    padding: var(--s3) var(--s4);
    font-family: var(--font-mono);
    font-size: .8rem;
    line-height: 1.55;
    font-variant-numeric: tabular-nums;
    white-space: pre-wrap;
    word-break: break-word;
    max-height: 520px;
    overflow: auto;
  }
  details { margin-top: var(--s3); }
  details summary {
    cursor: pointer;
    color: var(--ugr-blue2);
    font-weight: 600;
    font-size: .9rem;
  }
  details summary:hover { color: var(--ugr-blue); }
  details pre { background: #f1f5f9; }

  /* --- Tablas --- */
  table.table { font-variant-numeric: tabular-nums; margin-bottom: 0; }
  table.table thead th {
    background: #eef2f7;
    color: var(--ugr-blue);
    font-weight: 700;
    border-bottom: 2px solid var(--border) !important;
    white-space: nowrap;
  }
  table.table tbody tr:hover { background: #f6f9fd; }

  /* --- Formularios --- */
  .form-label, label, .control-label {
    font-weight: 600;
    color: #334155;
    font-size: .86rem;
  }
  .form-control, .form-select,
  input[type=number], input[type=text], select {
    border-radius: var(--r-sm);
    border-color: #cbd5e1;
  }
  .form-control:focus, .form-select:focus {
    border-color: var(--ugr-blue2);
    box-shadow: 0 0 0 .2rem rgba(0,61,124,.15);
  }
  .shiny-input-container { margin-bottom: var(--s3); }
  .ayuda { color: var(--text-muted); font-size: .8rem; margin-bottom: var(--s2); }
  .sidebar-panel-scroll {
    overflow-y: auto;
    max-height: 86vh;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--r-lg);
    box-shadow: var(--shadow-1);
    padding: var(--s4);
  }

  /* --- Botones --- */
  .btn {
    border-radius: var(--r-sm);
    font-weight: 600;
    transition: background-color .15s ease, box-shadow .15s ease;
  }
  .btn-primary { background: var(--ugr-blue2); border-color: var(--ugr-blue2); }
  .btn-primary:hover, .btn-primary:focus { background: var(--ugr-blue); border-color: var(--ugr-blue); }
  .btn-outline-primary { color: var(--ugr-blue2); border-color: var(--ugr-blue2); }
  .btn-outline-primary:hover { background: var(--ugr-blue2); color: #fff; }
  .btn-success { background: var(--success); border-color: var(--success); }
  .btn-sm { font-size: .8rem; padding: .35rem .7rem; }

  /* --- Pie de pagina --- */
  .footer-ugr {
    text-align: center;
    color: var(--text-soft);
    font-size: .78rem;
    line-height: 1.7;
    padding: var(--s5) var(--s3) var(--s6) var(--s3);
    border-top: 3px solid var(--ugr-gold);
    margin-top: var(--s5);
    background: var(--surface);
  }
  .footer-ugr a { color: var(--ugr-blue2); font-weight: 600; }

  /* --- Varios --- */
  .badge-ugr {
    display: inline-block;
    background: #eef4fc;
    color: var(--ugr-blue2);
    border: 1px solid #d6e4f5;
    border-radius: 999px;
    padding: 2px 10px;
    font-size: .72rem;
    font-weight: 600;
  }

  /* --- Adaptacion movil --- */
  @media (max-width: 991px) {
    .ugr-hero { padding: var(--s5) var(--s4); }
    .ugr-logo { height: 52px; margin-top: var(--s4); }
    .ugr-subbar { display: none; }
    .sidebar-panel-scroll { max-height: none; }
  }

  /* --- Accesibilidad e impresion --- */
  @media (prefers-reduced-motion: reduce) {
    * { transition: none !important; animation: none !important; }
  }
  @media print {
    .navbar, .ugr-hero, .ugr-subbar, .footer-ugr,
    .sidebar-panel-scroll, .result-actions, details, .btn { display: none !important; }
    body { background: #fff; }
    .card-ugr, .result-card { box-shadow: none; border: 1px solid #ccc; break-inside: avoid; }
    pre { max-height: none; }
  }
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
        "Bioestad\u00edstica con R, sin escribir c\u00f3digo \u2013 Docencia e investigaci\u00f3n"),
      p(class = "author",
        # Enlace al libro del autor (hostado en Netlify).
        # Reemplaza "https://TU_LIBRO.netlify.app/" por la URL real del libro.
        tags$a(href = "https://TU_LIBRO.netlify.app/", target = "_blank",
          strong("Miguel \u00c1ngel Luque-Fern\u00e1ndez, MA \u00b7 MSc \u00b7 MPH \u00b7 PhD")),
        br(),
        "Catedr\u00e1tico \u2013 Dpto. de Estad\u00edstica e Investigaci\u00f3n Operativa, Universidad de Granada",
        br(),
        tags$span(style = "color:#cbd5e1;",
          "Coautores: Pedro Jes\u00fas Femia Marzo, Miguel \u00c1ngel Montero Alonso y Juan Manuel Melchor Rodr\u00edguez")
      )
    ),
    column(
      4, class = "ugr-logo-container",
      tags$img(src = "logo-ugr.png", class = "ugr-logo",
               alt = "Logo Universidad de Granada")
    )
  )
)

barra_autor <- div(
  class = "ugr-subbar",
  tags$span(strong("Universidad de Granada"),
            " \u2013 Dpto. de Estad\u00edstica e Investigaci\u00f3n Operativa"),
  tags$span(class = "dot", " \u00b7 "),
  tags$span(strong("Miguel \u00c1ngel Luque-Fern\u00e1ndez"), ", PhD \u2013 Catedr\u00e1tico"),
  tags$span(class = "dot", " \u00b7 "),
  tags$span("Coautores: Pedro Jes\u00fas Femia Marzo, Miguel \u00c1ngel Montero Alonso y ",
            "Juan Manuel Melchor Rodr\u00edguez")
)

pie_ugr <- tags$footer(
  class = "footer-ugr",
  HTML("BioEstatR &middot; Rutinas de bioestad\u00edstica en R &middot; "),
  tags$a(href = "https://migariane.github.io/BioEstatR/", target = "_blank",
         "migariane.github.io/BioEstatR"),
  HTML(" &middot; "),
  tags$a(href = "https://www.ugr.es", target = "_blank", "Universidad de Granada"),
  tags$br(),
  "Miguel \u00c1ngel Luque-Fern\u00e1ndez, MA \u00b7 MSc \u00b7 MPH \u00b7 PhD - ",
  "Catedr\u00e1tico, Dpto. de Estad\u00edstica e Investigaci\u00f3n Operativa, UGR",
  tags$br(),
  tags$span(style = "color:#94a3b8;",
    "Coautores: Pedro Jes\u00fas Femia Marzo, Miguel \u00c1ngel Montero Alonso y Juan Manuel Melchor Rodr\u00edguez")
)

# -----------------------------------------------------------------------------
# Interfaz
# -----------------------------------------------------------------------------

ui <- navbarPage(
  title = tagList(
    tags$img(src = "logo-ugr.png",
             style = "height:26px; background:#fff; padding:2px 6px; border-radius:4px; margin-right:8px; vertical-align:middle;",
             alt = "UGR"),
    "BioEstatR"
  ),
  windowTitle = "BioEstatR - Bioestad\u00edstica con R (UGR)",
  collapsible = TRUE,
  inverse = TRUE,
  theme = bslib::bs_theme(
    version = 5,
    primary = "#003d7c",
    secondary = "#5a6b82",
    success = "#157347",
    info = "#0d6efd",
    bg = "#f6f5f1",
    fg = "#24303f",
    base_font = bslib::font_collection(
      bslib::font_google("Inter", local = FALSE),
      "system-ui", "Segoe UI", "Roboto", "Helvetica Neue", "Arial", "sans-serif"
    )
  ),

  header = tagList(estilos_ugr, barra_autor),
  footer = pie_ugr,

  # ------------------------------------------------------- Introduccion ----
  tabPanel(
    "Introducci\u00f3n",
    cabecera_ugr,
    fluidRow(
      column(
        8,
        div(
          class = "card-ugr",
          h3("Bioestad\u00edstica con R, sin escribir c\u00f3digo"),
          p(class = "ayuda",
            "Esta aplicacion permite usar las funciones del paquete ",
            strong("BioEstatR"), " seleccionando opciones con el raton. ",
            "En cada resultado puede desplegar ", em("Ver el codigo R equivalente"),
            " para aprender la instruccion que produce ese analisis."),
          hr(),
          h4("C\u00f3mo funciona"),
          tags$ol(
            tags$li("Elija un conjunto de datos en la pesta\u00f1a ", strong("Mis datos"),
                    " (por defecto ", code("osteo"),
                    ", que acompana al paquete: 94 pacientes con 27 variables)."),
            tags$li("Vaya a la pestana del analisis que necesite."),
            tags$li("Seleccione las variables y pulse el boton de calcular."),
            tags$li("Copie el informe, o abra el codigo R para reproducirlo.")
          ),
          hr(),
          h4("An\u00e1lisis de medias con potencia y tama\u00f1o muestral"),
          p(class = "ayuda",
            "La pesta\u00f1a ", strong("Medias"), " incluye el ",
            strong("t-test para medidas repetidas"), " (dos muestras relacionadas) ",
            "y, para cualquiera de los contrastes de medias, el ",
            strong("estudio de potencia y la estimaci\u00f3n del tama\u00f1o muestral"),
            " mediante los parametros ", code("delta"), " (efecto a detectar) y ",
            code("potencia"),
            ", tal y como los ofrece la funcion ", code("testt"), ".")
        )
      ),
      column(
        4,
        div(
          class = "card-ugr",
          h4("Pesta\u00f1as disponibles"),
          tags$table(
            class = "table table-sm table-striped",
            tags$thead(tags$tr(tags$th("Pesta\u00f1a"), tags$th("Funcion"))),
            tags$tbody(
              tags$tr(tags$td("Mis datos"),       tags$td(code("osteo / CSV / Excel"))),
              tags$tr(tags$td("Descriptiva"),     tags$td(code("descriptiva, freq"))),
              tags$tr(tags$td("Normalidad"),      tags$td(code("testnormal"))),
              tags$tr(tags$td("Medias"),          tags$td(code("testt"))),
              tags$tr(tags$td("Proporciones"),    tags$td(code("testp"))),
              tags$tr(tags$td("Intervalos"),      tags$td(code("icm, icp"))),
              tags$tr(tags$td("Tablas 2\u00d72"),      tags$td(code("tabla2x2"))),
              tags$tr(tags$td("McNemar"),         tags$td(code("testmcnemar"))),
              tags$tr(tags$td("Regresi\u00f3n"),       tags$td(code("rls, rlm, rlogits"))),
              tags$tr(tags$td("Tama\u00f1o muestral"), tags$td(code("nm, np, nl")))
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
        checkboxInput("descr_ic", "A\u00f1adir intervalos de confianza", FALSE),
        checkboxInput("descr_normal", "A\u00f1adir prueba de normalidad", FALSE),
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
        div(class = "card-ugr", h4("An\u00e1lisis descriptivo"),
            caja_resultado("descr_out", "descr_code", "descr_dl")),
        div(class = "card-ugr", h4("Distribuci\u00f3n de frecuencias"),
            caja_resultado("freq_out", "freq_code", "freq_dl"))
      )
    )
  ),

  navbarMenu(
    "An\u00e1lisis",
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
          numericInput("t_s", "Desviaci\u00f3n t\u00edpica", 4, min = 0, step = 0.1),
          numericInput("t_n", "Tama\u00f1o muestral", 30, min = 2, step = 1),
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
        numericInput("p_x", "N\u00famero de \u00e9xitos", 40, min = 0, step = 1),
        numericInput("p_n", "Tama\u00f1o muestral", 100, min = 1, step = 1),
        numericInput("p_p0", "Proporcion hipotetica (H0)", 0.5, 0.001, 0.999, 0.001),
        numericInput("p_alfa", "Nivel de significacion (alfa)", 0.05, 0.001, 0.2, 0.001),
        actionButton("p_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Contraste de una proporci\u00f3n"),
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
        radioButtons("ic_tipo", "Qu\u00e9 desea estimar",
          choices = c("Media" = "media", "Proporcion" = "prop")),
        conditionalPanel(
          "input.ic_tipo == 'media'",
          numericInput("ic_m", "Media muestral", 25, step = 0.1),
          numericInput("ic_s", "Desviaci\u00f3n t\u00edpica", 4, min = 0, step = 0.1),
          numericInput("ic_n", "Tama\u00f1o muestral", 30, min = 2, step = 1)
        ),
        conditionalPanel(
          "input.ic_tipo == 'prop'",
          numericInput("ic_x", "N\u00famero de \u00e9xitos", 40, min = 0, step = 1),
          numericInput("ic_np", "Tama\u00f1o muestral", 100, min = 1, step = 1)
        ),
        numericInput("ic_conf", "Nivel de confianza", 0.95, 0.5, 0.999, 0.001),
        actionButton("ic_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Estimaci\u00f3n por intervalo"),
            caja_resultado("ic_out", "ic_code", "ic_dl"))
      )
    )
  )
  ),

  navbarMenu(
    "Tablas",
  # ------------------------------------------------------------ Tablas 2x2 ----
  tabPanel(
    "Tablas 2\u00d72",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "sidebar-panel-scroll",
        p(class = "ayuda", "Introduzca las cuatro frecuencias observadas."),
        numericInput("x2_o11", "Fila 1 - Columna 1", 25, min = 0, step = 1),
        numericInput("x2_o12", "Fila 1 - Columna 2", 10, min = 0, step = 1),
        numericInput("x2_o21", "Fila 2 - Columna 1", 12, min = 0, step = 1),
        numericInput("x2_o22", "Fila 2 - Columna 2", 23, min = 0, step = 1),
        selectInput("x2_estudio", "Dise\u00f1o del estudio",
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
        div(class = "card-ugr", h4("An\u00e1lisis de tabla 2\u00d72"),
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
        numericInput("mc_alfa", "Nivel de significaci\u00f3n", 0.05, 0.001, 0.2, 0.001),
        actionButton("mc_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        div(class = "card-ugr", h4("Test de McNemar"),
            caja_resultado("mc_out", "mc_code", "mc_dl"))
      )
    )
  )
  ),

  # ------------------------------------------------------------ Regresi\u00f3n ----
  tabPanel(
    "Regresi\u00f3n",
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
        div(class = "card-ugr", h4("Modelo de regresi\u00f3n"),
            caja_resultado("reg_out", "reg_code", "reg_dl"))
      )
    )
  ),

  # ------------------------------------------------------ Tamano muestral ----
  tabPanel(
    "Tama\u00f1o muestral",
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
          radioButtons("n_nm_fuente", "Origen de la desviacion tipica",
            choices = c("Desde variable del dataset (muestra piloto)" = "datos",
                        "Valores introducidos manualmente" = "manual"),
            selected = "datos"),
          conditionalPanel(
            "input.n_nm_fuente == 'datos'",
            p(class = "ayuda",
              "La funcion ", code("nm"), " parte de una ",
              strong("muestra piloto"), " para estimar la desviacion tipica. ",
              "Seleccione una variable numerica de los datos cargados."),
            uiOutput("ui_nm_var")
          ),
          conditionalPanel(
            "input.n_nm_fuente == 'manual'",
            p(class = "ayuda",
              "Introduzca la desviacion tipica esperada y la precision deseada."),
            numericInput("n_s_manual", "Desviacion tipica (sigma)", 4, min = 0.001, step = 0.1),
            numericInput("n_nm_piloto", "Tamano de la muestra piloto (n)", 30, min = 2, step = 1)
          ),
          numericInput("n_d", "Precision deseada (margen de error)", 1, min = 0.001, step = 0.1)
        ),
        conditionalPanel(
          "input.n_tipo == 'np'",
          radioButtons("n_np_fuente", "Origen de la proporcion",
            choices = c("Valor introducido manualmente" = "manual",
                        "Desde variable del dataset" = "datos"),
            selected = "manual"),
          conditionalPanel(
            "input.n_np_fuente == 'manual'",
            p(class = "ayuda", "Estima n para una proporcion a partir de una muestra piloto."),
            numericInput("n_px", "Casos favorables en la muestra piloto", 40, min = 0, step = 1),
            numericInput("n_pn", "Tamano de la muestra piloto", 100, min = 1, step = 1)
          ),
          conditionalPanel(
            "input.n_np_fuente == 'datos'",
            p(class = "ayuda",
              "Seleccione una variable binaria (2 categorias) de los datos cargados y la categoria que considera 'caso' o exito."),
            uiOutput("ui_np_var"),
            uiOutput("ui_np_level")
          ),
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
        div(class = "card-ugr", h4("Tama\u00f1o muestral necesario"),
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

  # ---- Selectores para proporcion desde dataset (tamaño muestral) -----------
  output$ui_np_var <- renderUI({
    df <- datos()
    cats <- c(vars_cat(df), vars_num_con_cat(df))
    if (!length(cats)) cats <- names(df)
    selectInput("np_var", "Variable binaria (2 categorias)",
      choices = cats, selected = cats[1])
  })

  output$ui_np_level <- renderUI({
    req(input$np_var)
    df <- datos()
    vals <- unique(stats::na.omit(df[[input$np_var]]))
    # Solo tiene sentido para proporcion si hay 2 categorias (o se elige una como exito)
    selectInput("np_level", "Categoria 'exito' / caso",
      choices = vals, selected = vals[1])
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
      if (identical(input$n_nm_fuente, "datos")) {
        # ---- Media: desviacion tipica desde una variable del dataset ----
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
      } else {
        # ---- Media: valores introducidos manualmente ----
        validate(
          need(is.finite(input$n_s_manual) && input$n_s_manual > 0,
               "La desviacion tipica debe ser > 0."),
          need(is.finite(input$n_nm_piloto) && input$n_nm_piloto >= 2,
               "El tamano de la muestra piloto debe ser >= 2."),
          need(input$n_d > 0, "La precision debe ser > 0.")
        )
        r <- capturar(nm(s = input$n_s_manual, n = input$n_nm_piloto,
                         d = input$n_d, conf = input$n_conf))
        code <- paste0("library(BioEstatR)\n",
                       "# n para estimar una media con valores introducidos manualmente\n",
                       "nm(s = ", input$n_s_manual, ", n = ", input$n_nm_piloto, ", d = ", input$n_d, ",\n",
                       "   conf = ", input$n_conf, ")")
      }
    } else if (identical(input$n_tipo, "np")) {
      if (identical(input$n_np_fuente, "datos")) {
        # ---- Proporcion: desde una variable del dataset ----
        req(input$np_var, input$np_level)
        df <- datos()
        validate(
          need(input$np_var %in% names(df), "Variable no valida."),
          need(input$np_level %in% unique(stats::na.omit(df[[input$np_var]])),
               "Nivel de 'exito' no valido."),
          need(length(unique(stats::na.omit(df[[input$np_var]]))) <= 2,
               "Para una proporcion la variable debe ser binaria (2 categorias)."),
          need(input$n_dp > 0, "La precision debe ser > 0.")
        )
        r <- capturar(np(v = df[[input$np_var]], level = input$np_level,
                         d = input$n_dp, conf = input$n_conf))
        code <- paste0("library(BioEstatR)\n",
                       "# n para estimar una proporcion desde una variable del dataset\n",
                       "np(v = datos$", input$np_var, ", level = \"", input$np_level, "\", d = ", input$n_dp, ",\n",
                       "   conf = ", input$n_conf, ")")
      } else {
        # ---- Proporcion: valores introducidos manualmente ----
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
      }
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
