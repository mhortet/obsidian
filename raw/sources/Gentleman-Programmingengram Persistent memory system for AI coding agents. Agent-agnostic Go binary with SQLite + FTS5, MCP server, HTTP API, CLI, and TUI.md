---
title: "Gentleman-Programming/engram: Persistent memory system for AI coding agents. Agent-agnostic Go binary with SQLite + FTS5, MCP server, HTTP API, CLI, and TUI."
source: "https://github.com/Gentleman-Programming/engram"
author:
published:
created: 2026-06-27
description: "Persistent memory system for AI coding agents. Agent-agnostic Go binary with SQLite + FTS5, MCP server, HTTP API, CLI, and TUI. - Gentleman-Programming/engram"
tags:
  - "clippings"
---
[![Engrama: Un solo cerebro. Local o en la nube.](https://github.com/Gentleman-Programming/engram/raw/main/assets/branding/engram-banner.png)](https://github.com/Gentleman-Programming/engram/blob/main/assets/branding/engram-banner.png)

**Memoria persistente para agentes de codificación de IA**  
*. Un solo cerebro. Local o en la nube. Independiente del agente, binario único, sin dependencias.*

[Instalación](https://github.com/Gentleman-Programming/engram/blob/main/docs/INSTALLATION.md) • [Engram Cloud](https://github.com/Gentleman-Programming/engram/blob/main/docs/engram-cloud/README.md) • [Configuración del agente](https://github.com/Gentleman-Programming/engram/blob/main/docs/AGENT-SETUP.md) • [Guía del código fuente](https://github.com/Gentleman-Programming/engram/blob/main/docs/CODEBASE-GUIDE.md) • [Arquitectura](https://github.com/Gentleman-Programming/engram/blob/main/docs/ARCHITECTURE.md) • [Complementos](https://github.com/Gentleman-Programming/engram/blob/main/docs/PLUGINS.md) • [Uso en equipo](https://github.com/Gentleman-Programming/engram/blob/main/docs/TEAM-USAGE.md) • [Contribuciones](https://github.com/Gentleman-Programming/engram/blob/main/CONTRIBUTING.md) • [Documentación completa](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md)

---

> **engrama** `/ˈen.ɡræm/` — *neurociencia*: la huella física de un recuerdo en el cerebro.

Tu agente de codificación de IA lo olvida todo cuando termina la sesión. Engram le da un cerebro.

Un **binario Go** con búsqueda de texto completo SQLite + FTS5, accesible mediante CLI, API HTTP, servidor MCP y una interfaz de texto interactiva. Funciona con **cualquier agente** compatible con MCP: Claude Code, OpenCode, Gemini CLI, Codex, VS Code (Copilot), Antigravity, Cursor, Windsurf o cualquier otro.

```
Agent (Claude Code / OpenCode / Gemini CLI / Codex / VS Code / Antigravity / ...)
    ↓ MCP stdio
Engram (single Go binary)
    ↓
SQLite + FTS5 (~/.engram/engram.db)
```

## Inicio rápido

### Instalar

```
brew install gentleman-programming/tap/engram
```

Windows, Linux y otros métodos de instalación → [docs/INSTALLATION.md](https://github.com/Gentleman-Programming/engram/blob/main/docs/INSTALLATION.md)

### Configura tu agente

| Agente | Una sola línea |
| --- | --- |
| Código Claude | `claude plugin marketplace add Gentleman-Programming/engram && claude plugin install engram` |
| Pi | `engram setup pi` |
| Código abierto | `engram setup opencode` |
| Gemini CLI | `engram setup gemini-cli` |
| Códice | `engram setup codex` |
| CLI antigravedad | `engram setup antigravity-cli` |
| Windsurf | `engram setup windsurf` |
| Código Qwen | `engram setup qwen` |
| Kiro | `engram setup kiro` |
| Cursor | `engram setup cursor` |
| VS Code (Copiloto) | `engram setup vscode-copilot` |
| Código Kilo | `engram setup kilocode` |
| Cualquier otro cliente MCP | Consulte [docs/AGENT-SETUP.md](https://github.com/Gentleman-Programming/engram/blob/main/docs/AGENT-SETUP.md) |

Configuración completa por agente, protocolo de memoria y supervivencia de la compactación → [docs/AGENT-SETUP.md](https://github.com/Gentleman-Programming/engram/blob/main/docs/AGENT-SETUP.md)

**¿Qué `engram setup` hace**? Escribe los archivos de configuración y de complementos de MCP para el agente seleccionado. Tras la configuración, reinicie el agente y estará listo. No es necesario iniciar el servidor manualmente.

> **¿Debo correr yo `engram serve` o correr `engram mcp` yo mismo?**
> 
> Para la mayoría de los agentes (Claude Code, Gemini CLI, Codex, VS Code, Cursor, Windsurf), **no es necesario** ejecutarlo manualmente. El agente se inicia `engram mcp` automáticamente como un subproceso stdio de corta duración cada vez que se inicia una sesión. Nunca es necesario ejecutarlo manualmente.
> 
> `engram serve` Solo es necesario cuando un complemento utiliza la API HTTP para el seguimiento de sesiones: tanto el **complemento OpenCode** como la **extensión Pi** se comunican `engram serve` en segundo plano. `engram setup opencode` Tenga `engram setup pi` en cuenta que los complementos inician automáticamente el servidor cuando es posible. Si su entorno bloquea los procesos en segundo plano, inícielo manualmente en una terminal aparte.
> 
> ```
> engram serve   # runs on port 7437 by default; keep it running
> ```
> 
> No es necesario `engram serve` en absoluto para agentes que solo admiten stdio (Claude Code, Gemini CLI, Codex, VS Code, Cursor, Windsurf).

Sin Node.js, sin Python, sin Docker. **Un solo binario, un solo archivo SQLite.**

### Paquete Pi

Engram tiene un paquete Pi de primera clase: [`gentle-engram`](https://github.com/Gentleman-Programming/engram/blob/main/plugin/pi/README.md).

```
engram setup pi
```

Proporciona a Pi memoria persistente para proyectos, recuperación de compactación y memoria compartida con otros agentes MCP a través del mismo sistema Engram, ya sea local o en la nube. Este paquete forma parte del ecosistema de codificación de agentes de Gentleman Programming, junto con Gentle-AI, SDD, skills y Engram Cloud.

### Preguntas frecuentes sobre la configuración

**¿Cuándo necesito agregar manualmente la configuración al indicador o a los ajustes de mi agente?**

`engram setup` Cubre automáticamente el cableado de MCP. La configuración manual (añadir un fragmento de Memory Protocol a su `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, etc.) solo es necesaria si su agente olvida constantemente usar Engram después de sesiones largas o compactación de contexto. Este paso manual se denomina "opción nuclear" en la documentación detallada porque las indicaciones del sistema sobreviven a todo, incluida la compactación. Es una mejora de fiabilidad para usuarios intensivos, no un primer paso obligatorio. Consulte [Configuración del agente → Sobrevivir a la compactación](https://github.com/Gentleman-Programming/engram/blob/main/docs/AGENT-SETUP.md#surviving-compaction-recommended) para ver los fragmentos.

**¿Pueden los agentes de Docker (o agentes remotos) conectarse al MCP de Engram?**

El transporte MCP de Engram **solo admite entrada/salida estándar (stdio)**; no hay ningún punto final MCP HTTP ni de red. `engram mcp` Utiliza el protocolo MCP a través de stdin/stdout; no se puede acceder a él a través de un puerto TCP.

Si tiene agentes ejecutándose en Docker que necesitan escribir en Engram en el host, las rutas disponibles son:

- **API REST HTTP** ( `engram serve`): tenga en cuenta que `engram serve` actualmente se enlaza solo a, por lo que **no** `127.0.0.1` es accesible desde dentro de un contenedor de forma predeterminada: un contenedor no puede acceder al bucle invertido del host y aún no hay un indicador de dirección de enlace. permite que el **complemento Pi** apunte a un accesible en un host/puerto enrutable (por ejemplo ), pero eso solo funciona una vez que el servidor escucha en una interfaz que no es de bucle invertido, lo cual no es compatible hoy. La API HTTP no es el protocolo MCP; Pi lo usa para la captura de sesión y las herramientas nativas de Pi. Para Docker en este momento, prefiera la ruta stdio a continuación.`ENGRAM_URL` `engram serve` `ENGRAM_URL=http://host.docker.internal:7437 pi` `mem_*`
- **MCP de stdio** (montar el binario): la ruta más limpia para un agente en Docker que necesita herramientas MCP es montar el `engram` binario en el contenedor y dejar que el agente se inicie `engram mcp` localmente a través de stdio, apuntando `ENGRAM_DATA_DIR` a un volumen compartido con el host.

Referencia completa de variables de entorno → [DOCS.md#environment-variables](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md#environment-variables)

## Cómo funciona

```
1. Agent completes significant work (bugfix, architecture decision, etc.)
2. Agent calls mem_save → title, type, What/Why/Where/Learned
3. Engram persists to SQLite with FTS5 indexing
4. Next session: agent searches memory, gets relevant context
```

Para obtener información detallada sobre el ciclo de vida de la sesión, las claves de los temas y la gestión de la memoria, consulte [docs/ARCHITECTURE.md](https://github.com/Gentleman-Programming/engram/blob/main/docs/ARCHITECTURE.md)

## Herramientas MCP (20)

| Categoría | Herramientas |
| --- | --- |
| **Guardar y actualizar** | `mem_save`, `mem_update`, `mem_delete`,`mem_suggest_topic_key` |
| **Buscar y recuperar** | `mem_search`, `mem_context`, `mem_timeline`,`mem_get_observation` |
| **Ciclo de vida de la sesión** | `mem_session_start`, `mem_session_end`,`mem_session_summary` |
| **El conflicto está saliendo a la luz.** | `mem_judge`,`mem_compare` |
| **Revisión del ciclo de vida** | `mem_review` |
| **Servicios públicos** | `mem_save_prompt`, `mem_stats`, `mem_capture_passive`, `mem_merge_projects`, `mem_current_project`,`mem_doctor` |

Referencia completa de la herramienta con parámetros → [DOCS.md#mcp-tools-20-tools](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md#mcp-tools-20-tools)

## Interfaz de usuario del terminal

```
engram tui
```

[![Panel de control de TUI](https://github.com/Gentleman-Programming/engram/raw/main/assets/tui-dashboard.png)](https://github.com/Gentleman-Programming/engram/blob/main/assets/tui-dashboard.png) [![imagen](https://private-user-images.githubusercontent.com/6935240/550555336-0308991a-58bb-4ad8-9aa2-201c059f8b64.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODI1NjQyMjksIm5iZiI6MTc4MjU2MzkyOSwicGF0aCI6Ii82OTM1MjQwLzU1MDU1NTMzNi0wMzA4OTkxYS01OGJiLTRhZDgtOWFhMi0yMDFjMDU5ZjhiNjQucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI2MDYyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNjA2MjdUMTIzODQ5WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9NDA4ODIzM2IzMzE1NTBhOWM4YTZjMmRhM2Q3MzkxMDk2ZjJmOTE4OTBlMWU5ZmEwMDNhZDQ5NDA0ZDI5NWJkZiZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmcmVzcG9uc2UtY29udGVudC10eXBlPWltYWdlJTJGcG5nIn0.RUoFd2Wr8iBQqsf-5hUq41Q_V1z3LbDC5s_Wc8-QVw0)](https://private-user-images.githubusercontent.com/6935240/550555336-0308991a-58bb-4ad8-9aa2-201c059f8b64.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3ODI1NjQyMjksIm5iZiI6MTc4MjU2MzkyOSwicGF0aCI6Ii82OTM1MjQwLzU1MDU1NTMzNi0wMzA4OTkxYS01OGJiLTRhZDgtOWFhMi0yMDFjMDU5ZjhiNjQucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI2MDYyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNjA2MjdUMTIzODQ5WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9NDA4ODIzM2IzMzE1NTBhOWM4YTZjMmRhM2Q3MzkxMDk2ZjJmOTE4OTBlMWU5ZmEwMDNhZDQ5NDA0ZDI5NWJkZiZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmcmVzcG9uc2UtY29udGVudC10eXBlPWltYWdlJTJGcG5nIn0.RUoFd2Wr8iBQqsf-5hUq41Q_V1z3LbDC5s_Wc8-QVw0) [![Detalle de la observación de TUI](https://github.com/Gentleman-Programming/engram/raw/main/assets/tui-detail.png)](https://github.com/Gentleman-Programming/engram/blob/main/assets/tui-detail.png) [![Resultados de búsqueda de TUI](https://github.com/Gentleman-Programming/engram/raw/main/assets/tui-search.png)](https://github.com/Gentleman-Programming/engram/blob/main/assets/tui-search.png)

**Navegación**: `j/k` teclas de Vim, `Enter` para profundizar, `c` para copiar contenido al portapapeles (OSC 52), `/` para buscar, `Esc` atrás. Tema Catppuccin Mocha.

## Sincronización de Git

Comparte información de memoria entre diferentes máquinas. Utiliza fragmentos comprimidos: sin conflictos de fusión, sin archivos enormes.

La base de datos SQLite local sigue siendo la fuente de información principal. La integración en la nube es una replicación opcional.

```
engram sync                    # Export new memories as compressed chunk
git add .engram/ && git commit -m "sync engram memories"
engram sync --import           # On another machine: import new chunks
engram sync --status           # Check sync status
```

Documentación completa de sincronización → [DOCS.md](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md)

## Integración en la nube (replicación opcional)

La nube es opcional. La base de datos SQLite local sigue siendo la fuente autorizada; la nube solo ofrece replicación y acceso compartido.

**Primera ruta recomendada (humo local):**

```
docker compose -f docker-compose.cloud.yml up -d
engram cloud config --server http://127.0.0.1:18080
engram cloud enroll smoke-project
engram sync --cloud --project smoke-project
```

El modo nube siempre tiene alcance de proyecto ( `--project` es obligatorio; `engram sync --cloud --all` está bloqueado intencionalmente). `ENGRAM_CLOUD_ALLOWED_PROJECTS` Es obligatorio para `engram cloud serve` los modos de autenticación por token e inseguro. Configúrelo en `*` para permitir todos los proyectos (útil para implementaciones de desarrollo/internas): esto evita la aplicación del nombre por proyecto, pero sigue requiriendo un proyecto no vacío en cada solicitud. Los fallos conocidos de sincronización/actualización/canonización en la nube que se pueden reparar mantienen el error original visible y recomiendan el flujo `doctor` / explícito `repair` a continuación; Engram nunca aplica automáticamente la reparación desde la sincronización o la autosincronización. Para la sincronización en la nube bloqueada, `transport_failed`, o la reparación del directorio de sesión heredada, consulte [la Solución de problemas de Engram Cloud](https://github.com/Gentleman-Programming/engram/blob/main/docs/engram-cloud/troubleshooting.md). Si la sincronización en la nube permanece bloqueada después de `doctor` / `repair`, descargue el asistente de rescate y ejecute la reparación de fila exportada recomendada:

```
tools/repair-missing-session-directory.sh --apply --interactive --fix-exported <project>
engram sync --cloud --project <project>
```

`--fix-exported` Repara campos locales exportados `sessions[].directory` y `observations[]` obligatorios que aún pueden interrumpir el envío final después de que los informes estén listos. Para bloqueadores `doctor` heredados secuenciales, utilice .`sync_mutations` `tools/repair-missing-session-directory.sh --apply --interactive --all <project>`

**Después de actualizar `engram` mientras ya hay un cliente MCP en ejecución:**

```
engram setup claude-code
```

Luego, reinicie Claude Code para que recargue el subproceso MCP de Engram y actualice los archivos de configuración/ganchos. La actualización del `engram` binario en disco no reemplaza un proceso MCP de stdio que ya esté en ejecución.

**Flujo de actualización para bases de datos locales existentes** (diagnóstico → reparación → arranque → estado):

```
engram cloud upgrade doctor --project smoke-project        # read-only readiness check
engram cloud upgrade repair --project smoke-project --dry-run
engram cloud upgrade repair --project smoke-project --apply
engram cloud upgrade bootstrap --project smoke-project     # resumable enroll + push + verify
engram cloud upgrade status --project smoke-project        # stage/class/reason
```

Consulte [DOCS.md — Flujo de actualización a la nube](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md#cloud-upgrade-flow) para ver la máquina de estados completa.

Para el modo autenticado, el flujo de actualización, el comportamiento del panel de control, los códigos de motivo y los detalles completos del entorno de ejecución:

- [Página de inicio de la documentación de Engram Cloud](https://github.com/Gentleman-Programming/engram/blob/main/docs/engram-cloud/README.md)
- [Guía de inicio rápido de Engram Cloud](https://github.com/Gentleman-Programming/engram/blob/main/docs/engram-cloud/quickstart.md)
- [DOCS.md — Referencia de la interfaz de línea de comandos de la nube](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md#cloud-cli-opt-in)
- [DOCS.md — Sincronización automática en la nube](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md#cloud-autosync)

## Pasos para la prueba (Beta — Fases 2+3+4)

Pruebe las nuevas funciones de detección de conflictos de memoria de forma **totalmente independiente** de su configuración de engramas existente. Docker utiliza puertos no predeterminados, un directorio de datos independiente y un token exclusivo para la versión beta, por lo que su nube de producción `~/.engram/` permanece intacta. La limpieza se realiza con un solo comando.

**¿Qué incluye la versión beta**?

- 🔄 Sincronización en la nube de relaciones de conflicto entre máquinas
- 🔍 `engram conflicts` CLI + API HTTP para auditoría retroactiva + escaneo
- 🧠 `--semantic` Escaneo que utiliza **tu Claude Code o OpenCode CLI existente** para evaluar los candidatos a conflicto de FTS5 con razonamiento LLM — **$0 si tienes una suscripción Pro/Max/Plus**

### Configuración (4 comandos)

```
git clone https://github.com/Gentleman-Programming/engram.git engram-beta-repo
cd engram-beta-repo && git checkout feat/memory-conflict-surfacing-cloud-sync
docker compose -f docker-compose.beta.yml up -d
go build -o ./engram-beta ./cmd/engram

# Isolated env (does NOT touch ~/.engram or your prod cloud)
export ENGRAM_DATA_DIR=/tmp/engram-beta-data
export ENGRAM_CLOUD_SERVER=http://127.0.0.1:28080
export ENGRAM_CLOUD_TOKEN=beta-token-CHANGE-ME-please-32chars
mkdir -p "$ENGRAM_DATA_DIR"
```

### Casos de uso

**1️⃣ Fase 1 — Detección de conflictos al guardar (cordura)**

```
./engram-beta save \
  "Use Clean Architecture" \
  "Layers: entities, use cases, adapters." \
  --type architecture --project beta-test

./engram-beta save \
  "Use Hexagonal Architecture" \
  "Ports and adapters separate domain from infra." \
  --type architecture --project beta-test
```

✅ El segundo guardado devuelve `candidates[]` el ID del primer recuerdo.

**2️⃣ Fase 2 — Sincronización en la nube de relaciones entre máquinas**

```
./engram-beta cloud enroll beta-test
./engram-beta sync --cloud --project beta-test
./engram-beta cloud status

# Simulate a "second machine"
ENGRAM_DATA_DIR=/tmp/engram-beta-data-2 ./engram-beta cloud enroll beta-test
ENGRAM_DATA_DIR=/tmp/engram-beta-data-2 ./engram-beta sync --cloud --project beta-test
ENGRAM_DATA_DIR=/tmp/engram-beta-data-2 ./engram-beta search "Architecture"
```

✅ La "segunda máquina" sincroniza los recuerdos de la primera.

**3️⃣ Fase 3 — CLI de administración + API HTTP**

```
./engram-beta conflicts list --project beta-test
./engram-beta conflicts stats --project beta-test
./engram-beta conflicts scan --project beta-test --dry-run
./engram-beta conflicts scan --project beta-test --apply --max-insert 10

# In another terminal: ./engram-beta serve
curl -s "http://127.0.0.1:7437/conflicts?project=beta-test" | jq
```

✅ Las funciones de lista, escaneo y estadísticas devuelven datos sensatos.

**4️⃣ Fase 4 — Juez LLM semántico (la característica estrella) 🎯**

```
export ENGRAM_AGENT_CLI=claude   # or opencode

./engram-beta conflicts scan --project beta-test --semantic --apply \
  --max-semantic 5 --concurrency 3 --yes
```

✅ Your agent's LLM judges semantic similarity. **$0 if on a subscription**.

**5️⃣ The case where FTS5 finds a candidate, then the LLM judges meaning**

Lexically related candidate titles with a semantic conflict:

```
./engram-beta save \
  "Use Postgres for the user database" \
  "Postgres 15 is our SQL store for users." \
  --type architecture --project beta-test

./engram-beta save \
  "Replace the user database with MongoDB" \
  "Document store now backs the user collection. SQL is gone." \
  --type decision --project beta-test

./engram-beta conflicts scan --project beta-test --semantic --apply \
  --max-semantic 5 --yes

./engram-beta conflicts list --project beta-test --status judged
```

✅ FTS5 supplies the candidate pair through shared title terms like `user` / `database`; the LLM then judges whether it is `supersedes` / `conflicts_with`. `--semantic` does not discover totally lexically unrelated pairs on its own.

### Cleanup (zero residue)

```
docker compose -f docker-compose.beta.yml down -v
rm -rf /tmp/engram-beta-data /tmp/engram-beta-data-2 ./engram-beta
```

Your production engram is fully untouched throughout.

### Full guide + troubleshooting

→ [docs/BETA\_TESTING.md](https://github.com/Gentleman-Programming/engram/blob/main/docs/BETA_TESTING.md)

→ Report feedback: [issues with `beta-phase-2-3-4` label](https://github.com/Gentleman-Programming/engram/issues)

## CLI Reference

| Command | Description |
| --- | --- |
| `engram setup [agent]` | Install agent integration |
| `engram serve [port]` | Start HTTP API (default: 7437) |
| `engram mcp [--tools=PROFILE] [--project NAME]` | Start MCP server (stdio transport) |
| `engram tui` | Launch terminal UI |
| `engram search <query>` | Search memories |
| `engram save <title> <msg>` | Save a memory |
| `engram delete <obs_id>` | Delete an observation (soft by default; `--hard` removes permanently) |
| `engram delete session <id>` | Delete a session by ID (must have no observations) |
| `engram delete prompt <id>` | Delete a prompt by ID (permanent) |
| `engram delete project <name> [--hard]` | Cascade-delete a project: soft-deletes observations by default (`--hard` removes permanently and also removes sessions) |
| `engram timeline <obs_id>` | Chronological context |
| `engram context [project]` | Recent session context |
| `engram stats` | Memory statistics |
| `engram export [file]` | Export to JSON |
| `engram import <file>` | Import from JSON |
| `engram sync` | Git sync export/import |
| `engram conflicts <sub>` | Inspect and manage memory conflict relations |
| `engram doctor` | Run read-only operational diagnostics |
| `engram cloud <subcommand>` | Opt-in cloud config/status/enrollment + cloud runtime (`serve`) |
| `engram projects list\|consolidate\|prune` | Manage project names |
| `engram obsidian-export` | Export to Obsidian vault (beta) |
| `engram version` | Show version |

Full CLI with all flags → [docs/ARCHITECTURE.md#cli-reference](https://github.com/Gentleman-Programming/engram/blob/main/docs/ARCHITECTURE.md#cli-reference)

### Key Environment Variables

| Variable | Description | Default |
| --- | --- | --- |
| `ENGRAM_DATA_DIR` | Override data directory | `~/.engram` |
| `ENGRAM_PORT` | Override HTTP server port | `7437` |
| `ENGRAM_URL` | Point the **Pi plugin** at an existing `engram serve` instance instead of auto-starting one. Not an MCP endpoint — used by the HTTP event-capture path only. (The OpenCode plugin honors `ENGRAM_PORT` / `ENGRAM_BIN`, not `ENGRAM_URL`.) | (unset, defaults to `http://127.0.0.1:<ENGRAM_PORT>`) |
| `ENGRAM_HTTP_TOKEN` | Optional Bearer auth for local HTTP server. When set, destructive and export routes require `Authorization: Bearer <token>`. Unset = open (zero-config default). | (unset) |
| `ENGRAM_TIMEZONE` | Timezone for timestamp display in TUI and cloud dashboard (e.g. `America/New_York`). Falls back to system local when unset or invalid. | system local |
| `ENGRAM_CLOUD_AUTOSYNC` | Set to `1` to enable background autosync (also requires `ENGRAM_CLOUD_TOKEN` + `ENGRAM_CLOUD_SERVER`). | (unset) |
| `ENGRAM_CLOUD_ALLOWED_PROJECTS` | Comma-separated project allowlist for `engram cloud serve`. Use `*` to allow all projects. | (unset) |

Full environment variable reference → [DOCS.md#environment-variables](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md#environment-variables)

## Documentation

| Doc | Description |
| --- | --- |
| [Installation](https://github.com/Gentleman-Programming/engram/blob/main/docs/INSTALLATION.md) | All install methods + platform support |
| [Engram Cloud](https://github.com/Gentleman-Programming/engram/blob/main/docs/engram-cloud/README.md) | Cloud landing page, quickstart, branding, and deep links |
| [Agent Setup](https://github.com/Gentleman-Programming/engram/blob/main/docs/AGENT-SETUP.md) | Per-agent configuration + Memory Protocol |
| [Codebase Guide](https://github.com/Gentleman-Programming/engram/blob/main/docs/CODEBASE-GUIDE.md) | Guide to the repository structure, flows, and implementation landmarks |
| [Architecture](https://github.com/Gentleman-Programming/engram/blob/main/docs/ARCHITECTURE.md) | How it works + MCP tools + project structure |
| [Plugins](https://github.com/Gentleman-Programming/engram/blob/main/docs/PLUGINS.md) | OpenCode & Claude Code plugin details |
| [Comparison](https://github.com/Gentleman-Programming/engram/blob/main/docs/COMPARISON.md) | Why Engram vs claude-mem |
| [Intended Usage](https://github.com/Gentleman-Programming/engram/blob/main/docs/intended-usage.md) | Modelo mental: cómo se supone que debe usarse Engram |
| [Cerebro de obsidiana](https://github.com/Gentleman-Programming/engram/blob/main/docs/beta/obsidian-brain.md) | Exportar recuerdos como grafo de conocimiento de Obsidian (beta) |
| [Contribuyendo](https://github.com/Gentleman-Programming/engram/blob/main/CONTRIBUTING.md) | Flujo de trabajo y estándares de contribución |
| [Documentos completos](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md) | Referencia técnica completa |

> **Colaboradores del panel de control**: si modifican `.templ` archivos en `internal/cloud/dashboard/`, ejecuten `make templ` para regenerar antes de confirmar. Consulten [DOCS.md — Regeneración de la plantilla del panel de control](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md#dashboard-templ-regeneration).

## Licencia

MIT

---

**Inspirado en [claude-mem](https://github.com/thedotmack/claude-mem)**, pero independiente del agente, más simple y construido de manera diferente.

[![](https://camo.githubusercontent.com/932de38180bc22446488148870012671348aa36fbd5a421fe4df516db00152b1/68747470733a2f2f636f6e747269622e726f636b732f696d6167653f7265706f3d47656e746c656d616e2d50726f6772616d6d696e672f656e6772616d266d61783d313030)](https://github.com/Gentleman-Programming/engram/graphs/contributors)