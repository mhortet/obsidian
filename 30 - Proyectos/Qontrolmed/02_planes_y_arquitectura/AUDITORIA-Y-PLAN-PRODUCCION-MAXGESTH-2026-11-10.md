---
title: "Auditoría y plan de preparación para producción de maxgesth/Qontrolmed"
type: audit-plan
status: proposed
created: 2026-11-10
updated: 2026-11-10
sources:
  - "docs/01_gobierno_y_decisiones/DECISION-CICLO-VIDA-SOPORTE-RELEASE-PILOTO-2026-11-10.md"
  - "docs/90_archivo/documentacion_sustituida/estado_continuidad_2026-07.md"
  - "docs/90_archivo/documentacion_sustituida/plan_seguridad_consistencia_2026-07.md"
  - "docs/03_operacion_y_runbooks/security_delivery_playbook.md"
  - "docs/03_operacion_y_runbooks/guia_instalacion_rc_qontrolmed.md"
  - "H:/02.Trabajo/obsidian/30 - Proyectos/Servidor_MM/Servidor/CONTINUAR-SIGUIENTE-SESION.md"
  - "H:/02.Trabajo/obsidian/30 - Proyectos/Servidor_MM/Servidor/00_seguimiento/estados/REVISION-CODIGO-Y-EMPAQUETADO-QONTROLMED-2026-11-05.md"
tags: [qontrolmed, auditoria, produccion, seguridad, testing]
review_after: 2026-11-24
---

# Auditoría y plan de preparación para producción de maxgesth/Qontrolmed

## 1. Resumen ejecutivo

La situación actual se clasifica como **NO-GO para producción**.

Qontrolmed dispone de una base funcional relevante: instalación RC5 ensayada, separación entre código y datos de ejecución, autenticación con contraseña, roles, permisos, auditoría básica, empaquetado `onedir`, scripts de instalación y verificación, migraciones SQL, pruebas de backup/restauración históricas y contratos de intercambio con las aplicaciones móviles.

Sin embargo, la referencia integrada en `main` no reúne hoy las condiciones necesarias para trabajar con datos reales en una red de cliente:

1. El código de `main` conecta con MySQL sin exigir TLS ni verificar la identidad del servidor.
2. La implementación TLS está aislada y sin commit en `pilot/mysql-tls-20261105`; su instalación está bloqueada porque la RC no provisiona ni verifica de forma reproducible la CA pública de sede.
3. El análisis de dependencias del 9 de noviembre de 2026 falló con 73 registros de vulnerabilidad en Pillow 12.3.0 y pypdf 6.14.2. El workflow completo figura como correcto porque los trabajos de seguridad usan `continue-on-error: true`.
4. La cobertura automatizada del código crítico es insuficiente: 24 pruebas en `main` para unas 25.400 líneas Python. No existe una batería suficiente de autenticación, autorización, auditoría, migraciones, concurrencia, pérdida de conexión y consistencia transaccional.
5. El repositorio conserva artefactos de runtime y binarios pesados versionados, pese a que la documentación indica que no deben formar parte de los commits funcionales.
6. La estrategia de migraciones, copias, recuperación, observabilidad y respuesta a incidentes todavía no está cerrada para el entorno real.
7. La documentación es abundante, pero parte de la continuidad quedó congelada en julio y compite con evidencia y decisiones más recientes de `Servidor_MM`.

La recomendación es no construir ni instalar una nueva RC de producción hasta cerrar las puertas P0 y P1 de este documento.

**Actualización de decisiones, 10 de noviembre de 2026**: se incorpora la
orientación del propietario del proyecto sobre alcance, puestos, servidor,
ficheros y recuperación. Las decisiones 1 y 7 quedan definidas; 2, 3, 5 y 6
quedan parcialmente definidas; 4 requiere una decisión técnica distinta de
los roles de la aplicación; y 8, 9 y 10 se detallan para resolverlos al abordar
la preparación productiva. Esta actualización no cambia el estado **NO-GO**.

## 2. Alcance y método

### 2.1. Alcance revisado

