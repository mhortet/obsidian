---
title: "NPC o personaje no jugador"
type: concept
status: seed
created: 2026-06-29
updated: 2026-06-29
sources: []
tags: [concepto, videojuegos, sistemas-interactivos, programacion]
review_after:
---

# NPC o personaje no jugador

NPC significa `Non-Player Character`, normalmente traducido como "personaje no jugador".

Es una entidad o personaje dentro de un sistema interactivo que no esta controlado directamente por una persona usuaria, sino por reglas del propio sistema. Aunque el termino se usa mucho en videojuegos, la idea es mas general: representa actores simulados, asistentes, enemigos, guias, comerciantes, personajes de mision o cualquier entidad que tenga presencia y comportamiento dentro de una experiencia interactiva.

## Nombre y confusion habitual

La forma correcta en ingles es `NPC`, pero es facil recordarlo u oirlo como `NCP` en conversaciones rapidas durante una partida. En Fortnite y otros juegos puede aparecer en frases del tipo "acercate a ese NPC" o "habla con ese NPC", refiriendose a un personaje del entorno controlado por el juego.

## Idea clave

Un NPC parece un personaje, pero funcionalmente suele ser una combinacion de:

- representacion visible o narrativa;
- reglas de comportamiento;
- estado interno;
- reaccion a eventos;
- condiciones de decision;
- interaccion con el usuario o jugador.

Por eso es un concepto util para entender programacion sin empezar por sintaxis: detras de un NPC hay eventos, condiciones, estados, acciones y bucles de decision.

## Ejemplos

- Un vendedor dentro de un mapa.
- Un enemigo que patrulla una zona.
- Un personaje que entrega una mision.
- Un guia que explica el siguiente paso.
- Un guardia que reacciona si alguien entra en un area.
- Un companero controlado por el sistema.
- Un asistente conversacional dentro de una simulacion.

## Logica tipica

Ejemplos simples de comportamiento:

- si el usuario se acerca, el NPC saluda;
- si el jugador tiene una llave, el NPC abre una puerta;
- si se cumple una condicion, el NPC cambia de dialogo;
- si entra alguien en una zona, el NPC lo sigue o lo evita;
- si termina una tarea, el NPC entrega una recompensa.

Estas reglas permiten introducir conceptos basicos de programacion:

- evento;
- condicion;
- estado;
- accion;
- prioridad;
- comportamiento emergente;
- prueba y ajuste.

## Ambito de uso

El termino nace y se populariza en juegos de rol y videojuegos, pero puede aplicarse de forma mas amplia a experiencias interactivas, simulaciones, mundos virtuales, formacion inmersiva, entornos educativos, agentes digitales y prototipos conversacionales.

## Relacion con Fortnite y UEFN

En el proyecto [[../../../30 - Proyectos/Aprendizaje programacion con Fortnite/README|Aprendizaje de programacion con Fortnite]], los NPCs aparecen como posible recurso educativo: permiten mostrar de forma visual que programar no es solo escribir codigo, sino definir comportamientos.

Un primer ejercicio podria consistir en crear un NPC que reaccione a una condicion sencilla, por ejemplo acercarse, activar una zona, superar una prueba o entregar un objeto.
