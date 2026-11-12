---
title: "Runbook de reconciliación TLS y provisión de CA"
type: process
status: proposed
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/05_evidencias/auditorias/LINEA-BASE-TECNICA-P0-2026-11-11.md"
  - "C:/Users/Maxi/Documents/Codex/2026-11-05/u/work/qontrolmed-piloto"
tags: [qontrolmed, tls, ca, mysql, p0, p1]
review_after: 2026-11-18
---

# Runbook de reconciliación TLS y provisión de CA

## 1. Objetivo

Integrar TLS verificado sin copiar a ciegas una worktree antigua y conseguir que
el instalador, la configuración, la aplicación y el verificador compartan el
mismo contrato.

Este runbook describe preparación local. No autoriza conectarse al servidor ni
usar una CA real.

## 2. Estado observado

La worktree `pilot/mysql-tls-20261105` contiene:

- TLS obligatorio por defecto;
- `ssl_verify_cert` y `ssl_verify_identity`;
- TLS 1.2/1.3;
- timeouts de conexión, lectura y escritura;
- `allow_local_infile=False`;
- excepción sin TLS solo para IP loopback;
- resolución de CA relativa a la carpeta de configuración;
- ocho pruebas unitarias de política TLS;
- cuatro pruebas de recuperación de conexión.

No contiene:

- copia/provisión de CA por el instalador;
- validación de hash de la CA;
- ACL de CA verificadas por el instalador y el verificador;
- pruebas del configurador/instalador para CA;
- conexión negativa real con nombre o CA incorrectos;
- commit aislado y trazable.

También contiene un cambio de ID manual de marcas que no pertenece a TLS y debe
quedar fuera de esta integración.

## 3. Secuencia de integración futura

### Paso 1. Extraer por responsabilidad

1. Portar únicamente configuración TLS y sus tests.
2. Portar recuperación de conexión en un commit separado.
3. No portar el cambio de marcas.
4. Adaptar cada bloque sobre `907648d`, no reemplazar ficheros completos.

### Paso 2. Definir contrato de configuración

Variables previstas:

- `DB_TLS_REQUIRED=1` por defecto;
- `DB_SSL_CA=<ruta-relativa-o-absoluta>`;
- `DB_CONNECT_TIMEOUT`, `DB_READ_TIMEOUT`, `DB_WRITE_TIMEOUT`;
- excepción `DB_TLS_REQUIRED=0` solo para IP loopback explícita.

La configuración debe fallar antes de conectar si falta la CA, la ruta es
inválida o la política tiene valores no permitidos.

### Paso 3. Provisión de CA pública

Diseño propuesto:

- destino canónico: `C:\ProgramData\Qontrolmed\config\ca\mysql-ca.pem`;
- origen: paquete administrativo separado o canal protegido, nunca el código;
- CA pública, sin clave privada;
- propietario: grupo Administradores;
- lectura: usuarios autorizados a ejecutar Qontrolmed;
- escritura/modificación: denegada a usuarios estándar;
- SHA-256 esperado registrado en manifiesto protegido;
- copia atómica y verificación antes de actualizar `.env`.

El nombre y la ruta final deben aprobarse junto a la arquitectura de sede.

### Paso 4. Alinear herramientas

Modificar conjuntamente:

- `.env.example`;
- `src/compartido/configuracion.py`;
- `scripts/configurar_qontrolmed_env.ps1`;
- `scripts/instalar_qontrolmed_rc.ps1`;
- `scripts/verificar_qontrolmed_rc.ps1`;
- guía de instalación;
- tests unitarios y de scripts;
- manifiesto/SBOM de release.

### Paso 5. Pruebas negativas y positivas

Rechazar:

- CA ausente o ilegible;
- CA distinta;
- nombre del servidor distinto;
- TLS desactivado fuera de loopback;
- timeouts inválidos;
- CA modificable por usuario estándar;
- `LOCAL INFILE` habilitado.

Aceptar:

- conexión con certificado de laboratorio válido, identidad correcta y CA
  ficticia controlada;
- loopback explícito sin TLS solo en laboratorio;
- recuperación acotada antes de una operación nueva, sin repetir escrituras.

## 4. Aceptación

- todos los componentes usan el mismo contrato;
- instalación limpia provisiona y verifica CA pública;
- la aplicación falla de forma segura;
- pruebas positivas y negativas pasan;
- no se incorpora CA real, clave privada ni secreto al repositorio;
- no se mezcla el cambio funcional de marcas.

## 5. Reversión

Antes de producción, la reversión consiste en no fusionar la rama P1. En una
instalación de laboratorio, retirar el paquete candidato y restaurar la carpeta
de configuración ficticia desde su copia previa.
