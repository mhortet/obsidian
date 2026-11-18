---
title: "Reanudación P2P y arranque automático de MySQL"
type: state
status: active
created: 2026-11-17
updated: 2026-11-17
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2P-ESQUEMAS-DEFINITIVOS-IDENTIDADES-Y-ACCESOS-2026-11-16.md"
tags: [qontrolmed, sesion, mysql, p2p]
review_after: 2026-11-24
---

# Sesión 2026-11-17: reanudación P2P y arranque de MySQL

## Objetivo y motivo

Retomar P2P desde el punto seguro, revalidar MySQL y comprobar si ya puede
iniciarse automáticamente con Ubuntu sin ampliar su exposición de red.

## Punto seguro y límites

- Rama: `codex/produccion-readiness`, inicialmente en `92d27cf`.
- Se preservaron los cambios locales documentales y scripts P2P del 16/11.
- No se autorizó abrir 3306 en LAN, crear la cuenta runtime, activar SFTPGo ni
  insertar o modificar usuarios funcionales.

## Pasos, comandos y aprendizaje

### Revalidación SSH

Se consultaron `systemctl is-active mysql`, `systemctl is-enabled mysql`, las
unidades fallidas y los listeners 3306/33060.

- **Tipo de acción**: lectura y validación.
- **Resultado inicial**: `active/disabled`, sin unidades fallidas y escucha
  única en `127.0.0.1:3306`.
- **Interpretación**: MySQL funcionaba, pero no estaba configurado para
  iniciarse automáticamente con Ubuntu.

### Habilitación del arranque automático

El propietario ejecutó directamente `sudo systemctl enable mysql` e introdujo
su contraseña fuera de Codex. No se registró ni compartió ningún secreto.

- **Tipo de acción**: cambio operativo reversible.
- **Resultado posterior observado**: `active/enabled`, sin unidades fallidas y
  escucha exclusiva en `127.0.0.1:3306`.
- **Alcance**: se habilitó el arranque del servicio; no se abrió la LAN, no se
  reinició MySQL y no se modificaron esquemas, cuentas o datos.
- **Reversión**: `sudo systemctl disable mysql`. Este comando no detiene el
  servicio ya activo; una parada sería una decisión separada.

### Inventario funcional

Tras recuperar la conexión, Workbench ejecutó una única consulta de solo
lectura sobre `roles`, `permisos`, `roles_permisos` y `usuarios`. No se
consultaron nombres, contraseñas ni hashes y no hubo escrituras.

El inventario observó 0 roles, 0 permisos, 0 relaciones y 0 usuarios. Los
controles de relaciones huérfanas, usuarios sin rol y usuarios con rol inválido
también devolvieron 0. La base está vacía y es compatible con el punto de
partida greenfield, pero aún no contiene las semillas 4/40/75 necesarias para
el login funcional.

## Observado, inferido y decidido

### Observado

- `srv-mm-01` accesible por SSH en `192.168.1.31`.
- MySQL `active/enabled` y limitado a `127.0.0.1:3306`.
- Cero unidades fallidas en la comprobación posterior.
- Gestión: 0 roles, 0 permisos, 0 asignaciones y 0 usuarios; sin huérfanos.

### Inferido

- El arranque automático no amplía por sí solo la superficie de red mientras
  se conserve la escucha exclusiva en loopback.

### Decidido

- El propietario decidió mantener MySQL habilitado al arranque del servidor.

## Riesgos y pendientes

- No ejecutar los SQL de semillas ni crear el administrador inicial hasta
  revisar y autorizar el plan P2Q de bootstrap.

P2Q fue autorizado posteriormente. La fase SQL terminó con 4 roles, 40
permisos, 75 asignaciones, 0 huérfanos y un superusuario activo sin hash. La
carpeta temporal se retiró y la copia P2Q permanece en el servidor.

La asignación de la primera contraseña quedó detenida de forma segura: no
existe todavía la cuenta técnica runtime y no se reutilizará la cuenta
administrativa en Qontrolmed. El modo sin contraseña no se activó.

Tras autorizar el bloque de cuenta runtime, el precheck identificó que el
ejecutable instalado es del 15/07/2026 y anterior al bootstrap seguro, TLS
endurecido y guard de esquema actuales. La instalación tampoco dispone aún de
la CA pública prevista. No se creó la cuenta runtime, no se leyó ni modificó el
`.env` y la RC histórica no se conectó a las bases definitivas.

## Siguiente paso recomendado

