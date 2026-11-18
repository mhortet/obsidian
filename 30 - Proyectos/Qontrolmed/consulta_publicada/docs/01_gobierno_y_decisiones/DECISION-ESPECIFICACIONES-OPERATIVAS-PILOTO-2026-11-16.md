---
title: "Especificaciones operativas del piloto de Qontrolmed"
type: decision
status: approved
created: 2026-11-16
updated: 2026-11-16
sources:
  - "Comunicación del propietario de 2026-11-16"
  - "docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md"
  - "H:/02.Trabajo/obsidian/30 - Proyectos/Servidor_MM/Servidor/DOCUMENTACION-SERVIDOR-UBUNTU.md"
tags: [qontrolmed, piloto, capacidad, identidades, red, datos]
review_after: 2026-12-16
---

# Especificaciones operativas del piloto de Qontrolmed

## Decisión

Qontrolmed se desplegará en una pequeña empresa, con un máximo previsto de
cuatro o cinco puestos concurrentes en una LAN `192.168.0.0/24`. Los puestos
autorizados tendrán direcciones estables mediante reservas DHCP del router.
La IP definitiva del servidor, la puerta de enlace, el DNS y las reservas
concretas se verificarán y aplicarán durante la instalación en la sede; no se
trasladarán por suposición las direcciones del entorno doméstico.

Los usuarios funcionales, incluido el administrador de gestión, se
administrarán desde Qontrolmed y no tendrán privilegios administrativos sobre
MySQL. El administrador de gestión podrá realizar las funciones de
mantenimiento autorizadas por la aplicación y gestionar altas, bajas, roles y
permisos de otros usuarios funcionales. Su uso ordinario queda limitado a los
puestos autorizados de la LAN.

La aplicación utilizará una cuenta técnica MySQL separada y de mínimo
privilegio. Esta cuenta no podrá crear usuarios MySQL, conceder privilegios,
crear esquemas ni realizar DDL de mantenimiento. Sus permisos se limitarán a
las operaciones necesarias sobre los esquemas de Qontrolmed.

La administración técnica del servidor y de MySQL se realizará mediante una
identidad separada, principalmente desde el ordenador autorizado del
propietario y, cuando proceda, desde la LAN autorizada. Se emplearán SSH por
clave y túneles protegidos. MySQL, SSH y SMB no se publicarán directamente en
Internet. Una cuenta administrativa limitada a los esquemas de Qontrolmed no
se denominará ni tratará como superusuario global de MySQL.

El sistema no tratará datos de pacientes, historias clínicas, diagnósticos,
imágenes médicas ni identificadores clínicos. Conservará información técnica
de equipos, instalaciones e informes de revisión, además de los datos
personales mínimos de usuarios y técnicos necesarios para autenticación,
autorización, contacto y trazabilidad. Estos datos personales siguen
requiriendo protección aunque no sean clínicos.

## Separación de identidades

| Identidad | Finalidad | Origen previsto | Límite principal |
| --- | --- | --- | --- |
| Administrador de gestión de Qontrolmed | Maestros, mantenimiento funcional y usuarios de la aplicación | Puesto autorizado de la LAN | No administra MySQL ni el servidor |
| Cuenta técnica de la aplicación | Conexión de Qontrolmed a sus esquemas | Puestos autorizados de la LAN | Mínimo privilegio, sin usuarios MySQL, esquemas ni DDL |
| Administrador técnico | Servidor, copias, recuperación y administración controlada de MySQL | Ordenador del propietario y LAN autorizada | SSH por clave y túnel; sin exposición directa a Internet |

## Límites y pendientes de sede

- El máximo de cuatro o cinco puestos es una previsión de dimensionamiento, no
  una prueba de carga ya superada.
- Antes de habilitar puestos se registrarán equipo, responsable, sistema
  operativo y reserva DHCP o dirección autorizada.
- La red `192.168.0.0/24` es un dato comunicado pendiente de validación in
  situ. La IP final del servidor no se inventa en esta decisión.
- El acceso remoto definitivo requiere validar dispositivo autorizado,
  autenticación, denegación de orígenes no autorizados y recuperación.
- Esta decisión no autoriza por sí sola cambios de router, Netplan, UFW,
  cuentas, MySQL, túneles ni despliegue en sede.
