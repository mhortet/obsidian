---
title: "Diario srv-mm-01 2026-11-01"
type: register
status: active
created: 2026-11-01
updated: 2026-11-01
sources:
  - "ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md"
tags: [documentacion, auditoria, seguridad]
review_after:
---

# Diario de sesión — 2026-11-01

## Objetivo

Retomar `srv-mm-01` desde el cierre del 2026-10-31, comenzar con revalidación de solo lectura y mantener MySQL detenido y sus puertos cerrados.

## Cronología resumida

1. Se leyeron los documentos de continuidad, red, MVP y administración remota.
2. La primera comprobación reveló que `.30` ya no era el servidor.
3. Se localizó `srv-mm-01` en `.31` por MAC y se verificó su clave de host.
4. Se auditó red, SSH, hora, DNS, servicios, actualizaciones, montajes y espacio.
5. Se detectó MySQL activo y escuchando en 3306/33060 tras un arranque automático.
6. Se comprobó que UFW filtraba MySQL y SMB desde Windows.
7. El propietario reservó `.31` en el router.
8. Se revisó el modelo futuro: cuentas por IP reservada, roles y administración por Workbench sobre SSH.
9. La auditoría MySQL confirmó valores predeterminados inseguros para una apertura LAN.
10. Con aprobación se detuvo y deshabilitó MySQL.
11. `unattended-upgrade` instaló el kernel 147 y actualizaciones de seguridad.
12. Se realizó un reinicio aprobado y una revalidación completa satisfactoria.
13. Se reorganizó la carpeta del proyecto y se prepararon mapa, estado, relevo, diario, guía y plantilla.

## Decisiones

- Usar reserva DHCP en la red doméstica; no modificar Netplan.
- Mantener MySQL disabled/inactive hasta aprobar el diseño LAN/TLS.
- No abrir 3306/33060 ni crear cuentas/esquemas todavía.
- Separar cuentas de aplicación, mantenimiento y provisión.
- Preferir Workbench sobre SSH para administración y altas futuras.
- Adoptar una estructura documental numérica y reutilizable para proyectos.

## No realizado

- No se cambió UFW ni SSH.
- No se instaló ni configuró SFTPGo/Cloudflare.
- No se actualizó MySQL a 8.4.13.
- No se ejecutó `do-release-upgrade`.
- No se tocaron firmware, Secure Boot, PAM o `/dev/sdb`.
- No se guardaron credenciales ni datos sensibles.
