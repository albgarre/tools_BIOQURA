
## Load libraries

options(shiny.reactlog=TRUE) 

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library("shinyIncubator")
library(markdown)
library(dashboardthemes)

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
            menuItem("BIOQURA", icon = icon("calculator"),
                     menuSubItem("T101: IC proporcion positivos", tabName = "prop_test"),
                     menuSubItem("T102: Muestras con aw > límite", tabName = "aw_quantiles"),
                     menuSubItem("T103: Muestra con pH > límite", tabName = "pH_quantiles")
                     ),
            menuItem("Lagomorfos", icon = icon("drumstick-bite"),
                     menuSubItem("T201: Muestras infinitas", tabName = "infinite_chicken"),
                     menuSubItem("T202: Muestras finitas", tabName = "finite_chicken")
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
            tabItem(tabName = "finite_chicken",
                    finite_sizeUI("finite_sample")
                    ),
            tabItem(tabName = "infinite_chicken",
                    infiniteAppUI("infinite_chicken")
            ),
            tabItem(tabName = "welcome",
                    fluidRow(
                        box(title = NULL, width = 12,
                            withMathJax(includeMarkdown("welcome.md"))
                            )
                    )
                    ),
            tabItem(tabName = "pH_quantiles",
                    fluidRow(
                        box(title = NULL, width = 12, collapsible = TRUE,
                            withMathJax(includeMarkdown("help_pH_quantiles.md"))
                        )
                    ),
                    fluidRow(
                        box(title = "Resumen de las observaciones", status = "primary", solidHeader = TRUE,
                            numericInput("mean_ph", "pH medio:", 4.4, min = 0, max = 12, step = 1e-2),
                            numericInput("sd_pH", "Desv. standard del pH:", 0.1, min = 0, step = 1e-2),
                            numericInput("n_obs", "Número de medidas:", 10, min = 2, step = 1),
                            numericInput("ph_max_quantile", "pH máximo admisible", 4.4, min = 0, max = 12, step = 1e-1),
                            actionButton("launch_quantile", "Hacer cálculo")
                            ),
                        box(title = "Resultados del cálculo", status = "danger", solidHeader = TRUE,
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
                    fluidRow(
                        box(title = NULL, width = 12, collapsible = TRUE,
                            withMathJax(includeMarkdown("help_aw_quantiles.md"))
                        )
                    ),
                    fluidRow(
                        box(title = "Resumen de las observaciones", status = "primary", solidHeader = TRUE,
                            numericInput("mean_aw", "aw media:", 0.9, min = 0, max = 1, step = 1e-3),
                            numericInput("sd_aw", "Desv. standard del aw:", 0.1, min = 0, step = 1e-3),
                            numericInput("n_obs_aw", "Número de medidas:", 10, min = 2, step = 1),
                            numericInput("aw_max_quantile", "aw máximo admisible", 0.92, min = 0, max = 1, step = 1e-3),
                            actionButton("launch_quantile_aw", "Hacer cálculo")
                        ),
                        box(title = "Resultados del cálculo", status = "danger", solidHeader = TRUE,
                            h3("Proporcion de muestras con un aw superior al admisible"),
                            textOutput("number_above_aw"),
                            tags$hr(),
                            textOutput("number_above1_aw")
                        )
                    )
            ),
            tabItem(tabName = "prop_test",
                    fluidRow(
                        box(title = NULL, width = 12, collapsible = TRUE,
                            withMathJax(includeMarkdown("help_proportions.Rmd"))
                            
                        )
                    ),
                    fluidRow(
                        box(title = "Resumen de las observaciones", status = "primary", solidHeader = TRUE,
                            numericInput("n_positive", "Número de muestras positivas", 1, min = 0, step = 1),
                            numericInput("n_negative", "Número de muestras negativas", 1, min = 0, step = 1),
                            numericInput("conf_prop", "Nivel de confianza", 0.95, min = 0, max = 1)
                            ),
                        box(title = "Resultado del test", status = "danger", solidHeader = TRUE,
                            plotOutput("posteriors_proportions"),
                            textOutput("proportion_limit")
                            )
                    )
                    )
        )
    )
)
        


















