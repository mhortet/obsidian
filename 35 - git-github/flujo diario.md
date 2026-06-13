---
tags:
  - software
  - git
Creado: 2026-06-06
Autor: Notebooklm
Relacionado:
---
## Alcance
Trabajo diario
## Descripción

Paso 3: Conocimiento Operativo (El Flujo Diario)

El flujo de trabajo estándar en tu máquina local sigue estos comandos:

1. **git init****:** Convierte una carpeta normal en un repositorio de Git.
2. **git status****:** Tu mejor amigo. Te dice qué archivos han cambiado y en qué estado están.
3. **git add <archivo>** **(o** **git add .** **para todo):** Pasa tus cambios al área de ensayo.
4. **git commit -m "mensaje descriptivo"****:** Guarda la fotografía definitiva en tu historial local.
5. **.gitignore****:** Crea este archivo para listar qué ficheros (como archivos temporales o secretos) **nunca** deben ser rastreados por Git.

Paso 4: Colaboración y Sincronización Remota

Para trabajar con otros o respaldar tu código en GitHub:

- **git clone <url>****:** Descarga un repositorio existente a tu máquina.
- **git remote add origin <url>****:** Conecta tu repositorio local con uno nuevo en GitHub.
- **git push origin <rama>****:** Sube tus commits locales a GitHub.
- **git pull****:** Descarga e integra los cambios que otros han subido al servidor.
- **Forks y Pull Requests (PR):** En proyectos ajenos, haces un "Fork" (copia a tu cuenta), trabajas en tus cambios y luego envías una "Pull Request" para que el dueño original integre tu código.

