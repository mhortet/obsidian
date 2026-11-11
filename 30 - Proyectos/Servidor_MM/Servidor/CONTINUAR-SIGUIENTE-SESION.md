---
title: "Continuación srv-mm-01 — bloque doméstico aceptado"
type: register
status: active
created: 2026-11-01
updated: 2026-11-06
sources:
  - "00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "05_evidencias/ACEPTACION-FUNCIONAL-WEBCLIENT-2026-11-06.txt"
  - "05_evidencias/ACEPTACION-BLOQUE-DOMESTICO-2026-11-06.txt"
tags: [documentacion, seguridad, administracion]
review_after: 2026-11-13
---

# Punto seguro de continuación

## Leer primero

1. `AGENTS.md`.
2. `00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md`.
3. `02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md`.
4. `03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md`.
5. `DOCUMENTACION-SERVIDOR-UBUNTU.md`.
6. `02_planes_y_arquitectura/PLAN-PREPARACION-PREVIA-Y-PUESTA-EN-SEDE-2026-11-05.md`.

El bloque doméstico SFTPGo/`cloudflared`/`restic` sin datos del cliente está completado. No repetir instalación, cuentas, TOTP, pruebas de cuota o restauración salvo nueva necesidad documentada.

## Estado vigente

- SFTPGo Community `2.7.6-1` instalado, `inactive/disabled`.
- `cloudflared 2026.10.7` instalado, `inactive/masked`, sin túnel, token, DNS o recursos reales.
- `restic 0.16.4-2ubuntu0.24.04.3` y `acl 2.3.2-1build1.1` instalados.
- MySQL `inactive/disabled`, sin proceso ni 3306/33060.
- Sin unidades fallidas y sin listeners del bloque.
- `/srv/compartido` conserva `root:root 0750`, `nosuid,nodev,noexec` y ACL nominal `u:sftpgo:--x`.
- `documental-piloto` volvió a `Active` después del ensayo de revocación; `admin-piloto` y `documental-piloto` conservan TOTP.
- Túnel local cerrado, identidad `id_ed25519_srv_mm` retirada, agente SSH vacío y sin conexiones establecidas.

No se documentaron contraseñas, secretos TOTP, códigos de recuperación, cookies o la contraseña `restic`.

## Aceptación completada

- Descarga y sobrescritura con SHA-256 coincidentes.
- Límite de 50 MiB y cuota de 250 MiB rechazaron los excesos sintéticos.
- Credencial incorrecta, ausencia de TOTP y cuenta inactiva fueron rechazadas.
- Revocación temporal y reactivación de `documental-piloto` verificadas.
- Renombrado, copia, borrado, enlaces y comparticiones no se expusieron en la UI documental; no se forzó una API fuera del WebClient.
- Protocolos alternativos sin escucha.
- `restic check`, restauración aislada, comparación de hashes y `SQLITE_INTEGRITY=ok`.
- Resultado técnico: `ACCEPTANCE_RESULT=OK`.

La copia `restic` es un ensayo cifrado local en el mismo servidor/disco, no independiente ni 3-2-1.

## Corrección conservada

El script de aceptación vigente tiene SHA-256 `38351cc3d45c7793d40520ced02b6825b845ae445e90ee13936d16d6b2368d34`. Corrige el retorno falso de `assert_mysql_safe` bajo `set -e`. El original `e2e7d154...` se conserva en el staging remoto como `.pre-fix-e2e7d154` para reversión y trazabilidad.

## Próximo trabajo

No queda trabajo autorizado pendiente dentro del bloque doméstico. Sí puede avanzarse, sin las evidencias del cliente, mediante el [plan posterior a la aceptación](02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md): auditoría remota de solo lectura, revisión de los artefactos existentes y preparación local de plantillas y runbooks parametrizados. El [inicio de la próxima sesión](03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md) fija el orden y las condiciones de parada.

Este nuevo plan está **propuesto, no aprobado**. No autoriza cambios en el servidor. Si la auditoría identifica una mejora remota, se documentará en un plan técnico separado y se detendrá antes de aplicarla.

La integración y entrega siguen dependiendo de información o decisiones del cliente:

1. dominio, DNS, titularidad y recuperación de Cloudflare;
2. usuarios nominales, MFA y matriz definitiva de permisos;
3. red de sede, reserva DHCP, VLAN/segmentación y solapamiento;
4. destino externo independiente, retención, RPO/RTO y restauración 3-2-1;
5. responsable local, SAI/KVM y recuperación LUKS tras corte prolongado;
6. aceptación del cliente y calendario de entrega;
7. resolución del bloqueo de provisión de CA antes de instalar Qontrolmed.

Preparar localmente propuestas y parámetros reversibles es válido. Crear recursos reales, instalar o actualizar paquetes, cambiar servicios o configuración, modificar red/UFW/SSH/LUKS/discos, usar datos reales o iniciar MySQL/Qontrolmed requiere el plan correspondiente y aprobación explícita.

## Evidencias principales

- `05_evidencias/ACEPTACION-FUNCIONAL-WEBCLIENT-2026-11-06.txt`
- `05_evidencias/ACEPTACION-BLOQUE-DOMESTICO-2026-11-06.txt`
- `05_evidencias/MANIFIESTO-BLOQUE-DOMESTICO-2026-11-06.txt`
- `00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md`

## Documento maestro

Actualizar siempre `DOCUMENTACION-SERVIDOR-UBUNTU.md`; no crear otra guía maestra paralela. La puesta en producción y la aceptación del cliente siguen pendientes.
