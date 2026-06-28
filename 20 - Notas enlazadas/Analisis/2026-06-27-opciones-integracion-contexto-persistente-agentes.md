---
title: "Opciones de integracion de contexto persistente para agentes"
type: analysis
status: active
created: 2026-06-27
updated: 2026-06-28
sources:
  - "20 - Notas enlazadas/Fuentes/2026-06-27-engram-cloud-contexto-compartido-agentes.md"
  - "20 - Notas enlazadas/Conceptos/Herramientas agenticas/contexto-persistente-para-agentes.md"
  - "raw/sources/llm-wiki.md"
tags: [ia, agentes, memoria, obsidian, mcp]
review_after: 2026-09-27
---

# Opciones de integracion de contexto persistente para agentes

## Pregunta

Que opciones de integracion tiene sentido valorar para que distintos agentes puedan acceder a un contexto personal o tecnico sin empezar de cero, y si merece la pena iniciar trabajo en esa direccion.

## Respuesta breve

Si merece la pena, pero no empezando por desplegar Engram Cloud en produccion. La mejor ruta es incremental: consolidar Obsidian como memoria canonica, crear un paquete de contexto por proyecto, probar una memoria operativa local con informacion no sensible y, solo si aporta valor real, valorar una sincronizacion self-hosted.

La idea es buena porque coincide con un dolor real: cada agente pierde continuidad cuando cambia la sesion, la maquina o la herramienta. Pero en un entorno tecnico-sanitario el riesgo no esta en la herramienta, sino en que la memoria acumule informacion sensible, errores o decisiones no revisadas.

## Opciones de integracion

### 1. Reforzar la boveda como memoria canonica

Es la opcion mas segura y ya esta en marcha. Consiste en que cualquier agente lea primero `AGENTS.md`, `00 - Sistema/Indice.md`, notas curadas y estado de proyecto antes de actuar.

Ventajas:

- No requiere nueva infraestructura.
- Es versionable con Git.
- Es auditable por humanos.
- Encaja con Obsidian y con el flujo `raw -> fuente -> concepto/sintesis/analisis`.

Limites:

- Requiere disciplina de mantenimiento.
- La recuperacion depende de busqueda textual, indice y lectura por el agente.

Uso recomendado: mantenerla como fuente de verdad principal.

### 2. Crear paquetes de contexto por proyecto

Cada proyecto vivo podria tener un archivo compacto tipo `AI_CONTEXT.md`, `estado_continuidad.md` o `contexto_agentes.md` con lo minimo que cualquier agente debe saber antes de tocarlo.

Contenido esperado:

- Proposito del proyecto.
- Arquitectura actual.
- Restricciones tecnicas.
- Decisiones vigentes.
- Riesgos conocidos.
- Comandos de prueba.
- Que no tocar sin confirmacion.

Ventajas:

- Reduce mucho el coste de arranque.
- Es facil de revisar.
- Funciona con Codex, Claude Code, OpenCode, Cursor u otros agentes.

Uso recomendado: empezar por QontrolMed y por la propia boveda.

### 3. Busqueda local sobre Markdown

Antes de una memoria nueva, se puede mejorar la recuperacion con herramientas locales: `rg`, scripts Python, indices BM25, qmd u otro buscador Markdown con MCP.

Ventajas:

- Mantiene los datos en local.
- Aprovecha el conocimiento ya escrito.
- Permite consultas rapidas sin duplicar memoria.

Limites:

- No captura automaticamente "lo aprendido" durante una sesion si no se registra.
- Puede devolver demasiado ruido si las notas no estan curadas.

Uso recomendado: fase 1 tecnica, con permisos de solo lectura al principio.

### 4. MCP propio para la boveda y proyectos

Un MCP propio podria exponer herramientas controladas a los agentes: buscar notas, leer indice, consultar estado de proyecto, localizar fuentes, listar decisiones pendientes o consultar datos tecnicos autorizados.

Ventajas:

- Da a los agentes una interfaz estable.
- Permite permisos por herramienta.
- Puede evolucionar hacia datos estructurados de QontrolMed o electromedicina.

Riesgos:

- Puede acabar exponiendo informacion sensible si no se disena con permisos minimos.
- Requiere mantenimiento y pruebas.

Uso recomendado: prototipo read-only, limitado a notas curadas y sin datos personales.

### 5. Engram local por proyecto

Probar Engram solo en local permitiria evaluar si la memoria operativa aporta algo real: decisiones recientes, preferencias tecnicas, aprendizajes de sesion y recordatorios de arquitectura.

Ventajas:

- Resuelve continuidad entre conversaciones.
- No obliga a subir datos.
- Puede convivir con Obsidian.

Riesgos:

- Puede guardar basura o informacion obsoleta.
- Puede crear una memoria paralela no auditada.
- Hay que validar madurez, seguridad y compatibilidad real.

Uso recomendado: piloto pequeno, con un proyecto no sensible y reglas claras de que se puede guardar.

### 6. Engram Cloud self-hosted

La sincronizacion entre maquinas tiene sentido si el piloto local demuestra valor. Deberia desplegarse en servidor propio con HTTPS, tokens, allowlist de proyectos, backups y logs.

Ventajas:

- Memoria compartida entre equipos y maquinas.
- Dashboard para revisar que sabe el agente.
- Diseno local-first segun la fuente.

Riesgos:

- Nueva superficie de seguridad.
- Necesidad de administracion, backup y actualizaciones.
- Posible fuga de contexto si se sincroniza lo que no toca.

Uso recomendado: no iniciar aun. Esperar a una prueba local y a una revision tecnica del repositorio.

## Recomendacion

Iniciar trabajo, si, pero con alcance limitado:

1. Definir una politica de memoria para agentes: que se puede guardar, que no, como se revisa y cuando se promociona a Obsidian.
2. Crear un `contexto_agentes.md` para la boveda y otro para QontrolMed.
3. Preparar un prototipo read-only de busqueda/consulta sobre Obsidian antes de meter sincronizacion cloud.
4. Evaluar Engram en local con informacion no sensible.
5. Decidir si Engram Cloud aporta valor solo despues de medir uso real durante varias sesiones.

El criterio de exito no deberia ser "tener memoria", sino reducir reinicios de contexto sin perder trazabilidad, privacidad ni control humano.

## Fuentes, supuestos y limites

- Basado en la fuente de Engram Cloud capturada el 2026-06-27 y en `raw/sources/llm-wiki.md`.
- No se ha verificado en esta ingesta la madurez actual del repositorio ni se ha auditado su codigo.
- En ambito sanitario, este analisis no autoriza guardar datos de pacientes, credenciales, secretos ni informacion clinica identificable en memorias de agente.
