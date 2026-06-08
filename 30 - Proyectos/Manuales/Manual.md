---
tags:
  - app
  - manuales
Relacionado:
  - "[[Legalizar]]"
  - "[[Tareas Pendientes]]"
Creado:
---


# Procedimiento de carga de preventivos 

## Procedimiento Preventivos

	1. Preparar la excel en el formato indicado      
|Nº|INVENTARIO|MODELO|MARCA|NSERIE|Fecha Última modficicación|Ubicación|Descripción|
(falta meter el tipo de equipo referente a seg elec)

	2. Importar excel
	3. Genera automáticamente la plantilla si no está
	4. Asignar puntos de control a la plantilla si la plantilla es nueva
		1. Si estos no están, crearlos en 'Puntos de control'
		2. Los puntos de control se pueden ordenar en su presentación en pantalla y pdf, pero para su trabajo en movil, el número de orden que les demos a la hora de crearlos, será el que utilice
	5. Ahora podemos trabajar los informes de dos maneras:
		1. Exportar a movil
			1. Genera un fichero json ya preparado para app movil
		2. Trabajar desde el escritorio con documentos en papel
	6. Trabajar con APP
		1. Una vez recibido el fichero de exportación, lo importamos desde la app movil, caso de que en la aplicación persistierean informes de campañas anteriores, nos avisará para evitar el borrado accidental de las mismas.
		2. Pasamos al menú de infomre y seguir la operativa normal, selección del equipo, asignar tipo de equipo en función de la seguridad eléctrica, completar datos que falten e ir validando o rellenando según corresponda los correspondientes puntos de control.
		3. Una vez completados todos los puntos, se cerrará el informe con el correspondiente botón al final del mismo, pasando este a estado listo par exportar y desapareciendo del listado de equipos seleccionables en la cabecera del informe.
		4. Los informes cerrados, se pueden exportar cuando queramos, no es necesario esperar a tenerlos todos.
		5. Al importar informes de la app, comprueba si ese informe ya se existe en el equipo receptor, dando la opción a elegir cual mantenemos.
		6. Una vez en la central, se revisa el informe, se asigna equipo de medida y si todo está correcto, se cierra.
		7. El informe en papel o pdf, se puede imprimir en ese momento o en bloques igualmente se pueden imprimir o no los certificados de los equipos de medida.
		


		
			
		8. Trabajar desde el escritorio con documentos en papel
			1. Abrir Informes
			2. Seleccionar equipo
			3. Crear/cargar informe: si ya se creo anteriormente un informe los carga con el estado que tuviera cuando se guadó, sino creo un infimre nuevo.
			4. Asignar datos de cabecera, técnico fecha, etc 
			5. Importante revisar el tipo de equipo si no se indica, ya que verifica automáticamente el estado del punto comparando el valor introducido con el de referencia
			6. Asignar equipos de medida
			7. Guardar cabecera
			8. cumplimentar el informe
			9. Si nos posicionamos en el primer punto, podemos ir actualizandolo on las teclas B, M o N o bien utilizar los botones inferiores; al actualizar el estado pasará automáticamente al siguiente punto.
				Los valores hay qu validarlos con el correspondiente botón.
			10. Una vez terminado, podemos pedir una copia en pdf para verificar, o bien directamente cerrar el infome, lo que lo bloqueará para edición y desaparecerá de la ventana de búsqueda.
		9. Para poder acceder a los informes cerrados, tenemos que entrar por 'historico de informes', aquí podremos seleccionar para imprimir el informe o para re abrirlo en caso de necesidad.
			(En este punto, implementar control de cambios para trazabilidad del preventivo; utilizar tabla auxiliar donde guardar estado, fecha y usuario)
