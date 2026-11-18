---
title: "P2S — Reconciliación del ledger de Quirófanos"
type: plan
status: completed
created: 2026-11-17
updated: 2026-11-17
sources:
  - "bd/migraciones/manifest.json"
  - "docs/02_planes_y_arquitectura/PLAN-P2P-ESQUEMAS-DEFINITIVOS-IDENTIDADES-Y-ACCESOS-2026-11-16.md"
tags: [qontrolmed, mysql, ledger, quirofanos, p2s]
---

# P2S — Reconciliación del ledger de Quirófanos

## 1. Motivo y estado observado

El intento P2R de crear una cuenta temporal mínima se detuvo al comprobar que
`quirofanos.qontrolmed_schema_migrations` no existe. La revisión de solo lectura
confirmó que el ledger no existe en ninguno de los seis esquemas actuales.

También confirmó una divergencia estructural:

- `informes.tecnico_cierre` existe como `INT NULL`, compatible con v1;
- `equipos_medida.ruta_certificado` existe como `VARCHAR(100) NULL`;
- el manifiesto y la migración v2 exigen `VARCHAR(500) NULL`.

Por tanto, no es correcto registrar las migraciones como aplicadas sin corregir
y validar antes la estructura. P2R permanece detenido y la cuenta temporal fue
retirada por el propietario.

## 2. Alcance autorizado que se solicita

1. Revalidar host, MySQL, escucha loopback, espacio y ausencia de unidades
   fallidas.
2. Verificar que `qontrolmed_bootstrap@localhost` no existe.
3. Crear y verificar una copia lógica fechada de `quirofanos`.
4. Ejecutar prechecks de tabla, columna, tipo, nulabilidad, índices y filas cuyo
   valor de `ruta_certificado` exceda 100 caracteres.
5. Ampliar exclusivamente `quirofanos.equipos_medida.ruta_certificado` de
   `VARCHAR(100)` a `VARCHAR(500) NULL`.
6. Aprovisionar el ledger canónico únicamente en `quirofanos`.
7. Insertar las dos entradas canónicas del manifiesto, con sus identificadores,
   versiones y SHA-256 exactos, después de superar los postchecks estructurales.
8. Ejecutar el guard de compatibilidad del código y controles de integridad.
9. Retirar SQL temporal y conservar la copia previa.

No se modifica `piloto_mm_quirofanos`, no se crea ninguna cuenta runtime o
temporal, no se asigna la contraseña funcional y no se abre MySQL a la LAN.

## 3. Aceptación

- `ruta_certificado` es exactamente `VARCHAR(500) NULL DEFAULT NULL`.
- El ledger tiene el contrato canónico, dos filas y versiones únicas 1 y 2.
- Identificadores y SHA-256 coinciden con `bd/migraciones/manifest.json`.
- El guard vigente devuelve `compatible`.
- MySQL continúa limitado a `127.0.0.1:3306`.
- La copia previa tiene tamaño no nulo y SHA-256 verificado.

## 4. Reversión y parada segura

Ante cualquier fallo se detiene P2R y no se registra como compatible. La
reversión prevista es restaurar `quirofanos` desde la copia P2S verificada; no
se encadenan correcciones improvisadas ni se modifica el esquema de reversión.
Si el ledger se hubiera creado pero permaneciera vacío, podrá retirarse dentro
del mismo bloque tras comprobarlo. Si contiene filas, se preserva evidencia y
se restaura la copia completa.

## 5. Continuidad posterior

Solo tras la aceptación de P2S podrá retomarse P2R: volver a validar el script
blindado, crear la cuenta temporal mínima, abrir el túnel local, ejecutar el
bootstrap desde desarrollo y retirar inmediatamente la cuenta.

## 6. Resultado de ejecución

P2S fue autorizado y ejecutado el 17/11/2026. El script terminó con
`P2S_RESULTADO=OK` y dejó la copia previa verificada en
`/var/backups/qontrolmed/p2s-20261117T083320Z`.

Los postchecks confirmaron `ruta_certificado` como `VARCHAR(500)`, dos versiones
canónicas en el ledger y coincidencia exacta de identificadores y SHA-256. La
comprobación posterior por SSH observó MySQL `active/enabled`, cero unidades
fallidas y escucha exclusiva en `127.0.0.1:3306`. El script temporal fue
retirado de `/tmp`; la copia permanece disponible para recuperación.
