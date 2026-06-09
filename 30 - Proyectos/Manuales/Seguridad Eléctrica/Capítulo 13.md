---
tags:
  - manuales
  - SegElec
Referencias:
  - "[[Capítulo 14]]"
---
# 13. Métodos de Medición IEC 62353

## 13.1 Introducción

La norma IEC 62353 contempla distintos métodos para la medición de corrientes de fuga y otros parámetros de seguridad eléctrica.

La existencia de varios procedimientos responde a la necesidad de adaptarse a diferentes situaciones de trabajo, tipos de equipos y limitaciones operativas.

Aunque el objetivo final de todos ellos es evaluar la seguridad eléctrica del equipo, los principios de funcionamiento, las condiciones de ensayo y la precisión de los resultados pueden variar significativamente.

La correcta selección e interpretación del método empleado constituye una parte fundamental de la labor del técnico de electromedicina.

---

## 13.2 Método Directo

El método directo se considera el procedimiento de referencia dentro de la IEC 62353.

Durante el ensayo, el equipo bajo prueba se alimenta a través del propio analizador de seguridad eléctrica, que incorpora internamente los circuitos de medida necesarios para cuantificar las corrientes de fuga.

De esta forma, toda la energía suministrada al equipo circula a través del analizador.

### Características principales

- El equipo recibe alimentación desde el analizador.
    
- La corriente de fuga se mide directamente.
    
- No requiere cálculos indirectos.
    
- Proporciona la mayor precisión de medida.
    

### Ventajas

- Elevada precisión.
    
- Menor influencia de factores externos.
    
- Método de referencia de la norma.
    
- Resultados fácilmente comparables.
    

### Inconvenientes

- Algunos equipos no funcionan correctamente alimentados desde el analizador.
    
- Puede resultar incompatible con determinados sistemas electrónicos modernos.
    
- No siempre es viable en equipos de gran potencia.
    

### Aplicaciones recomendadas

- Verificaciones periódicas.
    
- Equipos de complejidad moderada.
    
- Ensayos donde se requiera máxima precisión.
    

---

## 13.3 Método Diferencial

El método diferencial mide la diferencia entre las corrientes que circulan por los conductores activos de alimentación.

En condiciones normales, la suma vectorial de las corrientes debería ser prácticamente nula.

Cualquier diferencia indica la existencia de corriente que abandona el circuito previsto, generalmente en forma de corriente de fuga.

A diferencia del método directo, el equipo permanece conectado a la red eléctrica habitual.

### Características principales

- El equipo se alimenta desde su instalación normal.
    
- No requiere modificar el entorno de trabajo.
    
- Permite ensayar equipos complejos en condiciones reales.
    

### Ventajas

- Muy versátil.
    
- Adecuado para equipos electrónicos modernos.
    
- Permite ensayos en condiciones de funcionamiento reales.
    
- Especialmente útil en equipos de gran potencia.
    

### Inconvenientes

- Mayor sensibilidad a perturbaciones externas.
    
- Puede verse afectado por otros equipos conectados.
    
- Requiere interpretar correctamente el contexto de medida.
    

### Aplicaciones recomendadas

- Equipos con filtros EMI complejos.
    
- Sistemas informáticos médicos.
    
- Equipos de imagen.
    
- Equipos cuyo funcionamiento se altera con el método directo.
    

---

## 13.4 Método Alternativo

El método alternativo fue desarrollado para situaciones en las que no resulta posible realizar una medida directa de corrientes de fuga.

En este procedimiento, el analizador aplica una tensión de ensayo y evalúa el estado del aislamiento mediante cálculos indirectos.

No se trata de una medida real de corriente de fuga durante funcionamiento normal, sino de una estimación obtenida a partir de las características eléctricas del equipo.

### Características principales

- El equipo puede permanecer apagado.
    
- No requiere funcionamiento completo.
    
- Evalúa el aislamiento de forma indirecta.
    

### Ventajas

- Rapidez.
    
- Aplicable a equipos que no pueden energizarse.
    
- Útil en determinadas verificaciones preliminares.
    

### Inconvenientes

- Menor representatividad respecto al funcionamiento real.
    
- No sustituye completamente a una medida funcional de fuga.
    
- Puede no detectar determinados defectos dependientes del funcionamiento.
    

### Aplicaciones recomendadas

- Equipos averiados.
    
- Comprobaciones preliminares.
    
- Situaciones donde otros métodos no sean posibles.
    

---

## 13.5 Selección del Método Adecuado

La elección del método debe realizarse considerando:

- Tipo de equipo.
    
- Tecnología utilizada.
    
- Condiciones de ensayo.
    
- Recomendaciones del fabricante.
    
- Disponibilidad del equipo para funcionar durante la prueba.
    

Como criterio general:

