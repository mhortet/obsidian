---
title: "Prueba LAN de conexiones Qontrolmed superada"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/PRUEBAS-QONTROLMED-WINDOWS-2026-11-05.md"
  - "../../05_evidencias/PILOTO-LAN-CIERRE-2026-11-05.txt"
tags: [mysql, seguridad, auditoria]
review_after: 2026-11-12
---

# Prueba de conexiones desde Windows — resultados

Puesto autorizado: este PC, 192.168.1.107. Ventana LAN iniciada a las 12:00 Europe/Madrid y cerrada a petición de las pruebas antes del límite.

## Superado

- Código real de GestorConexiones de la copia aislada: tres conexiones TLS con CA/identidad verificadas y cifrado TLS_AES_256_GCM_SHA384.
- Inserción, actualización, consulta y borrado exclusivamente de filas ficticias en los tres esquemas piloto.
- Recuperación de una sesión cerrada antes de una operación nueva.
- Rechazo de conexión sin TLS con la misma cuenta (1045, REQUIRE SSL).
- Rechazo de identidad incorrecta durante conexión real: resolución del nombre falso redirigida solo dentro del proceso de prueba a la IP real, manteniendo el nombre falso para la validación TLS. No se modificó DNS ni hosts.
- Timeout de lectura real con límite de 1 segundo frente a SELECT SLEEP(3).
- Escritura sintética interrumpida cancelando exclusivamente una conexión propia desde una segunda conexión de la misma cuenta. Error explícito, ninguna fila insertada/duplicada y recuperación posterior. No equivale a simular corte físico de red, todas las pérdidas posibles o timeout de escritura.

## Cierre

El script confirmó cuenta mm_piloto_pc bloqueada, retirada de su regla /32, restauración de escucha local y MySQL inactive/disabled. Revalidación SSH independiente: hash .cnf 4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927, sin escucha 3306/33060 y sin unidades fallidas. Las reglas UFW se retiraron mediante el script sudo con resultado correcto; no se hizo una lectura privilegiada independiente posterior.

Configuración de prueba de Windows protegida en AppData\Local\Qontrolmed-Piloto-20261105, fuera del repositorio y con herencia de permisos retirada; acceso al usuario actual y SYSTEM. CA pública distribuida sin confianza global. Credenciales no mostradas, no incorporadas a documentos o repositorios. La cuenta queda bloqueada. No se copiaron claves privadas.

## Preparación funcional pendiente

El repositorio no contiene una base completa de Preventivos. Se consultó MySQL80 local usando la configuración existente de ProgramData, solo después de verificar host loopback. Se usaron credenciales únicamente en memoria, sin mostrarlas. Transacción de solo lectura; exclusivamente INFORMATION_SCHEMA y SHOW CREATE TABLE, sin SELECT de registros de negocio y sin modificaciones de origen.

Metadatos: 13 tablas de Gestión, 7 de Quirófanos y 13 de Preventivos. Original de metadatos conservado en el directorio protegido de Windows, no en el repositorio. Preparada copia DDL sin registros, comentarios, contadores AUTO_INCREMENT ni valores predeterminados sensibles para columnas de credenciales. Destino: 06_herramientas/configuracion/estructura-piloto-20261105.json.

Script preparar-esquema-funcional.py preparado y copiado al servidor, sintaxis y hashes comprobados. Crea solo esas tablas en los tres esquemas piloto existentes, conservando prueba_conexion. Si aparecen tablas inesperadas o directorio previo, aborta sin sobrescribir. Conserva una copia lógica privada de cada esquema antes de añadir tablas; no ejecuta DROP. Aplica bootstrap estático revisado de roles/permisos y administrador sintético sin clave, que requerirá el asistente inicial de la aplicación. No copia usuarios o registros reales. Arranca solo localmente para esta preparación y detiene MySQL al finalizar; no abre UFW.

Pendiente ejecución sudo del script, validación de esquema, pruebas de interfaz y flujos representativos, y verificación desde un segundo origen de red si se desea completar ese caso. El piloto completo todavía no se declara terminado. El timeout de escritura y un corte físico de red no han sido probados experimentalmente.
