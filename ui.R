
## Load libraries

options(shiny.reactlog=TRUE) 

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library("shinyIncubator")
library(markdown)
library(dashboardthemes)

##

text_bioqura_house <- tagList(
    p("El Reglamento (CE) Nº 2073/2005 establece en su artículo 3 que los explotadores de em­presas alimentarias responsables de la fabricación de alimentos listos para el consumo tienen la obligación legal de realizar estudios de vida útil para investigar el cumplimiento de los criterios mi­crobiológicos cuando dichos alimentos puedan suponer un riesgo para la salud pública en relación con Listeria monocytogenes."),
    p("La Agencia Española Seguridad Alimentaria y Nutrición (AESAN) ha elaborado un “Documento de orientación para la verificación de estudios de vida útil en relación a Listeria monocytogenes en alimentos listos para el consumo” que sirva de herramienta a las autoridades competentes de inspección para verificar la idoneidad de los estudios de vida útil y que ha sido validado por Comité Científico (Informe AESAN-2019-001)."),
    p("Con el objetivo de facilitar la verificación de los estudios de vida útil, la aplicación a desarrollar debe incluir………………………….")
)

text_chicken_house <- tagList(
    p("El Reglamento de Ejecución (UE) 2019/627 establece que todas las aves y lagomorfos sacrificados deben de ser sometidos a una inspección post mortem. Sin embargo, también se recoge la posibilidad de que las autoridades competentes decidan someter a inspección post mortem solamente una muestra representativa de aves de cada manada o de cada lote de lagomorfos, siempre que se cumplan una serie de requisitos adicionales. "),
    p("De este modo se ha realizado un estudio conducente a proporcionar un método para calcular el número de animales que componen una muestra representativa, teniendo en cuenta el tamaño de la manada y el porcentaje de decomisos del matadero. "),
    p("El Comité Científico de la Agencia Española de Seguridad Alimentaria y Nutrición (AESAN) realizó un informe proponiendo una metodología para el diseño del tamaño de muestra (Informe AESAN-2020-006), así como para determinar si los resultados del muestreo indican que el sistema está fuera de control."),
    p("En este informe se propusieron dos métodos estadísticos: uno para el caso de que la población puede considerarse infinita y un segundo para casos en que no. "),
    p("Con el objetivo de facilitar la implementación de la inspección post mortem por muestreo en los mataderos, la aplicación a desarrollar debe incluir la metodología estadística para ambos casos. Consistirá en una herramienta en la que, basándose en el citado informe del Comité Científico, al introducir el tamaño de la manada/lote y el porcentaje de decomisos del matadero en cuestión, se obtiene el número de animales que deben someterse a inspección post mortem (muestra representativa), así como el número de decomisos totales que, en caso de superarse, indicarían que es necesario inspeccionar el 100% de animales de la manada/lote. ")
)
## App

title <- tags$a(href = "https://www.aesan.gob.es/AECOSAN/web/home/aecosan_inicio.htm",
                tags$img(src = "logo3.jpg", height = "50", width = "50"),
                tags$img(src = "logo-bioqura.png", height = "50", width = "120"))

