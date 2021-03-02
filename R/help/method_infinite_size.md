Método estadístico
------------------

El método de Wald para el cálculo de intervalos de confianza para la
proporción problacional esta basado en la aproximación de la
distribución binomial utilizando una distribución normal. La precisión
de esta aproximación depende del tamaño muestral y del valor de *p*.
Para ase gurar su precisión, se aconseja comprobar que el coeficiente de
simetría sea menor de 1/3 (Box et al., 2005). Esta condición se puede
escribir como:

$$
\\frac{1}{\\sqrt n} \\left| \\sqrt{ \\frac{1-p}{p} } - \\sqrt{ \\frac{p}{1-p} } \\right| \\leq 1/3
$$

dónde

-   *n* es el tamaño muestral.
-   *p* es la proporción esperada de positivos (decomisos).

Una vez que se ha validado la precisión del estimador utilizando la
condición anterior, se puede definir un tamaño mínimo muestral en base a
la precisión esperada del estimador:

$$
n \\geq \\left( \\frac{z\_{1-\\alpha/2}}{MOE}  \\right)^2p(1-p)
$$
dónde

-   *M**O**E* es el error del estimador.
-   *z*<sub>1 − *α*/2</sub> es el percentil (1 − *α*/2) de la
    distribución normal.

Interpretación de los parámetros
--------------------------------

El tamaño muestral mínimo está definido por 3 parámetros: la proporción
de positivos (decomisos) esperada (*p*), el nivel de significación (*α*)
y el error esperado del estimador (*M**O**E*). El valor de *p* puede
estar basado en datos históricos de la producción, o en valores sacados
de la bibliografía científica. Para *α*, se aconseja utilizar un valor
de 0.05. El error del estimador se debe asignar en base a la precisión
requerida en el estudio. Si, por ejemplo, la proporción de decomisos
esperada es igual a 0.02 y se consideraría que el sistema está fuera de
control para una proporción de 0.05, el *M**O**E* se debería definir
como 0.05-0.02 = 0.03.

Interpretación de los resultados del cálculo
--------------------------------------------

La herramienta calcula el tamaño muestral mínimo de acuerdo a las dos
condiciones descritas anteriormente. La Condición I es el tamaño mínimo
para que el método estadístico sea correcto. La Condición II es el
tamaño mínimo de acuerdo a la precisión mínima requerida para el
estimador. Como ambas condiciones dan un tamaño mínimo, se debe utilizar
el valor máximo (la herramienta lo muestra en naranja).

Es posible que el tamaño muestral calculado por la herramienta sea
demasiado alto desde un punto de vista práctico. En estos casos, se
recomienda utilizar la herramienta para poblaciones finitas, que utiliza
un método más complejo que considera poblaciones finitas.
