---
title: "Plan de adaptación documental de maxgesth al modelo de Servidor"
type: plan
status: active
created: 2026-11-10
updated: 2026-11-10
sources:
  - "docs/90_archivo/documentacion_sustituida/mapa_documental_proyecto_2026-07.md"
  - "docs/90_archivo/documentacion_sustituida/estado_continuidad_2026-07.md"
  - "docs/03_operacion_y_runbooks/security_delivery_playbook.md"
  - "H:/02.Trabajo/obsidian/30 - Proyectos/Servidor_MM/Servidor/README.md"
  - "H:/02.Trabajo/obsidian/30 - Proyectos/Servidor_MM/Servidor/07_recursos/plantillas/PLANTILLA-ESTRUCTURA-Y-RUTINA-DE-PROYECTO.md"
tags: [qontrolmed, documentacion, gobierno, continuidad]
review_after: 2026-11-24
---

# Plan de adaptación documental de maxgesth al modelo de Servidor

## 1. Objetivo

Adaptar `maxgesth` al sistema de trabajo probado en `Servidor_MM` para que una sesión pueda comenzar con tres puntos de entrada claros, distinguir estado, decisión, plan, operación y evidencia, y conservar el histórico sin que compita con la información vigente.

La adaptación debe respetar la naturaleza de un repositorio de software. No se propone copiar literalmente la estructura de un proyecto de infraestructura ni mover de forma artificial código, tests, SQL o automatizaciones dentro de carpetas documentales.

## 2. Conclusión de la auditoría estructural

El proyecto tiene mucha documentación útil, pero su organización actual presenta cinco problemas:

1. La raíz no contiene `AGENTS.md`, `README.md` ni `CONTINUAR-SIGUIENTE-SESION.md`.
2. La documentación viva se reparte entre varios documentos extensos y algunos están fechados en julio, mientras que decisiones de noviembre viven en `Servidor_MM`.
3. Coexisten `historico_doc/`, `proyectos/historico_doc/`, `docs/diario_sesiones/` y un diario externo, sin una única regla visible desde la raíz.
4. Evidencia, salida runtime, fuentes y binarios aparecen mezclados o duplicados en el árbol de trabajo y, en algunos casos, en Git.
5. La estructura física y el mapa documental no reflejan con claridad el ciclo propuesta → aprobación → ejecución → evidencia → estado → relevo.

La adaptación es recomendable, pero debe hacerse gradualmente. Una reorganización masiva inmediata rompería enlaces, aumentaría el diff y podría mezclar los cambios locales del usuario con el plan de producción.

## 3. Principios de adaptación

1. **Tres entradas de raíz**: reglas, mapa y relevo.
2. **Una fuente de verdad por función**: no mantener dos roadmaps o estados vivos equivalentes.
3. **Separar hechos, interpretación y decisión**.
4. **Fechar lo que caduca** y asignar revisión.
5. **No mover código por razones documentales**.
6. **No conservar evidencia pesada o sensible dentro de Git**; registrar resumen, hash y ubicación protegida.
7. **Archivar, no borrar**, hasta verificar enlaces y valor histórico.
8. **No tocar cambios locales ajenos** sin conciliarlos primero.
9. **No introducir datos de pacientes ni secretos**; nombres, correos, registros y datos de acceso son información protegida.
10. **Cada cambio técnico debe tener propósito, riesgo, aceptación y reversión**.

## 4. Traducción del modelo Servidor a un repositorio de software

