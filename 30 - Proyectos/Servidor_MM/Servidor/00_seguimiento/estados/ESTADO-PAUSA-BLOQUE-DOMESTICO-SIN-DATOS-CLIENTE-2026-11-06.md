---
title: "Pausa del bloque doméstico sin datos del cliente — 2026-11-06"
type: register
status: archived
created: 2026-11-06
updated: 2026-11-06
sources:
  - "../../02_planes_y_arquitectura/PLAN-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "../../05_evidencias/APLICACION-BLOQUE-DOMESTICO-2026-11-06.txt"
  - "../../05_evidencias/CORRECCION-ACL-SFTPGO-2026-11-06.txt"
  - "../../05_evidencias/CIERRE-BLOQUE-DOMESTICO-PAUSA-2026-11-06.txt"
tags: [documentacion, seguridad, administracion, testing]
review_after: 2026-11-07
---

# Pausa del bloque doméstico sin datos del cliente — 2026-11-06

> [!note] Estado histórico
> Esta pausa fue superada el 2026-11-06. Continuar desde [[ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06]].

## Motivo y alcance

El propietario solicitó pausar por límite de sesión después de completar la primera carga ficticia. No se incorporaron datos, usuarios, dominio, DNS, recursos Cloudflare o copias reales del cliente. No se modificaron UFW, SSH, red, LUKS, discos ni MySQL/Qontrolmed.

## Trabajo completado

- Preflight privilegiado superado y archivado.
- Instalación desde fuentes aprobadas:
  - SFTPGo Community `2.7.6-1`;
  - `cloudflared 2026.10.7`;
  - `restic 0.16.4-2ubuntu0.24.04.3`;
  - `acl 2.3.2-1build1.1`, añadido mediante bloque correctivo aprobado.
- SFTPGo configurado con WebClient en `127.0.0.1:18080` y WebAdmin en `127.0.0.1:18081`; SFTP, FTP y WebDAV sin escucha.
- `cloudflared` conserva una plantilla `.invalid`, sin túnel, token, DNS o servicio activo.
- Cuenta ficticia `admin-piloto` creada con TOTP.
- Cuenta ficticia `documental-piloto` creada con:
  - cuota de 250 MiB y carga máxima de 50 MiB;
  - máximo de dos sesiones;
  - TOTP obligatorio para HTTP;
  - SSH, FTP y WebDAV denegados;
  - permisos `list`, `download`, `upload`, `overwrite` y `create_dirs`;
  - borrado, renombrado, copia, enlaces, comparticiones y API keys no concedidos.
- Contraseñas, secretos TOTP y códigos de recuperación fueron introducidos y custodiados por el propietario; no se copiaron al chat, la bóveda o la evidencia.
- Corregido el tránsito de la cuenta de servicio mediante ACL nominal `u:sftpgo:--x` sobre `/srv/compartido`, conservando `root:root 0750`. Se verificó que `sftpgo` puede atravesar la ruta conocida pero no listar la raíz del montaje.
- WebClient autenticó con contraseña y TOTP.
- Creada la carpeta ficticia `ensayo-ficticio`.
- Cargado `PRUEBA-WEBCLIENT-FICTICIA-2026-11-06.txt`, 147 bytes; SHA-256 local `1c169fc300561b04fefd5d088a7a8e642ba766fd1539eceab948b769c12e190e`.

## Estado al pausar

El reenvío SSH local de `18080/18081` quedó cerrado. El primer intento no interactivo de detener SFTPGo falló de forma segura porque requería contraseña; el propietario ejecutó después la parada interactiva. La comprobación final confirmó:

- SFTPGo: `inactive/disabled`;
- `cloudflared`: `inactive/masked`;
- MySQL: `inactive/disabled`, sin escucha 3306/33060;
- cero unidades fallidas;
- ausencia de listeners `18080`, `18081`, `3306` y `33060`;
- cero unidades fallidas y ninguna exposición nueva a la LAN o Internet.

La identidad `id_ed25519_srv_mm` fue retirada después de esta comprobación y `ssh-add -l` confirmó que el agente no contiene identidades.

## Pruebas superadas

- procedencia, simulación e instalación de paquetes;
- bindings exclusivamente loopback y separación WebClient/WebAdmin;
- plantilla inerte de `cloudflared` y regla final 404;
- administración y cuenta documental con TOTP;
- creación de carpeta y primera carga ficticia;
- cuota y permisos configurados en WebAdmin;
- corrección ACL con reversión documentada;
- MySQL y `cloudflared` permanecieron detenidos.

## Pruebas pendientes

1. Revalidar SFTPGo `inactive/disabled`, ausencia de `18080/18081` y agente SSH vacío antes de reanudar.
2. Refrescar desde el servidor `APLICACION-BLOQUE-DOMESTICO-2026-11-06.txt`; la copia local actual se recogió tras `packages`, mientras el remoto contiene también `configure`.
3. Volver a iniciar SFTPGo solo durante la ventana de ensayo y abrir un reenvío SSH local nuevo.
4. Descargar el archivo y comparar SHA-256.
5. Sobrescribirlo con una versión 2 y comprobar contenido/hash.
6. Comprobar denegación de renombrado, copia, borrado, enlaces y protocolos no autorizados.
7. Comprobar carga superior a 50 MiB y cuota de 250 MiB sin incorporar datos reales.
8. Comprobar ausencia de TOTP y credencial incorrecta sin registrar secretos.
9. Revocar temporalmente `documental-piloto`, comprobar rechazo y restaurar solo si el plan de la siguiente sesión lo requiere.
10. Ejecutar `aceptar-bloque-domestico-20261106.sh`: copia/restauración local cifrada con `restic`, integridad SQLite, hashes y cierre automático de SFTPGo.
11. Archivar la aceptación depurada y actualizar maestro, diario, manifiesto y relevo final.

## Secuencia segura de reanudación

1. Leer este estado y el plan aprobado.
2. Revalidar en solo lectura MySQL, SFTPGo, `cloudflared`, puertos, unidades fallidas, ACL y agente SSH.
3. No repetir instalación, alta de cuentas o TOTP salvo evidencia de pérdida.
4. Continuar por descarga/sobrescritura y negativas.
5. Terminar con el script de aceptación y confirmar todos los servicios del bloque detenidos.

## Evidencias

- `05_evidencias/PREFLIGHT-BLOQUE-DOMESTICO-2026-11-06.txt`
- `05_evidencias/APLICACION-BLOQUE-DOMESTICO-2026-11-06.txt`
- `05_evidencias/CORRECCION-ACL-SFTPGO-2026-11-06.txt`
- `05_evidencias/CIERRE-BLOQUE-DOMESTICO-PAUSA-2026-11-06.txt`
- `05_evidencias/MANIFIESTO-BLOQUE-DOMESTICO-2026-11-06.txt`

La restauración `restic` aún no se ha ejecutado y no existe copia independiente ni cumplimiento 3-2-1.
