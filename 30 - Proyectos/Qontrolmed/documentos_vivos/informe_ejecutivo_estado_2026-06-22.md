---
tags:
  - app
  - documentacion
Creado: 2026-06-22
Relacionado:
---

# Informe ejecutivo de estado
[[masgesth]]
Fecha: 2026-06-22

## Proposito

Revisar el estado actual de `maxgesth`, `maxgesth_port` y `maxgestq_mov` tras la
ultima reorganizacion documental y las pruebas de campo, dejando una lectura
ejecutiva orientada a preparar una version inicial de produccion en septiembre.

## Conclusion principal

El proyecto ya no necesita abrir mas frentes amplios para demostrar valor. La
prioridad debe desplazarse a estabilizar, endurecer y empaquetar lo que ya
existe.

La version inicial de septiembre debe apoyarse en:

- `Qontrolmed` como escritorio central;
- Preventivos tablet como flujo de campo validado, incorporando las
  observaciones aceptadas de mayor impacto;
- Quirofanos tablet en standby operativo;
- seguridad, roles, auditoria, maestros y configuracion como columnas de
  produccion;
- Compras operativas e Informes/Analitica ampliados diferidos a una version
  posterior.

## Estado por modulo

### maxgesth / Qontrolmed

Estado: modulo central en fase de readiness.

Fortalezas:

- primer corte de login seguro, bootstrap de `superusuario`, roles, permisos,
  ventana unica y auditoria minima;
- roadmap y continuidad ya centralizados;
- base documental suficiente para preparar una salida controlada;
- `Gestion` puede sostener seguridad, usuarios, roles, centros y maestros.

Riesgos:

- doble ubicacion de `.env`, con riesgo real de soporte y validacion sobre el
  fichero equivocado;
- falta decision final de instalacion, credenciales, runtime y backup;
- maestros y migraciones deben quedar cerrados antes de produccion;
- el modulo tecnico `Compras` puede inducir a abrir alcance no prioritario si no
  se delimita su uso.

Decision recomendada:

- mantener `maxgesth` como foco principal;
- cerrar configuracion local, acceso seguro, auditoria y checklist de
  preproduccion antes de ampliar funcionalidad.

### maxgesth_port / Preventivos tablet

Estado: base de campo aceptada.

Fortalezas:

- flujo offline con importacion, SQLite local, informes, cierre y exportacion;
- contrato funcional documentado;
- pruebas de campo ya aportan observaciones validas;
- utilidad real como complemento del escritorio.

Riesgos:

- las entradas de campo de severidad alta afectan calidad de dato y cierre de
  informe;
- algunas mejoras pueden tocar ambos lados del contrato tablet-sobremesa;
- la validacion Android sigue siendo necesaria cuando cambie interfaz o flujo
  tactil.

Decision recomendada:

- incorporar primero `observaciones` y `NA` cuantitativo;
- agrupar identificacion por serie/inventario y referencias DESF como paquete
  medio;
- no abrir cambios cosmeticos salvo tanda controlada.

### maxgestq_mov / Quirofanos tablet

Estado: standby operativo.

Fortalezas:

- contrato funcional definido;
- suite de pruebas recomendada clara;
- distribucion Android por APK documentada;
- modelo alineado con matriz.

Riesgos:

- rama observada `main`, por lo que cualquier reactivacion funcional debe
  aislarse antes de editar;
- parte de la aceptacion depende de validacion visual en tablet;
- dudas funcionales de altas/bajas y puntos siguen abiertas, pero no bloquean
  la estrategia de septiembre si el modulo permanece en standby.

Decision recomendada:

- no abrir nuevas prestaciones;
- mantener pruebas y contrato;
- tocar solo por incidencia real, import/export o build.

## Trabajo pendiente hacia septiembre

### Imprescindible

- Resolver ruta canonica de configuracion y `.env`.
- Documentar instalacion, credenciales, runtime, exports y backups.
- Cerrar receta operativa de acceso seguro y bootstrap.
- Confirmar roles iniciales y permisos por perfil.
- Ensayar backup/restauracion y migraciones en entorno de prueba.
- Consolidar Centros y maestros minimos necesarios.
- Incorporar `observaciones` y `NA` cuantitativo en Preventivos si se confirma
  alcance tecnico en ambos lados.

### Conveniente

- Busqueda e identificacion por numero de serie e inventario.
- Referencias editables en `DESF-Q01` a `DESF-Q08`.
- Exportacion movil -> sobremesa por bloques si la operativa real lo requiere
  antes de septiembre.
- Checklist de preproduccion con smoke test funcional por modulo.

### Diferido

- Compras operativas.
- Informes de compra.
- Informes directivos.
- Analitica ampliada.
- Nuevas prestaciones de Quirofanos tablet.
- Mejoras visuales no ligadas a confusion real de usuarios.

## Sugerencias supervisoras

1. Definir un hito de congelacion de alcance.

   Propuesta: cerrar alcance funcional de septiembre antes de abrir cualquier
   tarea nueva no derivada de seguridad, campo validado o instalacion.

2. Separar `Gestion` de `Compras`.

   En la primera version, `Gestion` debe entenderse como administracion del
   sistema y maestros. Las compras funcionales deben quedar etiquetadas como
   version posterior para no contaminar prioridades.

3. Convertir el triaje de campo en paquetes.

   Evitar tareas sueltas. El paquete A debe cubrir `observaciones`, `NA`,
   contrato, persistencia y representacion final. El paquete B puede cubrir
   identificacion de equipo y referencias DESF.

4. Preparar una checklist de preproduccion.

   Debe incluir instalacion, credenciales, backup/restauracion, migraciones,
   login, roles, auditoria, import/export Preventivos, PDF e impresion.

5. Mantener Quirofanos tablet en reposo controlado.

   Su valor es conservar compatibilidad y pruebas. Reactivarlo sin incidencia
   real aumentaria riesgo y carga de validacion.

6. Reducir la documentacion de arranque.

   La entrada diaria debe limitarse a playbook, continuidad y roadmap. El mapa,
   especificaciones y diarios deben consultarse por necesidad, no por rutina.

## Proxima decision recomendada

Abrir una sesion tecnica centrada en:

- ruta canonica del `.env`;
- receta de configuracion normal y soporte;
- checklist de instalacion/preproduccion;
- impacto tecnico del paquete A de Preventivos.

No abrir Compras ni Informes en esa sesion.
