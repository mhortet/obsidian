[[Legalizar]]
# Roadmap Proyecto Gestión Técnica

## Objetivo general

Desarrollar una plataforma modular de gestión técnica orientada a:
- Electromedicina.
- Mantenimiento técnico legal.
- Preventivos.
- Revisiones de quirófanos.
- Gestión documental y trazabilidad.
- Trabajo local y futuro trabajo móvil/offline.

---

# Estado actual

## Módulos existentes

### Compras
Estado:
- Funcional.
- Flujo automatizado operativo.
- Pendiente de mejoras visuales y reorganización futura.

Funciones:
- Gestión de compras.
- Generación Excel.
- Automatizaciones PowerShell.
- Integración correo.
- Gestión OT.
- Gestión albaranes.

---

### Quirófanos
Estado:
- Muy avanzado.
- Pendiente estabilización PDF y revisión final.

Funciones:
- Informes mensuales.
- Gestión puntos de control.
- PDF.
- Libro de quirófano.
- Equipos de medida.
- Firma digital.
- Estados de calibración.

---

### Preventivos
Estado:
- Avanzado.
- Pendiente consolidación de lógica y PDF.

Funciones:
- Plantillas.
- Informes preventivos.
- Puntos cuantitativos/cualitativos.
- Gestión equipos GMAO.
- Resultados.
- PDF.
- Históricos.

---

# FASE 1 — Estabilización

## Prioridad alta

### PDFs definitivos

#### Quirófanos
Pendiente:
- Ajuste maquetación final.
- Revisar tamaños.
- Revisar bloques.
- Optimizar observaciones.
- Revisión logo.
- Validar firmas.
- Revisar anexos.
- Revisar libro de quirófano.

#### Preventivos
Pendiente:
- Rediseño definitivo.
- Ajuste tablas.
- Estado “Equipo apto para uso”.
- Revisión resultados cuantitativos.
- Integración márgenes.
- Revisar anexos certificados.
- Revisión visual general.

#### Compras
Pendiente:
- Posponer temporalmente.
- Revisar más adelante.

---

# FASE 2 — Robustez

## Corrección de bugs

Pendientes:
- Refrescos UI.
- Validaciones.
- Estados inconsistentes.
- Cierre de informes.
- Rutas.
- Gestión de errores.
- Revisar importaciones.
- Revisar generación PDFs.
- Revisar sincronización futura.

## Objetivo
Conseguir una versión:
- estable,
- mantenible,
- reproducible.

---

# FASE 3 — Seguridad

## Objetivo
Preparar el sistema para:
- pruebas externas,
- múltiples usuarios,
- app móvil.

## Pendientes

### Usuarios y autenticación
- Login.
- Gestión usuarios.
- Roles/permisos.
- Bloqueo edición informes cerrados.

### Seguridad técnica
- Contraseñas seguras.
- Logs.
- HTTPS/API segura.
- Gestión sesiones.

### App móvil
- Sincronización segura.
- Gestión conflictos.
- Control modificaciones.
- Trazabilidad completa.

---

# FASE 4 — Trazabilidad

## Objetivo
Registrar:
- quién,
- cuándo,
- qué modificó.

## Propuesta

### Tabla común
```sql  
trazabilidad_informes  
- id  
- modulo  
- id_informe  
- accion  
- estado_anterior  
- estado_nuevo  
- fecha  
- id_usuario  
- observaciones 

## Acciones posibles

- CREADO
- MODIFICADO
- CERRADO
- IMPRESO
- EXPORTADO
- REABIERTO
- SINCRONIZADO_MOVIL
```
# FASE 5 — Históricos e informes

## Objetivo

Pantalla unificada de:

- históricos,
- búsquedas,
- estadísticas,
- exportaciones.

## Preventivos

Informes:

- realizados,
- pendientes,
- cerrados,
- impresos,
- resultado final.

Agrupaciones:

- CECO.
- Hospital.
- Tipo equipo.
- Técnico.

## Quirófanos

Informes:

- revisiones realizadas,
- incidencias,
- pendientes,
- observaciones.

Agrupaciones:

- CECO.
- Hospital.
- Quirófano.
- Técnico.
- Mes.

## Exportaciones

- Excel.
- PDF.
- Resumen estadístico.

---

# FASE 6 — Integración GMAO

