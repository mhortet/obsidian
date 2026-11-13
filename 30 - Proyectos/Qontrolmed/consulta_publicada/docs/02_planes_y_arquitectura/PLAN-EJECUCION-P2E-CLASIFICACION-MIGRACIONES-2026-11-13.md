---
title: "Plan P2E: clasificación y promoción gradual de migraciones"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "CONTINUAR-SIGUIENTE-SESION.md"
  - "docs/05_evidencias/auditorias/INVENTARIO-ESQUEMAS-Y-MIGRACIONES-P2-2026-11-11.md"
  - "bd/migraciones/manifest.json"
tags: [qontrolmed, p2, migraciones, clasificacion, piloto]
review_after: 2026-11-20
---

# Plan P2E: clasificación y promoción gradual de migraciones

## 1. Objetivo

Clasificar las diez migraciones que permanecen fuera del manifiesto P2A y
definir un orden de promoción individual, proporcional al piloto privado. P2E
no convierte automáticamente ningún SQL histórico en migración soportada.

## 2. Alcance y límites

Incluye lectura estática de SQL, código consumidor y documentación; decisión
de necesidad, dependencias, riesgo y siguiente candidata; actualización del
inventario, diario y relevo.

No incluye modificar los SQL históricos ni el manifiesto, ejecutar SQL, abrir
`.env`, conectar a MySQL, encender el servidor, usar datos reales, construir
una RC ni declarar GO para piloto.

## 3. Criterios y categorías

Se evalúan necesidad para el alcance, consumo por el código, dependencias,
riesgo DDL/DML, precheck, postcheck, recuperación y prueba sintética. Las
categorías son: **promover siguiente**, **promover después**, **diferir** y
**legada/no promover**.

## 4. Secuencia ejecutada

1. Revalidar rama, árbol y relevos coordinados.
2. Contrastar las diez migraciones con código y estructuras vigentes.
3. Documentar la matriz con observaciones e inferencias separadas.
4. Elegir una sola candidata para el siguiente bloque.
5. Validar documentación, pruebas locales y publicación curada.

## 5. Aceptación

- Las diez migraciones excluidas tienen categoría y justificación.
- Se declara un orden por dependencias sin asumir orden alfabético.
- Existe una única candidata siguiente y un bloque de promoción acotado.
- El manifiesto continúa válido e inalterado.
- No se ejecuta SQL ni se modifica infraestructura.

## 6. Reversión

P2E solo cambia documentación. La reversión consiste en revertir sus cambios
documentales. Cualquier promoción posterior tendrá plan, pruebas y reversión
propios.

## 7. Resultado

Plan completado el 13/11/2026. La candidata siguiente es
`migracion_certificados_equipos_medida.sql`; su promoción no forma parte de
P2E y requerirá endurecer el SQL, registrar `quirofanos-0002` y validar tanto
aceptación como rechazo sin datos reales.
