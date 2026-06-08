---
tags:
  - app
  - estructura
Relacionado:
  - "[[Legalizar]]"
Creado: 2026-05-06
---
## Estructura mínima de un módulo de compras

### 1. Maestros básicos

Ya tienes parte:

- **Proveedores**
- **Productos / repuestos / servicios**
- **Equipos o activos asociados**
- **Centros / departamentos / CECOS**
- **Usuarios solicitantes**
- **Estados de compra**

Añadiría:

- **Familias de producto**
- **Condiciones proveedor**
- **Contactos del proveedor**
- **Formas de pago / entrega**
- **Impuestos / descuentos**

---

## 2. Solicitud de compra

Sería el inicio normal del flujo.

Debe permitir:

- Crear una **solicitud interna**
- Indicar solicitante
- Centro / servicio / equipo afectado
- Motivo de la compra
- Prioridad
- Líneas de productos o servicios
- Adjuntar documentos
- Estado: borrador, solicitada, aprobada, rechazada

---

## 3. Presupuestos de proveedores

Aquí ahora parece que tienes hueco.

Funcionalidades mínimas:

- Registrar uno o varios **presupuestos**
- Asociarlos a una solicitud
- Asociar proveedor
- Fecha del presupuesto
- Validez
- Importe
- Plazo de entrega
- Adjuntar PDF
- Comparar presupuestos
- Marcar presupuesto elegido

---

## 4. Aprobación

Aunque sea simple:

- Pendiente de aprobación
- Aprobada
- Rechazada
- Motivo de rechazo
- Usuario que aprueba
- Fecha aprobación
- Límite económico si algún día lo necesitas

---

## 5. Orden de compra / pedido

Esto sería el documento formal.

Debe tener:

- Número de pedido
- Proveedor
- Fecha emisión
- Líneas compradas
- Precio pactado
- Dirección / centro de entrega
- Condiciones
- Estado: emitido, enviado, parcialmente recibido, recibido, cerrado, cancelado
- Generar PDF/Excel de pedido
- Enviar por correo, más adelante

---

## 6. Recepción

Parte importante.

Funcionalidades:

- Registrar recepción total o parcial
- Fecha recepción
- Albarán
- Cantidades recibidas
- Incidencias
- Adjuntar albarán PDF
- Asociar material recibido a equipo/OT/centro
- Cerrar pedido si está completo

---

## 7. Factura / control económico

Mínimo:

- Registrar factura
- Número factura
- Fecha
- Proveedor
- Importe
- Pedido relacionado
- Estado: pendiente, recibida, validada, pagada
- Diferencias entre pedido / albarán / factura

---

## 8. Histórico y búsquedas

Imprescindible:

- Buscar por proveedor
- Producto
- equipo
- OT
- centro
- fecha
- estado
- número pedido
- número presupuesto
- factura
- albarán

---

## 9. Informes

Mínimos útiles:

- Compras por proveedor
- Compras por centro / CECOS
- Compras por equipo
- Pendientes de recibir
- Presupuestos pendientes
- Pedidos abiertos
- Gasto mensual/anual
- Refacturable / no refacturable, si lo mantienes

---

## Flujo completo recomendado

```
Solicitud de compra        ↓Presupuestos proveedor/es        ↓Selección / aprobación        ↓Orden de compra / pedido        ↓Recepción / albarán        ↓Factura        ↓Cierre
```

---

## Mi consejo para meterle mano

No tocaría todo de golpe.

Yo lo dividiría así:

### Fase 1 — Normalizar lo actual

Separar lo que es:

- compra genérica
- flujo específico de tu empresa actual
- automatismos de carpetas/correos

### Fase 2 — Añadir solicitudes

Crear entidad “solicitud de compra”.

### Fase 3 — Añadir presupuestos

Uno o varios presupuestos por solicitud.

### Fase 4 — Añadir orden de compra

Generar documento formal.

### Fase 5 — Recepción y cierre

Albaranes, parciales y cierre.

---

La clave: **tu módulo actual no está mal**, pero seguramente es más un **gestor de pedidos operativos** que un **módulo de compras completo**. Ahí está la primera separación buena.