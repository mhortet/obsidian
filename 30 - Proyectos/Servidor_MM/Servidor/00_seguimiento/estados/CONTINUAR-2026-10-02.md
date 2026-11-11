# Continuación de `srv-mm-01` — 2026-10-02

## Punto seguro de reanudación

- Ubuntu Server 24.04.5 LTS instalado y arrancando correctamente mediante UEFI.
- Sistema en Samsung SSD 860 PRO 512 GB con LUKS2 y LVM.
- Frase LUKS nueva verificada mediante prueba y reinicio real.
- Clave de recuperación verificada y custodiada fuera del servidor; se eliminó la copia `/var/log/installer/recovery-key.txt`.
- Samsung SSD 860 PRO 1 TB intacto. No borrar, formatear ni montar con escritura sin nueva autorización expresa.
- Cuenta nominativa: `vicente`.
- SSH accesible únicamente mediante clave pública; contraseña, autenticación interactiva y acceso directo de `root` deshabilitados.
- IP temporal de preparación observada: `192.168.2.104/24` por DHCP en `eno1`.
- Solo SSH escucha externamente; no se han instalado MySQL, Samba, VPN ni servicios de aplicación.
- UFW permanece inactivo. No se dejó ninguna regla a medio aplicar.
- No se aplicaron las 15 actualizaciones pendientes ni la actualización de versión ofrecida a Ubuntu 26.04.1 LTS.

## Acceso desde el ordenador administrador

Desde PowerShell:

```powershell
ssh -o KexAlgorithms=curve25519-sha256 -i "$env:USERPROFILE\.ssh\id_ed25519_srv_mm" -o IdentitiesOnly=yes vicente@192.168.2.104
```

La frase solicitada es la de la clave SSH del ordenador administrador. Si la IP cambia por DHCP, consultar en la consola física:

```bash
hostname -I
```

No copiar la clave privada al proyecto ni al servidor.

## Evidencia disponible

- `ESTADO-INSTALACION-2026-10-01.md`: decisiones, cambios, pruebas y pendientes.
- `auditoria-srv-mm-01-2026-10-01.txt`: captura de solo lectura; SHA-256 `C1F3B1ADB9568E45197DCAECDE65D8444985538F58278C555CE1B9FFDD26CDE3`.
- `auditoria-linux-readonly.sh`: script usado para la captura.
- `00-srv-mm-ssh-hardening.conf`: configuración SSH aplicada.

## Próxima secuencia propuesta

No ejecutar cambios sin presentar antes propósito, riesgo, aceptación y reversión.

1. Comprobaciones de solo lectura:
   - revisar `ssh.socket` y activación de SSH;
   - localizar la referencia y el paquete de `pam_lastlog.so`;
   - comprobar Secure Boot;
   - confirmar si hay reinicio pendiente;
   - revisar la política real de actualizaciones automáticas.
2. Proponer y aprobar el ajuste de zona horaria a `Europe/Madrid`; mantener NTP activo y RTC en UTC.
3. Proponer y aprobar UFW:
   - denegar entrantes por defecto;
   - permitir salientes;
   - permitir temporalmente TCP/22 solo desde `192.168.2.0/24`;
   - mantener una sesión abierta, validar configuración y probar una segunda conexión;
   - reversión mediante consola local con `sudo ufw disable`.
4. Completar SSH con `MaxAuthTries 3` y `X11Forwarding no`, validar con `sshd -t`, recargar y probar una sesión nueva.
5. Proponer y aprobar las actualizaciones de Ubuntu 24.04. No ejecutar `do-release-upgrade`.
6. Instalar y ejecutar herramientas de estado SMART solo tras aprobación.
7. Diseñar antes de crear volúmenes LVM separados para MySQL y archivos compartidos.
8. Mantener el SSD de 1 TB intacto hasta aprobar su conversión en destino local de copias y definir antes formato, cifrado, retención y prueba de restauración.

## Estado operativo al cerrar

El servidor puede quedar encendido en la red doméstica de preparación: solo expone SSH, exige clave nominativa y no contiene todavía datos de producción. La ausencia de UFW sigue pendiente y debe resolverse antes de añadir servicios. Si se apaga, el siguiente arranque exigirá presencia local para introducir la frase LUKS.
