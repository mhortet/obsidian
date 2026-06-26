---
tags:
  - desarrollo
  - IA
Creado: 2026-06-26
Autor:
  - "@Mouredev"
Relacionado:
---

Para abordar la complejidad técnica sin desbordar el contexto del modelo, debemos aplicar el principio de separación de preocupaciones (Separation of Concerns) mediante ecosistemas multiagente. 
Transicionar de un agente generalista a una red de agentes especializados permite manejar tareas concurrentes con mayor precisión. 

## Subagente 
Un subagente es un agente "hijo" que el agente principal lanza para una tarea concreta. La clave: corre en su propia ventana de contexto, con su propio rol y sus propios permisos, y al terminar devuelve solo un resumen al agente principal. 

## Objetivos de los Subagentes
**Aislar contexto:** El subagente hace el trabajo "duro" (leer cuarenta archivos, ejecutar tests, rebuscar en el código) y te devuelve solo la conclusión. El agente principal no se llena de basura. 

**Especializar con permisos mínimos:** Cada subagente puede tener un rol concreto y restringido. Un subagente para investigar, otro para auditar, otro para implementar... 

## El flujo multiagente 
	● Coordinador: No escribe código. Lee la tarea, la divide y reparte el trabajo. Decide qué hace cada subagente y en qué orden. 
	● Implementador: Recibe una subtarea concreta y la ejecuta (escribe el código). Puede haber varios en paralelo, cada uno con su parte. 
	● Verificador: Revisa lo que produjo el implementador. Corre tests, busca fallos, comprueba que cumple lo pedido.

![[b5pin4yl.png]]