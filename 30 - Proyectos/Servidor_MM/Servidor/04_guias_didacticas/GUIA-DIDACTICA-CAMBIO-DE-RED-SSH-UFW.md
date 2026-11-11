---
title: "Guía didáctica para cambiar de red un servidor Ubuntu con SSH y UFW"
type: process
status: active
created: 2026-10-31
updated: 2026-10-31
sources:
  - "ESTADO-ACCESO-SSH-Y-RED-2026-10-31.md"
tags: [seguridad, aprendizaje, documentacion]
review_after: 2027-04-30
---

# Guía didáctica para cambiar de red un servidor Ubuntu con SSH y UFW

Esta guía explica, desde un nivel inicial, el procedimiento seguido el 2026-10-31 para recuperar el acceso SSH a `srv-mm-01` después de cambiar la red local. Incluye el significado de los comandos, los riesgos y una secuencia reutilizable.

No es una receta universal para copiar sin revisar. Las direcciones, interfaces, usuarios y políticas pertenecen a este caso. En otro servidor deben confirmarse antes de ejecutar cambios.

## 1. Qué cambió realmente

Antes, el servidor estaba en esta red de preparación:

```text
Red:       192.168.2.0/24
Servidor:  192.168.2.104
```

Después del cambio de operador, el router empezó a utilizar:

```text
Red:       192.168.1.0/24
Servidor:  192.168.1.30
```

El servidor recibió una dirección nueva mediante DHCP y respondía al ping. Sin embargo, UFW solo permitía SSH desde la red antigua. El servidor existía y SSH escuchaba, pero el cortafuegos descartaba las conexiones originadas en la nueva LAN.

La solución no consistió en «abrir SSH para todos», sino en sustituir de forma controlada el origen autorizado, conservando recuperación y pruebas en cada etapa.

## 2. Conceptos fundamentales

### 2.1. Dirección IP

Una IPv4 como `192.168.1.30` identifica una interfaz dentro de una red. Las direcciones `192.168.x.x` son privadas: se utilizan dentro de redes locales y normalmente no son accesibles directamente desde Internet.

### 2.2. Prefijo `/24`

`192.168.1.30/24` equivale a máscara `255.255.255.0`. En este caso:

- la red es `192.168.1.0`;
- los hosts habituales van de `192.168.1.1` a `192.168.1.254`;
- `192.168.1.255` es la dirección de difusión;
- todos los equipos del mismo `/24` pueden comunicarse directamente si firewall y segmentación lo permiten.

`192.168.1.0/24` representa toda la subred. `192.168.1.30/32` representaría un único host.

### 2.3. DHCP frente a IP fija

DHCP permite que el router entregue automáticamente IP, máscara, puerta de enlace y DNS. Es cómodo, pero la IP puede cambiar.

Para un servidor se necesita una dirección estable. Las opciones habituales son:

1. **Reserva DHCP:** el router entrega siempre la misma IP a una MAC concreta. Suele ser la opción más fácil de gobernar.
2. **Configuración estática en Ubuntu:** el servidor fija su propia IP. Exige conocer DHCP, puerta de enlace y DNS para evitar conflictos.

Nunca se debe convertir una concesión casual en IP fija sin comprobar que está libre y fuera del rango dinámico o correctamente reservada.

### 2.4. Dirección MAC

La MAC identifica la interfaz de red a nivel local. En este caso `eno1` utiliza:

```text
74:fe:48:67:be:cc
```

Se utilizó para demostrar que `192.168.1.30` correspondía realmente al servidor documentado y no a otro dispositivo que respondiera al ping.

### 2.5. Puerta de enlace

La puerta de enlace es el router al que se envía el tráfico destinado a otras redes. En la red actual se observó `192.168.1.1`. No debe suponerse que en la sede del cliente será `192.168.0.1`; hay que confirmarlo.

### 2.6. Puerto TCP/22

Una IP identifica un equipo y un puerto identifica un servicio. SSH utiliza normalmente TCP/22.

- Que el ping funcione solo demuestra conectividad IP básica.
- Que TCP/22 responda demuestra que la ruta y el firewall permiten llegar al punto donde escucha SSH.
- Todavía falta superar la autenticación SSH.

### 2.7. UFW

UFW es una interfaz simplificada para administrar el firewall de Ubuntu. La política utilizada es:

```text
Entradas: denegadas por defecto
Salidas:  permitidas
Excepción: TCP/22 solo desde redes autorizadas
```

Esto reduce la superficie de ataque: un servicio puede estar escuchando y, aun así, no ser alcanzable desde orígenes no autorizados.

### 2.8. SSH por clave

SSH utiliza dos clases de claves que no deben confundirse:

- **Clave de usuario o cliente:** demuestra que el administrador posee la identidad autorizada. `ssh-add -l` muestra su huella.
- **Clave de host del servidor:** demuestra que estamos conectando al servidor correcto. Se consulta en el servidor con `ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub`.

Aceptar una clave de host sin comparar la huella puede permitir una suplantación.

## 3. Principio de seguridad empleado

El orden seguro fue:

```text
Identificar
  -> inspeccionar sin cambiar
  -> preparar recuperación
  -> copiar configuración
  -> añadir la ruta nueva
  -> probar una conexión nueva
  -> probar que la contraseña sigue bloqueada
  -> retirar la ruta antigua
  -> probar otra vez
```

La regla más importante es: **añadir y validar antes de eliminar**.

## 4. Paso 1: identificar el servidor

Desde Windows se comprobó la conectividad y la tabla ARP:

```powershell
Test-Connection 192.168.1.30 -Count 2
arp -a 192.168.1.30
```

### Qué significa

- `Test-Connection` envía solicitudes ICMP, equivalentes a `ping`.
- `arp -a` consulta la asociación aprendida entre IP y MAC en la LAN.
- La MAC obtenida coincidió con la interfaz `eno1` inventariada.

### Limitación

El ping no demuestra que SSH funcione. Un firewall puede permitir ICMP y bloquear TCP/22.

## 5. Paso 2: comprobar red, SSH y UFW desde consola física

```bash
hostnamectl --static
ip -br -4 addr show eno1
ip route
sudo sshd -t
sudo ss -ltnp | grep ':22'
sudo ufw status numbered
```

### `hostnamectl --static`

Muestra el nombre estable del equipo. Debía ser `srv-mm-01`. Evita administrar por error otro host.

### `ip -br -4 addr show eno1`

- `ip`: herramienta moderna de red en Linux.
- `-br`: salida breve.
- `-4`: solo IPv4.
- `addr`: direcciones.
- `show eno1`: limita la consulta a esa interfaz.

Permitió confirmar `192.168.1.30/24` en `eno1`.

### `ip route`

Muestra cómo decide Linux por dónde enviar el tráfico. Una línea `default via ...` identifica la ruta predeterminada.

### `sudo sshd -t`

Valida la sintaxis de la configuración y la coherencia básica de las claves de host. Si todo está bien, no muestra nada y devuelve código `0`.

No inicia una sesión y no recarga el servicio.

### `sudo ss -ltnp | grep ':22'`

- `ss`: inspecciona sockets.
- `-l`: solo escuchas.
- `-t`: TCP.
- `-n`: muestra números, sin resolver nombres.
- `-p`: muestra el proceso responsable.
- `grep ':22'`: conserva las líneas relacionadas con el puerto 22.

Se observó que `systemd` escuchaba en IPv4 e IPv6 mediante `ssh.socket`.

### `sudo ufw status numbered`

Muestra reglas activas y las numera para poder retirar una concreta. Reveló que solo `192.168.2.0/24` podía alcanzar TCP/22.

## 6. Incidencia: faltaba `/run/sshd`

`sshd -t` devolvió:

```text
Missing privilege separation directory: /run/sshd
```

### Qué significa

OpenSSH necesita un directorio controlado por `root` para aislar parte del proceso previo a la autenticación. El servidor utiliza activación mediante `ssh.socket`: `systemd` mantiene el puerto abierto y arranca el servicio cuando llega una conexión. En ese momento puede crear el directorio de ejecución.

Como `ssh.service` estaba inactivo, `/run/sshd` todavía no existía y la ejecución manual de `sshd -t` no podía completar la comprobación.

### Diagnóstico utilizado

```bash
ls -ld /run/sshd || echo RUN_SSHD_NO_EXISTE
systemctl is-active ssh.socket
systemctl is-active ssh.service
systemctl show ssh.service -p RuntimeDirectory -p RuntimeDirectoryMode
sudo ss -ltnp | grep ':22'
```

El conjunto de resultados confirmó:

- directorio ausente;
- `ssh.socket` activo;
- `ssh.service` inactivo;
- `RuntimeDirectory=sshd`;
- TCP/22 escuchado por `systemd`.

### Corrección mínima

```bash
sudo install -d -o root -g root -m 0755 /run/sshd
ls -ld /run/sshd
sudo sshd -t
echo $?
```

`install -d` crea un directorio aplicando propietario y permisos en una sola operación:

- `-d`: crea directorio;
- `-o root`: propietario `root`;
- `-g root`: grupo `root`;
- `-m 0755`: `root` puede escribir; los demás solo leer y atravesar.

