Para anotar en detecciones en pruebas de campo:

	- Meter en informe_ui un campo de búsqueda del equipo por N. de serie
	- Ampliar tema de valor objetivo en los puntos de DESF-Q01 a DESF-Q08
		- Tomar el valor para referencia el campo objetivo de la bd, cargarlo en el campo valor del informe y permitir que el usuario pueda cambiarlo a voluntad, quedando guardado al pulsar enter tanto en la bd como en el informe y en este último pasa al siguiente punto.
		- He comprobado en tablet, que al revisar los informes cerrados, si que aparece el campo valor 
		- En puntos de control prventivo, al actualizar cualquier punto, mantener el filtro y orden en ese momento.
		- Una vez exportado el informe en tablet, marcarlo como exportado para no enviarlo en sucesivos paquetes, pero con opción de exportación total para cubrir casos de pérdida de datos en los pasos de movil a sobremesa

Plan que propone Codex:

**Plan recomendado**

1. **Bloque 1, recomendable ahora mismo en maxgesth**.
    
    - Añadir modo de exportación solo pendientes por defecto y opción exportación total.
    - Conservar filtro y orden en Puntos de control preventivos tras guardar/activar/desactivar.
    - Esto es lo más rentable ahora porque no depende del móvil y se valida con datos ficticios de sobremesa.
2. **Bloque 2, después, compartido escritorio + móvil**.
    
    - Resolver DESF-Q01 a DESF-Q08 con valor inicial tomado del objetivo maestro y editable por informe.
    - Al pulsar Enter: guardar, persistir y avanzar al siguiente punto.
    - Aquí la decisión importante es esta: recomiendo guardar ese dato en el resultado del informe (valor_referencia o equivalente local en tablet), **no sobrescribir el objetivo maestro de puntos_control**.
    - Este bloque exige revisar también maxgesth_port, porque por tu contexto el uso real está hoy en móvil.
3. **Bloque 3, búsqueda por serie**.
    
    - Si el objetivo real es móvil, esta mejora debe priorizarse en maxgesth_port.
    - Si quieres además soporte en escritorio, en maxgesth la haría como búsqueda unificada por inventario o numero_serie, mejor que añadir lógica paralela confusa.

**Orden de ejecución que te propongo**

- Primero: exportación pendiente/total.
- Segundo: mantener filtro y orden.
- Tercero: DESF-Q01..Q08 como bloque coordinado con móvil.
- Cuarto: búsqueda por serie en la UI que realmente vaya a usar el técnico en la próxima carga.

**Tests de cierre por bloque**

- python -m py_compile src\preventivos\services\export_preventivos_service.py src\preventivos\services\tablet_tracking_service.py src\preventivos\main_preventivos.py src\preventivos\ui\pc_preventivos_ui.py src\preventivos\ui\informe_preventivo_ui.py
- python -m compileall main.py src

**Validación manual esperada**

- Exportar dos veces una misma tipología y comprobar diferencia entre solo pendientes y total.
- Editar un punto en Puntos de control con filtro y orden activos y verificar que la tabla vuelve al mismo contexto.
- Para DESF, probar con informes ficticios que el valor arranca con el objetivo esperado, se puede cambiar, queda persistido y Enter salta al siguiente.

Mi recomendación es empezar **ahora** por el **Bloque 1**. Si te encaja, sigo directamente con exportación pendiente/total y mantener filtro/orden, que es el tramo más seguro para avanzar hoy sin abrir todavía dependencia con móvil.

Nuevo Promt
una corrección, creo me expliqué mal o más bien no tenía bien definido el proceso de exportación

Actualiza contexto antes de empezar:

La idea general es que se exporte por defecto la campaña completa, pero se pueden dar casos que no sea así, por lo tanto:


