
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyFeedback)
library(shinyLP)
library(shinyWidgets)

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
        
        # print(paste("c:", c))
        # print(paste("lower:", lower))
        # print(paste("upper:", upper))
        # print("++++")
        
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
            jumbotron(button = FALSE, 
                      "Herramientas para el diseño del tamaño muestral para muestras finitas", 
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In blandit, elit non lacinia pellentesque, ex felis maximus magna, in faucibus tellus erat eu odio. Fusce at sollicitudin justo, non fermentum risus. Aenean eu ipsum id leo suscipit hendrerit. Integer pellentesque vulputate elit cursus auctor. Integer sed mi magna. Fusce malesuada dictum eleifend. Fusce egestas eu est vitae scelerisque. Donec ullamcorper ac urna sit amet porttitor. Curabitur ultricies tortor vitae ligula ultrices placerat. Aliquam erat volutpat. Integer mauris libero, feugiat sit amet bibendum ac, cursus nec est. Aliquam at dapibus massa. Aliquam cursus est sit amet commodo commodo. Nunc euismod, nulla eget varius mattis, erat nibh pretium quam, sit amet imperdiet neque ex ac nisi. Ut bibendum pharetra arcu vel vulputate. Praesent elementum mi purus, sit amet auctor nisi congue a.

Vestibulum molestie neque quis metus pretium, sit amet consequat augue gravida. Praesent dapibus lobortis quam. Proin malesuada convallis libero. Maecenas sit amet tellus facilisis, cursus massa sit amet, convallis nunc. Etiam mi sem, aliquam at ipsum in, rutrum porttitor eros. Nunc eu arcu quis lacus finibus fringilla. Pellentesque a justo finibus, fermentum ipsum non, condimentum ipsum. Aliquam ultricies odio ut sem congue dignissim. Pellentesque commodo nibh luctus ligula euismod, non tristique eros elementum. Phasellus eget ornare lorem, in mollis sapien. Quisque et accumsan diam, nec efficitur turpis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec ultrices, mi non placerat elementum, nisi ex dictum enim, vel tempor nunc ligula aliquet nisi.

Donec a lectus metus. Donec tincidunt nibh ac est venenatis faucibus. Sed a augue laoreet, ullamcorper sapien sed, mollis diam. Maecenas ut urna at ante pretium dictum nec a ligula. Nullam placerat erat turpis, sed semper nisi dictum vel. Donec auctor tincidunt lorem congue tristique. Phasellus mattis lacus non arcu porttitor blandit. Duis gravida neque elementum maximus tristique. Nullam ut est ornare, ultricies purus sit amet, faucibus sapien."),
        ),
        fluidRow(
            widgetUserBox(
                title = "Diseño del muestreo para poblaciones finitas",
                type = 2,
                width = width,
                color = "primary",
                fluidRow(
                    column(4,
                           boxPad(
                               # color = "primary",
                               numericInput(NS(id, "N"), "Tamaño de la población", 
                                            1000, min = 0, step = 1),
                               numericInput(NS(id, "alpha"), "Límite de significación (alpha)", 
                                            .05, min = 0, max = 1, step = 0.01),
                               numericInput(NS(id, "k0"), "k0", 
                                            10, min = 0, step = 1),
                               numericInput(NS(id, "beta"), "Potencia estadística (beta)", 
                                            .01, min = 0, max = 1, step = 0.01),
                               numericInput(NS(id, "k1"), "k1", 
                                            50, min = 0, step = 1),
                               br(),
                               actionBttn(NS(id, "go_btn"), "Calcular",
                                          style = "material-flat")
                           )
                    ),
                    column(8, 
                           uiOutput(NS(id, "output"))
                    )
                )
            )
        ),
        fluidRow(
            column(6, panel_div(class_type = "success", panel_title = "Referencias",
                                content = tagList(
                                    downloadLink(NS(id, "get_informe"), "Informe del comité científico")
                                ))),
            column(6, panel_div("success", "Contacto",
                                HTML("Email Me: <a href='mailto:placeholder.aesan@gmail.com?Subject=Shiny%20Help' target='_top'>Placeholder AESAN</a>")))
        )
        
    )
    
    
}

finite_sizeServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
        
        results <- eventReactive(input$go_btn, {

            find_the_c(N = input$N, 
                       alpha = input$alpha, 
                       beta = input$beta,
                       k0 = input$k0, k1 = input$k1,
                       niter = 200, 
                       start_n = 0.1*input$N,
                       max_c = input$N)
            
        })
        
        output$output <- renderUI({
            
            print(results())
            tagList(
                boxProfileItem(title = "Límite inferior del tamaño muestral:", 
                               description = results()$lower),
                boxProfileItem(title = "Límite superior del tamaño muestral:", 
                               description = results()$upper),
                boxProfileItem(title = "Número máximo de positivos:", 
                               description = results()$c),
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