P2R preparó un arnés temporal desde desarrollo, pero la creación de la cuenta
se detuvo al faltar `quirofanos.qontrolmed_schema_migrations`. El propietario
ejecutó la retirada de la cuenta parcial. La comprobación posterior observó
cero ledgers en los seis esquemas y una divergencia adicional: las columnas
`tecnico_cierre` son compatibles con v1, pero `ruta_certificado` es
`VARCHAR(100)` tanto en el esquema piloto como en el definitivo, frente al
`VARCHAR(500)` exigido por v2. No se activó el modo sin contraseña ni se inició
Qontrolmed.

El script de cuenta temporal quedó blindado con precheck de los ocho objetos
requeridos y retirada automática de la cuenta ante cualquier fallo. P2R queda
detenido hasta autorizar y completar P2S, que propone copia previa, corrección
estructural, aprovisionamiento del ledger, registro canónico y validación del
guard sin modificar el esquema `piloto_mm_quirofanos`.

P2S fue autorizado y completado después. La copia previa verificada quedó en
`/var/backups/qontrolmed/p2s-20261117T083320Z`; `ruta_certificado` pasó a
`VARCHAR(500)`, el ledger quedó con sus dos versiones canónicas y el script
terminó con `P2S_RESULTADO=OK`. La revalidación posterior confirmó MySQL
`active/enabled`, cero unidades fallidas y escucha solo en `127.0.0.1:3306`.
Se retiró el script temporal de `/tmp` y se conservó la copia. Workbench quedó
momentáneamente sin responder durante un refresco automatizado, por lo que no
se forzó su cierre; este incidente de interfaz no afectó al servidor.

P2R se reanudó después de P2S. El lanzador local necesitó dos correcciones:
resolución tardía de `ProjectRoot` y escritura del `.env` efímero en UTF-8 sin
BOM. También se detectó que el Python local conservaba
`mysql-connector-python 8.4.0`; se instaló la versión 9.7.0 fijada por el
proyecto y pasaron 23 pruebas de TLS, ledger y bootstrap.

La conexión alcanzó MySQL, pero este rechazó
`qontrolmed_bootstrap@localhost` con error 1045. Hubo dos intentos iniciales;
se rotó de forma oculta la contraseña temporal preservando los grants y otros
dos intentos devolvieron el mismo error. No se alcanzó el login funcional, no
se estableció contraseña al administrador y no cambió `password_hash`.

El propietario pidió pausar. Al cierre, el `.env` original estaba restaurado,
no quedaban copias temporales locales, se detuvo el túnel 13306 y se eliminaron
de `/tmp` los scripts de crear, retirar y rotar. La cuenta MySQL temporal sigue
existente porque su retirada requiere `sudo`; es la primera acción obligatoria
de la próxima sesión. Después se diagnosticará el plugin/estado de la cuenta y
se exigirá una prueba mínima de autenticación antes de volver a abrir Qontrolmed.

## Reanudación y cierre P2R/P2T

La cuenta pendiente se retiró antes de continuar. El arnés se endureció con
pruebas `SELECT 1` por socket y túnel, diagnóstico depurado de la identidad y
limpieza condicionada del `.env`. Se sustituyó el cliente `mysql` ausente en
Windows por un comprobador Python separado con `mysql.connector` 9.7.0.

Los intentos revelaron tres causas independientes: caída o espera del túnel,
conexión MySQL sin TLS rechazada por `require_secure_transport=ON` y ledger
marcado `recovered`. La conexión final usó la CA pública presentada por MySQL,
huella fijada e identidad `127.0.0.1` incluida en el SAN. P2T, autorizado como
bloque propio, creó una copia previa y cambió exclusivamente las dos filas
canónicas del ledger a `applied` tras comprobar estructura, versiones,
identificadores y hashes.

Qontrolmed superó entonces el guard y el propietario asignó la contraseña
funcional inicial desde la UI. El cierre depurado observó 4 roles, 40 permisos,
75 asignaciones, cero huérfanos, un administrador activo con hash presente y
ledger v1/v2 `applied`; no se leyó ningún hash ni se registraron contraseñas.
Se retiraron la cuenta temporal, scripts remotos, túnel y CA temporal.

Un defecto del `finally` del primer lanzador eliminó `compartido/.env` antes de
crear su copia temporal. No se encontró copia recuperable. Con autorización
del propietario se reconstruyó mediante entrada interactiva de las credenciales
locales originales. La validación confirmó estructura, loopback, bootstrap sin
contraseña desactivado e ignorado por Git, sin imprimir valores. Pasaron 23
pruebas de TLS, guard y bootstrap. Permanece pendiente la cuenta runtime
definitiva; no se abrió MySQL a la LAN ni se construyó o instaló una RC.
