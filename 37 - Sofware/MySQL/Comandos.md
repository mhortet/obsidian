---
tags:
  - SQL
  - software
  - app
Creado: 2026-06-17
Autor:
  - M.Hortet
Relacionado:
---
## Resumen

## Descripción

-  Lista todas las entradas de la tabla auditoria_eventos
		SELECT * FROM auditoria_eventos 
- Inserta una nueva entrada en la tabla equipos con los datos de Valuesn el las columnas referenciadas
		INSERT INTO equipos (idEquipos,Descripcion, Fabricante) VALUES ('66666','borrar', '1')
- Modifica la la columna precio_unitario de la tabla detalle_compra y le asigna el tipo decimal con dos decimales
		ALTER TABLE detalle_compra ADD precio_unitario decimal(6,2);
- Modifica la entrada con el id =  2 de la tabla hospitales y le asigna el nombre indicado
		UPDATE hospitales
		SET nombre = "Hospital Universitario San Agustín"
		WHERE id = 2;
- Elimina de la tabla detalle_compra, la entrada con id = 487
		DELETE FROM detalle_compra where id_compras =487 ;
- Combinando tablas
			SELECT c.id_compras, c.ceco, c.Fecha, c.OT, c.Equipo, r.Repuesto #COUNT(dc.id_compras) AS num_detalles
			FROM compras c
			LEFT JOIN detalle_compra dc ON dc.id_compras = c.id_compras
			left join repuestos r on r.idRepuestos = dc.idRepuestos
			GROUP BY c.id_compras, c.OT, c.Equipo
			ORDER BY c.id_compras;
			[[Drawing 2026-06-17 18.37.41.excalidraw]]