---
tags:
  - app
  - codigo
  - desarrollo
Creado:
Autor:
Relacionado:
---
## Resumen

## Descripción


# Android local build
[[maxgesth_port]]

Guia corta para volver a compilar el APK en Windows sin recordar pasos sueltos.

Esta es la via recomendada para las pruebas habituales de campo. GitHub Actions
queda como respaldo cuando la build local falle, se necesite comprobar un
entorno limpio o haya que compartir un artifact descargable.

## Comando recomendado

Desde la raiz del repo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_android_apk.ps1
```

Ese script hace tres cosas:

- fuerza UTF-8 y desactiva la salida problematica de `rich` en Windows
- ejecuta las validaciones minimas antes de empaquetar
- lanza `flet build apk --yes --verbose`

## Si quieres saltarte las validaciones

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_android_apk.ps1 -SkipChecks
```

Usalo solo cuando ya hayas validado antes y quieras repetir la build.

## Si solo quieres revisar que todo esta listo

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build_android_apk.ps1 -ChecksOnly
```

Hace las comprobaciones previas y termina sin arrancar la compilacion Android.

## Que valida antes de compilar

- `python -m compileall -q main.py src`
- `python test_import.py`
- `python test_report_service.py`

## Senales normales durante la build

- La primera build puede tardar varios minutos.
- Si nunca se ha compilado localmente, Flet puede instalar o actualizar JDK,
  Android SDK, `cmdline-tools`, plataformas Android, `build-tools`, NDK, CMake
  y dependencias de Gradle.
- Pueden aparecer avisos largos de Kotlin/Gradle sobre caches incrementales o
  paquetes Android mientras continua la compilacion; si al final aparece
  `Successfully built your .apk`, la build es valida.
- Si hay consumo de CPU o red, normalmente el proceso sigue vivo aunque parezca lento.

## Salida esperada

Si todo va bien, el APK queda en:

```txt
build/apk/maxgesth-field-work.apk
```

Ruta local absoluta habitual del ultimo APK generado:

```txt
D:\trabajo\Proyectos\maxgesth_port\build\apk\maxgesth-field-work.apk
```

## Si falla muy pronto

Revisa primero:

- que `python` este en `PATH`
- que `flet` este instalado
- que estas ejecutando el comando desde este repo

Si `flet` no aparece en PATH, una instalacion habitual seria:

```powershell
pip install -r requirements.txt
pip install flet==0.85.1
```

## Si la build local falla

1. Repite primero con el mismo script para descartar un fallo puntual de cache
   o descarga de toolchain.
2. Si sigue fallando por entorno local, lanza el respaldo remoto documentado en
   [docs/android_remote_build.md](android_remote_build.md).
3. Si GitHub Actions no tiene cuota o falla por infraestructura, conserva como
   evidencia los tests locales y deja la validacion APK remota pendiente.
