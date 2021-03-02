

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
        fluidRow(
            boxPlus(footer_padding = FALSE, width = 12,
                    h2("Herramientas para el diseño del muestreo para poblaciones infinitas"),
                    tags$p("El Reglamento de Ejecución (UE) 2019/627 establece de forma general que todas las aves sacrifi-
cadas deben de ser sometidas a inspección post mortem por parte de la autoridad, lo cual es de
aplicación por extensión al caso de los lagomorfos. Sin embargo, también se recoge la posibilidad
de que las autoridades competentes decidan someter a la inspección una muestra representativa de
aves o lagomorfos, siempre que se cumplan una serie de requisitos adicionales. De este modo se ha
realizado un estudio conducente a proporcionar un método para establecer lo que sería una muestra
representativa para someter a inspección post mortem por muestreo a estos tipos de animales."),
                    tags$p("El Comité Científico de la Agencia Española de Seguridad
                                 Alimentaria y Nutrición (AESAN) realizó un informe proponiendo 
                                 una metodología para el diseño del tamaño de muestra (AESAN-2020-006),
                                 así como para determinar si los resultados del muestreo indican que el 
                                 sistema está fuera de control."),
                    tags$p("En este informe se propusieron dos métodos: una para el que
                    la población puede considerarse infinita, y un segundo para casos
                    en que no. Esta aplicación incluye la metodología estadística
                    desarrollada para el primer caso: cuando la muestra no puede considerarse infinita.
                    Esta metodología sólo es válido para algunos tamaños poblacionales y muestrales.
                    Por eso, incluye una herramienta para calcular el tamaño muestral mínimo para una población dada.")
            )
        ),
        fluidRow(
            infiniteUI(NS(id, "infinite_chicken")),
            CIinfiniteUI(NS(id, "CI_infinite_chicken"))
        ),
        fluidRow(
            boxPlus(
                title = "Referencias", footer_padding = FALSE,
                closable = FALSE,
                downloadLink(NS(id, "get_informe"), 
                             "Informe del comité científico de AESAN (AESAN-2020-006)")
            ),
            boxPlus(
                title = "Contacto", footer_padding = FALSE,
                closable = FALSE,
                HTML("Email Me: <a href='mailto:placeholder.aesan@gmail.com?Subject=Shiny%20Help' target='_top'>Placeholder AESAN</a>")
            )
        )
    )
}

infiniteAppServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
        
        infiniteServer("infinite_chicken")
        CIinfiniteServer("CI_infinite_chicken")
        
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



