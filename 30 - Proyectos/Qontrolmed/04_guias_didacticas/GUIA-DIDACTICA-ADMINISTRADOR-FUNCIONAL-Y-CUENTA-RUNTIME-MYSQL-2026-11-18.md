---
title: "Guía didáctica: administrador funcional y cuenta runtime MySQL"
type: guide
status: active
created: 2026-11-18
updated: 2026-11-18
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2Q-BOOTSTRAP-FUNCIONAL-INICIAL-2026-11-17.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2R-BOOTSTRAP-DESDE-DESARROLLO-2026-11-17.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2U-CUENTA-RUNTIME-MINIMO-PRIVILEGIO-2026-11-18.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2W-SMOKE-FUNCIONAL-RUNTIME-DESARROLLO-2026-11-18.md"
tags: [qontrolmed, guia-didactica, identidades, mysql, bootstrap, runtime]
review_after: 2026-12-18
---

# Guía didáctica: administrador funcional y cuenta runtime MySQL

## 1. Para qué sirve esta guía

En las sesiones del 17 y 18 de noviembre de 2026 se realizaron dos trabajos
relacionados con usuarios y contraseñas. Vistos desde fuera pueden parecer el
mismo proceso repetido varias veces. No lo fueron.

Los dos objetivos principales fueron:

1. crear y activar el **primer administrador funcional de Qontrolmed**;
2. crear y verificar la **cuenta técnica MySQL que utiliza Qontrolmed para
   conectarse a las bases de datos**.

Las dos identidades participan en el mismo inicio de la aplicación, pero
pertenecen a capas distintas y cumplen funciones diferentes. La mayor parte de
la confusión procede de llamar «usuario» o «administrador» a identidades que no
son intercambiables.

Esta guía explica qué se hizo, por qué se separó, qué comprobó cada intento,
qué errores fueron detectados y cuál es el estado final. No contiene
contraseñas, hashes ni instrucciones para saltarse los controles de seguridad.

## 2. La idea fundamental: Qontrolmed atraviesa dos puertas

Al abrir Qontrolmed ocurren dos autenticaciones diferentes:

```text
Puesto Windows
    |
    | 1. Cuenta técnica + TLS
    v
Servidor MySQL
    |
    | 2. Usuario funcional + contraseña de Qontrolmed
    v
Menú y permisos de la aplicación
```

### Primera puerta: conexión técnica a MySQL

Antes de mostrar la pantalla de login, el programa necesita conectarse a los
esquemas `gestion`, `preventivos` y `quirofanos`. Para ello usa una identidad
MySQL como `qontrolmed_runtime_dev@localhost`.

Esta cuenta no representa a una persona. Representa al programa ejecutándose
desde un origen autorizado. Su contraseña se guarda en la configuración
técnica del puesto, no se escribe en la pantalla de login de Qontrolmed.

### Segunda puerta: login funcional de Qontrolmed

Cuando la conexión técnica ya funciona, Qontrolmed muestra su ventana de
autenticación. En ella entra una persona mediante un usuario almacenado en
`gestion.usuarios`.

Ese usuario tiene un rol funcional, por ejemplo `superusuario`, y permisos
como gestionar usuarios, abrir Preventivos o consultar Quirófanos. Su
contraseña no es la contraseña de la cuenta MySQL.

Por tanto, que la primera puerta funcione no significa que cualquier persona
pueda entrar. Y que una persona conozca su contraseña de Qontrolmed no le da
acceso directo a MySQL.

## 3. Las identidades que intervinieron

| Identidad | Capa | Para qué se utilizó | Estado final |
| --- | --- | --- | --- |
| `vicente` | Ubuntu/SSH | Entrar administrativamente en `srv-mm-01` y ejecutar acciones autorizadas con `sudo` | Se conserva como identidad técnica del servidor |
| `qontrolmed_admin@localhost` | MySQL administrativa | Crear esquemas, revisar cuentas y ejecutar cambios administrativos controlados | No se usa desde Qontrolmed |
| `qontrolmed_bootstrap@localhost` | MySQL temporal | Permitir que el código actual asignara la primera contraseña funcional | Eliminada al terminar P2R |
| Administrador funcional | Qontrolmed | Iniciar sesión y administrar funciones de la aplicación según su rol | Activo, con hash de contraseña presente |
| `qontrolmed_runtime_dev@localhost` | MySQL runtime | Conectar Qontrolmed a los tres esquemas con permisos mínimos | Activa tras P2U |

