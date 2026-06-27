---
title: "Arquitectura de seguridad MySQL"
type: concept
status: active
created: 2026-06-27
updated: 2026-06-27
sources: ["20 - Notas enlazadas/Fuentes/2026-06-27-mysql-reference-architectures-security.md"]
tags: [mysql, seguridad, base-de-datos, arquitectura, defensa-en-profundidad, datos-sensibles]
review_after: 2026-12-27
---

# Arquitectura de seguridad MySQL

## Definicion

Una arquitectura de seguridad MySQL es el conjunto organizado de controles tecnicos, operativos y de gobierno destinados a proteger los datos almacenados en MySQL frente a accesos indebidos, robo, destruccion, corrupcion, errores de configuracion y abuso de privilegios.

## Principio central

La proteccion debe ser proporcional a la sensibilidad del dato y a la criticidad del sistema. No todas las bases requieren el mismo nivel de inversion, pero todas deben tener una linea base minima de configuracion segura, parcheo y trazabilidad de actividad privilegiada.

## Capas de control

### 1. Evaluacion de postura

- Inventario de instancias, versiones y exposicion.
- Clasificacion de datos sensibles y sistemas criticos.
- Comparacion contra linea base: CIS Benchmark, DISA STIG o guia MySQL.
- Deteccion de deriva de configuracion.
- Revision de parches, componentes, drivers y clientes.

### 2. Control de acceso

- Cuentas nominativas para personas.
- Prohibicion de cuentas compartidas para tareas administrativas.
- Restriccion del uso de `root` a operaciones excepcionales.
- Roles por tarea y minimo privilegio.
- Segregacion de funciones entre administracion, seguridad, backup, desarrollo y explotacion.
- Autenticacion fuerte: MFA, OIDC, Kerberos, LDAP/AD, certificados o WebAuthn cuando proceda.
- Gestion de secretos para cuentas de aplicacion.

### 3. Proteccion del dato

- Cifrado en transito mediante TLS.
- Cifrado en reposo mediante TDE u opcion equivalente.
- Cifrado y proteccion de backups.
- Gestion externa o centralizada de claves cuando la criticidad lo justifique.
- Enmascaramiento o anonimizado antes de reutilizar datos reales fuera de produccion.
- Backups inmutables y recuperacion sincronizada frente a ransomware.

### 4. Monitorizacion y auditoria

- Auditoria de actividad privilegiada.
- Registro de accesos a datos sensibles.
- Eventos de seguridad y cambios de privilegios.
- Centralizacion de logs para alerta, retencion y analisis forense.
- Politicas selectivas para evitar ruido, coste excesivo y perdida de senal.

### 5. Proteccion de aplicacion y SQL

- Desarrollo seguro contra SQL injection.
- Validacion de entrada y consultas parametrizadas en aplicacion.
- WAF si el contexto web lo requiere.
- Firewall SQL o allow-list de sentencias cuando haya riesgo alto o aplicaciones legadas.

## Clasificacion por niveles

- Bronze: configuracion segura, parcheo y auditoria de usuarios privilegiados.
- Silver: controles Bronze mas cifrado de red, proteccion del sistema operativo, cifrado en reposo, autenticacion fuerte y entornos no productivos seguros.
- Gold: controles Silver mas restricciones a usuarios privilegiados, monitorizacion SQL y proteccion especifica de PII, PCI o PHI.
- Platinum: controles Gold mas restricciones de acceso al servidor, monitorizacion SQL casi en tiempo real, prevencion reforzada de SQL injection y auditoria forense completa.

## Aplicacion en contexto sanitario

En sistemas con datos sanitarios, identificadores personales, trazabilidad asistencial o informacion operacional sensible, esta arquitectura debe tratarse como punto de partida. Antes de implantarla como procedimiento formal hay que contrastarla con normativa aplicable, politica de seguridad local, clasificacion ENS si aplica, RGPD, contratos con proveedores y responsable de validacion.

## Senales de riesgo

- Usuarios administradores compartidos o sin trazabilidad individual.
- Credenciales en scripts, repositorios, ficheros `.env` sin control o documentacion.
- Bases de desarrollo con datos reales sin enmascarar.
- Backups accesibles desde el mismo plano comprometible que la base.
- Auditoria desactivada o tan amplia que no se revisa.
- Claves de cifrado en el mismo servidor que los datos cifrados.
- Sistemas sin inventario claro, sin versionado y sin cadencia de parcheo.

## Fuentes y relaciones

- Fuente principal: [[2026-06-27-mysql-reference-architectures-security]].
- Proceso operativo: [[checklist-seguridad-mysql]].

