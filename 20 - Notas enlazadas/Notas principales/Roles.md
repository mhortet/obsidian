---
tags:
  - app
  - codigo
  - desarrollo
  - prompt
Fecha: 2026-06-05
Relacionado:
excalidraw-open-md: true
excalidraw-plugin: parsed
---
>[!quote]+ Esquema
>![[Roles]]

# Resumen

Describe los distintos roles que se proponen para aplicar en Qontrolmed e informes a implementar

---
Roles:
- # Posibilidad de crear roles.
	- Puntos a asignar a roles mediante checking
		- Acceso Total - ¿Crear Opción de borrar informes?
		- Acceso a todos los CRUD de la aplicación
		- Crear informes
		- Ver informes
		- Modificar informes
		- Cerrar informes
		- Imprimir informes
		- Importar Campañas
		- Exportar trabajo de campo		
- # Módulo Informes datos y estadísticas
	"Los informes solo viven al generarse y en su salida en pdf"
	- Generar informes
	- Validar informes - ¿? se registra en auditoría eventos
	- imprimir informes
	- Informes de Preventivos.
		- Opción de lanzar lanzar informe por campañas 
			- Datos identificativos: fecha, centro, etc.
			- Total de preventivos realizados 
				- Preventivos OK
				- Preventivos con incidencias
				- Preventivos no aceptados
			- Listado de incidencias.
				- OT
				- N Inventario
				- Punto defectuoso
				- valor y límite si es valor 
			- Incluir Portada y firma y fecha al final del mismo
			- antes de imprimir Incluir posibilidad de:
				- Cambiar el nombre del informe
				- Vista previa, guardar pdf  en la ruta establecida dentro de Output o imprimir	
	- # Quirófanos
		Ya tenemos el libro de quirófano que pude hacer las veces de informe.
		Habría que implementar un informe más ejecutivo
		## Este informe no lo tengo muy claro pensar más en ello
			- Plantear el informe entre periodos
				- Total quirófanos medidos.
				- Total de incidencias detectadas
				- 
				- Evolución del valor de lámparas 
			- 

---
%%
# Excalidraw Data

## Text Elements
%%
## Drawing
```compressed-json
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
```
%%