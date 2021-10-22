
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyFeedback)

infiniteUI <- function(id, width = 6) {
    
    widgetUserBox(
        title = tagList("Tamaño muestral mínimo para una población infinita",
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
                   numericInput(NS(id, "p"), "Proporción esperada de decomisos", 
                                0.1, min = 0, max = 1, step = 0.01),
                   numericInput(NS(id, "alpha"), "Límite de significación (alpha)", 
                                0.05, min = 0, max = 1, step = 0.01),
                   numericInput(NS(id, "MOE"), "Margen de error", 
                                0.02, min = 0, max = 1, step = 0.01)
               )
        ),
        column(8,
               uiOutput(NS(id, "each_size"))
        ),
        # footer = tagList("Condición I: coeficiente de simetría < 1/3.",
        #                  "Condición II: precisión del MOE"),
        footer_padding = FALSE
    )
}

infiniteServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
        
        observeEvent(input$show_method,
                     showModal(
                         modalDialog(
                             withMathJax(includeMarkdown("./R/help/method_infinite_size.md")),
                             easyClose = TRUE,
                             size = "l",
                             footer = modalButton("Cerrar")
                         )
                     )
                     
        )
        
        size_1 <- reactive({
            p <- input$p
            q <- 1-p
            ceiling(9*( sqrt(q/p) - sqrt(p/q) )^2)
        })
        
        size_2 <- reactive({
            p <- input$p
            alpha <- input$alpha
            MOE <- input$MOE
            z <- qnorm(1 - alpha/2)
            
            feedbackDanger("p", !between(p, 0, 1), "p debe estar entre 0 y 1")
            feedbackDanger("alpha", !between(alpha, 0, 1), "alpha debe estar entre 0 y 1")
            feedbackDanger("MOE", !between(MOE, 0, 1), "MOE debe estar entre 0 y 1")
            
            ceiling( (z/MOE)^2 * p * (1-p) )
        })
        
        output$each_size <- renderUI({
            
            tagList(
                fluidRow(
                    valueBox(value = size_1(),
                             # subtitle = "",
                             subtitle = "Condición I",
                             width = 6, color = "olive"),
                    valueBox(value = size_2(),
                             # subtitle = "",
                             subtitle = "Condición II",
                             width = 6, color = "olive")
                ),
                fluidRow(
                    valueBox(value = max(c(size_1(), size_2())),
                             subtitle = "Tamaño muestral mínimo", 
                             width = 12, color = "yellow", icon = icon("vial")),
                ),
                fluidRow(
                    column(12,
                           alert(status = "info",
                                 "Si el tamaño muestral es mayor que ",
                                 round(max(c(size_1(), size_2())), 0),
                                 "se puede utilizar la herramienta T201.",
                                 "En caso contrario, usar la herramienta T202."
                           )
                           )
                    
                )
            )
        })

        output$out_size <- renderText({
            
            n <- max(c(size_1(), size_2()))
            paste("Minimum sample size:", n)
            
        })

    })
    
}

#####################################

infiniteApp <- function() {
    
    ui <- dashboardPagePlus(
        header = dashboardHeaderPlus(
            enable_rightsidebar = TRUE,
            rightSidebarIcon = "gears"
        ),
        sidebar = dashboardSidebar(),
        body = dashboardBody(
            useShinyFeedback(),
            fluidRow(
                infiniteUI("infinite")
            )
            
        ),
        rightsidebar = rightSidebar(),
        title = "DashboardPage"
    )

        server <- function(input, output, session) {
        infiniteServer("infinite")
    }
    shinyApp(ui, server)  
}

# infiniteApp()






