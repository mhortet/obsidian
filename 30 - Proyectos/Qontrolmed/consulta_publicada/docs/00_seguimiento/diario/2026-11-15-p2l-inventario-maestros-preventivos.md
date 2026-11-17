---
title: "Sesión P2L: inventario de maestros de Preventivos"
type: state
status: completed
created: 2026-11-15
updated: 2026-11-15
sources:
  - "../../01_gobierno_y_decisiones/DECISION-CONSERVAR-MAESTROS-PREVENTIVOS-SIN-HISTORICO-2026-11-15.md"
  - "../../02_planes_y_arquitectura/PLAN-EJECUCION-P2L-INVENTARIO-MAESTROS-PREVENTIVOS-2026-11-15.md"
tags: [qontrolmed, sesion, p2l, preventivos, maestros]
review_after: 2026-11-22
---

# Sesión 2026-11-15: inventario de maestros de Preventivos
[[masgesth]]

## Objetivo y motivo

Registrar la aclaración del propietario: se conservan los maestros preparados
en la base local y se descartan únicamente revisiones y actividad de prueba.

## Punto seguro y límites

- Base Git inicial: `5d70b87`, rama limpia y sincronizada.
- Sin cambios en `.env`, MySQL, servidor ni datos.
- Inventario limitado a metadatos, recuentos y anomalías agregadas.

## Pasos, comandos y aprendizaje

### 1. Contraste con la aplicación

Se revisaron las pantallas de tipologías, plantillas, puntos y relaciones, y el
exportador tablet existente.

- **Observado**: la aplicación permite que usuarios autorizados mantengan los
  cuatro maestros.
- **Límite**: el exportador tablet mezcla equipos, campañas y maestros y puede
  actualizar seguimiento; no es apto para esta migración.

### 2. Utilidad específica de solo lectura

Se creó `scripts/db/inventariar_maestros_preventivos.py`. Utiliza una
transacción `READ ONLY`, devuelve solo agregados, ejecuta `rollback` y cierra la
conexión. La excepción local solo admite `127.0.0.1` y no modifica `.env`.

### 3. Intentos controlados de inventario

- La configuración ordinaria se detuvo antes de conectar porque exige CA TLS.
- La excepción loopback rechazó correctamente el host remoto configurado.
- Se comprobó que el servicio local MySQL 8.4 está activo.
- Al forzar explícitamente loopback, la cuenta configurada no fue aceptada por
  la instancia local.
- Windows no permitió listar el directorio de datos ni siquiera mediante la
  ejecución elevada disponible.

En un primer momento no se realizaron consultas de inventario ni se modificó
la base por falta de una cuenta local adecuada.

### 4. Acceso local mínimo e inventario agregado

Con confirmación expresa del propietario se creó desde MySQL Workbench la
cuenta local `qontrolmed_inventory@localhost`, limitada a `SELECT` sobre
`preventivos.*`. La contraseña fue introducida directamente por el propietario
y no se incorporó al repositorio ni a la evidencia.

Después se ejecutó una única consulta agregada. Se observaron 8 tipos de
equipo, 7 plantillas, 390 puntos de control y 160 relaciones plantilla-punto.
Las cinco comprobaciones de huérfanos o duplicados devolvieron cero.

Las tablas operativas conservan 144 equipos, 1 campaña, 144 asignaciones, 12
informes, 396 resultados y 7 relaciones con equipos de medida. Estos datos
demuestran que existe histórico local y confirman que no debe copiarse al
destino nuevo.

## Cambios cerrados

- Decisión de conservación de maestros registrada.
- P2K y su runbook corregidos.
- Plan P2L y utilidad de inventario creados.
- Errores de autenticación futuros depurados para no mostrar detalles.
- Cuenta local de inventario creada con privilegio exclusivo de lectura.
- Inventario agregado completado y evidencia depurada registrada.

## Validaciones realizadas

- Suite completa: 92 pruebas correctas.
- Manifiesto: formato 1 y dos migraciones válidas.
- Bandit: cero hallazgos medios o altos.
- Compilación de la utilidad: correcta.
- `git diff --check`: correcto; solo avisos informativos LF/CRLF.
- Publicación curada: siete documentos copiados de 62 seleccionados; la
  comprobación posterior quedó sin pendientes.

## Observado, inferido y decidido

### Observado

- MySQL 8.4 local está en ejecución.
- Las credenciales del destino remoto no autentican en la instancia local.
- Los cuatro maestros locales contienen datos y sus relaciones agregadas no
  presentan las anomalías comprobadas.
- Las seis tablas operativas contienen actividad histórica.

### Inferido

- Los maestros son una base válida para preparar un libro de revisión, aunque
  su contenido todavía debe revisarse funcionalmente antes de importarlo.

### Decidido

- No intentar recuperar ni cambiar contraseñas.
- Migrar únicamente las cuatro tablas maestras y excluir todo el histórico.

## Riesgos y pendientes

- Todavía no existe el libro Excel para revisión ni un procedimiento aprobado
  de importación en la base definitiva.

## Siguiente paso recomendado

- Abrir un bloque independiente para generar un libro Excel revisable de los
  cuatro maestros, sin incluir las seis tablas operativas.
