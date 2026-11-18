---
title: "P2W — Smoke test funcional con cuenta runtime desde desarrollo"
type: plan
status: completed
created: 2026-11-18
updated: 2026-11-18
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2U-CUENTA-RUNTIME-MINIMO-PRIVILEGIO-2026-11-18.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2R-BOOTSTRAP-DESDE-DESARROLLO-2026-11-17.md"
tags: [qontrolmed, smoke-test, runtime, tls, p2w]
review_after: 2026-11-25
---

# P2W — Smoke test funcional con cuenta runtime desde desarrollo

## Autorización y objetivo

El propietario autorizó el 18/11/2026 continuar con el bloque recomendado tras
P2U. El objetivo es demostrar que el código actual arranca con la cuenta
runtime definitiva, supera TLS y el guard, permite login funcional y abre el
alcance del piloto sin utilizar una cuenta administrativa.

## Límites

- Ejecutar `main.py` desde el árbol de desarrollo actual.
- No construir, instalar ni conectar la RC histórica de julio.
- No leer, mover, sobrescribir ni eliminar `compartido/.env`.
- Inyectar la configuración solo en el proceso hijo y retirarla al cerrarlo.
- No activar el modo sin contraseña.
- No crear, modificar ni eliminar datos funcionales durante el smoke test.
- No abrir 3306 en LAN ni modificar MySQL, UFW, certificados o cuentas.
- Compras y analítica ampliada deben permanecer fuera de la navegación del
  piloto.

## Precondiciones

- P2U completo y `qontrolmed_runtime_dev@localhost` activa.
- MySQL `active/enabled`, sin unidades fallidas y solo en loopback.
- Certificado activo con SAN `127.0.0.1` y CA obtenida desde `@@ssl_ca`.
- Código local y pruebas críticas correctas.
- Administrador funcional con contraseña ya asignada mediante P2R.

## Secuencia

1. Revalidar scripts y pruebas locales de TLS, guard y bootstrap.
2. Preparar mediante `sudo` una copia temporal `0600` de la CA activa, sin
   copiar claves privadas.
3. Abrir un túnel SSH local con `ExitOnForwardFailure`.
4. Verificar SHA-256 de la CA y solicitar la contraseña runtime de forma
   oculta.
5. Lanzar `main.py` como proceso hijo con variables de entorno efímeras,
   `DB_TLS_REQUIRED=1`, hash fijado y
   `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`.
6. El propietario introduce la contraseña funcional en la UI.
7. Comprobar visualmente:
   - login correcto;
   - pantalla principal;
   - Compras y analítica ampliada ausentes;
   - apertura y cierre de Preventivos;
   - apertura y cierre de Quirófanos;
   - ninguna operación de alta, edición, cierre, importación o borrado.
8. Cerrar Qontrolmed y verificar salida correcta.
9. Retirar contraseña del entorno, CA temporal y túnel; comprobar que
   `compartido/.env` conserva existencia, tamaño y SHA-256 previos.
10. Revalidar línea base remota y retirar arneses temporales.

## Aceptación

- Qontrolmed supera TLS y el guard con la cuenta runtime.
- Login funcional correcto con modo sin contraseña desactivado.
- Preventivos y Quirófanos se abren sin error.
- Compras y analítica no aparecen en la navegación del piloto.
- No hay escrituras funcionales ni secretos en logs o evidencias.
- `.env` no cambia en existencia, tamaño ni SHA-256.
- MySQL termina `active/enabled`, sin unidades fallidas y solo en loopback.
- Se eliminan túnel, CA, variables y temporales.

## Reversión

Si falla antes de abrir la aplicación, cerrar túnel y retirar CA/secreto. Si la
aplicación falla, cerrarla sin reintentar escrituras, preservar únicamente el
error depurado y ejecutar la misma limpieza. Si `.env` cambia, detenerse y no
reconstruirlo automáticamente: comparar metadatos y solicitar decisión. P2W no
modifica la cuenta runtime ni requiere restauración de bases al no autorizar
escrituras.

## Resultado ejecutado

El primer intento alcanzó la conexión, pero mostró que
`load_dotenv(..., override=True)` sustituía la identidad runtime efímera por el
usuario del `.env` local. El intento se cerró antes del login y sin escrituras.
Se corrigió la precedencia para que el entorno explícito del proceso tenga
prioridad y `.env` complete solo valores ausentes; una prueba de regresión
protege ese contrato.

El segundo intento completó TLS, guard y login funcional. Gestión mínima,
Preventivos y Quirófanos abrieron y cerraron correctamente. El smoke descubrió
que el superusuario aún exponía Compras dentro de Gestión. Se centralizó el
alcance del piloto para diferir Compras, Estadísticas, proveedores, repuestos,
marcas, tipos de trabajo e importaciones históricas incluso para
superusuarios; se conservaron seguridad y maestros mínimos.

La repetición final confirmó:

- login funcional correcto con `qontrolmed_runtime_dev@localhost`;
- Gestión mínima, Preventivos y Quirófanos operativos en lectura;
- Compras y analítica ampliada ausentes de la navegación;
- cierre de Qontrolmed correcto;
- `.env` idéntico en existencia, tamaño y SHA-256;
- secreto, CA, túnel y temporales retirados;
- 95 pruebas automatizadas correctas y `git diff --check` sin errores;
- MySQL `active/enabled`, cero unidades fallidas y escucha exclusiva en
  `127.0.0.1:3306`.

No se realizaron altas, ediciones, importaciones, cierres funcionales ni
borrados; no se construyó o instaló una RC y no se abrió la LAN.
