---
title: "Estado del acceso SSH y preparación de red de srv-mm-01"
type: register
status: active
created: 2026-10-31
updated: 2026-10-31
sources:
  - "CONTINUAR-SIGUIENTE-SESION.md"
tags: [seguridad, administracion, documentacion]
review_after: 2026-11-07
---

# Estado del acceso SSH y preparación de red de `srv-mm-01`

Fecha de intervención: 2026-10-31 (`Europe/Madrid`)  
Ámbito autorizado: recuperar el acceso SSH desde la nueva LAN de preparación y dejar preautorizada la subred comunicada por el cliente  
Resultado: **cambio aplicado y validado en la LAN de preparación; configuración definitiva del cliente pendiente**

## 1. Resumen ejecutivo

El cambio de operador sustituyó la red de preparación `192.168.2.0/24` por `192.168.1.0/24`. El servidor obtuvo por DHCP la dirección temporal `192.168.1.30/24` en `eno1`, con puerta de enlace observada `192.168.1.1`.

La identidad del equipo se contrastó mediante la MAC `74:fe:48:67:be:cc`, coincidente con la interfaz `eno1` documentada de `srv-mm-01`. Inicialmente el servidor respondía a ICMP, pero TCP/22 no era alcanzable porque UFW conservaba exclusivamente la autorización para `192.168.2.0/24`.

Se autorizó SSH desde `192.168.1.0/24`, se verificó una conexión nueva mediante clave, se comprobó el rechazo de autenticación por contraseña y se retiró la regla obsoleta `192.168.2.0/24`.

El cliente ha comunicado que su red utiliza `192.168.0.0/24`. Se dejó preautorizada esa subred únicamente para TCP/22, pero todavía no se ha asignado una dirección de producción ni se ha validado acceso desde ella. Falta confirmar IP reservada, puerta de enlace, rango DHCP, DNS, posible VLAN, ausencia de conflictos y origen de administración.

## 2. Estado observado antes del cambio

- Host: `srv-mm-01`.
- Interfaz activa: `eno1`.
- Dirección temporal nueva: `192.168.1.30/24`, obtenida por DHCP.
- Puerta de enlace observada: `192.168.1.1`.
- MAC de `eno1`: `74:fe:48:67:be:cc`.
- `ssh.socket`: activo y escuchando en `0.0.0.0:22` y `[::]:22` mediante PID 1 (`systemd`).
- `ssh.service`: inactivo antes de iniciar una conexión, coherente con activación por socket.
- UFW: activo, con una única regla TCP/22 desde `192.168.2.0/24`.
- `sudo sshd -t`: fallaba inicialmente con `Missing privilege separation directory: /run/sshd`.

## 3. Cambios aplicados

### 3.1. Directorio temporal de separación de privilegios

Se creó `/run/sshd` con propietario `root:root` y modo `0755`:

```bash
sudo install -d -o root -g root -m 0755 /run/sshd
```

Después:

```bash
sudo sshd -t
echo $?
```

Resultado: `sshd -t` sin salida y código `0`.

El directorio está bajo `/run`, un sistema de archivos temporal. No se modificó `sshd_config`, no se recargó SSH y no se cambió el modelo de activación por `ssh.socket`.

### 3.2. Copia previa de UFW

Se conservó el estado anterior en:

```text
/root/srv-mm-change-20261031-red/
```

Contenido confirmado:

- `user.rules`;
- `user6.rules`;
- `ufw-before.txt`.

Esta copia representa el estado anterior al cambio, cuando solo estaba autorizada `192.168.2.0/24`. Restaurarla íntegramente recuperaría esa regla antigua; no representa el estado final actual.

### 3.3. Reglas de acceso SSH

Cambios realizados, por orden:

1. Se añadió TCP/22 desde `192.168.1.0/24`.
2. Se mantuvo temporalmente `192.168.2.0/24` como recuperación.
3. Se validó acceso nuevo desde `192.168.1.0/24`.
4. Se comprobó que la contraseña seguía rechazada.
5. Se eliminó `192.168.2.0/24`.
6. Se verificó de nuevo que TCP/22 continuaba accesible en `192.168.1.30`.
7. Se añadió TCP/22 desde la futura subred del cliente `192.168.0.0/24`.

