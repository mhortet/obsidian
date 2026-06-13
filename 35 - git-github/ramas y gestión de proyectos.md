---
tags:
  - software
  - git
Creado: 2026-06-06
Autor: Notebooklm
Relacionado:
---

## Alcance
entender ramas y trabajo con ellas
## Descripción

Paso 5: Ramificaciones y Gestión de Proyectos

Un desarrollo profesional nunca se hace directamente en la rama principal (`main` o `master`).

1. **Crear ramas:** `git branch <nombre-rama>`.
2. **Cambiar de rama:** `git switch <nombre-rama>` o `git checkout <nombre-rama>`.
3. **Fusionar:** `git merge <rama>` para integrar el trabajo de una rama en la actual.
4. **GitFlow:** Es un flujo de trabajo estructurado que usa ramas específicas para funciones (`feature`), correcciones (`hotfix`) y lanzamientos (`release`).

Como experiencia personal con trabajo una sola persona en el proyecto, trabajar en main hasta versión más o menos estable,
Cambiar a rama para hacer cambios sustanciales o pruebas de código que no sabemos el resultado, de esta forma tenemos dos soluciones del mismo problema y podemos elegir.

Las ramas son líneas de tiempo paralelas que te permiten desarrollar nuevas funciones o corregir errores sin afectar el código principal. Por defecto, todo proyecto empieza con una rama llamada `main` o `master`.

El flujo básico funciona así:

- **Crear una rama:** Usas `git branch <nombre>` para iniciar un camino nuevo.
- **Cambiarse a ella:** Usas `git switch <nombre>` (o `checkout`) para empezar a trabajar en ese espacio.
- **Fusionar:** Cuando terminas tu tarea, vuelves a la rama principal y usas `git merge <nombre>` para integrar tus cambios.

Esto es fundamental para trabajar en equipo o probar ideas arriesgadas sin "romper" la versión que ya funciona



