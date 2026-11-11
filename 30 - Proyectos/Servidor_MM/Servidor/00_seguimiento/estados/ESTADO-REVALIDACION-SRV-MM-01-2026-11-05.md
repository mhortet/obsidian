---
title: "Revalidación de srv-mm-01 2026-11-05"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md"
tags: [auditoria, seguridad, mysql]
review_after: 2026-11-12
---

# Revalidación de srv-mm-01 — 2026-11-05

Comprobación por SSH de solo lectura. Complementa el estado del 1 de noviembre; no revalida sus detalles privilegiados.

| Componente | Observación de hoy |
| --- | --- |
| Identidad | srv-mm-01; clave de host previamente conocida validada |
| Sistema | Ubuntu declarado 24.04.5 LTS; kernel 6.8.0-147-generic |
| Red doméstica temporal | eno1, 192.168.1.31/24; gateway 192.168.1.1 |
| Salud | running; sin unidades fallidas ni reinicio requerido |
| Servicios | ssh.socket y ufw active; mysql inactive y disabled |
| Escuchas TCP | 22 en IPv4/IPv6; DNS en loopback; sin 3306/33060 |
| Montajes | /var/lib/mysql y /srv/compartido correctos |
| Espacio libre aproximado | raíz 82 GiB; MySQL 62 GiB; compartido 218 GiB |

## Límites de la comprobación

sudo requiere autenticación local: no se inspeccionaron las reglas de UFW ni la asociación privilegiada entre procesos y puertos. No se revalidaron versión MySQL, cuentas, esquemas, certificados ni actualizaciones disponibles. La ausencia de escucha se comprobó en el servidor; no se repitió una prueba externa de puertos.

El propietario cargó su identidad SSH desde PowerShell. No se leyeron claves privadas ni se registraron contraseñas. La conexión utilizó temporalmente HostKeyAlias=192.168.1.30 y StrictHostKeyChecking=yes; sigue pendiente normalizar known_hosts.

No se realizaron cambios en el servidor.

## Decisiones y siguiente paso

Aceptado el piloto doméstico con un solo puesto y datos ficticios. Pendientes IP del puesto, nombre verificable del servidor, certificados, copia/restauración y revisión del código actual de Qontrolmed. No se autoriza todavía arrancar MySQL, abrir puertos ni crear cuentas/esquemas.
