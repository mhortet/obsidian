---
title: "Inventario y configuración entregada"
type: register
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../DOCUMENTACION-SERVIDOR-UBUNTU.md"
tags: [documentacion, administracion, arquitectura]
review_after:
---

# Inventario y configuración entregada

Este documento contendrá la configuración observada y aceptada en la entrega, sin secretos.

## Servidor

| Campo | Valor |
| --- | --- |
| Nombre | `srv-mm-01` |
| Sistema | Ubuntu Server 24.04 LTS; versión exacta a revalidar |
| CPU | Intel Core i7-9700K |
| Memoria | Aproximadamente 32 GB |
| Disco de sistema | Samsung SSD 860 PRO 512 GB |
| Segundo disco | Samsung SSD 860 PRO 1 TB; uso definitivo pendiente |
| Cifrado | LUKS2 en volumen principal |
| Consola | Intel integrada con `nomodeset`; revalidar en sede |

## Red de sede

| Campo | Valor validado |
| --- | --- |
| Interfaz | `eno1`; confirmar cableado |
| MAC | `74:fe:48:67:be:cc` |
| Red/VLAN | PENDIENTE DE SEDE |
| IP del servidor | PENDIENTE DE SEDE |
| Reserva DHCP | PENDIENTE DE SEDE |
| Puerta de enlace | PENDIENTE DE SEDE |
| DNS | PENDIENTE DE SEDE |
| Puestos autorizados | PENDIENTE DE SEDE |

## Servicios e identidades

| Elemento | Versión/estado | Responsable | Próxima revisión |
| --- | --- | --- | --- |
| OpenSSH | PENDIENTE DE REVALIDACIÓN | PENDIENTE | PENDIENTE |
| UFW | PENDIENTE DE REVALIDACIÓN | PENDIENTE | PENDIENTE |
| MySQL | 8.4 LTS; versión exacta a revalidar | PENDIENTE | PENDIENTE |
| Qontrolmed | PENDIENTE DE INSTALACIÓN | PENDIENTE | PENDIENTE |
| SFTPGo | PENDIENTE DE ACTIVACIÓN | PENDIENTE | PENDIENTE |
| Cloudflared | PENDIENTE DE TÚNEL | PENDIENTE | PENDIENTE |
| Copias | PENDIENTE DE DESTINO | PENDIENTE | PENDIENTE |

## Vencimientos

| Elemento | Fecha | Responsable | Aviso previo |
| --- | --- | --- | --- |
| Dominio | PENDIENTE | PENDIENTE | PENDIENTE |
| Certificado/CA MySQL | PENDIENTE DE SEDE | PENDIENTE | PENDIENTE |
| Identidades Cloudflare | PENDIENTE | PENDIENTE | PENDIENTE |
| Revisión de accesos | PENDIENTE | PENDIENTE | PENDIENTE |
