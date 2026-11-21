---
title: "Cierre de la fase portátil"
type: state
status: completed
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../../02_planes_y_arquitectura/PLAN-FASE-PORTATIL-2026-11-20.md"
tags: [qontrolmed, sesion, portatil, rc]
review_after: 2026-11-28
---

# Sesión 2026-11-21: cierre de la fase portátil
[[masgesth]]

## Objetivo y motivo

Incorporar a la fuente de verdad el resultado depurado de la preparación del
portátil y cerrar esa fase antes de planificar el trabajo en sede.

## Punto seguro y límites

- Rama observada: `codex/produccion-readiness`.
- Se preservaron los cambios locales existentes.
- No se conectó con `srv-mm-01` ni se modificaron servidor, red, MySQL,
  SFTPGo, Cloudflared, certificados o cuentas reales.
- La carpeta compartida del portátil se inspeccionó en modo de solo lectura.

## Pasos, comandos y aprendizaje

### Revisión del relevo compartido

```powershell
Get-ChildItem -LiteralPath '\\PC-ENRIQUEDAVID\servidor_portatil' -Force
Get-Content -LiteralPath '\\PC-ENRIQUEDAVID\servidor_portatil\PLAN-FASE-PORTATIL-2026-11-20.md'
```

- **Motivo**: recuperar el resultado sin trasladar instalaciones o secretos.
- **Tipo de acción**: lectura y validación.
- **Resultado observado**: el documento contenía inventario, verificación del
  kit, ensayo local, reversión y preparación de OpenSSH.
- **Interpretación y límites**: la RC extraída no es la fuente documental. El
  único cambio útil procedente del portátil era el seguimiento añadido al
  plan; no se incorporaron binarios, `.obsidian` ni la instalación extraída.

### Control de contenido sensible

Se buscaron por nombre `.env`, claves, certificados, tokens, credenciales y
logs. Solo aparecieron `.env.example`, el almacén público `certifi/cacert.pem`
y nombres de módulos incluidos en dependencias. No se observó un `.env` real,
una clave privada o un certificado de sede.

## Cambios cerrados

- El plan de portátil pasó de `prepared` a `completed`.
- El relevo de Qontrolmed señala la transición a la fase `sede`.
- Se registraron resultados y límites sin copiar la RC ni datos del portátil.

## Validaciones realizadas

- ZIP y kit constan verificados mediante sus manifiestos y SHA-256.
- Instalación, ACL, ejecución del proceso x64 en ARM64 y desinstalación constan
  aceptadas dentro del ensayo sintético.
- El servidor y la sede no fueron contactados.

## Observado, inferido y decidido

### Observado

- El portátil dispone de espacio suficiente y OpenSSH.
- El kit completo coincide en disco local y USB.
- La instalación de ensayo fue retirada sin residuos observados.

### Inferido

- La ejecución x64 bajo ARM64 es viable para el proceso probado, pero no
  demuestra todavía el flujo funcional conectado a MySQL.

### Decidido

- El portátil será equipo de administración/transporte y puesto de prueba.
- La configuración de Cloudflared pertenece a la fase de sede y a
  Servidor_MM; requiere plan aprobado y reversión.

## Riesgos y pendientes

- Revalidar Defender, Firewall y cifrado del portátil.
- Confirmar en sede red, acceso físico/LUKS, identidad SSH y huella del host.
- Preparar el plan transversal de sede, incluido Cloudflare/Cloudflared,
  MySQL/CA, cuentas, copias y aceptación de Qontrolmed.

## Siguiente paso recomendado

Preparar y revisar el plan de sede sin activar servicios ni crear recursos
reales. Después de su aprobación, ejecutar la ventana desde el portátil.
