
datasetInput <- function(id, filter = NULL) {
    names <- ls("package:datasets")
    if (!is.null(filter)) {
        data <- lapply(names, get, "package:datasets")
        names <- names[vapply(data, filter, logical(1))]
    }
    
    selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
}

datasetServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        reactive(get(input$dataset, "package:datasets"))
    })
}

datasetApp <- function(filter = NULL) {
    ui <- fluidPage(
        datasetInput("dataset", filter = filter),
        tableOutput("data")
    )
    server <- function(input, output, session) {
        data <- datasetServer("dataset")
        output$data <- renderTable(head(data()))
    }
    shinyApp(ui, server)
}
datasetApp(is.data.frame)



radioExtraUI <- function(id, label, choices, selected = NULL, placeholder = "Other") {
    other <- textInput(NS(id, "other"), label = NULL, placeholder = placeholder)
    
    names <- if (is.null(names(choices))) choices else names(choices)
    values <- unname(choices)
    
    radioButtons(NS(id, "primary"), 
                 label = label,
                 choiceValues = c(names, "other"),
                 choiceNames = c(as.list(values), list(other)),
                 selected = selected
    )
}

radioExtraServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        observeEvent(input$other, ignoreInit = TRUE, {
            updateRadioButtons(session, "primary", selected = "other")
        })
        
        reactive({
            if (input$primary == "other") {
                input$other
            } else {
                input$primary
            }
        })
    })
}

radioExtraApp <- function(...) {
    ui <- fluidPage(
        radioExtraUI("extra", NULL, ...),
        textOutput("value")
    )
    server <- function(input, output, server) {
        extra <- radioExtraServer("extra")
        output$value <- renderText(paste0("Selected: ", extra()))
    }
    
    shinyApp(ui, server)
}
radioExtraApp(c("a", "b", "c"))





nextPage <- function(id, i) {
    actionButton(NS(id, paste0("go_", i, "_", i + 1)), "next")
}
prevPage <- function(id, i) {
    actionButton(NS(id, paste0("go_", i, "_", i - 1)), "prev")
}

wrapPage <- function(title, page, button_left = NULL, button_right = NULL) {
    tabPanel(
        title = title, 
        fluidRow(
            column(12, page)
        ), 
        fluidRow(
            column(6, button_left),
            column(6, button_right)
        )
    )
}

wizardUI <- function(id, pages, doneButton = NULL) {
    stopifnot(is.list(pages))
    n <- length(pages)
    
    wrapped <- vector("list", n)
    for (i in seq_along(pages)) {
        # First page only has next; last page only prev + done
        lhs <- if (i > 1) prevPage(id, i)
        rhs <- if (i < n) nextPage(id, i) else doneButton
        wrapped[[i]] <- wrapPage(paste0("page_", i), pages[[i]], lhs, rhs)
    }
    
    # Create tabsetPanel
    # https://github.com/rstudio/shiny/issues/2927
    wrapped$id <- NS(id, "wizard")
    wrapped$type <- "hidden"
    do.call("tabsetPanel", wrapped)
}

wizardServer <- function(id, n) {
    moduleServer(id, function(input, output, session) {
        changePage <- function(from, to) {
            observeEvent(input[[paste0("go_", from, "_", to)]], {
                updateTabsetPanel(session, "wizard", selected = paste0("page_", to))
            })  
        }
        ids <- seq_len(n)
        lapply(ids[-1], function(i) changePage(i, i - 1))
        lapply(ids[-n], function(i) changePage(i, i + 1))
    })
}

wizardApp <- function(...) {
    pages <- list(...)
    
    ui <- fluidPage(
        wizardUI("whiz", pages)
    )
    server <- function(input, output, session) {
        wizardServer("whiz", length(pages))
    }
    shinyApp(ui, server)
}

wizardApp("p1", "p2", "p3")

filterUI <- function(id) {
    uiOutput(NS(id, "controls"))
}

library(purrr)

make_ui <- function(x, id, var) {
    if (is.numeric(x)) {
        rng <- range(x, na.rm = TRUE)
        sliderInput(id, var, min = rng[1], max = rng[2], value = rng)
    } else if (is.factor(x)) {
        levs <- levels(x)
        selectInput(id, var, choices = levs, selected = levs, multiple = TRUE)
    } else {
        # Not supported
        NULL
    }
}
filter_var <- function(x, val) {
    if (is.numeric(x)) {
        !is.na(x) & x >= val[1] & x <= val[2]
    } else if (is.factor(x)) {
        x %in% val
    } else {
        # No control, so don't filter
        TRUE
    }
}

filterServer <- function(id, df) {
    stopifnot(is.reactive(df))
    
    moduleServer(id, function(input, output, session) {
        vars <- reactive(names(df()))
        
        output$controls <- renderUI({
            map(vars(), function(var) make_ui(df()[[var]], NS(id, var), var))
        })
        
        reactive({
            each_var <- map(vars(), function(var) filter_var(df()[[var]], input[[var]]))
            reduce(each_var, `&`)
        })
    })
}

filterApp <- function() {
    ui <- fluidPage(
        sidebarLayout(
            sidebarPanel(
                datasetInput("data", is.data.frame),
                textOutput("n"),
                filterUI("filter"),
            ),
            mainPanel(
                tableOutput("table")    
            )
        )
    )
    server <- function(input, output, session) {
        df <- datasetServer("data")
        filter <- filterServer("filter", df)
        
        output$table <- renderTable(df()[filter(), , drop = FALSE])
        output$n <- renderText(paste0(sum(filter()), " rows"))
    }
    shinyApp(ui, server)
}

filterApp()









