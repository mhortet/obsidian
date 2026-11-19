---
title: "Inventario de sede para P2X"
type: template
status: active
created: 2026-11-19
updated: 2026-11-19
tags: [qontrolmed, p2x, sede, inventario]
review_after: 2026-12-19
---

# Inventario de sede para P2X

No registrar contraseñas, claves privadas ni datos de pacientes. Una propuesta
no equivale a un valor confirmado en sede.

## Red y servidor

| Dato | Propuesta | Confirmado | Quién valida | Modalidad |
| --- | --- | --- | --- | --- |
| Red y máscara | `192.168.0.0/24` | pendiente | propietario/cliente | sede |
| Rango DHCP actual | pendiente | pendiente | responsable del router | sede o remoto autorizado |
| IP reservada del servidor | pendiente | pendiente | propietario | sede |
| Gateway | pendiente | pendiente | responsable del router | sede |
| DNS | pendiente | pendiente | responsable del router | sede |
| Nombre DNS MySQL/certificado | pendiente | pendiente | propietario | preparación + sede |
| Conexión LAN o canal intermedio | directa LAN propuesta | pendiente | propietario | decisión previa |

## Puestos

| Código | SO | Usuario ordinario | Adaptador/MAC | IP propuesta | Reserva confirmada | Contacto | Estado |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `p01` | pendiente | pendiente | pendiente | pendiente | no | pendiente | propuesta |
| `p02` | pendiente | pendiente | pendiente | pendiente | no | pendiente | propuesta |
| `p03` | pendiente | pendiente | pendiente | pendiente | no | pendiente | propuesta |
| `p04` | pendiente | pendiente | pendiente | pendiente | no | pendiente | propuesta |
| `p05` | pendiente | pendiente | pendiente | pendiente | no | pendiente | propuesta |

## Responsables y ventana

| Decisión | Valor | Estado | ¿Remoto viable? |
| --- | --- | --- | --- |
| Altas/bajas de puestos | propietario, pendiente de confirmar | pendiente | sí, con SSH aprobado |
| Recuperación de credenciales | propietario, pendiente de confirmar | pendiente | sí, con identidad verificada |
| Acceso al router/reservas DHCP | pendiente | pendiente | solo si el cliente autoriza acceso remoto |
| Contacto funcional para aceptación | pendiente | pendiente | sí |
| Ventana de instalación | pendiente | pendiente | por decidir |

## Puertas para fase B

- [ ] inventario del primer puesto completo;
- [ ] direccionamiento comprobado sin conflictos;
- [ ] certificado compatible con la identidad elegida;
- [ ] plan transversal Qontrolmed/Servidor_MM autorizado;
- [ ] copia, aceptación y reversión exactas;
- [ ] clasificación confirmada de tareas locales y remotas.
