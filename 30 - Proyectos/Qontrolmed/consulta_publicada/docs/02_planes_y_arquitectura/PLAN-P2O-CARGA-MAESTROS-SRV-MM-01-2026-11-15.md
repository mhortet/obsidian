# P2O — Carga de maestros en srv-mm-01

Estado: completado el 15/11/2026.

## Alcance

- Destino: `srv-mm-01` (`192.168.1.31`), MySQL 8.4.11.
- Los tres esquemas `piloto_mm_*` fueron creados solo para ensayos, nunca han
  estado en producción y no contienen datos reales. El propietario confirmó
  este hecho antes de autorizar su reconstrucción completa.
- Origen: maestros locales revisados de Preventivos y puntos de Quirófanos.
- Decisiones: excluir tipo y plantilla 6 y sus 14 relaciones; renombrar seis plantillas; conservar el resto.
- Workbench accederá mediante túnel SSH. MySQL permanecerá ligado a loopback, sin regla UFW para 3306.

## Secuencia

1. Precheck de host, servicios, versión, espacio y ausencia de listener MySQL en LAN.
2. Iniciar MySQL sin habilitarlo al arranque.
3. Crear copia previa lógica y verificar su legibilidad.
4. Recrear los tres esquemas `piloto_mm_gestion`, `piloto_mm_preventivos` y
   `piloto_mm_quirofanos` desde las fuentes canónicas vigentes.
5. Cargar maestros en transacción con cuenta temporal de migración.
6. Postcheck de recuentos, claves, duplicados y decisiones P2N.
7. Crear cuenta administrativa restringida a `localhost` para Workbench por SSH.
8. Probar acceso y retirar cuenta/archivos temporales de migración.

## Aceptación

- 7 tipos, 6 plantillas, 390 puntos, 146 relaciones y 136 puntos de quirófanos.
- Cero huérfanos, duplicados o tablas operativas pobladas.
- 3306 no accesible desde LAN; acceso Workbench solo por túnel SSH.

## Reversión

- Detener la ventana ante cualquier pre/postcheck fallido.
- Restaurar la copia previa de los tres esquemas si falla cualquier puerta.
- Eliminar cuentas temporales y mantener MySQL `disabled`; cerrar el túnel SSH.

## Resultado

- Copia previa verificada: `/var/backups/qontrolmed/p2o-20261115/antes-carga.sql`,
  SHA-256 `a82a38f5610af8a0d7a12e6b6b0b27a0a7530cef1b013c338a534d27202339fa`.
- Carga correcta: 7 tipos, 6 plantillas, 390 puntos preventivos, 146 relaciones
  y 136 puntos de quirófanos; cero huérfanos y cero registros operativos.
- Cuenta `qontrolmed_admin@localhost` limitada a los tres esquemas; contraseña
  generada y custodiada por el propietario, no registrada.
- Workbench validado mediante túnel SSH local `127.0.0.1:13306`.
- MySQL quedó `active/disabled`, ligado a `127.0.0.1`; 3306 no se abrió en LAN.
- SQL temporal remoto retirado; copia y log conservados para reversión.