La regla importante es la **separación de funciones**: una identidad destinada
a administrar el servidor o MySQL no debe convertirse en la cuenta cotidiana
de la aplicación.

## 4. Primer proceso: crear el administrador funcional

### 4.1. Punto de partida

Las tablas de seguridad de `gestion` estaban vacías. No existían roles,
permisos, relaciones rol-permiso ni usuarios funcionales.

Antes de crear una persona administradora había que sembrar el modelo de
autorización. El resultado esperado era:

- 4 roles;
- 40 permisos;
- 75 relaciones entre roles y permisos;
- 0 relaciones huérfanas;
- 1 administrador funcional inicial.

Una relación huérfana sería, por ejemplo, un permiso asignado a un rol que no
existe. Comprobar que hay cero huérfanos evita una seguridad incoherente.

### 4.2. Qué significa «bootstrap»

**Bootstrap** es el procedimiento especial de primera puesta en marcha. Existe
un problema circular: para crear usuarios desde la aplicación hace falta un
administrador, pero todavía no existe ninguno.

La solución fue insertar un único administrador inicial sin hash de contraseña
y permitir, durante una ventana controlada, que Qontrolmed le solicitara su
primera contraseña. La contraseña se introdujo directamente en la interfaz y
la base de datos almacenó únicamente su hash.

Un **hash de contraseña** es un resultado irreversible utilizado para
comprobar una contraseña sin guardar el texto original. La documentación solo
verificó que el hash estaba presente; nunca leyó ni mostró su contenido.

### 4.3. P2Q: semillas y usuario inicial

P2Q realizó las siguientes acciones:

1. comprobó que las tablas de seguridad seguían vacías;
2. creó una copia previa de `gestion` y verificó su SHA-256;
3. insertó los 4 roles, 40 permisos y 75 asignaciones canónicas;
4. insertó un único administrador funcional activo;
5. comprobó recuentos, rol de superusuario y ausencia de huérfanos.

P2Q se detuvo correctamente antes de asignar la contraseña. La aplicación no
debía conectarse usando `qontrolmed_admin`, porque esa cuenta administrativa
tendría más privilegios de los necesarios.

### 4.4. P2R: asignación de la primera contraseña

P2R creó una cuenta MySQL temporal llamada `qontrolmed_bootstrap`. Solo podía
leer lo necesario para autenticar, actualizar las columnas de contraseña e
insertar auditoría.

El proceso fue:

1. abrir un túnel SSH desde Windows hasta MySQL;
2. proporcionar temporalmente la CA pública;
3. ejecutar el código actual de noviembre, no la RC antigua de julio;
4. mostrar el flujo de primera contraseña;
5. introducir la contraseña funcional directamente en Qontrolmed;
6. confirmar que el administrador terminó con hash;
7. desactivar el modo excepcional sin contraseña;
8. retirar la cuenta `qontrolmed_bootstrap`, el túnel, la CA y los scripts
   temporales.

Al terminar P2R, la persona administradora ya podía autenticarse en
Qontrolmed. Sin embargo, la cuenta técnica definitiva del programa seguía
pendiente. Esto explica por qué la sesión siguiente volvió a hablar de crear
una cuenta: era otra cuenta, de otra capa.

## 5. Segundo proceso: crear la cuenta runtime de MySQL

### 5.1. Qué es una cuenta runtime

**Runtime** significa «durante la ejecución». La cuenta runtime es la identidad
que utiliza Qontrolmed cada vez que arranca y trabaja con MySQL.

No debe poder:

- crear o borrar bases de datos;
- alterar tablas;
- crear usuarios MySQL;
- conceder permisos;
- leer módulos excluidos como Compras;
- modificar el ledger de migraciones.

Sí debe poder leer y escribir las tablas concretas que necesita Gestión
mínima, Preventivos y Quirófanos.

Esto es el **principio de mínimo privilegio**: conceder solo lo imprescindible
para la función prevista.

### 5.2. P2U: creación y verificación

P2U creó `qontrolmed_runtime_dev@localhost` con estas propiedades:

- autenticación `caching_sha2_password`;
- transporte cifrado obligatorio mediante `REQUIRE SSL`;
- permisos por tabla;
- sin privilegios globales;
- sin DDL;
- sin administración de usuarios;
- sin `GRANT OPTION`.

El sufijo `@localhost` forma parte de la identidad MySQL. Indica desde qué
origen acepta MySQL esa cuenta. En esta fase se utilizó un túnel SSH que llega
al loopback del servidor; todavía no se ha abierto MySQL a la LAN.

