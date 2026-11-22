---
title: "Estado actual consolidado de srv-mm-01"
type: register
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../CONTINUAR-SIGUIENTE-SESION.md"
  - "estados/ESTADO-REVALIDACION-SFTPGO-FASE-EQUIPO-ACTUAL-2026-11-19.md"
tags: [documentacion, administracion, seguridad]
review_after:
---

# Estado actual consolidado

Fecha de corte documental: **21 de noviembre de 2026**. Este resumen no sustituye una revalidación técnica al llegar a sede.

## Fase física

- Equipo actual: cerrada.
- Portátil: cerrado y preparado como equipo de administración/transporte y puesto de prueba.
- Sede: siguiente fase; requiere un plan específico aprobado basado en inventario real.

## Servidor

- Nombre: `srv-mm-01`.
- Ubuntu Server 24.04 LTS; versión y kernel deberán revalidarse en sede.
- Consola aceptada con Intel integrada y `nomodeset`; NVIDIA retirada.
- LUKS2 requiere resolver y ensayar la recuperación operativa de sede.
- IP doméstica `.31` y red `192.168.1.0/24`: históricas, no trasladables a producción.

## Servicios

- MySQL: último estado coordinado `active/enabled`, limitado a `127.0.0.1:3306`.
- SFTPGo: `inactive/disabled` al cierre de revalidación del 19/11.
- Cloudflared: `inactive/masked`, sin túnel, token, DNS o recurso real.
- SSH: acceso por clave; huella, origen y reglas deben revalidarse en sede.
- Copia restic: ensayo cifrado local correcto, pero no independiente ni 3-2-1.

## Aplicación

- RC `0.1.0-rc.1` preparada y verificada en las fases anteriores.
- No está autorizada todavía su conexión al servidor de sede.
- La cuenta runtime definitiva por puesto y la conectividad real se resolverán en el plan de sede.

## Datos y privacidad

- Se excluyen datos de pacientes e información clínica.
- Los datos personales mínimos de usuarios y técnicos están protegidos.
- Los ensayos documentados utilizaron datos ficticios o sintéticos.

## Próxima acción

Comenzar la fase de sede con inventario de solo lectura y preparar un plan con aceptación y reversión para red, túnel, MySQL/CA, identidades, SFTPGo, copias y Qontrolmed. No activar o publicar servicios antes de ese plan.
