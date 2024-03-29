

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyFeedback)
library(shinyLP)
library(shinyWidgets)

source("./R/infinite_CI.R")
source("./R/infinite_sample_size.R")

#######################################################################

infiniteAppUI <- function(id, width = 6) {
    
    
    
    fluidPage(
#         fluidRow(
#             boxPlus(footer_padding = FALSE, width = 12,
#                     h2("Herramientas para el diseño del muestreo para poblaciones infinitas"),
#                     tags$p("El Reglamento de Ejecución (UE) 2019/627 establece de forma general que todas las aves sacrifi-
# cadas deben de ser sometidas a inspección post mortem por parte de la autoridad, lo cual es de
# aplicación por extensión al caso de los lagomorfos. Sin embargo, también se recoge la posibilidad
# de que las autoridades competentes decidan someter a la inspección una muestra representativa de
# aves o lagomorfos, siempre que se cumplan una serie de requisitos adicionales. De este modo se ha
# realizado un estudio conducente a proporcionar un método para establecer lo que sería una muestra
# representativa para someter a inspección post mortem por muestreo a estos tipos de animales."),
#                     tags$p("El Comité Científico de la Agencia Española de Seguridad
#                                  Alimentaria y Nutrición (AESAN) realizó un informe proponiendo 
#                                  una metodología para el diseño del tamaño de muestra (AESAN-2020-006),
#                                  así como para determinar si los resultados del muestreo indican que el 
#                                  sistema está fuera de control."),
#                     tags$p("En este informe se propusieron dos métodos: una para el que
#                     la población puede considerarse infinita, y un segundo para casos
#                     en que no. Esta aplicación incluye la metodología estadística
#                     desarrollada para el primer caso: cuando la muestra no puede considerarse infinita.
#                     Esta metodología sólo es válido para algunos tamaños poblacionales y muestrales.
#                     Por eso, incluye una herramienta para calcular el tamaño muestral mínimo para una población dada."
#                            ),
#                     actionButton(NS(id, "example"), "Ejemplo")
#             )
#         ),
        # fluidRow(
        #     # infiniteUI(NS(id, "infinite_chicken")),
        #     CIinfiniteUI(NS(id, "CI_infinite_chicken"))
        # ),
        fluidRow(
            widgetUserBox(
                title = tagList("Intervalo de confianza para una muestra infinita",
                                actionBttn(NS(id, "show_method"),
                                           label = NULL,
                                           style = "bordered",
                                           icon = icon("info"),
                                           size = "xs"
                                )
                ),
                type = 2,
                width = width,
                color = "olive",
                column(4,
                       boxPad(
                           # color = "primary",
                           numericInput(NS(id, "n"), "Tamaño muestral", 
                                        1000, min = 0, step = 1),
                           numericInput(NS(id, "p_max"), "Proporción máxima de decomisos (%)",
                                        3, min = 0, max = 100, step = 1),
                           # numericInput(NS(id, "n_p"), "Número de decomisos",
                           #              10, min = 0, step = 1),
                           numericInput(NS(id, "alpha"), "Nivel de significación (alpha)", 
                                        0.05, min = 0, max = 1, step = 0.01)
                       )
                ),
                column(8,
                       # uiOutput(NS(id, "CI_results"))
                       uiOutput(NS(id, "c_results"))
                ),
                footer_padding = FALSE
            )
        )
        # fluidRow(
        #     boxPlus(
        #         title = "Referencias", footer_padding = FALSE,
        #         closable = FALSE,
        #         downloadLink(NS(id, "get_informe"), 
        #                      "Informe del comité científico de AESAN (AESAN-2020-006)")
        #     ),
        #     boxPlus(
        #         title = "Contacto", footer_padding = FALSE,
        #         closable = FALSE,
        #         HTML("Email Me: <a href='mailto:placeholder.aesan@gmail.com?Subject=Shiny%20Help' target='_top'>Placeholder AESAN</a>")
        #     )
        # )
    )
}

#------------------------------------------------------------------------------

infiniteAppServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
        
        observeEvent(input$example,
                     showModal(
                         modalDialog(
                             easyClose = TRUE,
                             size = "l",
                             footer = modalButton("Cerrar"),
                             title = "Ejemplo muestras finitas",
                             # HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/aQlTAznANDQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                             HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/FUZX2Q0EOsE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                         )
                     )
                     
        )
        
        # infiniteServer("infinite_chicken")
        # CIinfiniteServer("CI_infinite_chicken")
        
        observeEvent(input$show_method,
                     showModal(
                         modalDialog(
                             withMathJax(includeMarkdown("./R/help/method_infinite_CI.md")),
                             easyClose = TRUE,
                             size = "l",
                             footer = modalButton("Cerrar")
                         )
                     )
                     
        )
        
        out_c <- reactive({
            
            p_max <- input$p_max/100
            z <- qnorm(1 - input$alpha/2)
            n <- input$n
            
            p <- 1:n/n
            q <- 1-p
            
            left_ci <- p - z*sqrt(p*q/n)
            
            p_hat <- p[left_ci > p_max][1]
            c <- floor(p_hat*n) - 1

            c
            
        })
        
        output$c_results <- renderUI({
            
            tagList(
                fluidRow(
                    column(12,
                           fluidRow(
                               valueBox(value = prettyNum(out_c(), digits = 2),
                                        subtitle = paste("Máximo número de positivos (c)"),
                                        width = 12,
                                        color = "yellow")
                           )
                           )
                )
            )
            
        })
        
        # CI <- reactive({
        #     
        #     p <- input$n_p/input$n
        #     q <- 1-p
        #     z <- qnorm(1 - input$alpha/2)
        #     n <- input$n
        #     
        #     feedbackDanger("n", n<=0, "N debe ser mayor que 0")
        #     feedbackDanger("n_p", p>1, "El número de decomisos debe ser menor que N")
        #     feedbackDanger("alpha", !between(input$alpha, 0, 1), "alpha debe estar entre 0 y 1")
        #     
        #     ci <- p + c(-1,1)*z*sqrt(p*q/n)
        # })
        
        # output$CI_results <- renderUI({
        #     
        #     left <- CI()[1]
        #     right <- CI()[2]
        #     
        #     tagList(
        #         fluidRow(
        #             column(6,
        #                    fluidRow(
        #                        h3("Límite izquierdo")
        #                    ),
        #                    fluidRow(
        #                        valueBox(value = prettyNum(left, digits = 2),
        #                                 subtitle = paste("(1 positivo cada",
        #                                                  round(1/left),
        #                                                  " muestras)"),
        #                                 width = 12,
        #                                 color = "yellow")
        #                    )
        #             ),
        #             column(6,
        #                    fluidRow(
        #                        h3("Límite derecho")
        #                    ),
        #                    fluidRow(
        #                        valueBox(value = prettyNum(right, digits = 2),
        #                                 subtitle = paste("(1 positivo cada",
        #                                                  round(1/right),
        #                                                  " muestras)"),
        #                                 width = 12,
        #                                 color = "yellow")
        #                    )
        #             )
        #         )
        #     )
        # })
        
        output$get_informe <- downloadHandler(
            filename = "AESAN REVISTA comite_cientifico_32.pdf",
            content = function(file) {
                file.copy("AESAN REVISTA comite_cientifico_32.pdf", file)
            }
        )
    })
    
}

############################################3

infiniteSizeApp <- function() {
    
    ui <- dashboardPagePlus(
        md = TRUE,
        header = dashboardHeaderPlus(
            enable_rightsidebar = TRUE,
            rightSidebarIcon = "gears"
        ),
        sidebar = dashboardSidebar(),
        body = dashboardBody(
            useShinyFeedback(),
            fluidRow(
                infiniteAppUI("test")
            )
            
        ),
        rightsidebar = rightSidebar(),
        title = "DashboardPage"
    )
    
    server <- function(input, output, session) {
        infiniteAppServer("test")
    }
    shinyApp(ui, server)  
}



