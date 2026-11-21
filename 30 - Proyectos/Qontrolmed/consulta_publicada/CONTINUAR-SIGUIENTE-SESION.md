---
title: "Continuar siguiente sesión de Qontrolmed"
type: state
status: active
created: 2026-11-10
updated: 2026-11-21
tags: [qontrolmed, continuidad, produccion]
review_after: 2026-11-17
---

# Continuar siguiente sesión

## Entrada coordinada

Esta sesión puede iniciarse desde esta carpeta o desde `H:\02.Trabajo\obsidian\30 - Proyectos\Servidor_MM\Servidor`. En ambos casos se deben leer los `AGENTS.md` y relevos de `Qontrolmed` y `Servidor_MM` antes de ejecutar trabajo transversal. La aplicación y la infraestructura conservan fuentes de verdad y autorizaciones separadas; véase `AGENTS.md`.

## Punto seguro

- Fase `portátil` cerrada el 21/11/2026. El kit completo y sus 11 archivos se
  verificaron por tamaño y SHA-256 tanto en el disco local como en el USB. La
  RC se instaló y retiró en un ensayo sintético sin conexión al servidor; el
  proceso x64 inició y respondió sobre Windows ARM64. El portátil queda como
  herramienta de administración/transporte y puesto de prueba. Corresponde
  preparar y aprobar el plan de la fase `sede` antes de efectuar cambios.
- El inventario pendiente para sede incluye Defender, Firewall y cifrado del
  portátil, red real, acceso físico/LUKS, identidad SSH, DNS/Cloudflare,
  Cloudflared, CA, cuenta runtime, copias y aceptación. Ninguno de esos cambios
  está autorizado por el cierre de la fase portátil.
- Servidor_MM cerró su bloque SFTPGo. En Qontrolmed, la RC candidata local
  `0.1.0-rc.1` está construida y validada desde
  `c79bcec8099724cadfc37fae6aa14f50a28c4d11`.
- Pasaron 102 pruebas, Bandit, `pip-audit` y Gitleaks. El ZIP local, ignorado
  por Git, tiene SHA-256
  `4618C7258347106E0E62F920E9214E6940B11FA4057B10EDD3F9AB2B64D542DB`.
- El ensayo elevado aislado terminó con
  `VALIDACION_INSTALACION_LOCAL=OK`: instalación, CA sintética/ACL,
  verificación, `-WhatIf` y desinstalación real correctas, sin residuos.
- El EXE abrió la ventana `Gestion Documental`, respondió y se cerró de forma
  controlada usando `PROGRAMDATA` y configuración sintéticos.
- Tag anotado local: `v0.1.0-rc.1`. No se han publicado el tag, el ZIP ni los
  commits locales pendientes en el remoto.
