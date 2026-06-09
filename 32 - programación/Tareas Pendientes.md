[[Legalizar]]

---

## `docs/tareas_pendientes.md`

# Tareas Pendientes

# Prioridad alta

## PDFs

### Quirófanos
- [x] Revisar maquetación final. 
- [x] Ajustar tamaños tablas. 
- [x] Revisar observaciones. 
- [x] Revisar bloques E/P. 
- [x] Revisar firmas. 
- [x] Revisar logo.
- [x] Revisar libro de quirófano.

### Preventivos
- [x] Ajustar diseño PDF. 
- [x] Revisar tablas cuantitativos. 
- [x] Integrar margen ±.
- [x] Revisar “Equipo apto para uso”. 
- [x] Revisar observaciones. 
- [x] Revisar anexos certificados.


# Mejoras APPs
### General
- [ ] Pasar el módulo de compras a llamarlo Gestión
- [ ] Cambiar el CRUD de Equipos de medida de quirófanos a gestión
- [ ] Ampliar CRUD de CECOS, que pasa a llamarse Centros, al menos en las ui, en lógica no es necesario, pero si documentarlo para incluirlo en el manual de mantenimiento de la aplicación.
	- [ ] incluir al menos:
		- [ ] Dirección completa del CECO: Dirección / código postal / Ciudad
		- [ ] Persona de contacto
		- [ ] Teléfono Pral. y alternativo 
		- [ ] Correo E.
		- [ ] Contacto en Mantenimiento con nombre, teléfono y correo electrónico
		- [ ] Cualquier otro que consideres y sea necesario para el trabajo dentro de la app
	- [ ] Dame el comando completo para modificar la bd
- [ ] Login usuarios.
	- [x] Primera fase de refuerzo
- [ ] Roles/permisos.
- [x] Logs acciones.
- [ ] Protección contraseñas.
 
---

## Quirófanos

- En sobremesa:
	- [ ] implementar selección por ubicación en la ventana de informes
	- [ ] Botón Cerrar en ventana informe
	- [ ] Botón Nuevo - Limpia pantalla
	- [ ] Hace verificación para impedir la firma de un informe con una fecha anterior al mes del informe 
	- [ ] incluir un botón que se activa si hay alguna incidencia en el informe que permite lanzar un informe de reparación de la incidencia detectada. (No prioritario)
		- [ ] Estudiar como hacerlo, este informe iría en el libro de quirófanos como anexo al quirófano y mes en cuestión.
- [x] Informe de quirófanos
	- [x] Aumentar el tamaño del logo
	- [x] en cuadro izquierdo de la cabecera, poner Q1 un poco más grande que el actual, debajo Mes: el mes que corresponda a la fecha de realización (tipo mayor que el normal y en negrilla) y debajo la fecha en tipo normal del informe,
	- [x] Ajustar un poco mejor todo el informe en el A4, la firma sale a ras de la hoja y al imprimir se cortará -Dejar márgenes mínimos superior e inferior, lateral izquierdo aumentar un poco (aún hay quien imprime y encuaderna) y al derecho restarle el añadido al izquierdo
	- [x] Libro Quirófano
	- [x] Botón cerrar en ventana
	- [x] Revisarlo completo, hay inconsistencias entre el índice y páginas, creo que por el tema de fecha de cierre
	- [x] Incluir en el lateral izquierdo como en los informe de quirófano la referencia 'Qontrolmed Q02QF'
		- [x] Estructura del informe
			- portada General del informe
			- indice
			- Resumen gral. del informe
					- N. total de informes
					- informes correctos
					- informes con incidencias
					- incidencias resueltas - **No implementadas**
			- portada del quirófano
			- informes cerrados ordenados por mes de ejecución.
	- [x] Ordenar el listado por fecha de informe, no por fecha de firma, se puede cerrar un informe en un mes posterior al de realización
	- [x] En libro Quirófano, selector de ubicaciones con la opción Todas.
	
- [ ] En APP movil
	- [ ] mirar el procedimiento de trabajo en la app, los quirófanos son mensuales, ¿tiene sentido cargar todos los meses?
	- [ ] selección de quirófanos por ubicaciones
---


# Históricos e informes

## Preventivos
- [ ] Informe por periodo.
- [ ] Agrupación por Centro
- [ ] Exportación Excel.
- [ ] Exportación PDF.
- [ ] Estadísticas.
- [ ] Lanzar informes con selección en  Dashboard o impreso en formato pdf previa vista previa o word para su edición manual con graficas y tablas con datos de preventivos realizados según periodos, preventivos Ok, Incidencias No conformidades, etc. 

## Quirófanos
- [ ] Informe por periodo.
- [ ] Agrupación por Centro.
- [ ] Exportación Excel.
- [ ] Exportación PDF.
- [ ] Estadísticas.

---

# Trazabilidad

## Informes
- Diseñar Tabla trazabilidad.
	- Log de eventos de informes para sacar trazabilidad:
		- Se genera una entrada por creación, cierre y cada vez que se imprime
		- N equipo | fecha creación informe | Creador | fecha Cierre | Usuario cierre| Fecha impresión  | usuario q imprime
- Registrar acciones.
- Registrar usuario.
- Registrar fechas.

## GMAO
- Registrar cambios importación.
- Registrar altas/bajas.
- Registrar modificaciones.

---

# Documentación

## Manuales
- Manual usuario.
- Manual técnico.
- Procedimientos operación.
- Procedimiento backup.
- Procedimiento recuperación.

---

# Producción

## Preparación
- Revisar estabilidad.
- Revisar despliegue.
- Revisar backups.
- Revisar .env.   Sustituirlo por sistema de configuración donde se especificarán los datos principales, conexion bd, usuario root, etc.
- Revisar configuración.

## GitHub
- Generar release estable.
- Revisar ramas.
- Limpiar pendientes.

---

# Prueba piloto

## Septiembre
- Preparar instalación externa.
- Validar funcionamiento real.
- Detectar mejoras UX.
- Detectar errores reales.

---

# Ideas futuras

- App tablet offline.
- Sincronización automática.
- Dashboard estadísticas.
- Firma avanzada.
- Gestión documental.
- Adjuntos múltiples.
- Control calibraciones avanzado.
- Avisos automáticos.
- Sistema notificaciones.