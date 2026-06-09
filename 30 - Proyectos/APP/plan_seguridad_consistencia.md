# Plan maestro unico de trabajo, seguridad y consistencia
[[masgesth]]
Fecha de revision: 2026-06-01

## Objetivo

Este documento pasa a ser la unica guia viva del roadmap de `Qontrolmed`
(`maxgesth`), coordinando tambien `maxgesth_port` y `maxgestq_mov` cuando una
tarea toque contrato, importacion/exportacion o criterios compartidos de
produccion.

El objetivo ya no es abrir frentes grandes en todos los modulos a la vez. El
objetivo es llegar a una salida madura a produccion con criterio unico de
prioridad, validacion, trazabilidad y continuidad.

## Decisiones activas de esta etapa

- `Qontrolmed` es el nombre funcional del escritorio.
- El roadmap vive en `maxgesth`, pero gobierna los tres repos.
- Preventivos y Quirofanos pasan a estado de operativa bastante cerrada.
- Preventivos y Quirofanos quedan en mantenimiento correctivo guiado por campo,
  no como frente principal de ampliacion.
- La prioridad pasa a endurecimiento transversal, consistencia de datos,
  maestros, gobierno documental y readiness real de produccion.
- El diario externo de cada sesion debe guardarse en
  `D:\trabajo\Proyectos\diario_qontrolmed\sesion_YYYY-MM-DD_HH-mm.md`.
- Los nombres tecnicos actuales de paquetes, rutas y tablas no se renombraran
  salvo necesidad clara de produccion o migracion separada.

## Estado de las lineas activas

| Linea | Estado | Prioridad | Lectura operativa |
| --- | --- | --- | --- |
| Fase 1. Rebase documental y criterio unico | en curso | alta | Ya es la linea viva actual y debe consolidar entrada a sesion, continuidad y criterio unico de roadmap. |
| Fase 2. Hardening transversal y readiness | pendiente | muy alta | Siguiente frente principal de codigo: acceso, roles, auditoria, despliegue y migraciones. |
| Fase 3. Gestion y maestros | pendiente | alta | Renombrado funcional, equipos de medida y evolucion de `cecos` a Centros. |
| Fase 4. Trazabilidad y consolidacion de datos | pendiente | alta | Debe apoyarse en la auditoria central y cerrar riesgos de persistencia. |
| Fase 5. Informes y analitica futura | pendiente | media | Se mantiene como destino arquitectonico, no como frente inmediato. |
| Fase 6. Mantenimiento correctivo de modulos estables | validado en campo parcial | continua | Preventivos y Quirofanos solo escalan por incidencias reales bloqueantes o altas. |

Estados permitidos para mantener esta tabla:

- `pendiente`
- `en curso`
- `bloqueado`
- `validado en campo`

## Regla de prioridad

Mientras no cambie este documento, el orden por defecto es:

1. Fase 2. Hardening transversal y readiness de produccion.
2. Fase 3. Gestion: saneamiento de maestros y nomenclatura funcional.
3. Fase 4. Trazabilidad operativa y consolidacion de datos.
4. Fase 6. Correcciones derivadas de campo en Preventivos y Quirofanos.
5. Fase 5. Modulo de informes y analitica futura.

Excepcion permitida:

- una incidencia `bloqueante` o `alta` detectada en campo puede romper el orden
  anterior si impide operativa real o compromete persistencia, contrato de
  intercambio o salida a produccion.

## Tabla minima de arranque de sesion

La primera propuesta de cada sesion debe dejar, como minimo:

| Campo | Contenido obligatorio |
| --- | --- |
| Tarea principal | frente elegido del roadmap y objetivo concreto |
| Tarea alternativa | trabajo ya preparado para saltar si hay bloqueo |
| Tests exigibles | comandos reales de cierre para esa tarea |
| Validacion manual esperada | prueba funcional o visual pendiente, si aplica |
| Dependencias | repos, modulos, migraciones o documentos que condicionan la tarea |

Si la sesion es solo documental:

- verificar rutas, comandos, referencias cruzadas y coherencia entre playbook,
  continuidad y roadmap;
- no hace falta test de codigo si no cambia ninguna regla funcional.

## Regla cuando falte informacion

- Si la informacion que falta no es bloqueante, se solicita con el mayor
  detalle posible y la sesion continua con otra tarea ya preparada del roadmap.
- Si la informacion es bloqueante para la linea activa, se solicita y esa linea
  se pausa hasta respuesta; la sesion debe saltar a otra tarea lista.
