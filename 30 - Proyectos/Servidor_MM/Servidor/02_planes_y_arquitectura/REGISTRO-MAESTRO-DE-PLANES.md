---
title: "Registro maestro de planes y cambios de Servidor_MM"
type: register
status: active
created: 2026-11-21
updated: 2026-11-21
sources: []
tags: [documentacion, arquitectura, administracion]
review_after:
---

# Registro maestro de planes y cambios

Este registro distingue planes activos, ejecutados e históricos. El documento original conserva alcance, riesgos, aceptación y reversión.

## Planes relevantes

| Fecha | Plan o cambio | Estado consolidado | Uso actual |
| --- | --- | --- | --- |
| 2026-11-19 | [Revisión SFTPGo, fase equipo actual](PLAN-REVISION-SFTPGO-FASE-EQUIPO-ACTUAL-2026-11-19.md) | Ejecutado y cerrado | Evidencia para documentación y estado de preparación |
| 2026-11-13 | [Ventana P2G, certificados MySQL sintéticos](PLAN-VENTANA-P2G-CERTIFICADOS-MYSQL-SINTETICO-2026-11-13.md) | Ejecutado y revertido | Histórico de validación sintética |
| 2026-11-13 | [Ventana P2C, ledger MySQL sintético](PLAN-VENTANA-P2C-LEDGER-MYSQL-SINTETICO-2026-11-13.md) | Ejecutado y revertido | Histórico de validación sintética |
| 2026-11-06 | [Fase posterior a aceptación sin datos](PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md) | Parcialmente superado | Conservar como antecedente; el relevo vigente gobierna la continuación |
| 2026-11-06 | [Bloque doméstico sin datos](PLAN-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md) | Ejecutado y aceptado | Fuente del ensayo SFTPGo/restic; no repetir sin necesidad |
| 2026-11-05 | [Preparación previa y puesta en sede](PLAN-PREPARACION-PREVIA-Y-PUESTA-EN-SEDE-2026-11-05.md) | Sustituido como plan ejecutable | Conserva requisitos; la fase de sede necesita plan nuevo basado en observación real |
| 2026-11-05 | [Cierre del piloto doméstico](PLAN-CONJUNTO-CIERRE-PILOTO-DOMESTICO-2026-11-05.md) | Ejecutado | Histórico de cierre |
| 2026-11-05 | [Propuesta MySQL](PROPUESTA-MYSQL-SRV-MM-01-2026-11-05.md) | Superada por trabajo P2 posterior | Consulta histórica, no estado vigente |
| 2026-11-05 | [Cambio 01, MySQL local](CAMBIO-01-PILOTO-MYSQL-LOCAL-2026-11-05.md) | Ejecutado y cerrado | Histórico técnico |
| 2026-11-05 | [Cambio 02, arranque local](CAMBIO-02-PILOTO-ARRANQUE-LOCAL-2026-11-05.md) | Ejecutado y cerrado | Histórico técnico |
| 2026-11-05 | [Cambio 03, certificado](CAMBIO-03-PILOTO-CERTIFICADO-2026-11-05.md) | Ejecutado; identidad doméstica no reutilizable | Histórico técnico |
| 2026-10-25 | [Acceso administrativo remoto](PLAN-ACCESO-ADMINISTRATIVO-REMOTO-2026-10-25.md) | Diseño no implantado | Reutilizar criterios, no valores antiguos |
| 2026-10-25 | [Actualizaciones Qontrolmed LAN](PLAN-ACTUALIZACIONES-QONTROLMED-LAN-2026-10-25.md) | Histórico/superado | No ejecutar como plan vigente |
| 2026-10-25 | [Revisión documental y ruta MVP](REVISION-DOCUMENTAL-Y-RUTA-MVP-2026-10-25.md) | Histórico | Antecedente de arquitectura |
| 2026-10-08 | [Repositorio remoto y Qontrolmed](PLAN-ACCION-REPOSITORIO-REMOTO-Y-QONTROLMED-2026-10-08.md) | Histórico/superado | Consulta de alternativas |
| 2026-10-06 | [Repositorio remoto documental](PROPUESTA-REPOSITORIO-REMOTO-DOCUMENTOS-2026-10-06.md) | Propuesta histórica | Criterios reutilizables; implantación pendiente de sede |

## Próximo plan necesario

El siguiente plan será el **plan de implantación en sede**. Todavía no existe como plan aprobado y debe redactarse con el estado observado allí. Incluirá, como mínimo:

1. Inventario y prechecks del portátil, consola/LUKS, red y huella SSH.
2. Direccionamiento, DHCP, DNS, UFW y pruebas de origen autorizado/no autorizado.
3. Cloudflare/DNS/Access y `cloudflared`, si se confirma esa arquitectura.
4. MySQL, CA e identidad runtime por puesto.
5. SFTPGo e identidades documentales nominales.
6. Copia independiente y restauración.
7. Instalación y aceptación de Qontrolmed.
8. Documentación, formación, acta y reversión de cada bloque.

Hasta su aprobación no se activarán servicios ni se crearán recursos reales de sede.