- Repositorio local `D:\trabajo\Proyectos\maxgesth`.
- Estado de Git, ramas, historial, tags, ficheros versionados y cambios locales.
- Código Python bajo `src/`.
- Esquemas, bootstrap y migraciones bajo `bd/`.
- Scripts de construcción, instalación, configuración, verificación y backup.
- Tests y workflows de GitHub Actions.
- Documentación viva, histórica y de preproducción.
- Estado remoto de CI, trabajos de seguridad y pull requests del repositorio privado.
- Integración prevista con `srv-mm-01` según la documentación de `Servidor_MM`.
- Worktree aislado `pilot/mysql-tls-20261105`, solo para contrastar el estado del cambio TLS.

### 2.2. Acciones no realizadas

- No se modificó código, configuración, Git, bases de datos, servidor ni aplicaciones.
- No se ejecutó Qontrolmed.
- No se ejecutaron tests locales para evitar escrituras, conexiones o efectos laterales no autorizados.
- No se construyó ni instaló ninguna RC.
- No se conectó por SSH a `srv-mm-01`; su estado actual debe revalidarse antes de cualquier intervención.
- No se inspeccionaron secretos, `.env` reales, credenciales ni datos de cliente.

Por tanto, esta es una auditoría estática y documental fechada, no una certificación de funcionamiento en producción.

## 3. Línea base observada

### 3.1. Repositorio y release

- Rama local: `main`, alineada con `origin/main` en `014bf7c7b3c80c514786c36d1135efe00202b7a0`.
- Último commit integrado: 18 de julio de 2026.
- Último CI de `main`: correcto el 18 de julio de 2026.
- Cambios locales preexistentes, que deben preservarse:
  - modificados `docs/Tareas Pendientes.md` y `docs/mapa_documental_proyecto.md`;
  - nuevos `docs/backlog_evolutivo.md` y `historico_doc/2026-07-18_backlog_evolutivo/`.
- Existen pull requests Dependabot abiertos para acciones y varias dependencias.
- `main` no está protegido; la API de GitHub indica que la protección de rama no está disponible para este repositorio privado con el plan actual.
- Los avisos Dependabot están deshabilitados.

### 3.2. Tamaño y composición

- 2.137 rutas versionadas.
- 1.847 rutas versionadas bajo `_internal/`, correspondientes principalmente a runtime empaquetado.
- 89 ficheros Python bajo `src/`, aproximadamente 25.403 líneas.
- 5 módulos de test en `main`, 24 casos detectados y unas 291 líneas de test.
- El pack de Git ocupa aproximadamente 115 MiB.
- Hay seis copias versionadas de ejecutables o DLL de `wkhtmltopdf`, tres pares duplicados de aproximadamente 30 MiB cada archivo.
- Hay exports JSON de prueba versionados en rutas que la documentación identifica como runtime.
- La copia local de Git contiene siete índices de pack sin su `.pack` correspondiente. `git fsck` terminó con código 0, pero mostró numerosos objetos colgantes. No es un bloqueo funcional inmediato, aunque aconseja sanear mediante un clon verificado, no con limpieza destructiva improvisada.

### 3.3. Arquitectura funcional

- Aplicación de escritorio Python/Tkinter empaquetada con PyInstaller.
- Tres esquemas MySQL: `gestion`, `quirofanos` y `preventivos`.
- Conexión directa desde cada puesto Qontrolmed a MySQL.
- Configuración de desarrollo en `compartido/.env` y de RC en `C:\ProgramData\Qontrolmed\config\.env`.
- Binarios en `C:\Program Files\Qontrolmed` y datos/salidas compartidos en `C:\ProgramData\Qontrolmed`.
- Gestión de usuarios, roles, permisos y auditoría básica en el esquema `gestion`.
- Preventivos y Quirófanos con generación PDF e intercambio offline con aplicaciones móviles.
- Compras e informes ampliados permanecen fuera del primer corte declarado.

### 3.4. Servidor previsto

La documentación de `Servidor_MM` establece que MySQL/Qontrolmed debe permanecer detenido hasta resolver el empaquetado de CA, los puestos autorizados y la validación correspondiente. El último cierre documentado del 6 de noviembre de 2026 deja MySQL `inactive/disabled`, pero este dato debe considerarse histórico hasta revalidarlo.

## 4. Fortalezas aprovechables

