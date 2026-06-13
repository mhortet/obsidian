---
tags:
  - software
  - git
Creado: 2026-06-06
Autor:
Relacionado:
---
## Alcance
Introducción a git
## Descripción

Esta guía ha sido diseñada para llevarte desde el desconocimiento total hasta un nivel operativo profesional, utilizando las mejores prácticas de la industria y las herramientas que todo desarrollador experto utiliza a diario.

Paso 1: Conceptos Fundamentales

Antes de tocar el teclado, debes entender qué estamos haciendo. **Git** es un sistema de **control de versiones distribuido**. Esto significa que registra cada cambio en tu código, permitiéndote saber quién hizo qué y cuándo, además de poder volver a estados anteriores si algo sale mal. Al ser "distribuido", cada desarrollador tiene una copia completa del historial en su propia máquina.

**GitHub**, por otro lado, no es Git. Es una plataforma en la nube que aloja tus repositorios de Git, permitiendo la colaboración global, la gestión de tareas y la publicación de proyectos.

Conceptos clave que debes dominar:

- **Repositorio (Repo):** La carpeta del proyecto bajo control de versiones.
- **Commit:** Una "fotografía" o instantánea de tu código en un momento dado.
- **Rama (Branch):** Una línea de tiempo paralela para desarrollar funciones sin afectar el código principal.
- **Área de Ensayo (Staging Area):** El lugar donde preparas los cambios antes de confirmarlos (hacer el commit).

Paso 2: Primeros Pasos (Instalación y Configuración)

Un experto siempre empieza configurando su entorno.

1. **Instalación:** Descarga Git desde su sitio oficial (`git-scm.com`). Si usas Linux o Mac, es probable que ya lo tengas, aunque conviene actualizarlo.
2. **Configuración de Identidad:** Git necesita saber quién eres para firmar tus cambios. Ejecuta en tu terminal:
    - `git config --global user.name "Tu Nombre"`.
    - `git config --global user.email "tu@email.com"`.
3. **Autenticación con GitHub:** La forma más profesional de conectar tu máquina con GitHub es mediante **llaves SSH**, lo que evita escribir tu contraseña constantemente y añade una capa de seguridad.

