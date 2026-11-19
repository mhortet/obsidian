---
title: "Revisión SFTPGo y gestión documental desde el equipo actual"
type: plan
status: authorized
created: 2026-11-19
updated: 2026-11-19
sources:
  - "../00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "../DOCUMENTACION-SERVIDOR-UBUNTU.md"
  - "D:/trabajo/Proyectos/maxgesth/docs/01_gobierno_y_decisiones/DECISION-SECUENCIA-EQUIPO-PORTATIL-SEDE-2026-11-19.md"
tags: [servidor-mm, sftpgo, documentos, equipo-actual]
review_after: 2026-11-26
---

# Revisión SFTPGo y gestión documental desde el equipo actual

## Objetivo

Cerrar desde el equipo actual el estado técnico y documental del servicio de
subida y bajada de ficheros. Se parte de la aceptación doméstica ficticia ya
superada; no se repetirá una prueba correcta sin una desviación observada.

## Trabajo pendiente de esta fase

1. Revalidar en solo lectura SFTPGo, `cloudflared`, puertos, unidades,
   montajes, espacio, ACL y procesos, sin mostrar secretos.
2. Confirmar versión, bindings, protocolos deshabilitados y separación entre
   WebClient y WebAdmin.
3. Revisar subida, descarga, sobrescritura, creación de carpetas, borrado,
   renombrado, enlaces, comparticiones, límite de fichero y cuota.
4. Revisar el modelo de carpetas compartidas y personales y sus permisos por
   ruta.
5. Confirmar cuentas nominales, TOTP, alta, revocación, baja y recuperación
   manual administrada por Vicente.
6. Revisar copia y restauración de configuración, metadatos y documentos,
   distinguiendo el ensayo local de una copia independiente.
7. Actualizar los runbooks de operación, incidencias, salud y reversión.
8. Actualizar maestro, diario, estado y relevo separando hechos, inferencias y
   decisiones.

## Límites

- Primera entrada remota exclusivamente de lectura.
- No leer ni documentar contraseñas, hashes, secretos TOTP, cookies, tokens o
  claves privadas.
- Sin cuentas o documentos reales, publicación en Internet ni recursos
  Cloudflare.
- Sin modificar red, UFW, SSH, LUKS, discos, BIOS o MySQL.
- Un cambio necesario exigirá un plan técnico exacto de esta misma fase.

## Validación

- línea base comparada con la aceptación del 06/11;
- matriz documental sin contradicciones;
- runbooks coherentes y sin secretos;
- servidor sin cambios tras la auditoría;
- identidad SSH retirada y conexiones cerradas.

## Reversión

La auditoría no modifica el servidor. Los cambios documentales se revierten
por versión anterior y ningún artefacto local se transfiere sin validación.

## Criterio de cierre

La fase termina cuando SFTPGo y la gestión documental quedan revalidados y no
resta trabajo necesario ejecutable desde este equipo. El relevo indicará
entonces pasar a **portátil**, sin anticipar su plan.