1. Existe una política explícita de no versionar `.env` reales y de separar binarios, configuración y datos.
2. La RC5 fue instalada y probada en un entorno controlado durante julio.
3. El bootstrap del administrador evita incorporar una contraseña real en SQL.
4. Las contraseñas se almacenan con PBKDF2-HMAC-SHA256, salt aleatorio y comparación constante.
5. Hay un modelo de roles/permisos y control de acceso a módulos.
6. Existen eventos de auditoría para accesos, operaciones sensibles e intercambios.
7. Los scripts de RC validan manifiestos, rutas, ACL y ausencia de `.env` junto al ejecutable.
8. Se han realizado pruebas históricas de backup lógico, restauración en esquemas separados y smoke test.
9. El trabajo aislado añade TLS con verificación de certificado e identidad, timeouts y `LOCAL INFILE` deshabilitado.
10. La documentación distingue piloto, preproducción y alcance diferido.

Estas fortalezas reducen el trabajo necesario, pero no sustituyen una revalidación actual ni corrigen los bloqueos indicados a continuación.

## 5. Registro priorizado de hallazgos

| ID | Severidad | Hallazgo | Evidencia principal | Impacto | Acción exigida |
| --- | --- | --- | --- | --- | --- |
| PRD-001 | Crítica | Dependencias con vulnerabilidades conocidas | `pip-audit` del 09/11/2026: 73 registros en Pillow 12.3.0 y pypdf 6.14.2 | Procesamiento de imágenes/PDF no confiables puede exponer el puesto o provocar denegación de servicio | Actualizar, revisar compatibilidad, ejecutar tests y bloquear la RC si el audit falla |
| PRD-002 | Crítica | Transporte MySQL no seguro en `main` | `src/compartido/configuracion.py` solo configura host, usuario, contraseña y timeout | Credenciales y datos pueden quedar expuestos o conectarse al servidor equivocado | Integrar TLS verificado y probar denegaciones |
| PRD-003 | Crítica | La CA de sede no está integrada en la RC | Revisión de `Servidor_MM` del 05/11/2026 | La aplicación TLS falla de forma segura, pero la instalación no es reproducible | Definir ruta, provisión, ACL, hash y verificación de CA pública |
| PRD-004 | Alta | El workflow de seguridad puede quedar verde con fallos | Los tres trabajos usan `continue-on-error: true`; el audit falla semanalmente y el workflow termina `success` | Falsa señal de conformidad y posible promoción de una RC vulnerable | Hacer bloqueante `pip-audit`, Bandit y Gitleaks; excepciones solo documentadas y acotadas |
| PRD-005 | Alta | Autorización y auditoría admiten degradación silenciosa | `tiene_permiso(..., fallback_allow=True)`; auditoría devuelve `False` ante error sin alertar | Un esquema incompleto puede abrir acceso o perder trazabilidad | Fallo cerrado en producción, health check de esquema y alerta operativa |
| PRD-006 | Alta | Cobertura de pruebas insuficiente en áreas críticas | 24 pruebas para aproximadamente 25.400 líneas | Regresiones no detectadas en acceso, datos, PDF, importación y recuperación | Matriz de pruebas unitarias, integración MySQL y aceptación |
| PRD-007 | Alta | Migraciones sin ledger ni rollback uniforme | SQL manual heterogéneo; varios `ALTER TABLE` y DDL no idempotentes | Estado de esquema incierto, reejecución peligrosa y recuperación difícil | Inventario, versión de esquema, precheck, backup, postcheck y rollback por migración |
| PRD-008 | Alta | No hay copia productiva independiente confirmada | Ensayos históricos y restic local; destino externo pendiente | Pérdida de datos o recuperación incompleta | Diseñar 3-2-1, cifrado, retención, monitorización y restauración periódica |
| PRD-009 | Alta | No está cerrada la topología de datos y ficheros | MySQL central y salidas/certificados en `ProgramData` de cada puesto | Dispersión de documentos, copias parciales y diferencias entre puestos | Decidir fuente de verdad, sincronización, retención y alcance de backup |
| PRD-010 | Alta | Artefactos de build y binarios versionados | 1.847 rutas `_internal/`; binarios `wkhtmltopdf` duplicados | Supply chain opaca, clones pesados y riesgo de empaquetar material legado | Retirar del índice en una rama controlada y distribuir por releases/artefactos |
| PRD-011 | Media-Alta | No hay protección efectiva de `main` | Rama remota sin protección | Cambios pueden llegar sin revisión ni checks requeridos | Definir alternativa: PR obligatoria por convención, CODEOWNERS y release gate manual |
| PRD-012 | Media-Alta | No consta firma del ejecutable o instalador | `codesign_identity=None`; entrega por ZIP y hashes | Windows puede mostrar advertencias y no existe identidad verificable del editor | Evaluar firma Authenticode; como mínimo, canal controlado, SHA-256 y custodia de release |
| PRD-013 | Media-Alta | Bloqueo de login solo en memoria del proceso | Estado Python local, reiniciable | Fuerza bruta distribuida o reinicio elimina el bloqueo | Persistencia o control en servidor, alertas y política de contraseña/MFA según riesgo |
| PRD-014 | Media | Auditoría sin política de retención e integridad cerrada | Pendiente reconocido en documentación | Crecimiento indefinido o evidencia incompleta | Definir eventos, retención, acceso, exportación, copia e integridad |
| PRD-015 | Media | Documentación de continuidad desactualizada | `estado_continuidad.md` termina en julio; integración de noviembre está en `Servidor_MM` | Una sesión puede partir de decisiones superadas | Adoptar el plan documental complementario |
| PRD-016 | Media | Higiene local de Git degradada | Índices de pack huérfanos y muchos objetos colgantes | Riesgo operativo durante futuras limpiezas | Clon limpio verificado y comparación antes de retirar el checkout antiguo |