|Situación|Método recomendado|
|---|---|
|Verificación estándar|Directo|
|Equipos complejos o sensibles|Diferencial|
|Equipo no operativo|Alternativo|

No existe un método universalmente válido para todas las situaciones.

La capacidad del técnico para seleccionar correctamente el procedimiento constituye una parte esencial de la evaluación.

---

## 13.6 Comparación Práctica

Desde un punto de vista operativo, los tres métodos pueden considerarse complementarios.

El método directo proporciona la referencia más precisa.

El método diferencial ofrece una excelente aproximación en condiciones reales de funcionamiento.

El método alternativo permite obtener información útil cuando los anteriores no pueden aplicarse.

La elección no debe basarse únicamente en la comodidad del procedimiento, sino en su adecuación a las características del equipo evaluado.

---

## 13.7 Errores Frecuentes

Entre los errores más habituales destacan:

- Comparar resultados obtenidos mediante métodos diferentes.
    
- Aplicar siempre el mismo método independientemente del equipo.
    
- Interpretar el método alternativo como equivalente al directo.
    
- Ignorar las recomendaciones del fabricante.
    
- No documentar el método utilizado en el informe técnico.
    

La trazabilidad del procedimiento empleado resulta tan importante como el propio valor medido.

---

## 13.8 Aplicación Práctica para el Técnico de Electromedicina

En la práctica hospitalaria actual, el método diferencial ha ganado protagonismo debido a la creciente complejidad electrónica de los equipos médicos.

Muchos equipos modernos incorporan:

- Fuentes de alimentación conmutadas.
    
- Sistemas informáticos.
    
- Filtros EMI avanzados.
    
- Electrónica digital sensible.
    

Estas características hacen que, en determinadas situaciones, el método diferencial proporcione resultados más representativos del comportamiento real del equipo.

No obstante, el técnico debe conocer y comprender los tres procedimientos para seleccionar en cada caso el más adecuado.

---

## 13.9 Conclusiones

La IEC 62353 contempla distintos métodos de medición con el objetivo de adaptarse a las características de los equipos electromédicos modernos.

La correcta comprensión de sus principios, limitaciones y aplicaciones permite obtener resultados fiables y realizar una evaluación técnica más rigurosa de la seguridad eléctrica.

La selección adecuada del método de ensayo constituye una parte esencial del proceso de verificación y debe formar parte del criterio profesional del técnico responsable.

# Revisar a partir de aquí para completar lo anterior

## Inspección Visual y Resistencia de Tierra

Antes de realizar cualquier ensayo eléctrico, se lleva a cabo una inspección visual para detectar daños, desgastes en el equipo o en sus cables o cualquier deterioro que pueda afectar la integridad del dispositivo. Con una inspección detallada, se garantiza que el equipo cumple con los estándares de calidad y seguridad necesarios.

Posteriormente, se evalúa la Prueba de Resistencia de Tierra de Protección, la cual es fundamental para asegurar que el sistema de puesta a tierra funcione de manera óptima. Durante esta prueba se conecta un analizador de seguridad eléctrica al equipo médico para inyectar una corriente de prueba de 200 mA en la conexión a tierra. Se mide la caída de tensión generada en el trayecto y, aplicando la Ley de Ohm, se calcula la resistencia de tierra. Este proceso se efectúa en condiciones controladas para no afectar el funcionamiento del equipo.

En equipos con cable de alimentación desmontable (de hasta 3 metros), **IEC 62353** establece un límite máximo de 100 mΩ. Para dispositivos de Clase I que incluyen cable de alimentación de hasta 3 metros, el límite es de 300 mΩ.