## Objetivo

Mejorar trazabilidad importación.

## Pendientes

- Detectar equipos nuevos.
- Detectar modificaciones.
- Detectar bajas.
- Registrar cambios.
- Registrar usuario importación.

## Tabla propuesta

```
historial_importacion_gmao- id- fecha_importacion- id_usuario- inventario- accion- campo_modificado- valor_anterior- valor_nuevo
```

---

# FASE 7 — Documentación

## Objetivo

Preparar:

- mantenimiento,
- instalación,
- continuidad,
- pruebas externas.

## Estructura propuesta

```
docs/├── roadmap.md├── tareas_pendientes.md├── bugs_pendientes.md├── manual_usuario/├── procedimientos/├── arquitectura/├── bd/├── despliegue/└── sesiones/
```

## Documentación pendiente

- Manual usuario.
- Manual técnico.
- Procedimientos operación.
- Procedimiento backup.
- Recuperación.
- Instalación.
- Actualizaciones.

---

# FASE 8 — Producción

## Antes de producción

### Validaciones

- Revisar PDFs.
- Revisar permisos.
- Revisar backups.
- Validar sincronización.
- Validar históricos.
- Validar rendimiento.

### GitHub

- Crear versión estable.
- Congelar release.

### Despliegue

- Preparar instalación.
- Preparar configuración externa.
- Revisar .env.

---

# FASE 9 — Prueba real

## Septiembre

Prueba piloto en empresa externa/amiga.

## Objetivo

Detectar:

- problemas de flujo,
- UX,
- errores reales,
- rendimiento,
- problemas instalación,
- necesidades reales usuarios.

---

# Consideraciones generales

## Filosofía proyecto

Priorizar:

- simplicidad,
- robustez,
- mantenibilidad,
- control total.

Evitar:

- sobrearquitectura,
- complejidad innecesaria,
- tecnologías no necesarias.

---

# Objetivo final

Disponer de una plataforma:

- funcional,
- profesional,
- mantenible,
- adaptable,
- especializada en electromedicina y mantenimiento técnico legal.

```
---## `docs/tareas_pendientes.md````md# Tareas Pendientes# Prioridad alta## PDFs### Quirófanos- Revisar maquetación final.- Ajustar tamaños tablas.- Revisar observaciones.- Revisar bloques E/P.- Revisar firmas.- Revisar logo.- Revisar libro de quirófano.### Preventivos- Ajustar diseño PDF.- Revisar tablas cuantitativos.- Integrar margen ±.- Revisar “Equipo apto para uso”.- Revisar observaciones.- Revisar anexos certificados.---# Bugs## Generales- Revisar refrescos UI.- Revisar validaciones.- Revisar errores rutas.- Revisar bloqueos informes.- Revisar generación PDF.- Revisar importaciones.---# Seguridad## App móvil- Definir autenticación.- Definir sincronización.- Definir control conflictos.- Definir permisos.## General- Login usuarios.- Roles/permisos.- Logs acciones.- Protección contraseñas.---# Históricos e informes## Preventivos- Informe por periodo.- Agrupación por CECO.- Exportación Excel.- Exportación PDF.- Estadísticas.## Quirófanos- Informe por periodo.- Agrupación por CECO.- Exportación Excel.- Exportación PDF.- Estadísticas.---# Trazabilidad## Informes- Diseñar tabla trazabilidad.- Registrar acciones.- Registrar usuario.- Registrar fechas.## GMAO- Registrar cambios importación.- Registrar altas/bajas.- Registrar modificaciones.---# Documentación## Manuales- Manual usuario.- Manual técnico.- Procedimientos operación.- Procedimiento backup.- Procedimiento recuperación.---# Producción## Preparación- Revisar estabilidad.- Revisar despliegue.- Revisar backups.- Revisar .env.- Revisar configuración.## GitHub- Generar release estable.- Revisar ramas.- Limpiar pendientes.---# Prueba piloto## Septiembre- Preparar instalación externa.- Validar funcionamiento real.- Detectar mejoras UX.- Detectar errores reales.---# Ideas futuras- App tablet offline.- Sincronización automática.- Dashboard estadísticas.- Firma avanzada.- Gestión documental.- Adjuntos múltiples.- Control calibraciones avanzado.- Avisos automáticos.- Sistema notificaciones.
```

