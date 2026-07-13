---
tags:
  - app
  - aprendizaje
  - desarrollo
  - github
Creado: 2026-07-12
Autor:
Relacionado:
---
## Resumen

## Descripción



# Android remote build
[[maxgesth_port]]

Guia corta para generar un APK de prueba desde GitHub Actions.

La via recomendada para pruebas habituales es la build local en Windows:
[docs/android_local_build.md](android_local_build.md). Usa GitHub Actions como
respaldo si la build local falla, si quieres comprobar un entorno limpio o si
necesitas un artifact descargable desde GitHub.

## Objetivo

Construir la app `maxgesth field work` en remoto y descargar un APK instalable
en Android cuando no convenga usar la build local.

## Estado operativo actual

La build remota es opcional para el circuito normal de pruebas si ya existe un
APK local generado correctamente. Si GitHub Actions no tiene cuota disponible,
no interpretar la ausencia de artifact remoto como fallo tecnico del workflow:
usar la build local y dejar la validacion remota explicitamente pendiente solo
si hace falta evidencia en GitHub.

## Ejecutar build remoto

1. Sube los cambios a GitHub.
2. En GitHub, entra en `Actions`.
3. Selecciona el workflow `Android APK`.
4. Pulsa `Run workflow`.
5. Espera a que termine el job `Build debug APK`.
6. Descarga el artifact `maxgesth-field-work-apk`.

El workflow ejecuta:

```bash
uv run flet build apk --yes --verbose
```

La salida esperada queda en:

```txt
build/apk
```

## Instalar en Android

Para una prueba manual, descarga el APK en el dispositivo y acepta la instalacion desde origenes permitidos.

Si usas ADB:

```bash
adb install path/to/app.apk
```

## Configuracion del paquete

La configuracion base vive en `pyproject.toml`:

- producto: `maxgesth field work`
- bundle id: `com.maxgesth.fieldwork`
- version: `0.1.0`
- Flet: `0.85.1`
- Android min SDK: `24`
- Android target SDK: `35`

## Notas

- Este APK es para pruebas internas, no para publicacion en Play Store.
- Para Play Store hara falta generar `aab` y firmar con keystore.
- La app usa SQLite local y selectores de archivo para importar/exportar JSON.
