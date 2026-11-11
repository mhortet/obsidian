# Backlog evolutivo de versiones futuras

Fecha de creación: 2026-07-18

Última revisión: 2026-07-18
Estado: bandeja de entrada; sin compromiso de alcance ni calendario

## Finalidad

Este documento es la fuente viva única para reunir ideas, mejoras y deuda
técnica que puedan estudiarse después de consolidar en producción la versión
del piloto.

Una entrada en este documento **no significa que vaya a formar parte de la
próxima versión**. Primero deberá contrastarse con el uso real, concretarse y
priorizarse. Los defectos que bloqueen o comprometan la operación actual se
gestionan en los documentos del piloto, no aquí.

## Cómo utilizarlo

- Añadir las observaciones nuevas en `Bandeja de entrada`, aunque todavía sean
  imprecisas.
- Asignar un identificador correlativo `EV-YYYY-NNN` y conservarlo durante toda
  la vida de la entrada.
- Registrar el problema o la oportunidad, no una solución cerrada salvo que ya
  exista evidencia suficiente.
- Mantener el estado en `idea` hasta revisarla con experiencia de producción.
- Al madurar una entrada, completar alcance, criterios de aceptación,
  dependencias, riesgos y pruebas antes de pasarla a `candidata`.
- Al decidir una versión, mover solo las entradas aprobadas a un plan de
  versión específico y dejar aquí referencia a dicho plan.
- No duplicar incidencias de campo: si proceden de uso real, conservar también
  su identificador de `docs/05_evidencias/campo/cola_triaje_campo.md`.

Estados admitidos: `idea`, `en análisis`, `candidata`, `planificada`,
`descartada` y `trasladada`.

Prioridad orientativa: `sin valorar`, `baja`, `media`, `alta`. La prioridad no
equivale a urgencia para la versión actualmente en producción.

## Bandeja de entrada

| ID | Área | Anotación | Origen | Prioridad | Estado |
| --- | --- | --- | --- | --- | --- |
| EV-2026-001 | Navegación / Gestión | Cambiar el botón `Equipos de medida` del menú de Quirófanos al menú de Gestión. Revisar permisos, rutas de apertura y retorno para que siga funcionando como maestro común. | Observación 2026-07-18; antecedente en diario 2026-06-08 | baja | idea |
| EV-2026-002 | Preventivos escritorio | Mantener filtro y orden después de actualizar puntos de control. | `PTC-2026-06-10-03` | sin valorar | idea |
| EV-2026-003 | Preventivos móvil | Ajustar la identidad de la entrada a `Qontrolmed móvil`, con segunda línea `Preventivos`, y valorar un icono visible. | `PTC-2026-06-09-01` | baja | idea |
| EV-2026-004 | Preventivos móvil y escritorio | Estudiar exportación por lotes que evite reenviar informes ya importados. Solo reabrir con necesidad operativa confirmada y contrato anti-duplicados definido. | `PTC-2026-06-10-04`; decisión 2026-07-14 | sin valorar | idea |
| EV-2026-005 | UI transversal | Evitar que puedan abrirse simultáneamente varias instancias de una misma ventana. | Diario 2026-06-13 | sin valorar | idea |
| EV-2026-006 | Seguridad | Valorar avisos configurables por correo, inicialmente para series repetidas de intentos fallidos de acceso. | Diario 2026-06-14 | sin valorar | idea |
| EV-2026-007 | Seguridad | Valorar persistencia del bloqueo por intentos fallidos entre reinicios si la experiencia del piloto lo requiere. | Diario 2026-06-14 | sin valorar | idea |
| EV-2026-008 | Compras | Recuperar y completar el módulo de Compras operativo, incluidos sus informes y la conexión de la UI de importación PDF ya iniciada. | Plan de seguridad, fase 7; documentación técnica histórica | sin valorar | idea |
| EV-2026-009 | Analítica | Desarrollar analítica ampliada, informes directivos o cuadros de mando; valorar un menú principal `Analítico` para perfiles administrativos o de dirección. | Plan de seguridad, fase 7; especificación de analítica | sin valorar | idea |
| EV-2026-010 | Arquitectura | Separar persistencia, reglas de normalización y mensajes de UI actualmente concentrados en `Comunicacion`. | Documentación técnica histórica | sin valorar | idea |
| EV-2026-011 | Quirofanos / conexión | Revisar el cierre de conexión al salir de Quirófanos para evitar que el retorno a Compras pueda quedar sin conexión. | Documentación técnica histórica | sin valorar | idea |
| EV-2026-012 | PDF / Quirofanos | Depurar código antiguo o duplicado en `pdf_service.py` y en la generación del libro de quirófano, con pruebas de regresión previas. | Documentación técnica histórica | sin valorar | idea |
| EV-2026-013 | Datos | Fijar nombres canónicos mediante migraciones y reducir la compatibilidad indefinida con variantes históricas del esquema. | Documentación técnica histórica | sin valorar | idea |
| EV-2026-014 | Arquitectura / datos | Centralizar validaciones de fechas y decimales y aplicar transacción única a operaciones compuestas. | Documentación técnica histórica | sin valorar | idea |
| EV-2026-015 | Calidad técnica | Normalizar código y textos a UTF-8 y mantener cachés y salidas generadas fuera de las carpetas de código y del versionado. | Documentación técnica histórica; diario 2026-06-15 | sin valorar | idea |
| EV-2026-016 | Pruebas | Ampliar pruebas automatizadas de servicios puros de Compras, dashboard, históricos Excel e informes. | Documentación técnica histórica | sin valorar | idea |

## Líneas de producto diferidas

Estas líneas tienen documentación propia y un alcance superior al de una nota
individual. Permanecen como referencias, no como tareas aprobadas:

- Compras e informes: quedan fuera del alcance productivo inicial según el plan
  de producción vigente.
- Analítica y campañas:
  `docs/02_planes_y_arquitectura/especificaciones/modulo_analitico_y_campanas_preventivo.md`.
- Criterios técnicos aplicables a cualquier evolución:
  `docs/02_planes_y_arquitectura/especificaciones/criterios_transversales_capas.md`.

## Plantilla para nuevas entradas

Copiar una fila en la bandeja y completar, como mínimo:

```text
| EV-YYYY-NNN | Área | Problema, oportunidad o idea | Fecha/persona/documento | sin valorar | idea |
```

Cuando una idea pase a `en análisis`, añadir debajo una ficha con:

```text
### EV-YYYY-NNN — Título breve

- Necesidad observada:
- Usuarios afectados:
- Alcance propuesto:
- Fuera de alcance:
- Dependencias y riesgos:
- Criterios de aceptación:
- Pruebas necesarias:
- Decisión y fecha:
```

## Historial de decisiones

| Fecha | Decisión |
| --- | --- |
| 2026-07-18 | Se crea el backlog evolutivo y se consolidan las anotaciones futuras localizadas en la documentación existente. Ninguna entrada queda comprometida para una versión concreta. |
