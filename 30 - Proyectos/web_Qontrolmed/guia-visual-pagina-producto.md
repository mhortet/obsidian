---
tags:
  - programacion
  - qontrolmed
  - obsidian
Creado:
Relacionado:
---

# Guia visual para la pagina de producto de QontrolMed

## Objetivo

Este documento recoge las imagenes, capturas e infografias que conviene
preparar para completar `producto.html`.

La pagina ya explica correctamente la propuesta funcional, pero necesita mas
evidencia visual en su zona central. El objetivo no es decorarla, sino ayudar a
que un responsable tecnico entienda con rapidez:

1. que aplicaciones componen QontrolMed;
2. como se prepara el trabajo desde sobremesa;
3. como trabaja el tecnico en campo;
4. como vuelve la informacion a la matriz;
5. que documento y trazabilidad se obtienen al final.

Esta guia complementa los criterios generales definidos en
`docs/infografias-producto.md`.

## Diagnostico de la pagina actual

| Seccion | Estado visual | Valor actual | Necesidad |
| --- | --- | --- | --- |
| Hero de producto | Cubierta | Nueva imagen de identificacion de la suite | Mantener y revisar solo si cambia la marca |
| Suite | Solo texto | Explica matriz, Preventivos y Quirofanos | Añadir capturas reales de los tres entornos |
| Flujo operativo | Solo texto | Describe cinco pasos de principio a fin | Crear una infografia horizontal del flujo |
| Capacidades clave | Solo texto | Resume seis decisiones de producto | Añadir iconografia lineal coherente |
| Resultado documental | Imagen real disponible | Muestra un informe de quirofano | Sustituir por una captura mas limpia y anotada |
| Material visual | Listado de recomendaciones | Sirve como inventario provisional | Convertirlo despues en galeria o casos visuales |
| Contacto | No necesita imagen | Cierre comercial claro | Mantener limpio |

## Principio de produccion

No todas las piezas deben generarse con IA.

### Usar capturas reales para

- pantallas de la aplicacion matriz;
- formularios de Preventivos y Quirofanos;
- importaciones y exportaciones;
- configuracion de maestros y plantillas;
- estados de informes;
- documentos PDF terminados.

Las capturas deben prepararse con datos de demostracion. No deben mostrar
pacientes, usuarios reales, hospitales identificables, rutas personales,
credenciales ni informacion comercial sensible.

### Usar infografias o composiciones generadas para

- arquitectura matriz + tablet;
- recorrido del dato;
- relacion entre modulos;
- sincronizacion offline;
- resumen visual de trazabilidad.

Una infografia puede simplificar el proceso, pero no debe simular una pantalla
real inexistente.

### Usar SVG o CSS para

- iconos de las tarjetas de capacidades;
- flechas y conectores sencillos;
- estados como preparado, en campo, validado y cerrado;
- pequeños recursos decorativos repetidos.

Estos elementos conviene que sean deterministas, ligeros y faciles de mantener,
en lugar de formar parte de una imagen rasterizada.

## Inventario priorizado de piezas

### P01. Flujo completo de QontrolMed

**Prioridad:** critica.

**Seccion:** `#flujo`.

**Objetivo:** convertir los cinco pasos ya explicados en la pagina en un
recorrido que pueda entenderse en pocos segundos.

**Contenido:**

1. Preparacion de maestros y plantillas en la matriz.
2. Exportacion validada hacia tablet.
3. Trabajo offline del tecnico.
4. Importacion de resultados cerrados.
5. Revision y generacion documental.

**Tratamiento recomendado:** infografia horizontal con una linea de proceso.
La aplicacion de escritorio debe aparecer al principio y al final; la tablet,
en el centro. Usar iconos de paquete de datos, validacion, trabajo tecnico y
documento PDF.

**Texto dentro de la imagen:** solo los nombres breves de los cinco pasos.
El detalle debe permanecer en HTML.

**Formato:**

- maestro: 1920 x 1080 px;
- web: WebP de 1600 x 900 px;
- peso objetivo: menos de 250 KB;
- legible en movil mediante apilado HTML o apertura ampliada.

**Nombre propuesto:**

`producto-flujo-matriz-tablet-informe-v1.webp`

**Alt propuesto:**

`Flujo de QontrolMed desde la preparacion en la matriz hasta el informe final`

---

### P02. Vista real de los tres modulos de sobremesa

**Prioridad:** critica.

**Seccion:** `#suite`.

