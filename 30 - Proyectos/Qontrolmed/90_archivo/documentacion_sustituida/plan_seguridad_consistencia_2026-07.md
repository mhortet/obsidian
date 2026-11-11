# Plan maestro unico de trabajo, seguridad y consistencia
[[masgesth]]
Fecha de revision: 2026-07-17

## Objetivo

Este documento es la guia viva del roadmap de `Qontrolmed` y coordina los tres
repositorios actuales:

- `maxgesth`: escritorio, datos, seguridad, maestros y documentacion viva.
- `maxgesth_port`: tablet offline de Preventivos.
- `maxgestq_mov`: tablet offline de Quirofanos IT.

El objetivo de etapa es realizar en septiembre una implantacion piloto
controlada en una unica empresa para validar definitivamente el funcionamiento
real. No es un despliegue masivo ni la declaracion de disponibilidad general.
La prioridad ya no es ampliar superficie funcional, sino cerrar lo necesario
para instalar, operar, supervisar, auditar, recuperar y retirar el piloto con
seguridad razonable.

## Decisiones activas

- `Qontrolmed` es el nombre funcional del escritorio.
- El roadmap vive en `maxgesth` y gobierna los tres repositorios.
- Las observaciones de `docs/cola_triaje_campo.md` se dan por validas tras
  prueba de campo y entran en planificacion.
- Preventivos tablet queda como modulo de campo aceptado; Paquete A
  (`observaciones` y `NA` cuantitativo) queda validado manualmente el
  2026-07-12, y Paquete B queda cerrado/tagueado en `maxgesth_port` el
  2026-07-13.
- La exportacion movil -> sobremesa por lotes queda aplazada para una revision
  posterior y no forma parte del corte inicial de septiembre.
- Quirofanos tablet queda en standby salvo incidencia real o dependencia de
  contrato.
- Compras funcionales e Informes/Analitica ampliados pasan a version posterior.
- Los binarios `wkhtmltopdf` conservados en `src/Compras/bin` pertenecen al
  modulo Compras aparcado. Se mantienen en el repositorio para su desarrollo
  futuro, pero no se ejecutan ni se incluyen en el paquete del piloto.
- `Gestion` se conserva en la version inicial solo para usuarios, roles,
  seguridad, centros y maestros imprescindibles.
- La ruta canonica de configuracion queda fijada en `compartido/.env` para
  desarrollo y `C:\ProgramData\Qontrolmed\config\.env` para el ejecutable.
- Los PDF presentes actualmente en el entorno son salidas sinteticas de pruebas
  funcionales durante el desarrollo. No son documentos reales, no forman parte
  del historico del piloto y no deben migrarse a la empresa.
- No se renombran nombres tecnicos de paquetes, rutas o tablas salvo migracion
  separada.

## Alcance congelado de la primera version

Entran en el corte inicial:

- escritorio `Qontrolmed` como hub operativo;
- login seguro, usuarios, roles, permisos y auditoria minima;
- `Gestion` limitada a usuarios, roles, Centros y maestros imprescindibles;
- Preventivos con Paquete A y Paquete B ya aceptados, manteniendo el contrato
  tablet-sobremesa vigente;
- Quirofanos existente, sin ampliacion funcional, salvo correccion bloqueante
  o de contrato;
- importaciones, exportaciones y PDF ya necesarios para los circuitos
  aceptados;
- instalacion, configuracion, migraciones, backup/restauracion, smoke test y
  paquete RC de preproduccion.

Quedan fuera del corte inicial:

- exportacion de Preventivos por lotes;
- Compras operativas y sus informes;
- Informes/Analitica ampliados;
- nuevas prestaciones moviles o mejoras ergonomicas sin incidencia real;
- ampliaciones de identidad visual que no sean necesarias para operar.

Este alcance solo se reabre antes del RC por una incidencia bloqueante, perdida
de datos, rotura de contrato o requisito externo imprescindible para instalar y
operar.

## Estrategia de implantacion piloto de septiembre

La salida de septiembre se organiza como una prueba definitiva de operacion
real, limitada a una empresa, usuarios identificados y circuitos acordados.

Fases previstas:

1. Julio: cerrar RC5 de dependencias, ACL del `.env` y procedimiento de
   backup/restauracion.
