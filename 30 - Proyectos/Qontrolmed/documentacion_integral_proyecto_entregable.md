---
tags:
  - app
  - desarrollo
Creado: 2026-05-30
Autor:
  - Codex
Relacionado:
  - "[[masgesth]]"
---
## Alcance

## Descripción


# Gestion Hospital Modificado

## Documento tecnico y funcional

**Version:** 1.0  
**Fecha:** 12/05/2026  
**Estado:** Aprobado para entrega  
**Tipo:** Documentacion integral (base editable para Word)

---

## Control documental

| Campo | Valor |
|---|---|
| Proyecto | Gestion Hospital Modificado |
| Documento | Documentacion tecnica y funcional |
| Codigo | GHM-DOC-001 |
| Version | 1.0 |
| Fecha | 12/05/2026 |
| Autor | Equipo de desarrollo |
| Revisado por | Pendiente |
| Aprobado por | Pendiente |

## Historial de cambios

| Version | Fecha | Autor | Descripcion |
|---|---|---|---|
| 1.0 | 12/05/2026 | Equipo de desarrollo | Emision inicial completa para entrega |

---

## Indice

1. Resumen ejecutivo  
2. Alcance y objetivos  
3. Tecnologia y dependencias  
4. Arquitectura del sistema  
5. Configuracion y conectividad  
6. Seguridad y autenticacion  
7. Flujo general de operacion  
8. Modulo Compras  
9. Modulo Quirofanos  
10. Modulo Preventivos  
11. Modelo de datos y SQL  
12. Operativa del equipo y forma de trabajo  
13. Pruebas y control de calidad  
14. Riesgos tecnicos  
15. Roadmap recomendado  
16. Anexos de entrega

---

## 1. Resumen ejecutivo

Gestion Hospital Modificado es una aplicacion de escritorio desarrollada en Python con Tkinter para la gestion documental y operativa de tres dominios hospitalarios: Compras, Quirofanos y Preventivos.

El sistema proporciona:

- autenticacion de usuarios,
- acceso por modulos desde una portada central,
- gestion transaccional en MySQL,
- generacion de informes y documentos PDF,
- soporte para importacion de datos historicos.

La arquitectura prioriza separacion por capas (`ui`, `services`, `db`, `compartido`) y compatibilidad con esquemas de base de datos heredados.

## 2. Alcance y objetivos

### 2.1 Alcance

Este documento cubre:

- estructura del proyecto,
- componentes funcionales por modulo,
- logica de negocio principal,
- seguridad, configuracion y conectividad,
- forma de trabajo recomendada para mantenimiento y evolucion.

### 2.2 Objetivos

- dejar trazabilidad tecnica para mantenimiento,
- facilitar onboarding de nuevos perfiles,
- servir como base oficial de documentacion para auditoria y mejora continua.

## 3. Tecnologia y dependencias

### 3.1 Base tecnologica

- Lenguaje: Python
- UI: Tkinter
- Base de datos: MySQL
- Conexion: `mysql-connector-python`

### 3.2 Dependencias declaradas

Fuente: `requirements.txt`

- `mysql-connector-python`
- `python-dotenv`
- `pandas`
- `openpyxl`
- `pillow`
- `matplotlib`
- `pdfkit`
- `reportlab`
- `pypdf`
- `pdfplumber`
- `defusedxml`

### 3.3 Uso funcional de dependencias

- Datos y analitica: `pandas`
- Importacion/exportacion Excel: `openpyxl`
- Graficos: `matplotlib`
- PDF por HTML (Compras): `pdfkit`
- PDF programatico (Quirofanos/Preventivos): `reportlab`
- Fusion y manipulacion PDF: `pypdf`
- Extraccion desde PDF de entrada: `pdfplumber`

## 4. Arquitectura del sistema

### 4.1 Estructura principal de carpetas

```text
maxgesth/
  main.py
  requirements.txt
  src/
    compartido/
    Compras/
    Quirofanos/
    preventivos/
  bd/
  docs/
  output/
```

### 4.2 Patron de capas

