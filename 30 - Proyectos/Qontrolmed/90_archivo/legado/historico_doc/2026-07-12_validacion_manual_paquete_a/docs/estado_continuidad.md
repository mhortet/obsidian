# Estado de continuidad
[[masgesth]]
Fecha: 2026-06-27

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

## Foto ejecutiva a 2026-06-22

- El objetivo operativo pasa a ser disponer en septiembre de una version inicial
  de produccion controlada.
- `maxgesth` / `Qontrolmed` sigue siendo el hub de producto, datos, seguridad,
  documentacion viva y preparacion de despliegue.
- `maxgesth_port` queda aceptado como modulo de campo de Preventivos, con las
  observaciones de `docs/cola_triaje_campo.md` ya consideradas validas para
  planificacion.
- `maxgestq_mov` queda en standby operativo: mantener compatibilidad de
  contrato y corregir solo incidencias reales de campo o de import/export.
- La linea de Compras operativa y el modulo de Informes/Analitica pasan a
  version posterior. En la version inicial solo se conserva lo imprescindible
  de `Gestion` para usuarios, roles, centros, maestros y soporte operativo.
- El foco principal hasta septiembre es readiness: configuracion, acceso,
  auditoria, maestros, migraciones, consistencia de datos, backup/restauracion y
  empaquetado de entrega.

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

- Rama operativa observada: `fix-trabajo-campo`.
- Es la fuente canonica de roadmap y continuidad.
- Primer corte de login seguro, bootstrap de `superusuario`, roles, permisos,
  ventana unica y auditoria minima ya validado.
- Ruta canonica de configuracion fijada: `compartido/.env` tanto en desarrollo
  como en ejecutable congelado.
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
- Decision operativa de 2026-06-27: no avanzar con datos ficticios porque la
  validacion habria que repetirla. Queda preparado el runbook
  `docs/runbook_validacion_paquete_a_preventivos_datos_reales.md` para ejecutar
  a tiro hecho cuando haya datos reales o copia controlada.
- Siguiente frente recomendado en Paquete A: ejecutar el runbook sobre BD de
  preproduccion o copia controlada, revisar persistencia/PDF y dejar la prueba
  real APK/tablet como pendiente explicito hasta recuperar cuota o dispositivo.

### maxgesth_port

- Rama operativa observada: `fix-trabajo-campo`.
- Modulo de tablet Preventivos validado como base de trabajo de campo.
- Las indicaciones recogidas en `docs/cola_triaje_campo.md` ya no son simples
  hipotesis: pasan a entrada aceptada para planificar la version de septiembre.
- Paquete A de Preventivos implementado en commit `92013f1` y ya incluido en
  `origin/fix-trabajo-campo`: observaciones generales de informe, `NA`
  cuantitativo, exportacion `1.1` y features declaradas.
- Validacion local de 2026-06-26: `scripts/build_android_apk.ps1 -ChecksOnly`
  pasa compilacion, `test_import.py` y `test_report_service.py`.
- La prueba real en APK/tablet queda pendiente por bloqueo externo de cuota
  mensual de GitHub Actions o disponibilidad de dispositivo; no tratar ese
  bloqueo como fallo tecnico del paquete.
- Solo debe tocarse por contrato, import/export, ergonomia critica de campo,
  validacion Android o cierre de las observaciones aceptadas.

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
   - ruta canonica del `.env` fijada en `compartido/.env`;
   - variables normales frente a variables de soporte;
   - receta de instalacion, backup, restauracion y smoke test documentada;
   - separacion de runtime, exports, builds y secretos.

2. Consolidar seguridad y acceso:
   - receta operativa de bootstrap;
   - roles iniciales reales;
   - pruebas de denegacion y modo lectura;
   - auditoria minima de eventos sensibles.

3. Preparar maestros de produccion:
   - Centros como nombre funcional;
   - equipos de medida como fuente comun;
   - migraciones SQL explicitas;
   - validaciones minimas de datos de contacto y activacion.

4. Incorporar campo Preventivos aceptado:
   - observaciones en tablet y retorno a sobremesa;
   - `NA` en puntos cuantitativos cuando no apliquen;
   - identificacion por numero de serie e inventario;
   - referencia editable en puntos `DESF-Q01` a `DESF-Q08`;
   - exportacion movil -> sobremesa por bloques si se confirma necesaria para
     el circuito inicial.

5. Preparar trazabilidad y recuperacion:
   - backup/restauracion ensayados;
   - control de migraciones;
   - revision de atomicidad en cierres, importaciones y regeneracion de PDF;
   - checklist de preproduccion.

6. Congelar alcance de primera version:
   - no abrir Compras operativas;
   - no abrir Informes/Analitica ampliada;
   - no abrir nuevas prestaciones moviles sin evidencia de campo.

## Tarea recomendada de la proxima sesion

`Cerrar validacion de persistencia/PDF del Paquete A de Preventivos`

Objetivo:

- partir del analisis `LISTO PARA IMPLEMENTAR` de
  `docs/analisis_paquete_a_preventivos_2026-06-25.md`;
- tomar como evidencia local previa la sesion
  `docs/diario_sesiones/2026-06-26.md`;
- usar el fixture `docs/fixtures/preventivos_tablet_paquete_a_1_1.json` y el
  validador `scripts/validate_preventivos_tablet_fixture.py` como prueba
  repetible de contrato;
- tomar como evidencia de esquema la validacion de 2026-06-27 con
  `scripts/check_preventivos_paquete_a_schema.py`;
- seguir el runbook
  `docs/runbook_validacion_paquete_a_preventivos_datos_reales.md`;
- validar importacion real en `maxgesth` con observaciones de informe y `NA`
  cuantitativo solo sobre BD de preproduccion o copia controlada;
- revisar persistencia de `observaciones`, persistencia de `estado="NA"` con
  `valor_leido` nulo y salida PDF resultante;
- dejar APK/tablet real como prueba manual pendiente hasta recuperar cuota o
  dispositivo.

Si la validacion cruzada queda cerrada:

- mantener Paquete A como `VALIDADO TECNICAMENTE SIN TABLET REAL`;
- mantener estado `PENDIENTE DE PRUEBA APK/TABLET` hasta prueba fisica;
- separar cualquier mejora de Paquete B/C para no contaminar el corte de
  septiembre.

## Pendientes de informacion

- mecanismo final de instalacion y distribucion;
- ubicacion final de credenciales y parametros de conexion;
- si habra asistente inicial o fichero de configuracion gestionado;
- matriz final de permisos por rol;
- politica de retencion de auditoria;
- criterio final de backup/restauracion para cliente;
- alcance exacto de impresion y reimpresion;
- campos obligatorios de Centros;
- si la exportacion por bloques de Preventivos entra en septiembre o queda para
  estabilizacion posterior.

## Riesgos abiertos

- Persistencia local de `src/compartido/.env` antiguo en entornos ya usados.
- Acumulacion de tareas de readiness frente a la ventana de septiembre.
- Entradas de campo aceptadas que pueden tocar contrato tablet-sobremesa y deben
  validarse en ambos lados.
- Paquete A ya tiene validacion local y de contrato, pero sigue pendiente de
  prueba real en APK/tablet y de persistencia/PDF sobre copia controlada.
- Falta de decision final sobre instalacion, credenciales y backup.
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
- Validaciones recientes: `docs/diario_sesiones/2026-06-14.md` y
  `docs/diario_sesiones/2026-06-15.md`
