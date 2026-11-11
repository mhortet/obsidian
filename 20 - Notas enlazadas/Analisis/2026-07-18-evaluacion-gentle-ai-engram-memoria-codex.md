---
title: "Evaluación de Gentle-AI, Engram y la memoria local de Codex"
type: analysis
status: active
created: 2026-07-18
updated: 2026-07-18
sources:
  - "20 - Notas enlazadas/Fuentes/2026-06-27-engram-cloud-contexto-compartido-agentes.md"
  - "20 - Notas enlazadas/Conceptos/ia/contexto-persistente-para-agentes.md"
  - "20 - Notas enlazadas/Analisis/2026-06-27-opciones-integracion-contexto-persistente-agentes.md"
  - "https://github.com/Gentleman-Programming/gentle-ai"
  - "https://github.com/Gentleman-Programming/engram"
  - "https://learn.chatgpt.com/docs/customization/memories"
tags: [ia, agentes, memoria, mcp, seguridad]
review_after: 2026-10-18
---

# Evaluación de Gentle-AI, Engram y la memoria local de Codex

## Motivo de la evaluación

El ecosistema de Gentleman Programming resulta atractivo por su propuesta de dotar a los agentes de IA de memoria persistente, procedimientos de trabajo estructurados y herramientas abiertas que pueden ejecutarse en local.

El objetivo de esta evaluación es determinar si su instalación aporta un beneficio real en mi caso, teniendo en cuenta que mi actividad de programación no es profesional ni continua, aunque sí desarrollo proyectos personales y valoro poder conservar localmente el contexto de las interacciones con la IA.

Repositorios analizados:

- [Gentle-AI](https://github.com/Gentleman-Programming/gentle-ai)
- [Engram](https://github.com/Gentleman-Programming/engram)

## Conclusión ejecutiva

La decisión más razonable en este momento es **no instalar el ecosistema Gentle-AI completo**.

Antes de añadir herramientas externas, conviene comprobar hasta qué punto la memoria local nativa de Codex cubre la necesidad principal: conservar contexto útil entre conversaciones y mantener acceso local a las sesiones.

Si después de un periodo de uso se detectan carencias concretas —por ejemplo, necesidad de búsqueda avanzada, exportación, organización por proyectos o memoria compartida entre varios agentes— tendría sentido realizar una prueba limitada instalando **Engram de manera independiente y exclusivamente local**.

Gentle-AI completo quedaría reservado para un escenario futuro en el que se trabaje de forma frecuente en proyectos de mayor tamaño y resulte útil adoptar conscientemente su metodología SDD, sus skills, perfiles, subagentes y procesos de revisión.

> [!summary] Decisión actual
> **Primero Codex nativo; después, si existe una carencia demostrable, probar Engram; Gentle-AI completo, de momento no.**

## Qué aporta cada alternativa

| Alternativa | Aportación principal | Complejidad estimada |
|---|---|---:|
| Codex nativo | Memoria local, resúmenes y transcripciones de sesiones | Baja |
| Engram | Memoria estructurada, buscable y compartida entre agentes | Media |
| Gentle-AI | Engram más SDD, skills, perfiles, persona y flujos de revisión | Alta |

### Memoria local de Codex

La documentación actual de Codex describe una memoria local separada de la memoria de ChatGPT web. Cuando está habilitada, Codex puede extraer información útil de conversaciones anteriores y guardarla bajo su directorio local.

Las ubicaciones documentadas son:

- Memorias: `~/.codex/memories/`
- Transcripciones: `~/.codex/sessions/`
- Sesiones archivadas: `~/.codex/archived_sessions/`

La memoria se gestiona desde **Settings > Personalization > Enable memories** y, por conversación, mediante el comando `/memories`.

En la comprobación realizada el 18 de julio de 2026 no aparecía la carpeta local de memorias. Esto puede significar que la función no está habilitada, que todavía no ha generado recuerdos o que aún no está expuesta en la versión, cuenta o despliegue concreto de la aplicación. Por tanto, debe verificarse en la configuración antes de asumir que está disponible.

Documentación oficial:

- [Memories en Codex](https://learn.chatgpt.com/docs/customization/memories)
- [Configuración y estado local de Codex](https://learn.chatgpt.com/docs/config-file/config-advanced#config-and-state-locations)

### Engram

Engram es una aplicación escrita principalmente en Go que almacena recuerdos en una base SQLite local con búsqueda de texto completo. Se comunica con Codex mediante MCP.

Su utilidad principal no es conservar una copia exacta de cada conversación, sino registrar información seleccionada y estructurada, como:

- Decisiones técnicas.
- Errores y sus soluciones.
- Descubrimientos relevantes.
- Cambios de configuración.
- Resúmenes de sesiones y contexto de proyecto.

Sus ventajas más claras son la búsqueda, la línea temporal, la exportación, la interfaz TUI y la posibilidad de compartir la misma memoria entre diferentes agentes compatibles.

Sin embargo, en Codex su fiabilidad depende en parte de que el agente siga las instrucciones de memoria y llame a las herramientas `mem_*` cuando corresponde. Por ello, no debe considerarse un registrador automático e infalible de todas las interacciones.

### Gentle-AI

Gentle-AI no instala una inteligencia artificial local. Es una capa de configuración que modifica y amplía agentes existentes mediante:

- Engram como memoria persistente.
- Desarrollo guiado por especificaciones (SDD).
- Skills y servidores MCP.
- Perfiles, instrucciones y personalidad.
- Flujos de delegación, verificación y revisión.

Es una propuesta potente para usuarios que desarrollan con frecuencia y quieren adoptar un método de trabajo muy estructurado. En un uso ocasional puede aumentar la carga de configuración, el número de instrucciones y el mantenimiento sin proporcionar una mejora proporcional.

## Criterios para reconsiderar Engram

Engram tendría sentido si se cumplen varias de estas condiciones:

- Se utilizan dos o más agentes de IA de manera habitual.
- Se retoman proyectos después de semanas o meses.
- Es necesario recordar por qué se tomó una decisión técnica.
- Se desea buscar, revisar o exportar recuerdos fuera de Codex.
- La memoria nativa de Codex resulta insuficiente o poco controlable.
- Se acepta mantener y actualizar una herramienta adicional.

Si solo se utiliza Codex, se trabaja en pocos proyectos personales y el historial de la aplicación permite retomar el trabajo sin dificultad, la instalación probablemente no compense.

## Aspectos técnicos y de mantenimiento

En el sistema evaluado se observó lo siguiente:

- Git está instalado.
- Go no está instalado.
- No se encontró un `config.toml` creado manualmente en las rutas habituales consultadas.
- Se utiliza la aplicación de escritorio de Codex para Windows.

La documentación de Engram y la documentación oficial de Codex no son completamente coincidentes respecto a la ubicación de `config.toml` en Windows. Antes de realizar una integración habría que utilizar como referencia la ruta que abra la propia aplicación mediante **Settings > Configuration > Open config.toml**.

Engram advierte además de que sus binarios precompilados para Windows no están firmados y pueden provocar falsos positivos del antivirus. La alternativa de compilarlo localmente requiere instalar Go, lo que añade una dependencia que actualmente no existe en el equipo.

Para cualquier instalación futura deberían aplicarse estas precauciones:

1. Utilizar únicamente una versión estable etiquetada.
2. Evitar ramas beta o instalaciones desde `main`.
3. Descargar y revisar el script antes de ejecutarlo, en lugar de canalizarlo directamente a PowerShell.
4. Verificar el checksum del binario.
5. Hacer copia de seguridad de la configuración de Codex.
6. Empezar en un proyecto de prueba y con alcance limitado.
7. No habilitar inicialmente Engram Cloud, autosync ni sincronización mediante Git.
8. Confirmar que la desinstalación restaura correctamente la configuración anterior.

## Privacidad y ámbito sanitario

Que la base de datos se almacene localmente no significa que se esté utilizando un modelo de IA local.

Cuando Codex recupera un recuerdo para utilizarlo en una respuesta, su contenido puede incorporarse al contexto procesado por el servicio de IA. Por ello, la memoria local no debe interpretarse como garantía de que la información nunca sale del equipo.

No deberían almacenarse en estas memorias:

- Datos identificativos de pacientes.
- Información clínica real.
- Credenciales o tokens.
- Cadenas de conexión.
- Secretos incluidos en código o archivos de configuración.

En proyectos sanitarios, cualquier uso con información real requeriría previamente autorización organizativa, evaluación de protección de datos y medidas técnicas acordes con la sensibilidad de la información.

## Hoja de ruta recomendada

### Fase 1 — Codex nativo

1. Revisar **Settings > Personalization**.
2. Comprobar si aparece **Enable memories**.
3. Probar `/memories` en una conversación.
4. Utilizarlo únicamente con un proyecto no sensible.
5. Evaluar durante varias semanas si conserva adecuadamente decisiones y contexto.

### Fase 2 — Engram, solo si existe una necesidad

Si la memoria nativa no resulta suficiente:

1. Revisar nuevamente la documentación y la versión estable disponible.
2. Hacer una instalación aislada de Engram, sin Gentle-AI.
3. Mantener todos los datos en local y sin sincronización.
4. Probar búsqueda, recuperación y organización por proyectos.
5. Decidir su permanencia basándose en utilidad real, no solo en posibilidades teóricas.

### Fase 3 — Gentle-AI

Solo tendría sentido si aumenta claramente la frecuencia o complejidad del desarrollo y se desea adoptar su metodología de manera deliberada. En ese caso, la instalación debería comenzar con una previsualización (`--dry-run`), alcance de workspace y una configuración neutral o personalizada.

## Decisión revisable

La no instalación actual no supone descartar el ecosistema. Evita añadir complejidad antes de demostrar que existe una necesidad que las capacidades nativas de Codex no pueden resolver.

El criterio de implantación será, por tanto:

> **Instalar una herramienta únicamente cuando resuelva una carencia observada y recurrente, no solo porque ofrezca una arquitectura atractiva.**

## Notas relacionadas

- [[contexto-persistente-para-agentes]]
- [[2026-06-27-opciones-integracion-contexto-persistente-agentes]]
- [[2026-06-27-engram-cloud-contexto-compartido-agentes]]
