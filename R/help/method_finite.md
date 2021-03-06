Método estadístico
------------------

Cuando el tamaño de la población (el tamaño de la manada) no puede
considerarse infinito, los resultados del muestreo siguen una
distribución hipergeométrica. El cálculo del tamaño mínimo de la muestra
para una distribución hipergeométrica es más complejo que para una
distribución binomial. En esta herramienta, se utiliza el método
iterativo sugerido por Guenther (1973). En esta metodología, se
considera que el sistema de producción está bajo control si el número de
positivos en una muestra de tamaño *n* es menor o igual que un valor
entero *c*. Como en cualquier contraste de hipótesis, el sistema de
muestreo puede fallar por dos motivos: que se acepte el lote cuando la
producción está fuera de control (es decir, cuando hay un porcentaje de
decomisos por encima del esperado) (falso negativo) o que se rechace el
lote cuando la producción está bajo control (falso positivo). Nótese
que, desde un punto de vista estadístico, siempre habrá una (pequeña)
posibilidad de que ocurra un falso positivo o falso negativo.

Matemáticamente, la posibilidad de falso negativo (*β*) se puede definir
como la probabilidad de aceptar el lote cuando en realidad contiene
*k*<sub>1</sub> o más decomisos. Por otro lado, la posibilidad de falso
positivo (1 − *α*) se puede definir como la probabilidad de rechazar el
lote cuando éste contiene *k*<sub>0</sub> decomisos o menos. En base a
esta definición y a la aproximación propuesta por Wise (1954), Guenther
(1973) especifica que el tamaño muestral (*n*) adecuado para que la
probabilidad de falso negativo sea menor que *β* y la probabilidad de
falso positivo sea menor que 1 − *α* debe estar entre los siguientes
límites:

$$
\\frac{1}{2} \\left( \\chi^2\_{2c+2;1-\\beta} \\left(\\frac{1}{p\_1'} - 0.5 \\right) + c \\right) \\leq n \\leq \\frac{1}{2} \\left( \\chi^2\_{2c+2;\\alpha} \\left(\\frac{1}{p\_0'} - 0.5 \\right) + c \\right)
$$

dónde:

-   *χ*<sub>2*c* + 2; 1 − *β*</sub><sup>2</sup> es el percentil 1 − *β*
    de la distribución chi-cuadrado con 2*c* + 2 grados de libertad.
-   *χ*<sub>2*c* + 2; *α*</sub><sup>2</sup> es el percentil *α* de la
    distribución chi-cuadrado con 2*c* + 2 grados de libertad.
-   $p\_1'=\\frac{k\_1 -c/2}{M}$ y $p\_0'=\\frac{k\_0 - c/2}{M}$ con
    $M = N - \\frac{n-1}{2}$.

Esta ecuación no tiene solución analítica y debe de resolverse
utilizando métodos numéricos. Atendiendo a las recomendaciones de
Guenther (1973), el tamaño muestral es aquel definido por los valores
mínimos de *c* y *n* para los que la condición anterior tiene solución.

Interpretación de los parámetros
--------------------------------

El método implementado en esta herramienta considera que el sistema está
fuera de control si el número de positivos (decomisos en este contexto)
está fuera de un rango, definido por *k*<sub>1</sub> y *k*<sub>0</sub>.
Es decir, si el número de positivos es mayor o menor que unos valores
límitos. Aunque en el estudio del número de decomisos, es de especial
interés el límite superior (es decir, que el número de decomisos sea
superior a un valor dado), el método estadístico también necesita la
definición del límite anterior.

El método utiliza 5 parámetros. El primero es el tamaño de la manada
analizada, que debe de ser un valor entero. La proporción máxima de
positivos está definida por dos parámetros. El parámetro *k*<sub>1</sub>
(definido en la caja *Proporción máxima de positivos*) este valor
umbral. El parámetro *β* (definido en la caja *Significación estadística
del límite superior (beta)*) define el nivel de significación. Se
recomienda usar un valor de 0.01 para este parámetro.

La proporción mínima de positivos también está definida por dos
parámetros, *k*<sub>0</sub> (*Proporción mínima de positivos*) y *α*
(*Significación estadística del límite inferior (alpha)*), con similar
interpretación a *k*<sub>1</sub> y *β*. Se recomienda utilizar un valor
de 0.05 para *α*.

Interpretación de los resultados del cálculo
--------------------------------------------

Este método proporciona un rango para el tamaño muestral. Cualquier
valor dentro de ese rango (incluidos los límites) es válido. También
proporciona un valor máximo del número de positivos (en este caso,
número de decomisos). Cuando el número observado de decomisos es
superior a este valor, el sistema está fuera de control (la población
tiene más decomisos de los definidos por los parámetros).