**Objetivo:** demostrar que Gestion, Quirofanos y Preventivos son modulos reales
y diferenciados, no solo conceptos comerciales.

**Contenido:**

- portada real de Gestion;
- portada real de Quirofanos;
- portada real de Preventivos;
- una etiqueta breve por modulo.

**Tratamiento recomendado:** composicion de tres capturas reales, alineadas y
recortadas con el mismo tamaño. Se pueden mostrar dentro de marcos de ventana
muy discretos.

**Fuentes ya disponibles en MaxGestH:**

- `docs/Manual/capturas/compras_menu.png`;
- `docs/Manual/capturas/quirofanos_menu.png`;
- `docs/Manual/capturas/preventivos_menu.png`.

Antes de publicar, conviene repetir las capturas con la version actual de la
aplicacion, datos de demostracion y una resolucion mayor.

**Formato:**

- horizontal 16:9;
- PNG maestro para conservar la interfaz;
- WebP de 1600 px para la web;
- sin `object-fit: cover`.

**Nombre propuesto:**

`captura-matriz-modulos-principales-v1.webp`

**Alt propuesto:**

`Pantallas de los modulos Gestion, Quirofanos y Preventivos de QontrolMed`

---

### P03. Preventivos: trabajo completo en tablet

**Prioridad:** alta.

**Seccion:** tarjeta `Preventivos en tablet` o futura subseccion propia.

**Objetivo:** enseñar como se ejecuta una revision preventiva fuera de la
aplicacion de escritorio.

**Contenido obligatorio:**

- identificacion del equipo;
- campaña o contexto de trabajo, cuando aplique;
- lista de puntos de control;
- estados o resultados;
- observaciones;
- accion de guardado o cierre.

**Tratamiento recomendado:** captura real en horizontal de tablet. Añadir como
maximo tres llamadas:

1. equipo y contexto;
2. puntos de control;
3. cierre del informe.

**Evitar:** una captura vertical estrecha en la que no se entienda el formulario
completo.

**Formato:**

- PNG maestro;
- WebP de 1400 a 1600 px;
- relacion aproximada 16:10 o 4:3;
- version sin anotaciones conservada como fuente.

**Nombre propuesto:**

`captura-preventivos-tablet-informe-v1.webp`

**Alt propuesto:**

`Formulario de mantenimiento preventivo de QontrolMed para trabajo en tablet`

---

### P04. Quirofanos: revision mensual en campo

**Prioridad:** alta.

**Seccion:** tarjeta `Revisiones IT en quirofano` o futura subseccion propia.

**Objetivo:** conectar QontrolMed con su uso sanitario mas especializado.

**Contenido obligatorio:**

- hospital de demostracion;
- quirofano o sala;
- periodo de revision;
- equipo de medida;
- tabla o listado de puntos;
- resultado y observaciones;
- estado del informe.

**Tratamiento recomendado:** captura real de tablet o composicion formada por
una captura principal y un detalle ampliado de un punto de control.

**Restricciones:**

- no inventar limites de medida;
- no incluir referencias normativas si no han sido revisadas;
- no mostrar un centro sanitario real sin autorizacion.

**Formato:**

- PNG maestro;
- WebP de 1400 a 1600 px;
- relacion 16:10 o 4:3.

**Nombre propuesto:**

`captura-quirofanos-tablet-revision-mensual-v1.webp`

**Alt propuesto:**

`Revision mensual de quirofano realizada con QontrolMed en tablet`

---

### P05. Importacion y exportacion validadas

**Prioridad:** alta.

**Seccion:** entre `#suite` y `#flujo`, o como apoyo visual del paso 02 y 04.

**Objetivo:** transmitir robustez en el intercambio entre escritorio y campo.

**Contenido:**

- paquete preparado en la matriz;
- validacion antes de importar;
- conteo de registros o informes;
- confirmacion de operacion;
- rechazo claro de un archivo incorrecto, solo si es util para explicar el
  control.

**Tratamiento recomendado:** comparativa de dos o tres estados reales:

`Preparado` -> `Validado` -> `Importado`.

El grafico debe explicar control del proceso, no sugerir sincronizacion
permanente en tiempo real.

**Formato:**

- horizontal 16:9;
- captura anotada o composicion hibrida;
- WebP de 1600 x 900 px.

**Nombre propuesto:**

`producto-sincronizacion-validada-v1.webp`

**Alt propuesto:**

