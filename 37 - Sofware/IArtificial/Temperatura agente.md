---
tags:
  - desarrollo
  - IA
Creado: 2026-06-16
Relacionado:
---

### Ya no tan importante.

La **temperatura** es un parámetro que controla cuánto "riesgo" toma el modelo al elegir la siguiente palabra.

- **Temperatura = 0** → respuestas muy deterministas. Si haces la misma pregunta varias veces, la respuesta será muy parecida.
- **Temperatura = 1** → más variedad y creatividad.
- **Temperatura > 1** → aún más creatividad, pero también más posibilidad de errores o respuestas extrañas.

Ejemplos prácticos:

|Tarea|Temperatura recomendada|
|---|---|
|Código|0 - 0.2|
|SQL|0 - 0.2|
|Análisis técnico|0.1 - 0.3|
|Documentación|0.3 - 0.5|
|Lluvia de ideas|0.7 - 1|
|Escritura creativa|0.8 - 1.2|

En **Codex** o en agentes que generan código suele usarse una temperatura baja porque:

- Produce código más consistente.
- Sigue mejor las instrucciones.
- Introduce menos cambios inesperados.

Por ejemplo, si le dices:

> "Haz un CRUD de proveedores en Tkinter"

con temperatura 0.1 probablemente siempre te proponga una estructura muy similar.

Con temperatura 0.9 podría:

- cambiar nombres de clases,
- proponer otra arquitectura,
- añadir funcionalidades no pedidas,
- probar enfoques distintos.

Ahora bien, en los modelos actuales la temperatura ya no es tan determinante como hace unos años. El modelo sigue mucho más las instrucciones y el contexto que la temperatura pura.

Para tu forma de trabajar (proyectos de Compras, Quirófanos y Preventivos) yo usaría:

- **0.1 - 0.3** para programar.
- **0.5** para diseño de arquitectura.
- **0.8** para brainstorming de nuevas funcionalidades.

De hecho, muchas veces cuando notas que Codex "se ha puesto creativo" modificando cosas que no le has pedido, el efecto se parece al de una temperatura alta, aunque también puede deberse al contexto que le has dado o al modo de agente que estés usando. 😄