---
title: "Manual de administración de usuarios"
type: process
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../03_operacion_y_runbooks/OPERAR-SFTPGO-DOCUMENTAL-2026-11-19.md"
  - "D:/trabajo/Proyectos/maxgesth/docs/04_guias_didacticas/GUIA-DIDACTICA-ADMINISTRADOR-FUNCIONAL-Y-CUENTA-RUNTIME-MYSQL-2026-11-18.md"
tags: [administracion, seguridad, qontrolmed]
review_after:
---

# Manual de administración de usuarios

## Principio general

Cada acceso será nominal, tendrá un responsable que lo autorice y se limitará a la función necesaria. No se reutilizarán cuentas de personas que hayan dejado la empresa.

## Tipos de identidad

| Identidad | Para qué sirve | Quién la gestiona | No debe utilizarse para |
| --- | --- | --- | --- |
| Usuario funcional Qontrolmed | Trabajar en la aplicación | Administrador funcional | Administrar Ubuntu o MySQL |
| Usuario documental SFTPGo | Acceder a documentos | Administrador documental | Acceso técnico al servidor |
| Cuenta Ubuntu/SSH | Mantenimiento técnico | Responsable técnico | Uso cotidiano de Qontrolmed |
| Cuenta técnica MySQL | Conexión automática de Qontrolmed | Responsable técnico | Inicio de sesión humano o administración |
| Cuenta administrativa MySQL | Diagnóstico y cambios autorizados | Administrador técnico | Configuración de puestos o uso diario |

Una misma persona puede necesitar más de una identidad, pero cada alta y baja se tramitará por separado.

## Datos mínimos de una solicitud

- Nombre de la persona.
- Empresa o unidad.
- Función que justifica el acceso.
- Sistema y rol solicitado.
- Fecha de inicio y, si procede, de caducidad.
- Responsable que autoriza.
- Responsable que ejecuta.
- Resultado de la verificación.

No se registrarán contraseñas, claves privadas, secretos TOTP o códigos de recuperación.

## Alta

1. Recibir una solicitud autorizada y comprobar que el rol corresponde al trabajo.
2. Verificar que no existe otra cuenta activa de la misma persona.
3. Crear una identidad nominal con el mínimo privilegio.
4. Entregar la activación por un canal controlado, sin transmitir todos los factores juntos.
5. Exigir el establecimiento personal de la contraseña o segundo factor cuando el sistema lo permita.
6. Probar una función permitida y una denegación representativa.
7. Registrar fecha, rol, responsable y resultado.

Los pasos exactos de pantalla se incorporarán después de validar la versión instalada en sede.

## Modificación

Una modificación de rol, cuota, carpeta, estado o datos identificativos requiere autorización y registro. Antes de ampliar permisos se revisará si basta un rol existente. Después del cambio se comprobarán tanto la nueva función como las restricciones que deben permanecer.

## Bloqueo temporal

Se utilizará cuando exista una ausencia prolongada, investigación o duda razonable sin decisión de baja. Debe impedir nuevas sesiones sin eliminar inmediatamente el historial ni los datos asociados. Se registrarán motivo, autorización, hora y criterio de reactivación.

## Baja

1. Confirmar identidad, sistemas afectados y fecha efectiva.
2. Bloquear el acceso con prioridad cuando exista riesgo o salida inmediata.
3. Revocar sesiones, factores, claves o dispositivos vinculados según el sistema.
4. Transferir documentos o responsabilidades únicamente a la persona autorizada.
5. Conservar la trazabilidad exigida; no reutilizar el nombre de usuario.
6. Verificar desde un acceso nuevo que la cuenta ya no entra.
7. Registrar ejecución y revisión.

La baja funcional no implica por sí sola borrar datos históricos. Cualquier eliminación estará sujeta a la política de conservación y protección de datos.

## Recuperación y rotación

- Verificar la identidad de la persona antes de restablecer acceso.
- Revocar el factor o credencial anterior antes de entregar uno nuevo.
- No preguntar ni anotar la contraseña anterior.
- No desactivar MFA de forma permanente para resolver una incidencia.
- Probar el acceso nuevo y registrar el cierre.

## Revisión periódica

Mensualmente durante el piloto, y con la frecuencia aprobada después, se revisarán cuentas activas, roles, últimos accesos relevantes, factores, cuentas sin responsable y accesos temporales vencidos. El resultado será una lista fechada de conservar, modificar, bloquear o dar de baja.

## Registro de actuación

| Fecha | Persona | Sistema | Operación | Rol anterior/nuevo | Autoriza | Ejecuta | Verificación |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

Este registro no contendrá secretos.
