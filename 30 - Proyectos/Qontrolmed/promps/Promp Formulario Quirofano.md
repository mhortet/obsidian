[[Legalizar]]
# HECHO
### Indicaciones para mejorar el formulario pdf_service.py

Sigue las siguientes indicaciones para modificar src/quirofanos/service/pdf_service.py.
Cualquier duda sobre donde colocar o si hay que alterar distribuciones, pregunta antes de cambiar.
Respeta criterios de política de imagen e integridad y consistencia del código, así como la seguridad del mismo de cara a pasar test para escalar a producción.
Una vez terminada las modificaciones, lanza una muestra para verificación.

- En cabecera:	  
	- Cuadro izquierdo: el campo 'codigo' del quirófano, ponerlo centrado y un poco más grande
	- Fecha sustituir por 'Mes: XXXXX (el que corresponda a la fecha) '
	- Cuadro central, incluir debajo de nombre del quirófano la ubicación también centrada y con un tipo de la fuente un poco más pequeño
- En el módulo lámpara 
	- Darle un poco más de identidad como módulo suave remarque del contorno del módulo 
	- lámpara como título del módulo
	- en V inicial y V final, poner valor_medido, si no hay valor entonces estado
- Módulo Equipo de medida_
	- compactar un poco más quitar aire arriba y abajo las filas
- Módulo dispositivo de vigilancia
	-  el título pisa la primera línea
	- En los campos que tengan valor_medido indicarlo, si no hay valor, entonces el estado
- Módulo fugas de corriente
	- Pisa al módulo Equipo de medida justo debajo de la línea Marca
	- Compactar un poco , la suma de alturas de los módulos Equipo de Medida y Fugas de corriente, ha de ser igual a la suma de los módulos lámpara y Dispositivo de vigilancia, aumentar o disminuir separaciones entre módulos en lugar de aumentar altura de líneas de los módulos.
- Módulo Equipotenciales / protecciones
	- misma filosofía que en puntos anteriores, si tiene valor_medido, poner este, si no lo tiene el estado.
	- cambiar el título de la columna 'Est' a 'E/V' y ensanchar un poco para que entre el valor sin problemas.
	- si el estado es MAL pintar en rojo,
	- si en puntos 'E' el valor_medido es superior o igual a 100 pintar en rojo
	- si en puntos 'P' el valor_medido es superior o igual a 200 pintar en rojo
	
- Módulo Sistemas No AISLADOS
	- quitar un poco de espacio respecto a equipotenciales/protecciones
- Control del suelo electrostático
	- Bajarlo, alinearlo con Sistemas Aislados
	- marcar como título Control del Suelo Electrostático (..)
	- dar un poco más de aire respecto al los 4 puntos siguientes
- los 4 siguientes puntos:
	- Estado del elemento de iluminación "lámpara Quirúrgica"/Control Conexiones.../estado de las tomas de corriente/ Estado protecciones Magn...
	- Poner título: ' Revisión elementos' y poner como título
	- que quede alienado en altura sumando la del control de suelo con el sistema no aislado.
- Poner si se puede el texto de forma vertical con un tipo pequeño pero visible 'Qontrolmed' en el centro del lado izquierdo de la hoja, pintado de abajo hacia arriba.
- si no es posible, en la esquina inferior derecha 
-
