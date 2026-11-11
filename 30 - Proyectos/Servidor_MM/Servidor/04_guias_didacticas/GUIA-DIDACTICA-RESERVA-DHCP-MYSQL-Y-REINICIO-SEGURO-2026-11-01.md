---
title: "Guía didáctica: reserva DHCP, contención MySQL y reinicio seguro"
type: process
status: active
created: 2026-11-01
updated: 2026-11-01
sources:
  - "ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md"
tags: [seguridad, aprendizaje, documentacion, mysql]
review_after: 2027-05-01
---

# Guía didáctica: reserva DHCP, contención MySQL y reinicio seguro

Esta guía explica lo ocurrido en `srv-mm-01` el 2026-11-01 y convierte la intervención en un procedimiento reutilizable. No es una receta para copiar direcciones o reglas en otro servidor.

## 1. El problema inicial

El día anterior el servidor había recibido `192.168.1.30` mediante DHCP. Al volver a trabajar, esa dirección respondía al ping, pero TCP/22 no estaba disponible y ARP mostraba una MAC diferente.

La lección es importante: **una IP que respondió ayer no demuestra que hoy identifique al mismo equipo**.

Se comparó la MAC esperada de `eno1`:

```text
74:fe:48:67:be:cc
```

con la tabla ARP. El servidor apareció en `192.168.1.31`; `.30` pertenecía a otro dispositivo.

## 2. Cómo se demostró la identidad

Se usaron controles independientes:

1. La MAC de `.31` coincidía con `eno1`.
2. TCP/22 estaba disponible.
3. SSH presentó la misma clave de host conocida.
4. Dentro de la sesión respondieron `vicente`, `srv-mm-01` y `192.168.1.31/24`.

Para verificar la clave sin aceptar automáticamente una nueva entrada se utilizó temporalmente:

```powershell
ssh -o HostKeyAlias=192.168.1.30 `
    -o StrictHostKeyChecking=yes `
    -o KexAlgorithms=curve25519-sha256 `
    -o IdentitiesOnly=no `
    vicente@192.168.1.31
```

`HostKeyAlias` indica al cliente que compare el servidor nuevo con la clave ya guardada bajo la dirección anterior. Es una medida transitoria; después debe normalizarse `known_hosts`.

## 3. Reserva DHCP frente a IP estática

Ubuntu seguía correctamente configurado como cliente DHCP. La concesión observada era:

```text
ADDRESS=192.168.1.31
NETMASK=255.255.255.0
ROUTER=192.168.1.1
DNS=192.168.1.1
LIFETIME=1d
T1=12h
T2=21h
```

### Reserva DHCP

El router asocia una IP a una MAC y vuelve a entregar la misma dirección. Ventajas:

- centraliza la administración;
- Ubuntu conserva gateway y DNS automáticos;
- evita mantener Netplan manualmente;
- reduce errores al cambiar parámetros de red.

El servidor sigue mostrando `proto dhcp`; eso no significa que la reserva haya fallado.

### IP estática en Netplan

Solo es preferible cuando el router no puede reservar o existe una política de red que lo exige. Antes hacen falta IP, máscara, gateway, DNS, rango/exclusión DHCP, VLAN y comprobación de conflicto.

### Aceptación utilizada

Después del reinicio:

- `.31` volvió a asociarse con la MAC correcta;
- gateway y DNS siguieron siendo `.1`;
- SSH abrió una sesión nueva.

Esto validó la reserva sin modificar Netplan.

## 4. Por qué MySQL arrancó solo

El estado histórico era `enabled` pero `inactive`. Esto parece seguro mientras el servidor no reinicia, pero `enabled` significa:

> systemd debe iniciar el servicio automáticamente durante el arranque.

Tras arrancar el servidor, MySQL quedó `active` y escuchando en:

```text
*:3306
*:33060
```

No fue un acceso externo ni un fallo de UFW; fue el comportamiento esperado de una unidad habilitada.

## 5. Escuchar no equivale a ser alcanzable

Se deben distinguir dos capas:

- **Socket:** MySQL estaba escuchando en todas las interfaces.
- **Firewall:** UFW no tenía reglas 3306/33060 y bloqueaba el acceso desde Windows.

Las pruebas externas devolvieron:

```text
PORT_22=True
PORT_3306=False
PORT_33060=False
PORT_445=False
```

UFW reducía el riesgo, pero mantener un servicio innecesario escuchando añade superficie de ataque, consumo y posibilidad de exposición accidental futura.

## 6. Qué reveló la auditoría de MySQL

La auditoría no mostró secretos. Confirmó:

```text
VERSION()                 8.4.11
bind_address              *
mysqlx_port               33060
require_secure_transport  OFF
skip_name_resolve         OFF
tls_version               TLSv1.2,TLSv1.3
```

### Interpretación

- `bind_address=*`: escucha en todas las interfaces disponibles.
- `mysqlx_port=33060`: X Plugin está habilitado aunque Qontrolmed usa el protocolo clásico 3306.
- `require_secure_transport=OFF`: TLS puede estar disponible, pero no es obligatorio.
- `skip_name_resolve=OFF`: MySQL puede resolver nombres para comparar orígenes; si se diseñan cuentas por IP se valorará activarlo.
- TLS 1.2/1.3 disponible no significa que el cliente verifique la identidad del servidor.

