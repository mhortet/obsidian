---
title: "P2T — Canonización del resultado del ledger de Quirófanos"
type: plan
status: completed
created: 2026-11-17
updated: 2026-11-17
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2S-RECONCILIACION-LEDGER-QUIROFANOS-2026-11-17.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2R-BOOTSTRAP-DESDE-DESARROLLO-2026-11-17.md"
tags: [qontrolmed, mysql, ledger, quirofanos, p2t]
review_after: 2026-11-24
---

# P2T — Canonización del resultado del ledger de Quirófanos

## Motivo

P2S verificó la estructura equivalente a las migraciones 1 y 2, corrigió
`ruta_certificado` a `VARCHAR(500)` y registró los identificadores y hashes
canónicos. Sin embargo, insertó ambas filas con `result='recovered'`. El guard
de runtime rechaza por diseño cualquier resultado distinto de `applied`, por
lo que clasifica el esquema como `inconsistent` aunque versiones, orden,
identificadores, hashes y estructura coincidan.

## Objetivo

Demostrar de nuevo la equivalencia estructural y canónica de las versiones 1
y 2 y, solo si todos los prechecks coinciden exactamente, cambiar el resultado
de esas dos filas de `recovered` a `applied` para que el ledger exprese el
estado verificado y el guard pueda aceptarlo.

## Alcance y límites

- Actuar únicamente sobre `quirofanos.qontrolmed_schema_migrations`.
- No modificar tablas funcionales, usuarios, contraseñas, permisos ni otros
  esquemas.
- No cambiar identificadores, versiones, hashes ni fechas originales.
- No ejecutar migraciones ni abrir MySQL a la LAN.
- Detenerse si existe cualquier fila, versión, hash, estructura o resultado
  diferente de los dos estados exactos esperados.

## Secuencia autorizable

1. Revalidar MySQL `active/enabled`, cero unidades fallidas y escucha exclusiva
   en `127.0.0.1:3306`.
2. Verificar exactamente dos filas ordenadas: versiones 1 y 2, identificadores
   y hashes del manifiesto, ambas con `result='recovered'`.
3. Verificar `tecnico_cierre INT NULL` y
   `ruta_certificado VARCHAR(500) NULL DEFAULT NULL`.
4. Crear una copia previa verificada de la tabla ledger y una exportación
   depurada del estado canónico en un directorio P2T protegido.
5. En una transacción, actualizar exclusivamente esas dos filas a
   `result='applied'` y añadir a `notes` la referencia a la verificación P2T.
6. Confirmar dos filas afectadas, ninguna otra modificación y compatibilidad
   exacta con el manifiesto mediante el mismo evaluador del runtime.
7. Repetir el arranque P2R; si aparece la UI de contraseña inicial, completar
   el bootstrap funcional y verificar el hash solo por presencia.
8. Retirar la cuenta temporal, el túnel, la CA pública temporal y los scripts
   de `/tmp`; revalidar el estado seguro.

## Aceptación

- El ledger contiene únicamente las versiones 1 y 2 canónicas con
  `result='applied'`.
- La evaluación devuelve `compatible`.
- No cambian datos funcionales ni estructura.
- Qontrolmed supera el guard y permite completar el bootstrap.
- La cuenta y los archivos temporales quedan retirados.

## Reversión

Si falla cualquier precheck, no se ejecuta la actualización. Si falla el
postcheck, restaurar las dos filas desde la copia previa dentro de una
transacción y volver a comprobar `result='recovered'`. La copia P2S completa
permanece como recuperación adicional; no se restaura el esquema completo por
un fallo limitado al ledger salvo inconsistencia no acotable.

## Resultado ejecutado

El propietario autorizó el bloque completo el 17/11/2026. El arnés superó los
prechecks de servicio, loopback, ausencia de cuenta temporal, dos filas
canónicas y estructura equivalente a v1/v2. Creó y verificó la copia previa,
actualizó exactamente dos filas y terminó con:

- `P2T_PRECHECK=OK`;
- `P2T_BACKUP=OK`;
- `P2T_LEDGER=OK versiones=2 resultado=applied`;
- `P2T_RESULTADO=OK`.

La validación funcional del guard y el bootstrap continúan en P2R. La ruta
exacta de la copia protegida permanece registrada en la salida administrativa
del servidor y no se replica en documentación pública.
