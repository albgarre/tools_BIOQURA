
library(tidyverse)

## Infinite sample size

# p <- 0.02
# m <- 0.02

# 9*(sqrt((1-p)/p) - sqrt(p/(1-p)))^2

# 5/p

# (1.96/m)^2*p*(1-p)

## Functions for the calculations (from https://doi.org/10.1080/00224065.1973.11980599)

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

## Functions for the iterations

#' Determinacion del limite izquierdo para el tamano muestral
#' 
#' Parametros
#'     niter: Numero de iteraciones del algoritmo numerico
#'     n_start: Tamano muestral inicial
#'     c: Numero maximo de decomisos en la muestra
#'     N: Tamano poblacional
#'     beta: Probabilidad de error tipo II
#'     k0: Numero de decomisos definiendo el error tipo I
#'     k1: Numero de decomisos definiendo el error tipo II
#'     
iterate_lhs <- function(niter, n_start, c, N, beta, k0, k1) {
    
    my_ns <- numeric(length = niter)
    my_ns[1] <- n_start
    
    for (i in 1:niter) {
        new_n <- get_lhs(my_ns[i], c, N, beta, k0, k1)
        my_ns[i+1] <- new_n
    }
    
    my_ns
    
}

#' Determinacion del limite derecho para el tamano muestral
#' 
#' Parametros
#'     niter: Numero de iteraciones del algoritmo numerico
#'     n_start: Tamano muestral inicial
#'     c: Numero maximo de decomisos en la muestra
#'     N: Tamano poblacional
#'     alpha: 1-probabilidad de error tipo I
#'     k0: Numero de decomisos definiendo el error tipo I
#'     k1: Numero de decomisos definiendo el error tipo II
#'     
#'
iterate_rhs <- function(niter, n_start, c, N, alpha, k0, k1) {
    
    my_ns <- numeric(length = niter)
    my_ns[1] <- n_start
    
    for (i in 1:niter) {
        new_n <- get_rhs(my_ns[i], c, N, alpha, k0, k1)
        my_ns[i+1] <- new_n
    }
    
    my_ns
    
}

## Example calculations

#- Article https://doi.org/10.1080/00224065.1973.11980599

N <- 1000
alpha <- .05
beta <- .01
k0 <- 10
k1 <- 50

iterate_lhs(8, 259, 5, N, beta, k0, k1)
iterate_rhs(8, 262, 5, N, alpha, k0, k1)

iterate_lhs(8, 198, 4, N, beta, k0, k1)
iterate_rhs(8, 262, 4, N, alpha, k0, k1)

iterate_lhs(8, 198, 3, N, beta, k0, k1)
iterate_rhs(8, 262, 3, N, alpha, k0, k1)

