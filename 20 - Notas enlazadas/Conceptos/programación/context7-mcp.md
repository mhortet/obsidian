---
title: "Context7 MCP"
type: process
status: active
created: 2026-06-28
updated: 2026-06-28
sources:
  - "https://github.com/upstash/context7"
  - "https://context7.com/docs/clients/codex"
  - "https://context7.com/docs/security/data-privacy"
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-herramientas-desarrollo.md"
tags: [ia, agentes, mcp, context7, documentacion, programacion]
review_after: 2026-09-28
---

# Context7 MCP

## Para que sirve

Context7 MCP es un servidor MCP orientado a dar al agente documentación técnica actualizada de librerías, frameworks y APIs. Su objetivo es reducir respuestas basadas en conocimiento antiguo del modelo, APIs inventadas o ejemplos obsoletos.

En la practica, Context7 encaja cuando el agente va a escribir o modificar código que depende de una librería concreta: Next.js, Supabase, Prisma, FastAPI, Playwright, Flet, SQLAlchemy u otras herramientas con APIs cambiantes.

## Cuando usarlo

- Al pedir código con una librería o framework que cambia rápido.
- Cuando hay duda entre versiones.
- Antes de generar configuración, middleware, autenticación, migraciones o llamadas a APIs.
- Cuando el agente devuelve código que "suena bien" pero no coincide con la versión instalada.
- Al revisar un error que podría deberse a cambios recientes de API.

No hace falta usarlo para lógica propia, refactor sencillo, lectura del repositorio local o tareas donde la documentación oficial no aporta nada.

## Implementación recomendada

### 1. Empezar en modo MCP o plugin

Según la documentación oficial de Context7 para Codex, puede configurarse con:

```bash
npx ctx7 setup --codex
```

Ese asistente autentica vía OAuth, genera una clave API y escribe configuración en `~/.codex/config.toml` y `AGENTS.md`. También existe instalación como plugin de Codex:

```bash
codex plugin marketplace add upstash/context7
codex plugin add context7@context7-marketplace
```

Para configuración manual en Codex, Context7 documenta dos opciones:

```bash
codex mcp add context7 -- npx -y @upstash/context7-mcp --api-key YOUR_API_KEY
```

O en `~/.codex/config.toml`:

```toml
[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp", "--api-key", "YOUR_API_KEY"]
startup_timeout_ms = 20_000
```

También puede usarse el servidor remoto:

```toml
[mcp_servers.context7]
url = "https://mcp.context7.com/mcp"
http_headers = { "CONTEXT7_API_KEY" = "YOUR_API_KEY" }
```

### 2. Regla de uso en agentes

Regla sugerida para `AGENTS.md` de proyectos de programacion:

```markdown
Cuando generes codigo que dependa de una libreria, framework o API externa, usa Context7 para consultar documentacion vigente. Menciona la version si importa y no asumas APIs recientes desde memoria.
```

Regla mas estricta para proyectos sanitarios:

```markdown
Antes de cambiar codigo de integraciones, autenticacion, base de datos, seguridad, informes o dependencias externas, consulta documentacion vigente con Context7 u otra fuente oficial y deja constancia de version y supuesto tecnico.
```

## Pautas para obtener mejores resultados

- Nombrar la libreria y la tarea concreta: mejor "Supabase Storage upload signed URL" que "Supabase".
- Indicar version cuando sea relevante: "Next.js 15", "Pydantic v2", "SQLAlchemy 2".
- Usar el ID de libreria si ya se conoce, por ejemplo `/vercel/next.js` o `/supabase/supabase`.
- Pedir fragmentos aplicables al problema, no explicaciones generales.
- Si la primera recuperacion no encaja, pedir otra zona de la documentacion.
- Verificar siempre contra el codigo real instalado: `package.json`, `requirements.txt`, `pyproject.toml`, lockfiles o imports.

## Proceso de uso en una tarea de codigo

1. Identificar librerias afectadas y version instalada.
2. Consultar Context7 con una pregunta orientada a la tarea.
3. Comparar la respuesta con el codigo local y patrones existentes.
4. Implementar el cambio.
5. Ejecutar pruebas o al menos una verificacion focalizada.
6. Documentar en la nota de proyecto si la decision depende de una version concreta.

## Cautelas

- Context7 no sustituye a la documentacion oficial ni a pruebas locales.
- Segun su documentacion de privacidad, Context7 no almacena codigo fuente del usuario, pero si puede almacenar documentacion indexada, ejemplos, metadatos de librerias y consultas formuladas por el cliente MCP.
- No incluir secretos, credenciales, datos de pacientes ni fragmentos internos sensibles en consultas.
- En entornos hospitalarios, usarlo para documentacion tecnica publica; no para exponer informacion interna.
- Revisar `review_after` porque las opciones de instalacion y politicas de privacidad pueden cambiar.

## Fallos frecuentes

- Instalarlo globalmente y olvidar que todos los proyectos pueden invocarlo.
- Preguntar sin version cuando el problema depende de version.
- Aceptar codigo generado sin ejecutar pruebas.
- Usarlo para justificar cambios de seguridad sin revision humana.
- Mezclar documentacion recuperada con decisiones locales no documentadas.

## Fuentes consultadas

- Repositorio oficial Context7: `https://github.com/upstash/context7`.
- Documentacion oficial para Codex: `https://context7.com/docs/clients/codex`.
- Privacidad de datos Context7: `https://context7.com/docs/security/data-privacy`.
- Fecha de revision: 2026-06-28.

## Relaciones

- [[herramientas-mcp-para-desarrollo]]
- [[model-context-protocol-mcp]]
- [[seguridad-y-gobierno-de-mcp]]
