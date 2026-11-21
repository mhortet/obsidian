---
title: "Preparación de la fase portátil"
type: state
status: prepared
created: 2026-11-20
updated: 2026-11-20
sources:
  - "docs/02_planes_y_arquitectura/PLAN-FASE-PORTATIL-2026-11-20.md"
tags: [qontrolmed, sesion, portatil, rc]
review_after: 2026-11-21
---

# Sesión 2026-11-20: preparación de la fase portátil
[[masgesth]]

## Objetivo y motivo

Preparar la siguiente fase física sin iniciar todavía trabajo de sede y aclarar
qué material debe trasladarse al portátil.

## Decisiones

- No copiar completos `maxgesth` ni `Servidor_MM`.
- Para preparar o ensayar la RC basta el kit mínimo con ZIP, hash y lectura.
- Codex ya está instalado en el portátil; no necesita reinstalación.
- Solo se clonará Qontrolmed si se decide expresamente convertir el portátil en
  máquina de desarrollo. En ese caso se preferirá un clon limpio después de
  resolver la publicación de la rama/tag, nunca una copia indiscriminada del
  directorio actual.
- Servidor_MM no es necesario para la fase portátil sin infraestructura.

## Material preparado

`dist_rc\KIT-PORTATIL-QONTROLMED-0.1.0-rc.1\` con:

- ZIP de la RC candidata local;
- hash SHA-256 lateral;
- instrucciones breves sin secretos;
- manifiesto SHA-256 de once archivos;
- contexto mínimo de solo consulta para Codex: instrucciones, relevo, plan y
  lecturas obligatorias de Qontrolmed, más instrucciones y relevo coordinado
  de Servidor_MM.

## Límites

No se ha ejecutado nada en el portátil, no se ha transferido el kit, no se ha
publicado el tag o el ZIP y no se ha iniciado sede.

## Siguiente paso

Abrir la sesión desde el portátil, leer instrucciones y relevo, inventariar el
estado real en modo de solo lectura y verificar el kit antes de decidir el rol
del equipo.
