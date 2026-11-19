---
title: "Secuencia de preparación: equipo actual, portátil y sede"
type: state
status: active
created: 2026-11-19
updated: 2026-11-19
sources:
  - "../../01_gobierno_y_decisiones/DECISION-SECUENCIA-EQUIPO-PORTATIL-SEDE-2026-11-19.md"
  - "../../02_planes_y_arquitectura/PLAN-CIERRE-FASE-EQUIPO-ACTUAL-2026-11-19.md"
tags: [qontrolmed, sesion, implantacion, continuidad]
review_after: 2026-11-26
---

# Sesión 2026-11-19: secuencia física de preparación

## Objetivo y decisión

El propietario ordenó terminar todo lo posible desde el equipo actual, pasar
después al portátil y finalmente trabajar en sede. Cada plan mostrará solo el
pendiente de la fase activa y, al cerrarla, indicará únicamente el paso a la
siguiente.

## Trabajo realizado

- registrada la decisión transversal;
- creado el plan autorizado de cierre desde el equipo actual;
- actualizados `AGENTS.md`, relevo y selección curada;
- sincronizados plan, diario, maestro, reglas y relevo de Servidor_MM;
- fijada como continuación inmediata la revisión SFTPGo y subida/bajada desde
  la carpeta de Servidor_MM.

Un fallo transitorio de entrada/salida de `H:` interrumpió el primer intento.
Tras reconectar la unidad se verificaron en lectura los documentos principales
y se aplicaron los cambios mediante parches. No se conectó al servidor ni se
modificaron servicios, red, cuentas o datos.

## Continuación exacta

Cambiar el punto de trabajo a la carpeta de Servidor_MM y ejecutar la
revalidación de solo lectura indicada en su plan vigente. La fase activa sigue
siendo `equipo actual`.
