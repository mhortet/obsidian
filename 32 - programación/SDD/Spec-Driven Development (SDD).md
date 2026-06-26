---
tags:
  - desarrollo
  - IA
Creado: 2026-06-26
Autor:
  - "@Mouredev"
Relacionado:
---
## Resumen

## Descripción
## ¿Qué es? 
El Spec-Driven Development (SDD) no es solo una metodología, es una estrategia de mitigación de riesgos frente al indeterminismo de la IA. 
En un entorno profesional, la especificación técnica actúa como el "ancla de verdad" y la memoria persistente del proyecto. 
Al definir requerimientos técnicos precisos antes de la generación de código, transformamos la interacción con la IA de un ejercicio de "adivinación" a uno de implementación guiada, asegurando que el modelo opere dentro de un espacio de soluciones validado. 
El SDD es la metodología definitiva que devuelve el control al ingeniero. Desplaza el foco de la "escritura de código" hacia la "validación de la intención". 
En este flujo, el humano actúa como el Validador de Intentos, mientras que el código se convierte en un artefacto transitorio y derivado. 
**Consiste en dejar de pedirle al agente “hazme X” y esperar que acierte. Primero creas una especificación. La spec es el cerebro/contexto persistente.**

## El objetivo es reducir: 
	● Pérdida de contexto entre sesiones 
	● Cambios de rumbo invisibles 
	● Ambigüedad/Indeterminismo → La especificación sirve como el contrato técnico que garantiza que el output de la IA sea consistente a lo largo de diferentes sesiones de desarrollo 
	● Vibe coding de prueba/error → Se sustituye el ciclo ineficiente de prompts iterativos por una implementación precisa desde el primer intento. 
	● Deuda cognitiva → El ingeniero se libera de la carga de supervisar errores triviales, delegando la ejecución táctica a la IA bajo un marco de reglas estricto.

## El problema que resuelve 
● Sin SDD: Desarrollo rápido, pero se produce código que no siempre coincide con lo que buscas. Si las instrucciones son ambiguas, el resultado es ambiguo. 

● Con SDD: Escribes una especificación clara que define qué construir, y dejas que el agente la implemente. La spec actúa como un guardarraíl.

## El ciclo SDD 
1. Constitución (una vez por proyecto): las reglas generales. 
2. Specify: qué se va a construir (la feature), con criterios de aceptación. 
3. Plan: cómo se va a construir (enfoque técnico, archivos, datos). 
4. Tasks: el plan dividido en tareas pequeñas y verificables. 
5. Implement: el agente ejecuta las tareas, una a una. 
6. Verify: se valida contra los criterios de aceptación. Si falla, se ajusta


![[4vwdltfc.png]]

## Niveles de SDD 
● Spec-first: escribes la spec, generas el código una vez, y a partir de ahí editas el código directamente. La spec fue el punto de partida.

![[4ikggtx4.png]]


● Spec-anchored: 
la spec se mantiene viva: cada cambio importante pasa primero por actualizar la spec. Es el más recomendable para empezar.

![[fhblaclr.png]]


● Spec-as-source: la spec es lo único que editas; el código se regenera siempre desde ella. Experimental, todavía poco común.

![[qt3fkv2s.png]]


Los artefactos 
mi-proyecto/ 
├── spec/ (estructura base) 
│ ├── constitution/                             (puede ser un único archivo) 
│ │ ├── mission.md                              ← qué construimos y para quién 
│ │ ├── tech-stack.md                          ← tecnologías y convenciones 
│ │ └── roadmap.md                            ← orden de las features 
│ └── features/                                    (y para cada feature) 
│ ├── 001-tarea/                                 (puede ser un único archivo) 
│ │ ├── spec.md                                   ← qué hace esta feature y criterios de aceptación 
│ │ ├── plan.md                                   ← cómo se implementa 
│ │ └── tasks.md                                  ← checklist de tareas 
│ └── 002-tarea/ 
│ └── ... 
└── código/                                          ← el código que genera el agente



