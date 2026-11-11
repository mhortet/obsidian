---
title: "Plantilla de inventario de puestos P0"
type: guide
status: active
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P0-PRODUCCION-READINESS-2026-11-11.md"
tags: [qontrolmed, plantilla, inventario, puestos]
review_after: 2027-02-11
---

# Plantilla de inventario de puestos P0

## Regla de protección

El inventario nominal completo se mantiene en un almacén protegido acordado con
el cliente. En Git solo se registra un identificador pseudonimizado, el estado y
la evidencia depurada. No se versionan nombres personales, IP completas,
credenciales, números de serie ni detalles de red sensibles.

## Inventario depurado para el repositorio

| ID de puesto | Uso | SO soportado | Red validada | TLS/CA | Cuenta técnica | Responsable validado | Estado |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `PUESTO-01` | _Pendiente_ | _Pendiente_ | Sí/No | Sí/No | Creada/No | Sí/No | Pendiente |

## Inventario protegido externo

Campos mínimos que deben mantenerse fuera de Git:

- identificador correlacionado con la tabla depurada;
- nombre del equipo y número de serie;
- edición y versión de Windows;
- IP fija o reserva DHCP y segmento autorizado;
- ubicación física;
- responsable y contacto;
- fecha de último parche y protección endpoint;
- hash/versión de Qontrolmed instalada;
- fecha de provisión y hash de CA pública;
- identidad MySQL asociada, sin contraseña;
- fecha de alta, baja y última validación.

## Alta

1. Aprobar el puesto y asignar ID.
2. Validar SO, parches y protección.
3. Fijar origen de red autorizado.
4. Provisionar CA pública por canal controlado.
5. Crear identidad MySQL limitada por origen y `REQUIRE SSL`.
6. Instalar desde release verificada.
7. Ejecutar pruebas positivas y negativas.
8. Registrar fecha, aprobador y evidencia depurada.

## Baja

1. Revocar identidad MySQL y regla de origen.
2. Retirar configuración y CA de Qontrolmed conforme al runbook.
3. Recuperar o eliminar ficheros operativos según política.
4. Verificar que el puesto ya no conecta.
5. Registrar fecha, autorizador y evidencia depurada.
