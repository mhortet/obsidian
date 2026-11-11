# Estado de instalación de `srv-mm-01` — 2026-10-02

Fecha: 2026-10-02 (Europe/Madrid)

## Resultado del segundo día

- Acceso administrativo desde el ordenador de preparación normalizado mediante `ssh-agent` de Windows con inicio manual.
- Clave SSH específica cargada sin copiar ni registrar su frase.
- Zona horaria del servidor cambiada a `Europe/Madrid`; NTP permanece activo y el RTC continúa en UTC.
- UFW activado con política de entrada denegada y salida permitida.
- SSH permitido desde la LAN temporal `192.168.2.0/24` al puerto TCP/22.
- SSH completado con `MaxAuthTries 3` y `X11Forwarding no`.
- Acceso mediante clave validado en una conexión nueva; acceso por contraseña rechazado.
- Se instalaron correctamente las 15 actualizaciones previamente simuladas y aprobadas.
- No quedan paquetes actualizables según los índices del 2026-10-02 y no hay reinicio pendiente.
- Se instaló `smartmontools 7.4-2build1` y se capturó SMART de ambos SSD sin lanzar autotests.

## Recuperación del cambio

- Copia previa y script de reversión: `/root/srv-mm-change-20261002-01`.
- Desde la consola física:

```bash
sudo /root/srv-mm-change-20261002-01/rollback.sh
```

La reversión restaura la zona horaria, los archivos UFW y la configuración SSH anteriores, recarga SSH y desactiva UFW.

## Estado que no cambia

- Ubuntu Server 24.04.5 LTS sigue en el SSD Samsung de 512 GB con LUKS2 y LVM.
- El SSD Samsung de 1 TB permanece intacto.
- No se han creado volúmenes LVM adicionales.
- No se instalaron servicios nuevos ni se realizó una actualización de versión.
- No se configuraron MySQL, Samba, VPN, copias o servicios de aplicación.
- La red `192.168.2.0/24` y la IP `192.168.2.104` siguen siendo temporales y no deben trasladarse al cliente.

## Hallazgos pendientes

- Secure Boot está deshabilitado; tratarlo como cambio separado de firmware con presencia física.
- La referencia opcional a `pam_lastlog.so` continúa en `/etc/pam.d/login`, aunque el módulo no existe y el archivo pertenece sin modificaciones al paquete `login`. El aviso reapareció al iniciar sesión en la consola local después de actualizar; no editar PAM sin una propuesta separada.
- AppArmor emitió `Illegal number: yes` al recargar perfiles. El módulo está habilitado, el servicio permanece activo y `kernel.apparmor_restrict_unprivileged_userns=1`. Coincide con el fallo confirmado de Ubuntu [Launchpad #2105840](https://bugs.launchpad.net/ubuntu/+source/apparmor/+bug/2105840), provocado porque el script compara numéricamente el valor textual `yes`. No editar el script empaquetado.
- Deben diseñarse los volúmenes LVM para MySQL y archivos antes de consumir el espacio libre.

## Próximo bloque propuesto

1. Diseñar los volúmenes LVM para MySQL y archivos compartidos antes de crearlos.
2. Definir la política de monitorización SMART, alertas y autotests; `smartd` quedó habilitado por defecto, pero no tiene todavía alertas configuradas.
3. Resolver o aceptar documentalmente el aviso de PAM antes de producción, sin modificar el subsistema de autenticación de forma improvisada.
4. Tratar Secure Boot como cambio separado de firmware con presencia física.

## Evidencia APT

- Captura: `apt-simulacion-srv-mm-01-2026-10-02.txt`.
- SHA-256: `43CA242092D84E728FCFFC7C10AAE3014D8EE0E7B53A2EF521BA8EB20FE9D2C8`.
- Paquetes propuestos: AppArmor, auditoría, bibliotecas Kerberos, Netplan, `dmidecode` y `sosreport`.
- No se proponen kernel, `systemd`, OpenSSH, paquetes nuevos, eliminaciones ni cambio a Ubuntu 26.04.

## Resultado de la actualización

- Registro: `apt-upgrade-srv-mm-01-2026-10-02.txt`.
- SHA-256: `BE4F481A8D715D6DC6E2DA930198E42F6CE3DC782C2CD47E0B66CC2F439CBF14`.
- Resultado: 15 actualizados, 0 nuevos, 0 eliminados y 0 retenidos.
- `dpkg --audit` y `dpkg -C` no devolvieron incidencias.
- No quedan paquetes actualizables y no se requiere reinicio.
- Cero unidades de systemd fallidas.
- La sesión SSH previa sobrevivió y una conexión nueva funcionó mediante clave después del reinicio de `ssh.service` y `systemd-networkd.service`.
- La autenticación SSH por contraseña continúa rechazada.
- Red temporal, ruta, hora, UFW y configuración efectiva de SSH se conservaron.

## Estado SMART de almacenamiento

- Evidencia: `smart-srv-mm-01-2026-10-02.txt`.
- SHA-256: `4F081CD54178C57DBAB937C83622916335ABBBE647344FEBBA060F502DBB72D7`.
- `/dev/sda`, Samsung SSD 860 PRO 512 GB: SMART `PASSED`, 5.303 horas, 796 ciclos, 29 °C, máximo histórico 49 °C, 0 sectores reasignados, 0 errores incorregibles, 0 errores CRC y 1 % de resistencia consumida.
- `/dev/sdb`, Samsung SSD 860 PRO 1 TB: SMART `PASSED`, 5.414 horas, 836 ciclos, 29 °C, máximo histórico 44 °C, 0 sectores reasignados, 0 errores incorregibles, 0 errores CRC y 0 % de resistencia consumida.
- No constan autotests SMART previos en ninguno de los dos discos y no se inició ninguno en esta jornada.
- `smartd` quedó habilitado y activo por comportamiento predeterminado del paquete; detecta y monitoriza ambos SSD, pero aún no se han definido avisos ni calendario de autotests.
- El SSD de 1 TB conserva sus particiones anteriores y no se montó ni escribió para esta captura.