`/run` es temporal y se reconstruye en cada arranque. No se cambió la configuración persistente de OpenSSH.

## 7. Paso 3: crear una copia de UFW

```bash
sudo install -d -m 700 /root/srv-mm-change-20261031-red

sudo cp -a /etc/ufw/user.rules /etc/ufw/user6.rules \
  /root/srv-mm-change-20261031-red/

sudo ufw status numbered | sudo tee \
  /root/srv-mm-change-20261031-red/ufw-before.txt
```

### Qué significa

- El directorio bajo `/root` solo es accesible por administración.
- Modo `0700`: únicamente `root` puede leer, escribir o entrar.
- `cp -a` preserva atributos y marcas temporales.
- `tee` muestra la salida y la guarda a la vez.
- Se copiaron reglas IPv4 y IPv6, aunque el cambio afectara a IPv4.

Las fechas antiguas de los ficheros copiados son normales: `cp -a` conserva la fecha original.

## 8. Paso 4: añadir la red nueva sin borrar la antigua

```bash
sudo ufw allow proto tcp from 192.168.1.0/24 to any port 22 \
  comment 'SSH LAN nueva 2026-10-31'

sudo ufw status numbered
```

### Lectura del comando

- `allow`: permitir.
- `proto tcp`: solo protocolo TCP.
- `from 192.168.1.0/24`: únicamente equipos de esa LAN.
- `to any`: cualquier dirección local del servidor.
- `port 22`: únicamente SSH.
- `comment`: deja una explicación operativa.

En ese momento coexistieron las redes antigua y nueva. Esto evitó destruir la vía anterior antes de probar la nueva.

## 9. Paso 5: probar el puerto desde Windows

```powershell
Test-NetConnection 192.168.1.30 -Port 22
```

El dato importante fue:

```text
TcpTestSucceeded : True
```

Esto validó red, ruta y firewall hasta TCP/22, pero todavía no la autenticación.

## 10. Paso 6: verificar identidad y abrir SSH por clave

En la consola física del servidor:

```bash
sudo ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
```

En PowerShell:

```powershell
Start-Service ssh-agent
ssh-add -l
ssh-add "$env:USERPROFILE\.ssh\id_ed25519_srv_mm"
ssh -o KexAlgorithms=curve25519-sha256 -o IdentitiesOnly=no vicente@192.168.1.30
```

### Significado

- `ssh-agent` mantiene temporalmente claves descifradas en memoria.
- `ssh-add -l` enumera identidades cargadas; no muestra la clave privada.
- `ssh-add` carga la clave y solicita su frase localmente.
- La frase nunca se copia al chat ni al repositorio.
- `KexAlgorithms=curve25519-sha256` conserva la negociación validada para este host.
- `IdentitiesOnly=no` permite utilizar la identidad cargada en el agente.

Ante una IP nueva, SSH puede preguntar si se confía en la clave del host. Solo debe aceptarse después de comparar la huella con la consola física.

Dentro de la sesión se comprobó:

```bash
whoami
hostname
ip -br -4 addr show eno1
```

Esto validó usuario, host e interfaz desde el canal nuevo.

## 11. Paso 7: demostrar que la contraseña continúa bloqueada

En otra ventana de PowerShell:

```powershell
ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password -o KexAlgorithms=curve25519-sha256 vicente@192.168.1.30
```

Se deshabilitó deliberadamente la clave pública en el cliente para comprobar que el servidor no ofrecía una vía alternativa por contraseña.

Resultado esperado y obtenido:

```text
Permission denied (publickey)
```

Si hubiera aparecido una solicitud de contraseña, la prueba habría fallado y no se debería introducir ninguna credencial.

## 12. Paso 8: retirar la red antigua

Con la sesión nueva todavía abierta:

```bash
sudo ufw status numbered
sudo ufw delete NUMERO_DE_LA_REGLA_ANTIGUA
sudo ufw status numbered
```

Antes de borrar se volvió a leer el número porque UFW renumera las reglas cuando se añaden o eliminan entradas.

Se retiró `192.168.2.0/24` y se comprobó nuevamente TCP/22 desde Windows. Una sesión ya establecida no basta como prueba: es necesario abrir o comprobar una conexión nueva.

## 13. Preparación de una red futura

El cliente comunicó `192.168.0.0/24`. Se añadió una regla preventiva:

```bash
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 22 \
  comment 'SSH LAN cliente 2026-10-31'
```

Esta regla solo prepara el firewall. No configura la IP del servidor y no puede considerarse validada hasta probarla desde la sede.

Para terminar la red de producción siguen faltando:

- IP concreta;
- puerta de enlace;
- DHCP y reserva;
- DNS;
- VLAN;
- origen de administración;
- verificación de que la IP está libre.

No debe asumirse `192.168.0.30` por parecido con `192.168.1.30`.

## 14. Reversión razonada

### Error al añadir una red nueva

No retirar la antigua. Eliminar solo la regla nueva:

```bash
sudo ufw delete allow proto tcp from RED_NUEVA/24 to any port 22
```

### Se eliminó una regla equivocada

Usar la sesión aún abierta o la consola física para volver a añadir el origen correcto. No cerrar la recuperación antes de una conexión nueva.

### UFW bloquea todo acceso

Desde consola física, como medida de emergencia:

```bash
sudo ufw disable
```

Después deben corregirse las reglas y reactivar UFW. No debe dejarse deshabilitado.

### Restaurar los ficheros copiados

```bash
sudo cp -a /root/srv-mm-change-20261031-red/user.rules /etc/ufw/user.rules
sudo cp -a /root/srv-mm-change-20261031-red/user6.rules /etc/ufw/user6.rules
sudo ufw reload
```

En este caso concreto la copia recupera `192.168.2.0/24`, por lo que solo sirve como vuelta al estado previo, no como configuración final deseable.

## 15. Qué no se hizo y por qué

- No se abrió TCP/22 en el router: publicarlo en Internet aumentaría mucho el riesgo.
- No se permitió SSH desde `Anywhere`: se limitaron orígenes.
- No se activó autenticación por contraseña: las claves reducen ataques de credenciales.
- No se cambió Netplan: faltaban datos definitivos y la red actual funciona por DHCP.
- No se asumió una IP del cliente: evitar conflictos requiere coordinación con DHCP/router.
- No se arrancó MySQL ni se abrieron 3306/33060: el cambio era exclusivamente administrativo.
- No se eliminó la clave privada al terminar: solo debe descargarse del agente.

## 16. Cierre seguro de una sesión administrativa

Salir de las sesiones remotas:

```bash
exit
```

En PowerShell, retirar la identidad del agente:

```powershell
ssh-add -d "$env:USERPROFILE\.ssh\id_ed25519_srv_mm"
ssh-add -l
```

El primer comando descarga la identidad de memoria. No borra el archivo privado. `ssh-add -l` debe indicar que no quedan identidades si no se utiliza ninguna otra.

Bloquear Windows si el equipo queda sin supervisión.

## 17. Lista reutilizable

### Antes

- [ ] Consola física disponible.
- [ ] Identidad del servidor confirmada.
- [ ] Red actual y red nueva confirmadas.
- [ ] IP, prefijo, gateway y DNS inventariados.
- [ ] SSH validado con `sshd -t`.
- [ ] Puerto y proceso identificados.
- [ ] UFW leído y copiado.
- [ ] Reversión escrita.

### Durante

- [ ] Añadir la red nueva sin retirar la antigua.
- [ ] Comprobar TCP/22.
- [ ] Comparar huella del host.
- [ ] Abrir una sesión nueva por clave.
- [ ] Mantener recuperación abierta.
- [ ] Probar rechazo de contraseña.
- [ ] Retirar solo la regla obsoleta.
- [ ] Probar otra conexión nueva.

### Después

- [ ] Confirmar reglas finales.
- [ ] Confirmar que no existen reglas no previstas.
- [ ] Registrar propósito, riesgo, aceptación y reversión.
- [ ] Cerrar sesiones innecesarias.
- [ ] Descargar la clave de `ssh-agent`.
- [ ] Reservar una IP estable antes de producción.
- [ ] Retirar reglas temporales tras la migración.

## 18. Ideas para profundizar

1. Subnetting: diferencias entre `/24`, `/25`, `/30` y `/32`.
2. Tablas ARP y Neighbor Discovery en IPv6.
3. Activación de servicios mediante sockets de `systemd`.
4. Relación entre UFW, Netfilter y nftables.
5. Autenticación SSH, claves de host y `known_hosts`.
6. Reservas DHCP frente a Netplan estático.
7. Segmentación mediante VLAN y redes de administración.
8. Principios de mínimo privilegio, defensa en profundidad y recuperación.

## 19. Referencias internas

- `ESTADO-ACCESO-SSH-Y-RED-2026-10-31.md`: evidencia y estado operativo del caso.
- `PLAN-ACCESO-ADMINISTRATIVO-REMOTO-2026-10-25.md`: diseño futuro de mantenimiento remoto sin publicar SSH.
- `CONTINUAR-SIGUIENTE-SESION.md`: punto de reanudación del proyecto.
- `00-srv-mm-ssh-hardening.conf`: endurecimiento SSH aplicado.

