---
tags:
  - app
  - documentacion
Creado: 2026-07-12
Relacionado:
---

# Checklist de ejecucion para backup y upgrade a MySQL 8.4 LTS
[[masgesth]]
Fecha de creacion: 2026-06-12

## Objetivo

Ejecutar la fase de backup y verificacion previa al upgrade desde
`MySQL 8.0.44` a `MySQL 8.4 LTS` sin mezclarla con cambios funcionales.

## Punto de partida asumido hoy

- Existe ya un `Data Export` de `gestion`, `quirofanos` y `preventivos`
  generado hace pocas horas.
- No ha habido accesos adicionales a la base desde ese export.

Con ese contexto, el export actual puede tomarse como `snapshot logico base`,
pero aun debemos:

- duplicarlo;
- registrar su integridad;
- verificar que cubre las tres bases;
- hacer al menos una restauracion de prueba.

## Referencias

- `docs/plan_upgrade_mysql_8_0_44_a_8_4_lts.md`
- `docs/estado_continuidad.md`
- `scripts/db/registrar_backup_mysql.ps1`

## Fase 1. Congelar y etiquetar la evidencia actual

1. Localizar la carpeta exacta del `Data Export`.
2. Renombrarla o documentarla con fecha y hora si aun no la tiene.
3. Anotar:
   - fecha/hora del export;
   - quien lo genero;
   - desde que herramienta se genero;
   - si fue export por esquemas completos o por tablas.

## Fase 2. Duplicar el backup

Minimo recomendado:

1. Mantener la carpeta original sin tocar.
2. Crear una segunda copia en otra ubicacion segura.
3. Si es posible, crear una tercera copia comprimida o en almacenamiento
   externo controlado.

Regla:

- no trabajar nunca solo con una unica copia.

## Fase 3. Registrar hashes y cobertura

Ejecutar desde PowerShell en la raiz del repo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\db\registrar_backup_mysql.ps1 `
  -BackupPath "RUTA_DEL_DATA_EXPORT" `
  -OutputDir "output\backup_mysql"
```

Resultado esperado:

- se genera un `manifest` en Markdown;
- se genera un CSV con todos los ficheros y su `SHA256`;
- el manifest detecta evidencia de `gestion`, `quirofanos` y `preventivos`.

Si el script marca una base como `no detectada`:

- revisar nombres de carpetas o ficheros;
- confirmar manualmente que esa base esta realmente exportada;
- no seguir hasta resolverlo.

## Fase 4. Prechecks SQL antes de restaurar

Lanzar y guardar salida o captura de:

```sql
SELECT VERSION();
SHOW VARIABLES LIKE 'version_comment';
SHOW VARIABLES LIKE 'sql_mode';
SHOW VARIABLES LIKE 'character_set_server';
SHOW VARIABLES LIKE 'collation_server';
SHOW ENGINES;
```

Anotar ademas:

- tamano aproximado de cada base;
- si existen vistas, triggers o procedimientos;
- si la app se conecta por `localhost` y `3306` como parece por configuracion.

## Fase 5. Restauracion de prueba

Objetivo:

- demostrar que el backup sirve de verdad antes de tocar produccion.

Secuencia recomendada:

1. Elegir un entorno seguro o instancia separada.
2. Restaurar ahi `gestion`, `quirofanos` y `preventivos`.
3. Verificar:
   - que todas las tablas aparecen;
   - que no hay errores de importacion;
   - que una consulta simple devuelve datos en cada base.

Consultas minimas sugeridas:

```sql
SHOW TABLES FROM gestion;
SHOW TABLES FROM quirofanos;
SHOW TABLES FROM preventivos;
```

Y una comprobacion minima por base, ajustando tablas reales si hiciera falta.

## Fase 6. Validacion minima con la app

Contra la restauracion de prueba o contra una instancia de validacion:

1. Abrir la app.
2. Probar login.
3. Abrir `Gestion -> Centros`.
4. Abrir `Gestion -> Usuarios`.
5. Abrir un flujo representativo de `Preventivos`.
6. Abrir un flujo representativo de `Quirofanos`.

Criterio:

- si la app no conecta o falla una lectura/escritura basica, no pasar al
  upgrade real.

## Fase 7. Checklist previa al upgrade real

Antes de subir a `8.4 LTS`, dejar marcado:

- [ ] backup original localizado
- [ ] segunda copia creada
- [ ] hashes generados
- [ ] cobertura de las tres bases confirmada
- [ ] prechecks SQL guardados
- [ ] restauracion de prueba correcta
- [ ] validacion minima con la app correcta
- [ ] ventana de mantenimiento acordada
- [ ] responsable de validacion funcional identificado
- [ ] criterio de rollback claro

## Fase 8. Qué no mezclar en la misma ventana

No mezclar el upgrade del servidor con:

- migracion de `roles` explicitos;
- permisos finos por usuario;
- nuevas migraciones grandes de esquema;
- correctivos funcionales no relacionados con base de datos.

## Evidencias a conservar

- carpeta original del `Data Export`;
- copia secundaria;
- manifest Markdown de hashes;
- CSV de hashes;
- capturas o salida de prechecks SQL;
- prueba de restauracion;
- resultado de validacion con la app.
