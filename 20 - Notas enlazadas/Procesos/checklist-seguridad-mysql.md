---
title: "Checklist de seguridad MySQL"
type: process
status: seed
created: 2026-06-27
updated: 2026-06-27
sources: ["20 - Notas enlazadas/Fuentes/2026-06-27-mysql-reference-architectures-security.md"]
tags: [proceso, mysql, seguridad, base-de-datos, auditoria, checklist]
review_after: 2026-12-27
---

# Checklist de seguridad MySQL

## Objetivo

Convertir las indicaciones del white paper de Oracle en una lista de comprobacion reutilizable para revisar instancias MySQL. Es una guia preliminar de trabajo, no un procedimiento formal aprobado.

## 1. Inventario y clasificacion

- Identificar todas las instancias MySQL, version, entorno, criticidad y propietario tecnico.
- Clasificar el tipo de datos: identificacion, financieros, sanitarios, laborales, academicos, propiedad intelectual u otros datos sensibles.
- Marcar entornos con PII, PCI, PHI o datos especialmente protegidos.
- Identificar copias no productivas, replicas, backups y exportaciones.
- Definir nivel de proteccion: Bronze, Silver, Gold o Platinum.

## 2. Linea base y parcheo

- Comparar la configuracion con CIS Benchmark, DISA STIG o guia de seguridad MySQL.
- Revisar exposicion de red, puertos, permisos de ficheros, logs, autenticacion y parametros criticos.
- Verificar version de servidor, clientes, conectores, drivers JDBC y dependencias.
- Establecer cadencia de actualizacion y parcheo, preferentemente trimestral o segun criticidad.
- Registrar desviaciones aceptadas con responsable, motivo y fecha de revision.

## 3. Identidades y autenticacion

- Eliminar contrasenas en texto plano, scripts y codigo fuente.
- Prohibir cuentas compartidas para administradores, desarrolladores y operadores.
- Usar cuentas nominativas para DBAs y administradores de aplicacion.
- Limitar el uso de `root` a casos excepcionales y trazados.
- Activar politicas robustas de contrasena si se usan passwords.
- Implantar MFA o autenticacion fuerte cuando el entorno lo permita.
- Centralizar identidades con LDAP, Active Directory, Entra ID, Okta, OCI IAM, Kerberos, OIDC, PAM o certificados si es viable.
- Revisar cuentas huerfanas, inactivas y de antiguos usuarios.

## 4. Autorizacion y privilegios

- Revisar `SHOW GRANTS` y tablas de `information_schema` relacionadas con privilegios.
- Agrupar privilegios en roles por tarea.
- Aplicar minimo privilegio y segregacion de funciones.
- Separar funciones de administracion, backup, rendimiento, seguridad y desarrollo.
- Evitar privilegios globales salvo que sean estrictamente necesarios.
- Revisar privilegios de cuentas de servicio y cuentas de aplicacion.
- Documentar excepciones de privilegio elevado y su fecha de caducidad.

## 5. Cuentas de aplicacion y secretos

- Restringir cuentas de aplicacion por origen con `user@host` u otro control equivalente.
- Guardar secretos en gestor de secretos o vault, no en ficheros planos ni repositorios.
- Rotar credenciales con mecanismo de doble password cuando sea posible.
- Evitar que administradores de aplicacion usen la cuenta de servicio para tareas personales.
- Registrar propietarios, uso esperado y plan de rotacion de cada cuenta tecnica.

## 6. SQL injection y capa aplicativa

- Revisar aplicaciones expuestas y uso de consultas parametrizadas.
- Activar validacion de entrada y controles de desarrollo seguro.
- Considerar WAF para capa HTTP cuando aplique.
- Considerar firewall SQL o allow-list de sentencias en bases de alto riesgo o aplicaciones legadas.
- Monitorizar sentencias fuera de patron esperado antes de bloquear en produccion.

## 7. Cifrado y claves

- Cifrar conexiones con TLS y revisar version/cifrados permitidos.
- Usar mTLS o certificados cliente cuando el riesgo lo justifique.
- Activar cifrado en reposo para tablaspaces, logs y backups cuando proceda.
- Revisar si TDE u opcion equivalente cubre InnoDB, redo, undo y logs de auditoria.
- Gestionar claves maestras en vault o KMS fuera del servidor de base de datos.
- Documentar rotacion, custodia, backup y revocacion de claves.

## 8. Enmascaramiento y entornos no productivos

- Evitar copias de produccion con datos reales en desarrollo, pruebas o formacion.
- Enmascarar identificadores, datos financieros, datos sanitarios y otros datos sensibles.
- Validar que el dato enmascarado sigue siendo util para pruebas sin exponer informacion real.
- Controlar cesiones a terceros, analitica, formacion y soporte.

## 9. Auditoria y monitorizacion

- Auditar actividad de usuarios privilegiados.
- Auditar accesos a datos sensibles.
- Auditar cambios de privilegios, cuentas, roles y configuracion.
- Registrar usuario, aplicacion, origen, fecha/hora y accion realizada.
- Evitar auditoria indiscriminada que genere ruido y coste excesivo.
- Centralizar logs para alerta, informes, retencion y analisis forense.
- Proteger integridad, cifrado, retencion y borrado de logs de auditoria.

## 10. Ransomware y recuperacion

- Mantener backups inmutables o protegidos frente a borrado/cifrado malicioso.
- Validar restauracion a punto consistente entre bases relacionadas.
- Preparar infraestructura limpia de recuperacion.
- Aislar claves de cifrado fuera del servidor comprometible.
- Probar recuperacion y documentar RPO/RTO.

## Salida esperada de una revision

- Inventario de instancias y clasificacion.
- Nivel asignado por sistema: Bronze, Silver, Gold o Platinum.
- Brechas detectadas y riesgo asociado.
- Acciones correctoras priorizadas.
- Excepciones aceptadas con responsable y fecha de revision.
- Evidencia de configuracion, auditoria, cifrado, parches y backups.

## Limites

- Este checklist nace de un white paper de proveedor y requiere contraste con documentacion oficial vigente, normativa aplicable y politica interna.
- En entorno sanitario, cualquier uso sobre sistemas con datos reales debe pasar por responsable tecnico y responsable de seguridad o privacidad.

