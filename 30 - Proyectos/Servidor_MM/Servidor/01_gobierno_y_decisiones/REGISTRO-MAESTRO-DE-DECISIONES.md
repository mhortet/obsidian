---
title: "Registro maestro de decisiones de Servidor_MM"
type: register
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "DECISION-ARQUITECTURA-CONEXION-QONTROLMED-MYSQL-2026-10-05.md"
  - "DECISION-IDS-MARCAS-MANUALES-2026-11-05.md"
  - "DECISION-PREPARAR-TODO-ANTES-TRASLADO-2026-11-05.md"
tags: [gobierno, documentacion, arquitectura]
review_after:
---

# Registro maestro de decisiones

Este registro facilita la consulta. No sustituye las decisiones originales ni concede nuevas autorizaciones. Una decisión puede seguir siendo históricamente válida aunque su ejecución haya terminado; el campo `Estado` indica su efecto actual.

## Cómo leerlo

- **Vigente:** gobierna el estado o el trabajo futuro.
- **Ejecutada:** su resultado está incorporado y no requiere repetir la actuación.
- **Sustituida:** otra decisión posterior cambió el criterio.
- **Parcial:** una parte está cerrada y otra depende de sede o aceptación.
- **Pendiente:** todavía requiere elección o aprobación.

## Decisiones, de más reciente a más antigua

| Fecha | Decisión | Estado | Consecuencia vigente | Fuente |
| --- | --- | --- | --- | --- |
| 2026-11-21 | Separar documentación de cliente y archivo interno; consolidar mediante registros maestros sin borrar fuentes | Vigente | `08_entrega_cliente/` será la entrega; los originales siguen como trazabilidad | Instrucción del propietario y revisión documental del 21/11 |
| 2026-11-21 | Pasar a fase física de sede solo mediante un plan específico | Vigente | No activar túnel, abrir puertos, cambiar UFW ni conectar la RC por anticipado | [Relevo vigente](../CONTINUAR-SIGUIENTE-SESION.md) |
| 2026-11-19 | Completar primero equipo actual, después portátil y finalmente sede | Ejecutada hasta portátil; sede pendiente | Cada plan cubre solo la fase activa observada | Decisión coordinada en Qontrolmed; enlazada desde `AGENTS.md` |
| 2026-11-18 | Separar administrador funcional, cuenta runtime MySQL y administración técnica | Vigente | No reutilizar cuentas administrativas en la aplicación; identidades por puesto pendientes de sede | Relevo coordinado de Qontrolmed y guía P2U/P2W |
| 2026-11-17 | Mantener MySQL activo y habilitado, limitado a loopback | Vigente hasta plan de sede | Estado esperado `active/enabled` y `127.0.0.1:3306`; no implica apertura LAN | [Relevo vigente](../CONTINUAR-SIGUIENTE-SESION.md) |
| 2026-11-16 | Piloto previsto para cuatro o cinco puestos; red comunicada `192.168.0.0/24`; reservas DHCP | Parcial | Capacidad y separación de identidades aceptadas; direcciones reales pendientes de comprobar en sede | Decisión coordinada de especificaciones operativas de Qontrolmed |
| 2026-11-12 | Retirar NVIDIA defectuosa y conservar consola mediante `nomodeset` reversible | Ejecutada y vigente | No reinstalar NVIDIA ni modificar GRUB sin nuevo plan | [Estado del incidente](../00_seguimiento/estados/ESTADO-INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.md) |
| 2026-11-06 | Preparar y aceptar SFTPGo/restic con datos ficticios y sin exposición externa | Ejecutada | SFTPGo continúa inactivo; ensayo local no es copia 3-2-1 | [Aceptación](../00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md) |
| 2026-11-05 | Preparar accesos, recuperación y pruebas antes del traslado | Vigente | La implantación debe llegar a sede con procedimientos y reversión preparados | [Decisión original](DECISION-PREPARAR-TODO-ANTES-TRASLADO-2026-11-05.md) |
| 2026-11-05 | Interpretar “plenos poderes” como cuenta nominal, MFA/clave y `sudo` interactivo | Vigente | No habilitar root remoto, contraseña SSH o `NOPASSWD: ALL` | [Decisión original](DECISION-PREPARAR-TODO-ANTES-TRASLADO-2026-11-05.md) |
| 2026-11-05 | Preservar los identificadores manuales históricos de marcas | Vigente en Qontrolmed | No convertirlos a autoincremento ni renumerarlos | [Decisión original](DECISION-IDS-MARCAS-MANUALES-2026-11-05.md) |
| 2026-11-05 | Una aprobación cubre el plan completo, incluidas pruebas y reversión | Vigente | Solo se vuelve a pedir aprobación ante ampliación material, riesgo nuevo o decisión no deducible | [AGENTS.md](../AGENTS.md) |
| 2026-11-01 | Usar reserva DHCP doméstica `.31`; mantener red de sede sin inventar | Doméstica ejecutada; sede pendiente | La IP doméstica no se trasladará al cliente | [Estado operativo](../00_seguimiento/estados/ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md) |
| 2026-10-05 | No publicar MySQL directamente en Internet; seleccionar arquitectura tras conocer puestos y acceso remoto | Vigente | La conectividad de sede requiere TLS, mínimo privilegio y alternativa aprobada | [Decisión original](DECISION-ARQUITECTURA-CONEXION-QONTROLMED-MYSQL-2026-10-05.md) |
| 2026-10-04 | Usar MySQL 8.4 LTS y separar volúmenes de raíz, MySQL y compartido | Ejecutada | Mantener rama soportada; cambios de almacenamiento requieren plan | [Revalidación y propuestas](../00_seguimiento/estados/REVALIDACION-Y-PROPUESTAS-2026-10-04.md) |
| 2026-10-04 | Aplazar firmware y Secure Boot hasta identificar placa y asegurar recuperación | Vigente | No actualizar firmware como mantenimiento rutinario | [Revalidación y propuestas](../00_seguimiento/estados/REVALIDACION-Y-PROPUESTAS-2026-10-04.md) |
| 2026-10-01 | Instalar Ubuntu dedicado con LUKS2 y administración SSH por clave | Ejecutada y vigente | Cifrado y acceso mínimo forman parte de la arquitectura base | [Estado de instalación](../00_seguimiento/estados/ESTADO-INSTALACION-2026-10-01.md) |

## Decisiones aún necesarias

| ID | Decisión pendiente | Momento |
| --- | --- | --- |
| D-P01 | Direccionamiento, VLAN, reservas, DNS y orígenes autorizados | Inventario inicial de sede |
| D-P02 | Arquitectura definitiva del túnel y del acceso administrativo | Tras validar red e identidad del cliente |
| D-P03 | Destino de copia independiente, retención, RPO y RTO | Antes de datos reales |
| D-P04 | Responsables nominales y sustitutos | Antes de entrega |
| D-P05 | Recuperación después de corte eléctrico y desbloqueo LUKS | Antes de declarar operación autónoma |
| D-P06 | Política de actualizaciones, ventanas y reinicios | Antes de entrega |
| D-P07 | Aceptación de excepciones PAM, AppArmor, firmware y Secure Boot | Antes de producción |
