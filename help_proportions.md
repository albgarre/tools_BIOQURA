Intervalo de confianza de la proporción de muestras positivas
-------------------------------------------------------------

El análisis del riesgo microbiológico en el ámbido de la industria
alimentaria requiere una estimación precisa de la proporción de lotes
que tienen una posible contaminación.Para conocer este valor, sería
necesario realizar un análisis microbiológico de todos los lotes
producidos por la empresa, lo que es inviable. Consecuentemente, el
muestreo se limita a un muestreo, el cuál debe de ser complementado con
análisis estadístico. Sin embargo, debido a que esta proporción es
extremadamente baja, se violan las hipótesis requeridas para la
estimación de la proporción utilizando las técnicas clásicas
(frecuentistas) de estimación. Por lo tanto, técnicas alternativas son
requeridas para analizar este tipo de datos.

Esta herramienta utiliza técnicas de análisis Bayesiano para estimar un
intervalo de confianza para la proporción de muestras (ver **Análisis
Estadístico**). El usuario debe introducir el número de muestras
positivas y el número de muestra positivas, así como el nivel de
confianza deseado (se recomienda 0.99).

En base a estos datos, la herramienta calcula un intervalo de confianza
para la proporción de muestras positivas utilizando estadística
bayesiana con suponiendo una versomilitud de acuerdo a una distribución
binomial y una distribución a-priori tipo Beta. Este resultado puede
incorporarse dentro de un análisis del riesgo microbiológico.

Descripción de los parámetros
-----------------------------

-   **número de muestras positivas**: Número de muestras en el que el
    test (p.ej. presencia de patógeno) es positivo.
-   **número de muestras negativas**: Número de muestras en el que el
    test (p.ej. presencia de patógeno) es negativo.
-   **Nivel de confianza**: Nivel de confianza (1 − *α*) al que los
    resultados son calculados.

Resultados
----------

Los resultados se reportan como:

-   Un gráfico de densidad de probabilidad a posteriori de la proporción
    de muestras positivas. En este gráfico, el intervalo de confianza al
    nivel de confianza seleccionado se muestra sombreado en azul.
-   El valor numérico del límite superior del intervalo de confianza
    para la proporción de muestras positivas en base a los parámetros
    introducidos.

Detalles del análisis estadístico
---------------------------------

Sea *p* la proporción de productos que contaminados. La probabilidad de
que en un muestreo de tamaño *n* se encuentren *y* muestras contaminadas
sigue una distribución binomial:

*y* ∼ *B**i**n**o**m*(*n*, *p*)

En este caso, tanto *n* (el número de muestras) como *y* (el número de
muestras positivas) son datos conocidos. Por lo tanto, lo que se
necesita es estimar *p*. Utilizando una destribución a-priori para *p*
tipo Beta con parámetros *α* y *β*:

*p* ∼ *B**e**t**a*(*α*, *β*)

La distribución a posteriori de *p* dados los valores de *y* y *n*
observados también sigue una distribución Beta con parámetros
(*α*+*y*<sub>*p*</sub>,*β*+*y*<sub>*N*</sub>), dónde *y*<sub>*p*</sub>
es el número de muestras positivas y *y*<sub>*n*</sub> el número de
muestras negativas.

*p*(*p*|*y*, *n*) ∼ *B**e**t**a*(*α* + *y*<sub>*p*</sub>, *β* + *y*<sub>*n*</sub>)

Finalmente, el intervalo de confianza para *p* se puede calcular de
acuerdo a los cuantiles de la distribución Beta.
