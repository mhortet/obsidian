---
tags:
  - app
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
  general de informe.

Sobremesa ya normaliza `estado` a `P/B/M/NA`. Para evitar ambiguedad, conviene
ajustar `_insert_result` para que si `estado == "NA"` no intente convertir
`valor_leido` a decimal y persista `NULL`.

## Impacto por capa

### JSON

No cambiar forma raiz. Mantener:

- `informes`: lista de cabeceras;
- `resultados`: lista de resultados.

Ampliar de forma compatible:

- `informes[*].observaciones`: texto opcional;
- `resultados[*].estado = "NA"` para cuantitativos no aplicables.

Opcional recomendado:

- subir version logica de exportacion tablet a `1.1` o anadir
  `features: ["informe_observaciones", "cuantitativo_na"]`.

### SQLite tablet

Requiere migracion no destructiva:

```sql
ALTER TABLE informes_preventivo ADD COLUMN observaciones TEXT;
```

La migracion debe vivir en `ensure_schema_migrations`.

### MySQL sobremesa

No se ha localizado script base de `preventivos` en `bd/base`. El codigo ya
consulta dinamicamente la existencia de columnas en varios puntos.

Decision:

- si `informes_preventivo.observaciones` existe en preproduccion, no migrar;
- si no existe, crear migracion MySQL idempotente antes de activar el flujo.

No se requiere nueva columna para `NA` si `resultados_preventivo.estado` ya
admite texto/enum con `NA`. Si fuera enum sin `NA`, habria que migrar.

### Importacion

Sobremesa:

- ya acepta `informes[*].observaciones`;
- debe reforzarse `NA` para no depender de conversion decimal;
- JSON antiguo sigue funcionando.

Tablet:

- importacion de maestros no cambia.

### Validacion de cierre

Tablet:

- cuantitativo vacio sin `NA` debe bloquear cierre;
- cuantitativo `NA` debe permitir cierre;
- valor no numerico debe seguir quedando pendiente, no `NA`.

Sobremesa:

- estado `NA` ya no bloquea cierre ni cierre masivo.

### Historico y PDF

Historico:

- no requiere cambio para listar informes;
- si se quiere visibilidad de observaciones en historico, queda como mejora
  posterior, no necesaria para Paquete A.

PDF:

- observaciones generales ya aparecen;
- `NA` ya se representa;
- no cambiar en esta fase la decision existente de pintar `P` como `NA`.

## Plan incremental de implementacion

1. Tablet SQLite: anadir columna `informes_preventivo.observaciones` y migracion.
2. Tablet servicio: ampliar `ReportService.save_report`, carga de informes y
   dataclass para conservar observaciones.
3. Tablet UI: anadir campo de observaciones al final del formulario y boton/flujo
   de guardado integrado.
4. Tablet `NA`: incorporar control manual `NA` para cuantitativos y ajustar
   validacion de cierre.
5. Tablet export: incluir `informes.observaciones` y asegurar
   `estado="NA"` con valor vacio/null.
6. Sobremesa import: reforzar `_insert_result` para `NA` cuantitativo con
   `valor_leido = NULL`.
7. Tests tablet: ampliar `test_report_service.py` con observaciones de informe,
   `NA` cuantitativo, cierre y exportacion.
8. Tests sobremesa: crear test acotado de importacion JSON con observaciones y
   cuantitativo `NA`.
9. Prueba manual: crear informe en tablet con observaciones y cuantitativo `NA`,
   exportar, importar en sobremesa, revisar PDF y compatibilidad con JSON antiguo.

## Criterio de compatibilidad

- JSON antiguo sin `informes[*].observaciones` importa igual.
- JSON antiguo sin `NA` cuantitativo no cambia comportamiento.
- Tablet existente migra SQLite sin borrar datos locales.
- `NA` no equivale a campo vacio: solo cuenta si `estado == "NA"`.
- Observaciones generales no sustituyen observaciones de punto.

## Riesgos residuales

- Confirmar en BD real que `informes_preventivo.observaciones` existe.
- Confirmar tipo real de `resultados_preventivo.estado`; debe admitir `NA`.
- Evitar que la UI tablet guarde el texto literal `NA` como medida cuantitativa.
- No mezclar con Paquete B/C durante la implementacion.