| Modelo Servidor | Adaptación recomendada en maxgesth |
| --- | --- |
| `AGENTS.md` | Reglas persistentes de alcance, seguridad, datos, autorizaciones, Git y producción |
| `README.md` | Mapa estable del producto, módulos, repos relacionados, entradas vivas, build y estado resumido |
| `CONTINUAR-SIGUIENTE-SESION.md` | Punto seguro, bloque activo, cambios locales, pruebas pendientes y siguiente acción |
| Documento maestro | `DOCUMENTACION-QONTROLMED.md`, creado solo tras reconciliar el entregable integral existente |
| `00_seguimiento/` | Estado, diario y registros de release dentro de `docs/00_seguimiento/` |
| `01_gobierno_y_decisiones/` | Alcance, decisiones, roles de proyecto, clasificación de datos y ADR sencillos |
| `02_planes_y_arquitectura/` | Roadmap, planes propuestos, arquitectura y especificaciones actualmente dispersas |
| `03_operacion_y_runbooks/` | Instalación, configuración, migración, backup, restauración, soporte y rollback |
| `04_guias_didacticas/` | Manuales explicativos para administradores, técnicos y usuarios |
| `05_evidencias/` | Resúmenes depurados, manifiestos, hashes y referencias; no datos reales ni logs masivos |
| `06_herramientas/` | Se mapea a las carpetas técnicas existentes `scripts/`, `bd/` y `.github/`; no se duplica |
| `07_recursos/` | Plantillas documentales y material reutilizable |
| `90_archivo/` | Documentación sustituida, snapshots y relevos previos |

## 5. Estructura objetivo recomendada

```text
maxgesth/
├── AGENTS.md
├── README.md
├── CONTINUAR-SIGUIENTE-SESION.md
├── DOCUMENTACION-QONTROLMED.md          # después de consolidar el entregable existente
├── .github/
├── bd/
├── scripts/
├── src/
├── tests/
├── docs/
│   ├── 00_seguimiento/
│   │   ├── estados/
│   │   ├── diario/
│   │   └── releases/
│   ├── 01_gobierno_y_decisiones/
│   ├── 02_planes_y_arquitectura/
│   │   └── especificaciones/
│   ├── 03_operacion_y_runbooks/
│   ├── 04_guias_didacticas/
│   ├── 05_evidencias/
│   │   ├── auditorias/
│   │   └── manifiestos/
│   ├── 07_recursos/
│   │   └── plantillas/
│   └── 90_archivo/
├── pdf_assets/                          # recursos fuente aprobados
```

No deben existir en la estructura versionada final:

- `_internal/` generado;
- `build/`, `dist/`, `build_rc/` o `dist_rc/`;
- `output/` o exports runtime;
- `.env` reales;
- certificados reales de equipos o CA de sede;
- logs con usuarios, IP, correos o datos del cliente;
- copias de bases de datos;
- instaladores o ZIP sin una política explícita de release.

## 6. Función de los puntos de entrada

### 6.1. `AGENTS.md`

Contenido mínimo:

- objetivo y alcance funcional congelado;
- exclusión de datos de pacientes y datos clínicos;
- tratamiento de datos personales y secretos;
- repositorios relacionados;
- política de ramas, commits, tests y releases;
- condiciones para tocar base de datos, migraciones, servidor o datos reales;
- autorización por plan;
- reglas de reversión y preservación de evidencia;
- definición de terminado.

No debe contener una foto extensa del estado: las reglas cambian menos que el relevo.

### 6.2. `README.md`

Contenido mínimo:

- descripción de Qontrolmed;
- módulos incluidos y diferidos;
- arquitectura de alto nivel;
- instalación solo en forma de enlace al runbook;
- estructura del repositorio;
- documentos vivos y orden de lectura;
- estado resumido y fecha;
- referencias a repos móviles y `Servidor_MM`;
- cómo ejecutar tests sin secretos;
- política de contribución y release.

### 6.3. `CONTINUAR-SIGUIENTE-SESION.md`

Debe ser breve y sustituible:

- commit/rama de partida;
- cambios locales a preservar;
- último punto seguro;
- bloque autorizado y bloque no autorizado;
- pruebas realizadas y pendientes;
- riesgos o decisiones abiertas;
- orden exacto de lectura;
- siguiente acción segura;
- comandos de revalidación no destructivos.

Cada relevo sustituido se mueve a `docs/90_archivo/handoffs/`.

### 6.4. `DOCUMENTACION-QONTROLMED.md`