2. Agosto: repetir instalacion limpia, restauracion, usuarios/roles, smoke test
   y preparacion de datos iniciales del piloto.
3. Inicio de septiembre: simulacion de aceptacion, congelacion de la RC y
   decision formal de entrada.
4. Implantacion: activacion controlada, soporte reforzado, monitorizacion y
   posibilidad de rollback.
5. Observacion: entre dos y cuatro semanas de uso real, con seguimiento diario
   inicial y revision semanal de incidencias, seguridad y consistencia.

Hito de calendario: el bloque tecnico previo a vacaciones queda cerrado el
2026-07-17, siete dias antes de la fecha objetivo. La recopilacion de datos y
plantillas con la empresa piloto se reanuda, como pronto, en la segunda
quincena de agosto. Hasta entonces, las lineas futuras de aplicacion y web se
trabajan separadas de la referencia RC5 validada.

Criterios minimos para autorizar la entrada:

- dependencias auditadas y sin vulnerabilidades conocidas no aceptadas;
- paquete del piloto sin `pdfkit` ni binarios `wkhtmltopdf`, aunque los activos
  legados de Compras permanezcan conservados en su directorio fuente;
- `.env` instalable y actualizable con propietario y ACL reproducibles;
- backup y restauracion completos ensayados sobre esquemas de prueba;
- usuarios nominales, roles y permisos comprobados;
- datos de prueba y PDF de desarrollo retirados antes de cargar datos reales;
- responsable operativo, soporte, ventana de intervencion y rollback definidos.

La salida del piloto requerira una decision explicita: ampliar, mantener
controlado, corregir y repetir, o retirar. Ninguna de ellas implica por si sola
un despliegue masivo.

## Estado de lineas activas

| Linea | Estado | Prioridad | Lectura operativa |
| --- | --- | --- | --- |
| Fase 1. Documentacion viva y criterio unico | en curso | alta | Reordenar documentos para que la entrada de sesion sea breve, actual y sin backlogs competidores. |
| Fase 2. Hardening y readiness de produccion | en curso | muy alta | Acceso, configuracion local, auditoria, migraciones, backup y preparacion de instalacion. |
| Fase 3. Maestros minimos de produccion | en curso | alta | Politica inicial decidida; falta contrastar puntos, plantillas y datos reales con la empresa piloto. |
| Fase 4. Campo Preventivos validado | validado en campo | alta | Paquete A y Paquete B cerrados; exportacion por lotes aplazada para estabilizacion posterior. |
| Fase 5. Trazabilidad y recuperacion | en curso | alta | Backup/restauracion y smoke test validados; quedan consistencia, atomicidad y control de migraciones. |
| Fase 6. Quirofanos movil en standby | standby | media | Mantener contrato y pruebas; no abrir nuevas prestaciones sin evidencia real. |
| Fase 7. Compras e Informes futuros | standby | baja | Pospone compras operativas, informes directivos y analitica ampliada a version posterior. |

Estados permitidos:

- `pendiente`
- `en curso`
- `validado en campo`
- `standby`
- `bloqueado`

## Regla de prioridad

Orden por defecto hasta septiembre:

1. Configuracion local, acceso seguro, auditoria y receta de instalacion.
2. Maestros minimos y migraciones necesarias para produccion controlada.
3. Observaciones de campo Preventivos con severidad `alta`.
4. Trazabilidad, backup/restauracion y checklist de preproduccion.
5. Observaciones Preventivos de severidad `media` que mejoren eficiencia sin
   comprometer las prioridades anteriores.
6. Quirofanos movil solo por contrato o incidencia real.
7. Compras operativas e Informes/Analitica ampliados para version posterior.

Excepcion:

- una incidencia `bloqueante` o `alta` detectada en campo puede romper el orden
  si impide terminar trabajo real, compromete persistencia o rompe el contrato
  tablet-sobremesa.

## Arranque minimo de sesion

La primera propuesta de cada sesion debe dejar:

