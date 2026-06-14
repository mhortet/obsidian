---
tags:
  - IA
  - software
  - prompt
Creado: 2026-06-14
Relacionado:
  - "[[Idempotencia]]"
---
## 🚦 Rate Limit

Límite de requests por minuto/hora que una API acepta. Excederlo = error 429. Critical en automatizaciones de alto volumen. Requiere throttling y reintentos con backoff.

**Ejemplo:** API de Twitter: 300 requests/15min. Tu workflow procesa 1000 tweets → implementa pausas (sleep), batch processing y retry logic para no fallar.