## 6. Decisiones de arquitectura que deben cerrarse

Antes de implementar cambios productivos deben quedar aprobadas y verificadas
las siguientes decisiones. La columna «pendiente» no invalida lo ya decidido:
identifica la información que todavía hace falta para ejecutar sin suposiciones.

| Nº | Decisión incorporada | Estado | Pendiente antes de producción |
| --- | --- | --- | --- |
| 1 | **Alcance inicial**: Gestión mínima exclusivamente como soporte de Preventivos y Quirófanos. Las opciones de Compras y analítica ampliada no formarán parte de la navegación productiva y permanecerán ocultas en los menús. No se elimina su código en esta fase. | Definida | Verificar con pruebas de permisos y navegación que ningún perfil del piloto pueda abrir Compras ni analítica por una ruta alternativa. |
| 2 | **Puestos autorizados**: acceso a MySQL limitado por IP de origen dentro de la LAN aprobada. El administrador del servidor será responsable de infraestructura y puestos. Las altas y bajas de usuarios funcionales se gestionan con usuarios, roles y permisos de Qontrolmed. | Parcial | Inventario nominal de puestos, sistema operativo, IP fija o reserva DHCP y procedimiento para añadir o retirar una IP. La autorización de red y el alta de un usuario en Qontrolmed son controles distintos y deben completarse ambos. |
| 3 | **Conectividad MySQL**: se utilizará como base la infraestructura en desarrollo documentada en `H:\02.Trabajo\obsidian\30 - Proyectos\Servidor_MM`. El acceso seguirá siendo LAN y restringido por origen. | Parcial | Revalidar el estado real de `srv-mm-01`; fijar DNS estable, CA pública de sede, TLS obligatorio, puertos y reglas exactas de firewall antes de habilitar puestos. La configuración histórica no se da por vigente sin comprobación. |
| 4 | **Cuenta técnica de base de datos**: los roles y permisos de Qontrolmed controlan lo que puede hacer cada usuario dentro de la aplicación, pero no sustituyen los privilegios de la cuenta con la que el programa conecta a MySQL. | Pendiente técnica | Crear una cuenta técnica sin privilegios globales y definir los `GRANT` mínimos por esquema y operación. Si todos los puestos comparten cuenta técnica, esta será distinta de los usuarios funcionales y su secreto se custodiará fuera del código. Validar que no pueda administrar usuarios MySQL, crear esquemas ni acceder a otros datos. |
| 5 | **Ficheros operativos**: se mantiene la selección de carpeta por el usuario y la salida local actual. Se estudiará que la ubicación predeterminada sea una carpeta del servidor de archivos, sin eliminar la posibilidad de seleccionar otro destino autorizado. | Parcial | Probar permisos, concurrencia, pérdida de red, nombres duplicados, trabajo temporal sin servidor, copia de seguridad y recuperación. Decidir qué ficheros son fuente de verdad: PDF, certificados e intercambios. |
| 6 | **Datos iniciales**: la aplicación ya contiene la estructura para centros, usuarios, roles, plantillas, puntos de control y equipos de medida. | Parcial | Designar una persona responsable del cliente para validar el contenido y dejar evidencia de aceptación. El administrador puede cargar o corregir datos, pero no debe asumir por sí solo la validación funcional del cliente. |
| 7 | **RPO/RTO**: objetivo RPO de 24 horas y RTO de 1 día. Se admite estudiar un máximo de 2 días de RTO como contingencia contractual, pero no se rebaja el objetivo técnico inicial de 1 día. | Definida técnicamente | Medirlos en una restauración real y obtener aceptación del cliente; precisar si «día» significa día natural o laborable. |
| 8 | **Retención**: SemVer y Git completo; backups diarios con mínimo 7 diarios y 3 mensuales, copia independiente cifrada, restauración periódica, logs técnicos 15 días, auditoría separada y builds N/N-1. | Definida para piloto | Concretar destino independiente, retención de auditoría y ficheros documentales, y plazo de exports/temporales con el cliente. |
| 9 | **Soporte y recuperación**: soporte asíncrono solo para `latest`, sin 24/7 ni LTS; críticos prioritarios dentro de la ventana acordada y mejoras en ciclo mensual; observabilidad local ligera. | Definida para piloto | Fijar horario, canal, contacto, severidades y autorizadores de restauración, migración y rollback. |
| 10 | **Canal de release**: `dev → tag → build limpio → RC efímera con datos ficticios → prod`; paquete inmutable con hash, manifiesto, SBOM y N-1. No se compila en producción. | Definida para piloto | Concretar custodia y aprobación; decidir Authenticode. El rollback de aplicación queda condicionado por la compatibilidad del esquema o restauración previa. |