| Campo | Contenido obligatorio |
| --- | --- |
| Tarea principal | Frente elegido y objetivo concreto. |
| Tarea alternativa | Trabajo preparado si aparece bloqueo. |
| Tests exigibles | Comandos reales si hay codigo; coherencia documental si solo hay texto. |
| Validacion manual | Prueba funcional o visual pendiente, si aplica. |
| Dependencias | Repos, contratos, migraciones, entorno o decision externa. |

Si la sesion es documental:

- verificar fechas, rutas, nombres de modulo y referencias cruzadas;
- no duplicar backlog;
- mover detalle historico fuera de la entrada viva;
- comprobar que `estado_continuidad`, `plan` y `playbook` no se contradicen.

## Fase 1. Documentacion viva y criterio unico

### Objetivo

Reducir ruido de reentrada y dejar una unica fuente de verdad para continuidad,
prioridad, criterios de cierre y lectura inicial.

### Criterio de terminado

- `docs/estado_continuidad.md` funciona como foto ejecutiva breve.
- `docs/plan_seguridad_consistencia.md` contiene el roadmap y las prioridades.
- `docs/security_delivery_playbook.md` contiene la rutina de trabajo.
- `docs/mapa_documental_proyecto.md` clasifica fuentes vivas, historicas y de
  apoyo.
- `docs/Tareas Pendientes.md` no actua como backlog paralelo.
- Las notas locales de `maxgesth_port` y `maxgestq_mov` apuntan al roadmap
  canonico.

## Fase 2. Hardening y readiness de produccion

### Objetivo

Preparar `Qontrolmed` para piloto o produccion controlada sin atajos de
desarrollo.

### Alcance

- ruta canonica de configuracion local y `.env`;
- separacion entre variables normales y variables de soporte;
- receta de bootstrap seguro;
- roles iniciales y permisos efectivos;
- auditoria minima de eventos sensibles;
- migraciones SQL documentadas en lugar de autoajustes silenciosos;
- politica de secretos, exports, runtime y artefactos generados;
- checklist inicial de instalacion, backup y restauracion.

### Avance confirmado

- primer corte de `usuario -> rol -> permisos`;
- visibilidad por permisos en portada, Preventivos y Quirofanos;
- ventana unica para portada, modulos y pantallas no modales clave;
- bootstrap guiado de `superusuario` validado;
- bloqueo temporal de 3 intentos y 5 minutos;
- auditoria base de login/acceso e import/export;
- consulta y exportacion CSV de auditoria como base inicial.
- ruta canonica de `.env` alineada: `compartido/.env` en desarrollo y
  `C:\ProgramData\Qontrolmed\config\.env` en ejecutable congelado;
- modelo de despliegue elegido para una organizacion con varios usuarios:
  PyInstaller `onedir`, binarios protegidos en `Program Files` y datos
  compartidos en `ProgramData`;
- generador de RC versionada con manifiesto SHA-256 y rechazo de `.env` real;
- RC `2026.07.15-rc4` instalada desde cero y validada funcionalmente en entorno
  controlado.
- RC5 completada con MySQL Connector, Pillow y pypdf actualizados,
  `pdfkit`/`wkhtmltopdf` retirados del paquete y manipulacion PDF unificada
  sobre `pypdf`.
- Entorno limpio Python 3.13 validado: auditoria sin vulnerabilidades conocidas
  y suite automatica correcta.
- RC `2026.07.16-rc5` generada con manifiesto y hash verificados, sin `.env`
  real ni runtime `wkhtmltopdf`, y con prueba breve de arranque correcta.
- Paso administrativo del `.env` incorporado para restaurar propietario y ACL
  de forma reproducible.
- Validacion manual de RC5 comunicada el 2026-07-17: instalacion sin
  incidencias, creacion correcta del `.env` mediante el procedimiento de RC5 y
  generacion de PDF en las rutas previstas bajo `ProgramData`.
- ACL generales y accesos funcionales por permisos validados previamente en
  RC3/RC4. Como RC5 no cambia autenticacion, roles ni autorizacion, no se exige
  repetir esa matriz completa; solo la comprobacion puntual de la ACL del
  `.env` modificada por el nuevo configurador.
- Comprobacion puntual de RC5 cerrada: un usuario Windows normal puede ejecutar
  la aplicacion y no puede modificar los binarios ni la configuracion.

### Pendiente inmediato

