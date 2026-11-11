---
title: "Plan conjunto para completar el piloto doméstico"
type: plan
status: approved
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../00_seguimiento/estados/ESTADO-CAMBIO-03-PILOTO-2026-11-05.md"
tags: [mysql, seguridad, documentacion]
review_after: 2026-11-12
---

# Plan conjunto: completar el piloto doméstico

Aprobado expresamente por el propietario el 2026-11-05. Puesto piloto autorizado: este ordenador Windows (IP observada 192.168.1.107; revalidar antes de LAN). Una aprobación cubre todas las fases descritas; no pedir otra por sus pasos internos. No amplía el proyecto a producción.

## Alcance

Servidor srv-mm-01 en su red doméstica, un único puesto administrador/piloto y exclusivamente datos ficticios. No importar volcados existentes ni archivos empresariales. No modificar red, router, acceso SSH, reglas existentes ni inicio automático de MySQL. No publicar servicios en Internet ni instalar la CA como confianza global de Windows.

## Fases incluidas

1. Revalidar estado y certificado del cambio 03. Arrancar MySQL manualmente y comprobar que usa realmente las rutas TLS previstas. Si falla, detener y diagnosticar sin forzar recuperación.
2. Crear únicamente los esquemas nuevos piloto_mm_gestion, piloto_mm_quirofanos y piloto_mm_preventivos; si ya existen, detener para revisar. Crear cuenta mm_piloto_local@127.0.0.1 de privilegios mínimos sobre esos esquemas, REQUIRE SSL y contraseña aleatoria. Secretos solo en archivos protegidos fuera del repositorio, sin argumentos de proceso, chat o logs públicos. Administración por socket local; no modificar root.
3. Completar pruebas de sesión TCP autenticada con CA e identidad, TLS negociado, rechazo sin TLS, rechazo con CA o identidad incorrectas, operaciones ficticias permitidas y denegación fuera del alcance. No conceder FILE, privilegios globales, administración de cuentas ni GRANT OPTION.
4. Adaptar TLS, timeouts y errores de Qontrolmed en un checkout o rama aislada, preservando cambios previos y sin modificar instalaciones actuales. Revisar bootstrap sin ejecutar volcados existentes; usar solo estructura revisada y datos sintéticos en los esquemas piloto. Separar migraciones de operación; permisos adicionales solo si se justifican por funciones revisadas y se limitan a estos esquemas. No introducir repetición automática de escrituras ambiguas.
5. Preparar configuración exclusiva de prueba para Windows y distribuir solo CA pública. Confirmar IP actual y estabilidad del puesto antes de crear su cuenta por IP y una regla UFW TCP/3306 /32. Si no hay reserva confirmada, volver a verificar la IP antes de cada prueba y retirar la regla al terminar; pedir al propietario la reserva solo como dato técnico necesario, sin modificar el router automáticamente. Usar inicialmente la IP del servidor incluida en SAN, evitando cambios DNS/hosts.
6. Para la prueba LAN, cambiar bind-address a 127.0.0.1,192.168.1.31 y permitir 3306 exclusivamente desde la IP comprobada del puesto. Validar antes de arrancar, comprobar escucha y reglas y probar desde un segundo origen si está disponible. Si no existe segundo origen, registrar la limitación y no afirmar esa prueba como realizada.
7. Probar aplicación con datos sintéticos: operaciones representativas en los tres módulos, límites de espera, desconexión y recuperación sin duplicación de escrituras. Ampliar tests solo donde verifiquen estos riesgos y no reflejen trivialmente el código.
8. Crear copia lógica exclusivamente de los tres esquemas ficticios y restaurarla en esquemas nuevos de ensayo. Guardar la copia solo en ubicación protegida del piloto; verificar estructura y contenido. Esto no valida todavía una política 3-2-1 ni autoriza copias de producción. No borrar esquemas al terminar sin orden específica.
9. Cerrar la sesión de ensayo: detener/deshabilitado MySQL, retirar solo la nueva regla UFW piloto, restaurar escucha loopback y validar configuración. Conservar esquemas y bloquear las cuentas nuevas al finalizar, cerrando sesiones propias si las hubiera. Guardar evidencia no secreta, resultados y pendientes en la estructura del proyecto. Mantener CA y clave privadas protegidas.

## Aceptación y límites

Sesión autenticada con identidad comprobada, rechazo explícito de TCP sin TLS con la misma cuenta, CA/nombre incorrectos rechazados, permisos mínimos, operación de Qontrolmed con datos ficticios y copia/restauración comprobada. Distinguir pruebas superadas, inconclusas y no realizadas. No declarar producción preparada ni piloto completo si quedan criterios esenciales pendientes.

## Riesgos y reversión

Riesgos: errores en permisos/código, apertura LAN excesiva, secreto filtrado y operaciones duplicadas ante caída de red. Mitigación: aislamiento, cuentas limitadas, regla /32, registros sin secretos y pruebas negativas. Ante fallo, detener MySQL, retirar la regla creada, restaurar configuración segura previa y mantener arranque automático deshabilitado. Bloquear cuentas del piloto sin tocar cuentas existentes; conservar evidencia y datos ficticios. Los cambios de aplicación se aíslan del trabajo previo. No borrar ni restaurar encima de datos existentes.

## Intervenciones del propietario

La contraseña sudo se introduce localmente cuando sea necesaria; no se cambiarán las reglas de sudo para evitarla. Elegir o confirmar el puesto y aportar una reserva DHCP si se desea estabilidad LAN. Estas intervenciones no requieren reaprobar fases ya incluidas. Producción, datos reales, nuevos puestos, modificaciones de router y acciones destructivas quedan fuera del alcance.


## Estado tras las pruebas del 2026-11-05

Fases técnicas y servicios representativos ejecutados con resultado correcto y cierre seguro. Aceptación global parcial: pendientes revisión visual, prueba desde segundo origen, restauración del esquema funcional completo y revisión/entrega del código. Véase ../00_seguimiento/estados/CIERRE-TECNICO-PILOTO-DOMESTICO-2026-11-05.md. La aprobación del plan permanece vigente para sus fases pendientes; no exigir permiso por cada paso incluido.


## Pausa de sesión solicitada

El propietario pidió cerrar el trabajo del día. Plan autorizado conservado, ejecución en pausa hasta retomar. Véase ../00_seguimiento/estados/CIERRE-Y-PAUSA-PILOTO-2026-11-05.md. No confundir pausa con aceptación completa o revocación de la aprobación.

