---
title: "Inicio de fase posterior a la aceptación sin datos del cliente"
type: process
status: active
created: 2026-11-06
updated: 2026-11-06
sources:
  - "../02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "../00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "../CONTINUAR-SIGUIENTE-SESION.md"
tags: [documentacion, seguridad, administracion, testing]
review_after: 2026-11-13
---

# Inicio de la próxima sesión

## Objetivo

Ejecutar únicamente la parte de solo lectura y preparación local del plan posterior a la aceptación doméstica. No cambiar el servidor. El resultado de la sesión será una auditoría fechada, artefactos locales revisados y, si procede, una propuesta separada de cambios técnicos.

## Documentos de apertura

Leer en este orden:

1. `AGENTS.md`.
2. `CONTINUAR-SIGUIENTE-SESION.md`.
3. `00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md`.
4. `02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md`.
5. `DOCUMENTACION-SERVIDOR-UBUNTU.md`.

El nuevo plan está `proposed`. La próxima sesión puede realizar auditoría de solo lectura y trabajo local; no debe interpretar este runbook como aprobación de cambios remotos.

## Secuencia

### 1. Comprobación local

1. Confirmar fecha/zona horaria y ruta del proyecto.
2. Comprobar que FortiClient no altera rutas si se valida la LAN.
3. Confirmar que el agente SSH está vacío antes de comenzar.
4. Verificar TCP/22 hacia la dirección doméstica documentada sin explorar otras máquinas.
5. Cargar `id_ed25519_srv_mm` solo con intervención local del propietario y sin registrar su frase.

### 2. Revalidación remota de cierre

Con clave de host estricta y sin aceptar claves nuevas:

- hostname, fecha, kernel y reinicio pendiente;
- unidades fallidas;
- MySQL, SFTPGo y `cloudflared` inactivos con estados de habilitación esperados;
- SSH/UFW activos;
- procesos y listeners;
- montajes, espacio, propietario, modo y ACL de `/srv/compartido`;
- hash de `90-qontrolmed-piloto.cnf`;
- hash de la evidencia final de aceptación.

Abortar el trabajo dependiente si SFTPGo/MySQL/Cloudflare están activos, aparece un puerto nuevo, cambia la ACL/hash o hay unidades fallidas.

### 3. Auditoría de instalación sin arrancar servicios

Recoger y depurar:

- `dpkg-query`, `apt-cache policy` y fuentes APT de SFTPGo, `cloudflared`, `restic` y `acl`;
- `systemctl cat/show` de SFTPGo y Cloudflare;
- `systemd-analyze verify` y `systemd-analyze security`;
- propietarios/modos de configuración, SQLite, logs y hoja ficticia;
- lista de archivos de idioma instalados;
- errores recientes relevantes de `journalctl`, sin copiar usuarios, direcciones o contenido documental a la evidencia;
- espacio consumido por repositorio ficticio, SQLite y ensayo `restic`, sin leer secretos root.

No ejecutar `sftpgo dumpdata`, no copiar SQLite y no mostrar variables, contraseñas, TOTP, cookies o tokens.

### 4. Revisión local

1. Revisar scripts de aplicación, aceptación, reversión y ACL.
2. Añadir una prueba de regresión del retorno de `assert_mysql_safe`.
3. Diseñar el script de salud de solo lectura con fixtures.
4. Preparar plantillas `systemd` deshabilitadas y marcadas `NO INSTALADO`.
5. Preparar matriz de copia externa y parámetros del cliente.
6. Actualizar o crear runbooks operativos sin duplicar el documento maestro.

### 5. Clasificación de hallazgos

Para cada hallazgo registrar:

- hecho observado y comando/fuente;
- impacto y confianza;
- si requiere cambio;
- dependencia de datos del cliente;
- prueba de aceptación y reversión propuestas.

No corregir el hallazgo en el servidor durante esta sesión.

### 6. Cierre

1. Revalidar que los servicios y puertos coinciden con la apertura.
2. Confirmar que ningún archivo remoto cambió.
3. Cerrar conexiones y retirar la identidad SSH.
4. Ejecutar lint y tags de Obsidian si se crean notas o estructura.
5. Actualizar diario, estado, maestro y `CONTINUAR-SIGUIENTE-SESION.md`.
6. Presentar una propuesta de cambios separada solo si la evidencia la justifica.

## Condiciones de parada

- diferencia respecto al cierre aceptado;
- solicitud de `sudo` para una acción modificadora;
- riesgo de mostrar secretos o datos personales;
- necesidad de arrancar servicios;
- dependencia de dominio, identidad, red, copia externa o recuperación no confirmados;
- cambio que afecte UFW, SSH, red, LUKS, disco, BIOS o paquetes;
- ausencia de reversión verificable.

## Resultado esperado

- auditoría posterior a aceptación con evidencia depurada;
- registro priorizado de brechas;
- artefactos locales no instalados y probados;
- propuesta exacta del siguiente bloque o declaración justificada de que no se requieren cambios;
- servidor en el mismo estado seguro.

## Prompt de arranque

> Continúa desde `CONTINUAR-SIGUIENTE-SESION.md` y sigue `03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md`. Asume que siguen faltando los datos del cliente. Ejecuta solo auditoría remota de lectura y preparación local; no arranques servicios ni cambies el servidor. Separa hechos, inferencias, recomendaciones y pendientes. Si aparece una mejora remota, prepara un plan técnico exacto y detente antes de aplicarla.
