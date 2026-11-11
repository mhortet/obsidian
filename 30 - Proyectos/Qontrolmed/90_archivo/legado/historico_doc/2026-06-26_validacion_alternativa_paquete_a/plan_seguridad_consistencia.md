# Plan maestro unico de trabajo, seguridad y consistencia
[[masgesth]]
Fecha de revision: 2026-06-23

## Objetivo

Este documento es la guia viva del roadmap de `Qontrolmed` y coordina los tres
repositorios actuales:

- `maxgesth`: escritorio, datos, seguridad, maestros y documentacion viva.
- `maxgesth_port`: tablet offline de Preventivos.
- `maxgestq_mov`: tablet offline de Quirofanos IT.

El objetivo de etapa es llegar a septiembre con una version inicial de
produccion controlada. La prioridad ya no es ampliar superficie funcional, sino
cerrar lo necesario para instalar, operar, auditar, recuperar y mantener el
sistema con seguridad razonable.

## Decisiones activas

- `Qontrolmed` es el nombre funcional del escritorio.
- El roadmap vive en `maxgesth` y gobierna los tres repositorios.
- Las observaciones de `docs/cola_triaje_campo.md` se dan por validas tras
  prueba de campo y entran en planificacion.
- Preventivos tablet queda como modulo de campo aceptado, pendiente de cerrar
  observaciones priorizadas.
- Quirofanos tablet queda en standby salvo incidencia real o dependencia de
  contrato.
- Compras funcionales e Informes/Analitica ampliados pasan a version posterior.
- `Gestion` se conserva en la version inicial solo para usuarios, roles,
  seguridad, centros y maestros imprescindibles.
- La ruta canonica de configuracion queda fijada en `compartido/.env`.
- No se renombran nombres tecnicos de paquetes, rutas o tablas salvo migracion
  separada.

## Estado de lineas activas

| Linea | Estado | Prioridad | Lectura operativa |
| --- | --- | --- | --- |
| Fase 1. Documentacion viva y criterio unico | en curso | alta | Reordenar documentos para que la entrada de sesion sea breve, actual y sin backlogs competidores. |
| Fase 2. Hardening y readiness de produccion | en curso | muy alta | Acceso, configuracion local, auditoria, migraciones, backup y preparacion de instalacion. |
| Fase 3. Maestros minimos de produccion | pendiente | alta | Centros, equipos de medida y datos base necesarios para operar sin deuda critica. |
| Fase 4. Campo Preventivos validado | pendiente | alta | Incorporar observaciones aceptadas de campo que afecten cierre real o calidad de datos. |
| Fase 5. Trazabilidad y recuperacion | pendiente | alta | Consistencia, atomicidad, backup/restauracion y checklist de preproduccion. |
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
- ruta canonica de `.env` alineada en desarrollo, ejecutable y empaquetado:
  `compartido/.env`.

### Pendiente inmediato

- retirar o ignorar operativamente cualquier `src/compartido/.env` legado;
- documentar uso normal frente a soporte;
- definir instalacion y ubicacion final de credenciales;
- ensayar backup/restauracion antes de hablar de produccion.

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

### Prioridad media agrupable

- mostrar numero de serie e inventario en identificacion de equipo;
- referencia editable en `DESF-Q01` a `DESF-Q08`;
- busqueda por numero de serie en escritorio;
- exportacion movil -> sobremesa por bloques, si entra en el circuito inicial;
- mejoras de ergonomia ya validadas localmente, solo por regresion o extension
  planificada.

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

- checklist de backup/restauracion;
- entorno de prueba de migraciones;
- datos minimos de Centros;
- criterio de aceptacion para septiembre.

### Campo Preventivos

- decidir si exportacion por bloques entra en septiembre;
- validar cambios `alta` en ambos lados del flujo;
- confirmar impacto en PDF o historico al anadir observaciones/NA.

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
python -m compileall main.py src
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
