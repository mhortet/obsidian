# Puntos automaticos por quirofano
[[masgesth]]
## Objetivo

Permitir asignar puntos secuenciales como `E1`, `E2`, `E3` o `P1`, `P2`, `P3`
directamente a cada quirofano sin tener que crearlos antes en la tabla general
`puntos_control`.

La tabla `puntos_control` queda reservada para puntos especiales o de catalogo,
por ejemplo `PT`, `ET` u otros puntos especificos.

## Modelo recomendado

Antes, toda asignacion de un punto a un quirofano dependia de esta relacion:

```text
quirofano_puntos_control.id_punto_control -> puntos_control.id
```

Eso obligaba a que cualquier punto asignado existiera primero en `puntos_control`.

Con el nuevo modelo:

```text
puntos_control
  PT
  ET
  otros puntos especiales

quirofano_puntos_control
  puntos de catalogo: id_punto_control con valor
  puntos automaticos: id_punto_control NULL, codigo propio, descripcion propia
```

La tabla `quirofano_puntos_control` pasa a guardar tambien:

```text
codigo
descripcion
tipo
```

Donde `tipo` puede ser:

```text
CATALOGO
AUTO
```

## Ejemplo funcional

Para un quirofano se puede introducir:

```text
E inicial: 1
E final: 8
P inicial: 1
P final: 6
```

La aplicacion crea y asigna directamente:

```text
E1, E2, E3, E4, E5, E6, E7, E8
P1, P2, P3, P4, P5, P6
```

Esos puntos no se insertan en `puntos_control`; quedan asociados solo al quirofano.

## Cambios en base de datos

La migracion esta en:

```text
docs/migracion_puntos_automaticos.sql
```

Cambios principales:

- `quirofano_puntos_control.id_punto_control` pasa a permitir `NULL`.
- Se anaden `codigo`, `descripcion` y `tipo` a `quirofano_puntos_control`.
- Las asignaciones existentes se rellenan con el codigo y descripcion del catalogo.
- Se anade una clave unica por `id_quirofano + codigo`.
- `resultado_puntos` pasa a apuntar a `quirofano_puntos_control.id`.

Este ultimo punto es importante: los informes ya no dependen solo del punto de
catalogo, sino de la asignacion concreta del quirofano. Asi pueden existir puntos
automaticos que no estan en `puntos_control`.

## Archivos modificados

```text
src/Quirofanos/services/quirofano_puntos_control_service.py
src/Quirofanos/services/informe_service.py
src/Quirofanos/ui/quirofano_puntos_control_ui.py
docs/migracion_puntos_automaticos.sql
```

## Funcionamiento en la pantalla

En la pantalla de asignacion de puntos por quirofano se anade el boton:

```text
Asignar rango
```

El dialogo permite informar rangos para `E` y `P`.

Si un codigo ya existe en ese quirofano, se omite para evitar duplicados.

## Pasos recomendados antes de usarlo

1. Hacer copia de seguridad de la base `quirofanos`.
2. Ejecutar la migracion `docs/migracion_puntos_automaticos.sql`.
3. Abrir la aplicacion.
4. Entrar en asignacion de puntos por quirofano.
5. Probar un rango pequeno, por ejemplo:

```text
E inicial: 1
E final: 3
P inicial: 1
P final: 2
```

6. Crear o cargar un informe para ese quirofano.
7. Verificar que aparecen `E1`, `E2`, `E3`, `P1`, `P2`.
8. Marcar algun punto como `MAL` y comprobar que guarda observacion/valor.
9. Generar PDF y revisar que los puntos aparecen correctamente.

## Precauciones

No ejecutar la migracion sin copia previa. Cambia claves foraneas, indices y la
forma en que `resultado_puntos` referencia los puntos del informe.

Si ya hay informes creados, la migracion intenta enlazar sus resultados con la
asignacion existente del quirofano.

Si en la base hubiera resultados antiguos sin asignacion correspondiente, habria
que revisarlos antes de hacer obligatorio `resultado_puntos.id_quirofano_punto_control`.

## Resumen

Este cambio permite mantener limpia la tabla general `puntos_control` y usarla
solo para puntos especiales. Los puntos repetitivos por quirofano se gestionan
directamente desde la asignacion del quirofano, que es donde realmente pertenecen.