- retirar PDF, exports y otros artefactos de prueba antes de preparar el piloto;
- resolver firma digital si la politica del centro la exige;
- definir maestros minimos, datos iniciales y migraciones necesarias para el
  piloto.

## Fase 3. Maestros minimos de produccion

### Objetivo

Dejar datos base suficientes para operar sin inconsistencias graves.

### Alcance inicial

- `Centros` como nombre funcional apoyado por la tabla tecnica `cecos`;
- campos de contacto y mantenimiento necesarios;
- equipos de medida como maestro comun cuando proceda;
- reglas de activacion/desactivacion;
- migraciones SQL explicitas;
- revision de dependencias en usuarios, Preventivos, Quirofanos y PDF.

### Decision de datos iniciales

- `gestion.cecos` comienza vacia; el administrador inicial no necesita centro
  porque `usuarios.id_ceco` admite `NULL`;
- roles, permisos y asignaciones se regeneran mediante el bootstrap oficial;
- se conserva el catalogo base de puntos de control de Quirofanos, pero no las
  asignaciones a quirofanos de desarrollo;
- tipos de equipo, puntos, plantillas y relaciones de Preventivos se conservan
  provisionalmente como un conjunto coherente;
- cada plantilla se cruza con la equivalente de la empresa antes de decidir si
  se mantiene, adapta o sustituye;
- equipos de medida, centros, usuarios nominales y el resto de datos se crean
  por usuarios autorizados o mediante configuracion controlada tras la primera
  toma de contacto;
- no se migra historico operativo ni datos transaccionales de desarrollo.

Detalle: `docs/politica_datos_iniciales_piloto.md`.

### Fuera de alcance

- evolucion completa de Compras;
- informes de compra;
- analitica directiva o cuadros ampliados.

## Fase 4. Campo Preventivos validado

### Objetivo

Incorporar las observaciones reales de campo sin abrir una nueva fase funcional
descontrolada.

### Prioridad alta

- anadir `observaciones` al final del formulario movil y asegurar retorno a
  sobremesa;
- permitir `NA` en puntos cuantitativos cuando el control no aplique;
- revisar contrato tablet-sobremesa si cualquiera de los dos cambios modifica
  JSON, persistencia o PDF.

### Avance confirmado

- Analisis de Paquete A cerrado como `LISTO PARA IMPLEMENTAR` en
  `docs/analisis_paquete_a_preventivos_2026-06-25.md`.
- Implementacion tablet observada en `maxgesth_port` commit `92013f1`, con
  exportacion version `1.1`, feature `informe_observaciones` y feature
  `cuantitativo_na`.
- Validacion local de `maxgesth_port` el 2026-06-26 mediante
  `scripts/build_android_apk.ps1 -ChecksOnly`: compilacion, `test_import.py` y
  `test_report_service.py` correctos.
- Validacion de contrato en `maxgesth` el 2026-06-26: fixture JSON `1.1`
  generado desde el exportador real de `maxgesth_port` y validado con
  `scripts/validate_preventivos_tablet_fixture.py`, sin tocar BD real.
- Validacion de esquema en `maxgesth` el 2026-06-27: la BD Preventivos
  configurada contiene `informes_preventivo.observaciones` como `text` y
  `resultados_preventivo.estado` como `enum('P','B','M','NA')`. Herramienta:
  `scripts/check_preventivos_paquete_a_schema.py`.
- Validacion manual de 2026-07-12: calculo de resultado desde valor de
  referencia, `NA` cuantitativo, traslado de observaciones e informe PDF
  correctos en ambos sentidos revisados por el usuario.

### Seguimiento especifico

- No quedan pendientes funcionales de Paquete A salvo regresion.
- Paquete B queda cerrado en `maxgesth_port` y tagueado como
  `preventivos-pruebas-campo-2026-07-13` sobre commit `1c82696`.
- Mantener pruebas de contrato si se toca exportacion/importacion.
- Si se genera nuevo APK por cambios de UI o flujo, probar build local y
  dispositivo antes de cerrar.
- La exportacion por lotes queda fuera del corte inicial y solo se reabrira en
  una revision posterior de estabilizacion.

### Cerrado en Paquete B

