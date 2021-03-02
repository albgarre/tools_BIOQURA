
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyFeedback)
library(shinyLP)
library(shinyWidgets)
# library(shinyalert)

#######################################################################

get_intermediate_stuff <- function(n, c, N, k0, k1) {
    
    M <- N - (n-1)/2
    p0 <- (k0 - c/2)/M
    p1 <- (k1 - c/2)/M
    
    list(M = M, p0 = p0, p1 = p1)
    
}

get_lhs <- function(n, c, N, beta, k0, k1) {
    
    inter <- get_intermediate_stuff(n, c, N, k0, k1)
    
    df <- 2*c+2
    
    ( qchisq(1-beta, df)*(1/inter$p1-.5) + c )/2
    
}

get_rhs <- function(n, c, N, alpha, k0, k1) {
    
    inter <- get_intermediate_stuff(n, c, N, k0, k1)
    
    df <- 2*c+2
    
    ( qchisq(alpha, df)*(1/inter$p0-.5)+ c )/2
    
}

new_iterate_lhs <- function(niter, n_start, c, N, beta, k0, k1) {
    
    my_ns <- numeric(length = niter)
    my_ns[1] <- n_start
    
    for (i in 1:niter) {
        new_n <- get_lhs(my_ns[i], c, N, beta, k0, k1)
        my_ns[i+1] <- new_n
    }
    
    my_ns <- ceiling(my_ns)
    
    if (my_ns[niter] != my_ns[niter-1]) {
        stop("Algorithm did not converge (", my_ns[niter], my_ns[niter-1],
             "). Try a different value for n_start or increase the number of iterations")
    }
    
    my_ns[niter]
    
}

new_iterate_rhs <- function(niter, n_start, c, N, alpha, k0, k1) {
    
    my_ns <- numeric(length = niter)
    my_ns[1] <- n_start
    
    for (i in 1:niter) {
        new_n <- get_rhs(my_ns[i], c, N, alpha, k0, k1)
        my_ns[i+1] <- new_n
    }
    
    my_ns <- floor(my_ns)
    
    
    if (my_ns[niter] != my_ns[niter-1]) {
        stop("Algorithm did not converge (", my_ns[niter], my_ns[niter-1],
             "). Try a different value for n_start or increase the number of iterations")
    }
    
    my_ns[niter]
    
}


find_the_c <- function(N, alpha, beta, k0, k1,
                       niter, start_n, max_c) {
    
    for (c in 1:max_c) {
        
        lower <- new_iterate_lhs(niter, start_n, c, 
                             N, beta, k0, k1)
        
        upper <- new_iterate_rhs(niter, start_n, c, 
                             N, alpha, k0, k1)

        if (lower < upper) {
            out <- list(c = c, lower = lower, upper = upper)
            return(out)
        }
        
    }
    
    stop("max_c reached without convergence")

    
}

######################################################################

finite_sizeUI <- function(id, width = 6) {
    fluidPage(
        fluidRow(
            boxPlus(footer_padding = FALSE, width = 12,
                    h2("Herramientas para el diseño del tamaño muestral para poblaciones finitas"),
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
                                 en que no. El primer método es más sencillo, aunque sólo es aplicable para
                                 casos en que el tamaño muestral es mucho menor que el tamaño de la población.
                                 La aplicación T201 incluye una herramienta para validar si el tamaño de la población
                                 es lo suficientemente grande para poder considerarla infinita."),
                    tags$p("Esta aplicación incluye la metodología estadística
                                 desarrollada para el segundo caso: cuando la muestra no puede considerarse infinita.
                                 Esta metodología es más general, aunque el método estadístico es más complejo.")
            )
        ),
        fluidRow(
            widgetUserBox(
                footer_padding = FALSE,
                title = tagList("Diseño del muestreo para poblaciones finitas",
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
                # actionBttn(NS(id, "show_method"),
                #            label = NULL,
                #            style = "material-flat",
                #            icon = icon("info")
                # ),
                fluidRow(
                    column(4,
                           boxPad(
                           # wellPanel(
                               # color = "olive",
                               numericInput(NS(id, "N"), "Tamaño de la población", 
                                            1000, min = 0, step = 1),
                               numericInput(NS(id, "p_k1"), "Proporción máxima de positivos", 
                                            0.03, min = 0, max = 1, step = 0.001),
                               numericInput(NS(id, "beta"), "Significación estadística del límite superior (beta)", 
                                            .01, min = 0, max = 1, step = 0.001),
                               numericInput(NS(id, "p_k0"), "Proporción mínima de positivos", 
                                            0.01, min = 0, max = 1, step = 0.001),
                               numericInput(NS(id, "alpha"), "Significación estadística del límite inferior (alpha)", 
                                            .05, min = 0, max = 1, step = 0.001),
                               br(),
                               actionBttn(NS(id, "go_btn"), "Calcular",
                                          style = "bordered")
                           )
                    ),
                    column(8, 
                           uiOutput(NS(id, "output"))
                    )
                )
            )
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

finite_sizeServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
        
        observeEvent(input$show_method,
                     showModal(
                         modalDialog(
                             withMathJax(includeMarkdown("./R/help/method_finite.md")),
                             easyClose = TRUE,
                             size = "l",
                             footer = modalButton("Cerrar")
                         )
                     )
                     
                     )
        
        results <- eventReactive(input$go_btn, {
            
            feedbackDanger("p_k1", !between(input$p_k1, 0, 1), "Debe estar entre 0 y 1")
            feedbackDanger("p_k2", !between(input$p_k2, 0, 1), "Debe estar entre 0 y 1")
            feedbackDanger("N", !is.integer(input$N), "Debe ser un número entero")
            feedbackDanger("alpha", !between(input$alpha, 0, 1), "Debe estar entre 0 y 1")
            feedbackDanger("beta", !between(input$beta, 0, 1), "Debe estar entre 0 y 1")

            find_the_c(N = input$N, 
                       alpha = input$alpha, 
                       beta = input$beta,
                       k0 = floor(input$p_k0*input$N), 
                       k1 = floor(input$p_k1*input$N),
                       niter = 200, 
                       start_n = 0.1*input$N,
                       max_c = input$N)
            
        })
        
        output$output <- renderUI({
            
            tagList(
                fluidRow(
                    valueBox(value = results()$lower,
                             # subtitle = "",
                             subtitle = "Límite izquierdo del tamaño muestral",
                             width = 6, color = "yellow", icon = icon("chevron-right")),
                    valueBox(value = results()$upper,
                             # subtitle = "",
                             subtitle = "Límite derecho del tamaño muestral",
                             width = 6, color = "yellow", icon = icon("chevron-left"))
                ),
                fluidRow(
                    valueBox(value = results()$c,
                             subtitle = "Máximo número de positivos", 
                             width = 6, color = "yellow", icon = icon("vial")),
                )
            )
        })
        
        output$get_informe <- downloadHandler(
            filename = "AESAN REVISTA comite_cientifico_32.pdf",
            content = function(file) {
                file.copy("AESAN REVISTA comite_cientifico_32.pdf", file)
            }
        )
        
    })
    }

#########################################

finite_sizeApp <- function() {
    
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
                finite_sizeUI("test")
            )
            
        ),
        rightsidebar = rightSidebar(),
        title = "DashboardPage"
    )
    
    server <- function(input, output, session) {
        finite_sizeServer("test")
    }
    shinyApp(ui, server)  
}

# finite_sizeApp()





