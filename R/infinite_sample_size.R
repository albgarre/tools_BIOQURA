
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyFeedback)

infiniteUI <- function(id, width = 6) {
    
    widgetUserBox(
        title = "Diseño del tamaño muestral para una muestra infinita",
        type = 2,
        width = width,
        color = "primary",
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
               uiOutput(NS(id, "each_size")),
               br(),
               boxPad(textOutput(NS(id, "out_size")), color = "warning")
        ),
        footer = tagList("Condición I: coeficiente de simetría < 1/3.",
                         "Condición II: precisión del MOE")
    )
}

infiniteServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
        
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
                boxProfileItem(title = "According to condition I:", 
                               description = size_1()),
                boxProfileItem(title = "According to condition II:", 
                               description = size_2())
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






