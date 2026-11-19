---
title: "Secuencia de preparación: equipo actual, portátil y sede"
type: decision
status: approved
created: 2026-11-19
updated: 2026-11-19
sources:
  - "Comunicación del propietario de 2026-11-19"
  - "docs/02_planes_y_arquitectura/PLAN-P2X-PROVISION-PUESTOS-Y-CONEXION-SEDE-2026-11-18.md"
tags: [qontrolmed, servidor-mm, implantacion, fases, continuidad]
review_after: 2026-12-19
---

# Secuencia de preparación: equipo actual, portátil y sede

## Decisión

La preparación de la implantación se ejecutará en tres fases físicas y
consecutivas:

1. equipo actual de trabajo;
2. portátil que se llevará a la instalación;
3. sede del cliente.

No se iniciará una fase mientras quede trabajo ejecutable y necesario de la
anterior. Qontrolmed y Servidor_MM conservarán sus fuentes de verdad separadas,
pero sus relevos señalarán la misma fase activa.

## Regla documental

Cada plan mostrará exclusivamente:

- objetivo de la fase activa;
- acciones que pueden realizarse en el entorno actual;
- límites, validación y reversión de esas acciones;
- criterio de cierre de la fase.

No incluirá inventarios de carencias ni listas de trabajo pertenecientes al
portátil o a la sede. Al cerrar la fase se indicará únicamente el paso a la
siguiente; su contenido se definirá entonces a partir del estado real.

## Estado inicial

La fase activa es **equipo actual**. Incluye cerrar la preparación local de
Qontrolmed y revisar desde la carpeta de Servidor_MM el estado vigente de
SFTPGo y de la gestión de subida y bajada de documentos.

## Límite

Esta decisión organiza el orden de trabajo, pero no autoriza por sí sola
cambios en servidor, red, firewall, certificados, cuentas reales, datos del
cliente, builds o releases. Cada bloque conserva la autorización exigida por
su proyecto.
