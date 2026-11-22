---
title: "Guía documental de SFTPGo"
type: process
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../03_operacion_y_runbooks/OPERAR-SFTPGO-DOCUMENTAL-2026-11-19.md"
tags: [documentacion, administracion, seguridad]
review_after:
---

# Guía documental de SFTPGo

## Finalidad

El WebClient documental permite subir y descargar documentación técnica autorizada. No es un almacenamiento para datos clínicos, copias personales o archivos ajenos al trabajo.

## Acceso definitivo

| Dato | Valor |
| --- | --- |
| Dirección del WebClient | PENDIENTE DE SEDE Y TÚNEL |
| Método de identidad previa | PENDIENTE DE SEDE Y TÚNEL |
| Segundo factor | PENDIENTE DE SEDE Y TÚNEL |
| Responsable documental | PENDIENTE DE SEDE |
| Tamaño máximo por archivo | PENDIENTE DE ACEPTACIÓN |
| Cuota por usuario | PENDIENTE DE ACEPTACIÓN |

## Uso seguro

1. Acceder únicamente mediante la dirección entregada.
2. Comprobar que el navegador no muestra advertencias de identidad o certificado.
3. Usar la cuenta nominal y el segundo factor propio.
4. Guardar los documentos en la carpeta asignada.
5. Comprobar que la carga ha terminado antes de cerrar.
6. Cerrar sesión cuando se use un equipo compartido o se termine el trabajo.

Las funciones disponibles dependerán del perfil. La ausencia de borrado, renombrado, copia, enlaces o compartición puede ser una restricción deliberada.

## Pérdida de acceso o segundo factor

No se enviarán códigos de recuperación ni secretos TOTP por correo o mensajería ordinaria. La recuperación exige identificar al usuario, registrar la autorización, revocar el factor anterior y comprobar un acceso nuevo.

## Incidencias

- Cuota completa: no borrar indiscriminadamente; solicitar revisión.
- Archivo rechazado: registrar nombre, tamaño y mensaje sin adjuntar información sensible.
- Documento incorrecto: avisar al responsable; preservar trazabilidad antes de sustituir o retirar.
- Sospecha de acceso ajeno: cerrar sesión si es seguro, informar inmediatamente y no alterar registros.
