---
tags:
  - desarrollo
  - codigo
  - estructura
  - IA
Creado: 2026-06-25
Relacionado:
---

## Y ahora viene la parte que creo que más te puede interesar

Yo empezaría a pensar en el repositorio como si fuera **un pequeño sistema operativo** para agentes.

No un conjunto de archivos.

Por ejemplo:

		Proyecto/
		
		01_Contexto/
		02_Arquitectura/
		03_Codigo/
		04_Test/
		05_Documentacion/
		06_Experimentos/
El número delante no es por estética.

Es porque cuando una IA explora un proyecto suele recorrer directorios y nombres. Un orden consistente reduce la ambigüedad.

Y en general:

		AI-LAB
		
		001_Codex
		002_MCP
		003_Agentes
		004_Subagentes
		005_Skills
		006_Context7
		007_Filesystem
		008_GitHub
		009_RAG
		010_Docker
		011_HomeAssistant
		012_Flet
		013_Python
	Dentro de cada uno:
		README.md
		NOTAS.md
		EJEMPLOS.md
		ERRORES.md
		CONCLUSIONES.md
¿Por qué?

Porque dentro de un año no vas a recordar:

> "¿Por qué descarté aquella forma de hacer un agente?"

Pero sí recordarás:

```
005_Skills/CONCLUSIONES.md
```

Y eso, vale muchísimo más que guardar veinte enlaces