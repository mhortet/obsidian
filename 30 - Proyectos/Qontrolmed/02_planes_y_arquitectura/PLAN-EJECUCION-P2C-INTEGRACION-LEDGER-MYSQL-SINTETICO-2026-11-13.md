---
title: "Plan P2C: integración del ledger con MySQL sintético"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P2B-LEDGER-Y-COMPATIBILIDAD-LOCAL-2026-11-11.md"
  - "docs/02_planes_y_arquitectura/CONTRATO-LEDGER-ESQUEMA-P2A-2026-11-11.md"
  - "bd/migraciones/aprovisionar_ledger_esquema.sql"
  - "H:\\02.Trabajo\\obsidian\\30 - Proyectos\\Servidor_MM\\Servidor\\DOCUMENTACION-SERVIDOR-UBUNTU.md"
tags: [qontrolmed, p2, ledger, mysql, integracion]
review_after: 2026-11-20
---

# Plan P2C: integración del ledger con MySQL sintético

## 1. Objetivo

Demostrar en MySQL Community Server 8.4.11 que el SQL administrativo de P2B
crea el ledger con el contrato esperado y que las filas leídas desde una base
sintética producen los cuatro estados de compatibilidad previstos, sin usar
esquemas, cuentas ni datos de Qontrolmed reales.

Este plan prepara una prueba técnica aislada. No instala Qontrolmed, no crea
una RC y no autoriza producción.

## 2. Destino exacto y precondiciones

- servidor: `srv-mm-01`, IP doméstica reservada `192.168.1.31`;
- motor: MySQL Community Server `8.4.11` ya instalado;
- servicio inicialmente `inactive/disabled` y finalmente en el mismo estado;
- escucha MySQL limitada a `127.0.0.1:3306`, X Plugin deshabilitado y
  `require_secure_transport=ON`;
- acceso administrativo por SSH verificado y administración MySQL por socket
  local; no se abre 3306 en UFW ni se habilita acceso LAN;
- esquema temporal exacto: `qontrolmed_ledger_it_20261113`;
- cuenta temporal exacta: `qontrolmed_ledger_reader`@`localhost`;
- datos exclusivamente sintéticos, sin `.env`, copias reales ni credenciales
  documentadas.

Antes de ejecutar se revalidarán versión, servicio, listeners, configuración
efectiva, montajes, espacio, unidades fallidas y ausencia del esquema y cuenta
temporales. Una diferencia detiene la prueba antes de modificar MySQL.

## 3. Privilegios y separación de funciones

La administración por socket crea y retira el esquema y la cuenta. La cuenta
temporal recibe únicamente:

```sql
SELECT ON qontrolmed_ledger_it_20261113.qontrolmed_schema_migrations
```

No recibe privilegios globales, DDL, DML, `FILE`, `PROCESS`, administración de
usuarios ni acceso a otros esquemas. Los prechecks y postchecks de estructura
se ejecutan por la sesión administrativa local. La comprobación de lectura se
repite con la cuenta temporal.

La contraseña temporal se genera e introduce durante la ventana, no se muestra
en terminales capturadas ni se escribe en repositorio, chat o evidencias.

## 4. Secuencia autorizable

### 4.1. Preparación y línea base

1. Arrancar el servidor, desbloquear LUKS localmente y revalidar su estado
   seguro según el runbook vigente.
2. Cargar temporalmente la identidad SSH y verificar la clave de host.
3. Confirmar MySQL 8.4.11, servicio detenido/deshabilitado, 3306/33060 cerrados,
   cero unidades fallidas y espacio suficiente.
4. Verificar la configuración antes de arrancar; debe mantener loopback,
   transporte seguro y X Plugin deshabilitado.
5. Registrar que no existen el esquema ni la cuenta temporales.

### 4.2. Arranque contenido y copia previa

1. Iniciar MySQL manualmente sin habilitarlo al arranque.
2. Verificar `VERSION()`, `bind_address`, `require_secure_transport`, TLS,
   puerto 3306 solo en loopback y ausencia de 33060.
3. Crear el esquema sintético vacío con `utf8mb4`.
4. Generar un `mysqldump --no-data` del esquema vacío en una ruta temporal
   restringida, calcular SHA-256 y comprobar que el volcado es legible. Esta es
   la copia previa de la prueba; no contiene datos operativos.

### 4.3. Aprovisionamiento del ledger

1. Seleccionar explícitamente `qontrolmed_ledger_it_20261113` y comprobar
   `SELECT DATABASE()`.
2. Ejecutar el artefacto versionado
   `bd/migraciones/aprovisionar_ledger_esquema.sql` sin sustituirlo por SQL
   reconstruido manualmente.
3. Comprobar las ocho columnas, clave primaria, versión única, restricciones,
   motor InnoDB, `utf8mb4` y cero filas.
4. Repetir el aprovisionamiento para demostrar que no destruye ni duplica la
   tabla existente.

### 4.4. Casos integrados sintéticos

Insertar y retirar únicamente filas sintéticas bajo sesión administrativa para
observar, por lectura real del ledger, al menos:

1. ledger vacío → `migration-required`;
2. fila exacta `quirofanos-0001-tecnico-cierre`, versión 1, hash versionado y
   resultado `applied` → `compatible`;
