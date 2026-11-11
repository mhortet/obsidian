# Plantillas en blanco: primera implantacion y consolidacion de PDFs

## Resumen

Este PR deja integrada en una sola rama la base de trabajo de PDFs de `pdf_preventivos` y `pdf_quirofano`, y añade la primera implantacion funcional de `plantillas en blanco` para trabajo en campo.

## Incluye

- Integracion de las lineas previas de trabajo PDF sobre `main`.
- Generacion de plantillas en blanco de quirófanos sin crear informes reales en base de datos.
- Generacion de plantillas en blanco de preventivos por plantilla, tambien en modo read-only.
- Nuevo acceso UI `Plantillas en blanco` en quirófanos y preventivos.
- En quirófanos, salida de `1 PDF por quirófano` para:
  - un quirófano
  - una ubicación
  - todos los quirófanos
- Referencias de formulario visibles en el lateral de los PDFs finales:
  - `Q01QF` para informe final de quirófano
  - `P01QF` para informe final de preventivos
- Preparacion de referencias para plantillas de campo:
  - `Q02QF`
  - `P02PF`
- Ajustes de assets visuales e ignore local para evitar ruido de logos/iconos en el flujo de trabajo.

## Criterios aplicados

- La generacion de plantillas en blanco es `read-only`.
- No se insertan informes temporales ni resultados ficticios para imprimir.
- Se reutiliza el formato actual de los PDFs para minimizar riesgo funcional.
- Se deja encaminada la futura separacion entre informe final y plantilla de campo sin forzar todavia una remaquetacion completa.

## Validacion realizada

- Compilacion con `python -m py_compile` de los archivos tocados.
- Prueba funcional real de generacion:
  - `output/quirofanos/plantillas_blanco/Q02QF_HEM1.pdf`
  - `output/preventivos/plantillas_blanco/P02PF_Electorcardiógrafos.pdf`
- Prueba manual de apertura de ventanas nuevas y ajuste visual basico.

## Notas para revision

- El alcance visible frente a `main` incluye tambien la consolidacion de mejoras PDF previas, no solo la parte de plantillas en blanco.
- La personalizacion de imagen visual por cliente no se aborda en este PR; se prioriza estabilidad del informe actual.
- La siguiente iteracion natural seria revisar visualmente las plantillas de campo y decidir si conviene una maquetacion especifica distinta del informe final.
