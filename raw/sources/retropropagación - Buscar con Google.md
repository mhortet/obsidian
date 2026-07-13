---
title: "retropropagación - Buscar con Google"
source: "https://www.google.com/search?q=retropropagaci%C3%B3n#fpstate=ive&vld=cid:a051356d,vid:ScVpPS_CFYc,st:4"
author:
published:
created: 2026-06-30
description:
tags:
  - "clippings"
---
## Resultados web

### [¿Qué es la retropropagación?](https://www.ibm.com/es-es/think/topics/backpropagation)
## ¿Qué es la retropropagación?

La retropropagación es una técnica [de machine learning](https://www.ibm.com/es-es/think/topics/machine-learning) esencial para la optimización de las [redes neuronales](https://www.ibm.com/es-es/think/topics/neural-networks). Facilita el uso de algoritmos [de descenso gradiente](https://www.ibm.com/es-es/think/topics/gradient-descent) para actualizar las ponderaciones de la red, que es como "aprenden" los modelos [de deep learning](https://www.ibm.com/es-es/think/topics/deep-learning) que impulsan la [inteligencia artificial (IA)](https://www.ibm.com/es-es/think/topics/artificial-intelligence) moderna.

Abreviatura de "propagación hacia atrás del error", la retropropagación es un método elegante para calcular cómo los cambios en cualquiera de las ponderaciones o sesgos de una red neuronal afectarán a la precisión de las predicciones del modelo. Es esencial el uso del aprendizaje supervisado, el aprendizaje [semisupervisado](https://www.ibm.com/es-es/think/topics/semi-supervised-learning) o el aprendizaje [autosupervisado](https://www.ibm.com/es-es/think/topics/self-supervised-learning) para entrenar redes neuronales.

Aunque se propusieron de forma independiente equivalentes y predecesores de la retropropagación en diversos contextos que se remontan a la década de 1960, David E. Rumelhart, Geoffrey Hinton y Ronald J. Williams publicaron por primera vez el algoritmo de aprendizaje formal. Su artículo de 1986, "Learning representations by back-propagating errors (Aprendizaje de representaciones mediante errores de retropropagación)", proporcionó la derivación del algoritmo de retropropagación tal como se utiliza y entiende en un contexto moderno de machine learning.

La lógica de la retropropagación es que las capas de neuronas de las redes neuronales artificiales son básicamente una serie de funciones matemáticas anidadas. Durante el entrenamiento, esas ecuaciones interconectadas se anidan en otra función más: una "función de pérdida" que mide la diferencia (o "pérdida") entre la salida deseada (o "verdad fundamental") para una entrada dada y la salida real de las redes neuronales.

Por lo tanto, podemos usar la “regla de la cadena”, un [principio de cálculo que data del siglo XVII](https://www.jstor.org/stable/27900650), para calcular la tasa a la que cada neurona contribuye a la pérdida total. Al hacerlo, podemos calcular el impacto de los cambios en cualquier variable, es decir, en cualquier ponderación o sesgo, dentro de las ecuaciones que representan esas neuronas.

Matemáticamente hablando, la retropropagación funciona hacia atrás desde la salida para calcular eficazmente el "gradiente" de la función de pérdida: un vector de derivadas para cada ecuación de la red. Este gradiente indica a los algoritmos de optimización, como el "descenso de gradiente", qué ecuaciones ajustar y en qué dirección ajustarlas para reducir las pérdidas.

Estos tres procesos entrelazados (una función de pérdida que rastrea el error del modelo en diferentes entradas, la propagación hacia atrás de ese error para ver cómo las diferentes partes de la red contribuyen al error y los algoritmos de descenso de gradiente que ajustan las ponderaciones del modelo en consecuencia) son la forma en que los modelos de deep learning “aprenden”. Como tal, la retropropagación es fundamental para entrenar modelos de redes neuronales, desde los [perceptrones multicapa](https://www.ibm.com/docs/en/spss-statistics/saas?topic=networks-multilayer-perceptron) más básicos hasta las complejas arquitecturas de redes neuronales profundas utilizadas para la [IA generativa](https://www.ibm.com/es-es/topics/generative-ai).
## ¿Cómo funcionan las redes neuronales?

Dado que el proceso de retropropagación es tan fundamental para el entrenamiento de las redes neuronales, una explicación útil del proceso requiere una comprensión práctica de cómo las redes neuronales hacen predicciones.

Y todavía más importante es entender el propósito y el contexto de las "ponderaciones" y los "sesgos": los parámetros ajustables del modelo que se optimizan mediante retropropagación y descenso de gradiente.

### Estructura de las redes neuronales

Las redes neuronales pretenden imitar aproximadamente la estructura del cerebro humano. Están compuestas de muchos nodos interconectados (o neuronas), dispuestos en capas. Las redes neuronales hacen predicciones cuando los datos de entrada originales han realizado un "paso hacia adelante" a través de toda la red.

Las neuronas en la "capa de entrada" reciben datos de entrada, generalmente como una [incrustación](https://www.ibm.com/es-es/think/topics/vector-embedding) vectorial, y cada neurona de entrada recibe una característica individual del vector de entrada. Por ejemplo, un modelo que trabaja con imágenes en escala de grises de 10x10 píxeles normalmente tendrá 100 neuronas en su capa de entrada, y cada neurona de entrada corresponde a un píxel individual. Por lo tanto, las redes neuronales suelen requerir entradas de tamaño fijo, aunque técnicas como la agrupación o la normalización pueden proporcionar cierta flexibilidad.  

En una red neuronal feedforward estándar, cada neurona de la capa de entrada está conectada a cada una de las neuronas de la siguiente capa, que a su vez están conectadas a las neuronas de la siguiente capa, y así sucesivamente hasta la _capa de salida_ donde se realizan las predicciones finales. Las capas intermedias entre la capa de entrada y la capa de salida, llamadas _capas ocultas_ de la red, son donde se produce la mayor parte del "aprendizaje".

Aunque algunas arquitecturas de redes neuronales especializadas, como la [mezcla de modelos expertos](https://www.ibm.com/es-es/think/topics/mixture-of-experts) o [las redes neuronales convolucionales](https://www.ibm.com/es-es/think/topics/convolutional-neural-networks), implican variaciones, adiciones o excepciones a esta sencilla disposición, todas las redes neuronales emplean esta estructura central.
![Diagrama de una red neuronal con tres capas ocultas: capa de entrada, varias capas ocultas, capa de output](https://assets.ibm.com/is/image/ibm/ICLH_Diagram_Batch_01_03-DeepNeuralNetwork?fmt=png-alpha&dpr=on%2C1&wid=320&hei=180)
Representación visual de una red neuronal feedforward básica con 3 capas ocultas. Durante la inferencia, la información sobre los datos de entrada fluye de izquierda a derecha; durante la retropropagación, la información sobre el error fluye de derecha a izquierda.

### Ponderaciones y sesgos

Aunque cada neurona recibe entradas de cada nodo de la capa anterior, no todas esas entradas tienen la misma importancia. A cada conexión entre dos neuronas se le asigna una "ponderación" única: un multiplicador que aumenta o disminuye la contribución de una neurona a una neurona en la siguiente capa.

A cada neurona individual también se le puede dar un "sesgo": un valor constante añadido a la suma de las entradas ponderadas de las neuronas en la capa anterior.[](https://www.ibm.com/es-es/think/topics/backpropagation#_msocom_1)

El objetivo final de la retropropagación y el descenso de gradiente es calcular las ponderaciones y sesgos que producirán las mejores predicciones del modelo. Las neuronas correspondientes a características de datos que se correlacionan significativamente con predicciones precisas reciben mayor ponderación; a otras conexiones se les puede dar ponderaciones cercanas a cero.

Las redes neuronales profundas modernas, a menudo con docenas de capas ocultas y cada una con muchas neuronas, pueden comprender miles, millones o, en el caso de la mayoría de los grandes modelos lingüísticos (LLM), miles de millones de parámetros ajustables de este tipo.

### Funciones de activación

Cada neurona está configurada para realizar una operación matemática, denominada "función de activación", sobre la suma de las entradas ponderadas de forma variable que recibe de los nodos de la capa anterior. Las funciones de activación introducen "no linealidad"_, l_o que permite al modelo capturar patrones complejos en los datos de entrada y producir gradientes que pueden optimizarse. El uso exclusivo de funciones de activación lineal esencialmente colapsa la red neuronal en un modelo [de regresión](https://www.ibm.com/es-es/think/topics/linear-regression) lineal.

[Las funciones de activación comunes](https://www.ibm.com/docs/spss-statistics/29.0.0?topic=perceptron-architecture-multilayer&mhsrc=ibmsearch_a&mhq=Architecture%20%26lpar%3BMultilayer%20Perceptron%26rpar%3B%20) en redes neuronales incluyen:

- La función **sigmoide** , que asigna cualquier entrada a un valor entre 0 y 1.
- La **tangente hiperbólica** (o **tanh**) , que asigna entradas a un valor entre -1 y 1.
- La **unidad lineal rectificada** (o **ReLU**), que asigna cualquier entrada negativa a 0 y deja sin cambios cualquier entrada positiva.
- La función **softmax**, que convierte un vector de entradas en un vector cuyos elementos oscilan entre 0 y 1 y, en conjunto, suman 1.

Considere una unidad oculta hipotética _z,_ con una función de activación _tanh_ y un término de sesgo _t,_ en la segunda capa de una red neuronal con 3 nodos de entrada, _a_, _b y_ _c,_ en su capa de entrada. Cada una de las conexiones entre los nodos de entrada y el nodo _z_ tiene una ponderación única, _w._ Podemos describir el valor de salida que el nodo _z_ pasará a las neuronas de la capa siguiente con la ecuación simplificada _z_ = _tanh_(_waz*a + wbz*b_ + _wcz*c_ _+ t_)_._

La neurona _z_ está conectada a las neuronas de la siguiente capa. Esa ecuación para _z_ es, por lo tanto, parte de las funciones de activación en la siguiente capa y, por extensión, también parte de cada función de activación para cualquier neurona en cualquier capa posterior.

![Fórmulas y visualizaciones para funciones de activación comunes en redes neuronales. IZQUIERDA: sigmoide; CENTRO: tanh; DERECHA: ReLU](https://assets.ibm.com/is/image/ibm/common-activation-functions-combined?dpr=on%2C1&wid=320&hei=180)Fórmulas y visualizaciones para funciones de activación comunes en redes neuronales. IZQUIERDA: sigmoide; CENTRO: tanh; DERECHA: ReLU

## ¿Por qué utilizar la retropropagación?

Como se explicará en las siguientes secciones, la retropropagación es un algoritmo notablemente rápido y eficiente para desenredar la enorme red de variables y ecuaciones interconectadas en una red neuronal.

Para ilustrar la eficiencia de la retropropagación, Michael Nielsen la compara con un enfoque alternativo simple e intuitivo para calcular el gradiente de la función de pérdida de una red neuronal en su libro digital, "Neural Networks and Deep Learning"_._

Como explica Nielsen, se puede estimar fácilmente el impacto de los cambios en cualquier ponderación específica _w_j en la red simplemente completando un paso hacia adelante para dos valores ligeramente diferentes de _w_j, manteniendo todos los demás parámetros sin cambios y comparando la pérdida resultante para cada paso. Al formalizar ese proceso en una ecuación sencilla e implementar unas pocas líneas de código en Python, se puede automatizar ese proceso para cada ponderación de la red.

Pero ahora imagine que su modelo tiene 1 millón de ponderaciones, algo bastante modesto para un modelo moderno de deep learning. Para calcular todo el gradiente, necesitaría completar 1 000 001 pasos hacia adelante a través de la red: uno para establecer una línea de base y luego otro paso para evaluar los cambios en cada uno de los millones de ponderaciones.[](https://www.ibm.com/es-es/think/topics/backpropagation#_ftn1)

La retropropagación puede lograr el mismo objetivo en _2_ pasos: 1 paso hacia adelante y 1 paso hacia atrás.

Mixture of Experts | 12 de diciembre, episodio 85

IBM

https://www.ibm.com › think › topics › backpropagation

IBM

https://www.ibm.com › think › topics › backpropagation

La retropropagación *es una técnica de machine learning esencial para la optimización de las redes neuronales*. Facilita el uso de algoritmos de descenso...

### [Retropropagación - Wikipedia, la enciclopedia libre](https://es.wikipedia.org/wiki/Retropropagaci%C3%B3n)

Wikipedia

https://es.wikipedia.org › wiki › Retropropagación

Wikipedia

https://es.wikipedia.org › wiki › Retropropagación

En aprendizaje de máquina, la retr *o* propagación o propagación hacia atrás de errores (del inglés backpropagation) es un algoritmo de aprendizaje supervisado...

[![retropropagación de es.wikipedia.org](data:image/png;base64,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)](https://es.wikipedia.org/wiki/Retropropagaci%C3%B3n)

Más preguntas

## Resultados web

### [La mejor manera de entender la retropropagación...](https://www.reddit.com/r/learnmachinelearning/comments/1e89458/best_way_to_understand_backpropagation/?tl=es-419)

Reddit · r/learnmachinelearning

Más de 20 comentarios · hace 1 año

Reddit · r/learnmachinelearning

Más de 20 comentarios · hace 1 año

No le des tantas vueltas: la retropropagación (backprop) *es básicamente una aplicación ingeniosa de la regla de la cadena*, que nos facilita...

## Resultados web

### [Algoritmo de retropropagación de error | Aula En Abierto](https://formacion.intef.es/aulaenabierto/mod/book/view.php?id=5077&chapterid=6493)

INTEF

https://formacion.intef.es ›... › Aprendizaje profundo

INTEF

https://formacion.intef.es ›... › Aprendizaje profundo

En la *retropropagación* se utiliza la regla de la cadena, con la que se calcula la derivada del error de cada capa y luego la derivada de la penúltima capa. A...

### [Qué es Retropropagación Concepto y definición. Glosario](https://gamco.es/glosario/retropropagacion/)

gamco, sl

https://gamco.es › glosario › retropropagacion

gamco, sl

https://gamco.es › glosario › retropropagacion

*La retropropagación funciona propagando el error hacia atrás a través de la red neuronal*, comenzando por la capa de salida y retrocediendo hacia las capas...

### [Retropropagación en redes neuronales y Machine Learning](https://blog.bricogeek.com/noticias/programacion/retropropagacion-en-redes-neuronales-y-machine-learning/)

BricoGeek.com

https://blog.bricogeek.com › noticias › programacion › r...

BricoGeek.com

https://blog.bricogeek.com › noticias › programacion › r...

18 abr 2016 — *Mediante la retropropagación se ajustan los pesos*. Si lo piensas bien, no es más que un calculo estadísticos que devuelve una tasa de error. El...

### [Algoritmo de Retropropagación](https://www.cs.us.es/~fsancho/ficheros/IAML/2016/Sesion04/capitulo_BP.pdf)

Universidad de Sevilla

https://www.cs.us.es › Sesion04 › capitulo\_BP

Universidad de Sevilla

https://www.cs.us.es › Sesion04 › capitulo\_BP

PDF

por PA BlancoMencionado por 5 — A continuación presentamos el método de retropropagación, *uno de los al- goritmos más conocidos para entrenar los pesos de una red neuronal artificial*.

8 páginas

### [¿Qué es la retropropagación y qué hace realmente?: r/compsci](https://www.reddit.com/r/compsci/comments/7atmsf/what_is_backpropagation_and_what_is_it_actually/?tl=es-es)

Reddit · r/compsci

Más de 10 comentarios · hace 8 años

Reddit · r/compsci

Más de 10 comentarios · hace 8 años

“ **Retropropagación** ” es el método por el que se entrenan las redes neuronales artificiales. Si eso es todo lo que querías saber, por ejemplo, para...