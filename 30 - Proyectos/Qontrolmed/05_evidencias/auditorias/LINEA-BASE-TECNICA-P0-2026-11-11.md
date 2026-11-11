---
title: "Línea base técnica P0"
type: evidence
status: active
created: 2026-11-11
updated: 2026-11-11
sources:
  - "commit 907648df368312f985e7797eed5a43f78cdf8234"
  - "GitHub Actions run 42659458332"
tags: [qontrolmed, p0, evidencia, git, ci]
review_after: 2026-11-18
---

# Línea base técnica P0

## 1. Alcance y método

Evidencia obtenida mediante lectura del repositorio, comandos Git, ejecución de
tests locales y consulta autenticada de metadatos de GitHub. No se inspeccionó
ningún secreto ni se conectó con servidor o base de datos.

## 2. Repositorio

| Elemento | Valor observado |
| --- | --- |
| Repositorio remoto | `mhortet/gestion_tecnica` |
| Rama remota por defecto | `main` |
| Commit remoto de `main` observado | `014bf7c7b3c80c514786c36d1135efe00202b7a0` |
| Commit estructural local | `907648df368312f985e7797eed5a43f78cdf8234` |
| Rama P0 | `codex/produccion-readiness` |
| Rutas versionadas | 290 |
| Rutas bajo patrones de build/runtime revisados | 0 |
| Ficheros Python en `src/` | 89 |
| Módulos Python de test | 5 |
| Documentos Markdown | 93 antes de los entregables P0 |

## 3. Integridad Git

`git fsck --full` terminó con código 0. Mostró numerosos árboles y blobs
colgantes, además de commits colgantes históricos. Un objeto colgante no está
referenciado por una rama o tag; su presencia no equivale a corrupción.

Decisión:

- no ejecutar `git gc`, `prune` ni reescritura de historia en P0;
- verificar un clon limpio y comparar el commit antes de sanear este checkout;
- mantener cualquier limpieza de historia como plan independiente.

## 4. Entorno local observado

| Herramienta | Versión |
| --- | --- |
| Python | 3.13.12 |
| pip | 26.0.1 |
| Git | 2.54.0.windows.1 |
| GitHub CLI | 2.92.0 |

El CI usa Python 3.11. Esta diferencia debe formar parte de la matriz de
compatibilidad y no se interpreta como validación cruzada.

## 5. Dependencias declaradas

Runtime fijado en `requirements.txt`:

- `mysql-connector-python==9.7.0`;
- `python-dotenv==1.2.2`;
- `pandas==3.0.1`;
- `openpyxl==3.1.5`;
- `pillow==12.3.0`;
- `matplotlib==3.10.8`;
- `reportlab==4.4.10`;
- `pypdf==6.14.2`;
- `pdfplumber==0.11.9`;
- `defusedxml==0.7.1`.

Build: `pyinstaller==6.19.0` además del runtime.

## 6. Pruebas y seguridad

### Tests

`python -m unittest discover -s tests -v`: 24 pruebas, resultado `OK`.

### Bandit local

`python -m bandit -c bandit.yaml -r src -x '*/__pycache__/*' -ll`:

- 25.090 líneas de código analizadas;
- 0 problemas medios;
- 0 problemas altos;
- 17 problemas bajos, excluidos por el umbral `-ll`;
- código de salida 0.

### Herramientas ausentes localmente

- `python -m pip_audit`: módulo no instalado.
- `gitleaks version`: ejecutable no disponible.

La ausencia de una herramienta no se registra como resultado favorable.

## 7. CI remoto observado

Run `42659458332`, creado el 9 de noviembre de 2026 a las 17:54 hora peninsular:

| Trabajo | Resultado real |
| --- | --- |
| Dependency audit | `failure` |
| Bandit SAST | `success` |
| Gitleaks secrets scan | `success` |
| Resultado global del workflow | `success` |

La discrepancia se explica por `continue-on-error: true` en los tres trabajos.
Por tanto, el verde global no constituye una puerta de seguridad válida.

Se observaron ocho pull requests Dependabot abiertos: tres acciones de GitHub y
cinco dependencias Python. No se fusionó ninguno.

La consulta de protección de `main` devolvió HTTP 401 con la autenticación
disponible; su estado no se considera verificado en esta sesión.

## 8. Worktrees y TLS

- Worktree principal: commit estructural `907648d`.
- Worktree aislada TLS: rama `pilot/mysql-tls-20261105`, base `014bf7c`.
- Cambios TLS locales: `.env.example`, configuración y gestor de conexión.
- Cambios funcionales no relacionados: ID manual de marcas.
- Tests sin seguimiento: TLS, recuperación de conexión e ID de marcas.
- Instalador, configurador y verificador RC: sin cambios de provisión de CA.

No se integró ni copió ningún fichero.

## 9. Hallazgo nuevo P0

`src/Quirofanos/services/informe_service.py` ejecuta un `ALTER TABLE` durante el
runtime si falta `tecnico_cierre`. Este comportamiento contradice la regla de no
ejecutar migraciones al abrir o utilizar la aplicación y obligaría a conceder
DDL a la cuenta técnica.

Tratamiento: retirar el autoajuste, convertirlo en migración controlada y probar
el fallo seguro si el esquema no cumple la versión esperada.