Estado UFW comunicado al cierre:

| Puerto | Acción | Origen | Finalidad | Validación |
| --- | --- | --- | --- | --- |
| TCP/22 | `ALLOW IN` | `192.168.1.0/24` | Administración desde la LAN actual de preparación | Validada con TCP y SSH por clave |
| TCP/22 | `ALLOW IN` | `192.168.0.0/24` | Preparación para la LAN comunicada por el cliente | No validada todavía desde esa LAN |

No se creó ninguna regla para MySQL, SMB, SFTP ni otros servicios. No se abrió ningún puerto en el router ni se autorizó SSH desde Internet.

## 4. Pruebas de aceptación realizadas

- `192.168.1.30` respondió y su MAC coincidió con `eno1`.
- TCP/22 pasó de inaccesible a accesible tras añadir la nueva regla UFW.
- Se abrió una sesión SSH nueva como `vicente` mediante la clave dedicada.
- Dentro de la sesión se validaron `vicente`, `srv-mm-01` y `eno1` con `192.168.1.30/24`.
- Una conexión forzada sin clave pública devolvió `Permission denied (publickey)`.
- Tras retirar `192.168.2.0/24`, `Test-NetConnection 192.168.1.30 -Port 22` devolvió `TcpTestSucceeded : True`.
- La sesión existente permaneció como recuperación durante las comprobaciones.

No se incorpora a este documento ninguna clave, frase secreta ni contraseña. La huella mostrada por `ssh-add -l` corresponde a la identidad pública del cliente y no sustituye la comprobación independiente de la clave de host del servidor.

## 5. Reversión

### Retirar solo la autorización de la futura LAN del cliente

```bash
sudo ufw delete allow proto tcp from 192.168.0.0/24 to any port 22
```

### Retirar solo la autorización de la LAN actual

Debe hacerse únicamente desde consola física o después de validar otro camino administrativo:

```bash
sudo ufw delete allow proto tcp from 192.168.1.0/24 to any port 22
```

### Restauración integral de la copia anterior

Solo para recuperación controlada, porque recupera la red obsoleta `192.168.2.0/24`:

```bash
sudo cp -a /root/srv-mm-change-20261031-red/user.rules /etc/ufw/user.rules
sudo cp -a /root/srv-mm-change-20261031-red/user6.rules /etc/ufw/user6.rules
sudo ufw reload
```

Como último recurso desde consola física puede usarse `sudo ufw disable`, pero dejaría temporalmente el servidor sin la protección de UFW y exige corregir y reactivar inmediatamente.

## 6. Pendientes antes de trasladar el servidor

1. Confirmar con el cliente:
   - IP concreta y libre para `srv-mm-01`;
   - máscara, actualmente comunicada como `/24`;
   - puerta de enlace;
   - rango DHCP;
   - DNS;
   - capacidad de reservar por MAC `74:fe:48:67:be:cc`;
   - VLAN o segmentación;
   - equipo o dirección de administración autorizada.
2. Preferir reserva DHCP en el router si el responsable de red puede gestionarla.
3. No asumir `192.168.0.30` por semejanza con la dirección temporal actual.
4. Al conectar en la sede, identificar la concesión real desde consola física antes de probar acceso remoto.
5. Mantener `192.168.1.0/24` hasta finalizar la migración y validar una conexión nueva desde la red del cliente.
6. Tras aceptar la red definitiva, retirar la regla temporal `192.168.1.0/24`.
7. Revalidar MySQL detenido y 3306/33060 cerrados; este cambio no autoriza arrancarlo ni abrirlo.

## 7. Estado de seguridad al cierre

- SSH continúa limitado a claves públicas; root, contraseña y teclado interactivo permanecen deshabilitados según la configuración previamente validada.
- UFW continúa activo con entrada denegada por defecto y autorizaciones SSH de origen limitado.
- La subred `192.168.0.0/24` está confirmada solo como rango comunicado por el cliente, no como configuración de producción completa.
- La dirección `192.168.1.30/24` es temporal y no debe incorporarse a Qontrolmed, certificados, DNS ni documentación de producción.
- MySQL, almacenamiento, firmware, Secure Boot, usuarios y servicios de aplicación quedaron fuera del cambio.

