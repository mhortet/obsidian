# Especificacion: preventivos en tablet y sincronizacion con sobremesa

Fecha de adopcion en este proyecto: 2026-05-16

## Objetivo

Permitir que la tablet trabaje con informes preventivos fuera de linea y que la aplicacion de sobremesa pueda importar esos informes de forma controlada, trazable y sin duplicar informacion critica.

Nota de naming:

- `Qontrolmed` es el nombre funcional del escritorio.
- `maxgesth` y `maxgesth_port` se mantienen aqui cuando haga falta distinguir
  repositorio, ruta o contrato tecnico.

Esta especificacion viene adaptada desde `maxgesth_port`, pero queda ajustada a la arquitectura actual de `Qontrolmed` (`maxgesth`): aplicacion de escritorio, MySQL como base principal y export/import mediante fichero local.

Ademas de esta especificacion funcional, las futuras actualizaciones de este flujo deben respetar el criterio transversal definido en `docs/02_planes_y_arquitectura/especificaciones/criterios_transversales_capas.md`.

La definicion de campanas preventivas y su impacto en analiticas queda fijada en
`docs/02_planes_y_arquitectura/especificaciones/modulo_analitico_y_campanas_preventivo.md`.

## Alcance

Incluido:

- Preventivos.
- Exportacion de datos maestros hacia tablet.
- Captura de informes en tablet.
- Importacion de informes desde JSON generado por tablet.
- Resolucion de conflicto cuando ya existe un informe para el mismo equipo/campana.
- Apertura del informe importado en sobremesa para completar equipos de medida, observaciones y revision final.

Fuera de alcance por ahora:

- Sincronizacion en tiempo real.
- API remota.
- Quirofanos y compras.
- Multiusuario concurrente sobre la tablet.
- Firma/cierre definitivo desde tablet como estado final de sobremesa.

## Reglas funcionales

1. La tablet puede cerrar un informe para indicar que esta terminado en campo.
2. Al importar en sobremesa, el informe no debe quedar cerrado en la base principal.
3. El informe importado debe quedar editable para completar:
   - Equipos de medida.
   - Observaciones finales.
   - Ajustes administrativos o tecnicos.
   - Cierre definitivo desde sobremesa.
4. No se pueden cargar dos informes activos sobre el mismo equipo en la misma campana.
4.bis. La misma regla aplica a la creacion manual en sobremesa: la unicidad
funcional se controla por `equipo + campana`, no por equipo aislado cuando la
campana existe.
5. Si ya existe un informe para el equipo/campana, la importacion debe pedir decision explicita:
   - Mantener informe existente.
   - Reemplazar por informe importado.
6. Cualquier reemplazo debe ejecutarse en transaccion.
7. Si se cancela una decision de conflicto, no debe quedar una importacion parcial.

## Contrato minimo del fichero de importacion

El fichero debe declarar metadatos suficientes para validar su origen:

- Version de exportacion.
- Fecha de exportacion.
- Origen tablet.
- Campana o contexto de preventivos.
- Tablas o bloques incluidos.

Bloques esperados:

- Informes preventivos.
- Mediciones/respuestas/puntos asociados.
- Equipos o identificadores necesarios para enlazar con la base principal.
- Metadatos de estado en tablet.

Campo clave adicional:

- Cada informe debe incluir `id_campana` cuando la tablet ya conoce la campana
  importada.
- Si un fichero legado no lo incluye, sobremesa puede usar la campana activa
  como fallback controlado, dejando aviso visible en la importacion.

La importacion debe rechazar el fichero si faltan campos obligatorios, si hay tipos incompatibles o si las relaciones internas no son coherentes.

## Reglas de seguridad de importacion

Antes de escribir en base de datos:

- Validar que el JSON es legible.
- Validar version y estructura.
- Validar columnas esperadas frente al contrato.
- Validar claves de equipo/campana.
- Validar que los estados son conocidos.
- Preparar lista de conflictos.
- Solicitar decisiones al usuario cuando proceda.

Durante la escritura:

- Usar transaccion.
- No hacer borrados destructivos fuera de una decision explicita.
- Reemplazar cabecera y detalle como una unidad atomica.
- Mantener trazabilidad de fecha de importacion y origen.
- Forzar el estado de sobremesa a abierto, aunque el informe venga cerrado desde tablet.

Despues de escribir:

- Mostrar resumen de importacion.
- Informar de importados, omitidos, reemplazados y errores.
- No marcar nada como cerrado automaticamente.

## Estados recomendados

Estados de tablet:

- `borrador`: trabajo empezado.
- `cerrado_tablet`: informe terminado en campo y listo para exportar.
- `exportado`: fichero generado correctamente.

Estados de sobremesa:

- `abierto`: informe editable.
- `pendiente_revision`: opcional, si se decide diferenciar importados de creados manualmente.
- `cerrado`: informe finalizado en sobremesa.

Regla actual obligatoria:

- `cerrado_tablet` nunca equivale automaticamente a `cerrado` en sobremesa.

## Reglas de consistencia

- Una importacion debe ser idempotente cuando el usuario elige mantener el informe existente.
- Una importacion con reemplazo debe dejar una unica version valida del informe.
- Los detalles no deben quedar huerfanos si falla la cabecera.
- La aplicacion no debe depender de rutas absolutas del entorno de desarrollo.
- Los errores de importacion deben ser comprensibles para el usuario, pero los detalles tecnicos deben quedar disponibles para diagnostico.

## Pruebas minimas antes de subir cambios

- Importar fichero valido sin conflictos.
- Importar fichero valido con conflicto y mantener base.
- Importar fichero valido con conflicto y reemplazar por tablet.
- Verificar que el informe importado queda abierto.
- Verificar que no hay detalles duplicados tras dos importaciones.
- Probar fichero JSON invalido.
- Probar fichero con version no soportada.
- Probar cancelacion de dialogo de conflicto.

## Pendiente tecnico

- Consolidar el uso funcional de `campanas_preventivo` e
  `informes_preventivo.id_campana`, ya presentes en el esquema, y crear la
  relacion `campana_equipos_preventivo` antes de ampliar analiticas.
- Formalizar versionado del JSON.
- Cubrir importacion con tests automatizados.
- Separar completamente parseo, validacion, decision de conflicto y persistencia.
- Registrar auditoria ligera de importaciones.
- Definir si `pendiente_revision` merece columna propia o se modela con el estado actual.