- Las dudas abiertas no deben quedarse solo en el chat: deben anotarse en
  `docs/estado_continuidad.md` y en el diario externo de la sesion.

## Fase 1. Rebase documental y criterio unico de produccion

### Objetivo

Consolidar una unica fuente de verdad para continuidad, prioridad, rutina de
entrada y criterio de cierre.

### Criterio de terminado

- `docs/plan_seguridad_consistencia.md` es la guia viva unica del roadmap.
- `docs/estado_continuidad.md` refleja tarea recomendada, riesgos y pendientes
  de informacion reales.
- `docs/security_delivery_playbook.md` refleja el ritual de sesion vigente.
- `docs/mapa_documental_proyecto.md` deja clara la fuente de verdad y evita
  competir con documentos antiguos.
- `docs/Tareas Pendientes.md` deja de funcionar como backlog paralelo.
- Existe parte externo de sesion fuera del repo en cada bloque de trabajo
  relevante.

### Acciones activas

- mantener esta tabla de estados actualizada;
- reclasificar Preventivos y Quirofanos como modulos estables con incidencias
  de campo;
- mantener un apartado fijo de `Pendientes de informacion`;
- registrar en cada sesion objetivo, cambios, tests, validacion pendiente y
  notas para manual tecnico/usuario.

## Fase 2. Hardening transversal y readiness de produccion

### Objetivo

Endurecer el escritorio para un piloto o produccion controlada sin depender de
criterios provisionales o atajos de desarrollo.

### Alcance objetivo

- revisar login y acceso para eliminar bypass no aceptable en produccion;
- exigir contrasenas para usuarios productivos;
- revisar mensajes, intentos fallidos y sesion actual;
- implantar permisos por roles, no por checklist de permisos por usuario;
- roles iniciales recomendados:
  - `Administrador`;
  - `Tecnico`;
  - `Administrativo`;
  - `Consulta` si aporta valor real;
- posponer overrides por usuario salvo caso justificado;
- disenar e implantar auditoria minima central;
- sustituir autoajustes de schema en runtime por migraciones SQL documentadas
  cuando se detecten;
- definir la linea de configuracion e instalacion para cliente, separada de la
  implementacion tecnica del mecanismo final;
- mantener `maxgesth_port` y `maxgestq_mov` en compatibilidad contractual salvo
  que una decision transversal exija tocar esos repos.

### Eventos minimos de auditoria

- creacion de informe;
- exportacion a tablet;
- importacion desde tablet;
- cierre o firma;
- generacion de PDF;
- impresion;
- reimpresion;
- cambios sensibles de configuracion;
- altas, bajas y cambios de permisos de usuarios.

### Campos minimos de auditoria

- fecha y hora;
- usuario;
- modulo;
- entidad afectada;
- id de entidad;
- accion;
- resultado;
- detalle resumido.

## Fase 3. Gestion: renombrado funcional y saneamiento de maestros

### Objetivo

Sacar al modulo maestro de su estado hibrido actual y dejar una base funcional
clara para operativa diaria, mantenimiento y futura produccion.

### Alcance objetivo

- renombrar visiblemente `Compras` a `Gestion` en menu principal, ventanas y
  textos de usuario;
- mantener nombres tecnicos de paquete, tabla y ruta mientras no haya migracion
  tecnica separada;
- dejar esa dualidad documentada en mantenimiento;
- completar CRUD maestro de equipos de medida como fuente unica comun;
- integrar acceso a equipos de medida desde Gestion y desde los flujos que lo
  consumen;
- revisar duplicidades entre Preventivos y Quirofanos para que la regla de
  negocio quede centralizada;
- ampliar `CECOS` a `Centros` en UI y documentacion funcional, manteniendo la
  tabla tecnica `cecos` por ahora.

### Campos minimos previstos para Centros

- direccion;
- codigo postal;
- ciudad;
- persona de contacto;
- telefono principal;
- telefono alternativo;
- correo electronico;
- contacto de mantenimiento;
- telefono de mantenimiento;
- correo de mantenimiento;
- observaciones si aporta valor operativo.

### Criterio de implementacion

- migracion SQL explicita;
- adaptacion de servicios y formularios;
- revision de dependencias en usuarios, compras, preventivos y PDFs donde se
  muestre o consuma el centro;
- anotacion clara en mantenimiento de que `Centro` es nombre funcional y
  `cecos` sigue siendo nombre tecnico legado.

## Fase 4. Trazabilidad operativa y consolidacion de datos

### Objetivo

