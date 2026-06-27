---
title: "Gentleman-Programming/gentle-ai"
source: "https://github.com/Gentleman-Programming/gentle-ai"
author:
published:
created: 2026-06-27
description: "Contribute to Gentleman-Programming/gentle-ai development by creating an account on GitHub."
tags:
  - "clippings"
---
[![Banner de rosa neón de Gentle-AI](https://github.com/Gentleman-Programming/gentle-ai/raw/main/docs/assets/brand/gentle-ai-banner.png)](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/assets/brand/gentle-ai-banner.png)

## Inteligencia artificial suave

**Gentle-AI: ecosistema, marcos de trabajo y flujos de trabajo para agentes de codificación de IA.**

---

## Qué hace

Gentle-AI NO es un instalador de agentes de IA. La mayoría de los agentes son fáciles de instalar. Es un **configurador de ecosistemas**: toma cualquier agente de codificación de IA que utilices y lo potencia con memoria persistente, flujos de trabajo de desarrollo guiado por especificaciones (SDD), habilidades de codificación seleccionadas, servidores MCP, un selector de proveedores de IA, un perfil orientado a la enseñanza con permisos que priorizan la seguridad y asignación de modelos por fase para que cada paso de SDD pueda ejecutarse en un modelo diferente.

**Antes**: "Instalé Claude Code / OpenCode / Cursor, pero es solo un chatbot que escribe código."

**Después**: Tu agente ahora tiene memoria, habilidades, flujo de trabajo, herramientas MCP y una personalidad que realmente te enseña.

### 15 agentes compatibles

| Agente | Modelo de delegación | Característica clave |
| --- | --- | --- |
| **Código Claude** | Completo (Herramienta de tareas) | Subagentes, estilos de salida |
| **Código abierto** | Completo (superposición multimodo) | Enrutamiento del modelo por fase |
| **Código Kilo** | Completo (superposición multimodo) | Configuración compatible con OpenCode en `~/.config/kilo` |
| **Gemini CLI** | Completo (experimental) | Agentes de aduanas en `~/.gemini/agents/` |
| **Cursor** | Completo (subagentes nativos) | 10 agentes SDD en `~/.cursor/agents/` |
| **VS Code Copilot** | Completo (runSubagente) | Ejecución en paralelo |
| **Códice** | Agente independiente | Configuración nativa de CLI y TOML |
| **Windsurf** | Agente independiente | Modo de planificación, modo de código, flujos de trabajo nativos |
| **Antigravedad** | Agente solitario + Centro de control de misiones | Subagentes de navegador/terminal integrados |
| **Código Kimi** | Completo (agentes personalizados nativos) | Plantillas de indicaciones modulares en `~/.kimi` |
| **IDE Kiro** | Completo (subagentes nativos) | `~/.kiro/agents/` Orquestación nativa + de dirección |
| **Código Qwen** | Agentes secundarios nativos completos | Comandos de barra, `~/.qwen/commands/`, `auto_edit` modo |
| **OpenClaw** | Agente independiente | Espacio de trabajo prioritario `AGENTS.md` / `SOUL.md` con configuración global de MCP |
| **Trae** | Agente independiente | Aplicación de escritorio de ByteDance; `~/.trae/skills/` \+ Reglas específicas del sistema operativo |
| **Pi** | Completo (subagentes gestionados por paquete) | `gentle-pi` Controlar con comandos de persona/modelo + memoria de engrama |
| **Hermes** | Solo detección | Configuración YAML MCP, perfil SOUL.md; instalar manualmente primero |

> **Nota**: Este proyecto reemplaza [a Agent Teams Lite](https://github.com/Gentleman-Programming/agent-teams-lite) (actualmente archivado). Incluye todas las funcionalidades de ATL, con una instalación mejorada, actualizaciones automáticas y memoria persistente.

### Disparadores de delegación

Gentle-AI mantiene el hilo principal/orquestador con poco tráfico. Una vez que una tarea deja de ser pequeña, se espera la delegación o un límite explícito de la fase SDD, en lugar de ser opcional.

| Desencadenar | Comportamiento esperado |
| --- | --- |
| Leer más de 4 archivos para comprender un flujo | Delegar la exploración o ejecutar una fase de exploración. |
| Tocar 2 o más archivos no triviales | Utilice un solo escritor o solicite una nueva revisión antes de la finalización. |
| Confirma, envía o crea una solicitud de extracción después de realizar cambios en el código. | Realiza una nueva revisión a menos que la diferencia sea trivial (documentos/texto). |
| Directorio de trabajo actual incorrecto, accidente de worktree/git, recuperación de fusión, problema confuso de pruebas/entorno | Deténgase y realice una nueva auditoría antes de continuar. |
| Sesión larga y monolítica con complejidad creciente | Haz una pausa y delega, replanifica o justifica por qué no hacerlo. |
| Revisión adversarial de diferencias, conflictos, preparación de relaciones públicas o incidentes. | Utilice un contexto actualizado cuando la plataforma del agente lo admita. |

El objetivo no es la ceremonia. El objetivo es evitar el caos accidental, manteniendo al mismo tiempo un hilo conductor responsable y una línea de escritura coherente.

---

## Inicio rápido

### macOS / Linux

```
curl -fsSL https://raw.githubusercontent.com/Gentleman-Programming/gentle-ai/main/scripts/install.sh | bash
```

### Windows

```
scoop bucket add gentleman https://github.com/Gentleman-Programming/scoop-bucket
scoop install gentle-ai
```

### Prueba el canal beta (prueba mainantes del lanzamiento).

El canal beta compila Gentle AI directamente desde `main`, por lo que necesitas tener **Go 1.24+** instalado. Úsalo para probar cambios no publicados e informar de problemas con antelación.

**macOS / Linux**

```
curl -fsSL https://raw.githubusercontent.com/Gentleman-Programming/gentle-ai/main/scripts/install.sh | bash -s -- --channel beta
```

**Windows (PowerShell)**

```
$env:GENTLE_AI_CHANNEL="beta"; irm https://raw.githubusercontent.com/Gentleman-Programming/gentle-ai/main/scripts/install.ps1 | iex
```

Para seguir actualizando a la versión beta más adelante, ejecute `GENTLE_AI_CHANNEL=beta gentle-ai upgrade`. Para volver a la versión estable, reinstale mediante Homebrew o Scoop.

### Después de la instalación: configuración a nivel de proyecto

Una vez configurados tus agentes, abre tu agente de IA en un proyecto y ejecuta estos dos comandos para registrar el contexto del proyecto:

| Dominio | Lo que hace | Cuándo volver a ejecutar |
| --- | --- | --- |
| `/sdd-init` | Detecta la pila, las capacidades de prueba, activa el modo TDD estricto si está disponible. | Cuando tu proyecto agrega o elimina marcos de prueba, o por primera vez en un proyecto nuevo. |
| `gentle-ai skill-registry refresh` | Escanea las habilidades instaladas y las convenciones del proyecto, crea el registro. | Después de instalar/eliminar habilidades, o por primera vez en un proyecto nuevo. |

Estos **no son necesarios** para el uso básico. El orquestador SDD se ejecuta `/sdd-init` automáticamente si no detecta contexto. Los ganchos de inicio normalmente mantienen actualizado el registro de habilidades para los agentes que admiten ganchos, incluidos Codex, Claude Code, OpenCode y Pi a través de `gentle-pi`. Si inicia Pi con `pi -ns`, se omiten la carga de habilidades/ganchos de inicio, por lo que debe ejecutar la actualización del registro manualmente cuando necesite reglas de proyecto actualizadas.

Ejecútalo `gentle-ai doctor` en cualquier momento para realizar una comprobación de estado de solo lectura de tu ecosistema (binarios de herramientas `state.json`, accesibilidad de Engram, espacio en disco).

---

## Instalar

### Recomendado

```
# macOS / Linux
brew tap Gentleman-Programming/homebrew-tap
brew trust --formula gentleman-programming/tap/gentle-ai  # one-time, for Homebrew tap trust
brew install gentle-ai

# Windows
scoop bucket add gentleman https://github.com/Gentleman-Programming/scoop-bucket
scoop install gentle-ai
```
**Otros métodos de instalación** (Instalación Go)

#### Instalación de Go (cualquier plataforma con Go 1.24+)

```
go install github.com/gentleman-programming/gentle-ai/cmd/gentle-ai@latest
```

#### Windows

Utiliza Scoop en Windows. Es la ruta de instalación recomendada para mantener Gentle AI actualizado correctamente:

```
scoop bucket add gentleman https://github.com/Gentleman-Programming/scoop-bucket
scoop install gentle-ai
```

Por defecto, `gentle-ai install` escribe los archivos con ámbito de agente en el directorio de configuración global de cada agente seleccionado. Para mantener la pila de Gentleman aislada en un solo proyecto, ejecute:

```
gentle-ai install --scope=workspace
```

El ámbito del espacio de trabajo no se limita a Claude; se aplica a agentes seleccionados para archivos con ámbito de agente, como avisos del sistema, habilidades, agentes SDD y archivos de perfil. Las integraciones globales siguen siendo globales por diseño.

---

## Copias de seguridad

Cada instalación, sincronización y actualización crea automáticamente instantáneas de tus archivos de configuración. Las copias de seguridad están **comprimidas** (tar.gz), **deduplicadas** (las configuraciones idénticas no se vuelven a guardar) y **se eliminan automáticamente** (conservan las 5 más recientes). Ancla las copias de seguridad importantes mediante la interfaz de texto ( `p` tecla) para protegerlas de la eliminación.

Consulte [la Guía de copia de seguridad y reversión](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/rollback.md) para obtener más detalles.

---

## Características clave que debes conocer

### Perfiles SDD de OpenCode

Asigne diferentes modelos de IA a las distintas fases de SDD: un modelo potente para el diseño, uno rápido para la implementación y uno económico para la exploración. OpenCode utiliza **`gentle-orchestrator`** como base el sistema SDD, y los perfiles con nombre generados siguen apareciendo como `sdd-orchestrator-{name}` entradas.

```
# Via CLI
gentle-ai sync --profile cheap:openrouter/qwen/qwen3-30b-a3b:free
gentle-ai sync --profile-phase cheap:sdd-design:anthropic/claude-sonnet-4-20250514

# Or via TUI: gentle-ai → "OpenCode SDD Profiles" → Create
```

Tras crear un perfil, abre OpenCode y pulsa **la tecla Tab** para alternar entre `gentle-orchestrator` el perfil predeterminado y tu perfil personalizado.

| Lo que necesitas | Utilice esto |
| --- | --- |
| Conductor SDD predeterminado | `gentle-orchestrator` |
| Configuraciones heredadas | `sdd-orchestrator` se migra a `gentle-orchestrator` en sincronización |
| Perfiles de modelos con nombre | `sdd-orchestrator-cheap`, `sdd-orchestrator-premium`, etc. |

**Guía completa**: [Perfiles SDD de OpenCode](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/opencode-profiles.md)

### Engrama (Memoria persistente)

Tu agente de IA recuerda automáticamente las decisiones, los errores y el contexto entre sesiones. No necesitas hacer nada, pero cuando lo haces:

```
engram projects list          # See all projects with memory counts
engram projects consolidate   # Fix name drift ("my-app" vs "My-App")
engram search "auth bug"      # Find a past decision from the terminal
engram tui                    # Visual memory browser
```

**Referencia completa**: [Comandos de engramas](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/engram.md)

---

## Documentación

| Tema | Descripción |
| --- | --- |
| [Uso previsto](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/intended-usage.md) | Cómo se supone que debe usarse Gentle-AI: el modelo mental |
| [Perfiles SDD de OpenCode](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/opencode-profiles.md) | Cree y gestione perfiles de modelo por fase para OpenCode. |
| [Comandos de engramas](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/engram.md) | Comandos CLI, herramientas MCP, gestión de proyectos, trabajo en equipo |
| [Guía de la base de código](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/CODEBASE-GUIDE.md) | Mapa de responsables del mantenimiento para la propiedad del repositorio, los límites de la arquitectura y las directrices de revisión. |
| [Agentes](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/agents.md) | Agentes compatibles, matriz de características, rutas de configuración y notas por agente. |
| [Registro de habilidades](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/skill-registry.md) | Diagramas de flujo de descubrimiento de habilidades basado en índices, contrato de delegación y diagramas de uso. |
| [Agente Pi](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/pi.md) | Paquetes de Pi, comandos, perfil, asignación de modelos y solución de problemas. |
| [Componentes, habilidades y preajustes](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/components.md) | Todos los componentes, el comportamiento de GGA, el catálogo de habilidades y las definiciones predefinidas. |
| [Uso](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/usage.md) | Modos de personalidad, interfaz de texto interactiva, indicadores de línea de comandos y gestión de dependencias. |
| [Copia de seguridad y reversión](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/rollback.md) | Retención de copias de seguridad, compresión, deduplicación, fijación y restauración |
| [IDE Kiro](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/kiro.md) | Configuración específica de Kiro, rutas de configuración, subagentes nativos y comportamiento de SDD |
| [Plataformas](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/platforms.md) | Plataformas compatibles, notas sobre Windows, verificación de seguridad, rutas de configuración |
| [Arquitectura y desarrollo](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/architecture.md) | Diseño del código fuente, pruebas y relación con Gentleman.Dots |

---

## Aspectos destacados de la comunidad

Este proyecto mejora cuando la comunidad lo desarrolla y lo amplía.

### Integraciones comunitarias

- [sub-agent-statusline](https://github.com/Joaquinvesapa/sub-agent-statusline): complemento TUI opcional de OpenCode que muestra la actividad, el estado, el tiempo transcurrido y el uso de tokens/contexto de los subagentes cuando OpenCode lo expone.
- [sdd-engram-plugin](https://github.com/j0k3r-dev-rgl/sdd-engram-plugin): complemento opcional de la interfaz de usuario de OpenCode para administrar perfiles SDD y explorar memorias Engram directamente desde OpenCode, con activación de perfil en tiempo de ejecución y sin necesidad de reiniciar.

Al seleccionar OpenCode en el instalador, Gentle-AI pregunta si se desea registrar cada complemento de la comunidad y ofrece un acceso directo al navegador para revisar primero el repositorio. Gentle-AI solo verifica que `~/.config/opencode/tui.json` exista y agrega los nombres de los paquetes de los complementos a su `plugin` matriz; OpenCode instala/carga esos paquetes la próxima vez que se inicia. Una vez que OpenCode ha materializado un complemento `~/.config/opencode/node_modules/`, `gentle-ai update` puede comparar su `package.json` versión local con las versiones del complemento en GitHub.

## Colaboradores

Este proyecto existe gracias a la comunidad. Consulta [CONTRIBUTORS.md](https://github.com/Gentleman-Programming/gentle-ai/blob/main/CONTRIBUTORS.md) para ver la lista completa.

[![](https://camo.githubusercontent.com/f9ad58fdb6bfa9bf96e5741de94ea12140ecad5b0fd400b6bbf28963f8587427/68747470733a2f2f636f6e747269622e726f636b732f696d6167653f7265706f3d47656e746c656d616e2d50726f6772616d6d696e672f67656e746c652d6169)](https://github.com/Gentleman-Programming/gentle-ai/graphs/contributors)

---

## Próximos pasos

- **¿Acaba de instalarlo?** Lea el [manual de uso previsto](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/intended-usage.md): la página que explica el modelo mental.
- **¿Utilizas OpenCode?** Configura [perfiles SDD](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/opencode-profiles.md) para asignar diferentes modelos a cada fase.
- **¿Utilizas Pi?** Consulta [Pi Agent](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/pi.md) para obtener información sobre los comandos de Pi, la configuración de perfiles, la asignación de modelos y el comportamiento de los paquetes.
- **¿Quieres compartir memoria entre máquinas?** Aprende más `engram sync` en la [referencia de Engram](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/engram.md).
- **¿Listo para contribuir?** Consulta [CONTRIBUTING.md](https://github.com/Gentleman-Programming/gentle-ai/blob/main/CONTRIBUTING.md) y los [problemas abiertos](https://github.com/Gentleman-Programming/gentle-ai/issues?q=is%3Aissue+is%3Aopen+label%3A%22status%3Aapproved%22).