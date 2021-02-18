

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
            jumbotron(button = FALSE, 
                      "Herramientas para el diseño del tamaño muestral para muestras finitas", 
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In blandit, elit non lacinia pellentesque, ex felis maximus magna, in faucibus tellus erat eu odio. Fusce at sollicitudin justo, non fermentum risus. Aenean eu ipsum id leo suscipit hendrerit. Integer pellentesque vulputate elit cursus auctor. Integer sed mi magna. Fusce malesuada dictum eleifend. Fusce egestas eu est vitae scelerisque. Donec ullamcorper ac urna sit amet porttitor. Curabitur ultricies tortor vitae ligula ultrices placerat. Aliquam erat volutpat. Integer mauris libero, feugiat sit amet bibendum ac, cursus nec est. Aliquam at dapibus massa. Aliquam cursus est sit amet commodo commodo. Nunc euismod, nulla eget varius mattis, erat nibh pretium quam, sit amet imperdiet neque ex ac nisi. Ut bibendum pharetra arcu vel vulputate. Praesent elementum mi purus, sit amet auctor nisi congue a.

Vestibulum molestie neque quis metus pretium, sit amet consequat augue gravida. Praesent dapibus lobortis quam. Proin malesuada convallis libero. Maecenas sit amet tellus facilisis, cursus massa sit amet, convallis nunc. Etiam mi sem, aliquam at ipsum in, rutrum porttitor eros. Nunc eu arcu quis lacus finibus fringilla. Pellentesque a justo finibus, fermentum ipsum non, condimentum ipsum. Aliquam ultricies odio ut sem congue dignissim. Pellentesque commodo nibh luctus ligula euismod, non tristique eros elementum. Phasellus eget ornare lorem, in mollis sapien. Quisque et accumsan diam, nec efficitur turpis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec ultrices, mi non placerat elementum, nisi ex dictum enim, vel tempor nunc ligula aliquet nisi.

Donec a lectus metus. Donec tincidunt nibh ac est venenatis faucibus. Sed a augue laoreet, ullamcorper sapien sed, mollis diam. Maecenas ut urna at ante pretium dictum nec a ligula. Nullam placerat erat turpis, sed semper nisi dictum vel. Donec auctor tincidunt lorem congue tristique. Phasellus mattis lacus non arcu porttitor blandit. Duis gravida neque elementum maximus tristique. Nullam ut est ornare, ultricies purus sit amet, faucibus sapien."),
        ),
        fluidRow(
            infiniteUI(NS(id, "infinite_chicken")),
            CIinfiniteUI(NS(id, "CI_infinite_chicken"))
        ),
        fluidRow(
            column(6, panel_div(class_type = "success", panel_title = "Referencias",
                                content = tagList(
                                    downloadLink(NS(id, "get_informe"), "Informe del comité científico")
                                ))),
            column(6, panel_div("success", "Contacto",
                                HTML("Email Me: <a href='mailto:placeholder.aesan@gmail.com?Subject=Shiny%20Help' target='_top'>Placeholder AESAN</a>")))
        ),
    )
}

infiniteAppServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
        
        infiniteServer("infinite_chicken")
        CIinfiniteServer("CI_infinite_chicken")

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