- mostrar numero de serie e inventario en identificacion de equipo;
- referencia editable en `DESF-Q01` a `DESF-Q08`;
- busqueda por numero de serie en escritorio;
- mejoras de ergonomia ya validadas localmente, solo por regresion o extension
  planificada.

### Decision cerrada el 2026-07-14

- La exportacion movil -> sobremesa por lotes queda aplazada.
- Se mantiene el contrato actual y no se consume la ventana previa a vacaciones
  en una mejora de flujo no imprescindible para el circuito inicial.
- Una futura reapertura exigira necesidad operativa confirmada, criterio
  anti-duplicados, validacion de escritorio y prueba Android.

## Fase 5. Trazabilidad y recuperacion

### Objetivo

Reducir riesgo de perdida de datos, duplicidad o estados parciales.

### Alcance

- atomicidad en operaciones cabecera-detalle;
- importaciones con resumen claro y rollback real;
- cierre, firma, PDF, impresion y reimpresion auditables;
- politica de backup/restauracion;
- rutas runtime fuera de codigo fuente;
- validacion de migraciones en entorno de prueba;
- checklist de preproduccion.

### Evidencia confirmada

- backup logico de `gestion`, `quirofanos` y `preventivos` con manifiesto y
  SHA-256;
- segunda copia integra en una ubicacion independiente;
- restauracion correcta en los tres esquemas `_restore` mediante Workbench;
- smoke test correcto contra la restauracion: login, modulos principales y
  muestra de 4 o 5 accesos por cada UI;
- configuracion operativa restaurada al finalizar;
- cobertura declarada como smoke test, no como regresion exhaustiva del 100 %
  de enlaces.

## Fase 6. Quirofanos movil en standby

### Objetivo

Conservar el modulo operativo sin consumir prioridad de la primera salida.

### Regla

- tocar solo por incidencia real, contrato JSON, import/export, build Android o
  regresion confirmada.

### Tests recomendados si se toca

```powershell
python -m unittest test_import_export_contract.py test_catalog_service.py test_point_validation.py test_informe_service.py
python -m compileall -q main.py src test_catalog_service.py test_import_export_contract.py test_informe_service.py test_point_validation.py
```

## Fase 7. Compras e Informes futuros

### Objetivo

Dejar claro que no son parte del primer corte de septiembre.

### Standby

- Compras operativas;
- informes de compra;
- modulo analitico ampliado;
- informes directivos o dashboards;
- nuevas prestaciones no necesarias para seguridad, maestros, campo o
  produccion controlada.

## Pendientes de informacion

### Instalacion y entorno

- mecanismo final de distribucion;
- ubicacion de credenciales y parametros;
- asistente inicial o fichero gestionado;
- ruta final de exports, backups y artefactos runtime.

### Seguridad

- matriz final de permisos por rol;
- si `Consulta` entra en primera version;
- politica de retencion de auditoria;
- criterios de impresion y reimpresion.

### Produccion

- entorno de prueba de migraciones;
- datos minimos de Centros;
- responsables y usuarios incluidos en el piloto;
- ventana de implantacion y soporte;
- criterio de aceptacion y salida del piloto de septiembre.

### Campo Preventivos

- exportacion por lotes aplazada para revision posterior;
- mantener Paquete A cerrado salvo regresion;
- mantener Paquete B cerrado salvo regresion.

## Politica de pruebas y cierre

Una tarea puede estar implementada o validada sin estar cerrada. Cerrar tarea
implica:

- tests proporcionales ejecutados;
- validacion manual si aplica;
- documentacion viva actualizada;
- commit pequeno y coherente;
- push de la rama correspondiente.

Validacion base de escritorio si hay codigo:

```powershell
python -m unittest discover -s tests -v
python -m compileall main.py src
python -m pip_audit -r requirements.txt
python scripts\validate_preventivos_tablet_fixture.py
python scripts\check_preventivos_paquete_a_schema.py
```

Tablet Preventivos si se toca import/export o informes:

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\data\schema.py src\services\import_service.py src\services\report_service.py src\services\export_service.py
```

Si la sesion solo toca documentacion:

- comprobar referencias cruzadas;
- comprobar que no se duplica backlog;
- verificar que las notas locales de los modulos no contradicen el roadmap.
