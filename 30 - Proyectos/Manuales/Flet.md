---
tags:
  - app
  - codigo
  - desarrollo
  - estructura
  - manuales
Creado: 2026-06-08
Autor:
  - M.Hortet
Relacionado:
---
## Alcance
Descripción del Flet dentro de la plantilla
## Descripción

###  Flet (Tecnología / Programación)

En el mundo de la programación, **Flet** es un popular framework o marco de trabajo de código abierto que permite a los desarrolladores crear aplicaciones web, móviles y de escritorio utilizando exclusivamente código **Python**.

- **Cómo funciona:** Está basado en _Flutter_ (el motor de interfaz gráfica de Google).
- **Ventajas:** Permite crear interfaces de usuario atractivas sin necesidad de tener conocimientos previos de lenguajes de diseño web o _frontend_ (como HTML, CSS o JavaScript).
- **Público:** Es muy utilizado por científicos de datos, ingenieros y principiantes que quieren construir herramientas visuales y funcionales sin tener que aprender múltiples lenguajes de programación

### Para lanzar la aplicacion desde consola:

		flet run --android main.py


Para este repo, la respuesta corta es: **no necesitas una extensión de VS Code específica para “conectar el móvil por USB”**.

Lo que sí te conviene instalar en VS Code es:
	- Python de Microsoft
	- PowerShell de Microsoft, porque el repo ya trae el script build_android_apk.ps1 (line 1)

Este proyecto es una app **Flet** y está fijado a flet 0.85.1 en pyproject.toml (line 7) y requirements.txt (line 6). Para lanzar en Android, lo importante no es una extensión, sino tener:

		- adb / Android SDK (platform-tools)
		- Java JDK 17
		- el móvil con Depuración USB activada

Si tu objetivo es **probar la app en el móvil**, tienes dos caminos:

1. **Desarrollo rápido**  
    Usa Flet y ejecuta desde el repo algo tipo flet run --android main.py o el flujo de Flet app en Android. En Flet, la vía habitual de prueba es la app oficial de Flet y red local; no suele depender de USB.
    
2. **Instalar APK en el móvil por cable**  
    Este repo ya trae el flujo preparado:  
    powershell -ExecutionPolicy Bypass -File .\scripts\build_android_apk.ps1  
    y luego instalas el .apk por adb.
    

La propia documentación del repo apunta a eso en README.md (line 42) y docs/android_local_build.md (line 1).

Fuentes oficiales Flet:

- flet build Android: [https://flet.dev/docs/publish/android/](https://flet.dev/docs/publish/android/)
- flet run: [https://flet.dev/docs/cli/flet-run/](https://flet.dev/docs/cli/flet-run/)
- testing en móvil: [https://flet.dev/docs/getting-started/testing-on-mobile/](https://flet.dev/docs/getting-started/testing-on-mobile/)
- dispositivos conectados: [https://flet.dev/docs/cli/flet-devices/](https://flet.dev/docs/cli/flet-devices/)
-  [(https://jpadillaa.hashnode.dev/pokemon-python-flet)]
-  [(https://flet.dev/docs/)]
-  [(https://www.youtube.com/watch?v=E3a7x9RgRGE),
-  [(https://jpadillaa.hashnode.dev/pokemon-python-flet)
-  [(https://medium.com/@andresortizcherrez/desarrollo-de-una-aplicaci%C3%B3n-desktop-con-flet-50f5d7c19756), [2](https://escuela.it/materias/frontend), [3](https://www.academia.edu/143423182/Resumen_de_Flet_Introducci%C3%B3n_al_Dise%C3%B1o_de_Aplicaciones_Multiplataforma_con_Flet_en_Python_a_trav%C3%A9s_del_IDE_PyCharm), [4](https://flet.dev/docs/), [5](https://www.youtube.com/watch?v=E3a7x9RgRGE)]
- 