### 6.1. Decisión 8: retención

La política aprobada para el piloto se desarrolla en
`docs/01_gobierno_y_decisiones/DECISION-CICLO-VIDA-SOPORTE-RELEASE-PILOTO-2026-11-10.md`.
P0/P2 deben convertirla en una matriz operativa con categoría, plazo,
ubicación, acceso, copia, restauración y eliminación.

- **auditoría de aplicación y accesos**: conservar el tiempo que acuerden el
  responsable del cliente y sus requisitos internos; acceso restringido al
  soporte autorizado y exportación protegida cuando sea necesaria;
- **informes PDF y certificados**: conservarlos en la ubicación declarada como
  fuente de verdad y cubrirlos con la misma política de copia y recuperación;
- **ficheros de intercambio móvil**: eliminar o archivar tras confirmar la
  importación y vencer el periodo operativo acordado, evitando acumulaciones en
  los puestos;
- **temporales y exportaciones auxiliares**: limpieza automática con plazo
  corto y verificable; nunca deben convertirse en la única copia;
- **copias**: combinar varias generaciones y una copia independiente, cifrada
  y probada. Los plazos concretos se fijarán al diseñar la política 3-2-1.

La base numérica ya está fijada para backups, logs y builds. En P0/P2 debe
concretarse con el cliente **la retención de auditoría y documentos, cuál es la
fuente de verdad y quién autoriza su eliminación**.

### 6.2. Decisión 9: soporte y recuperación

Hay que separar propiedad técnica, comunicación y autorización:

1. el administrador del servidor mantiene infraestructura, copias y acceso
   administrativo;
2. un contacto funcional del cliente valida el impacto y la recuperación del
   servicio;
3. los defectos de aplicación escalan al mantenedor/desarrollador con evidencia
   depurada y sin secretos;
4. una restauración, migración o rollback requiere responsable, ventana,
   comunicación previa y comprobación posterior.

