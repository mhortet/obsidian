---
tags:
  - app
  - desarrollo
Relacionado:
  - "[[Legalizar]]"
Creado: 2026-05-21
---
### Resultado de la revisión tras modificaciones en flujo de preventivos.

#### Esto para incluir en la documentación como verificación
1. Revisada la importación de dos campañas sin conflictos
2. Realización de informes en PC OK
3. Histórico, Cierre, etc... OK
4. Exportación a Tablet OK
	1. protección anti carga con datos antiguos OK
	2. Doble seguridad borrado equipos antiguos OK
5. Trabajo en Tablet OK
6. Exportación / Importación PC OK
	1. Seguridad en caso de informes repetidos tablet/PC OK
		1. te da a elegir que informe permanece
7. Impresión Informe OK


#### Ahora detalles detectados:

1. En ventana emergente para indicar la campaña, cambiar Anio x Año
2. En ventana de asignar puntos a las plantillas, implementar botón de salida
3. En importación GMAO, añadir la columna 'clase_seguridad' se llama igual en la excel, 
4. En ventana Informe preventivo:
	1. Solo tiene el botón cerrar en la esquina superior derecha, poner el de minimizar y el de ajustable
	2. Cuando creas el informe desde esta pantalla, no te habilita el checking de Forzar No apto
		1. Cuando se abre desde histórico, si que está habilitado
	3. Al CERRAR el informe, queda desbloqueado el combox clase/tipo
5. En informe_pdf:
	1. mantener juntas los títulos , cabecera y 1ª fila de cada bloque, al menos el de Seguridad Eléctrica, no lo hace.
	2. En el recuadro superior derecho, cambiar la imagen y texto fijo por logo, siempre ha estado en la raíz del proyecto, pero podemos ponerlo en /pdf_assets/qontrolmed/logo.png.