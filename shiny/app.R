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
# Autor: interfaz docente sobre BioEstatR (Pedro Femia / M. A. Luque Fernandez)
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
  tagList(
    verbatimTextOutput(id_salida),
    div(
      class = "d-flex gap-2 mt-2 mb-2",
      downloadButton(id_descarga, "Descargar informe",
                     class = "btn-sm btn-outline-success"),
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
# Interfaz
# -----------------------------------------------------------------------------

ui <- navbarPage(
  title = "BioEstatR · Bioestadistica con R",
  windowTitle = "BioEstatR - Bioestadistica con R",
  collapsible = TRUE,

  header = tags$head(
    tags$style(HTML("
      .navbar-brand { font-weight: 600; }
      body { padding-bottom: 2rem; }
      pre { background: #f7f7f9; border: 1px solid #e3e3e6; border-radius: 6px;
            padding: 12px; font-size: 12.5px; line-height: 1.45;
            max-height: 460px; overflow-y: auto; }
      details { margin-top: 14px; }
      details summary { cursor: pointer; color: #0d6efd; font-weight: 500; }
      .ayuda { color: #6c757d; font-size: 13px; margin-bottom: 10px; }
      .resultado { margin-top: 8px; }
    "))
  ),

  # ---------------------------------------------------------------- Inicio ----
  tabPanel(
    "Inicio",
    fluidRow(
      column(
        12,
        h2("Bioestadistica con R, sin escribir codigo"),
        p(class = "ayuda",
          "Esta aplicacion permite usar las funciones del paquete ",
          strong("BioEstatR"), " seleccionando opciones con el raton. ",
          "En cada resultado puede desplegar ", em("Ver el codigo R equivalente"),
          " para aprender la instruccion que produce ese analisis."),
        hr(),
        h4("Como funciona"),
        tags$ol(
          tags$li("Elija un conjunto de datos (por defecto ", code("osteo"),
                  ", que acompana al paquete: 94 pacientes con 27 variables)."),
          tags$li("Vaya a la pestana del analisis que necesite."),
          tags$li("Seleccione las variables y pulse el boton de calcular."),
          tags$li("Copie el informe, o abra el codigo R para reproducirlo.")
        ),
        hr(),
        h4("Pestanas disponibles"),
        tags$table(
          class = "table table-sm table-striped",
          tags$thead(tags$tr(tags$th("Pestana"), tags$th("Funcion"), tags$th("Para que sirve"))),
          tags$tbody(
            tags$tr(tags$td("Descriptiva"),   tags$td(code("descriptiva")), tags$td("Resumen de una o varias variables")),
            tags$tr(tags$td("Descriptiva"),   tags$td(code("freq")),         tags$td("Tabla de frecuencias")),
            tags$tr(tags$td("Normalidad"),    tags$td(code("testnormal")),   tags$td("Shapiro-Wilk, QQ-plot")),
            tags$tr(tags$td("Medias"),        tags$td(code("testt")),        tags$td("t de Student: 1 y 2 muestras")),
            tags$tr(tags$td("Proporciones"),  tags$td(code("testp")),        tags$td("Contraste de una proporcion")),
            tags$tr(tags$td("Intervalos"),    tags$td(code("icm, icp")),     tags$td("IC para media y proporcion")),
            tags$tr(tags$td("Tablas 2x2"),    tags$td(code("tabla2x2")),     tags$td("Chi-cuadrado, OR, RR")),
            tags$tr(tags$tr(tags$td("Tablas RxC"), tags$td(code("tablarxc")), tags$td("Chi-cuadrado, asociacion"))),
            tags$tr(tags$td("McNemar"),       tags$td(code("testmcnemar")),   tags$td("Datos apareados")),
            tags$tr(tags$td("Regresion"),     tags$td(code("rls, rlm")),      tags$td("Lineal simple y multiple")),
            tags$tr(tags$td("Regresion"),     tags$td(code("rlogits")),       tags$td("Logistica")),
            tags$tr(tags$td("Tamano muestral"), tags$td(code("nm, np, nl")),  tags$td("Calcular n necesario"))
          )
        ),
        hr(),
        p(class = "ayuda",
          "Version del paquete: ", textOutput("version_pkg", inline = TRUE))
      )
    )
  ),

  # ----------------------------------------------------------- Descriptiva ----
  tabPanel(
    "Descriptiva",
    sidebarLayout(
      sidebarPanel(
        width = 3,
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
        h4("Analisis descriptivo"),
        caja_resultado("descr_out", "descr_code", "descr_dl"),
        hr(),
        h4("Distribucion de frecuencias"),
        caja_resultado("freq_out", "freq_code", "freq_dl")
      )
    )
  ),

  # ------------------------------------------------------------ Normalidad ----
  tabPanel(
    "Normalidad",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        uiOutput("ui_norm_dataset"),
        uiOutput("ui_norm_var"),
        p(class = "ayuda", "Contrasta si la variable sigue una distribucion normal (Shapiro-Wilk)."),
        actionButton("norm_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        h4("Test de normalidad"),
        caja_resultado("norm_out", "norm_code", "norm_dl"),
        plotOutput("norm_plot", height = "420px")
      )
    )
  ),

  # ---------------------------------------------------------------- Medias ----
  tabPanel(
    "Medias",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        radioButtons("t_tipo", "Tipo de contraste",
          choices = c("Una muestra" = "una", "Dos muestras independientes" = "dos"),
          selected = "una"),
        conditionalPanel(
          "input.t_tipo == 'una'",
          numericInput("t_m", "Media muestral", 25, step = 0.1),
          numericInput("t_s", "Desviacion tipica", 4, min = 0, step = 0.1),
          numericInput("t_n", "Tamano muestral", 30, min = 2, step = 1),
          numericInput("t_m0", "Media hipotetica (H0)", 23, step = 0.1)
        ),
        conditionalPanel(
          "input.t_tipo == 'dos'",
          numericInput("t_m1", "Media grupo 1", 25, step = 0.1),
          numericInput("t_s1", "Desv. tipica grupo 1", 4, min = 0, step = 0.1),
          numericInput("t_n1", "n grupo 1", 30, min = 2, step = 1),
          numericInput("t_m2", "Media grupo 2", 23, step = 0.1),
          numericInput("t_s2", "Desv. tipica grupo 2", 3.5, min = 0, step = 0.1),
          numericInput("t_n2", "n grupo 2", 30, min = 2, step = 1)
        ),
        numericInput("t_alfa", "Nivel de significacion (alfa)", 0.05, 0.001, 0.2, 0.001),
        actionButton("t_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        h4("Comparacion de medias (t de Student)"),
        caja_resultado("t_out", "t_code", "t_dl")
      )
    )
  ),

  # ---------------------------------------------------------- Proporciones ----
  tabPanel(
    "Proporciones",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        numericInput("p_x", "Numero de exitos", 40, min = 0, step = 1),
        numericInput("p_n", "Tamano muestral", 100, min = 1, step = 1),
        numericInput("p_p0", "Proporcion hipotetica (H0)", 0.5, 0.001, 0.999, 0.001),
        numericInput("p_alfa", "Nivel de significacion (alfa)", 0.05, 0.001, 0.2, 0.001),
        actionButton("p_go", "Calcular", class = "btn-primary w-100")
      ),
      mainPanel(
        width = 9,
        h4("Contraste de una proporcion"),
        caja_resultado("p_out", "p_code", "p_dl")
      )
    )
  ),

  # ----------------------------------------------------------- Intervalos ----
  tabPanel(
    "Intervalos",
    sidebarLayout(
      sidebarPanel(
        width = 3,
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
        h4("Estimacion por intervalo"),
        caja_resultado("ic_out", "ic_code", "ic_dl")
      )
    )
  ),

  # ------------------------------------------------------------ Tablas 2x2 ----
  tabPanel(
    "Tablas 2x2",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        p(class = "ayuda", "Introduzca las cuatro frecuencias observadas."),
        numericInput("x2_o11", "Fila 1 · Columna 1", 25, min = 0, step = 1),
        numericInput("x2_o12", "Fila 1 · Columna 2", 10, min = 0, step = 1),
        numericInput("x2_o21", "Fila 2 · Columna 1", 12, min = 0, step = 1),
        numericInput("x2_o22", "Fila 2 · Columna 2", 23, min = 0, step = 1),
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
        h4("Analisis de tabla 2x2"),
        caja_resultado("x2_out", "x2_code", "x2_dl")
      )
    )
  ),

  # -------------------------------------------------------------- McNemar ----
  tabPanel(
    "McNemar",
    sidebarLayout(
      sidebarPanel(
        width = 3,
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
        h4("Test de McNemar"),
        caja_resultado("mc_out", "mc_code", "mc_dl")
      )
    )
  ),

  # ------------------------------------------------------------ Regresion ----
  tabPanel(
    "Regresion",
    sidebarLayout(
      sidebarPanel(
        width = 3,
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
        h4("Modelo de regresion"),
        caja_resultado("reg_out", "reg_code", "reg_dl")
      )
    )
  ),

  # ------------------------------------------------------ Tamano muestral ----
  tabPanel(
    "Tamano muestral",
    sidebarLayout(
      sidebarPanel(
        width = 3,
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
        h4("Tamano muestral necesario"),
        caja_resultado("n_out", "n_code", "n_dl")
      )
    )
  ),

  # ------------------------------------------------------------- Datasets ----
  tabPanel(
    "Mis datos",
    sidebarLayout(
      sidebarPanel(
        width = 3,
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
        h4("Vista de los datos"),
        tableOutput("tabla_datos"),
        hr(),
        h4("Estructura"),
        verbatimTextOutput("str_datos")
      )
    )
  ),

  # --------------------------------------------------------------- Ayuda ----
  tabPanel(
    "Ayuda",
    fluidRow(column(
      12,
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

  # ---- t de Student ---------------------------------------------------------
  observeEvent(input$t_go, {
    if (identical(input$t_tipo, "una")) {
      validate(
        need(is.finite(input$t_m), "Indique la media."),
        need(is.finite(input$t_s) && input$t_s > 0, "La desviacion tipica debe ser > 0."),
        need(input$t_n >= 2, "El tamano muestral debe ser al menos 2.")
      )
      r <- capturar(testt(m = input$t_m, s = input$t_s, n = input$t_n,
                          m0 = input$t_m0, alfa = input$t_alfa, grf = FALSE))
      code <- paste0(
        "library(BioEstatR)\n",
        "# Contraste de una media (t de Student)\n",
        "testt(m = ", input$t_m, ", s = ", input$t_s, ", n = ", input$t_n, ",\n",
        "      m0 = ", input$t_m0, ", alfa = ", input$t_alfa, ", grf = FALSE)"
      )
    } else {
      validate(
        need(input$t_n1 >= 2 && input$t_n2 >= 2, "Los tamanos muestrales deben ser al menos 2."),
        need(is.finite(input$t_s1) && input$t_s1 > 0, "Desv. tipica grupo 1 > 0."),
        need(is.finite(input$t_s2) && input$t_s2 > 0, "Desv. tipica grupo 2 > 0.")
      )
      r <- capturar(testt(m1 = input$t_m1, s1 = input$t_s1, n1 = input$t_n1,
                          m2 = input$t_m2, s2 = input$t_s2, n2 = input$t_n2,
                          alfa = input$t_alfa, grf = FALSE))
      code <- paste0(
        "library(BioEstatR)\n",
        "# Dos muestras independientes\n",
        "testt(m1 = ", input$t_m1, ", s1 = ", input$t_s1, ", n1 = ", input$t_n1, ",\n",
        "      m2 = ", input$t_m2, ", s2 = ", input$t_s2, ", n2 = ", input$t_n2, ",\n",
        "      alfa = ", input$t_alfa, ", grf = FALSE)"
      )
    }
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
