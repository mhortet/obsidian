---
title: "Continuación srv-mm-01 — reanudación tras incidente de consola"
type: register
status: active
created: 2026-11-01
updated: 2026-11-13
sources:
  - "00_seguimiento/estados/ESTADO-INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.md"
  - "03_operacion_y_runbooks/REANUDAR-TRAS-INCIDENTE-CONSOLA-2026-11-13.md"
  - "../../Qontrolmed/01_gobierno_y_decisiones/CONTINUAR-SIGUIENTE-SESION.md"
  - "00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "05_evidencias/ACEPTACION-FUNCIONAL-WEBCLIENT-2026-11-06.txt"
  - "05_evidencias/ACEPTACION-BLOQUE-DOMESTICO-2026-11-06.txt"
tags: [documentacion, seguridad, administracion]
review_after: 2026-11-14
---

# Punto seguro de continuación

## Entrada coordinada

Esta sesión puede iniciarse desde esta carpeta o desde `D:\trabajo\Proyectos\maxgesth`. En ambos casos se deben leer los `AGENTS.md` y relevos de `Servidor_MM` y `Qontrolmed` antes de ejecutar trabajo transversal. La infraestructura y la aplicación conservan fuentes de verdad y autorizaciones separadas; véase `AGENTS.md`.

## Leer primero

1. `AGENTS.md`.
2. `00_seguimiento/estados/ESTADO-INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.md`.
3. `03_operacion_y_runbooks/REANUDAR-TRAS-INCIDENTE-CONSOLA-2026-11-13.md`.
4. `00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md`.
5. `02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md`.
6. `DOCUMENTACION-SERVIDOR-UBUNTU.md`.
7. `../../Qontrolmed/01_gobierno_y_decisiones/CONTINUAR-SIGUIENTE-SESION.md` como relevo funcional vigente, creado el 10/11 y actualizado el 11/11.

El servidor fue encendido por el propietario el 13/11/2026 para P2G y permanece en línea. Las puertas de arranque físico y revalidación remota anteriores terminaron con `REVALIDACION_TRAS_INCIDENTE=OK`.

La consola quedó aceptada en tres arranques persistentes —dos VGA y uno DisplayPort— con `nomodeset`. La NVIDIA GA106 permanece retirada. No reinstalarla, no modificar BIOS/UEFI, no reparar `sdb1` y no cambiar GRUB salvo un plan nuevo aprobado.

El bloque doméstico SFTPGo/`cloudflared`/`restic` sin datos del cliente está completado. No repetir instalación, cuentas, TOTP, pruebas de cuota o restauración salvo nueva necesidad documentada.

## Contexto funcional vigente de Qontrolmed

El relevo del servidor del 6/11 no era el último relevo del trabajo conjunto. El proyecto `Qontrolmed` conserva un relevo creado el 10/11 y actualizado el 11/11. Ese documento es la fuente vigente para el estado de aplicación:

- rama `codex/produccion-readiness` publicada;
- P0 local parcialmente completado y P1 local implementado;
- 44 pruebas correctas, Bandit sin hallazgos medios/altos y auditoría directa de dependencias sin avisos conocidos;
- código TLS, recuperación, retirada de DDL runtime, CI bloqueante y provisión de CA trabajados localmente;
- servidor, MySQL real, datos reales y `.env` no modificados ni inspeccionados;
- ninguna RC construida o instalada;
- GitHub CI/Gitleaks remoto pendiente por autenticación caducada de `gh`;
- producto todavía `NO-GO` para producción; objetivo limitado a piloto privado controlado.

No regresar al plan funcional del 6/11 como si fuera el último punto de Qontrolmed. Tras recuperar el servidor, continuar desde el relevo Qontrolmed del 10/11–11/11 y revalidar su estado de rama antes de editar.

## Estado vigente

