# Nota local de continuidad - maxgesth_port
[[maxgesth_port]]
Fecha de revision: 2026-07-12

## Rol de este repo

`maxgesth_port` es la app tablet offline de Preventivos. Su trabajo debe
mantenerse alineado con `maxgesth`, que es la fuente canonica de roadmap,
seguridad, documentacion viva y contrato escritorio-tablet.

## Lectura obligatoria antes de tocar este repo

Leer primero en `maxgesth`:

1. `D:/trabajo/Proyectos/maxgesth/docs/security_delivery_playbook.md`
2. `D:/trabajo/Proyectos/maxgesth/docs/estado_continuidad.md`
3. `D:/trabajo/Proyectos/maxgesth/docs/plan_seguridad_consistencia.md`

Leer tambien:

- `D:/trabajo/Proyectos/maxgesth/docs/cola_triaje_campo.md`
- `D:/trabajo/Proyectos/maxgesth/specifications/remote_tablet_preventivos.md`
- `D:/trabajo/Proyectos/maxgesth_port/specifications/remote_tablet_preventivos.md`
- `D:/trabajo/Proyectos/maxgesth_port/docs/mapa_documental_local.md`
- `D:/trabajo/Proyectos/maxgesth_port/docs/estado_continuidad_local.md`

## Estado local a tener presente

- Rama observada: `fix-trabajo-campo`.
- Modulo aceptado como base de trabajo de campo para Preventivos.
- Las observaciones de `cola_triaje_campo` ya se dan por buenas para
  planificacion.
- Paquete A de Preventivos queda validado manualmente el 2026-07-12:
  calculo de resultado desde valor de referencia, `NA` cuantitativo, traslado
  de observaciones e informe PDF correctos.
- La build Android local con `scripts/build_android_apk.ps1` es la via
  recomendada para generar APK de pruebas. GitHub Actions queda como respaldo
  si falla local, se necesita artifact compartible o se quiere validar en
  entorno limpio.
- El repo no debe abrir prestaciones nuevas salvo que esten ligadas a:
  - contrato con escritorio;
  - importacion/exportacion;
  - cierre real de informes;
  - observaciones de campo aceptadas;
  - build o validacion Android.

## Prioridad local hacia septiembre

1. Mantener contrato con `maxgesth`.
2. Mantener Paquete A como validado funcionalmente; reabrir solo por regresion
   o por cambio nuevo de contrato.
3. Agrupar mejoras medias como siguiente paquete:
   - serie e inventario;
   - referencias `DESF-Q01` a `DESF-Q08`;
   - busqueda por numero de serie;
   - exportacion por bloques si se confirma necesaria.
4. Mantener mejoras visuales como opcionales.

## Tests locales recomendados

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\data\schema.py src\services\import_service.py src\services\report_service.py src\services\export_service.py
```

Si el cambio afecta a UI o flujo tactil:

- probar en Windows;
- probar en Android/APK o dejar validacion manual explicitamente pendiente.

## Riesgos especificos

- Cualquier cambio de JSON debe revisarse tambien en `maxgesth`.
- `id_campana`, nombres de fichero, claves JSON y estados de cierre son
  sensibles.
- Cambios futuros sobre `observaciones` y `NA` pueden afectar persistencia,
  exportacion, importacion, validacion de cierre y PDF.
- No versionar `tmp/`, bases locales, exports de pruebas ni artefactos Android.

## Regla de cierre

No dar por cerrado un cambio de este repo sin:

- pruebas locales proporcionales;
- validacion manual si cambia UI o Android;
- actualizacion de especificacion/continuidad si cambia contrato;
- confirmacion de que `maxgesth` sigue pudiendo importar/exportar el flujo.

Para validar APK, usar primero build local. Si GitHub Actions no tiene cuota o
falla por infraestructura, dejarlo registrado como bloqueo externo solo cuando
la evidencia remota sea necesaria.
