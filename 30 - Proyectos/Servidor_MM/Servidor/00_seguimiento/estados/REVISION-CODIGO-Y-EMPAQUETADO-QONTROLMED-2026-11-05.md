---
title: "Revisión de código y empaquetado Qontrolmed del piloto"
type: analysis
status: needs-review
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../06_herramientas/configuracion/QONTROLMED-CAMBIOS-PILOTO-2026-11-05.zip"
  - "CIERRE-TECNICO-PILOTO-DOMESTICO-2026-11-05.md"
tags: [qontrolmed, seguridad, testing]
review_after: 2026-11-12
---

# Revisión de código y empaquetado aislados

## Alcance revisado

Worktree aislado `C:\Users\Maxi\Documents\Codex\2026-11-05\u\work\qontrolmed-piloto`, rama `pilot/mysql-tls-20261105`, base `014bf7c7b3c80c514786c36d1135efe00202b7a0`.

Cambios sin commit ni merge: `.env.example`, configuración y conexiones compartidas, servicio/formulario de marcas y tres módulos de tests. No se leyó ni modificó el `.env` real, no se instaló ni empaquetó una RC y no se tocó la aplicación habitual.

## Resultado técnico

- TLS verificado por defecto con CA e identidad; excepción sin TLS limitada a IP loopback explícita.
- Timeouts finitos y `LOCAL INFILE` desactivado.
- Reconexión acotada solo antes de una operación nueva; no se repiten escrituras ambiguas.
- Cierre de conexiones desconectadas e idempotente.
- Alta de marcas con ID manual explícito, rango de entero firmado y traducción de duplicado 1062.
- `git diff --check` sin incidencias.
- Suite completa: 39 de 39 pruebas correctas con `mysql-connector-python 9.7.0`.
- El ZIP documental contiene únicamente ocho archivos de código/tests/configuración de ejemplo y un README. Los ocho hashes coinciden con el worktree actual; no contiene `.env` real, credenciales ni claves privadas.

## Hallazgo bloqueante de empaquetado

El código resuelve una CA relativa junto al `.env`. La plantilla actual define `DB_SSL_CA=ca-piloto.pem`, por lo que en modo instalado espera `C:\ProgramData\Qontrolmed\config\ca-piloto.pem`.

El flujo RC actual:

1. crea `config`, `output` y `docs\certificados`;
2. copia únicamente `.env.example` a `config`;
3. no incorpora ni exige un paso explícito para provisionar la CA pública en la ruta resuelta;
4. el verificador no exige `DB_TLS_REQUIRED=1`, `DB_SSL_CA`, existencia/lectura/integridad de la CA ni coherencia entre su ruta y las ACL;
5. los tests de scripts RC no cubren esos requisitos nuevos.

Consecuencia: la aplicación falla de forma segura si falta la CA, pero el paquete no es todavía instalable de manera reproducible con TLS. Tampoco debe reutilizarse el nombre o certificado del piloto doméstico como identidad de producción.

## Criterio para levantar el bloqueo

Antes de construir o instalar otra RC:

1. definir un procedimiento de provisión de la CA pública específica de la sede, sin incluir claves privadas;
2. alinear `.env.example`, instalador, configurador y verificador con una única ruta canónica;
3. proteger la integridad del archivo CA con propietario/ACL y verificar que Usuarios no puedan modificarlo;
4. exigir TLS, CA existente y variables de timeout en la verificación de la RC;
5. añadir tests de empaquetado para esos requisitos y ejecutar la suite completa;
6. probar el paquete aislado contra el piloto antes de sustituir una instalación habitual.

Estado: código funcional del piloto aceptable para continuar pruebas aisladas; paquete/instalación no aceptados todavía.
