---
title: "Plantilla de estructura y rutina para proyectos"
type: process
status: active
created: 2026-11-01
updated: 2026-11-01
sources:
  - "README.md"
tags: [plantilla, documentacion, gobierno, arquitectura]
review_after: 2027-05-01
---

# Plantilla de estructura y rutina para proyectos

## Estructura base

```text
Proyecto/
├── AGENTS.md
├── README.md
├── CONTINUAR-SIGUIENTE-SESION.md
├── 00_seguimiento/
│   ├── estados/
│   └── diario/
├── 01_gobierno_y_decisiones/
├── 02_planes_y_arquitectura/
├── 03_operacion_y_runbooks/
├── 04_guias_didacticas/
├── 05_evidencias/
│   ├── auditorias/
│   └── imagenes/
├── 06_herramientas/
│   ├── scripts/
│   └── configuracion/
├── 07_recursos/
│   └── plantillas/
└── 90_archivo/
```

No es obligatorio crear todas las carpetas el primer día. Se crean cuando exista contenido real, manteniendo siempre los tres puntos de entrada de la raíz.

## Función de los archivos de raíz

### `AGENTS.md`

Reglas persistentes: alcance, seguridad, privacidad, autorizaciones y forma de trabajar.

### `README.md`

Mapa estable: objetivo, estructura, enlaces principales, estado resumido y rutina.

### `CONTINUAR-SIGUIENTE-SESION.md`

Estado efímero: último punto seguro, pendientes inmediatos, comandos de revalidación y prompt de reanudación. Se sustituye al cerrar cada sesión importante y el anterior se archiva.

## Qué documento crear

| Necesidad | Destino |
| --- | --- |
| Estado técnico vigente | `00_seguimiento/estados/` |
| Relato cronológico de una sesión | `00_seguimiento/diario/` |
| Decisión y sus alternativas | `01_gobierno_y_decisiones/` |
| Diseño o plan no ejecutado | `02_planes_y_arquitectura/` |
| Procedimiento para operar/recuperar | `03_operacion_y_runbooks/` |
| Explicación para aprender y reutilizar | `04_guias_didacticas/` |
| Salida original, log o captura | `05_evidencias/` |
| Script o configuración reutilizable | `06_herramientas/` |
| Plantilla o apoyo | `07_recursos/` |
| Material sustituido | `90_archivo/` |

## Convenciones de nombres

- Fechas: `AAAA-MM-DD`.
- Estado: `ESTADO-<TEMA>-AAAA-MM-DD.md`.
- Decisión: `DECISION-<TEMA>-AAAA-MM-DD.md`.
- Plan: `PLAN-<TEMA>-AAAA-MM-DD.md`.
- Guía: `GUIA-DIDACTICA-<TEMA>-AAAA-MM-DD.md`.
- Diario: `AAAA-MM-DD-<resumen>.md`.
- Evidencia: nombre descriptivo y fecha; conservar hash cuando sea relevante.
- Evitar `final`, `final2`, `nuevo` o `copia`; usar estado y fecha.

## Rutina al iniciar un proyecto

1. Crear `AGENTS.md` con alcance, límites y datos sensibles.
2. Crear `README.md` con objetivo, responsables, aceptación y estructura.
3. Registrar el estado inicial, aunque sea mínimo.
4. Crear el primer relevo con la siguiente acción segura.
5. Separar desde el inicio planes, evidencia y operación.
6. Definir qué cambios requieren aprobación y cómo se revierten.

## Rutina al iniciar una sesión

1. Leer `AGENTS.md`, `README.md` y el relevo.
2. Revalidar en solo lectura lo que pueda haber cambiado.
3. Comparar evidencia actual con estado documentado.
4. Identificar el cambio mínimo útil.
5. Presentar propósito, riesgo, aceptación y reversión.
6. Obtener aprobación cuando cambie sistemas o datos.

## Rutina al cerrar una sesión

1. Verificar el estado final desde más de un punto cuando sea posible.
2. Crear o actualizar el estado técnico.
3. Añadir una entrada de diario.
4. Actualizar decisiones y pendientes.
5. Sustituir el relevo y archivar el anterior.
6. Incorporar evidencia sin mezclarla con interpretación.
7. Actualizar el mapa del proyecto si cambia la estructura.
8. Ejecutar lint y control de tags si forma parte de una bóveda Obsidian.

## Plantilla de cambio controlado

```markdown
## Cambio propuesto

### Propósito

Qué problema resuelve y por qué ahora.

### Alcance

Archivos, servicios, equipos y personas afectados.

### Riesgo

Qué puede fallar y cuál sería el impacto.

### Prueba de aceptación

Resultados observables que demuestran que el cambio funciona.

### Reversión

Cómo volver al estado anterior, quién puede hacerlo y qué evidencia conservar.

### Aprobación

Responsable, fecha y alcance exacto autorizado.
```

## Criterios de calidad

- La fuente de verdad está identificada.
- Los hechos se distinguen de inferencias y propuestas.
- Lo temporal lleva fecha y revisión.
- Los secretos y datos personales se minimizan.
- Las capturas no sustituyen una conclusión escrita.
- Un tercero puede continuar leyendo solo el relevo y los enlaces principales.
- Los documentos antiguos se conservan en archivo, no compiten con el vigente.
