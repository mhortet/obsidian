# Estado de continuidad
[[masgesth]]
Fecha: 2026-07-16

Este documento es la entrada viva de reanudacion del proyecto. Debe permitir
arrancar una sesion con criterio suficiente y poco ruido. El detalle historico,
las validaciones manuales y las cronologias de prueba deben vivir en
`docs/diario_sesiones/` o en documentos tematicos.

## Lectura minima de sesion

Leer en este orden:

1. `docs/security_delivery_playbook.md`
2. `docs/estado_continuidad.md`
3. `docs/plan_seguridad_consistencia.md`

Leer `docs/mapa_documental_proyecto.md` solo si la sesion toca documentacion,
clasificacion de fuentes o limpieza de material historico.

Despues revisar estado Git en:

- `D:/trabajo/Proyectos/maxgesth`
- `D:/trabajo/Proyectos/maxgesth_port`
- `D:/trabajo/Proyectos/maxgestq_mov`

Y registrar la sesion, si procede, en:

- `D:\trabajo\Proyectos\diario_qontrolmed\sesion_YYYY-MM-DD_HH-mm.md`

## Foto ejecutiva a 2026-07-17

- El objetivo operativo de septiembre es una implantacion piloto controlada en
  una unica empresa para validar el funcionamiento real. No es un despliegue
  masivo.
- `maxgesth` / `Qontrolmed` sigue siendo el hub de producto, datos, seguridad,
  documentacion viva y preparacion de despliegue.
- `maxgesth_port` queda aceptado como modulo de campo de Preventivos; Paquete A
  y Paquete B quedan cerrados para el corte de campo salvo regresion.
- `maxgestq_mov` queda en standby operativo: mantener compatibilidad de
  contrato y corregir solo incidencias reales de campo o de import/export.
- La linea de Compras operativa y el modulo de Informes/Analitica pasan a
  version posterior. En la version inicial solo se conserva lo imprescindible
  de `Gestion` para usuarios, roles, centros, maestros y soporte operativo.
- Los binarios `wkhtmltopdf` de `src/Compras/bin` pertenecen a ese modulo
  aparcado: se conservan para una futura evolucion completa, pero no se
  ejecutan ni se empaquetan en la RC del piloto.
- La exportacion movil -> sobremesa por lotes queda aplazada para una revision
  posterior y fuera del corte inicial de septiembre.
- El foco principal hasta septiembre es readiness: configuracion, acceso,
  auditoria, maestros, migraciones, consistencia de datos, backup/restauracion y
  empaquetado de entrega.
- La RC `2026.07.16-rc5` se ha instalado sin incidencias en entorno controlado.
  El configurador administrativo ha permitido crear el `.env` y los informes
  PDF se han generado en las rutas previstas bajo `ProgramData`.
- La incidencia operativa observada en RC4 al actualizar el `.env` no se ha
  reproducido en RC5. La regresion con usuario Windows normal confirma
  ejecucion de la aplicacion y denegacion de modificacion sobre la configuracion.
- Todos los PDF presentes actualmente son salidas de prueba funcional del
  desarrollo. No contienen historico operativo valido, no deben migrarse y
  deben retirarse antes de preparar los datos reales del piloto.
- El bloque previsto antes de vacaciones queda cerrado el 2026-07-17, siete
  dias antes de la fecha objetivo. El contacto con la empresa piloto no se
  preve antes de la segunda quincena de agosto.
- Hasta esa toma de contacto, las mejoras futuras de aplicacion y web deben
  mantenerse separadas de la referencia RC5 validada para el piloto.

## Naming vigente

- Nombre comercial del escritorio: `Qontrolmed`.
- Nombres tecnicos de repositorio: `maxgesth`, `maxgesth_port`,
  `maxgestq_mov`.
- `Gestion` es el nombre funcional del modulo tecnico historico `Compras`,
  limitado para la primera salida a administracion de usuarios, roles, centros
  y maestros necesarios.
- `Centros` es el nombre funcional del maestro apoyado hoy en la tabla tecnica
  `cecos`.

## Estado por modulo

### maxgesth

- Rama operativa: `agent/qm-v1.0-preproduccion`, con PR #9 abierta como borrador.
- Es la fuente canonica de roadmap y continuidad.
- Primer corte de login seguro, bootstrap de `superusuario`, roles, permisos,
  ventana unica y auditoria minima ya validado.
