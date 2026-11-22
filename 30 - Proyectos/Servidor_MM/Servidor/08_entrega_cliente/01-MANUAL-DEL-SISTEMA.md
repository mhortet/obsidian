---
title: "Manual del sistema srv-mm-01"
type: project
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../DOCUMENTACION-SERVIDOR-UBUNTU.md"
tags: [documentacion, administracion, arquitectura]
review_after:
---

# Manual del sistema

## Componentes

| Componente | Función | Quién lo administra |
| --- | --- | --- |
| Ubuntu Server | Sistema operativo del servidor | Responsable técnico |
| OpenSSH | Acceso técnico protegido | Responsable técnico |
| UFW | Limita las conexiones de red | Responsable técnico |
| MySQL | Almacena los datos de Qontrolmed | Responsable técnico; la aplicación usa una identidad propia |
| Qontrolmed | Gestión funcional de instalaciones y equipos | Usuarios y administrador funcional |
| SFTPGo WebClient | Acceso controlado a documentos | Usuarios documentales y administrador documental |
| Cloudflare Tunnel/Access | Acceso exterior protegido, si se aprueba | Responsable técnico y administrador de identidad |
| Restic o solución definitiva | Copias cifradas | Responsable de copias |

## Separación de responsabilidades

Un usuario de Qontrolmed no es una cuenta de Ubuntu ni de MySQL. Un usuario documental tampoco debe recibir administración técnica. Cada persona obtiene únicamente los accesos necesarios para su trabajo.

## Puesta en marcha y parada

El servidor usa cifrado LUKS. Después de un corte eléctrico puede requerir intervención autorizada en la consola antes de que funcionen la red y los servicios. El procedimiento definitivo se validará en sede.

No se realizará un apagado desde el interruptor salvo emergencia física. La parada ordinaria corresponde al responsable técnico y debe comprobar que no existen operaciones o copias en curso.

## Estado de servicios

La tabla definitiva se completará después de la implantación en sede.

| Servicio | Estado esperado en producción | Acceso esperado |
| --- | --- | --- |
| SSH | PENDIENTE DE SEDE | Solo administración autorizada |
| MySQL | Activo si Qontrolmed está en servicio | Nunca publicado directamente en Internet |
| SFTPGo | PENDIENTE DE SEDE | WebClient protegido; administración restringida |
| Cloudflared | PENDIENTE DE SEDE | Túnel saliente autorizado, sin publicar otros servicios |
| Copias | PENDIENTE DE SEDE | Destino cifrado e independiente |

## Límites conocidos antes de sede

- La dirección doméstica utilizada durante la preparación no es la dirección de producción.
- El acceso externo y el dominio no están cerrados hasta validar el túnel.
- El ensayo local de copia no constituye una copia independiente ni una política 3-2-1.
- Los responsables, contactos, RPO y RTO deben ser aceptados por el cliente.
- No se considerará completada la entrega hasta firmar el acta y sus excepciones.
