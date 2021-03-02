
library(tidyverse)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

CIinfiniteUI <- function(id, width = 6) {
    
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
                   numericInput(NS(id, "n_p"), "Número de decomisos", 
                                10, min = 0, step = 1),
                   numericInput(NS(id, "alpha"), "Nivel de significación (alpha)", 
                                0.05, min = 0, max = 1, step = 0.01)
               )
        ),
        column(8,
               uiOutput(NS(id, "CI_results"))
        ),
        footer_padding = FALSE
    )
}

CIinfiniteServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
        
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
        
        CI <- reactive({
            
            p <- input$n_p/input$n
            q <- 1-p
            z <- qnorm(1 - input$alpha/2)
            n <- input$n
            
            feedbackDanger("n", n<=0, "N debe ser mayor que 0")
            feedbackDanger("n_p", p>1, "El número de decomisos debe ser menor que N")
            feedbackDanger("alpha", !between(input$alpha, 0, 1), "alpha debe estar entre 0 y 1")
            
            ci <- p + c(-1,1)*z*sqrt(p*q/n)
        })
        
        output$CI_results <- renderUI({
            
            left <- CI()[1]
            right <- CI()[2]
            
            tagList(
                fluidRow(
                    column(6,
                           fluidRow(
                               h3("Límite izquierdo")
                               ),
                           fluidRow(
                               valueBox(value = prettyNum(left, digits = 2),
                                        subtitle = paste("(1 positivo cada",
                                                         round(1/left),
                                                         " muestras)"),
                                        width = 12,
                                        color = "yellow")
                           )
                           ),
                    column(6,
                           fluidRow(
                               h3("Límite derecho")
                           ),
                           fluidRow(
                               valueBox(value = prettyNum(right, digits = 2),
                                        subtitle = paste("(1 positivo cada",
                                                         round(1/right),
                                                         " muestras)"),
                                        width = 12,
                                        color = "yellow")
                           )
                           )
                )
            )
        })
    })
    
}

############################################3

CIinfiniteApp <- function() {
    
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
                CIinfiniteUI("CI_infinite")
            )
            
        ),
        rightsidebar = rightSidebar(),
        title = "DashboardPage"
    )
    
    server <- function(input, output, session) {
        CIinfiniteServer("CI_infinite")
    }
    shinyApp(ui, server)  
}

# CIinfiniteApp()



