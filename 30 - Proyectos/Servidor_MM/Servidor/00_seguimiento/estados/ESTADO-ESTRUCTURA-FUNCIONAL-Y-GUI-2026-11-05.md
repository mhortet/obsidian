---
title: "Estructura funcional lista para prueba de interfaz"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/PREPARACION-FUNCIONAL-COMPLETADA-2026-11-05.txt"
tags: [mysql, seguridad, documentacion]
review_after: 2026-11-12
---

# Estructura funcional preparada

Evidencia PREPARACION_FUNCIONAL_COMPLETADA recogida. Añadidas 13 tablas de Gestión, 7 de Quirófanos y 13 de Preventivos a los esquemas ficticios, conservando la tabla prueba_conexion. Copia lógica previa restringida en /root/srv-mm-piloto-20261105/esquema-funcional/. Aplicado bootstrap estático de roles/permisos y un administrador ficticio sin contraseña inicial; no se copiaron usuarios ni registros de la instancia original.

MySQL inactive/disabled y sin escucha 3306/33060, sin unidades fallidas; revalidado por SSH. No se abrió UFW para esta fase. Cuentas MySQL de pruebas siguen bloqueadas.

## Aplicación aislada

Instaladas todas las dependencias de requirements.txt únicamente en work/venv-piloto. Inventario en 05_evidencias/DEPENDENCIAS-ENTORNO-PILOTO-2026-11-05.txt. Importación de src.main correcta. Suite completa del worktree: 36 pruebas, todas correctas. No se modificó la instalación habitual.

Preparado work/abrir-piloto-gui.py, copia en 06_herramientas/scripts. Es un harness de pruebas, no una modificación del login de producción. Inicializa solo el administrador ficticio mediante el servicio real, con credencial aleatoria almacenada fuera del repositorio en el directorio protegido del piloto; comprueba autenticación correcta e incorrecta mediante el servicio. Abre las pantallas con esa sesión ya autenticada y título Qontrolmed - PILOTO FICTICIO. El diálogo de login y el asistente gráfico de contraseña no se automatizan ni se declaran probados. No mostrar la credencial o su archivo en capturas/chat.

## Próxima ventana LAN

Modo --resume de piloto-lan-20261105.py preparado y comprobado. Reutiliza únicamente la cuenta LAN del piloto bloqueada y su configuración existente; verifica REQUIRE SSL, host /32 y línea base antes de desbloquear. Conserva la marca FINALIZAR anterior con un nombre nuevo en lugar de borrar archivos. No cambia contraseña ni recrea la cuenta o los datos. Mantiene origen 192.168.1.107, límite 15 minutos y limpieza de regla propia/configuración/cuenta al salir.

Pendiente ejecución sudo de esa ventana y revisión de pantallas/flujos. Otros pendientes: segundo origen para prueba activa del cortafuegos, timeout de escritura real y cierre de aceptación del piloto. Producción no autorizada por este ensayo.