3. hash alterado → `inconsistent`;
4. resultado `recovered` → `inconsistent`;
5. versión posterior/desconocida → `unsupported-newer`;
6. intento de duplicar versión → rechazo por la restricción única;
7. intento de hash no canónico → rechazo por la restricción `CHECK`;
8. lectura con la cuenta temporal correcta y rechazo de `INSERT`, `UPDATE`,
   `DELETE`, `CREATE`, acceso a otro esquema y administración de usuarios.

La herramienta de prueba deberá transformar las filas leídas a
`LedgerRow` y llamar al comprobador P2B existente; no contendrá rutas de
escritura ni ejecutará migraciones automáticamente.

## 5. Postcheck y aceptación

La puerta P2C exige simultáneamente:

- versión y contención de MySQL coincidentes con el plan;
- estructura real del ledger igual al contrato P2A/P2B;
- estados de compatibilidad esperados para todos los casos;
- restricciones MySQL rechazando duplicados y hashes inválidos;
- cuenta lectora capaz de consultar el ledger e incapaz de escribir, ejecutar
  DDL o acceder a otros esquemas;
- suite local, manifiesto, Bandit y controles remotos correctos;
- cero secretos y cero datos reales en salidas o evidencias;
- retirada completa del esquema, cuenta, credenciales y artefactos temporales;
- MySQL nuevamente `inactive/disabled`, sin 3306/33060, identidad SSH retirada
  y servidor apagado o en el estado acordado.

## 6. Reversión y cierre

Si falla antes de crear el esquema, detener MySQL y volver a la línea base.
Si falla después:

1. preservar salida depurada y hash de la copia vacía;
2. revocar y eliminar la cuenta temporal;
3. eliminar exclusivamente `qontrolmed_ledger_it_20261113`, después de
   comprobar nombre exacto y ausencia de datos no sintéticos;
4. si se necesita demostrar recuperación, restaurar la copia vacía en el mismo
   esquema temporal, validar y volver a retirarlo;
5. eliminar de forma controlada la copia y credencial temporales;
6. detener MySQL, confirmar `inactive/disabled` y puertos cerrados;
7. retirar la identidad SSH y apagar de forma controlada con
   `sudo systemctl poweroff` si no existe otro trabajo autorizado.

No se modifica ni restaura ningún esquema existente. Una anomalía de identidad,
almacenamiento, configuración, servicio o contenido inesperado obliga a parar y
requiere una decisión nueva.

## 7. Límites expresos

- sin datos reales, `.env`, certificados privados ni cuentas productivas;
- sin escucha MySQL en LAN, cambios UFW, DNS, CA de sede o puestos cliente;
- sin actualizar paquetes ni cambiar la configuración persistente del servidor;
- sin ejecutar la migración funcional `tecnico_cierre` sobre una base real;
- sin integrar todavía el guard de esquema en el arranque de Qontrolmed;
- sin construir o instalar una RC;
- sin promover las otras migraciones al manifiesto.

## 8. Autorización necesaria

P2C afecta a Qontrolmed y a `srv-mm-01`; por tanto, antes de ejecutarlo debe
quedar aprobado como plan transversal o reflejado mediante un plan compatible
en Servidor_MM. Su aprobación cubre la ventana completa, comprobaciones,
artefactos temporales, cierre y reversión descritos, pero no amplía los límites
del apartado anterior.

## 9. Aprobación

El propietario aprobó expresamente el bloque transversal P2C el 13/11/2026,
junto con el plan compatible de Servidor_MM. La aprobación autoriza la ventana
completa dentro de los límites, prechecks, aceptación y reversión descritos.

## 10. Ampliación TLS aprobada tras el primer intento

El primer intento P2C falló de forma segura en `VERIFY_IDENTITY`: MySQL
presentó su certificado automático, cuya cadena era válida pero no contenía
SAN. La limpieza dejó MySQL detenido/deshabilitado, puertos cerrados y retiró
los objetos temporales.

El inventario confirmó que ya existe un certificado piloto separado en
`/var/lib/mysql/piloto-tls/server-cert.pem`, emitido por
`/var/lib/mysql/piloto-tls/ca.pem`, con SAN `srv-mm-01`, `127.0.0.1` y
`192.168.1.31`. El propietario aprobó expresamente ampliar P2C para:

1. validar cadena, vigencia, correspondencia entre clave y certificado y
   permisos sin mostrar la clave privada;
2. crear un único drop-in temporal `91-p2c-tls-temporal.cnf` que seleccione
   esos artefactos;
3. validar configuración, iniciar MySQL y comprobar el certificado efectivo;
4. repetir P2C con `VERIFY_IDENTITY`, sin degradar a `VERIFY_CA`;
5. retirar el drop-in solo si conserva el hash esperado, detener MySQL y
   confirmar la línea base.

No se generan certificados, no se modifica la CA y no se deja configuración
persistente al cerrar.

## 11. Resultado

P2C se completó correctamente el 13/11/2026. MySQL aplicó las restricciones
esperadas, la cuenta lectora fue de mínimo privilegio y las exportaciones reales
produjeron `migration-required`, `compatible`, `inconsistent` y
`unsupported-newer` según el contrato.

El drop-in TLS temporal se retiró con comprobación de hash. MySQL volvió a
`inactive/disabled`, sin proceso ni puertos, y no quedaron configuración TLS,
cuenta o esquema temporales. Evidencia:
`docs/05_evidencias/VALIDACION-P2C-LEDGER-MYSQL-SINTETICO-2026-11-13.md`.