tibble(
    iter = 0:8,
    lower = iterate_lhs(8, 259, 4, N, beta, k0, k1),
    upper = iterate_rhs(8, 262, 4, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
        geom_point() +
        geom_line()

#- 

N <- 2801
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 500, 7, N, beta, k0, k1),
    upper = iterate_rhs(25, 500, 7, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 1051
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
        lower = iterate_lhs(25, 500, 6, N, beta, k0, k1),
    upper = iterate_rhs(25, 500, 6, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 541
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 500, 5, N, beta, k0, k1),
    upper = iterate_rhs(25, 500, 5, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 300
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:100,
    lower = iterate_lhs(100, 300, 4, N, beta, k0, k1),
    upper = iterate_rhs(100, 300, 4, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 2000
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 500, 6, N, beta, k0, k1),
    upper = iterate_rhs(25, 500, 6, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 1500
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 400, 6, N, beta, k0, k1),
    upper = iterate_rhs(25, 400, 6, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 1000
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 300, 5, N, beta, k0, k1),
    upper = iterate_rhs(25, 300, 5, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 500
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 300, 4, N, beta, k0, k1),
    upper = iterate_rhs(25, 300, 4, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 8000
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 300, 7, N, beta, k0, k1),
    upper = iterate_rhs(25, 300, 7, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 6000
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 300, 7, N, beta, k0, k1),
    upper = iterate_rhs(25, 300, 7, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 4000
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 300, 7, N, beta, k0, k1),
    upper = iterate_rhs(25, 300, 7, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 8480
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 300, 7, N, beta, k0, k1),
    upper = iterate_rhs(25, 300, 7, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 7000
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 300, 7, N, beta, k0, k1),
    upper = iterate_rhs(25, 300, 7, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 5000
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 300, 7, N, beta, k0, k1),
    upper = iterate_rhs(25, 300, 7, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#- 

N <- 3000
alpha <- .05
beta <- .01
k0 <- .01*N
k1 <- .04*N

tibble(
    iter = 0:25,
    lower = iterate_lhs(25, 300, 7, N, beta, k0, k1),
    upper = iterate_rhs(25, 300, 7, N, alpha, k0, k1)
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

## Calculos limite del 2%

N <- 200
alpha <- .05
beta <- .01
k0 <- 1
k1 <- floor(.02*N)

tibble(
    lower = ceiling(iterate_lhs(100, 10, 3, N, beta, k0, k1)),
    upper = floor(iterate_rhs(100, 10, 3, N, alpha, k0, k1))
) %>%
    mutate(iter = row_number()) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#-

N <- 500
alpha <- .05
beta <- .01
k0 <- floor(.005*N)
k1 <- floor(.02*N)

tibble(
    lower = ceiling(iterate_lhs(100, 60, 4, N, beta, k0, k1)),
    upper = floor(iterate_rhs(100, 600, 4, N, alpha, k0, k1))
) %>%
    mutate(iter = row_number()) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#-

N <- 1199
alpha <- .05
beta <- .01
k0 <- floor(.005*N)
k1 <- floor(.02*N)

tibble(
    lower = ceiling(iterate_lhs(100, 600, 4, N, beta, k0, k1)),
    upper = floor(iterate_rhs(100, 600, 4, N, alpha, k0, k1))
) %>%
    mutate(iter = row_number()) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#-

N <- 2199
alpha <- .05
beta <- .01
k0 <- floor(.005*N)
k1 <- floor(.02*N)

tibble(
    lower = ceiling(iterate_lhs(100, 600, 5, N, beta, k0, k1)),
    upper = floor(iterate_rhs(100, 600, 5, N, alpha, k0, k1))
) %>%
    mutate(iter = row_number()) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#-

N <- 5199
alpha <- .05
beta <- .01
k0 <- floor(.005*N)
k1 <- floor(.02*N)

tibble(
    lower = ceiling(iterate_lhs(100, 700, 6, N, beta, k0, k1)),
    upper = floor(iterate_rhs(100, 700, 6, N, alpha, k0, k1))
) %>%
    mutate(iter = row_number()) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

#-

N <- 5200
alpha <- .05
beta <- .01
k0 <- floor(.005*N)
k1 <- floor(.02*N)

tibble(
    lower = ceiling(iterate_lhs(100, 700, 7, N, beta, k0, k1)),
    upper = floor(iterate_rhs(100, 700, 7, N, alpha, k0, k1))
) %>%
    mutate(iter = row_number()) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()




#-

N <- 8481
alpha <- .05
beta <- .01
k0 <- .005*N
k1 <- .02*N

tibble(
    iter = 0:25,
    lower = ceiling(iterate_lhs(25, 300, 7, N, beta, k0, k1)),
    upper = floor(iterate_rhs(25, 300, 7, N, alpha, k0, k1))
) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()

## Calculos limite del 4%

N <- 600
alpha <- .05
beta <- .01
k0 <- floor(.005*N)
k1 <- floor(.04*N)

tibble(
    lower = ceiling(iterate_lhs(1000, 200, 4, N, beta, k0, k1)),
    upper = floor(iterate_rhs(1000, 200, 4, N, alpha, k0, k1))
) %>%
    mutate(iter = row_number()) %>%
    gather(side, n, -iter) %>%
    ggplot(aes(x = iter, y = n, colour = side)) +
    geom_point() +
    geom_line()





















