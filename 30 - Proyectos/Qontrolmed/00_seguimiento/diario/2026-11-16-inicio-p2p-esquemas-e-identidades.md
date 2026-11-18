---
title: "Inicio P2P: esquemas definitivos e identidades"
type: state
status: completed
created: 2026-11-16
updated: 2026-11-16
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2P-ESQUEMAS-DEFINITIVOS-IDENTIDADES-Y-ACCESOS-2026-11-16.md"
tags: [qontrolmed, sesion, mysql, identidades, sftpgo]
review_after: 2026-11-23
---

# Sesión 2026-11-16: inicio P2P

## Objetivo

Iniciar las fases 0 y 1 autorizadas: crear los esquemas definitivos `gestion`,
`preventivos` y `quirofanos`, y consolidar el tratamiento separado de usuarios
funcionales, cuentas MySQL, administración técnica y acceso documental.

## Trabajo realizado

1. Se revisó el diseño documental vigente de Servidor_MM.
2. Se confirmó que el acceso inicial previsto a documentos es SFTPGo WebClient
   con cuentas nominales y TOTP; SMB no está desplegado.
3. Se registró el plan P2P con alcance, límites, aceptación y reversión.
4. Se ejecutó un precheck SSH de solo lectura sobre `srv-mm-01`.

## Resultado observado

- Host: `srv-mm-01`.
- MySQL: `inactive/disabled`.
- No hay listeners en 3306, 33060, 18080 o 18081.
- `/var/lib/mysql`: 63 GiB, aproximadamente 62 GiB disponibles.
- `/srv/compartido`: 220 GiB, aproximadamente 217 GiB disponibles.
- No se listaron unidades fallidas.
- El intento de inicio no interactivo terminó de forma segura porque `sudo`
  requiere contraseña. No se pidió ni registró el secreto.

## Límite y continuación

El propietario inició MySQL e introdujo `sudo` directamente en su sesión SSH,
sin compartir la contraseña. El arnés P2P creó de forma no destructiva
`gestion`, `preventivos` y `quirofanos`, mantuvo `piloto_mm_*` y terminó con
`P2P_RESULTADO=OK`.

La verificación posterior confirmó:

- copia previa con SHA-256 correcto;
- pares origen/destino con 13, 10 y 7 tablas;
- charset/collation coincidentes;
- `qontrolmed_admin@localhost` limitado a los seis esquemas de transición;
- ausencia de privilegios globales y `GRANT OPTION`;
- MySQL `active/disabled` y escucha exclusiva en `127.0.0.1:3306`;
- `P2P_VERIFICACION=OK`.

La fase 0 queda completada. El propietario confirmó visualmente desde
Workbench, a través del túnel SSH, que aparecen los tres esquemas definitivos y
los tres `piloto_mm_*` de reversión. La fase 1 continúa pendiente únicamente de
completar los procedimientos de usuarios funcionales de Qontrolmed y usuarios
nominales SFTPGo.

Posteriormente se definió la política documental inicial: lectura y descarga
globales, aportación y borrado dentro de una carpeta nominal propia, asignación
adicional mediante carpetas virtuales/grupos y recuperación manual solicitada a
Vicente. Se difiere la recuperación automática por correo o teléfono. El
aislamiento por carpetas propias evita afirmar erróneamente que SFTPGo puede
conceder borrado por autor dentro de una única carpeta compartida.

## Pausa solicitada

El propietario pidió detener la sesión por malestar físico. Se dejó constancia
de que el flujo vigente exige insertar primero el usuario inicial en
`gestion.usuarios` y que Qontrolmed solicita después su contraseña. No se creó
ningún usuario, no se abrió MySQL en LAN y no se activó SFTPGo.

La próxima sesión comenzará con inventario de solo lectura de roles, permisos y
usuarios en `gestion`, seguido de un plan específico de bootstrap seguro.
