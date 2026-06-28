---
title: "Semgrep MCP"
type: process
status: active
created: 2026-06-28
updated: 2026-06-28
sources:
  - "https://github.com/semgrep/semgrep"
  - "https://github.com/semgrep/mcp"
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-herramientas-desarrollo.md"
tags: [ia, agentes, mcp, semgrep, seguridad, sast, programacion]
review_after: 2026-09-28
---

# Semgrep MCP

## Nota de nombre

La fuente cruda previa transcribia "Sengrab" o "Seng Grip", pero la herramienta correcta es Semgrep. En esta boveda se normaliza como `Semgrep MCP`.

## Para que sirve

Semgrep MCP permite que un agente de IA ejecute analisis Semgrep desde el flujo de trabajo de programacion. Semgrep es una herramienta de analisis estatico que busca patrones semanticos en codigo para detectar vulnerabilidades, errores, malas practicas y reglas de estilo o arquitectura.

El valor no es que la IA "opine" sobre seguridad, sino que pueda apoyarse en un motor determinista de analisis y devolver hallazgos accionables dentro del contexto de trabajo.

## Estado y vigencia

La informacion debe tratarse como temporal. A fecha 2026-06-28:

- El repositorio principal `semgrep/semgrep` indica que Semgrep MCP forma parte del ecosistema oficial y que se puede iniciar localmente con `semgrep mcp`.
- El repositorio historico `semgrep/mcp` aparece archivado y avisa que las actualizaciones se realizan mediante el repositorio/binario oficial de `semgrep`.
- La documentacion historica del repo archivado aun muestra ejemplos con `uvx semgrep-mcp`, Docker y transporte `stdio`, `streamable-http` o `sse`.

Criterio practico: preferir la via oficial actual `semgrep mcp` cuando la instalacion local de Semgrep lo soporte. Usar ejemplos antiguos solo para entender integraciones o como fallback verificado.

## Cuando usarlo

- Antes de aceptar codigo generado por IA que toca autenticacion, permisos, SQL, serializacion, subida de archivos, rutas web o procesamiento de entradas de usuario.
- En revisiones de PR o antes de commit.
- Para crear reglas Semgrep propias que reflejen normas locales.
- Para detectar secretos, patrones inseguros o APIs prohibidas.
- Para reforzar proyectos Python, JavaScript/TypeScript, Go, Java, PHP, Ruby, Terraform, YAML, Dockerfile y otros lenguajes soportados por Semgrep.

No debe usarse como unica barrera de seguridad ni como sustituto de revision humana.

## Implementacion recomendada

### 1. Instalar y validar Semgrep

Instalar Semgrep por el metodo adecuado del entorno:

```bash
uv tool install semgrep
```

O, segun entorno:

```bash
pipx install semgrep
brew install semgrep
docker pull semgrep/semgrep:latest
```

Verificar:

```bash
semgrep --version
semgrep --config=p/ci .
```

Para evitar telemetria de reglas de registry cuando proceda:

```bash
semgrep --metrics=off --config=p/ci .
```

### 2. Arrancar MCP local

Via preferente segun repo principal:

```bash
semgrep mcp
```

Si el cliente MCP necesita un comando en configuracion, usar Semgrep local como servidor del proyecto. Validar la sintaxis exacta con la version instalada porque la documentacion ha migrado.

Ejemplo historico con `uvx` visto en el repositorio archivado:

```json
{
  "mcpServers": {
    "semgrep": {
      "command": "uvx",
      "args": ["semgrep-mcp"]
    }
  }
}
```

Este ejemplo debe tratarse como fallback, no como referencia principal permanente.

### 3. Configuracion por proyecto

Crear una politica minima:

```yaml
# .semgrep.yml
rules:
  - id: no-subprocess-shell-true
    message: "Evitar shell=True salvo justificacion explicita."
    languages: [python]
    severity: WARNING
    pattern: subprocess.$FUNC(..., shell=True, ...)
```

Y ejecutar:

```bash
semgrep --config=.semgrep.yml .
```

Para proyectos sanitarios, empezar con reglas informativas antes de bloquear CI.

## Proceso recomendado de uso con agente

1. El agente modifica codigo.
2. El agente ejecuta Semgrep MCP o Semgrep CLI sobre los archivos afectados.
3. El agente resume hallazgos separando:
   - vulnerabilidad probable,
   - mala practica,
   - falso positivo,
   - pendiente de revision humana.
4. El agente propone cambios, pero no aplica fixes masivos sin confirmacion.
5. Se ejecutan pruebas del proyecto.
6. Si la regla es nueva o local, se documenta en el proyecto.

## Pautas de reglas utiles

- Prohibir APIs peligrosas: `eval`, `exec`, `pickle.loads`, `subprocess` con `shell=True`.
- Detectar SQL construido por concatenacion.
- Detectar rutas o nombres de archivo derivados directamente de entrada de usuario.
- Exigir parametros seguros en cookies y sesiones.
- Detectar credenciales hardcodeadas.
- Vigilar deserializacion insegura.
- Codificar convenciones locales: por ejemplo, no tocar tablas productivas desde scripts exploratorios.
- Crear reglas de arquitectura: no acceder a base de datos desde capa UI, no mezclar logica de negocio con formularios, no saltarse servicios compartidos.

## Criterio sanitario

En software sanitario o tecnico-sanitario, Semgrep MCP puede ayudar a detectar riesgos tempranos, pero sus resultados no convierten el codigo en validado. Para sistemas que afecten mantenimiento, compras, calidad, seguridad electrica, informes o asistencia:

- Usar Semgrep como control complementario.
- Guardar version de reglas y fecha de escaneo cuando el resultado forme parte de una decision.
- No enviar codigo sensible a servicios remotos sin base clara y autorizacion.
- Preferir escaneo local para repositorios internos.
- Revisar manualmente cualquier hallazgo que afecte seguridad, privacidad o continuidad.

## Riesgos y limites

- Semgrep Community Edition puede tener falsos positivos y falsos negativos.
- Las reglas genericas no conocen las convenciones locales.
- Un agente puede sobrerreaccionar y hacer cambios innecesarios si no se le exige justificar hallazgos.
- La configuracion MCP ha cambiado: revisar documentacion oficial antes de automatizar.
- Un scanner no sustituye tests, type checking, revision de arquitectura ni threat modeling.

## Fuentes consultadas

- Repositorio oficial Semgrep: `https://github.com/semgrep/semgrep`.
- Repositorio historico Semgrep MCP: `https://github.com/semgrep/mcp`.
- Fecha de revision: 2026-06-28.

## Relaciones

- [[herramientas-mcp-para-desarrollo]]
- [[seguridad-y-gobierno-de-mcp]]
- [[model-context-protocol-mcp]]
