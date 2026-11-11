---
title: "Servicios funcionales: incompatibilidad de marcas y limitación visual"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/SERVICIOS-FUNCIONALES-RESULTADO-PARCIAL-2026-11-05.txt"
  - "../../05_evidencias/PILOTO-VENTANA-FUNCIONAL-CIERRE-2026-11-05.txt"
tags: [mysql, seguridad, documentacion]
review_after: 2026-11-12
---

# Resultado de la fase funcional

La aplicación aislada arrancó y expuso una ventana titulada Qontrolmed - PILOTO FICTICIO. El harness inicializó la contraseña exclusivamente del administrador sintético mediante el servicio real y verificó autenticación correcta e incorrecta. La credencial generada permanece solo en usuario-aplicacion-piloto.json dentro del directorio Windows protegido. No se automatizó el diálogo de login; no declarar probado ese diálogo ni el asistente gráfico.

## Limitación de control visual

@oai/sky localizó una ventana única del piloto. La primera captura falló con FrameArrived timed out: timed out waiting on channel. Se recuperó la selección desde list_windows y se reintentó una vez: window capture timed out: timed out waiting on channel. Se detuvo la automatización visual sin hacer clic ni usar coordenadas antiguas. No se usó otro mecanismo para automatizar ventanas como alternativa. Pantallas/flujo visual no validados.

## Pruebas de servicios, independientes de UI

Se ejecutó el código real de servicios contra las bases ficticias. Las notificaciones visuales se sustituyeron por un mock dentro de este proceso de test de negocio, para no abrir mensajes UI. No sustituye una revisión visual.

- Autenticación y permisos de superusuario sintético: correctos.
- Gestión: alta de marca falla con 1364. El DDL consultado contiene idMarcas INT NOT NULL sin AUTO_INCREMENT, mientras guardar_marca inserta únicamente Descripcion. La tabla marcas sigue vacía por el fallo; no se modificó la instancia MySQL80 original.
- Quirófanos: crear, listar, modificar y desactivar un instrumento ficticio con los servicios reales: correcto. Se conserva el instrumento desactivado, identificador sintético PILOTO-20261105.
- Preventivos: obtener_o_crear_punto crea un punto sintético y su repetición devuelve el mismo ID sin duplicación; consulta de campaña activa vacía correcta.

## Cierre seguro

Se terminó únicamente el proceso creado para el harness (PID 5296, ruta de lanzador verificada) al no poder controlar su ventana. Se solicitó cierre de LAN mediante FINALIZAR. El script confirmó bloqueo de cuenta, retirada de regla y restauración local. Revalidación SSH: inactive/disabled, sin escucha 3306/33060, hash .cnf de la línea base correcto. No se tocó la aplicación habitual ni la base local original.

## Corrección preparada dentro del plan aprobado

Script corregir-marcas-y-abrir-piloto.py preparado, copiado y verificado. Comprueba estado local y marcas vacía con definición exacta; conserva copia lógica privada en /root/srv-mm-piloto-20261105/correccion-marcas/. Aplica exclusivamente ALTER TABLE piloto_mm_gestion.marcas MODIFY COLUMN idMarcas INT NOT NULL AUTO_INCREMENT; no toca tabla original ni otros esquemas. El índice único existente en idMarcas permite el autoincremento. Verifica EXTRA=auto_increment y detiene MySQL. Si falla tras alterar, intenta restaurar la definición sin autoincremento, sin borrar filas.

Después abre automáticamente la ventana LAN --resume con los mismos límites aprobados para repetir servicios desde este PC. Pendiente ejecución sudo. Si ya existe el directorio de corrección, no repetir automáticamente: revisar resultado.

Script probar-servicios-funcionales.py actualizado para reconocer y verificar el instrumento ficticio previo sin recrearlo ni cambiar registros ajenos. Tras el ajuste, repetir alta/consulta/modificación de marca y validar los otros servicios. El punto de Preventivos es idempotente. Mantener pendiente la revisión visual hasta resolver el fallo de captura o recibir comprobación manual del propietario.

## Rectificación vigente

Propuesta de autoincremento retirada tras aclaración del propietario. Preservar ID manual e importados; corregir el envío del ID desde formulario al servicio. Véase ../../01_gobierno_y_decisiones/DECISION-IDS-MARCAS-MANUALES-2026-11-05.md. El ALTER fue rechazado con 1833, MySQL sigue detenido y no se abrió LAN. Suite tras corrección de código: 39 pruebas correctas; integración pendiente.

