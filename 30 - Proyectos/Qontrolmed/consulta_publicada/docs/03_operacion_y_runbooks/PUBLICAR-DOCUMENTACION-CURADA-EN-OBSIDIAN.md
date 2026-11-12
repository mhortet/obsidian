---
title: "Publicar documentación curada de Qontrolmed en Obsidian"
type: process
status: active
created: 2026-11-12
updated: 2026-11-12
sources:
  - "../../../scripts/documentacion/seleccion_obsidian.json"
  - "../../../scripts/documentacion/publicar_obsidian.py"
tags: [qontrolmed, documentacion, obsidian]
review_after: 2027-02-12
---

# Publicar documentación curada de Qontrolmed en Obsidian

## Finalidad y fuente de verdad

La documentación oficial permanece en `D:\trabajo\Proyectos\maxgesth`. La
carpeta `H:\02.Trabajo\obsidian\30 - Proyectos\Qontrolmed\consulta_publicada`
es una copia derivada de solo consulta para seguimiento, aprendizaje y
reutilización futura.

La publicación es siempre unidireccional: **Qontrolmed → Obsidian**. Una
edición hecha en la copia no se importa ni se considera una modificación del
proyecto.

## Selección

El manifiesto `scripts/documentacion/seleccion_obsidian.json` contiene una
lista explícita. Incluye:

- relevo, estados y diarios recientes con valor formativo;
- decisiones de gobierno reutilizables;
- arquitectura y especificaciones con valor de consulta;
- runbooks generales de operación y seguridad;
- guía didáctica, manual y capturas necesarias para leerlo.

Quedan fuera por defecto evidencias técnicas, inventarios de auditoría,
histórico sustituido, backlog, planes puntuales de ejecución y datos de
runtime. Un documento nuevo solo se publica si durante su revisión se añade
expresamente al manifiesto.

## Comandos

Vista previa sin modificar Obsidian:

```powershell
python scripts/documentacion/publicar_obsidian.py --comprobar
```

Publicación al destino predeterminado:

```powershell
python scripts/documentacion/publicar_obsidian.py
```

El comando compara SHA-256 y solo vuelve a copiar los seleccionados cuyo
contenido haya cambiado. También actualiza `INDICE.md` y un estado técnico con
la revisión Git de procedencia. No borra archivos de Obsidian.

## Cierre de sesión

Al final de cada sesión técnica relevante:

1. revisar si se creó un documento útil para seguimiento, aprendizaje o
   consulta futura y, en ese caso, añadir su ruta al manifiesto;
2. ejecutar primero `--comprobar`;
3. ejecutar la publicación si existen cambios pendientes;
4. registrar el resultado en la nota de sesión.

Los errores de destino, rutas ausentes o selección sensible deben detener la
publicación; no se sustituyen por una copia manual silenciosa.

## Reversión

La publicación no modifica el origen. Ante un error, se corrige el manifiesto
o el documento en Qontrolmed y se vuelve a publicar. La retirada de material
ya copiado se hará mediante una revisión explícita del destino; el script no
elimina automáticamente contenido de Obsidian.