Reducir riesgo de inconsistencia, perdida de contexto y estados parciales en
los flujos operativos del escritorio.

### Alcance objetivo

- reutilizar la auditoria central en Preventivos y Quirofanos;
- revisar persistencia y atomicidad en operaciones cabecera-detalle;
- revisar flujos de mayor riesgo:
  - creacion y edicion de informes;
  - cierres;
  - import/export;
  - regeneracion de PDFs;
  - libro de quirofano;
  - operaciones masivas;
- introducir checklist minima de backup, restauracion y recuperacion antes de
  considerar piloto;
- definir politica de rutas runtime y artefactos para cliente final;
- revisar secretos, logos de cliente y material sensible para que no dependan
  del repo como si fueran fuente estable.

## Fase 5. Modulo de informes y analitica futura

### Objetivo

Mantener preparada la arquitectura de analitica sin adelantar una linea de
implementacion prematura.

### Decisiones activas

- `src/Analitico/` se mantiene como destino arquitectonico de solo lectura;
- no se abre ahora una gran linea funcional de analitica en Preventivos ni en
  Quirofanos;
- el acceso futuro seguira embebido en cada dominio, no en un menu principal
  `Analitico`, salvo necesidad real de perfiles directivos o administrativos;
- la primera implementacion de esta linea solo debe arrancar cuando esten
  estables:
  - centros;
  - equipos de medida;
  - roles;
  - auditoria;
  - configuracion de produccion.

## Fase 6. Mantenimiento correctivo de modulos estables

### Preventivos

- solo correcciones derivadas de pruebas reales;
- prioridad baja salvo bloqueo de campo o de produccion.

### Quirofanos

- solo correcciones derivadas de pruebas reales;
- prioridad baja salvo bloqueo de campo o de produccion.

### Android y tablet

- tocar solo por contrato, import/export o incidencias que bloqueen trabajo
  real.

### Cola de triage para incidencias de campo

- `bloqueante`
- `alta`
- `media`
- `mejora`

Solo las incidencias `bloqueante` o `alta` pueden romper la prioridad general
del roadmap.

## Pendientes de informacion

Mantener esta lista viva y revisarla al iniciar cada sesion:

### Configuracion de cliente

- mecanismo final de instalacion y distribucion;
- ubicacion final de credenciales y parametros de conexion;
- si habra asistente inicial o fichero de configuracion gestionado.

### Roles

- matriz exacta de acciones por rol;
- si `Consulta` existe desde el inicio o se difiere.

### Auditoria

- politica de retencion;
- si habra consulta o exportacion de logs desde UI;
- alcance exacto de impresion y reimpresion en todos los modulos.

### Centros

- confirmacion final del conjunto de campos;
- validaciones obligatorias de contacto o formato.

### Informes y analitica

- destinatario real de cada informe;
- diseno y filtros finales;
- prioridad relativa frente a salida a produccion.

### Mobile

- que incidencias de campo escalan a bloqueante y cuales quedan como mejora
  acumulada.

## Politica de pruebas y cierre

Definicion operativa fija:

- una tarea puede quedar implementada o validada sin quedar cerrada;
- `cerrar tarea` implica de forma explicita: tests proporcionados al cambio,
  commit, push y nota de continuidad actualizada;
- si falta cualquiera de esos pasos, el trabajo no debe marcarse como cierre
  completo.

Validacion base de escritorio para sesiones con codigo:

```powershell
python -m compileall main.py src
```

Si se toca autenticacion, permisos, usuarios o maestros:

- compilar modulos tocados;
- probar caso feliz;
- probar denegacion o conflicto;
- verificar persistencia real.

Si se toca auditoria:

- verificar alta de log en exito;
- verificar no dejar inconsistencia en error;
- verificar usuario, entidad y accion correctos.

Si se toca schema:

- validar migracion en entorno de prueba;
- documentar rollback o reversion manual razonable.

Si se toca UI o PDF:

- dejar validacion manual proporcional;
- anotarla en continuidad y en el diario externo.

Ninguna tarea se considera lista para commit si falta cualquiera de estas
cosas:

- resumen claro del cambio;
- tests ejecutados y resultado;
- validacion manual realizada o pendiente;
- confirmacion positiva del usuario para cerrar.

Y ninguna tarea se considera cerrada del todo si falta cualquiera de estas
cosas:

- commit pequeno y coherente;
- `push` de la rama correspondiente;
- actualizacion de `docs/estado_continuidad.md` o del documento vivo que haga
  de nota de continuidad para esa tarea.
