---
title: "Identificadores historicos de marcas: preservar asignacion manual"
type: decision
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "Aclaracion expresa del propietario en el chat del piloto"
  - "../05_evidencias/AUTOINCREMENTO-RECHAZADO-1833-2026-11-05.txt"
tags: [documentacion, mysql, arquitectura]
review_after:
---

# Conservar los ID manuales de marcas

El propietario confirma que los ID de marcas se importaron originalmente de otra base y por eso su asignación se dejó manual. Preservar identificadores y relaciones; no tratarlos como un error del diseño ni sustituirlos por números calculados.

La ventana principal de Qontrolmed se abrió al inicio de la prueba, confirmado por el propietario y consistente con la ventana detectada por la herramienta. La captura automatizada falló: esto no demuestra que fallase el arranque. No equivale a haber verificado visualmente todos los módulos.

## Diagnóstico corregido

El formulario ya permite introducir un ID, pero guardar() no lo transmitía a guardar_marca(); el servicio insertaba solo Descripcion. La incompatibilidad está en ese flujo de alta, no en la existencia histórica de un ID manual.

El intento de ALTER exclusivo del piloto fue rechazado por MySQL con 1833: columna referenciada por una clave foránea. No se ejecutará un cambio alternativo de relaciones para forzarlo. MySQL quedó detenido y la ventana LAN no se abrió. La configuración segura de red/TLS mantiene el hash esperado.

## Solución en la copia aislada

El botón Guardar envía id_marca al servicio. El servicio requiere ID entero positivo dentro del rango INT firmado e inserta explícitamente idMarcas y Descripcion. Duplicados producen aviso comprensible; no se renumeran filas, no se usa MAX+1, no se modifican restricciones ni IDs existentes. La validación afecta solo a altas nuevas; no cambia IDs históricos ya almacenados.

Tres pruebas nuevas verifican preservar un ID explícito, rechazar ID ausente/inválido sin escritura y tratar duplicados sin actualizar filas existentes. Suite completa: 39 pruebas superadas. Pendiente prueba de integración LAN del alta manual corregida.

El script de ALTER fue retirado: su ruta activa local/proyecto/servidor contiene solo un aviso y termina sin ejecutar cambios. Original conservado como histórico en 90_archivo/CORRECCION-AUTOINCREMENTO-RETIRADA-2026-11-05.py. No ejecutar el histórico. La aplicación habitual y MySQL80 local permanecen intactos.

Referencia técnica del error: https://dev.mysql.com/doc/mysql-errors/8.4/en/server-error-reference.html#error_er_fk_column_cannot_change_child
