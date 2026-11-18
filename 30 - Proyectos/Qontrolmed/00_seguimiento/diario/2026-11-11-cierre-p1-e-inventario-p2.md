---
title: "Cierre P1 e inventario inicial P2"
type: session-log
status: completed
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/02_planes_y_arquitectura/PLAN-SESION-2H-CIERRE-P1-Y-ARRANQUE-P2-2026-11-11.md"
tags: [qontrolmed, sesion, p1, p2, ci, migraciones]
---

# Cierre P1 e inventario inicial P2

## Objetivo y motivo

Cerrar la evidencia remota pendiente de P1 y preparar P2 sin tocar servidor,
MySQL ni datos. P1 no podía declararse completado únicamente con resultados
locales; P2 necesitaba un inventario antes de diseñar versionado de esquema.

## Acciones y resultados

1. Se comprobó la rama `codex/produccion-readiness`, alineada con su remoto en
   `7c4a331`, salvo el plan de sesión nuevo.
2. `python -m unittest discover -s tests -v` ejecutó 44 pruebas y terminó `OK`.
3. La credencial almacenada de `gh` devolvía `401`. Se retiró únicamente esa
   entrada caducada y se completó dos veces el flujo oficial de dispositivo,
   pero la CLI siguió rechazando la credencial. No se imprimieron tokens.
4. Se utilizó la sesión web autenticada de GitHub, en modo de solo lectura.
5. Security Checks #58 (`43004406817`) para `7c4a331` mostró correctos
   `Dependency audit`, `Bandit SAST` y `Gitleaks secrets scan`; Gitleaks indicó
   que no detectó fugas.
6. CI #69 (`43004407025`) terminó correctamente. El YAML versionado confirma
   que su job compila el código y ejecuta las pruebas unitarias.
7. Se leyeron `bd/`, `scripts/db/` y las once migraciones sin ejecutar SQL.
8. Se creó un inventario P2 y un plan P2A local de gobierno de esquema.

## Interpretación

P1 queda completado dentro de su alcance local. Esto no autoriza una RC ni
producción. P2 sigue siendo necesario porque no existe ledger ni orden formal y
la mayoría de migraciones carece del ciclo completo exigido.

El diagnóstico posterior confirmó que la credencial de `gh` es válida en el
llavero de Windows y permite consultar repositorio y Actions desde el contexto
autorizado. El `401` se limita al sandbox ordinario de Codex, que no puede leer
el llavero. Para futuras consultas se utilizará el contexto con acceso al
llavero, sin repetir el login mientras esa comprobación continúe correcta.

Tras publicar `19e5fdc`, CI (`43079524608`) y Security Checks
(`43079524648`) finalizaron correctamente para ese commit.

## Continuación: ejecución de P2A

El propietario aprobó continuar con el plan P2A. Se creó un manifiesto JSON con
un solo caso piloto, un validador Python sin conectores de base de datos, una
utilidad CLI de solo lectura y once pruebas de aceptación y fallo seguro.

Comandos principales:

```powershell
python scripts/db/validar_manifest_migraciones.py
python -m unittest discover -s tests -v
python -m py_compile src/compartido/schema_migrations.py scripts/db/validar_manifest_migraciones.py
bandit -c bandit.yaml -r src scripts/db/validar_manifest_migraciones.py -x "*/__pycache__/*" -ll
pip-audit -r requirements.txt
```

El manifiesto fue válido, las 55 pruebas pasaron y Bandit no encontró problemas
medios o altos. `pip-audit` no emitió salida tras más de 90 segundos y se
interrumpió; por tanto, esa ejecución local queda como no concluyente. No se
abrió MySQL, no se ejecutó SQL y no se modificaron dependencias.

Los commits P2A `1a6966b` y `e62f23c` se publicaron. CI
`43081859463` ejecutó compilación y 55 pruebas con resultado correcto; Security
Checks `43081859180` también finalizó correctamente. Se completó además el
contrato lógico del ledger y se dejó su implementación administrativa y su
comprobador simulado para P2B.

## Continuación: ejecución de P2B

El propietario confirmó que el servidor podía permanecer apagado y autorizó
continuar localmente. Se registró y ejecutó P2B sin SSH ni MySQL.

Se añadió un SQL administrativo revisable para aprovisionar un ledger vacío y
un comprobador puro que clasifica filas sintéticas. Las pruebas cubren ledger
exacto, ausente, vacío, ilegible, duplicado, fuera de orden, recuperado, con
hash distinto, con versión posterior y con forma inválida. Otras dos pruebas
impiden que el SQL elija un esquema real, inserte filas o contenga un borrado
ejecutable.

Resultado: 68 pruebas correctas, compilación y manifiesto correctos y Bandit sin
hallazgos medios o altos. No se ejecutó el SQL añadido.

## Límites y reversión

No se accedió a servidor, MySQL, `.env`, datos ni certificados reales. No se
ejecutaron migraciones. Los cambios son documentales y pueden revertirse por
commit sin efecto operativo.