- Ruta canonica de configuracion fijada: `compartido/.env` en desarrollo y
  `C:\ProgramData\Qontrolmed\config\.env` en ejecutable congelado.
- Modelo de entrega fijado el 2026-07-14 para una organizacion con varios
  usuarios: PyInstaller `onedir`, aplicacion bajo `Program Files` y datos
  compartidos bajo `ProgramData`.
- RC técnica `2026.07.15-rc4` generada sin `.env` real, con recursos PDF,
  manifiesto SHA-256, verificación de rutas runtime y bootstrap limpio.
- Instalación y smoke test funcional completados el 2026-07-16:
  - scripts SQL y creación de base de datos correctos;
  - aplicación instalada y operativa;
  - primera contraseña de `administrador` solicitada correctamente;
  - acceso y creación de nuevos usuarios correctos;
  - informes de Quirófanos y Preventivos generados en las rutas previstas;
  - CSV de auditoría con advertencia de sensibilidad y selección de destino.
- Incidencia historica de RC4: la configuracion inicial del `.env` requirio
  cambios manuales de permisos y propiedad. El procedimiento se sustituyo en
  RC5 por el configurador administrativo.
- RC `2026.07.16-rc5` generada con `mysql-connector-python` 9.7.0, Pillow
  12.3.0 y pypdf 6.14.2; `pdfkit`, `PyPDF2` y los binarios `wkhtmltopdf` de
  Compras quedan fuera del paquete piloto.
- Validacion limpia de RC5: `pip-audit -r requirements.txt` sin
  vulnerabilidades conocidas, 24 tests correctos y versiones nuevas
  importadas correctamente sobre Python 3.13.
- Incorporado `configurar_qontrolmed_env.ps1` para crear o editar el `.env`
  elevado y reaplicar propietario/ACL al cerrar. El verificador comprueba
  propietario Administradores, control total de Administradores/`SYSTEM`,
  lectura para Usuarios y ausencia de escritura para Usuarios.
- Paquete RC5 validado: ZIP y SHA-256 coincidentes, 2.216 entradas de manifiesto
  correctas, sin `.env` real, con configurador administrativo incluido y prueba
  de arranque de 10 segundos correcta.
- Validacion manual comunicada el 2026-07-17: RC5 instalada sin incidencias,
  `.env` creado correctamente y PDF generados en las rutas previstas.
- Las ACL generales de instalacion y los accesos funcionales segun rol ya se
  probaron en RC3/RC4. RC5 no modifica login, roles ni autorizacion, por lo que
  no se repite la matriz completa; solo corresponde una regresion puntual de la
  ACL del `.env`, porque su configurador si es nuevo en RC5.
- Regresion ACL de RC5 confirmada: el usuario Windows normal puede ejecutar la
  aplicacion y no puede modificar binarios ni configuracion. La lectura tecnica
  minima del `.env` se conserva para que el proceso pueda cargar la conexion.
- Backup logico de los tres esquemas generado y registrado el 2026-07-17:
  tres ficheros, cobertura `gestion`/`quirofanos`/`preventivos` correcta,
  frescura `ok` (0,18 horas) y CSV con SHA-256. Segunda copia verificada en
  `K:\backup_mysql_2026-07-17_completa`: 3 de 3 ficheros con igual tamano y
  SHA-256. Restauracion mediante MySQL Workbench completada sin errores en
  `gestion_restore`, `quirofanos_restore` y `preventivos_restore`. Smoke test
  final correcto: login, configuracion temporal, apertura de los tres modulos y
  muestra de 4 o 5 accesos por cada UI; configuracion operativa restaurada al
  terminar. No se realizo una regresion exhaustiva del 100 % de enlaces.
- Los certificados y salidas locales observados son ejemplos de trabajo, no son
  validos para produccion y no deben migrarse. `ProgramData` debe iniciar vacio
  en esas carpetas. Esto incluye todos los PDF generados hasta ahora.
- Validacion local de 2026-06-24: `src/compartido/.env` ya no existe,
  `compartido/.env` existe, `cargar_entorno_db()` carga correctamente y
  `compileall` pasa.
- Receta de instalacion, backup, restauracion y smoke test cerrada en
  `docs/checklist_configuracion_preproduccion.md`.
- Validacion tecnica de 2026-06-26: el lado escritorio compila y acepta el
  fixture JSON `1.1` generado desde `maxgesth_port`, con
  `informes[*].observaciones` y resultados `estado="NA"` con `valor_leido`
  nulo/no numerico. Herramienta:
  `scripts/validate_preventivos_tablet_fixture.py`.