### 5.3. Qué verificaron las pruebas positivas

Las pruebas positivas confirmaron:

- conexión por túnel;
- cadena TLS válida;
- identidad `127.0.0.1` incluida en el certificado;
- lectura de `gestion`, `preventivos` y `quirofanos`;
- compatibilidad del ledger;
- login real de Qontrolmed;
- apertura de Gestión mínima, Preventivos y Quirófanos.

### 5.4. Qué verificaron las pruebas negativas

Una prueba de seguridad no debe limitarse a comprobar «lo permitido funciona».
También debe comprobar «lo prohibido falla».

P2U confirmó que la cuenta runtime no podía:

- acceder a las tablas de Compras;
- escribir en `qontrolmed_schema_migrations`;
- crear una tabla temporal;
- conectarse por TCP sin TLS.

Estas denegaciones son tan importantes como las pruebas positivas. Demuestran
que los límites no existen solo en un documento.

## 6. P2W: la comprobación completa desde la aplicación

P2U demostró técnicamente que la cuenta funcionaba. P2W comprobó el recorrido
completo que hará un usuario:

```text
Cuenta runtime -> TLS -> guard de esquema -> login funcional -> módulos
```

La configuración se inyectó únicamente en el proceso de prueba. El archivo
`compartido/.env` no se movió ni se reescribió. Al cerrar, el lanzador comparó
su existencia, tamaño y SHA-256 antes y después.

El resultado final fue:

- login funcional correcto;
- Gestión mínima abre y cierra;
- Preventivos abre y cierra;
- Quirófanos abre y cierra;
- Compras y analítica quedan ocultas;
- `.env` queda idéntico;
- contraseña runtime, CA temporal y túnel se retiran del proceso;
- MySQL continúa solo en `127.0.0.1:3306`.

## 7. Por qué hubo varios intentos

No todos los intentos repitieron el mismo trabajo. Cada uno añadió una
comprobación o corrigió una hipótesis concreta.

| Incidencia | Qué parecía | Causa real | Qué se aprendió o corrigió |
| --- | --- | --- | --- |
| Ledger rechazado | La conexión no funcionaba | P2S registró `recovered`, pero el guard solo acepta `applied` | P2T canonizó únicamente las dos filas verificadas |
| Error 1045 de bootstrap | Contraseña incorrecta | La prueba mezclaba clientes, túnel y TLS sin aislar cada capa | Se añadieron `SELECT 1` separados por socket y túnel |
| `.env` eliminado | Fallo de conexión | El bloque `finally` limpiaba antes de confirmar la copia | Se reconstruyó con entrada local y P2W dejó de mover `.env` |
| P2U consultó `version` | Ledger incompatible | La columna real se llama `schema_version` | El precheck se alineó con el contrato canónico |
| Cuenta `REQUIRE SSL` falló por socket | Contraseña incorrecta | Una cuenta que exige SSL debía probarse por TCP/TLS | La autenticación runtime pasó al túnel TLS |
| Cuenta parcial permaneció | La reversión había funcionado | `trap ERR` no se ejecutaba al salir mediante `fail` | La función `fail` retira explícitamente la cuenta parcial |
| `SHOW GRANTS` no mostraba `REQUIRE SSL` | Faltaba SSL | MySQL registra la exigencia en `mysql.user.ssl_type=ANY` | Se usó el estado autoritativo y no una búsqueda textual frágil |
| Certificado «sin SAN» | Había que regenerar certificados | Se inspeccionó la CA automática inactiva, no `@@ssl_ca` | Se consultan siempre las rutas efectivas de MySQL; P2V se canceló sin cambios |
| Qontrolmed usó `administrador` como usuario MySQL | La cuenta runtime no funcionaba | `.env` sobrescribía variables explícitas del proceso | El entorno tiene prioridad y existe prueba de regresión |
| Compras seguía visible | El alcance estaba aplicado | El superusuario anulaba el ocultamiento | Se centralizó la puerta de alcance también para superusuarios |

La repetición útil sigue este patrón:

1. observar un fallo concreto;
2. detenerse antes de ampliar el daño;
3. aislar la capa responsable;
4. corregir el arnés o el código;
5. repetir solo la prueba afectada;
6. limpiar y volver a la línea base.

Lo que habría sido incorrecto es repetir exactamente el mismo intento sin
cambiar ninguna hipótesis ni añadir evidencia.

## 8. Conceptos utilizados

### Cuenta funcional