`Proceso validado de exportacion e importacion entre QontrolMed y la tablet`

---

### P06. Informe final anotado

**Prioridad:** alta.

**Seccion:** `Resultado documental`.

**Objetivo:** mejorar la imagen actual `informe_quirofano.png` y demostrar la
calidad de la salida.

**Contenido recomendado:**

- cabecera e identificacion del informe;
- sala, periodo y equipo;
- resultados y estados;
- observaciones;
- identificacion o firma de cierre, si forma parte del documento real.

**Tratamiento recomendado:** mostrar una pagina completa y dos ampliaciones
laterales. Usar un maximo de tres llamadas:

1. identificacion;
2. resultado tecnico;
3. trazabilidad de cierre.

**Formato:**

- captura desde el PDF original, no fotografia;
- PNG maestro a 2x;
- WebP de 1200 a 1600 px;
- mantener el documento completo sin recorte destructivo.

**Nombre propuesto:**

`captura-informe-quirofano-anotado-v1.webp`

**Alt propuesto:**

`Informe tecnico de quirofano generado por QontrolMed con resultados y cierre`

---

### P07. Gobierno del dato: usuarios, permisos y maestros

**Prioridad:** media-alta.

**Seccion:** modulo de aplicacion matriz o capacidad `Contratos de datos
controlados`.

**Objetivo:** demostrar que la suite no se limita a rellenar formularios.

**Contenido posible:**

- usuarios nominales;
- permisos por funcion;
- catalogos de equipos;
- plantillas y puntos de control;
- centros o configuracion operativa.

**Tratamiento recomendado:** elegir una sola idea central. La primera pieza
deberia centrarse en usuarios y permisos; una segunda, si hace falta, en
plantillas y puntos.

**Fuente ya disponible en MaxGestH:**

- `docs/Manual/capturas/configuracion_usuarios.png`.

**Formato:**

- captura real anotada;
- 3:2 o 16:9;
- WebP de 1400 px.

**Nombre propuesto:**

`captura-matriz-usuarios-permisos-v1.webp`

**Alt propuesto:**

`Configuracion de usuarios y permisos nominales en QontrolMed`

---

### P08. Trazabilidad de estados de un informe

**Prioridad:** media.

**Seccion:** capacidad `Trazabilidad de informes`.

**Objetivo:** explicar como evoluciona un trabajo sin depender de un parrafo.

**Estados propuestos:**

`Preparado` -> `En curso` -> `Cerrado en campo` -> `Importado` ->
`Revisado` -> `Emitido`.

Los nombres definitivos deben coincidir con los estados reales del producto.

**Tratamiento recomendado:** linea temporal compacta con iconos SVG y una
captura real pequeña como apoyo. No debe convertirse en una segunda version de
la infografia P01: esta pieza se centra en el estado documental, no en los
dispositivos.

**Formato:**

- preferiblemente SVG integrado en HTML;
- alternativa WebP de 1600 x 700 px;
- fondo transparente o blanco.

**Nombre propuesto:**

`producto-estados-trazabilidad-informe-v1.svg`

**Alt propuesto:**

`Estados de trazabilidad de un informe tecnico en QontrolMed`

---

### P09. Iconografia para capacidades clave

**Prioridad:** media.

**Seccion:** `Capacidades clave`.

**Objetivo:** facilitar el escaneo visual de las seis tarjetas sin añadir
fotografias ni infografias pesadas.

**Iconos necesarios:**

| Capacidad | Concepto visual |
| --- | --- |
| Offline first | tablet con estado local o nube desconectada |
| Contratos de datos | paquete estructurado con marca de validacion |
| Trazabilidad | linea temporal o historial |
| Modelo alineado | dos bases o capas conectadas |
| Entorno sanitario | quirofano o equipo electromedico simplificado |
| Base para crecer | modulos conectables o grafico ascendente sobrio |

**Tratamiento recomendado:**

- SVG lineal;
- trazo uniforme;
- tamaño visual de 28 a 36 px;
- verdes QontrolMed con un solo acento secundario;
- sin texto dentro del icono.

**Nombre de carpeta propuesto:**

`assets/icons/producto/`

---

### P10. Libro de quirofano e historico mensual

**Prioridad:** media-baja.

**Seccion:** futura ampliacion despues del resultado documental.

**Objetivo:** mostrar continuidad entre revisiones individuales y seguimiento
historico.

**Contenido:**