Solo existían cuentas internas bloqueadas y `root@localhost` con `auth_socket`; no había usuarios Qontrolmed.

## 7. Detención y deshabilitación controladas

Antes del cambio se comprobó que no existían conexiones MySQL establecidas.

### Propósito

Cerrar el servicio y evitar que reaparezca tras otro reinicio.

### Riesgo

Interrumpir conexiones existentes y eliminar el arranque automático. No había conexiones ni aplicaciones configuradas.

### Cambio aprobado

```bash
sudo systemctl disable --now mysql
```

- `--now` detiene el servicio inmediatamente.
- `disable` elimina el enlace que lo inicia automáticamente.

### Aceptación

```bash
systemctl is-enabled mysql
systemctl is-active mysql
pgrep -a -x mysqld || echo MYSQLD_PROCESS_ABSENT
sudo ss -ltnp | grep -E ':(3306|33060)([[:space:]]|$)' || echo MYSQL_PORTS_CLOSED
```

Resultado:

```text
disabled
inactive
MYSQLD_PROCESS_ABSENT
MYSQL_PORTS_CLOSED
```

### Reversión

```bash
sudo systemctl enable mysql
```

Esto restaura el arranque automático, pero no inicia MySQL. No debe usarse `enable --now` hasta aprobar y validar la configuración definitiva.

## 8. Actualizaciones automáticas y aviso de reinicio

Al inicio no había aviso de reinicio. Más tarde apareció porque `unattended-upgrade` ejecutó automáticamente actualizaciones de seguridad, entre ellas:

- systemd;
- OpenSSH;
- kernel 6.8.0-147;
- bibliotecas de seguridad.

La secuencia temporal de `/var/log/apt/history.log` y `/var/log/dpkg.log` permitió demostrar que no las iniciaron los comandos de auditoría.

Un aviso MOTD debe verificarse con:

```bash
if test -e /var/run/reboot-required; then
  cat /var/run/reboot-required
  cat /var/run/reboot-required.pkgs 2>/dev/null || true
else
  echo NO_REBOOT_REQUIRED
fi
```

## 9. Preflight antes de reiniciar

Antes de un reinicio se comprobó:

- `dpkg --audit` sin errores;
- sin procesos APT/dpkg aplicando paquetes;
- kernel e `initrd` nuevos presentes;
- sistema `running` y sin unidades fallidas;
- MySQL disabled/inactive;
- reserva DHCP creada;
- consola física disponible.

### Propósito

Cargar el kernel nuevo y finalizar las actualizaciones.

### Riesgo

Pérdida temporal de SSH o fallo de arranque/red.

### Reversión

Si el kernel nuevo falla, usar la consola física y seleccionar el kernel anterior en las opciones avanzadas de GRUB.

### Cambio

```bash
sudo systemctl reboot
```

## 10. Validación posterior al reinicio

No basta con comprobar que aparece la pantalla de login. Se validó desde otro equipo:

1. ping y ARP;
2. MAC correcta en `.31`;
3. TCP/22 accesible;
4. conexión SSH por clave;
5. `uname -r` igual a `6.8.0-147-generic`;
6. UFW y SSH activos;
7. MySQL disabled/inactive;
8. 3306/33060 cerrados;
9. sin unidades fallidas ni reinicio pendiente;
10. montajes y espacio correctos.

## 11. Diseño futuro para cuatro puestos Qontrolmed

El modelo propuesto es adecuado para una LAN pequeña si se aplican varias capas:

- reserva DHCP para cada puesto;
- UFW TCP/3306 limitado a IP exactas `/32`;
- cuenta MySQL distinta por puesto y host exacto;
- rol de operación con privilegios mínimos;
- rol separado para migraciones;
- X Plugin deshabilitado;
- TLS obligatorio y verificación de CA/identidad;
- administración con Workbench sobre SSH;
- root remoto prohibido;
- copia y restauración verificadas.

La cuenta que disponga de `CREATE USER` puede modificar o eliminar cuentas regulares. Debe ser una identidad separada, utilizada solo desde el canal administrativo y sin privilegios globales innecesarios.

## 12. Checklist reutilizable

### Antes

- [ ] Identidad del servidor confirmada por MAC y clave de host.
- [ ] Consola física o recuperación disponible.
- [ ] IP, gateway y DNS inventariados.
- [ ] Estado de servicios y puertos leído.
- [ ] Conexiones activas comprobadas.
- [ ] Propósito, riesgo, aceptación y reversión escritos.

### Durante

- [ ] Un cambio acotado cada vez.
- [ ] Sesión de recuperación conservada.
- [ ] No introducir secretos en el chat o repositorio.
- [ ] Detenerse si la evidencia no coincide con lo esperado.

### Después

- [ ] Validar desde el servidor y desde otro equipo.
- [ ] Confirmar puertos permitidos y denegados.
- [ ] Revisar unidades fallidas, reinicio y montajes.
- [ ] Actualizar estado, diario y relevo.
- [ ] Archivar, no borrar, el documento sustituido.