Debe ser el documento maestro de entrega y mantenimiento, no un segundo roadmap. Conviene crearlo mediante consolidación de `docs/documentacion_integral_proyecto_entregable.md` después de revisar alcance, rutas y decisiones obsoletas.

Contenido:

- alcance de producto;
- arquitectura desplegada;
- requisitos y dependencias;
- instalación y configuración mediante enlaces a runbooks;
- operación, copias, recuperación y soporte;
- matriz de versiones y release vigente;
- limitaciones conocidas;
- historial de cambios del documento.

## 7. Clasificación propuesta del contenido actual

Esta tabla es una propuesta de destino. Debe validarse antes de mover archivos.

| Contenido actual | Clasificación recomendada |
| --- | --- |
| `docs/estado_continuidad.md` | Sustituir por estado fechado en `docs/00_seguimiento/estados/` y relevo de raíz |
| `docs/diario_sesiones/` | `docs/00_seguimiento/diario/` |
| `docs/plan_seguridad_consistencia.md` | `docs/02_planes_y_arquitectura/PLAN-MAESTRO-PRODUCCION-<fecha>.md` o integrar el nuevo plan |
| `docs/security_delivery_playbook.md` | Repartir reglas persistentes a `AGENTS.md` y operación de sesión a `docs/03_operacion_y_runbooks/` |
| `docs/mapa_documental_proyecto.md` | Absorber en `README.md`; archivar el original tras verificar enlaces |
| `docs/backlog_evolutivo.md` | `docs/00_seguimiento/backlog/` o mantener en raíz de seguimiento, claramente fuera del roadmap aprobado |
| `docs/roles_operativos_acceso.md` | Gobierno si define decisiones; runbook si describe operación; dividir si mezcla ambas |
| `docs/politica_datos_iniciales_piloto.md` | `docs/01_gobierno_y_decisiones/` |
| `docs/migraciones_operativas_hardening.md` | `docs/03_operacion_y_runbooks/` |
| `docs/checklist_configuracion_preproduccion.md` | `docs/03_operacion_y_runbooks/` |
| `docs/guia_instalacion_rc_qontrolmed.md` | `docs/03_operacion_y_runbooks/` |
| `docs/Manual/` | `docs/04_guias_didacticas/Manual/` |
| `specifications/` | `docs/02_planes_y_arquitectura/especificaciones/`, solo tras actualizar imports/enlaces documentales |
| `historico_doc/` y `proyectos/historico_doc/` | Consolidar gradualmente en `docs/90_archivo/` con índice de procedencia |
| `docs/fixtures/` | Mover a `tests/fixtures/` si son datos de test; mantener únicamente material sintético |
| resultados de CI y auditoría | Resumen en `docs/05_evidencias/`; el log completo permanece en GitHub Actions o almacén protegido |
| `scripts/`, `bd/`, `.github/` | Permanecen en raíz como herramientas operativas y fuente técnica |

## 8. Metadatos y convenciones

Los documentos activos deberían usar front matter mínimo:

```yaml
---
title: "Título legible"
type: plan | decision | state | process | guide | evidence
status: proposed | approved | active | completed | superseded | blocked
created: AAAA-MM-DD
updated: AAAA-MM-DD
sources: []
tags: []
review_after: AAAA-MM-DD
---
```

Convenciones:

- Estado: `ESTADO-<TEMA>-AAAA-MM-DD.md`.
- Decisión: `DECISION-<TEMA>-AAAA-MM-DD.md`.
- Plan: `PLAN-<TEMA>-AAAA-MM-DD.md`.
- Runbook: `RUNBOOK-<TEMA>-AAAA-MM-DD.md` cuando sea específico de versión; sin fecha si es realmente vivo.
- Diario: `AAAA-MM-DD-<resumen>.md`.
- Release: `RELEASE-<VERSION>-AAAA-MM-DD.md`.
- Evidencia: nombre descriptivo, fecha, hash y clasificación de sensibilidad.
- Evitar `final`, `definitivo`, `nuevo`, `copia` o `v2` sin contexto.