- `ui/`: interfaces, formularios, eventos y flujo de usuario.
- `services/`: reglas de negocio y validaciones funcionales.
- `db.py` o `db/` por dominio: helpers SQL por modulo.
- `compartido/`: conexion, configuracion, autenticacion y recursos comunes.

### 4.3 Punto de entrada

`main.py`:

1. crea ventana raiz,
2. inicializa `Comunicacion`,
3. ejecuta login,
4. muestra menu principal con acceso a modulos.

## 5. Configuracion y conectividad

### 5.1 Variables de entorno obligatorias

Definidas en `src/compartido/configuracion.py`:

- `DB_HOST`
- `DB_PORT` (opcional, default 3306)
- `DB_USER`
- `DB_PASSWORD`
- `DB_GESTION`
- `DB_QUIROFANOS`
- `DB_PREVENTIVOS`

Si falta cualquier variable requerida, el sistema bloquea arranque con mensaje explicativo.

### 5.2 Gestor de conexiones

`src/compartido/db.py` administra 3 conexiones independientes:

- gestion,
- quirofanos,
- preventivos.

Incluye utilidades de:

- validacion de conexion,
- `fetchone` y `fetchall`,
- ejecucion con commit/rollback,
- verificacion de columnas para compatibilidad de esquema.

## 6. Seguridad y autenticacion

### 6.1 Flujo de acceso

`src/Compras/ui/login_ui.py`:

- solicita credenciales al iniciar,
- limita intentos fallidos,
- permite acceso inicial controlado si no hay contrasenas cargadas,
- guarda usuario autenticado en contexto de sesion (`db.usuario_actual`).

### 6.2 Proteccion de contrasenas

`src/compartido/auth.py`:

- hash PBKDF2-SHA256,
- 210000 iteraciones,
- sal aleatoria,
- comparacion segura con `hmac.compare_digest`.

## 7. Flujo general de operacion

1. Arranque de aplicacion.
2. Conexion a BD.
3. Login.
4. Seleccion de modulo en portada.
5. Operacion en ventana especifica del modulo.
6. Guardado transaccional de datos.
7. Cierre controlado y liberacion de conexiones.

## 8. Modulo Compras

### 8.1 Funciones principales

- gestion de compras (cabecera y lineas),
- mantenimiento de maestros,
- dashboard de gasto,
- importacion de historicos,
- exportaciones relacionadas.

### 8.2 Entidades funcionales

- compras,
- detalle_compra,
- equipos,
- repuestos,
- proveedor,
- marcas,
- tipo_trabajo,
- usuarios,
- cecos.

### 8.3 Logica de negocio clave

`src/Compras/services/compras_service.py` implementa:

- validacion de lineas,
- calculo de totales,
- normalizacion de detalle,
- guardado de compra + detalle en transaccion,
- filtros de consulta por fechas, ceco, OT, equipo, proveedor y texto.

### 8.4 Observaciones de mantenibilidad

- se maneja compatibilidad de columnas legacy por `_resolve_column`,
- conviene registrar cada cambio de schema con migracion SQL formal.
- este modulo queda fuera de la presente evaluacion operativa y requiere una
  revision especifica antes de fijar su roadmap de produccion.

## 9. Modulo Quirofanos

### 9.1 Funciones principales

- gestion de quirofanos,
- puntos de control,
- asignacion de puntos por quirofano,
- equipos de medida,
- informes mensuales,
- libro de quirofano y PDFs.

### 9.2 Logica de negocio clave

`src/Quirofanos/services/informe_service.py` cubre:

- creacion de informe,
- alta inicial de resultados por puntos,
- completado de puntos faltantes,
- actualizacion por codigo,
- evaluacion de estado de calibracion de equipos.

Estado actual resumido:

- el modulo conserva base funcional para informes, PDF, libro y trabajo de
  campo;
- necesita una sesion de refresco tecnico-funcional porque hace mas tiempo que
  no se revisa de forma integral;
- la siguiente evolucion recomendable pasa por validar de nuevo escritorio,
  documentacion y contrato con Android antes de ampliar analitica o UX.

## 10. Modulo Preventivos

### 10.1 Funciones principales

