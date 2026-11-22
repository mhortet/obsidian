---
title: "Incidencias y recuperación"
type: process
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../DOCUMENTACION-SERVIDOR-UBUNTU.md"
tags: [seguridad, administracion, documentacion]
review_after:
---

# Incidencias y recuperación

## Qué registrar

- Fecha y hora.
- Persona y puesto afectados.
- Mensaje o síntoma exacto.
- Última operación conocida.
- Alcance: una persona, un puesto o todos.
- Cambios recientes conocidos.

No enviar contraseñas, secretos, bases de datos, archivos de configuración privados o registros completos sin revisión.

## Primera actuación

| Incidencia | Actuación segura |
| --- | --- |
| Qontrolmed no conecta | No repetir escrituras inciertas; registrar mensaje y avisar |
| Web documental no abre | Comprobar otros usuarios y conexión; no cambiar URL ni MFA |
| Usuario bloqueado | Tramitar recuperación nominal; no prestar otra cuenta |
| Falta de espacio | Detener nuevas cargas y avisar; no borrar para liberar espacio |
| Error de certificado | Detenerse; no aceptar excepciones ni desactivar verificación |
| Servidor sin red | Comprobar alimentación y estado local; no reiniciar repetidamente |
| Sospecha de acceso indebido | Informar inmediatamente y preservar evidencia |
| Ruido, olor o temperatura anormal | Priorizar seguridad física y avisar; no abrir el equipo sin autorización |

## Prioridades

- **Crítica:** riesgo para la seguridad, pérdida activa de datos o sistema completo inaccesible.
- **Alta:** servicio principal indisponible para varios usuarios.
- **Media:** función degradada con alternativa segura.
- **Baja:** consulta, mejora o incidencia sin impacto inmediato.

Los tiempos de respuesta y contactos se completarán en sede.

## Recuperación

Una restauración no se realizará directamente sobre producción como primera prueba. Se usará un destino aislado, se verificará integridad y solo después se decidirá la recuperación operativa. La frase LUKS, claves, tokens y contraseñas se custodiarán fuera de esta documentación.

## Registro de incidencia

| ID | Inicio | Prioridad | Síntoma | Alcance | Responsable | Estado | Cierre |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |
