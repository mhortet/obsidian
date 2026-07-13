---
tags:
  - app
  - aprendizaje
  - desarrollo
  - codigo
Creado:
Autor:
Relacionado:
---
## Resumen

## Descripción


# Estado de continuidad local - maxgesth_port
[[maxgesth_port]]
Fecha: 2026-07-12

## Foto ejecutiva

`maxgesth_port` es la tablet offline de Preventivos para trabajo de campo. Su
funcion es importar datos maestros desde `maxgesth`, permitir capturar informes
sin conexion, conservar trabajo local en SQLite y exportar resultados cerrados
para su revision/importacion en escritorio.

El repo principal `maxgesth` gobierna roadmap, seguridad, prioridades de
septiembre y contrato global. Este repo conserva la especificidad local:
ejecucion Flet, persistencia SQLite, UI tactil, exportacion JSON y build APK.

## Estado observado

- App Flet con entrada `python -m src.main`.
- Persistencia local SQLite.
- Importacion validada de maestros JSON.
- Proteccion frente a sobrescritura de trabajo local antes de importar.
- Alta, guardado, cierre, reapertura y exportacion de informes preventivos.
- Trazabilidad de `id_campana` en importacion, guardado y exportacion.
- Soporte local observado para `observaciones` de informe y `NA` cuantitativo,
  con exportacion version `1.1` y features declaradas.
- Validacion manual de Paquete A registrada el 2026-07-12:
  - calculo correcto del resultado del valor medido a partir del valor de
    referencia;
  - funcionamiento correcto de `NA` en campos cuantitativos;
  - traslado correcto de observaciones hacia sobremesa;
  - salida correcta de observaciones y `NA` en informe PDF.
- Build Android local documentada y validada mediante
  `scripts/build_android_apk.ps1`; es la via recomendada para generar APK de
  pruebas de campo.
- Build remoto GitHub Actions queda como respaldo si falla la build local, si se
  necesita artifact compartible o si se quiere validar en entorno limpio.

## Prioridad local

1. Mantener alineado el contrato con `maxgesth`.
2. Dar Paquete A de severidad alta como validado funcionalmente y no reabrirlo
   salvo regresion.
3. No abrir prestaciones nuevas fuera de import/export, cierre real, campo
   aceptado o build/validacion Android.
4. Confirmar en escritorio cualquier cambio nuevo de JSON, estado o semantica de
   cierre.
5. Mantener la documentacion local como satelite, no como roadmap paralelo.

## Riesgos abiertos

- La build remota puede depender de cuota o disponibilidad de GitHub Actions;
  no debe bloquear pruebas si el APK local se genera correctamente.
- Cualquier ajuste futuro de exportacion puede romper importacion en escritorio
  si no se valida en ambos repositorios.
- La validacion Android real vuelve a ser obligatoria cuando cambie UI, fichero
  compartido o flujo de guardado.

## Tests locales base

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\data\schema.py src\services\import_service.py src\services\report_service.py src\services\export_service.py
```

## Proxima entrada recomendada

Siguiente frente recomendado: abordar Paquete B de eficiencia de campo sin
mezclarlo con Paquete A. Prioridad natural:

1. mostrar numero de serie e inventario en identificacion de equipo;
2. revisar referencias `DESF-Q01` a `DESF-Q08`;
3. anadir busqueda por numero de serie en escritorio;
4. decidir si la exportacion por bloques entra en septiembre o queda para
   estabilizacion posterior.

Para cambios de UI o Android, generar primero APK local con
`scripts/build_android_apk.ps1` y probar en dispositivo. Usar GitHub Actions
solo como respaldo o evidencia adicional.