Los enlaces deben ser relativos dentro del repositorio. Las rutas externas deben identificarse como dependencias, no como documentos disponibles universalmente.

## 9. Plan de adaptación por fases

### Fase D0. Preservación y mapa de origen — 2 a 3 horas

**Objetivo**: impedir pérdida o mezcla de trabajo.

1. Registrar `git status`, commit base y cambios locales.
2. Copiar solo el inventario, no los contenidos, a una matriz origen → tipo → vigencia → destino.
3. Marcar cada documento como vivo, histórico, evidencia, duplicado o por revisar.
4. Identificar enlaces entrantes antes de mover nada.
5. Acordar si el diario externo seguirá existiendo o se integrará.

**Aceptación**:

- todos los cambios locales están identificados;
- ningún archivo se mueve;
- existe una propuesta revisable de clasificación.

### Fase D1. Puntos de entrada sin mudanza — 3 a 5 horas

**Objetivo**: obtener el beneficio operativo principal con el mínimo riesgo.

1. Crear `AGENTS.md`.
2. Crear `README.md` enlazando las ubicaciones actuales.
3. Crear `CONTINUAR-SIGUIENTE-SESION.md` con el punto seguro real.
4. Registrar esta auditoría como plan propuesto.
5. Añadir avisos de documento sustituido donde existan competidores claros, sin mover todavía.

**Aceptación**:

- una nueva sesión comienza leyendo tres archivos;
- ninguna ruta histórica se rompe;
- propuesta, aprobación y estado están diferenciados.

### Fase D2. Gobierno, planes y operación — 4 a 8 horas

**Objetivo**: reclasificar primero lo que condiciona producción.

Orden:

1. `00_seguimiento/estados` y `00_seguimiento/diario`.
2. `01_gobierno_y_decisiones`.
3. `02_planes_y_arquitectura`.
4. `03_operacion_y_runbooks`.
5. Actualización de enlaces y validación de referencias.

No se deben mover simultáneamente fuentes de código, fixtures y documentación.

**Aceptación**:

- existe una fuente viva por función;
- los planes propuestos no se leen como aprobados;
- los runbooks contienen precondiciones, aceptación y reversión;
- no hay enlaces rotos en los puntos de entrada.

### Fase D3. Guías, evidencia y archivo — 4 a 8 horas

**Objetivo**: separar material reutilizable, prueba original e histórico.

1. Mover manuales y guías didácticas.
2. Crear política de evidencia:
   - clasificación;
   - depuración de secretos/datos personales;
   - ubicación del original;
   - hash;
   - retención;
   - acceso.
3. Consolidar `historico_doc/` y `proyectos/historico_doc/` gradualmente.
4. Crear índice en `docs/90_archivo/README.md` con procedencia y motivo de archivo.
5. Archivar relevos sustituidos.

**Aceptación**:

- el histórico no compite con el vigente;
- no se incorporan logs masivos, bases, secretos ni datos reales;
- cada evidencia tiene contexto suficiente para interpretarse.

### Fase D4. Documento maestro y rutina de mantenimiento — 4 a 6 horas

**Objetivo**: cerrar el modelo y evitar que vuelva a degradarse.

1. Revisar `documentacion_integral_proyecto_entregable.md`.
2. Crear o renombrar `DOCUMENTACION-QONTROLMED.md` sin duplicar roadmap ni runbooks.
3. Añadir historial de cambios y release vigente.
4. Definir rutina de apertura/cierre de sesión.
5. Añadir comprobación automática de enlaces Markdown, metadatos y nombres.
6. Incorporar checklist documental a pull requests.

**Aceptación**:

- un tercero puede continuar desde el relevo;
- el documento maestro describe la entrega vigente;
- el roadmap, el estado y la operación tienen propietarios documentales distintos;
- CI detecta enlaces o metadatos inválidos.

## 10. Hoja de ruta conjunta recomendada

| Orden | Bloque | Esfuerzo estimado | Motivo |
| --- | --- | --- | --- |
| 1 | P0 + D0 | 4-6 h | Preservar estado y fijar una línea base común |
| 2 | D1 | 3-5 h | Crear gobierno y relevo antes de cambios técnicos |
| 3 | P1 | 2-4 jornadas | Resolver vulnerabilidades, TLS, CA y CI engañosa |
| 4 | P2 + P3 | 5-9 jornadas | Cerrar datos, migraciones, copias, pruebas y señales |
| 5 | D2 | 4-8 h | Reordenar fuentes vivas ya reconciliadas |
| 6 | P4 | 1-2 jornadas | Limpiar supply chain y repositorio |
| 7 | D3 | 4-8 h | Separar evidencia e histórico sin distraer el cierre crítico |
| 8 | P5 | 2-3 jornadas | Construir y validar una RC candidata |
| 9 | D4 | 4-6 h | Cerrar documento maestro y release vigente |
| 10 | P6 | 1-3 jornadas + ventana | Preparar sede y aceptación |
| 11 | P7 | 2-4 semanas | Piloto controlado y decisión posterior |

Duración técnica orientativa previa al piloto: **12 a 20 jornadas**, dependiendo del alcance real de pruebas, migraciones y arquitectura de ficheros. La espera de decisiones del cliente puede ampliar el calendario, pero no debe impedir P0, D0, D1 ni buena parte de P1-P4.

## 11. Riesgos de la reorganización y mitigación

| Riesgo | Mitigación |
| --- | --- |
| Perder cambios locales | Inventario y rama/worktree antes de mover |
| Romper enlaces | Mapa de enlaces, movimientos pequeños y comprobación automática |
| Mezclar histórico con vigente | Metadatos `status`, índices y avisos de sustitución |
| Duplicar herramientas | Mantener `scripts/`, `bd/` y `.github/` como ubicaciones técnicas únicas |
| Versionar evidencia sensible | Política de evidencia, depuración, hashes y almacén externo protegido |
| Convertir el plan en autorización | Mantener `status: proposed` hasta aprobación explícita |
| Hacer un diff inmanejable | Una fase por commit/PR; no mezclar reorganización con cambios funcionales |
| Ocultar trazabilidad con renombres | Conservar índice de procedencia y usar `git mv` solo tras aprobar |

## 12. Reversión

Cada fase documental debe ejecutarse en una rama separada.

Si una fase no cumple aceptación:

1. no fusionar la rama;
2. conservar el inventario y el diff;
3. restaurar únicamente los enlaces o movimientos de esa fase;
4. no borrar originales hasta comprobar que el nuevo destino es completo;
5. registrar el motivo y ajustar el mapa antes de reintentar.

No se recomienda reescribir la historia de Git como parte de esta adaptación.

## 13. Estado de ejecución a 10 de noviembre de 2026

El propietario autorizó una reorganización profunda al disponer de copia de
seguridad completa. Se ejecutaron D0-D3 en una rama aislada, con estas
salvedades:

- se preservaron e integraron los cambios locales del backlog;
- se crearon `AGENTS.md`, `README.md` y
  `CONTINUAR-SIGUIENTE-SESION.md`;
- la documentación activa se reclasificó por función;
- `historico_doc/` y `proyectos/historico_doc/` se consolidaron en
  `docs/90_archivo/` con índice de procedencia;
- tras confirmación expresa se eliminaron aproximadamente 3,26 GiB de builds,
  distribuciones, runtime versionado, exports, certificados locales, binarios
  legados y caches; los últimos residuos requirieron consola elevada por sus
  ACL y la limpieza física quedó completada;
- D4 queda pendiente: el documento maestro se creará después de reconciliar el
  entregable histórico con la arquitectura que finalmente llegue a producción.

La estructura documental ya no necesita esperar a P1. El siguiente bloque
técnico es P0 del plan asociado, una vez revisado el diff y resuelta la purga
controlada.

Plan técnico asociado:
[AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md](AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md).