- creacion de informes preventivos,
- administracion de plantillas,
- asignacion de puntos a plantillas,
- importacion GMAO,
- historico e impresion multiple,
- exportacion e importacion controlada con tablet por campana.

### 10.2 Logica de negocio clave

`src/preventivos/services/informes_preventivo_service.py` implementa:

- creacion de informe desde plantilla por tipo de equipo,
- inicializacion de resultados,
- evaluacion automatica de puntos:
  - cualitativos,
  - cuantitativos (rango fijo y variable),
  - seguridad por clase del equipo.

Estado actual resumido:

- Preventivos es el modulo mas cercano a estar cerrado operativamente;
- ya existe criterio consistente por campana para historico, creacion manual y
  flujo escritorio-tablet;
- el foco siguiente no es abrir mas operativa, sino consolidar estabilidad,
  trazabilidad, analitica y preparacion de paso a produccion.

## 11. Modelo de datos y SQL

### 11.1 Estrategia de persistencia

- SQL manual con cursores.
- Control transaccional explicito.
- Dependencia de scripts en `bd/` y migraciones en `docs/`.

### 11.2 Ventajas y compromisos

- Ventaja: control total sobre consultas y rendimiento.
- Compromiso: mayor esfuerzo de mantenimiento de schema y pruebas de regresion.
- Compromiso adicional: la compatibilidad con esquemas legacy no debe derivar en
  autoajustes de schema silenciosos para una salida de produccion.

## 12. Operativa del equipo y forma de trabajo

### 12.1 Principios recomendados

- no mezclar SQL de negocio en `ui/`,
- centralizar validaciones en `services/`,
- mantener consistencia de nomenclatura CRUD,
- documentar cambios funcionales y de BD en cada iteracion.

### 12.2 Flujo de implementacion sugerido

1. Analisis funcional del cambio.
2. Diseno/actualizacion de schema.
3. Migracion SQL versionada.
4. Desarrollo en `services` y luego `ui`.
5. Pruebas integrales manuales.
6. Actualizacion documental y cierre.

## 13. Pruebas y control de calidad

### 13.1 Casos minimos por version

- login correcto y fallido,
- CRUD de al menos un maestro por modulo,
- compra completa con detalle y recalculo,
- informe de quirofano con salida PDF,
- informe preventivo con evaluacion automatica.

### 13.2 Recomendacion de evolucion

Crear suite de pruebas unitarias para `services` criticos y smoke tests
funcionales por flujo, empezando por Preventivos y por los servicios de
informes y PDF con mayor impacto operativo.

## 14. Riesgos tecnicos

- ausencia de test automatizado completo,
- coexistencia de estructura de datos legacy,
- complejidad creciente de UI por multiplicidad de ventanas,
- necesidad de formalizar pipeline de build/distribucion,
- presencia de mojibake y criterios de codificacion no del todo normalizados,
- riesgo de depender de autoajustes de schema o compatibilidades implicitas en
  tiempo de ejecucion,
- falta de modulo Analitico implantado pese a que Preventivos ya esta maduro
  para esa siguiente fase.

## 15. Roadmap recomendado

1. consolidar Preventivos para analitica y preproduccion,
2. implantar `src/Analitico/` con servicios de solo lectura y primer informe de
   Preventivos,
3. fijar migraciones SQL y eliminar dependencia de autoajustes de schema,
4. hacer refresco tecnico-funcional completo de Quirofanos,
5. preparar guia formal de despliegue, backup, restauracion y soporte
   operativo.

## 16. Anexos de entrega

Se recomienda adjuntar en la version final:

- DER simplificado por dominio,
- diccionario de datos,
- matriz de permisos por rol,
- capturas de UI por flujo,
- checklist de validacion por release.

---

## Instrucciones rapidas para maquetar en Word

1. Copiar este contenido en Word.
2. Aplicar estilos `Titulo 1` a secciones numeradas.
3. Aplicar estilos `Titulo 2` a subsecciones.
4. Insertar tabla de contenido automatica.
5. Agregar portada corporativa y pie con version/fecha.
6. Exportar a PDF como version de distribucion.