- Validacion de esquema de 2026-06-27: la BD Preventivos configurada contiene
  `informes_preventivo.observaciones` como `text` y
  `resultados_preventivo.estado` como `enum('P','B','M','NA')`.
  Herramienta:
  `scripts/check_preventivos_paquete_a_schema.py`.
- Validacion manual de 2026-07-12: el usuario confirma flujo correcto en ambos
  sentidos para calculo de resultado desde valor de referencia, `NA`
  cuantitativo, traslado de observaciones y salida PDF. Paquete A queda como
  comportamiento aceptado y solo debe reabrirse por regresion o cambio nuevo de
  contrato.

### maxgesth_port

- Rama operativa observada: `main`, alineada con `origin/main`.
- Modulo de tablet Preventivos validado como base de trabajo de campo.
- Las indicaciones recogidas en `docs/cola_triaje_campo.md` ya no son simples
  hipotesis: pasan a entrada aceptada para planificar la version de septiembre.
- Paquete A de Preventivos implementado en commit `92013f1` y ya incluido en
  `origin/fix-trabajo-campo`: observaciones generales de informe, `NA`
  cuantitativo, exportacion `1.1` y features declaradas.
- Validacion local de 2026-06-26: `scripts/build_android_apk.ps1 -ChecksOnly`
  pasa compilacion, `test_import.py` y `test_report_service.py`.
- Validacion manual funcional de 2026-07-12: resultado desde valor de
  referencia, `NA` cuantitativo, observaciones y salida PDF correctos. La build
  local sigue siendo la via recomendada si se necesita nuevo APK de prueba.
- Cierre de campo de 2026-07-13 integrado en `main` y tagueado como
  `preventivos-pruebas-campo-2026-07-13` sobre commit `1c82696`:
  identificacion de equipo en tablet, referencias `DESF` y documentacion local
  de cierre.
- Solo debe tocarse por contrato, import/export, ergonomia critica de campo o
  validacion Android; la exportacion por lotes queda fuera del corte inicial.

### maxgestq_mov

- Rama observada: `main`.
- Modulo de tablet Quirofanos IT en standby.
- Mantener compatibilidad de contrato JSON, pruebas de import/export y criterio
  de distribucion APK.
- No abrir nuevas prestaciones salvo incidencia real o dependencia directa de
  la version inicial de produccion.

## Decisiones vigentes

### Acceso y seguridad

- El acceso implicito al primer usuario activo sin contrasena no es valido para
  produccion.
- El bootstrap de `superusuario` queda validado como flujo guiado y acotado.
- `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1` solo se permite en soporte,
  restauracion o validacion controlada.
- El entorno normal debe operar con `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`.
- Bloqueo vigente: 3 intentos fallidos consecutivos sobre la misma cuenta y 5
  minutos de bloqueo temporal.
- No se amplia por ahora a persistencia entre reinicios salvo exigencia de
  piloto o produccion.

### Auditoria

- Primer corte implantado para login/acceso, import/export Preventivos e
  import/export Android Quirofanos.
- La consulta minima y exportacion CSV desde `Gestion/Seguridad/Auditoria`
  quedan como base valida.
- Pendiente para produccion: politica de retencion y alcance exacto de
  impresion, reimpresion, cierre y cambios sensibles.

### Campo

- `docs/cola_triaje_campo.md` queda aceptada como evidencia de campo.
- Las entradas de severidad `alta` se incorporan al bloque de preparacion de
  septiembre.
- Las entradas `media` se agrupan por eficiencia de campo y se abordaran si no
  comprometen hardening, instalacion ni consistencia.
- Las entradas ya validadas localmente quedan como comportamiento aceptado y
  solo se reabren por regresion.

### Compras e Informes

- Compras funcionales, circuitos de compra y analitica/informes ampliados no
  forman parte de la version inicial de septiembre.
- No deben consumir prioridad salvo que bloqueen usuarios, roles, centros,
  maestros, auditoria o una salida tecnica de produccion.

## Trabajo pendiente hacia septiembre

1. Cerrar configuracion local y despliegue base:
   - ruta canonica fijada en `compartido/.env` para desarrollo y
     `C:\ProgramData\Qontrolmed\config\.env` para el ejecutable;
   - variables normales frente a variables de soporte;
   - receta de instalacion, backup, restauracion y smoke test documentada;
   - separacion de runtime, exports, builds y secretos implementada y validada
     en el puesto controlado;
   - creacion elevada del `.env` y rutas PDF validadas en RC5;
   - propietario y ACL comprobados con usuario Windows normal: ejecucion de la
     aplicacion permitida y modificacion de configuracion denegada.

