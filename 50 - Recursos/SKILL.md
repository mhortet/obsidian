---
name: el-cuaderno-de-tu-ia
description: Monta y mantiene la memoria del usuario para su IA — un cuaderno en Markdown con índice y una nota por idea — para que no tenga que explicarle lo mismo cada día. Tres modos — montar el cuaderno con una entrevista corta, apuntar lo aprendido al final de una sesión y revisar el cuaderno para cazar notas falsas, caducadas o duplicadas. Úsala cuando el usuario diga «monta mi cuaderno», «quiero que te acuerdes de esto», «apunta», «guarda esto para la próxima vez», «revisa tu memoria» o «revisa el cuaderno».
tags:
  - aprendizaje
  - arquitectura
  - calidad
  - configuracion
  - documentacion
  - ia
  - inteligenciaartificial
Creado: 2026-11-06
Autor:
Relacionado:
---
## Resumen

## Descripción


Vas a llevar mi cuaderno: la memoria que te deja trabajar conmigo sin que te explique lo mismo cada día. Tú no recuerdas nada de una sesión a otra; lo que sabes de mí es lo que hay escrito ahí.

## Dónde vive

- Una carpeta `memoria/` en la carpeta donde trabajamos, con un `indice.md` y una nota por idea.
- En el `CLAUDE.md` de esa carpeta, esta línea (créalo si no existe, y no toques lo demás): «Al empezar, lee `memoria/indice.md` y abre las notas que toquen para la tarea. Si algo choca con lo que ves, dímelo antes de seguir.»
- Si ya tengo un `cuaderno.md` de un solo archivo, propónme pasarlo a la carpeta o seguir con él, como prefiera.

## Formato

**El índice** (`memoria/indice.md`): una línea por nota, nada más. Que no pase de unas 150 líneas; si crece, propónme agrupar.

```
- [Título corto](archivo.md) — gancho que diga cuándo hace falta abrirla
```

**Cada nota** (`memoria/<nombre-en-minusculas-con-guiones>.md`):

```
---
nombre: <nombre del archivo sin .md>
tipo: sobre-mi | correccion | proyecto | referencia
fecha: <día-mes-año de calendario, nunca «ayer» ni «el jueves»>
---
<La idea, en una o dos líneas concretas.>

Por qué: <lo que pasó o la razón. Obligatorio en las correcciones.>
Cómo aplicarlo: <cuándo y cómo se usa. Obligatorio en las correcciones.>
Comprobado: <cómo y cuándo se comprobó; si no, «sin comprobar».>
```

Tipos:
- **sobre-mi:** a qué me dedico, qué sé y qué no, cómo me gusta trabajar.
- **correccion:** cada «así no» que te diga, y también lo que salió bien y quiero que repitas.
- **proyecto:** en qué punto está cada cosa y por dónde seguir. Caduca al cerrarse.
- **referencia:** dónde está algo (carpeta, web, documento). Apunta dónde, no copies el contenido.

## Modo 1 · Montar el cuaderno

Si no existe `memoria/`, pregúntame de una en una y espera cada respuesta:
1. A qué me dedico y para qué te uso sobre todo.
2. Cómo me gusta que me respondas: tono, largo, formato.
3. Qué me saca de quicio de cómo responde una IA.
4. Qué tengo ahora entre manos y en qué punto está.
5. Algún error que ya me hayas cometido o que no quiera ver nunca.

Con eso escribe las primeras notas y el índice, enséñamelo todo y espera mi visto bueno antes de guardar. Añade la línea al `CLAUDE.md`.

## Modo 2 · Apuntar («apunta», o al cerrar una sesión)

1. Repasa la sesión: correcciones que te hice, lo que se comprobó, lo que falló, lo que quedó a medias.
2. Antes de crear una nota, busca en el índice si ya existe una sobre lo mismo. Si existe, propón actualizarla. Dos notas que se contradicen son peor que ninguna.
3. Propónme como mucho cinco cambios: los que más tiempo ahorren la próxima vez. Para cada uno, el texto exacto de la nota y la línea del índice.
4. Si algo quedó a medias, una nota de proyecto con por dónde seguir.
5. No guardes nada hasta que te diga que sí.

No apuntes:
- lo que cualquier IA ya sabe, ni lo que ya está en otro archivo (apunta dónde está);
- como comprobado lo que no se comprobó;
- contraseñas, datos bancarios ni datos personales de otras personas.

## Modo 3 · Revisar («revisa el cuaderno»)

Lee todas las notas como un auditor desconfiado. Busca:
1. Prohibiciones y «no funciona» sin fecha ni prueba, o que pudieron cambiar desde entonces. Son las más peligrosas: impiden volver a intentarlo.
2. Récords o éxitos demasiado buenos sin comprobar de otra forma.
3. Afirmaciones rotundas sin prueba.
4. Contradicciones entre notas.
5. Notas caducadas: proyectos cerrados, estados viejos, cosas que ya no se usan.
6. Duplicados.
7. Paja: notas generales o vagas.
8. Correcciones sin su porqué.
9. Notas que no están en el índice, o líneas del índice que apuntan a notas que no existen.
10. Datos que no deberían estar.

Devuélveme una tabla con cada nota con problemas: qué le pasa, cuánto daño puede hacer (alto, medio, bajo) y qué propones (mantener, reescribir, volver a probar, borrar). Para las que haya que volver a probar, la prueba concreta. No cambies nada hasta que te diga qué apruebo.

## Siempre

- Nada entra ni sale del cuaderno sin mi visto bueno.
- Si una nota choca con lo que ves al trabajar, dímelo: puede que la nota esté mal.
- No inventes funciones de mi herramienta. Si no sabes si algo se puede hacer, dímelo.
