---
tags:
  - agentes
  - arquitectura
  - desarrollo
  - IA
Creado:
Relacionado:
---

# Arnes para infografias e imagenes de producto

Este documento define el criterio comun para preparar infografias, capturas e
imagenes que amplien la informacion de la pagina `producto.html`.

El objetivo es que cada nueva pieza visual parezca parte del mismo sistema:
tecnica, sanitaria, clara y conectada con el producto QontrolMed.

## Principio editorial

Toda infografia debe nacer de una necesidad de producto, no de una idea
decorativa.

Antes de crearla, debe poder responder a una de estas preguntas:

- Que modulo de QontrolMed explica mejor?
- Que flujo operativo aclara?
- Que problema real del entorno sanitario ayuda a entender?
- Que evidencia aporta sobre trazabilidad, seguridad, trabajo de campo o
  salida documental?

Si la imagen no mejora la comprension de la suite, no debe entrar en la pagina
de producto. Puede reservarse para `recursos.html` o una publicacion tecnica.

## Ubicacion recomendada en la web

### Pagina de producto

Usar solo imagenes directamente relacionadas con:

- arquitectura matriz + tablet
- flujo de importacion y exportacion
- preventivos
- revisiones IT en quirofano
- libro de quirofano
- informes cerrados y trazabilidad
- guia diaria para tecnicos
- gobierno del dato, permisos y usuarios nominales

Tratamiento recomendado:

- pieza destacada en banda ancha
- comparativa antes/despues
- bloque de proceso paso a paso
- imagen completa con texto lateral breve

Evitar:

- miniaturas donde el texto quede ilegible
- recortes con `object-fit: cover` si la imagen contiene texto importante
- infografias muy densas dentro de tarjetas pequenas

### Pagina de recursos

Usar para contenido mas formativo o sectorial:

- seguridad electrica en ecografos
- ITC-BT-38
- IEC 62353
- mantenimiento preventivo general
- buenas practicas de inspeccion
- material divulgativo descargable

## Ficha obligatoria antes de crear una infografia

Copiar esta ficha y completarla antes de generar o disenar la imagen.

```text
Titulo de la pieza:

Pagina destino:
Producto / Recursos / Noticias

Seccion destino:

Objetivo de comunicacion:

Modulo o flujo de QontrolMed relacionado:

Publico principal:
Direccion tecnica / Ingenieria clinica / Mantenimiento / Tecnicos de campo /
Responsables sanitarios / Cliente final

Mensaje central en una frase:

Datos o conceptos obligatorios:

Datos que no deben aparecer:

Nivel de detalle:
Bajo / Medio / Alto

Formato:
Horizontal 16:9 / Vertical / Cuadrada / Captura anotada

Uso previsto:
Hero / Banda destacada / Card de recurso / Imagen ampliable / Descarga

Debe poder leerse en movil:
Si / No, solo ampliada

Estado editorial:
Borrador / Revisada tecnicamente / Lista para publicar
```

## Criterio visual comun

### Estilo

- sanitario, tecnico y limpio
- fondo claro o blanco roto
- ilustracion precisa, no fantastica
- iconografia lineal o semiplana
- ritmo visual ordenado por bloques
- evitar aspecto de publicidad generica

### Paleta

Tomar como base los tokens del sitio:

```text
Verde principal: #178D5B
Verde oscuro:    #24564C
Verde claro:     #42C098
Verde suave:     #7CB8A5
Fondo:           #F8FAF9
Texto:           #334155
Superficie:      #FFFFFF
```

Se admiten acentos azules o naranjas si tienen funcion informativa, por
ejemplo alerta, riesgo, energia o diferenciacion de modulo. No deben dominar la
pieza salvo que sea un recurso tecnico independiente.

### Tipografia

- usar una sans serif sobria similar a Inter
- titulos con peso alto
- evitar mayusculas en parrafos largos
- no mezclar mas de dos pesos de texto
- mantener espacio suficiente entre bloques

### Marca

- escribir siempre `QontrolMed`
- no usar variantes como `Qontromed`, `Qontrolmed` o `Qontrol Med`
- si aparece el logo, debe verse limpio y no competir con el contenido
- no incluir marcas de herramientas externas, firmas automaticas o sellos de IA

## Formatos recomendados

### Horizontal principal

Uso:

- pagina de producto
- bloques destacados
- recursos principales

Especificacion:

```text
Relacion: 16:9
Tamano maestro: 2752 x 1536 px o 1920 x 1080 px
Version web: WebP, ancho maximo 1600 px
Peso objetivo: menos de 350 KB si es posible
```

### Vertical explicativa

Uso:

- recurso descargable
- articulo tecnico
- visor ampliado
- resumen de proceso largo

Especificacion:

```text
Relacion: 9:16 o similar
Tamano maestro: 1080 x 1920 px o superior
Version web: WebP, ancho maximo 900 px
Uso en producto: solo si hay layout especifico o enlace a ampliar
```

### Captura anotada

Uso:

- explicar una pantalla real de QontrolMed
- resaltar una accion o estado
- conectar software con flujo operativo

Especificacion:

```text
Formato: PNG o WebP
Fondo: interfaz real, limpia y sin datos sensibles
Anotaciones: maximo 3 llamadas visuales
Texto: breve, legible y no redundante con el copy de la pagina
```

## Densidad de contenido

Una infografia de producto no debe intentar contarlo todo.

Regla practica:

- 1 idea central
- 3 a 5 bloques maximos
- 1 flujo principal si hay proceso
- maximo 40-70 palabras visibles en la imagen para uso dentro de pagina
- si supera esa densidad, tratarla como recurso ampliable

Para piezas tecnicas densas, crear dos versiones:

- version web resumida
- version completa descargable o enlazada

## Plantilla de brief para generar una imagen

Usar esta plantilla como prompt o encargo base.

```text
Crear una infografia tecnica para QontrolMed, una suite sanitaria orientada a
gestion tecnica, revisiones de quirofano, mantenimiento preventivo, trabajo
offline en tablet e informes trazables.

Tema:
[tema concreto]

Objetivo:
[que debe entender el usuario al verla]

Publico:
[perfil principal]

Formato:
[horizontal 16:9 / vertical / captura anotada]

Estilo visual:
Sanitario, tecnico, limpio, moderno, sobrio, con fondo claro, iconografia
lineal o semiplana, paleta basada en verdes QontrolMed (#178D5B, #24564C,
#42C098), texto oscuro #334155 y espacios amplios.

Contenido obligatorio:
- [bloque 1]
- [bloque 2]
- [bloque 3]

Jerarquia:
Titulo claro, subtitulo breve si hace falta, bloques numerados o agrupados,
sin saturar la composicion.

Restricciones:
- Escribir la marca exactamente como QontrolMed.
- No incluir marcas de herramientas externas ni firmas automaticas.
- No usar imagenes de stock genericas.
- No inventar normativa, limites tecnicos o cifras no aportadas.
- Mantener todos los textos legibles.
- Evitar parrafos largos dentro de la imagen.
```

## Checklist de revision antes de insertar

### Revision tecnica

- La informacion es correcta para el ambito sanitario tratado.
- Las cifras, limites o normas citadas han sido revisadas.
- No hay conceptos inventados o ambiguos.
- No se muestran datos reales de clientes, centros, usuarios o pacientes.

### Revision editorial

- La marca aparece como `QontrolMed`.
- No hay faltas de ortografia.
- No hay frases generadas raras o poco naturales.
- El titulo explica la pieza sin depender de contexto externo.
- El texto aporta algo distinto al parrafo que la acompana en la web.

### Revision visual

- La pieza se entiende en 5 segundos.
- El contenido importante no queda en bordes recortables.
- Hay aire suficiente entre bloques.
- La paleta encaja con la web.
- En movil sigue siendo legible o se marca como imagen ampliable.

### Revision tecnica web

- Existe version optimizada para web.
- El nombre de archivo es claro y estable.
- El atributo `alt` describe la funcion de la imagen.
- Si contiene mucho texto, se ofrece contexto en HTML cercano.
- No se usa `object-fit: cover` para imagenes con texto esencial.
- Se usa `loading="lazy"` salvo en imagenes principales del primer viewport.

## Nombres de archivo

Usar nombres estables, en minusculas, sin espacios y sin acentos.

Formato recomendado:

```text
producto-[modulo]-[tema]-[version].webp
recurso-[tema]-[version].webp
captura-[modulo]-[pantalla]-[version].webp
```

Ejemplos:

```text
producto-quirofanos-flujo-informes-v1.webp
producto-preventivos-sincronizacion-v1.webp
producto-guia-tecnicos-v1.webp
recurso-seguridad-electrica-ecografos-v1.webp
captura-matriz-dashboard-v1.webp
```

## Criterio especifico para ampliar `producto.html`

La pagina de producto debe explicar la suite desde el flujo real. Las nuevas
infografias deben reforzar esta narrativa:

1. Que prepara la matriz.
2. Que se envia a tablet.
3. Como trabaja el tecnico en campo.
4. Como se valida y cierra el informe.
5. Como vuelve la informacion a sobremesa.
6. Que valor documental o legal aporta.

Orden recomendado de incorporacion:

1. Guia de uso diario para tecnicos.
2. Flujo de revisiones IT en quirofano.
3. Flujo de mantenimiento preventivo.
4. Libro de quirofano e informes mensuales.
5. Sincronizacion desktop-tablet.
6. Seguridad electrica como contexto tecnico secundario.

## Decision rapida de publicacion

Usar esta matriz:

```text
Explica directamente QontrolMed + es legible + esta revisada:
Publicar en producto.

Explica contexto sanitario + es tecnica + no depende del producto:
Publicar en recursos.

Es densa pero valiosa:
Publicar como recurso ampliable o descargable.

Tiene errores de marca, texto o normativa:
No publicar hasta corregir.

Es bonita pero no aclara nada:
No usar.
```

