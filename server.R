
## Load libraries

library(shiny)
library("shinyIncubator")
library(tidyverse)
library(broom)

source("stat_functions.R")

shinyServer(function(input, output) {
    
    ## Test of proportion of samples with a pH higher than a threshold
    
    pH_quantile_data <- eventReactive(input$launch_quantile, {
        set.seed(1214)
        simulate_ph(input$n_obs, input$mean_ph, input$sd_pH)
    })
    
    output$number_above <- renderText({
        prop <- pH_quantile_data() %>%
            gather(simul, x) %>%
            mutate(above = x > input$ph_max_quantile) %>%
            group_by(simul) %>%
            summarize(p = mean(above)) %>%
            ungroup() %>%
            .$p %>% 
            mean() 

        paste("Se estima un porcentaje del ", 100*round(prop, 3), "%")
    })
    
    output$number_above1 <- renderText({
        proportion <- pH_quantile_data() %>%
            gather(simul, x) %>%
            mutate(above = x > input$ph_max_quantile) %>%
            group_by(simul) %>%
            summarize(p = mean(above)) %>%
            ungroup() %>%
            .$p %>%
            mean()
        paste("Eso es, ", round(1000*proportion, 1), "unidades de cada 1000.")
    })
    
    output$hist_quantile_ph <- renderPlot({
        
        pH_quantile_data() %>%
            gather(simul, x) %>%
            mutate(above = x > input$ph_max_quantile) %>%
            group_by(simul) %>%
            summarize(p = mean(above)) %>%
            ggplot() + 
                geom_density(aes(p), fill = "grey") + 
                xlab("Proporción de muestras no válidas") + 
                ylab("Densidad de probabilidad")
        
    })
    
    ## Test of proportion of samples with a aw higher than a threshold
    
    aw_quantile_data <- eventReactive(input$launch_quantile_aw, {
        
        set.seed(1214)
        simulate_ph(input$n_obs_aw, input$mean_aw, input$sd_aw)
    })
    
    output$number_above_aw <- renderText({
        prop <- aw_quantile_data() %>%
            gather(simul, x) %>%
            mutate(above = x > input$aw_max_quantile) %>%
            group_by(simul) %>%
            summarize(p = mean(above)) %>%
            ungroup() %>%
            .$p %>% 
            mean() 
        
        paste("Se estima un porcentaje del ", 100*round(prop, 3), "%")
    })
    
    output$number_above1_aw <- renderText({
        proportion <- aw_quantile_data() %>%
            gather(simul, x) %>%
            mutate(above = x > input$aw_max_quantile) %>%
            group_by(simul) %>%
            summarize(p = mean(above)) %>%
            ungroup() %>%
            .$p %>%
            mean()
        paste("Eso es, ", round(1000*proportion, 1), "unidades de cada 1000.")
    })
    
    ## Bayesian test of the proportions
    
    output$proportion_limit <- renderText({
        
        prior_alpha <- 1
        prior_beta <- 1
        n_positives <- input$n_positive
        n_negatives <- input$n_negative
        # alpha <- 1 - input$conf_prop
        limit_p <- qbeta(input$conf_prop, prior_alpha + n_positives, prior_beta + n_negatives)
        
        paste0("Límite superior del intervalo de confianza para la proporción: ", round(limit_p, 3),
               "\n Es decir, ", round(limit_p*1000, 1), " muestras por cada 1000 muestras.")
        
    })
    
    output$posteriors_proportions <- renderPlot({
        
        prior_alpha <- 1
        prior_beta <- 1
        n_positives <- input$n_positive
        n_negatives <- input$n_negative
        # alpha <- 1 - input$conf_prop
        limit_p <- qbeta(input$conf_prop, prior_alpha + n_positives, prior_beta + n_negatives)
        
        p_prior <- tibble(x = seq(0, 1, length = 100),
                          y = dbeta(x, prior_alpha, prior_beta)) %>%
            geom_line(aes(x, y), colour = "blue", linetype = 2, data = .)
        
        p_posterior <- tibble(x = seq(0, 1, length = 1000),
                              y = dbeta(x, prior_alpha + n_positives, prior_beta + n_negatives)) %>%
            mutate(within = ifelse(x < limit_p, TRUE, FALSE)) %>%
            ggplot(aes(x = x, y = y)) +
                geom_area(aes(fill = within), alpha = 0.5) +
                geom_line()
        
        p_posterior + p_prior +
            scale_fill_manual(values = c("white", "darkblue")) +
            theme(legend.position = "none") +
            xlab("Proporcion de muestras positivas") + 
            ylab("Densidad de probabilidad")
            
        
        # tibble(x = seq(0, 1, length = 100),
        #        prior = dbeta(x, prior_alpha, prior_beta),
        #        posterior = dbeta(x, prior_alpha + n_positives, prior_beta + n_negatives)
        # ) %>%
        #     gather(distrib, y, -x) %>%
        #     ggplot() +
        #     geom_line(aes(x, y, colour = distrib, linetype = distrib)) +
        #     geom_vline(xintercept = qbeta(1-alpha, prior_alpha + n_positives, prior_beta + n_negatives),
        #                linetype = 2) +
        #     geom_text(aes(x = qbeta(1-alpha, prior_alpha + n_positives, prior_beta + n_negatives),
        #                   y = 1, 
        #                   label = paste0("Confidence value: ", round(qbeta(1-alpha, prior_alpha + n_positives, prior_beta + n_negatives), 3))), 
        #               hjust = 0)
    })
    
    
    ## T-test of the mean
    
    my_data <- reactive(input$input_pH)
    
    output$histogram_data <- renderPlot({
        
        
        
        my_data() %>%
            as_tibble(., name_repair = "unique") %>% 
            set_names("pH") %>%
            ggplot() +
                # geom_boxplot(aes(y = pH, x = 1)) +
                # geom_hline(yintercept = input$ph_test, linetype = 2, colour = "red")
                geom_histogram(aes(pH)) +
                geom_vline(xintercept = input$ph_test, linetype = 2, colour = "red") +
                geom_text(aes(x = input$ph_test, y = 1, label = "pH para el test"),
                          colour = "red", hjust = 1)
    })
    
    output$test_pH <- renderTable(
        t.test(my_data()[,1], alternative = "less", mu = input$ph_test, 
               conf.level = 1 - input$alpha_test) %>% 
            tidy() %>%
            select(`estadistico t` = statistic,
                   `p-valor` = p.value,
                   `grados de libertad` = parameter,
                   `Intervalo de confianza` = conf.high)
    )
    
    output$summary_data <- renderTable(
        my_data() %>%
            as_tibble(., name_repair = "unique") %>%
            set_names("pH") %>%
            summarise(media = mean(pH), mediana = median(pH), 
                      `desviacion estandard` = sd(pH), observaciones = n())
    )
    
    output$p_value <- renderText({
        
        p_val <- t.test(my_data()[,1], alternative = "less", mu = input$ph_test, 
                                conf.level = 1 - input$alpha_test) %>% 
            tidy() %>%
            .$p.value
        
        if (p_val < input$alpha_test) {
            print(paste("Hay suficiente evidencia para garantizar que el pH es menor que", input$ph_test))
        } else {
            print(paste("NO hay suficiente evidencia para garantizar que el pH es menor que", input$ph_test))
        }
        
    })
    
    output$t_distrib <- renderPlot({
        
        test_results <- t.test(my_data()[,1], alternative = "less", mu = input$ph_test, 
               conf.level = 1 - input$alpha_test) %>% 
            tidy()
        
        tibble(x = seq(-4, 4, length = 100),
               y = dt(x, df = test_results$parameter)) %>%
            mutate(colour = ifelse(x < test_results$statistic, TRUE, FALSE)) %>%
            ggplot(aes(x, y)) +
                geom_line() +
                geom_area(aes(fill = colour)) +
                geom_vline(xintercept = qt(input$alpha_test, df = test_results$parameter),
                           linetype = 2, colour = "red") +
                geom_text(aes(x = qt(input$alpha_test, df = test_results$parameter), y = 0.2, label = "alpha"), 
                          hjust = 1, colour = "red", size = 5) +
                geom_label(aes(x = 0, y = 0.2, label = paste0("p-valor = ", round(test_results$p.value, 3))),
                           size = 5) +
                scale_fill_manual(values = c("darkblue", "white")) +
                theme(legend.position = "none")
        
    })
    
})

