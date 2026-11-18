---
title: "P2R — Bootstrap controlado desde el código de desarrollo"
type: plan
status: completed
created: 2026-11-17
updated: 2026-11-17
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2Q-BOOTSTRAP-FUNCIONAL-INICIAL-2026-11-17.md"
  - "docs/02_planes_y_arquitectura/PROPUESTA-CUENTA-TECNICA-MYSQL-P0-2026-11-11.md"
tags: [qontrolmed, bootstrap, desarrollo, mysql]
review_after: 2026-11-24
---

# P2R — Bootstrap controlado desde el código de desarrollo

## Objetivo y autorización

El propietario autorizó el 17/11/2026 la recomendación de ejecutar el código
actual desde el directorio de desarrollo, sin conectar la RC histórica de julio
y sin construir o instalar una RC nueva.

El objetivo es asignar la primera contraseña funcional mediante el flujo real
de noviembre usando una identidad MySQL temporal y mínima a través del túnel
SSH de Workbench.

## Límites

- No leer ni documentar la configuración local existente.
- Preservar y restaurar `compartido/.env` sin copiarlo dentro del repositorio.
- No reutilizar `qontrolmed_admin` en Qontrolmed.
- No crear todavía la cuenta runtime definitiva para puestos del piloto.
- No abrir 3306 en LAN.
- No dejar activos la cuenta temporal ni el modo sin contraseña.
- No registrar la contraseña técnica ni la contraseña funcional.

## Secuencia

1. Validar sintaxis e integridad de los tres arneses P2R.
2. Crear `qontrolmed_bootstrap@localhost` solicitando la contraseña técnica de
   forma oculta y concediendo solo las lecturas mínimas, actualización de las
   columnas de contraseña e inserción de auditoría.
3. Confirmar ausencia de privilegios globales, DDL y `GRANT OPTION`.
4. Mantener el túnel SSH local de Workbench en `127.0.0.1:13306`.
5. Mover temporalmente `compartido/.env` a una ruta privada bajo `%TEMP%`, sin
   leerlo; crear una configuración efímera con excepción TLS solo para la IP
   loopback protegida por el túnel SSH.
6. Ejecutar `main.py` con el código actual y el modo controlado de bootstrap.
7. El propietario introduce y confirma la contraseña funcional dentro de la
   UI de Qontrolmed.
8. Cerrar Qontrolmed; el lanzador elimina la configuración efímera y restaura
   el `.env` local original.
9. Verificar por consultas depuradas que existe un hash y que 4/40/75 y las
   relaciones permanecen correctas.
10. Retirar la cuenta temporal y comprobar su ausencia.

## Aceptación

- El flujo visual corresponde al código actual del repositorio.
- Un único superusuario activo termina con hash no vacío.
- El modo sin contraseña no persiste en la configuración restaurada.
- La cuenta temporal queda eliminada.
- MySQL sigue `active/enabled`, solo en loopback y sin unidades fallidas.
- No se expone ni conserva ningún secreto en evidencias o archivos temporales.

## Reversión

Si falla antes de asignar la contraseña, cerrar el lanzador, restaurar el `.env`
y retirar la cuenta temporal. Si falla después, no repetir el bootstrap a
ciegas: verificar el hash y restaurar la copia P2Q solo si la consistencia no
puede demostrarse. El lanzador restaura la configuración mediante `finally`.

## Estado al pausar el 17/11/2026

P2R no alcanzó la pantalla de acceso ni asignó la contraseña funcional. Durante
la ejecución se resolvieron de forma trazable tres bloqueos previos:

1. P2S corrigió `ruta_certificado` a `VARCHAR(500)` y aprovisionó el ledger
   canónico con sus dos versiones.
2. El lanzador pasó a resolver `ProjectRoot` después de `param` y a escribir el
   `.env` efímero en UTF-8 sin BOM.
3. El conector local se actualizó de 8.4.0 a la versión 9.7.0 fijada en
   `requirements.txt`; 23 pruebas de TLS, ledger y bootstrap pasaron.

Después, MySQL rechazó el acceso de `qontrolmed_bootstrap@localhost` con error
1045. El propietario repitió el intento, se rotó la contraseña temporal sin
cambiar privilegios y se realizaron otros dos intentos con el mismo resultado.
No se siguió repitiendo a ciegas.

Al cierre se comprobó que `compartido/.env` había sido restaurado, no quedaban
copias `qontrolmed-p2r-env-*.bak`, se detuvo el túnel local 13306 y se retiraron
los tres scripts P2R de `/tmp`. La cuenta temporal MySQL continúa existente y
debe retirarse con privilegios administrativos al inicio de la próxima sesión.
No contiene datos funcionales y conserva únicamente los permisos mínimos P2R.

### Continuidad exacta

1. Revalidar MySQL, loopback y unidades fallidas.
2. Copiar de nuevo y ejecutar `retirar_cuenta_bootstrap_temporal.sh`; verificar
   que la cuenta desaparece antes de cualquier otro intento.
3. Consultar de forma depurada `plugin`, `account_locked` y `password_expired`
   para la identidad temporal nueva, sin leer ni mostrar `authentication_string`.
4. Ajustar el arnés para verificar la credencial mediante una conexión mínima
   `SELECT 1` inmediatamente después de crearla y antes de abrir el túnel.
5. Probar la misma credencial por el túnel con un comprobador mínimo, antes de
   iniciar `main.py` o volver a mover `.env`.
6. Solo si ambos controles pasan, reanudar el bootstrap visual y retirar la
   cuenta temporal al terminar.

## Cierre ejecutado el 17/11/2026

P2R terminó correctamente después de resolver y verificar los siguientes
bloqueos:

- la cuenta temporal pasó `SELECT 1` primero por socket y después por el túnel;
- el arnés local pasó a usar `mysql.connector` 9.7.0 y una prueba Python
  externa, evitando dependencias del cliente `mysql` y problemas de comillas;
- la conexión real usó TLS obligatorio, CA pública verificada por SHA-256 e
  identidad válida para `127.0.0.1`;
- P2T corrigió la contradicción entre el ledger P2S con resultado `recovered`
  y el guard que solo admite `applied`, con copia previa y dos filas exactas;
- Qontrolmed superó el guard, mostró el flujo controlado y el propietario
  asignó la primera contraseña funcional sin compartirla ni registrarla;
- el cierre depurado confirmó 4 roles, 40 permisos, 75 asignaciones, cero
  huérfanos, un administrador activo con hash presente y ledger v1/v2
  `applied`;
- la cuenta temporal, los scripts de `/tmp`, el túnel y la CA pública temporal
  fueron retirados.

Durante los intentos, un defecto del bloque `finally` eliminó el `.env` local
antes de haber creado su copia efímera. No existía copia recuperable de
Qontrolmed. El propietario autorizó reconstruirlo mediante entrada local de
sus credenciales originales. El archivo resultante quedó en loopback, con
`QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`, ignorado por Git y validado sin
mostrar valores. Este incidente no afectó al servidor ni a la contraseña
funcional recién asignada.

Validación local final: 23 pruebas de TLS, guard de runtime y bootstrap
superadas. MySQL quedó `active/enabled`, sin unidades fallidas y limitado a
`127.0.0.1:3306`. Sigue pendiente diseñar la cuenta runtime definitiva; no se
ha abierto MySQL a la LAN ni se ha conectado una RC.