dashboardPagePlus(
    # skin = "black",
    md = TRUE,
    rightsidebar = rightSidebar(
        rightSidebarTabContent(
            id = 1,
            icon = "desktop",
            title = "Idioma",
            active = TRUE,
            "Placeholder language picker"
            # skinSelector()
        )
    ),
    dashboardHeaderPlus(
        title = title,
        enable_rightsidebar = TRUE),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("Welcome", tabName = "welcome", icon = icon("home")),
            hr(),
            menuItem("Vida útil", icon = icon("calculator"),
                     menuSubItem("Home", tabName = "bioqura_house"),
                     menuSubItem("T101: IC proporcion positivos", tabName = "prop_test"),
                     menuSubItem("T102: Muestras con aw > límite", tabName = "aw_quantiles"),
                     menuSubItem("T103: Muestra con pH > límite", tabName = "pH_quantiles")
                     ),
            menuItem("Aves & lagomorfos", 
                     icon = icon("drumstick-bite"),
                     menuSubItem("Home", tabName = "chicken_house"),
                     menuSubItem("T200: Finito/infinito", tabName = "size_matters"),
                     menuSubItem("T201: Poblaciones infinitas", tabName = "infinite_chicken"),
                     menuSubItem("T202: Poblaciones finitas", tabName = "finite_chicken")
                     ),
            hr(),
            menuItem("Github page", icon = icon("github"),
                     href = "https://github.com/albgarre/tools_BIOQURA")
        )
    ),
    dashboardBody(
        shinyDashboardThemes(
            theme = "grey_dark"
        ),
        useShinyFeedback(),
        tabItems(
            tabItem(tabName = "chicken_house",
                    fluidPage(
                        fluidRow(
                            boxPlus(
                                width = 6, collapsible = FALSE, closable = FALSE,
                                title = "Muestreo de aves y lagomorfos",
                                tagList(
                                    fluidRow(column(12,text_chicken_house))
                                )
                            ),
                            boxPlus(
                                width = 6, collapsible = FALSE, closable = FALSE,
                                title = "Uso de la herramienta",
                                fluidRow(
                                    column(12,
                                           p("En primer lugar se debe utilizar la herramienta T200, para establecer el tamaño mínimo muestral para poder considerar una población infinita."),
                                           p("En caso positivo, se puede utilizar la herramienta T201 para calcular el máximo número de positivos admisible."),
                                           p("En caso negativo, se debe utilizar la herramienta T202.")
                                    )
                                ),
                                fluidRow(
                                    column(12,
                                           actionButton("example_chicken_1", "Ejemplo")
                                    )
                                )
                            )
                        ),
                        fluidRow(
                            boxPlus(
                                title = "Referencias", footer_padding = FALSE,
                                closable = FALSE,
                                downloadLink("get_informe", 
                                             "Informe del comité científico de AESAN (AESAN-2020-006)")
                            ),
                            boxPlus(
                                title = "Contacto", footer_padding = FALSE,
                                closable = FALSE,
                                HTML("Email Me: <a href='mailto:placeholder.aesan@gmail.com?Subject=Shiny%20Help' target='_top'>Placeholder AESAN</a>")
                            )
                        )
                    )
                    ),
            tabItem(tabName = "size_matters",
                    infiniteUI("sample_size")
                    
                    ),
            tabItem(tabName = "finite_chicken",
                    finite_sizeUI("finite_sample")
                    ),
            tabItem(tabName = "infinite_chicken",
                    infiniteAppUI("infinite_chicken")
            ),
            tabItem(tabName = "welcome",
                    fluidRow(
                        boxPlus(title = "Introduction",
                                status  = "info",
                                solidHeader = TRUE, closable = FALSE,
                                p("El análisis de riesgos, la estimación de la vida útil y el control dentro de la seguridad alimentaria requiere la aplicación de métodos relativamente avanzados de análisis estadístico. La implementación de estos métodos a situaciones reales puede ser compleja y, en mucho casos, requiere conocimientos de programación y desarrollo de software. Por esa razón, la Agencia Española de Seguridad Alimentaria y Nutrición (AESAN) ha implementado a través de la red BIOQURA un conjunto de herramientas de libre acceso para facilitar la aplicación de estos cálculos."),
                                tags$img(src = "logo3.jpg", height = "100", width = "100"),
                                tags$img(src = "logo-bioqura.png", height = "100", width = "240")
                                ),
                        boxPlus(title = "Listado de herramientas",
                                status = "info",
                                solidHeader = TRUE, closable = FALSE,
                                p("Las herramientas están divididas en dos grupos. En primer lugar, la red BIOQURA desarrolló las siguientes herramientas para apoyar estudios de vida útil:"),
                                tags$ul(
                                    tags$li("T101 (IC proporcion positivos) permite estimar la proporción de muestras positivas con respecto a un test (p.ej. presencia/ausencia de patógenos)."),
                                    tags$li("T102 (Muestras con aw > limite) calcula la proporción de muestras con una actividad del agua superior a un límite en base a un muestreo."),
                                    tags$li("T103 (Muestras con pH > limite) calcula la proporción de muestras con un pH superior a un límite en base a un muestreo.")
                                ),
                                p(paste("Posteriormente, como parte del Informe del Comité Científico de la Agencia Española de Seguridad Alimentaria  y  Nutrición  (AESAN)  sobre  el  tamaño  de  muestra  de  aves de corral o lagomorfos, que se puede considerar representativa para su inspección post mortem en el matadero (AESAN-2020-006),",
                                        "la herramientase extendió con las siguientes herramientas para ayudar en el diseño muestral:")
                                  ),
                                tags$ul(
                                    tags$li("T201 (Muestras infinitas) asiste en el diseño de planes de muestreo bajo la hipótesis de que el tamaño de la población es infinito."),
                                    tags$li("T202 (Muestras infinitas) asiste en el diseño de planes de muestreo bajo la hipótesis de que el tamaño de la población es finito.")
                                )
                                )
                    ),
                    fluidRow(
                        boxPlus(title = "BIOQURA",
                                status = "info",
                                solidHeader = TRUE, closable = FALSE,
                                p("La red BIOQURA se creo con el objetivo de desarrollar la estructura necesaria para llevar a cabo una priorización y evaluación de riesgo biológicos cuantitativa en España. Esta integrada por investigadores de distintos centros de investigación, universidades y organismos reguladores:"),
                                tags$ul(
                                    tags$li("Universidad Politecnica de Cartagena"),
                                    tags$li("Universidad de Leon"),
                                    tags$li("Universidad de Barcelona"),
                                    tags$li("Universidad de Zaragoza"),
                                    tags$li("Universidad de Cordoba"),
                                    tags$li("Instituto de Agroquímica y Tecnología de Alimentos IATA - CSIC"),
                                    tags$li("Centro de Edafología y Biología Aplicada del Segura CEBAS - CSIC"),
                                    tags$li("Centro Nacional de Tecnología y Seguridad de Alimentos (CNTA)"),
                                    tags$li("Tecnalia Research & Innovation"),
                                    tags$li("Agencia Española de Seguridad Alimentaria y Nutrición (AESAN)")
                                )
                                ),
                        boxPlus(title = "Contacto",
                                status = "info",
                                solidHeader = TRUE, closable = FALSE,
                                p("Para dudas con respecto al funcionamiento de la aplicación ponerse en contacto con Alberto Garre a través de:"),
                                p("alberto.garreperez@wur.nl"),
                                p("Para reportar bugs, por favor utilizar la página de GitHub del proyecto:"),
                                p("https://github.com/albgarre/tools_BIOQURA")
                                )
                    )
                    ),
            tabItem(tabName = "bioqura_house",
                    fluidPage(
                        fluidRow(
                            boxPlus(
                                width = 6, collapsible = FALSE, closable = FALSE,
                                title = "Estimación de vida útil",
                                tagList(
                                    fluidRow(column(12, text_bioqura_house))
                                )
                            )
                        ),
                        fluidRow(
                            boxPlus(
                                title = "Contacto", footer_padding = FALSE,
                                closable = FALSE,
                                HTML("Email Me: <a href='mailto:placeholder.aesan@gmail.com?Subject=Shiny%20Help' target='_top'>Placeholder AESAN</a>")
                            )
                        )
                    )
            ),
            tabItem(tabName = "pH_quantiles",
                    # fluidRow(
                    #     boxPlus(title = "Estimación del pH", width = 12, collapsible = TRUE,
                    #         # withMathJax(includeMarkdown("help_pH_quantiles.md"))
                    #         closable = FALSE,
                    #         "Esta herramienta permite estimar, en base a una serie de mediciones, la proporción de muestras con un pH superior al admisible. El cálculo está basado en la hipótesis de que el pH de las muestras sigue una distribución normal con varianza y media desconocidas."
                    #     )
                    # ),
                    fluidRow(
                        boxPlus(
                            closable = FALSE,
                            # title = "Resumen de las observaciones", 
                            title = tagList("Datos",
                                            actionBttn("show_method_ph",
                                                       label = NULL,
                                                       style = "bordered",
                                                       icon = icon("info"),
                                                       size = "xs"
                                            )
                            ),
                            
                            status = "primary", solidHeader = TRUE,
                            numericInput("mean_ph", "pH medio:", 4.4, min = 0, max = 12, step = 1e-2),
                            numericInput("sd_pH", "Desv. standard del pH:", 0.1, min = 0, step = 1e-2),
                            numericInput("n_obs", "Número de medidas:", 10, min = 2, step = 1),
                            numericInput("ph_max_quantile", "pH máximo admisible", 4.4, min = 0, max = 12, step = 1e-1),
                            actionButton("launch_quantile", "Hacer cálculo")
                        ),
                        boxPlus(title = "Resultados del cálculo", 
                                status = "danger", solidHeader = TRUE,
                                closable = FALSE,
                                h3("Proporcion de muestras con un pH superior al admisible"),
                                textOutput("number_above"),
                                tags$hr(),
                                textOutput("number_above1"),
                                tags$hr(),
                                plotOutput("hist_quantile_ph")
                        )
                    )
                    ),
            tabItem(tabName = "aw_quantiles",
                    # fluidRow(
                    #     boxPlus(title = "Estimación de la actividad del agua", 
                    #             width = 12, collapsible = TRUE,
                    #         # withMathJax(includeMarkdown("help_aw_quantiles.md"))
                    #         closable = FALSE, 
                    #         "Esta herramienta permite estimar, en base a una serie de mediciones, la proporción de muestras con un aw superior al admisible. El cálculo está basado en la hipótesis de que el aw de las muestras sigue una distribución normal con varianza y media desconocidas."
                    #     )
                    # ),
                    fluidRow(
                        boxPlus(title = tagList("Datos",
                                                actionBttn("show_method_aw",
                                                           label = NULL,
                                                           style = "bordered",
                                                           icon = icon("info"),
                                                           size = "xs"
                                                )
                        ),
                                
                                status = "primary", solidHeader = TRUE,
                            numericInput("mean_aw", "aw media:", 0.9, min = 0, max = 1, step = 1e-3),
                            numericInput("sd_aw", "Desv. standard del aw:", 0.1, min = 0, step = 1e-3),
                            numericInput("n_obs_aw", "Número de medidas:", 10, min = 2, step = 1),
                            numericInput("aw_max_quantile", "aw máximo admisible", 0.92, min = 0, max = 1, step = 1e-3),
                            actionButton("launch_quantile_aw", "Hacer cálculo")
                        ),
                        boxPlus(title = "Resultados del cálculo", status = "danger", solidHeader = TRUE,
                            h3("Proporcion de muestras con un aw superior al admisible"),
                            textOutput("number_above_aw"),
                            tags$hr(),
                            textOutput("number_above1_aw")
                        )
                    )
            ),
            tabItem(tabName = "prop_test",
                    # fluidRow(
                    #     boxPlus(title = NULL, width = 12, collapsible = TRUE,
                    #             closable = FALSE,
                    #             
                    #         # withMathJax(includeMarkdown("help_proportions.Rmd"))
                    # 
                    # 
                    #     )
                    # ),
                    fluidRow(
                        boxPlus(
                            title = tagList("Datos",
                                    actionBttn("show_method_prop",
                                               label = NULL,
                                               style = "bordered",
                                               icon = icon("info"),
                                               size = "xs"
                                    )
                            ),
                            status = "primary", solidHeader = TRUE,
                            numericInput("n_positive", "Número de muestras positivas", 1, min = 0, step = 1),
                            numericInput("n_negative", "Número de muestras negativas", 1, min = 0, step = 1),
                            numericInput("conf_prop", "Nivel de confianza", 0.95, min = 0, max = 1)
                            ),
                        boxPlus(title = "Resultado del test", status = "danger", solidHeader = TRUE,
                            plotOutput("posteriors_proportions"),
                            textOutput("proportion_limit")
                            )
                    )
                    )
        )
    )
)
        


















