Método estadístico
------------------

Un intervalo de confianza para la proporción poblacional se puede
calcular utilizando el método de Wald (Box et al., 2005):

$$
CI: \\hat{p} \\pm z\_{1-\\alpha/2} \\sqrt{ \\frac{\\hat{p}(1-\\hat{p})}{n} }
$$

dónde

-   *p̂* es el número de positivos (decomisos) observado.
-   *z*<sub>1 − *α*/2</sub> es el percentil (1 − *α*/2) de la
    distribución normal.
-   *n* es el tamaño muestral.

Interpretación de los parámetros
--------------------------------

De los tres parámetros que utiliza la herramienta, uno es el diseño del
muestreo (*n*) y otro es el resultado del muestreo (*p̂*). El único
parámetro “editable” es el nivel de significación *α*. Se recomienda
usar un valor máximo de 0.05, aunque valores menores se pueden utilizar
para niveles de calidad más altos.