- selector de periodo;
- salas incluidas;
- estado mensual;
- acceso al libro o documento consolidado;
- historico sin datos reales.

**Tratamiento recomendado:** captura real de sobremesa acompañada por una
miniatura del documento consolidado.

**Formato:**

- horizontal 16:9;
- WebP de 1600 x 900 px.

**Nombre propuesto:**

`captura-quirofanos-libro-historico-v1.webp`

**Alt propuesto:**

`Libro de quirofano e historico mensual gestionados desde QontrolMed`

## Orden de trabajo recomendado

### Fase 1. Narrativa principal

Preparar estas piezas antes de ampliar la pagina con mas texto:

1. P01. Flujo completo de QontrolMed.
2. P02. Vista real de los tres modulos.
3. P03. Preventivos en tablet.
4. P04. Quirofanos en tablet.
5. P06. Informe final anotado.

Con estas cinco piezas la pagina ya mostraria producto, operativa de campo y
resultado.

### Fase 2. Confianza tecnica

6. P05. Importacion y exportacion validadas.
7. P07. Usuarios, permisos y maestros.
8. P08. Estados y trazabilidad.
9. P09. Iconografia de capacidades.

### Fase 3. Profundidad funcional

10. P10. Libro de quirofano e historico.
11. Capturas adicionales de campañas preventivas.
12. Comparativas o casos de uso por perfil profesional.

## Integracion prevista en la pagina

Cuando las piezas esten listas, la estructura visual recomendada seria:

1. Hero actual con la imagen de identificacion.
2. Seccion Suite con P02.
3. Bloque Preventivos con P03.
4. Bloque Quirofanos con P04.
5. Flujo operativo con P01.
6. Capacidades con P09.
7. Sincronizacion validada con P05.
8. Resultado documental con P06.
9. Trazabilidad o historico con P08 o P10.
10. Contacto.

La seccion actual `Capturas recomendadas` debe considerarse provisional. Cuando
existan las piezas, conviene sustituirla por una de estas opciones:

- galeria de pantallas reales;
- casos de uso;
- recorrido visual por modulo;
- recursos ampliables.

No deberia mantenerse indefinidamente como una lista interna de imagenes que
faltan.

## Ficha de produccion por imagen

Usar esta ficha antes de preparar cada recurso:

```text
Codigo:
P01 / P02 / ...

Titulo:

Seccion de producto:

Objetivo:

Tipo:
Captura real / Captura anotada / Infografia / SVG / Composicion hibrida

Fuente:

Datos de demostracion utilizados:

Contenido obligatorio:

Texto exacto dentro de la imagen:

Elementos que no deben aparecer:

Formato maestro:

Formato web:

Nombre de archivo:

Texto alternativo:

Estado:
Pendiente / Capturada / Diseñada / Revisada tecnicamente / Optimizada / Publicada
```

## Lista de comprobacion

### Producto

- La imagen explica una funcion real de QontrolMed.
- Los nombres de modulos y estados coinciden con la aplicacion.
- No se presentan como disponibles funciones que aun no lo estan.
- La imagen no confunde transferencia por archivos con sincronizacion en
  tiempo real.

### Seguridad y privacidad

- No aparecen datos de pacientes.
- No aparecen nombres o credenciales de usuarios reales.
- No aparecen hospitales o clientes sin autorizacion.
- No se muestran rutas locales, claves, direcciones internas ni configuracion
  sensible.

### Marca y texto

- La marca se escribe siempre `QontrolMed`.
- Se revisan tildes, mayusculas y nombres funcionales.
- No aparece ninguna marca de la herramienta utilizada para generar la pieza.
- Los textos dentro de la imagen son breves.

### Calidad web

- Existe un original sin anotaciones cuando se trata de una captura.
- Existe una version WebP optimizada.
- El contenido sigue siendo comprensible al reducir la imagen.
- No se usa `object-fit: cover` si puede cortar informacion.
- El HTML cercano explica el contenido esencial.
- El atributo `alt` describe la finalidad de la pieza.

## Siguiente pieza aconsejada

La siguiente imagen que mas mejoraria la pagina es **P01. Flujo completo de
QontrolMed**.

La cabecera actual ya identifica la suite. El mayor salto de calidad vendria de
mostrar visualmente el recorrido:

`Matriz -> exportacion -> tablet offline -> importacion -> informe`.

Despues conviene preparar P03 y P04 con capturas reales, porque son las piezas
que aportaran mayor credibilidad al uso de campo.
