---
title: "Aceptación del bloque doméstico sin datos del cliente — 2026-11-06"
type: register
status: active
created: 2026-11-06
updated: 2026-11-06
sources:
  - "../../02_planes_y_arquitectura/PLAN-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "../../05_evidencias/ACEPTACION-FUNCIONAL-WEBCLIENT-2026-11-06.txt"
  - "../../05_evidencias/ACEPTACION-BLOQUE-DOMESTICO-2026-11-06.txt"
  - "../../05_evidencias/MANIFIESTO-BLOQUE-DOMESTICO-2026-11-06.txt"
tags: [documentacion, seguridad, administracion, testing]
review_after: 2026-11-13
---

# Aceptación del bloque doméstico sin datos del cliente — 2026-11-06

## Resultado

El bloque doméstico aprobado queda completado y aceptado dentro de su alcance ficticio. No se usaron datos, usuarios, dominio, DNS, túneles o copias reales del cliente. No se modificaron UFW, SSH, red, LUKS, discos, BIOS ni MySQL/Qontrolmed.

El resultado no autoriza producción ni datos reales. La copia `restic` permanece en el mismo servidor y disco físico: es un ensayo local cifrado, no una copia independiente ni 3-2-1.

## Pruebas funcionales WebClient

- Autenticación correcta con contraseña y TOTP.
- Descarga de la versión 1: 147 bytes y SHA-256 `1c169fc300561b04fefd5d088a7a8e642ba766fd1539eceab948b769c12e190e`.
- Sobrescritura por versión 2: 154 bytes y SHA-256 local/descarga `11b2b692c4a3682ba0c1a66c5995fa93aa662781c6980f64473d39cfe47dcd94`.
- El menú de acciones no expuso renombrado, copia, borrado, enlaces o comparticiones para la cuenta documental. No se forzó una llamada API fuera del flujo WebClient.
- Ausencia de listeners SFTP, FTP, FTPS y WebDAV en `2022`, `21`, `990` y `8080`.
- Archivo de 50 MiB + 1 byte rechazado y ausente del listado.
- Cinco archivos ficticios de 49 MiB aceptados; un archivo adicional de 10 MiB fue rechazado por cuota y quedó ausente.
- Credencial incorrecta y ausencia de TOTP rechazadas con `Invalid credentials`.
- Revocación temporal: cuenta `Inactive`, sesión existente invalidada con `Forbidden` y nuevo acceso rechazado. Reversión inmediata a `Active` y acceso contraseña+TOTP restaurado.

No se registraron contraseñas, secretos TOTP, códigos de recuperación o cookies de sesión.

## Copia y restauración local

El script de aceptación finalizó con `ACCEPTANCE_RESULT=OK`:

- SFTPGo se detuvo antes de copiar la configuración y SQLite.
- `restic` respaldó 12 archivos y 15 directorios; volumen lógico procesado: 245,364 MiB.
- `restic check` terminó sin errores.
- La restauración se realizó en `/root/srv-mm-preparacion-20261106/restore-20261106T171447`, sin sobrescribir el proveedor activo.
- El manifiesto SHA-256 de documentos originales y restaurados coincidió; `diff` terminó con código 0.
- La SQLite restaurada devolvió `SQLITE_INTEGRITY=ok`.
- `forget --keep-last 1 --dry-run` conservó el único snapshot; no se ejecutó `prune`.
- Snapshot local: `ad68b9ac`; repositorio `5929195a30` bajo `/root/srv-mm-preparacion-20261106/restic-ensayo`.

La contraseña del repositorio permanece en un archivo root `0600` fuera de la bóveda y no se imprimió. La base restaurada contiene hashes de contraseña y secretos TOTP cifrados; debe seguir tratándose como material sensible.

## Corrección del script de aceptación

El primer intento terminó de forma segura inmediatamente después de `ACCEPTANCE_START`: `assert_mysql_safe` devolvía 1 cuando no encontraba MySQL, y `set -e` interpretaba ese estado seguro como error.

Se sustituyeron las comprobaciones `cmd && fail` por bloques `if` y `return 0`. Hash anterior: `e2e7d1542eaecfe252bc3cb64ccfaf8068c65e4e0ec69578f6abbbe370791fdf`; hash corregido: `38351cc3d45c7793d40520ced02b6825b845ae445e90ee13936d16d6b2368d34`. El original se preservó en el staging remoto como `.pre-fix-e2e7d154`. La corrección pasó `bash -n` y la ejecución posterior terminó correctamente.

## Estado final confirmado a las 17:17 CET

- SFTPGo `inactive/disabled`.
- `cloudflared inactive/masked`, sin túnel, token, DNS o recursos externos.
- MySQL `inactive/disabled`, sin proceso ni 3306/33060.
- Sin procesos SFTPGo/Cloudflare/MySQL y sin unidades fallidas.
- Únicamente SSH, resolved y DHCP en escucha; ausencia de `18080/18081` y protocolos deshabilitados.
- `/srv/compartido` conserva ext4 `rw,nosuid,nodev,noexec`, `root:root 0750` y ACL `u:sftpgo:--x`.
- Hash de `90-qontrolmed-piloto.cnf` intacto: `4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927`.
- UFW activo con las dos reglas SSH existentes; `ssh.socket` activo/habilitado.
- Túnel local cerrado; identidad `id_ed25519_srv_mm` retirada; agente SSH vacío y sin conexiones establecidas.

## Evidencias

- `05_evidencias/ACEPTACION-FUNCIONAL-WEBCLIENT-2026-11-06.txt`
- `05_evidencias/ACEPTACION-BLOQUE-DOMESTICO-2026-11-06.txt`
- `05_evidencias/APLICACION-BLOQUE-DOMESTICO-2026-11-06.txt`
- `05_evidencias/CORRECCION-ACL-SFTPGO-2026-11-06.txt`
- `05_evidencias/MANIFIESTO-BLOQUE-DOMESTICO-2026-11-06.txt`

## Trabajo siguiente

No queda trabajo pendiente dentro del bloque doméstico aprobado. La siguiente fase requiere decisiones o datos del cliente y un plan específico: dominio/DNS/Cloudflare, identidades nominales, red de sede, destino externo 3-2-1, RPO/RTO, recuperación LUKS/SAI y aceptación del cliente. MySQL/Qontrolmed deben seguir detenidos en la primera entrega documental prevista.

Sin esperar esos datos puede ejecutarse, tras su aprobación, el [plan posterior a la aceptación](../../02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md): auditoría remota de solo lectura y preparación local parametrizada. El plan está propuesto y no autoriza cambios en el servidor.