La decisión que debes tomar es: **qué cobertura ofreces, por qué canal se abre
una incidencia, quién puede autorizar cambios y cuándo se escala**. RTO expresa
cuándo debe volver el servicio; el tiempo de primera respuesta de soporte es un
compromiso diferente.

### 6.3. Decisión 10: canal de release

El canal debe impedir que un ZIP suelto o una compilación local no identificada
se confunda con una versión instalable. Cada release debe incluir:

- versión única, commit/tag de origen y notas de cambios;
- paquete inmutable, SBOM y manifiesto SHA-256;
- resultado de tests y puertas de seguridad;
- repositorio o almacén protegido con acceso de publicación limitado;
- versión anterior compatible y copia previa de datos para rollback;
- procedimiento de instalación, verificación, decisión de reversión y registro
  de quién aprobó la entrega.

La decisión que debes tomar es: **si se firma con Authenticode desde el primer
piloto, dónde se custodian las releases, quién las publica y aprueba, y cuánto
tiempo se conserva la versión anterior**. La recomendación mínima, aunque se
aplace la firma, es no distribuir nada sin hash, tag, custodia controlada y
rollback probado.

## 7. Plan de trabajo hacia producción

Las estimaciones son de trabajo técnico efectivo y no incluyen esperas de cliente, compra de certificados, desplazamientos o ventanas de mantenimiento.

### Fase P0. Congelación, inventario y línea base — 4 a 6 horas

**Objetivo**: preservar el estado actual y eliminar ambigüedades antes de tocar código.

Acciones:

1. Preservar y revisar los cambios locales documentales existentes.
2. Crear una rama `codex/produccion-readiness` desde un clon limpio o worktree verificado.
3. Registrar commit base, dependencias, ficheros versionados, estado de CI y artefactos existentes.
4. Reconciliar el worktree TLS aislado con `main` sin copiar a ciegas.
5. Confirmar alcance funcional congelado y las diez decisiones del apartado anterior.
6. Crear registro de riesgos, matriz de puertas y dueño de cada decisión.

**Aceptación**:

- no se pierde ningún cambio local;
- existe una única base técnica para el plan;
- se sabe qué ramas y artefactos son históricos;
- no se construye ninguna RC.

### Fase P1. Cierre de bloqueos críticos — 2 a 4 jornadas

**Objetivo**: dejar el código en condiciones de generar una RC candidata segura.

Bloques:

1. Actualizar Pillow y pypdf hasta versiones sin alertas abiertas aplicables.
2. Revisar el resto de dependencias y PRs Dependabot uno a uno, sin fusionar actualizaciones mayores solo porque CI compile.
3. Integrar TLS verificado:
   - `DB_TLS_REQUIRED=1` por defecto;
   - `ssl_verify_cert` y `ssl_verify_identity`;
   - TLS 1.2/1.3;
   - timeouts finitos;
   - `LOCAL INFILE` deshabilitado;
   - excepción sin TLS solo para loopback de laboratorio.
4. Diseñar provisión de CA pública:
   - ruta canónica junto al `.env` o subdirectorio protegido;
   - copia mediante canal controlado;
   - propietario Administradores y lectura de Usuarios;
   - prohibición de escritura por usuarios normales;
   - hash esperado o inventario firmado;
   - verificación previa al arranque.
5. Alinear `.env.example`, instalador, configurador, verificador, guía y tests.
6. Cambiar CI para que seguridad falle de verdad; cualquier excepción debe incluir identificador, alcance, vencimiento y aprobación.
7. Hacer que permisos y auditoría fallen de forma segura cuando falta el esquema requerido.

**Puerta P1**:

- `pip-audit` sin vulnerabilidades no aceptadas;
- Gitleaks y Bandit correctos;
- tests TLS positivos y negativos;
- aplicación rechaza CA ausente, CA incorrecta, nombre incorrecto y TLS desactivado fuera de loopback;
- el usuario normal no puede modificar `.env`, CA ni binarios;
- CI completo en verde sin `continue-on-error` en controles obligatorios.

### Fase P2. Gobierno de esquema, consistencia y recuperación — 2 a 4 jornadas

**Objetivo**: poder instalar, migrar y recuperar sin autoajustes ni estados desconocidos.

Acciones:

1. Crear un inventario ordenado de scripts base, bootstrap y migraciones.
2. Añadir tabla o ledger de versión de esquema por entorno.
3. Para cada migración definir:
   - precondiciones;
   - backup obligatorio;
   - ejecución única;
   - postcondiciones verificables;
   - reversión técnica o restauración prevista;
   - tiempo estimado y bloqueo.
4. Revisar atomicidad de cabecera-detalle, importaciones, cierres y regeneración de PDF.
5. Probar concurrencia y pérdida de conexión sin repetir escrituras ambiguas.
6. Definir el procedimiento de datos iniciales y validación por el cliente.
7. Diseñar y probar copia 3-2-1 de:
   - los tres esquemas MySQL;
   - configuración de Qontrolmed y CA pública;
   - informes, certificados e intercambios que se declaren fuente de verdad;
   - configuración necesaria del servidor.
8. Programar restauración selectiva y completa en un entorno aislado.

**Puerta P2**:

- base limpia instalable desde cero;
- actualización desde el estado previo reproducible;
- restauración verificada con hashes y smoke test;
- RPO/RTO medidos y aceptados;
- ninguna migración se ejecuta automáticamente al abrir la aplicación.

### Fase P3. Ampliación de pruebas y observabilidad — 3 a 5 jornadas

**Objetivo**: convertir los riesgos críticos en regresiones automatizadas y señales operativas.

Matriz mínima:

- autenticación, bootstrap y política de contraseña;
- bloqueo y desbloqueo de cuenta;
- roles, permisos y denegaciones;
- fallo cerrado si faltan tablas o permisos;
- escritura y fallo de auditoría;
- TLS y recuperación de conexión;
- migraciones y versión de esquema;
- operaciones transaccionales críticas;
- importación/exportación tablet, duplicados y reintentos;
- generación y anexado de PDF con entradas corruptas o grandes;
- rutas de runtime y ACL;
- build y contenido del paquete;
- backup/restauración y smoke test.

No se recomienda fijar como única meta un porcentaje global. La condición principal debe ser cobertura completa de rutas críticas; como indicador complementario, establecer al menos 80 % de cobertura de ramas en los servicios de seguridad, conexión, migración e importación.

Observabilidad mínima:

- salud de conexión y versión de esquema sin mostrar secretos;
- antigüedad de la última copia;
- fallos de backup, migración y auditoría;
- espacio de disco y crecimiento de tablas;
- accesos fallidos y bloqueos;
- reloj correcto en servidor y puestos;
- destinatario y prueba de recepción de alertas.

### Fase P4. Higiene de repositorio y supply chain — 1 a 2 jornadas

**Objetivo**: separar fuente, dependencia, runtime, evidencia y release.

Acciones:

1. Retirar del índice `_internal/`, exports y artefactos de runtime sin borrar material local útil hasta verificar su sustitución.
2. Eliminar duplicados de `wkhtmltopdf` del paquete piloto y decidir su futuro en el módulo Compras aplazado.
3. Mantener los binarios de terceros fuera del repositorio o acompañarlos de origen, versión, licencia y hash si existe una razón aprobada para conservarlos.
4. Generar SBOM de la RC y manifiesto SHA-256.
5. Fijar versiones de build y documentar el entorno reproducible.
6. Evaluar firma Authenticode del ejecutable/paquete.
7. Crear un clon limpio, ejecutar `git fsck`, comparar HEAD y archivar el checkout degradado antes de cualquier limpieza local.
8. Aplicar el plan documental complementario.

Una reescritura de historia para reducir el tamaño de Git queda fuera de este bloque: sería una acción de alto impacto, con plan y aprobación propios.

### Fase P5. RC candidata y preproducción integrada — 2 a 3 jornadas

**Objetivo**: validar una RC nueva contra una réplica controlada de la arquitectura final.

Secuencia:

1. Construir RC con número nuevo; no reutilizar RC5.
2. Verificar paquete, SBOM, hashes, ausencia de secretos y contenido permitido.
3. Instalar desde cero en un puesto Windows limpio.
4. Configurar `.env` y CA mediante el procedimiento administrativo.
5. Conectar a MySQL de prueba en `srv-mm-01` con reglas limitadas por origen.
6. Ejecutar matriz de acceso, roles, módulos, PDF, intercambios y auditoría.
7. Ejecutar migración y restauración de una copia ficticia.
8. Probar caída/reinicio de MySQL, pérdida de red y recuperación de la aplicación.
9. Confirmar ausencia de escucha pública y denegación desde un puesto no autorizado.
10. Cerrar servicios y retirar credenciales temporales al terminar.

**Puerta P5**:

- aceptación técnica completa con datos ficticios;
- cero secretos en artefactos y evidencias;
- rollback medido y probado;
- evidencia fechada y revisable;
- servidor y puestos vuelven a su línea base segura.

### Fase P6. Preparación de sede y aceptación — 1 a 3 jornadas más ventana de cliente

**Objetivo**: convertir la RC técnica en un piloto real controlado.

Requisitos previos:

- red y puestos inventariados;
- usuarios nominales y matriz de permisos aprobados;
- datos iniciales revisados por responsable del cliente;
- copia externa y alertas operativas;
- acceso administrativo y recuperación de energía/LUKS probados;
- ventana, responsable, rollback y comunicación acordados.

Ejecución:

1. backup y foto previa;
2. instalación y verificación de ACL;
3. provisión de CA y cuenta MySQL de mínimo privilegio;
4. carga controlada de maestros;
5. pruebas de aceptación con usuarios representativos;
6. validación de copias y restauración selectiva;
7. acta de entrada o reversión.

### Fase P7. Piloto productivo controlado — 2 a 4 semanas

- Revisión diaria los primeros días.
- Revisión semanal de incidentes, seguridad, consistencia, copias y rendimiento.
- No abrir funcionalidad nueva durante estabilización.
- Clasificar cada incidencia como bloqueo, seguridad, datos, operación o mejora.
- Decisión final: ampliar, mantener controlado, corregir y repetir, o retirar.

## 8. Orden recomendado con el plan documental

Las fases documentales D0-D3 se ejecutaron el 10 de noviembre de 2026 en la
rama `codex/estructura-documental-20261110`. D4 permanece pendiente hasta
conocer la arquitectura y release que realmente lleguen a producción.

Orden técnico actualizado:

1. revisar el diff documental y resolver la purga física controlada pendiente;
2. **P0**: línea base técnica, inventario de puestos, responsables y decisiones
   aún parciales;
3. **P1**: dependencias, TLS, CA, cuenta técnica MySQL y CI bloqueante;
4. **P2/P3**: migraciones, copias, retención, pruebas y observabilidad;
5. **P4**: cierre de higiene de repositorio y supply chain;
6. **P5/P6**: RC candidata, preproducción y sede;
7. **D4**: documento maestro de la entrega y archivo de la release sustituida;
8. **P7**: observación del piloto.

Detalle: [PLAN-ADAPTACION-DOCUMENTAL-MAXGESTH-AL-MODELO-SERVIDOR-2026-11-10.md](PLAN-ADAPTACION-DOCUMENTAL-MAXGESTH-AL-MODELO-SERVIDOR-2026-11-10.md).

## 9. Criterio de autorización futura

Este documento es una propuesta. Su aprobación debería autorizar solo el bloque o fase indicado, junto con sus pruebas, documentación y reversión. Cualquier ampliación material —datos reales, instalación en sede, cambios de red, firewall, MySQL, copias externas, borrado de artefactos o reescritura de Git— necesita quedar expresamente incluida en el plan aprobado.

## 10. Próxima decisión recomendada

Tras revisar la reorganización, autorizar **P0 de solo preparación técnica
local**, sin servidor ni datos reales, con estos entregables:

1. verificar en un clon limpio la retirada del índice de artefactos que no son
   fuente y la integridad del repositorio tras la purga ya realizada;
2. inventario de puestos con SO, IP y responsable;
3. propuesta exacta de cuenta técnica MySQL y privilegios mínimos;
4. plan técnico para integrar TLS y provisionar/verificar la CA de sede;
5. concreción operativa de la decisión aprobada sobre retención, soporte y
   canal de release;
6. matriz de pruebas y puertas de aceptación;
7. ninguna RC construida ni instalada todavía.