- Servidor encendido y en línea al cierre de P2G del 13/11/2026.
- `nomodeset` persistente; reversión disponible en `/etc/default/grub.pre-nomodeset-20261112T1325`.
- NVIDIA GA106 retirada y pendiente de diagnóstico físico separado.
- Dirección doméstica vigente `192.168.1.31`, reservada en el router y revalidada a 100 Mb/s por límite del switch 3Com. `.30` es solo el alias histórico de la clave de host SSH.
- SFTPGo Community `2.7.6-1` instalado, `inactive/disabled`.
- `cloudflared 2026.10.7` instalado, `inactive/masked`, sin túnel, token, DNS o recursos reales.
- `restic 0.16.4-2ubuntu0.24.04.3` y `acl 2.3.2-1build1.1` instalados.
- MySQL `inactive/disabled`, sin proceso ni 3306/33060.
- Sin unidades fallidas y sin listeners del bloque.
- `/srv/compartido` conserva `root:root 0750`, `nosuid,nodev,noexec` y ACL nominal `u:sftpgo:--x`.
- `documental-piloto` volvió a `Active` después del ensayo de revocación; `admin-piloto` y `documental-piloto` conservan TOTP.
- Túnel local cerrado, identidad `id_ed25519_srv_mm` retirada, agente SSH vacío y sin conexiones establecidas.

No se documentaron contraseñas, secretos TOTP, códigos de recuperación, cookies o la contraseña `restic`.

P2G validó `quirofanos-0002` contra MySQL 8.4.11 con esquema, cuenta y datos
sintéticos. La ventana terminó con MySQL `inactive/disabled`, 3306/33060
cerrados, TLS temporal retirado, SFTPGo `inactive/disabled` y Cloudflared
`inactive/masked`. El servidor permaneció encendido por decisión del
propietario. Plan:
`02_planes_y_arquitectura/PLAN-VENTANA-P2G-CERTIFICADOS-MYSQL-SINTETICO-2026-11-13.md`.

P2J validó el 13/11 la base greenfield de Preventivos contra MySQL 8.4.11 con
esquema y datos exclusivamente sintéticos. Dos ejecuciones dejaron 10 tablas,
12 claves foráneas y el ciclo mínimo correcto. Al cerrar se retiraron esquema,
TLS y `/tmp/qontrolmed-p2j-20261113`; MySQL quedó `inactive/disabled`, sin
3306/33060, SFTPGo `inactive/disabled` y Cloudflared `inactive/masked`. El
servidor permanece encendido. Fuente funcional y evidencia:
`D:\trabajo\Proyectos\maxgesth\docs\05_evidencias\VALIDACION-P2J-PREVENTIVOS-MYSQL-SINTETICO-2026-11-13.md`.
El bloque está publicado en `a969c39`; CI `43476382817` y Security Checks
`43476383169` finalizaron correctamente.

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

### Prioridad inmediata — 13/11/2026

Completada. Arranque normal, LUKS, consola VGA, red, SSH, montajes y línea base segura coincidieron. MySQL y SFTPGo permanecieron `inactive/disabled`, `cloudflared` `inactive/masked`, no hubo unidades fallidas ni puertos de aplicación. La identidad SSH fue retirada y el servidor se apagó con `sudo systemctl poweroff`.

Queda como hallazgo separado una referencia de `/etc/pam.d/login` a
`pam_lastlog.so` ausente. No bloqueó el acceso finalmente realizado ni el
apagado y no autoriza una corrección sin diagnóstico y plan.

### Continuación condicionada

No queda trabajo autorizado pendiente dentro del bloque doméstico del servidor. Una vez superada la revalidación tras el incidente, la prioridad funcional es retomar `Qontrolmed` desde su relevo vigente y comprobar rama, diff y pruebas antes de continuar el siguiente bloque local proporcional al piloto privado.

El 13/11 se preparó y ejecutó el plan compatible
`02_planes_y_arquitectura/PLAN-VENTANA-P2C-LEDGER-MYSQL-SINTETICO-2026-11-13.md`
para probar el ledger contra MySQL 8.4.11 con un esquema y una cuenta
temporales, escucha solo en loopback y retirada completa. P2C terminó
correctamente; MySQL volvió a `inactive/disabled`, sin proceso ni puertos, y la
configuración TLS temporal quedó retirada. No repetir la ventana salvo una
nueva necesidad documentada.

También puede avanzarse, si se decide trabajar específicamente en la plataforma del servidor, mediante la parte de auditoría de solo lectura y preparación local del [plan posterior a la aceptación](02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md). Ese plan del servidor sigue propuesto y no autoriza cambios remotos.

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
