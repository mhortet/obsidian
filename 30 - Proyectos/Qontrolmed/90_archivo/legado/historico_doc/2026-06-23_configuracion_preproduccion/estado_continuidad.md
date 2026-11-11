# Estado de continuidad
[[masgesth]]
Fecha: 2026-06-22

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
- Riesgo operativo inmediato: coexistencia de `compartido/.env` y
  `src/compartido/.env`; la aplicacion en desarrollo lee `src/compartido/.env`.
- Siguiente frente recomendado: ordenar configuracion local, receta de acceso
  seguro y preparacion de instalacion/despliegue.

### maxgesth_port

- Rama operativa observada: `fix-trabajo-campo`.
- Modulo de tablet Preventivos validado como base de trabajo de campo.
- Las indicaciones recogidas en `docs/cola_triaje_campo.md` ya no son simples
  hipotesis: pasan a entrada aceptada para planificar la version de septiembre.
- Solo debe tocarse por contrato, import/export, ergonomia critica de campo o
  cierre de las observaciones aceptadas.

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
   - ruta canonica del `.env`;
   - variables normales frente a variables de soporte;
   - receta de instalacion o configuracion de cliente;
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

`Ordenar configuracion local y preparar checklist de salida inicial`

Objetivo:

- fijar y documentar una ruta canonica de configuracion;
- dejar receta breve de acceso seguro para uso normal, soporte y bootstrap;
- listar los elementos minimos de instalacion, backup y validacion antes de
  septiembre;
- no tocar Compras ni Informes salvo dependencia directa.

Si se decide abrir campo Preventivos:

- empezar por `docs/cola_triaje_campo.md`;
- abordar primero las entradas `alta` ya aceptadas;
- revisar ambos lados del contrato si el cambio afecta tablet y sobremesa.

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

- Confusion operativa por doble ubicacion de `.env`.
- Acumulacion de tareas de readiness frente a la ventana de septiembre.
- Entradas de campo aceptadas que pueden tocar contrato tablet-sobremesa y deben
  validarse en ambos lados.
- Falta de decision final sobre instalacion, credenciales y backup.
- `maxgestq_mov` esta en `main`; si se reabre, conviene aislar cambios antes de
  tocar funcionalidad.

## Donde esta el detalle

- Roadmap y prioridades: `docs/plan_seguridad_consistencia.md`
- Cola de campo aceptada: `docs/cola_triaje_campo.md`
- Criterio documental: `docs/mapa_documental_proyecto.md`
- Acceso y roles: `docs/roles_operativos_acceso.md`
- Validaciones recientes: `docs/diario_sesiones/2026-06-14.md` y
  `docs/diario_sesiones/2026-06-15.md`
