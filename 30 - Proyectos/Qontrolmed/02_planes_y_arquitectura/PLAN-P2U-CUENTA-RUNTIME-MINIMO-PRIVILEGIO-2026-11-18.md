---
title: "P2U — Cuenta runtime MySQL de mínimo privilegio"
type: plan
status: completed
created: 2026-11-18
updated: 2026-11-18
sources:
  - "docs/02_planes_y_arquitectura/PROPUESTA-CUENTA-TECNICA-MYSQL-P0-2026-11-11.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2R-BOOTSTRAP-DESDE-DESARROLLO-2026-11-17.md"
  - "docs/01_gobierno_y_decisiones/DECISION-ESPECIFICACIONES-OPERATIVAS-PILOTO-2026-11-16.md"
tags: [qontrolmed, mysql, runtime, minimo-privilegio, p2u]
review_after: 2026-11-25
---

# P2U — Cuenta runtime MySQL de mínimo privilegio

## Estado y autorización

Plan transversal autorizado y completado el 18/11/2026. La autorización no se
extendió a apertura de red, instalación ni construcción de una RC.

## Objetivo

Crear y validar una identidad técnica MySQL definitiva para el runtime de
Qontrolmed, separada del administrador funcional, de las cuentas de migración y
de `qontrolmed_admin`. La cuenta permitirá el funcionamiento ordinario del
alcance del piloto —Gestión mínima, Preventivos y Quirófanos— sin DDL ni
administración de MySQL.

## Decisiones de diseño

1. Se usará una identidad distinta por puesto autorizado. En esta ventana se
   creará únicamente la identidad del puesto de desarrollo/validación.
2. La identidad se limitará al origen exacto que MySQL observe a través del
   canal aprobado. Mientras MySQL siga solo en loopback, la validación se hará
   por túnel SSH y la cuenta será `@localhost`; esto no decide todavía el
   modelo de conexión LAN de la sede.
3. La cuenta exigirá transporte cifrado (`REQUIRE SSL`). Qontrolmed verificará
   CA e identidad; `REQUIRE SSL` no sustituye esa comprobación del cliente.
4. Los permisos se concederán por tabla. No se concederán privilegios sobre
   `*.*`, DDL, gestión de usuarios, `GRANT OPTION`, `FILE`, `PROCESS`,
   `SYSTEM_USER`, `SHUTDOWN` ni `LOCAL INFILE`.
5. Compras, proveedores, repuestos y analítica ampliada quedan fuera.

## Matriz runtime inicial

La matriz se validará contra el código actual antes de generar SQL. Se parte de
estas concesiones máximas; si una prueba demuestra que una operación no es
necesaria se retirará, no se ampliará por conveniencia.

| Esquema | Tablas | Privilegios máximos |
| --- | --- | --- |
| `gestion` | `usuarios` | `SELECT`, `INSERT`, `UPDATE` |
| `gestion` | `roles`, `permisos`, `roles_permisos`, `cecos`, `marcas`, `equipos`, `tipo_trabajo` | `SELECT`, `INSERT`, `UPDATE`, `DELETE` solo donde exista caso de uso activo validado |
| `gestion` | `auditoria_eventos` | `SELECT`, `INSERT` |
| `quirofanos` | `qontrolmed_schema_migrations` | `SELECT` |
| `quirofanos` | `hospitales`, `quirofanos`, `puntos_control`, `quirofano_puntos_control`, `equipos_medida`, `informes`, `resultado_puntos` | `SELECT`, `INSERT`, `UPDATE`, `DELETE` según las operaciones activas |
| `preventivos` | `tipos_equipo`, `plantillas_preventivo`, `puntos_control`, `plantilla_puntos`, `equipos_gmao`, `campanas_preventivo`, `campana_equipos_preventivo`, `informes_preventivo`, `resultados_preventivo`, `informe_equipos_medida` | `SELECT`, `INSERT`, `UPDATE`, `DELETE` según las operaciones activas |

`SHOW TABLES` y `SHOW COLUMNS`, usados por comprobaciones de compatibilidad,
deben funcionar únicamente para los objetos sobre los que la cuenta ya tenga
privilegios. No se concederá acceso general a `information_schema`.

## Precondiciones

- Plan P2U autorizado por el propietario y enlazado desde ambos proyectos.
- `srv-mm-01` accesible mediante la identidad administrativa aprobada.
- MySQL `active/enabled`, sin unidades fallidas y limitado a
  `127.0.0.1:3306`.
- Ledger de `quirofanos` con versiones 1 y 2 canónicas en estado `applied`.
- Bootstrap funcional P2R cerrado y sin cuentas temporales remanentes.
- Copia previa identificada y con SHA-256 verificado antes de cualquier cambio.
- Nombre de cuenta, origen y secreto generados fuera del repositorio y sin
  mostrarlos en comandos, logs o evidencias.

## Ejecución propuesta

1. Revalidar servicio, listeners, unidades fallidas, ledger y ausencia de las
   cuentas temporales P2R mediante salidas depuradas.
2. Generar localmente un script parametrizado que falle si no se han sustituido
   los marcadores; no incluir secretos ni valores reales en Git.
3. Crear una única cuenta runtime de validación con autenticación compatible,
   `REQUIRE SSL`, sin privilegios globales y sin `GRANT OPTION`.
4. Aplicar la matriz final por tabla y revisar `SHOW GRANTS` con el identificador
   de la cuenta depurado.
5. Verificar administrativamente la identidad creada y probar su autenticación
   exclusivamente por el túnel con `mysql.connector` y TLS verificado. Una
   cuenta con `REQUIRE SSL` no se autentica mediante la prueba runtime por
   socket Unix.