Usuario de una persona dentro de Qontrolmed. Sus permisos los decide el modelo
de roles de la aplicación.

### Cuenta técnica MySQL

Identidad utilizada por un programa o una tarea administrativa para conectarse
a MySQL. Sus privilegios los decide MySQL.

### Rol y permiso

Un rol agrupa capacidades funcionales. Un permiso representa una acción
concreta. Qontrolmed consulta ambos después del login.

### TLS

Cifra la comunicación y permite comprobar la identidad del servidor. Evita que
la contraseña y los datos viajen en claro por la red.

### CA

La autoridad certificadora que firma el certificado del servidor. Qontrolmed
recibe únicamente su certificado público, nunca la clave privada.

### SAN

`Subject Alternative Name`. Lista los nombres o IP para los que un certificado
es válido. El certificado activo incluye `127.0.0.1`, necesario para el túnel.

### Túnel SSH

Canal cifrado que hace que un puerto local de Windows llegue al puerto MySQL
del servidor sin abrir 3306 a la LAN.

### SHA-256

Huella digital utilizada para comprobar que un archivo no ha cambiado. Se
utilizó en copias, CA y `.env` sin publicar su contenido.

### Ledger de esquema

Tabla que registra qué migraciones estructurales se han aplicado. El guard de
Qontrolmed la lee antes del login y bloquea estados desconocidos.

### DDL y DML

- **DDL** cambia la estructura: `CREATE`, `ALTER`, `DROP`.
- **DML** trabaja con datos: `SELECT`, `INSERT`, `UPDATE`, `DELETE`.

La cuenta runtime necesita DML acotado, pero no DDL.

### Precheck y postcheck

- **Precheck**: comprobaciones antes de cambiar nada.
- **Postcheck**: comprobaciones después del cambio.

Si el precheck falla, el cambio no debe empezar. Si el postcheck falla, se
aplica la reversión prevista.

### Reversión

Procedimiento para volver a un estado seguro conocido. En estas sesiones
incluyó retirar cuentas parciales, cerrar túneles, borrar CA temporales y
restaurar configuración cuando fue necesario.

## 9. Qué existe ahora y qué no

### Existe y está validado

- administrador funcional de Qontrolmed con contraseña establecida;
- 4 roles, 40 permisos y 75 asignaciones canónicas;
- cuenta runtime `qontrolmed_runtime_dev@localhost`;
- TLS e identidad verificados;
- ledger v1/v2 en estado `applied`;
- Gestión mínima, Preventivos y Quirófanos operativos en el smoke test;
- Compras y analítica ocultas en la navegación del piloto;
- MySQL activo al arranque y limitado a loopback.

### Todavía no se ha hecho

- abrir MySQL a la LAN;
- crear identidades runtime para los puestos reales;
- fijar DNS, IP y CA definitivos de la sede;
- construir o instalar una RC nueva;
- validar concurrencia de cuatro o cinco puestos;
- activar SFTPGo para usuarios reales;
- aprobar el libro de maestros definitivo;
- realizar la aceptación del piloto en la empresa.

## 10. Resumen en una frase

La primera sesión creó **quién puede administrar Qontrolmed**; la segunda creó
**con qué identidad limitada se conecta Qontrolmed a MySQL**; P2W demostró que
ambas capas funcionan juntas sin utilizar una cuenta administrativa ni exponer
Compras, secretos o MySQL en la LAN.

## 11. Documentos técnicos relacionados

- `docs/02_planes_y_arquitectura/PLAN-P2Q-BOOTSTRAP-FUNCIONAL-INICIAL-2026-11-17.md`
- `docs/02_planes_y_arquitectura/PLAN-P2R-BOOTSTRAP-DESDE-DESARROLLO-2026-11-17.md`
- `docs/02_planes_y_arquitectura/PLAN-P2T-CANONIZACION-RESULTADO-LEDGER-QUIROFANOS-2026-11-17.md`
- `docs/02_planes_y_arquitectura/PLAN-P2U-CUENTA-RUNTIME-MINIMO-PRIVILEGIO-2026-11-18.md`
- `docs/02_planes_y_arquitectura/PLAN-P2V-CERTIFICADO-MYSQL-CON-SAN-2026-11-18.md`
- `docs/02_planes_y_arquitectura/PLAN-P2W-SMOKE-FUNCIONAL-RUNTIME-DESARROLLO-2026-11-18.md`
- `docs/04_guias_didacticas/GUIA-WORKBENCH-TUNEL-SSH-SRV-MM-01.md`
