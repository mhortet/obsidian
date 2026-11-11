---
tags:
  - qontrolmed
  - documentacion
Creado: 2026-06-25
Relacionado:
---

# Analisis Paquete A Preventivos - 2026-06-25

Estado: LISTO PARA IMPLEMENTAR

## Alcance

Paquete A cubre solo:

- observaciones generales de informe capturadas en tablet y visibles en sobremesa;
- marcado `NA` en puntos cuantitativos de tablet cuando el control no aplica.

Quedan fuera de este paquete serie/inventario visible, referencias DESF ampliadas,
busqueda por numero de serie y exportacion por bloques.

## Flujo actual mapeado

1. Sobremesa exporta maestros a tablet desde
   `src/preventivos/services/export_preventivos_service.py`.
2. Tablet importa maestros en SQLite con `src/services/import_service.py`.
3. Tablet guarda informes y resultados en `src/services/report_service.py`.
4. Tablet exporta informes cerrados desde `src/services/export_service.py`.
5. Sobremesa importa resultados con
   `src/preventivos/services/import_tablet_service.py`.
6. Sobremesa recalcula estado, deja el informe abierto y permite revision final.
7. PDF e historico consumen las tablas MySQL de sobremesa.

## Observaciones

### Sobremesa

La sobremesa ya esta preparada para recibir observaciones generales:

- `informes_preventivo.observaciones` se muestra y edita en
  `src/preventivos/ui/informe_preventivo_ui.py`.
- `guardar_observaciones_informe` persiste el texto.
- `import_tablet_service._insert_report` ya lee `informe["observaciones"]` si
  la columna existe.
- `pdf_service.generar_pdf_informe_preventivo` ya consulta
  `i.observaciones` y lo pinta en el bloque de comentarios.
- El cierre masivo de correctos excluye informes con observaciones.

Conclusion: no se requiere cambio de contrato MySQL si la columna ya existe en
el entorno. Si el entorno objetivo no la tiene, falta migracion SQL explicita.

### Tablet

La tablet solo tiene `resultados_preventivo.observaciones`. No existe columna
de observaciones generales en `informes_preventivo`, ni se exporta en el bloque
`informes`.

Cambio necesario:

- anadir `informes_preventivo.observaciones TEXT` en SQLite;
- migrar con `ALTER TABLE informes_preventivo ADD COLUMN observaciones TEXT`;
- exponer un campo de texto al final del formulario movil;
- guardar y recuperar el texto en `ReportService`;
- incluir `ip.observaciones` en la exportacion JSON de resultados.

Compatibilidad:

- JSON antiguo sin `observaciones` debe seguir importando como `NULL`;
- JSON nuevo con `observaciones` sera consumido por sobremesa sin cambiar la
  estructura base de `informes`/`resultados`.

## NA cuantitativo

### Sobremesa

La sobremesa ya admite `NA` manual sobre puntos cuantitativos:

- UI permite `NA` para `CUALITATIVO`, `CUANTITATIVO` y `SEGURIDAD`;
- `actualizar_resultado_informe` guarda estado `NA` y `valor_leido = NULL`;
- el resumen no cuenta `NA` como pendiente ni incidencia;
- el cierre masivo acepta estados `B` o `NA`;
- el PDF representa `NA`.

Riesgo detectado: el PDF trata tambien `P` como `NA` visual en algunas tablas.
No forma parte del Paquete A salvo que se decida corregirlo; conviene no mezclar
ese ajuste con el contrato tablet.

### Tablet

La tablet actualmente:

- calcula cuantitativos desde valor numerico;
- devuelve `P` si falta valor o el valor no es numerico;
- solo tiene selector `B/M/NA` para cualitativos;
- permite `NA` automatico para seguridad clase III;
- al cerrar exige valor en puntos cuantitativos salvo `estado_auto`.

Cambio necesario:

- permitir un estado manual `NA` tambien en puntos cuantitativos;
- conservar `estado = "NA"` y `valor_leido = ""` o `NULL` localmente;
- al exportar JSON enviar `estado: "NA"` y `valor_leido: ""` o `null`;
- mantener campo vacio sin `NA` como pendiente/no cerrable;
- no convertir texto literal `"NA"` en valor numerico.

Contrato recomendado:

- `resultado.estado = "NA"` es la fuente de verdad;
- `resultado.valor_leido` debe ir vacio o `null` cuando el estado es `NA`;
- `resultado.valor_referencia` puede conservarse si ya estaba informado, pero
  no debe ser obligatorio para cerrar un punto `NA`;
- `resultado.observaciones` sigue siendo observacion de punto, no observacion
  general de