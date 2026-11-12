# Especificacion: criterios transversales para futuras actualizaciones

Fecha de adopcion en este proyecto: 2026-05-17
Ultima revision: 2026-05-30

## Objetivo

Definir los criterios obligatorios que deben seguir las proximas actualizaciones de `Qontrolmed` (`maxgesth`) en todas las capas del proyecto: UI, servicios, base de datos, integraciones por fichero, documentacion y entrega.

Esta especificacion no sustituye a las especificaciones funcionales de cada modulo. Las complementa para que cualquier cambio nuevo mantenga consistencia tecnica, reduzca regresiones y deje trazabilidad clara.

## Principios base

- Cada cambio debe tener una unica fuente de verdad para la regla de negocio que modifica.
- La UI no debe decidir reglas criticas de persistencia.
- Las operaciones compuestas deben ser atomicas o no ejecutarse.
- Los artefactos de runtime no forman parte del codigo fuente.
- La documentacion funcional y tecnica debe actualizarse cuando cambia una regla real.
- La validacion minima debe hacerse antes de considerar un cambio listo para entrega.

## Criterios por capa

### UI

- La UI debe centrarse en capturar datos, mostrar estado y pedir confirmaciones al usuario.
- La UI no debe repartir `UPDATE`, `INSERT` o reglas de negocio criticas en varios pasos sueltos si la operacion pertenece a una unica accion funcional.
- Las pantallas deben bloquear o limitar la edicion cuando el estado funcional lo exija, por ejemplo informes cerrados.
- Los mensajes de error deben ser comprensibles para el usuario final y no dejar estados ambiguos.
- Las rutas de exportacion, importacion o salida no deben apuntar a `src/` ni depender de rutas absolutas del entorno de desarrollo.
- La UI no debe disparar cambios de esquema en segundo plano como parte normal
  del uso diario.
- Los textos visibles al usuario deben mantenerse sin mojibake y con criterio
  uniforme de codificacion antes de dar una version por valida.

### Servicios

- La logica de negocio debe vivir en servicios del dominio correspondiente.
- Los servicios deben encapsular validaciones, consistencia y transacciones de las operaciones compuestas.
- Los servicios deben devolver resultados claros o lanzar errores del dominio cuando una operacion no puede completarse.
- Cuando exista logica comun entre dos flujos, se debe reutilizar antes de duplicar criterio.
- Un cambio funcional no debe dejar criterios distintos para la misma regla segun se ejecute desde UI, importacion, historico o proceso auxiliar.
- Los servicios no deben ocultar `ALTER TABLE`, autocreacion de columnas o
  migraciones silenciosas en rutas normales de usuario sin documentarlo y sin
  decision explicita del proyecto.

### Base de datos y persistencia

- Toda operacion cabecera-detalle debe ejecutarse como una sola unidad atomica.
- Las importaciones, reemplazos, cierres y borrados de detalle deben tener `rollback()` real si falla cualquier paso.
- El SQL debe usar parametros y, cuando haya SQL dinamico inevitable, listas blancas explicitas para columnas o fragmentos.
- Los cambios de estado derivados, como `resultado_final`, deben recalcularse desde una logica unica y no desde multiples implementaciones divergentes.
- Si una tabla o columna opcional condiciona el comportamiento, el codigo debe tratar esa compatibilidad de forma explicita y segura.
- Las migraciones de esquema para produccion deben vivir en SQL documentado y no
  depender de que un flujo funcional "arregle" la base en tiempo de ejecucion.
- Las operaciones sensibles deben dejar capacidad de auditoria minima:
  importador, fecha, origen y resultado resumido cuando el caso lo requiera.

### Ficheros e integraciones

- Los intercambios por fichero deben validar estructura, version y coherencia antes de escribir en base de datos.
- Cualquier importacion con conflicto debe pedir decision explicita si puede reemplazar informacion existente.
- Los procesos de exportacion e importacion deben dejar resumen de lo ocurrido: importados, omitidos, reemplazados y errores.
- Los directorios de runtime deben vivir fuera del codigo fuente y quedar cubiertos por `.gitignore` cuando proceda.
- Ninguna integracion debe depender de assets de cliente versionados como si fueran fuente estable.
- Los contratos JSON o de intercambio deben versionarse y rechazar estructuras
  incompatibles de forma comprensible.
- Las rutas de intercambio deben quedar separadas por dominio y sentido del
  flujo cuando exista riesgo de mezclar maestro y resultados de campo.

### Documentacion y especificaciones

- Si cambia una regla funcional, debe actualizarse su especificacion viva en `docs/02_planes_y_arquitectura/especificaciones/`.
- Si cambia el criterio tecnico o de entrega, debe actualizarse el documento vivo en `docs/`.
- Cuando una decision afecte a varias capas, debe quedar reflejada en esta especificacion transversal o en una version posterior de la misma.
- Las pruebas manuales relevantes y el estado de validacion deben resumirse en `CONTINUAR-SIGUIENTE-SESION.md` y en un estado fechado bajo `docs/00_seguimiento/estados/` cuando cambien el punto de reanudacion del trabajo.

### Entrega y mantenimiento

- Antes de una fase grande, revisar `git status --short` y separar cambios funcionales de cambios de limpieza.
- No versionar builds, caches, exports temporales ni assets especificos de cliente.
- Mantener commits pequenos y trazables, preferiblemente por unidad funcional.
- No considerar una tarea lista solo porque compila; debe existir validacion acorde al riesgo del cambio.
- Antes de cualquier paso a produccion o piloto, dejar checklist minima de
  backup, restauracion, validacion manual y riesgos residuales.

## Validaciones minimas obligatorias

Para cualquier cambio Python:

```powershell
python -m compileall main.py src
```

Cuando el cambio afecte a persistencia, importacion, cierre o calculo de estado:

- Probar el flujo feliz completo.
- Probar al menos un caso de cancelacion o conflicto.
- Probar que no quedan datos parciales tras error o interrupcion controlada.
- Verificar que el estado visible en UI coincide con el estado persistido.

Cuando el cambio afecte a exportacion/importacion por fichero:

- Verificar ruta de salida real.
- Verificar estructura minima del fichero.
- Verificar reimportacion o repeticion controlada sin duplicados indebidos.
- Verificar que no se confunden ficheros maestro con resultados de campo.
- Verificar que la version o metadatos del intercambio quedan trazados.

## Regla de evolucion

Si una actualizacion nueva obliga a saltarse uno de estos criterios, no debe hacerse en silencio. Hay que:

1. Documentar la excepcion.
2. Explicar el motivo tecnico o funcional.
3. Dejar anotado si la excepcion es temporal o definitiva.
4. Registrar la tarea pendiente para volver al criterio objetivo.

## Documentos relacionados

- `docs/03_operacion_y_runbooks/security_delivery_playbook.md`
- `docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md`
- `CONTINUAR-SIGUIENTE-SESION.md`
- `docs/02_planes_y_arquitectura/especificaciones/remote_tablet_preventivos.md`
- `docs/02_planes_y_arquitectura/especificaciones/modulo_analitico_y_campanas_preventivo.md`
