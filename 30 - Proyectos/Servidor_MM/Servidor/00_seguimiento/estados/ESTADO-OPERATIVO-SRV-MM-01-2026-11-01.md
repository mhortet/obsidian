---
title: "Estado operativo de srv-mm-01 tras reserva DHCP y reinicio"
type: register
status: active
created: 2026-11-01
updated: 2026-11-01
sources:
  - "ESTADO-ACCESO-SSH-Y-RED-2026-10-31.md"
tags: [auditoria, seguridad, administracion, mysql]
review_after: 2026-11-08
---

# Estado operativo de `srv-mm-01` — 2026-11-01

## Resultado ejecutivo

`srv-mm-01` quedó en un punto seguro y verificable después de corregir la identificación DHCP, reservar su dirección doméstica, detener/deshabilitar MySQL, completar un reinicio por actualizaciones automáticas y revalidar desde el puesto administrador.

No se modificaron Netplan, UFW, `sshd_config`, usuarios MySQL, esquemas, TLS, almacenamiento, firmware ni Secure Boot.

## Estado vigente

| Componente | Estado validado |
| --- | --- |
| Host | `srv-mm-01` |
| Kernel | `6.8.0-147-generic` |
| Interfaz | `eno1`, MAC `74:fe:48:67:be:cc` |
| Red temporal | `192.168.1.31/24`, reserva DHCP doméstica |
| Gateway/DNS | `192.168.1.1` |
| SSH | `ssh.socket` enabled/active, TCP/22 accesible por clave |
| UFW | enabled/active |
| MySQL | 8.4.11, disabled/inactive, proceso ausente |
| Puertos | 22 accesible; 3306, 33060 y 445 no accesibles desde Windows |
| Reinicio | no pendiente |
| Unidades fallidas | ninguna |
| MySQL LV | `/var/lib/mysql`, 63 GiB, aproximadamente 62 GiB libres |
| Compartido LV | `/srv/compartido`, 220 GiB, aproximadamente 218 GiB libres |

## Evidencia y decisiones

### Identidad y reserva DHCP

- `192.168.1.30` resolvía a `a8:80:55:78:07:39`, no al servidor.
- Un sondeo ICMP/ARP limitado a la LAN localizó `74:fe:48:67:be:cc` en `192.168.1.31`.
- `.31` presentó la misma clave SSH previamente conocida y respondió como `vicente@srv-mm-01`.
- El propietario creó en el router una reserva DHCP `.31` para la MAC de `eno1`.
- Tras reiniciar, `.31` volvió a asignarse a la misma MAC, validando la reserva.

La dirección sigue siendo DHCP y así debe aparecer en Ubuntu. La estabilidad la gobierna la reserva del router. Esta IP pertenece a la red doméstica temporal y no es un dato de producción.

### UFW y accesibilidad

Antes del reinicio, `sudo ufw status numbered` mostró:

1. TCP/22 desde `192.168.1.0/24`, validado en la LAN doméstica.
2. TCP/22 desde `192.168.0.0/24`, subred del cliente aún no validada en sede.

No había reglas MySQL ni SMB. Después del reinicio, UFW seguía enabled/active y las pruebas desde `192.168.1.107` devolvieron:

- TCP/22: accesible;
- TCP/3306: cerrado/filtrado;
- TCP/33060: cerrado/filtrado;
- TCP/445: cerrado/filtrado.

### MySQL

Al reanudar se descubrió que MySQL había arrancado automáticamente porque la unidad estaba enabled. El servicio escuchaba en `*:3306` y `*:33060`, aunque UFW impedía alcanzarlo desde el puesto administrador.

La auditoría privilegiada confirmó:

- versión 8.4.11;
- cuentas internas bloqueadas y `root@localhost` mediante `auth_socket`;
- sin cuentas Qontrolmed;
- `bind_address=*`;
- `mysqlx_port=33060`;
- `require_secure_transport=OFF`;
- `skip_name_resolve=OFF`;
- TLS 1.2/1.3 disponible, pero no obligatorio;
- sin ajustes explícitos coincidentes en `/etc/mysql/mysql.conf.d` ni `/etc/mysql/conf.d`.

No había conexiones MySQL establecidas. Con aprobación explícita se ejecutó:

```bash
sudo systemctl disable --now mysql
```

Aceptación comprobada antes y después del reinicio:

```text
disabled
inactive
MYSQLD_PROCESS_ABSENT
MYSQL_PORTS_CLOSED
```

### Actualizaciones y reinicio

`unattended-upgrade` comenzó automáticamente a las 18:10. Actualizó, entre otros, systemd, OpenSSH y el kernel 6.8.0-147. No fue iniciado por los comandos de auditoría ni incluyó la actualización disponible de MySQL 8.4.13.

Tras comprobar `dpkg --audit`, ausencia de operaciones APT/dpkg activas, archivos de kernel/initrd y estado `running`, se aprobó y ejecutó un reinicio controlado.

Validación posterior:

- kernel `6.8.0-147-generic` activo;
- `NO_REBOOT_REQUIRED`;
- sin unidades fallidas;
- IP/MAC/reserva, SSH y UFW correctos;
- MySQL permaneció disabled/inactive;
- montajes y espacio correctos.

## Riesgos abiertos

1. MySQL no puede arrancarse en producción con sus valores predeterminados: escucha en todas las interfaces, habilita 33060 y no obliga TLS.
2. Qontrolmed todavía no verifica CA/identidad TLS ni tiene timeouts completos según la revisión documental.
3. Conceder `CREATE USER` a una cuenta de provisión permite también modificar o eliminar cuentas regulares; debe aislarse tras SSH y limitarse mediante roles.
4. La política de `unattended-upgrades` necesita una decisión operativa sobre ventanas, avisos y reinicios.
5. La entrada `known_hosts` está asociada históricamente a `.30`; `.31` se validó usando `HostKeyAlias=.30`, pero falta normalizarla.
6. La LAN de producción `192.168.0.0/24` continúa incompleta y no validada.

## Reversión del cambio MySQL

Restaurar únicamente el arranque automático, sin iniciar el servicio:

```bash
sudo systemctl enable mysql
```

No usar `enable --now` hasta validar configuración, TLS, cuentas, UFW, copia y restauración.