- Kit preparado para trasladar al portátil:
  `dist_rc\KIT-PORTATIL-QONTROLMED-0.1.0-rc.1\`. Es una única carpeta con RC,
  hash, manifiesto e instrucciones/relevos mínimos para Codex; no requiere
  copiar completos `maxgesth` o `Servidor_MM`.

- Rama de trabajo: `codex/produccion-readiness`.
- Base P0: `907648df368312f985e7797eed5a43f78cdf8234`.
- La reorganización quedó cerrada en la rama
  `codex/estructura-documental-20261110` con ese mismo commit.
- P1 local ha modificado código de conexión, guarda de esquema, dependencias y
  scripts de instalación; no se ha modificado servidor, MySQL real ni `.env`.
- No se ha instalado la RC en ningún puesto real; solo se ensayó en rutas
  locales aisladas y posteriormente retiradas.
- `compartido/.env` permanece local, ignorado y sin inspeccionar.
- La revisión de 11 de noviembre no tocó código funcional, servidor ni datos.

## Bloque realizado

- Reorganización documental por función.
- Consolidación de los dos árboles históricos en `docs/90_archivo/`.
- Creación de `AGENTS.md`, `README.md` y este relevo.
- Actualización del plan de producción con las decisiones comunicadas el 10 de
  noviembre de 2026.
- Conservación del backlog evolutivo y de sus cambios locales previos.
- Limpieza física completa de aproximadamente 3,26 GiB de builds,
  distribuciones, runtime versionado, exports, certificados locales, binarios
  legados y caches.
- Aprobación del modelo solo-dev/B2B de retención, soporte y release, registrado
  en `docs/01_gobierno_y_decisiones/DECISION-CICLO-VIDA-SOPORTE-RELEASE-PILOTO-2026-11-10.md`.
- Revisión inicial del diff estructural: 1.966 cambios preparados, sin
  diferencias adicionales en el árbol y sin errores de `git diff --check`.
- Estado final tras añadir la trazabilidad didáctica: 1.970 ficheros cambiados,
  290 rutas resultantes y 0 rutas bajo los patrones de runtime/build revisados.
- Validación final de enlaces Markdown activos: 52 documentos examinados, 7 enlaces
  relativos comprobados y 0 destinos ausentes.
- Revalidación local: 24 pruebas superadas.
- Creación de una guía didáctica viva y una bitácora formativa de sesión.
- Commit estructural creado: `907648d`.
- Rama P0 creada desde el commit estructural.
- Línea base técnica local/remota, worktrees, CI, dependencias y seguridad
  registradas sin conectar al servidor.
- Reconciliación estática de la worktree TLS: separados TLS, recuperación de
  conexión e ID manual de marcas; no se ha copiado código.
- Propuestas P0 creadas para cuenta técnica MySQL, CA/TLS, inventario de puestos,
  riesgos, responsables y puertas.
- Hallazgo P0: existe un `ALTER TABLE` automático en runtime que debe retirarse;
  no se concederá DDL a la cuenta productiva.
- Inventario de objetos Git colgantes creado: 11 blobs documentales, 2 commits
  WIP y 334 árboles internos; no se ha podado ningún objeto.
- P1 local autorizado íntegramente por el propietario; no requiere permisos
  paso a paso dentro del plan registrado.
- Regla general aprobada: los planes de trabajo se ejecutan completos una vez
  definidos, manteniendo alcance, límites, validaciones y reversión.
- Decisión de alcance: piloto privado de evaluación en una única empresa, sin
  venta, difusión pública ni preparación comercial obligatoria.
- P1 local implementado en commits separados: TLS verificado, recuperación de
  conexión, retirada de DDL runtime, CI bloqueante y provisión de CA.
- Validación local P1: 44 pruebas correctas, Bandit sin hallazgos medios/altos y
  auditoría directa de dependencias sin avisos conocidos.
- Rama `codex/produccion-readiness` publicada; la lectura de CI remoto quedó
  pendiente porque la autenticación de `gh` está caducada.
- Validación remota P1 cerrada mediante GitHub web: CI #69 y Security Checks
  #58 correctos para `7c4a331`; `pip-audit`, Bandit y Gitleaks finalizaron
  correctamente como controles bloqueantes.
- Inventario estático P2 creado: 20 scripts base, 2 bootstrap y 11 migraciones;
  no existe ledger ni orden canónico y solo la migración de técnico de cierre
  declara precheck, postcheck y restauración de forma completa.
- Plan P2A propuesto para gobierno local de esquema, sin conexión ni DDL.
- Diagnóstico de `gh` cerrado: la credencial del llavero es válida y permite
  consultar el repositorio y Actions desde el contexto con acceso al llavero;
  el `401` solo aparece en el sandbox ordinario de Codex, que no puede leerla.
- CI y Security Checks del commit documental `19e5fdc` finalizaron
  correctamente en los runs `43079524608` y `43079524648`.
- P2A implementado localmente: manifiesto de migraciones de formato 1,
  validador sin ejecución SQL, utilidad CLI y primer caso piloto para
  `quirofanos_tecnico_cierre`.
- Validación P2A: 55 pruebas correctas y Bandit sin hallazgos medios/altos;
  `pip-audit` local quedó no concluyente por espera superior a 90 segundos sin
  salida. No se cambiaron dependencias.
- P2A publicado en `1a6966b` y `e62f23c`; CI `43081859463` y Security Checks
  `43081859180` correctos.
- Contrato lógico de ledger definido sin SQL ejecutable: runtime de solo
  lectura, fallo cerrado y estados `compatible`, `migration-required`,
  `inconsistent` y `unsupported-newer`.
- P2B implementado localmente sin servidor: SQL administrativo no ejecutado,
  comprobador puro de compatibilidad y 13 pruebas nuevas.
- Validación P2B: 68 pruebas correctas, compilación y manifiesto correctos y
  Bandit sin hallazgos medios/altos.
- Publicación documental unidireccional a Obsidian definida mediante una
  selección explícita, comparación SHA-256 e índice de procedencia. Qontrolmed
  permanece como única fuente oficial; el destino de consulta no se importa ni
  se limpia automáticamente.
- Revalidación coordinada de `srv-mm-01` completada el 13 de noviembre:
  `REVALIDACION_TRAS_INCIDENTE=OK`, IP reservada vigente `192.168.1.31`, línea
  base segura coincidente y apagado controlado. `.30` es únicamente el alias
  histórico de la clave de host SSH. El servidor permanece apagado hasta que
  un plan aprobado requiera volver a utilizarlo.

## Pendiente inmediato

### Siguiente fase física: portátil — plan preparado, no ejecutado

El propietario fijó una secuencia física obligatoria: terminar primero todo lo
ejecutable desde este equipo, después pasar al portátil y, una vez cerrado ese
bloque, trabajar en sede. Los planes documentarán únicamente la fase activa y
al cerrarla indicarán solo el cambio a la siguiente.

El plan transversal
`docs/02_planes_y_arquitectura/PLAN-CIERRE-FASE-EQUIPO-ACTUAL-2026-11-19.md`
está completado: SFTPGo quedó cerrado en Servidor_MM y la RC/paquete local en
Qontrolmed superaron sus puertas. Corresponde pasar a **portátil** cuando el
propietario decida iniciar esa sesión. El plan preparado limita la primera
acción al inventario real y a la verificación del kit; las decisiones variables
se completarán con lo observado. No iniciar sede.

### Punto de continuación P2P — 16/11/2026

La sesión P2P quedó pausada a petición del propietario después de completar la
fase 0. Se crearon y validaron `gestion`, `preventivos` y `quirofanos`; los tres
`piloto_mm_*` se conservan como reversión. La copia P2P verificó SHA-256, las
parejas tienen 13/10/7 tablas, MySQL quedó observado `active/disabled` en
`127.0.0.1:3306` y Workbench mostró visualmente los seis esquemas mediante
túnel SSH. `qontrolmed_admin@localhost` está limitado a esos seis esquemas.

La fase 1 solo está iniciada. No se han creado usuarios funcionales o
documentales reales, cuenta runtime ni reglas LAN. Se aclaró el bootstrap: hay
que sembrar roles/permisos e insertar el usuario inicial en
`gestion.usuarios`; Qontrolmed solicita después la primera contraseña mediante
el modo controlado, que debe volver a
`QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0` al finalizar.

Próxima acción exacta: revalidación de solo lectura e inventario depurado de
`gestion.roles`, `gestion.permisos`, `gestion.roles_permisos` y
`gestion.usuarios`; después preparar el plan de bootstrap. No abrir 3306 en
LAN, no conectar Qontrolmed y no activar SFTPGo antes de ese bloque. Fuente:
`docs/02_planes_y_arquitectura/PLAN-P2P-ESQUEMAS-DEFINITIVOS-IDENTIDADES-Y-ACCESOS-2026-11-16.md`.

La decisión de especificaciones operativas del 16/11 fija un máximo previsto
de cuatro o cinco puestos concurrentes, LAN de sede `192.168.0.0/24` con
reservas DHCP, separación entre administrador funcional, cuenta técnica de la
aplicación y administrador técnico, y exclusión de datos clínicos sin negar los
datos personales mínimos de usuarios y técnicos. La configuración concreta de
red, cuentas y acceso remoto continúa pendiente de validación y plan de sede.
Fuente:
`docs/01_gobierno_y_decisiones/DECISION-ESPECIFICACIONES-OPERATIVAS-PILOTO-2026-11-16.md`.

Actualización del 17/11: el propietario habilitó el arranque automático de
MySQL y la verificación posterior confirmó `active/enabled`, sin unidades
fallidas y escucha exclusiva en `127.0.0.1:3306`. No se abrió la LAN ni se
alteraron esquemas o datos. Reversión: `sudo systemctl disable mysql`. El
inventario depurado quedó cerrado tras recuperar Workbench: 0 roles, 0
permisos, 0 relaciones y 0 usuarios; los controles de huérfanos y referencias
inválidas devolvieron 0. No hubo escrituras ni exposición de datos sensibles.
El siguiente bloque es revisar y autorizar P2Q para aplicar las semillas
4/40/75 y crear el administrador inicial mediante el flujo controlado.

P2Q fue autorizado y su fase SQL quedó verificada: 4 roles, 40 permisos, 75
asignaciones, 0 huérfanos y un único superusuario activo sin `password_hash`.
La copia previa P2Q se conserva y la carpeta temporal fue retirada. MySQL sigue
`active/enabled` y solo en loopback. La primera contraseña no se asignó y el
modo sin contraseña no se activó, porque todavía no existe la cuenta técnica
runtime; no se reutilizará `qontrolmed_admin` en la aplicación. La próxima
decisión es autorizar un bloque de cuenta runtime mínima y conexión controlada.

El propietario autorizó ese bloque, pero el precheck detectó que la instalación
disponible corresponde al 15/07/2026, anterior al bootstrap seguro, TLS
endurecido y guard de esquema actuales, y no contiene aún la CA pública. No se
creó la cuenta runtime, no se inspeccionó ni modificó el `.env` y la RC antigua
no se conectó. La próxima decisión debe cubrir una build actual controlada o un
arnés temporal validado; no hay autorización implícita para construir o
instalar una RC.

### Cierre P2R/P2T — 17/11/2026

P2S quedó completado: copia verificada en
`/var/backups/qontrolmed/p2s-20261117T083320Z`,
`quirofanos.equipos_medida.ruta_certificado` reconciliada a `VARCHAR(500)` y
ledger canónico con versiones 1 y 2. MySQL continuó `active/enabled`, sin
unidades fallidas y limitado a `127.0.0.1:3306`.

P2R completó el bootstrap funcional mediante el código actual. La cuenta
temporal pasó `SELECT 1` por socket y túnel, Qontrolmed conectó con TLS e
identidad verificados y el propietario asignó la primera contraseña del
administrador mediante la UI. El cierre confirmó 4 roles, 40 permisos, 75
asignaciones, cero huérfanos, un superusuario activo con hash presente y ledger
v1/v2 `applied`.

P2T resolvió previamente la contradicción descubierta entre P2S, que había
registrado las dos versiones como `recovered`, y el guard de runtime, que las
rechaza por diseño. Se creó y verificó copia previa y se actualizaron solo las
dos filas canónicas a `applied` después de validar estructura, identificadores
y hashes.

El cierre retiró la cuenta `qontrolmed_bootstrap`, los scripts remotos, el
túnel 13306 y la CA pública temporal. MySQL quedó `active/enabled`, sin unidades
fallidas y solo en `127.0.0.1:3306`. Un fallo del lanzador eliminó el `.env`
local durante los intentos; se reconstruyó con entrada local del propietario,
loopback, modo sin contraseña desactivado y sin exponer valores. Pasaron 23
pruebas de TLS, guard y bootstrap.

Siguiente bloque recomendado: diseñar y autorizar la cuenta runtime definitiva
de mínimo privilegio y su conexión controlada. No abrir 3306 en LAN, no
reutilizar cuentas administrativas y no construir ni instalar una RC sin un
plan específico. Fuentes:
`docs/02_planes_y_arquitectura/PLAN-P2R-BOOTSTRAP-DESDE-DESARROLLO-2026-11-17.md`
y `docs/02_planes_y_arquitectura/PLAN-P2T-CANONIZACION-RESULTADO-LEDGER-QUIROFANOS-2026-11-17.md`.

### Propuesta P2U — 18/11/2026

Se preparó, sin conexión ni cambios en el servidor, el plan transversal P2U
para crear y validar una identidad runtime MySQL por puesto, limitada por
origen, con TLS y privilegios por tabla. Incluye pruebas positivas, denegación
de DDL/administración/Compras, retirada de datos sintéticos y reversión por
eliminación de la identidad exacta. El plan permanece **propuesto y no
autorizado**; no se ha creado ninguna cuenta ni se ha modificado `.env`.

Próxima decisión exacta: revisar y autorizar el bloque completo P2U antes de
conectar a `srv-mm-01`. Fuente:
`docs/02_planes_y_arquitectura/PLAN-P2U-CUENTA-RUNTIME-MINIMO-PRIVILEGIO-2026-11-18.md`.

P2U fue autorizado y ejecutado después. El precheck, las copias SHA-256 y los
privilegios mínimos fueron correctos, pero la conexión fuerte descubrió que el
certificado MySQL actual carece de SAN. La cadena y vigencia son correctas,
pero no puede verificarse la identidad `127.0.0.1`; no se debilitó
`ssl_verify_identity`. La cuenta runtime fue retirada y los temporales se
eliminaron. MySQL terminó `active/enabled`, sin unidades fallidas y solo en
loopback.

Próxima decisión exacta: revisar y autorizar P2V para emitir e instalar, con
copia y reversión, un certificado MySQL con `IP:127.0.0.1` y
`DNS:srv-mm-01`. P2V no abre la LAN ni decide todavía la identidad de sede.
Fuente:
`docs/02_planes_y_arquitectura/PLAN-P2V-CERTIFICADO-MYSQL-CON-SAN-2026-11-18.md`.

P2V se autorizó, pero quedó cancelado sin cambios: el precheck demostró que
MySQL usa `/var/lib/mysql/piloto-tls/` y que su certificado activo ya incluye
SAN para `srv-mm-01`, `127.0.0.1` y `192.168.1.31`. El diagnóstico inicial de
P2U había inspeccionado y copiado la CA automática inactiva.

P2U se reanudó desde una cuenta nueva y terminó correctamente. La CA activa se
resolvió desde `@@ssl_ca`; pasaron TLS con identidad, lectura de los tres
esquemas, denegaciones de Compras/ledger/DDL y rechazo sin TLS. La cuenta
`qontrolmed_runtime_dev@localhost` queda activa con mínimo privilegio y
`REQUIRE SSL`. Se retiraron CA, secreto de proceso, túnel y temporales. MySQL
quedó `active/enabled`, cero unidades fallidas y solo en
`127.0.0.1:3306`.

Siguiente bloque recomendado: validar un smoke test funcional controlado con
el código actual y esta cuenta, sin reutilizar la RC histórica ni instalar una
RC nueva; después decidir la provisión por puesto y la conectividad de sede.

P2W quedó completado el 18/11. La configuración efímera reveló y corrigió que
`.env` sobrescribía variables explícitas del proceso; ahora el entorno tiene
prioridad y existe prueba de regresión. El smoke validó TLS, guard, login y
apertura/cierre de Gestión mínima, Preventivos y Quirófanos. También detectó y
corrigió que el superusuario exponía Compras: quedan ocultas Compras,
Estadísticas, proveedores, repuestos, marcas, tipos de trabajo e importaciones
históricas, sin borrar su código.

El cierre confirmó 95 pruebas correctas, `.env` intacto, limpieza de secreto,
CA, túnel y temporales, y MySQL `active/enabled`, sin unidades fallidas y solo
en loopback. No hubo escrituras funcionales, RC, instalación ni apertura LAN.
Fuente:
`docs/02_planes_y_arquitectura/PLAN-P2W-SMOKE-FUNCIONAL-RUNTIME-DESARROLLO-2026-11-18.md`.

Siguiente decisión recomendada: revisar el diff P2U/P2W y separar commits
documentales, arneses y código; después diseñar la provisión de identidad por
puesto y la conectividad de sede, sin abrir todavía MySQL a la LAN.

La explicación formativa de las dos últimas sesiones quedó consolidada en
`docs/04_guias_didacticas/GUIA-DIDACTICA-ADMINISTRADOR-FUNCIONAL-Y-CUENTA-RUNTIME-MYSQL-2026-11-18.md`.
La guía separa administrador funcional, cuentas MySQL administrativa,
temporal y runtime; explica los reintentos y resume el estado final sin
secretos.

### Cierre de la fase A de P2X — 19/11/2026

El trabajo P2P–P2W quedó separado en tres commits y publicado hasta `11faaa8`.
CI `44303019641` y Security Checks `44303019607` finalizaron correctamente. El
árbol quedó limpio al preparar este relevo.

El propietario autorizó la fase A local de P2X y aclaró que los datos ausentes
del cliente no deben bloquear la preparación: el propietario puede proponer
parte del direccionamiento y los detalles pendientes pueden completarse al
aproximarse la fase operativa o, cuando sea seguro, mediante una intervención
remota posterior.

La fase A quedó completada sin conexión al servidor. Se definieron el contrato
de identidad separada por puesto, el ciclo de alta/baja/rotación, cuatro
plantillas administrativas no ejecutables, la provisión segura de `.env`/CA y
ACL, la matriz de aceptación/denegación y el inventario de sede. Las IP
propuestas no serán definitivas hasta comprobar router, DHCP y conflictos.
Pasaron 100 pruebas, incluidas 5 nuevas de P2X.

La fase B sigue no autorizada. Próxima acción exacta: cuando se aproxime la
instalación, rellenar al menos el primer puesto y preparar una propuesta de
direccionamiento; después redactar el plan transversal de fase B separando lo
remoto viable de la ventana de sede. No abrir MySQL a la LAN, modificar UFW,
crear identidades reales, emitir certificados ni instalar una RC antes de ese
plan. Fuente:
`docs/02_planes_y_arquitectura/PLAN-P2X-PROVISION-PUESTOS-Y-CONEXION-SEDE-2026-11-18.md`.

1. Revisar con el propietario el libro Excel ya generado con los cuatro
   maestros de Preventivos y `quirofanos.puntos_control`. La siguiente decisión
   funcional es clasificar cada registro como conservar, modificar o excluir;
   todavía no se ha preparado ni ejecutado ninguna carga sobre la base
   definitiva.
2. Mantener como pendientes de sede el inventario real de puestos, DNS/CA y
   destino de copia independiente; no bloquean el desarrollo local.
3. Ejecutar futuras consultas autenticadas de `gh` desde el contexto autorizado
   con acceso al llavero; no repetir el login mientras la comprobación elevada
   siga siendo correcta.
4. Resolver la revisión de objetos Git como `conservar`, `recuperar` o
   `descartar`; cualquier poda requerirá un bloque posterior independiente.
5. No integrar el cambio histórico de marcas ni construir una RC hasta superar
   las puertas P2 y posteriores.

P2B ya está publicado en `aeb0c2e`: CI `43083258291` y Security Checks
`43083258293` finalizaron correctamente.

P2C quedó completado el 13/11 contra MySQL 8.4.11 sintético. Se validaron TLS
con identidad, estructura, restricciones, mínimo privilegio y los cuatro
estados del comprobador. El servidor volvió a su línea base segura y no se
construyó ninguna RC.

P2C está publicado en `674dbcd`: CI `43408673786` y Security Checks
`43408673712` finalizaron correctamente.

P2D está implementado localmente: guard de ledger de solo lectura anterior al
login, cierre seguro de conexiones, recursos de build y 76 pruebas correctas.
Está publicado en `51ddb90`: CI `43409940569` y Security Checks `43409940328`
finalizaron correctamente.

P2E quedó completado localmente el 13/11: las diez migraciones restantes se
clasificaron por necesidad, dependencias, riesgo y recuperación sin ejecutar
SQL ni modificar el manifiesto. La siguiente candidata individual es
`migracion_certificados_equipos_medida.sql`; las cadenas de roles, Preventivos
y puntos automáticos permanecen separadas y los puentes legados no se
promoverán por defecto.

P2E está publicado en `b7f4086`: CI `43463086022` y Security Checks
`43463086644` finalizaron correctamente.

P2F quedó implementado localmente: certificados se promovió como
`quirofanos-0002-certificados-equipos-medida`, el SQL se endureció con
pre/postchecks y recuperación, el build incluye el recurso y el guard bloquea
un ledger detenido en v1. Validación local: 81 pruebas, manifiesto y Bandit
correctos. No se ejecutó MySQL; la integración sintética corresponde a P2G.

P2F está publicado en `fe99684`: CI `43464360995` y Security Checks
`43464360775` finalizaron correctamente.

P2G completó la integración de `quirofanos-0002` contra MySQL 8.4.11
sintético: estructura y datos preservados, reejecución rechazada, v1
`migration-required`, v1+v2 `compatible` y cuenta lectora sin escritura. La
limpieza devolvió MySQL a `inactive/disabled`, sin puertos ni TLS temporal; el
servidor permaneció encendido.

P2G está publicado en `8c6b0e7`: CI `43469627567` y Security Checks
`43469627563` finalizaron correctamente.

El propietario decidió que la implantación parte de bases nuevas y que los
datos locales anteriores son pruebas sin valor de migración. P2H inventarió el
contrato greenfield de Preventivos: diez tablas propias, dependencias con
Gestión/Quirófanos y JSON offline de ida y vuelta. La reconciliación histórica
queda diferida; el siguiente bloque es crear SQL base de Preventivos.

P2H está publicado en `73beaa2`: CI `43472291142` y Security Checks
`43472291363` finalizaron correctamente.

P2I dejó implementada la estructura base vacía de Preventivos: diez
tablas ordenadas, relaciones internas, referencias lógicas entre esquemas y
cinco pruebas específicas. La validación local cerró con 88 pruebas,
manifiesto y Bandit correctos. Está publicado en `689ae06`: CI `43473769165`
y Security Checks `43473769241` finalizaron correctamente. No se conectó a
MySQL ni se modificaron los repositorios móviles; la integración sintética
corresponde a P2J.

P2J validó la base greenfield contra MySQL 8.4.11 sintético: doble ejecución,
10 tablas, 12 claves foráneas, ciclo funcional mínimo y rechazos negativos
correctos. Esquema, TLS y carpeta temporal se retiraron; MySQL quedó
`inactive/disabled` y sin puertos. Validación local: 90 pruebas y Bandit
correcto. Publicado en `a969c39`: CI `43476382817` y Security Checks
`43476383169` finalizaron correctamente.

P2K quedó completado localmente desde `33bbf84`: define el bootstrap mínimo de
Preventivos como estructura P2I inicialmente vacía. La interpretación de que
los maestros debían descartarse fue corregida el 15/11: se conservan las cuatro
tablas maestras locales y solo las seis tablas operativas empiezan vacías.

P2L quedó completado el 15/11. Se creó en MySQL local una cuenta exclusiva de
inventario con `SELECT` sobre `preventivos.*`; su contraseña fue introducida
por el propietario y no se registró. El inventario confirmó 8 tipos, 7
plantillas, 390 puntos y 160 relaciones, con cero incidencias en cinco controles
agregados. Las seis tablas operativas contienen histórico y quedan excluidas.
Para Quirófanos, el propietario decidió conservar únicamente el maestro
`puntos_control`; P2M confirmó 136 filas, todas activas y sin anomalías en los
controles agregados. Cualquier exportación debe excluir el resto del esquema.

P2N quedó completado el 15/11 y revalidado en la sesión de entrega. El libro
`outputs/01a1debb-87f9-7e60-8b3a-211f0cc67495/Qontrolmed_maestros_revision_2026-11-15.xlsx`
contiene una hoja de resumen y cinco hojas revisables: 8 tipos de equipo, 7
plantillas, 390 puntos preventivos, 160 relaciones plantilla-punto y 136 puntos
de quirófanos. Los campos extraídos se mantienen separados de las columnas
`Decisión revisión` y `Observaciones de revisión`; no se incluyen tablas
operativas ni históricas. El libro fue reimportado y revisado visualmente en
sus seis hojas. Tras la validación se eliminaron los CSV, previsualizaciones,
scripts y dependencias temporales; solo permanece el XLSX de entrega. SHA-256:
`B09685B4ECB0B43C418B1A71FBACFD86E7AEC59BCF3D654F0066E3AC5F7B7009`.

P2O quedó completado el 15/11 sobre `srv-mm-01`. Tras copia previa verificada se
recrearon los tres esquemas `piloto_mm_*` de ensayo y se cargaron los maestros
aprobados: 7 tipos, 6 plantillas, 390 puntos preventivos, 146 relaciones y 136
puntos de quirófanos. Los controles de huérfanos y tablas operativas dieron
cero. Workbench accede mediante túnel SSH local, sin abrir 3306 en LAN, con
`qontrolmed_admin@localhost` limitado a los tres esquemas. MySQL permanece
`active/disabled`; el SQL temporal fue retirado y la copia previa se conserva.

## Límites actuales

- Qontrolmed sigue en estado **NO-GO para producción o distribución
  comercial**; el objetivo es un piloto privado controlado.
- No usar datos reales ni abrir MySQL del servidor hasta revalidar estado,
  TLS/CA, cuentas, firewall, puestos y copias.
- No construir una nueva RC antes de cerrar P0 y P1.
- No editar `consulta_publicada` como fuente ni recuperar cambios desde
  Obsidian. Al final de cada sesión relevante, revisar el manifiesto y ejecutar
  `python scripts/documentacion/publicar_obsidian.py --comprobar`; publicar
  solo si aparecen cambios seleccionados.

## Lectura mínima

1. `AGENTS.md`.
2. `README.md`.
3. `docs/04_guias_didacticas/GUIA-DIDACTICA-DE-SESIONES-Y-COMANDOS.md`.
4. `docs/00_seguimiento/estados/ESTADO-REORGANIZACION-DOCUMENTAL-2026-11-10.md`.
5. `docs/00_seguimiento/diario/2026-11-11-revision-estructural-y-trazabilidad-didactica.md`.
6. `docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md`.
7. `docs/02_planes_y_arquitectura/PLAN-EJECUCION-P0-PRODUCCION-READINESS-2026-11-11.md`.
8. `docs/05_evidencias/auditorias/LINEA-BASE-TECNICA-P0-2026-11-11.md`.
9. `docs/05_evidencias/auditorias/INVENTARIO-REVISION-OBJETOS-GIT-COLGANTES-2026-11-11.md`.
10. `docs/01_gobierno_y_decisiones/DECISION-AUTORIZACION-INTEGRAL-PLANES-Y-P1-LOCAL-2026-11-11.md`.
11. `docs/02_planes_y_arquitectura/PLAN-EJECUCION-P1-LOCAL-2026-11-11.md`.
12. `docs/01_gobierno_y_decisiones/DECISION-PILOTO-PRIVADO-EVALUACION-2026-11-11.md`.

## Revalidación no destructiva

```powershell
git status --short
git diff --stat
python -m unittest discover -s tests -v
```