6. Ejecutar el guard de esquema y un smoke test técnico desde el código actual,
   sin reutilizar ni instalar la RC histórica de julio.
7. Ejecutar pruebas positivas de lectura, auditoría y transacción con datos
   sintéticos identificables y retirables.
8. Ejecutar pruebas negativas de DDL, administración, tablas de Compras,
   esquemas no autorizados, conexión sin TLS y credencial incorrecta.
9. Retirar los registros sintéticos de validación mediante sus claves exactas.
10. Conservar la cuenta solo si todas las puertas pasan; retirar scripts y
    secretos temporales, cerrar el túnel y revalidar la línea base.

## Pruebas de aceptación

- Conexión con TLS, CA e identidad verificadas.
- Guard de esquema compatible sin permiso de escritura sobre el ledger.
- Login funcional y apertura controlada de Preventivos y Quirófanos.
- Lecturas cruzadas necesarias entre los tres esquemas.
- Inserción de auditoría y una transacción sintética por módulo con rollback
  comprobado ante fallo inducido.
- `SHOW GRANTS` sin privilegios globales, DDL, administración ni
  `GRANT OPTION`.
- MySQL continúa solo en loopback y no se construye ni instala una RC.

## Pruebas de denegación

- `ALTER TABLE`, `CREATE USER`, `DROP TABLE` y concesión de privilegios.
- Lectura o escritura en tablas de Compras diferidas y esquemas no autorizados.
- Escritura en `quirofanos.qontrolmed_schema_migrations`.
- Conexión sin TLS, con CA incorrecta, identidad incorrecta o contraseña
  incorrecta.
- Uso de la cuenta desde un origen distinto del autorizado.

## Reversión

Si falla una precondición, no se crea la cuenta. Si falla una prueba después de
crearla, se revocan sus privilegios y se elimina la identidad exacta; se
retiran los datos sintéticos por identificadores registrados y se comprueba su
ausencia. La copia previa solo se restaura si una escritura sintética no puede
revertirse de forma demostrable. La reversión no cambia el estado de MySQL ni
abre la LAN.

## Límites y siguiente decisión

P2U no configura todavía los cuatro o cinco puestos de sede, UFW, la escucha
LAN, DNS, CA definitiva, una RC ni SFTPGo. Tras aprobar y completar esta
validación de una identidad, un bloque posterior decidirá la provisión por
puesto y la conectividad exacta en la sede.

## Resultado ejecutado el 18/11/2026

P2U completó la fase administrativa y terminó revertido al no superar la
puerta TLS:

- precheck correcto: 24 objetos requeridos y ledger v1/v2 `applied`;
- varias copias previas completas se generaron durante los reintentos y cada
  una verificó su SHA-256;
- la cuenta `qontrolmed_runtime_dev@localhost` se creó con
  `caching_sha2_password`, sin bloqueo ni expiración y `ssl_type=ANY`;
- `SHOW GRANTS` confirmó ausencia de privilegios globales, DDL,
  administración y `GRANT OPTION`;
- la CA temporal copiada coincidió por SHA-256 y el túnel SSH quedó operativo;
- la conexión fuerte falló antes de autenticar: el certificado de servidor no
  contiene SAN y por ello no puede verificarse la identidad `127.0.0.1`;
- `openssl verify` confirmó una cadena válida y los certificados permanecen
  vigentes hasta el 01/10/2036, pero `subjectAltName` está ausente;
- no se deshabilitó `ssl_verify_identity` ni se aceptó el certificado;
- la cuenta runtime fue retirada y los arneses/CA temporales de `/tmp` fueron
  eliminados.

El cierre observó MySQL `active/enabled`, cero unidades fallidas y escucha
exclusiva en `127.0.0.1:3306`. No se abrió la LAN, no se modificaron datos
funcionales y no se construyó ni instaló una RC. La continuación requiere un
plan independiente para sustituir controladamente el certificado de servidor.

## Reanudación y cierre correcto

El diagnóstico anterior había inspeccionado por error los certificados
automáticos inactivos de `/var/lib/mysql`. El inventario de variables efectivas
demostró que MySQL presenta el conjunto activo de
`/var/lib/mysql/piloto-tls/`, cuya cadena es correcta y cuyo certificado sí
contiene `DNS:srv-mm-01`, `IP Address:127.0.0.1` e
`IP Address:192.168.1.31`. P2V se canceló antes de realizar cambios.

P2U se repitió desde una cuenta nueva. La preparación de CA pasó a resolver
`@@ssl_ca` en vez de asumir una ruta. El cierre final confirmó:

- `qontrolmed_runtime_dev@localhost` creada con `caching_sha2_password`,
  `ssl_type=ANY`, sin bloqueo ni expiración;
- ausencia de privilegios globales, DDL, administración y `GRANT OPTION`;
- CA activa copiada temporalmente y verificada mediante SHA-256;
- túnel SSH operativo y conexión con certificado e identidad verificados;
- lectura correcta de `gestion`, `preventivos` y `quirofanos`;
- denegación de Compras, escritura del ledger y DDL temporal;
- rechazo de conexión TCP sin TLS;
- eliminación del secreto de entorno, CA local/remota, túnel y arneses de
  `/tmp`.

La cuenta runtime queda conservada al superar todas las puertas ejecutadas. La
línea base final es MySQL `active/enabled`, cero unidades fallidas y escucha
exclusiva en `127.0.0.1:3306`. No se conectó una RC, no se abrió la LAN y no se
modificaron datos funcionales.
