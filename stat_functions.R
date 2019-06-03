
simulate_ph <- function(n, mu, s, sim_dim1 = 2000, sim_dim2 = 5000) {
    
    tibble(t_val = rt(sim_dim1, n-1),
           mu_sim = t_val*s/sqrt(n) + mu,
           # mu_sim = rnorm(sim_dim1, mu, s/sqrt(n)),
           s_sim = (n-1)*s^2/rchisq(sim_dim1, n-1)) %>%
        # ggplot() +
        #     geom_density(aes(s_sim))
        mutate(sim = 1:nrow(.)) %>%
        gather(var, value, -sim) %>%
        spread(sim, value) %>%
        column_to_rownames("var") %>%
        map_dfc(., ~ rnorm(sim_dim2, mean = .[1], sd = .[2]))
    
}

