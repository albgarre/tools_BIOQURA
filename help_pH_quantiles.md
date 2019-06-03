Análisis estadístico de los cuantiles del pH
--------------------------------------------

Debido a la variabilidad de los productos, es prácticamente imposible
asegurar que ningún producto dentro de un lote tenga un pH superior al
admisible (p.ej. el pH que permita el crecimiento de *Listeria*). Por
ello, en el contexto del análisis de riesgo, es importante conocer la
probabilidad de que un producto tenga un pH superior al límite.

Esta herramienta permite estimar, en base a una serie de mediciones, la
proporción de muestras con un pH superior al admisible. El cálculo está
basado en la hipótesis de que el pH de las muestras sigue una
distribución normal con varianza y media desconocidas (ver **Detalles
del análisis estadístico**).

Descripción de los parámetros
-----------------------------

-   **pH medio**: media del pH medido en todas las muestras (calculado
    como PROMEDIO en Excel).
-   **Desv. standard del pH**: desviación estandard de las medidas
    (calculado como DESVEST en Excel).
-   **Número de medidas**: número de muestras analizadas.
-   **pH máximo admisible**: pH definido como máximo admisible (p.ej.
    para *Listeria* el pH máximo admisible para crecimiento es 4,4).

Resultados
----------

Los resultados reportados son:

-   La proporción estimada de muestras con un pH superior a la
    admisible.
-   El número de muestras con un pH superior al límite por cada mil
    productos.
-   Un gráfico de densidad de probabilidad para la proporción de
    muestras con un pH superior al admisible.

Detalles del análisis estadístico
---------------------------------

Sea *X* una variable aleatoria con un media *μ* y varianza
*σ*<sup>2</sup>, ambas desconocidas. Una muestra aleatoria
*X*<sub>1</sub>, *X*<sub>2</sub>, ..., *X*<sub>*n*</sub> de tamaño *n*
de *X* cumple las siguientes propiedades:

-   $\\bar{X} = \\sum\_{i=1}^n{X\_i}$ y
    $s^2 = \\frac{\\sum\_{i=1}^n{(X\_i - \\bar{X})^2}}{n-1}$ son
    independientes.
-   el cociente (*n* − 1)*s*<sup>2</sup>/*σ*<sup>2</sup> sigue una
    distribución *χ*<sub>*n* − 1</sub><sup>2</sup>.
-   el cociente $\\frac{\\bar{X}-\\mu}{s/\\sqrt(n)}$ sigue una
    distribución t de Student con *n* − 1 grados de libertad.

A traves del muestreo intentamos estimar ambas variables, la media
muestral y su varianza. Por lo tanto, a la hora de estimar la proporción
de muestras con un pH superior al límite, la incertidumbre en la
estimación de ambas variables se debe de tener en cuenta. Esta
herramienta utiliza simulaciones de Monte Carlo para ello:

1.  Se generan 2000 valores aleatorios de una distribución t de Student
    con *n* − 1 grados de libertad
    (*t*<sub>*i*</sub>; *i* = 1, ..., 2000).
2.  Se genera una muestra de la media
    $\\mu\_i = \\frac{t\_i \\cdot s}{\\sqrt{n}} + \\bar{X}$.
3.  Se generan 2000 valores aleatorios de una distribución
    *χ*<sup>2</sup> con *n* − 1 grados de libertad
    (*χ*<sub>*i*</sub><sup>2</sup>; *i* = 1, ..., 2000).
4.  Se simula la varianza como
    $\\sigma^2\_i = (n-1) \\frac{s^2}{\\chi^2\_{i}}$.
5.  Para cada par *μ*<sub>*i*</sub>, *σ*<sub>*i*</sub><sup>2</sup> se
    genera una muestra de 5000 valores aleatorios de acuerdo a una
    distribución normal con parámetros
    *μ*<sub>*i*</sub>, *σ*<sub>*i*</sub><sup>2</sup>.
6.  De la muestra aleatoria simulada, se comprueba cuántos tienen un pH
    superior al límite (*n*<sub>*p**o**s*</sub>) y cuantos no
    (*n*<sub>*n**e**t*</sub>).
7.  La proporción de productos con un pH superior al límite se estima
    como $\\frac{n\_{pos}}{n\_{pos} + n\_{neg}}$.
