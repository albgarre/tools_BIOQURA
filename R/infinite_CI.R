
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

CIinfiniteUI <- function(id, width = 6) {
    
    widgetUserBox(
        title = "Intervalo de confianza para una muestra infinita",
        type = 2,
        width = width,
        color = "primary",
        column(4,
               boxPad(
                   # color = "primary",
                   numericInput(NS(id, "n"), "Tamaño muestral", 
                                1000, min = 0, step = 1),
                   numericInput(NS(id, "n_p"), "Número de decomisos", 
                                10, min = 0, step = 1),
                   numericInput(NS(id, "alpha"), "Límite de significación (alpha)", 
                                0.05, min = 0, max = 1, step = 0.01)
               )
        ),
        column(8,
               boxPad(textOutput(NS(id, "CI_left")), color = "warning"),
               br(),
               boxPad(textOutput(NS(id, "CI_right")), color = "warning")
               # boxPad(textOutput(NS(id, "cond_2")), color = "primary"
        ),
        footer = tagList("IC calculado de acuerdo al método de Wald.")
    )
}

CIinfiniteServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
        
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
        
        output$CI_left <- renderText({
            x <- CI()[1]
            paste("Limite izquierdo del IC para p:",
                  prettyNum(x, digits = 2),
                  "(1 positivo cada",
                  round(1/x),
                  " muestras)")
        })
        
        output$CI_right <- renderText({
            x <- CI()[2]
            paste("Limite derecho del IC para p:",
                  prettyNum(x, digits = 2),
                  "(1 positivo cada",
                  round(1/x),
                  " muestras)")
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