![Resistencia de Tierra de Protección de equipos con cable de alimentación desmontables.](https://biomedex.mx/wp-content/uploads/2025/02/image-300x196.png)

Imagen 1. Prueba de Resistencia de Tierra de Protección de equipos con cable de alimentación desmontables.

Si la resistencia medida es igual o inferior, el equipo cumple con el límite máximo permitido para equipos según **IEC 62353**. Por otra parte, si el valor supera los límites, se debe revisar la integridad de la conexión a tierra y realizar las acciones correctivas necesarias, ya que un valor mayor podría comprometer la seguridad eléctrica del equipo.

## Pruebas de Corriente de Fuga

La medición de la corriente de fuga es fundamental para comprobar que las corrientes no funcionales se mantengan dentro de límites seguros, minimizando el riesgo para pacientes y operadores. La norma distingue dos tipos de pruebas de corriente de fuga:

### Corriente de Fuga del Equipo

**La Prueba de la Corriente de Fuga del Equipo** verifica la fuga total que se origina desde la fuente de alimentación hacia la carcasa y otros componentes accesibles del equipo, evaluando la protección del dispositivo.

De los tres métodos que establece la norma, el método directo es el más empleado por su facilidad de aplicación y precisión. En este método, se conecta el analizador de seguridad eléctrica de forma que se mida de forma directa el valor RMS de la corriente que se devía del camino normal. Es necesaria la interrupción temporal de la conexión a tierra del equipo y se inyecta una corriente de prueba. Se utiliza la Ley de Ohm para calcular la corriente de fuga a partir de la caída de tensión y una resistencia de 1kΩ (ya integrada en el analizador).

![Corriente de fuga del equipo por Método Directo](https://biomedex.mx/wp-content/uploads/2025/02/image-2-1024x307.png)

Imagen 2. Prueba de la Corriente de fuga del equipo por Método Directo

La prueba se realiza en ambas polaridades de la alimentación, garantizando una medición precisa y reproducible. Los límites máximos son:

- Para equipos de **Clase I**, el límite máximo de corriente de fuga es de **500 µA**.
- Para equipos de **Clase II**, el límite máximo permitido es de **100 µA**.

Superar estos límites puede indicar un deterioro en el aislamiento o en la conexión a tierra, lo que requiere acciones correctivas inmediatas.

### Corriente de Fuga de Partes Aplicadas

**La Prueba de Fuga de Partes Aplicadas** se centra en evaluar la seguridad de las partes del equipo que tienen contacto directo con el paciente (aplicadas), asegurando que la corriente de fuga en estas zonas se mantenga en niveles seguros.

Al igual que en la prueba de corriente de fuga del equipo, se utiliza el método directo para las partes aplicadas. En este caso, el medidor se conecta directamente a las partes aplicadas que, durante la prueba, se dejan flotantes (sin conexión a tierra). Esto permite simular las peores condiciones de aislamiento, midiendo directamente la corriente de fuga que podría circular hacia el paciente. La medición se realiza en condiciones de prueba controladas, inyectando una corriente de prueba y midiendo la caída de tensión para calcular la corriente a través de la Ley de Ohm utilizando el mismo valor de resistencia de 1 kΩ.

![Corriente de fuga de parte aplicada por Método Directo](https://biomedex.mx/wp-content/uploads/2025/02/image-3-1024x288.png)

Imagen 3. Prueba de Corriente de fuga de parte aplicada por Método Directo

Los límites máximos de esta prueba son:

- Para equipos de **Clase I** y II con partes aplicadas de Tipo BF, el límite máximo permitido es de **5000 µA**
- Para equipos de **Clase I** y II con partes aplicadas de Tipo CF, el límite máximo permitido es de **50 µA**.

Estos límites aseguran que la exposición del paciente a corrientes de fuga sea mínima, garantizando un alto nivel de seguridad.



stoy de acuerdo. De todos los capítulos que llevamos, el **13 es probablemente el más importante para un técnico de campo**, porque es donde se pasa de "sé medir" a "sé qué estoy midiendo y por qué".

Y además ahora mismo está demasiado descriptivo. Explica los métodos, pero no los hace "visuales".

Yo ampliaría bastante:

### 13.2 Método Directo

Añadiría un esquema simple:

```
RED │ │ ▼ANALIZADOR │ │ ▼EQUIPO BAJO PRUEBALa fuga es medida directamente por el analizador.
```

Y una explicación práctica:

> El analizador se convierte temporalmente en la fuente de alimentación del equipo. Toda la corriente consumida por el equipo pasa a través de los circuitos internos de medida del analizador.

También incluiría:

- Qué ocurre con fuentes conmutadas modernas.
- Por qué algunos equipos se niegan a arrancar.
- Equipos que dan resultados inconsistentes.

---

### 13.3 Método Diferencial

Aquí sí metería un dibujo más elaborado:

```
        ┌─────────────┐L ─────▶│             │─────▶ Equipo        │ Sensor ΔI   │N ─────▶│             │─────▶        └─────────────┘Si la corriente que entraes distinta de la que sale,la diferencia es una fuga.
```

Y una analogía muy sencilla:

> Es exactamente el mismo principio utilizado por un interruptor diferencial de una instalación eléctrica.

Eso cualquier técnico lo entiende inmediatamente.

Además explicaría:

```
Corriente que entra = 1,000 ACorriente que sale = 0,998 AFuga = 0,002 A     = 2 mA
```

Visualmente queda muy claro.

---

### 13.4 Método Alternativo

Aquí suele haber bastante confusión.

Yo reforzaría algo así:

> El método alternativo NO mide una corriente de fuga real durante el funcionamiento del equipo.

Porque es un error muy frecuente.

Incluso pondría un cuadro:

|Método|Mide fuga real|
|---|---|
|Directo|Sí|
|Diferencial|Sí|
|Alternativo|No|

Eso ayuda muchísimo.

---

### 13.5 Selección del método adecuado

Aquí haría un árbol de decisión:

```
¿El equipo funciona?│├─ NO│   └─ Método alternativo│└─ SÍ    │    ├─ Funciona correctamente    │   alimentado por analizador?    │    ├─ SÍ    │   └─ Método directo    │    └─ NO        └─ Método diferencial
```

Muy sencillo.

---

### Imágenes que buscaría

No buscaría imágenes complejas.

Buscaría:

1. Esquema de método directo.
2. Esquema de método diferencial.
3. Esquema de método alternativo.
4. Imagen de un diferencial doméstico (para explicar el principio).
5. Capturas reales de Rigel y Fluke mostrando los tres métodos.

Estas últimas, sinceramente, valen más que cualquier dibujo.

---

Además, una cosa que me gustaría añadir en este capítulo cuando lo revisemos en profundidad:

### 13.X Limitaciones de cada método

Porque en la práctica la pregunta no es:

> ¿Cuál es mejor?

Sino:

> ¿Cuál me está diciendo la verdad en esta situación concreta?

Y ahí entran:

- Fuentes conmutadas.
- Filtros EMI.
- Equipos informáticos.
- Monitores.
- Ecógrafos.
- Torres de endoscopia.

Ese apartado puede acabar siendo uno de los más útiles de todo el manual para un técnico de electromedicina. 🔧⚡📟📚

Y sí, voy buscando esquemas simples y didácticos para estos tres métodos porque aquí una imagen bien hecha ahorra dos páginas de explicación.
He encontrado material bastante útil, pero te diría que **no uses imágenes complejas sacadas de la norma**. Para el manual van a funcionar mucho mejor esquemas propios, sencillos y limpios.

Lo más interesante que he encontrado es:

- La guía práctica de Rigel incluye esquemas de los métodos directo, diferencial y alternativo.
- Fluke tiene una explicación bastante clara de cuándo usar cada método.
- Un artículo de 24x7 explica muy bien ventajas e inconvenientes del método diferencial y alternativo.

---

### Mi recomendación

No copiar ninguna figura.

Crear 4 figuras propias para el manual.

---

## Figura 13-1 Método Directo

```
      RED       │       ▼┌─────────────┐│ ANALIZADOR  │└──────┬──────┘       │       ▼┌─────────────┐│  EQUIPO     │└─────────────┘La corriente de fuga es medidadirectamente por el analizador.
```

Pie:

> En el método directo el equipo es alimentado a través del analizador, permitiendo medir directamente la corriente de fuga mediante el circuito de medida interno.

---

## Figura 13-2 Método Diferencial

```
          Corriente entradaL ───────────────────────►          Corriente salidaN ◄───────────────────────      SENSOR DIFERENCIALEntrada - Salida = Fuga
```

Pie:

> El método diferencial mide el desequilibrio entre la corriente que entra y la que sale del equipo.

Aquí añadiría una nota:

> El principio de funcionamiento es análogo al utilizado por los interruptores diferenciales de las instalaciones eléctricas.

---

## Figura 13-3 Método Alternativo

```
      ANALIZADOR      250 V CA          │          ▼ ┌────────────────┐ │    EQUIPO      │ └────────────────┘Evaluación indirectadel aislamiento
```

Pie:

> El método alternativo no mide una corriente de fuga real durante el funcionamiento normal del equipo, sino que estima el estado del aislamiento aplicando una tensión de ensayo limitada.

---

## Figura 13-4 Selección del Método

```
¿El equipo funciona?        │   ┌────┴────┐   │         │  NO        SI   │         │Altern.   ¿Funciona           con el         analizador?           │      ┌────┴────┐      │         │     SI        NO      │         │ Directo   Diferencial
```

Esta figura sola probablemente evita media página de explicaciones.

---

### Y una ampliación que sí metería en el texto

Un apartado nuevo:

```
13.X Comparación práctica de resultados
```

Con una tabla:

|Aspecto|Directo|Diferencial|Alternativo|
|---|---|---|---|
|Mide fuga real|Sí|Sí|No|
|Precisión|Alta|Media-Alta|Media|
|Equipo alimentado normalmente|No|Sí|No|
|Influencia EMI|Baja|Media|Baja|
|Equipos informáticos|Puede dar problemas|Muy adecuado|Limitado|
|Tendencias históricas|Muy útil|Muy útil|Útil|

Y otro cuadro:

> **Importante:** Los resultados obtenidos mediante distintos métodos no deben compararse directamente entre sí sin tener en cuenta el procedimiento empleado. La trazabilidad del método utilizado forma parte esencial del resultado obtenido.

---

Mi impresión es que este capítulo puede acabar siendo de los más largos del manual porque es donde realmente se aprende a interpretar lo que hace un Fluke o un Rigel cuando pulsas "Start". Y eso tiene muchísimo más valor para un técnico que memorizar un límite de microamperios.
