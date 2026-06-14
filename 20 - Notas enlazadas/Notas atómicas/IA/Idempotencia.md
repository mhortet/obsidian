---
tags:
  - IA
  - software
  - prompt
Creado: 2026-06-14
Relacionado:
  - "[[Operations vs Tasks]]"
---
## 🔒 Idempotencia

Propiedad de una operación que produce el mismo resultado si se ejecuta múltiples veces. Evita duplicados en automatizaciones. Usa claves únicas (IDs) para deduplicación.

**Ejemplo:** Workflow crea cliente en CRM usando email como clave única. Si se ejecuta 2 veces, verifica "¿email existe?" antes de crear. Sin idempotencia = duplicados.
