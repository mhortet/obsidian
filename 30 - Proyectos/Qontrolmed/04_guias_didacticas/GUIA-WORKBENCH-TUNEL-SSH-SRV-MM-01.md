---
title: "Guía didáctica de Workbench mediante túnel SSH en srv-mm-01"
type: guide
status: active
created: 2026-11-15
updated: 2026-11-15
sources:
  - "../02_planes_y_arquitectura/PLAN-P2O-CARGA-MAESTROS-SRV-MM-01-2026-11-15.md"
  - "../../CONTINUAR-SIGUIENTE-SESION.md"
tags: [qontrolmed, mysql, workbench, ssh, seguridad, formacion]
review_after: 2026-12-15
---

# Guía didáctica de Workbench mediante túnel SSH en srv-mm-01

## 1. Finalidad

Esta guía explica cómo administrar con MySQL Workbench los esquemas de
Qontrolmed alojados en `srv-mm-01` sin exponer MySQL en la red local.

El acceso utiliza dos capas:

1. OpenSSH verifica la identidad del servidor y crea un túnel cifrado.
2. Workbench se conecta a un puerto local que el túnel reenvía a MySQL.

MySQL permanece ligado a `127.0.0.1:3306`. Ningún equipo de la LAN puede
conectarse directamente a ese puerto.

## 2. Estado y datos utilizados

| Elemento | Valor |
| --- | --- |
| Servidor | `srv-mm-01` |
| IP doméstica reservada | `192.168.1.31` |
| Usuario SSH | `vicente` |
| Alias histórico de clave de host | `192.168.1.30` |
| Puerto local del túnel | `127.0.0.1:13306` |
| MySQL en el servidor | `127.0.0.1:3306` |
| Usuario MySQL de Workbench | `qontrolmed_admin` |
| Esquema predeterminado | `piloto_mm_gestion` |

No se documenta la contraseña MySQL ni la frase secreta de la clave SSH.

## 3. Qué significa el túnel

Workbench cree que accede a un MySQL local en `127.0.0.1:13306`. OpenSSH
recibe esa conexión, la cifra y la entrega dentro del servidor a
`127.0.0.1:3306`.

```text
Workbench → 127.0.0.1:13306 → túnel SSH → srv-mm-01:127.0.0.1:3306
```

Cerrar la consola del túnel corta el acceso de Workbench, pero no modifica ni
detiene la base de datos.

## 4. Apertura de una sesión

### Paso 1. Encender y comprobar el servidor

El servidor debe estar arrancado y accesible en `192.168.1.31`.

### Paso 2. Cargar la identidad SSH

En PowerShell de Windows:

```powershell
ssh-add "$env:USERPROFILE\.ssh\id_ed25519_srv_mm"
ssh-add -l
```

`ssh-add` solicita localmente la frase secreta. `ssh-add -l` debe mostrar la
huella de la identidad. La frase no se escribe en el chat ni en documentos.

Si aparece `Error connecting to agent`, abrir PowerShell como administrador y
ejecutar una vez:

```powershell
Set-Service -Name ssh-agent -StartupType Manual
Start-Service ssh-agent
```

### Paso 3. Iniciar MySQL sin habilitarlo al arranque

Abrir una sesión SSH normal:

```powershell
ssh -i "$env:USERPROFILE\.ssh\id_ed25519_srv_mm" -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes -o HostKeyAlias=192.168.1.30 vicente@192.168.1.31
```

El prompt cambia de `PS C:\...>` a `vicente@srv-mm-01`. Ya dentro del servidor:

```bash
sudo systemctl start mysql
systemctl is-active mysql
systemctl is-enabled mysql
```

El resultado esperado es `active` y `disabled`: MySQL funciona durante la
sesión, pero no se inicia automáticamente tras un reinicio.

### Paso 4. Abrir el túnel desde otra consola de Windows

No ejecutar este comando dentro del servidor. Abrir una segunda ventana cuyo
prompt comience por `PS C:\Users\Maxi>` y ejecutar en una sola línea:

```powershell
ssh -N -L 127.0.0.1:13306:127.0.0.1:3306 -i "$env:USERPROFILE\.ssh\id_ed25519_srv_mm" -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes -o HostKeyAlias=192.168.1.30 vicente@192.168.1.31
```

- `-N`: no abre una consola remota; mantiene únicamente el túnel.
- `-L`: enlaza el puerto local `13306` con MySQL remoto.
- `StrictHostKeyChecking=yes`: rechaza una identidad de servidor desconocida.
- `HostKeyAlias`: conserva la verificación histórica tras el cambio de IP.

La ventana queda sin prompt mientras el túnel está activo. No debe cerrarse.

## 5. Configuración de Workbench

Crear o utilizar la conexión con estos valores:

| Campo | Valor |
| --- | --- |
| Connection Name | `Qontrolmed srv-mm-01` |
| Connection Method | `Standard (TCP/IP)` |
| Hostname | `127.0.0.1` |
| Port | `13306` |
| Username | `qontrolmed_admin` |
| Default Schema | `piloto_mm_gestion` |

La contraseña se introduce con `Store in Vault…`; nunca se copia al
repositorio ni a Obsidian.

Workbench 8.0 puede advertir que MySQL 8.4 no es una versión plenamente
soportada. Se puede continuar para navegación, consultas y editor SQL. No usar
sin validación previa asistentes de migración, administración del servidor o
modificación de usuarios.

## 6. Comprobaciones iniciales

En el editor SQL:

```sql
SELECT VERSION(), @@hostname, @@bind_address, @@port;
SHOW DATABASES;
```

Debe observarse MySQL 8.4, `srv-mm-01`, `127.0.0.1` y los esquemas
`piloto_mm_gestion`, `piloto_mm_preventivos` y `piloto_mm_quirofanos`.

La cuenta `qontrolmed_admin@localhost` tiene privilegios únicamente sobre esos
tres esquemas. No debe concederse `GRANT OPTION` ni acceso global.

## 7. Cierre seguro

1. Terminar consultas y cerrar la pestaña o Workbench.
2. En la consola del túnel, pulsar `Ctrl+C`.
3. Si ya no se necesita MySQL, dentro de la sesión SSH ejecutar:

```bash
sudo systemctl stop mysql
systemctl is-active mysql
```

4. Cerrar la sesión SSH con `exit`.
5. Retirar la identidad del agente de Windows:

```powershell
ssh-add -d "$env:USERPROFILE\.ssh\id_ed25519_srv_mm"
ssh-add -l
```

El resultado final más restrictivo es MySQL `inactive/disabled`, túnel cerrado
y agente SSH sin identidades. Si se decide mantener MySQL activo para continuar
trabajando, sigue sin exposición LAN porque escucha solo en loopback.

## 8. Problemas habituales

### El comando aparece con las líneas invertidas

Cancelar con `Ctrl+C` y utilizar la versión de una sola línea. No pegar comandos
multilínea si la consola altera su orden.

### La ruta `%USERPROFILE%` o `$env:USERPROFILE` no existe

El comando se ejecutó dentro de Ubuntu. Las rutas de Windows solo se utilizan
en un prompt `PS C:\...>`.

### Workbench no conecta

Comprobar, en este orden:

1. servidor encendido;
2. MySQL `active`;
3. consola del túnel abierta;
4. `127.0.0.1` y puerto `13306` en Workbench;
5. usuario `qontrolmed_admin` y contraseña correcta.

No solucionar el problema abriendo 3306 en UFW o cambiando `bind-address`.

## 9. Límites

- Esta guía describe administración por túnel SSH, no la conexión productiva
  de Qontrolmed, que requiere su propio plan TLS, cuenta técnica y puesto
  autorizado.
- No sustituye las copias previas, prechecks, postchecks y reversión exigidos
  para migraciones.
- No autoriza cargar datos de pacientes ni datos clínicos.
