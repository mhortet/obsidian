---
tags:
  - app
  - documentacion
Creado: 2026-07-12
Relacionado:
---

# Runbook de validacion Paquete A Preventivos con datos reales
[[masgesth]]
Fecha de preparacion: 2026-06-27
Fecha de cierre manual: 2026-07-12

## Objetivo

Dejar preparada la ejecucion del Paquete A de Preventivos para cuando exista
una BD de preproduccion o una copia controlada de datos reales. El objetivo no
es repetir la validacion virtual, sino cerrar persistencia real y PDF sin
improvisar.

Paquete A cubre solo:

- observaciones generales capturadas en tablet y visibles en sobremesa;
- `NA` manual en puntos cuantitativos cuando el control no aplica.

La prueba fisica APK/tablet sigue siendo una validacion separada cuando se
genere un nuevo APK por cambios de UI o flujo.

## Resultado registrado

El 2026-07-12 el usuario confirma validacion manual correcta de las
modificaciones del Paquete A:

- calculo del resultado del valor medido a partir del valor de referencia;
- funcionamiento de `NA` en campos cuantitativos;
- traslado de observaciones indicadas;
- salida correcta hacia el informe PDF.

Con esta evidencia, Paquete A queda aceptado funcionalmente. Este runbook se
conserva como receta de repeticion o diagnostico si aparece una regresion, se
cambia el contrato o se prepara una nueva validacion sobre otro entorno.

## Condiciones de entrada

No empezar si falta cualquiera de estos puntos:

- backup reciente o copia restaurada de `gestion`, `preventivos` y, si aplica,
  `quirofanos`;
- `compartido/.env` apuntando a esquemas de preproduccion/restauracion, no a
  produccion real sin autorizacion explicita;
- usuario normal activo con contrasena;
- JSON de resultados tablet real o paquete equivalente autorizado;
- decision sobre conflictos: conservar existentes (`keep`) o reemplazar
  existentes (`replace`) en la copia controlada.

## Corte previo

Desde la raiz del repo:

```powershell
git status --short --branch
Test-Path src\compartido\.env
Test-Path compartido\.env
python -c "import sys; sys.path.insert(0, 'src'); from compartido.configuracion import cargar_entorno_db; cargar_entorno_db(); print('entorno ok')"
python -m compileall main.py src
```

Criterio:

- `src\compartido\.env` debe devolver `False`;
- `compartido\.env` debe devolver `True`;
- no imprimir secretos;
- `compileall` debe terminar sin error.

## Validacion de contrato y esquema

```powershell
python scripts\validate_preventivos_tablet_fixture.py
python scripts\check_preventivos_paquete_a_schema.py
```

Criterio esperado:

- fixture `1.1` correcto contra importador de escritorio;
- `informes_preventivo.observaciones` existe;
- `resultados_preventivo.estado` admite `NA`.

Si falla el esquema, no importar. Preparar migracion SQL explicita antes de
continuar.

## Preview contra la copia controlada

Con el JSON real:

```powershell
python scripts\preview_preventivos_tablet_import.py "RUTA\AL\export_tablet.json"
```

Salida esperada:

- `Equipos no encontrados: 0`;
- conflictos revisados y decision documentada;
- avisos entendidos.

Si hay equipos no encontrados, parar y revisar maestros. Si hay conflictos,
decidir `keep` o `replace` antes de importar.

## Importacion controlada

Modo conservador, sin reemplazar informes existentes:

```powershell
python scripts\import_preventivos_tablet_controlado.py "RUTA\AL\export_tablet.json" `
  --conflict-policy keep `
  --generate-pdf `
  --confirm-controlled-copy COPIA_CONTROLADA
```

Modo con reemplazo, solo si se ha decidido expresamente en la copia:

```powershell
python scripts\import_preventivos_tablet_controlado.py "RUTA\AL\export_tablet.json" `
  --conflict-policy replace `
  --allow-conflicts `
  --confirm-replace `
  --generate-pdf `
  --confirm-controlled-copy COPIA_CONTROLADA
```

No ejecutar estos comandos contra produccion real sin backup, autorizacion y
ventana de prueba documentada.

## Verificaciones posteriores

Con los `new_report_ids` devueltos por el script:

1. Abrir el informe importado en `Preventivos`.
2. Confirmar que las observaciones generales aparecen en sobremesa.
3. Confirmar que los puntos cuantitativos `NA` quedan como `estado = 'NA'` y
   `valor_leido` nulo.
4. Confirmar que el informe queda abierto para revision final.
5. Abrir el PDF generado en `output/preventivos/`.
6. Confirmar que el bloque de comentarios muestra observaciones generales.
7. Confirmar que `NA` aparece en el punto esperado.
8. Revisar auditoria de importacion tablet.

Consultas de apoyo, sustituyendo `<ID_INFORME>`:

```sql
SELECT id, observaciones, resultado_final, cerrado
FROM informes_preventivo
WHERE id = <ID_INFORME>;

SELECT r.id, pc.codigo, r.estado, r.valor_leido, r.observacion
FROM resultados_preventivo r
JOIN puntos_control pc ON pc.id = r.id_punto
WHERE r.id_informe = <ID_INFORME>
ORDER BY pc.codigo;
```

## Criterio de aceptacion

La validacion queda cerrada como `VALIDADO FUNCIONALMENTE` si:

- preview sin equipos perdidos;
- importacion controlada sin errores;
- observaciones generales persistidas;
- `NA` cuantitativo persistido sin valor numerico;
- PDF generado y revisado;
- auditoria de importacion visible;
- queda documentada la evidencia manual o el entorno usado.

No cerrar si:

- hay que tocar schema sin migracion;
- faltan maestros;
- el JSON real no representa el circuito de campo;
- el PDF no refleja observaciones o `NA`;
- la prueba se ha hecho sobre datos ficticios que luego habria que repetir.

## Evidencia a registrar

Crear entrada en `docs/diario_sesiones/YYYY-MM-DD.md` con:

- entorno usado y confirmacion de copia controlada;
- ruta del JSON importado;
- resultado de preview;
- politica de conflicto usada;
- `new_report_ids`;
- rutas de PDF generadas;
- incidencias y decision final.