2. Consolidar seguridad y acceso:
   - receta operativa de bootstrap;
   - roles iniciales reales;
   - pruebas de denegacion y modo lectura;
   - auditoria minima de eventos sensibles.

3. Preparar maestros de produccion:
   - politica inicial fijada: `Centros` comienza vacio y `administrador` no
     requiere centro inicial;
   - roles/permisos se regeneran mediante bootstrap oficial;
   - se conserva el catalogo base de puntos de control de Quirofanos;
   - se conservan provisionalmente tipos, puntos, plantillas y relaciones de
     Preventivos; se contrastan con las plantillas de la empresa antes de
     decidir si se mantienen, adaptan o sustituyen;
   - equipos de medida se cargan por el usuario o mediante configuracion
     controlada tras la primera toma de contacto;
   - migraciones SQL explicitas;
   - validaciones minimas de datos de contacto y activacion.

4. Mantener campo Preventivos aceptado:
   - Paquete A cerrado: observaciones en tablet, retorno a sobremesa y `NA`
     cuantitativo;
   - Paquete B cerrado: identificacion por numero de serie e inventario y
     referencias `DESF-Q01` a `DESF-Q08`;
   - exportacion movil -> sobremesa por lotes aplazada para estabilizacion
     posterior, sin cambios en el contrato actual.

5. Preparar trazabilidad y recuperacion:
   - backup/restauracion ensayados y smoke test correcto el 2026-07-17;
   - control de migraciones;
   - revision de atomicidad en cierres, importaciones y regeneracion de PDF;
   - checklist de preproduccion.

6. Preparar y gobernar el piloto:
   - una empresa y un conjunto limitado de usuarios nominales;
   - datos iniciales revisados y entorno limpio de artefactos de desarrollo;
   - soporte reforzado, registro de incidencias y rollback disponible;
   - observacion real entre dos y cuatro semanas antes de decidir ampliacion.

7. Congelar alcance de primera version:
   - no abrir Compras operativas;
   - no abrir Informes/Analitica ampliada;
   - no abrir nuevas prestaciones moviles sin evidencia de campo.

## Tarea recomendada de la próxima sesión

`Retomar en la segunda quincena de agosto el inventario con la empresa piloto`

Objetivo:

- confirmar si la empresa quiere dar de alta los centros manualmente o aportar
  una precarga controlada;
- cruzar las plantillas provisionales de Preventivos con las aportadas o
  validadas por la empresa;
- identificar quirofanos, equipos de medida y usuarios nominales iniciales;
- documentar cualquier migracion SQL necesaria sin autoajustes silenciosos;
- mantener congelado el alcance documentado en
  `docs/plan_seguridad_consistencia.md`.

## Pendientes de informacion

- matriz final de permisos por rol;
- politica de retencion de auditoria;
- criterio final de backup/restauracion para cliente;
- alcance exacto de impresion y reimpresion;
- datos iniciales que aporte o apruebe la empresa piloto;

## Riesgos abiertos

- Persistencia local de `src/compartido/.env` antiguo en entornos ya usados.
- Acumulacion de tareas de readiness frente a la ventana de septiembre.
- Entradas de campo ya cerradas que no deben reabrirse salvo regresion.
- Paquete A y Paquete B quedan aceptados; la exportacion por lotes queda fuera
  del corte inicial y no debe reabrir el contrato tablet-sobremesa.
- Un artefacto PDF de desarrollo podria confundirse con documentacion real si
  no se limpia el entorno antes de la implantacion.
- `maxgestq_mov` esta en `main`; si se reabre, conviene aislar cambios antes de
  tocar funcionalidad.

## Donde esta el detalle

- Roadmap y prioridades: `docs/plan_seguridad_consistencia.md`
- Configuracion y preproduccion: `docs/checklist_configuracion_preproduccion.md`
- Runbook Paquete A con datos reales:
  `docs/runbook_validacion_paquete_a_preventivos_datos_reales.md`
- Cola de campo aceptada: `docs/cola_triaje_campo.md`
- Criterio documental: `docs/mapa_documental_proyecto.md`
- Acceso y roles: `docs/roles_operativos_acceso.md`
- Validación de instalación: `docs/diario_sesiones/2026-07-16.md`
