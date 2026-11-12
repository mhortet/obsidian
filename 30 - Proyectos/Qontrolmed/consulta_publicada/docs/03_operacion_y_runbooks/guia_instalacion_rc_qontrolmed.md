# Guía de instalación de la RC de Qontrolmed

Fecha de revisión: 2026-07-17

## Alcance

Esta receta corresponde a una única organización con varios usuarios Windows.
La configuración y las salidas son compartidas en el equipo, mientras que los
binarios quedan protegidos frente a modificación por usuarios normales.

## Rutas

| Uso | Ruta |
| --- | --- |
| Aplicación | `C:\Program Files\Qontrolmed\` |
| Configuración | `C:\ProgramData\Qontrolmed\config\.env` |
| Salidas | `C:\ProgramData\Qontrolmed\output\` |
| Intercambio tablet | `C:\ProgramData\Qontrolmed\output\export_tablet\` |
| Certificados | `C:\ProgramData\Qontrolmed\docs\certificados\` |

## Modelo de permisos

- Administradores y `SYSTEM`: control total.
- Usuarios normales: lectura y ejecución de la aplicación.
- Usuarios normales: lectura de la configuración.
- Usuarios normales: modificación en salidas y certificados.

La aplicación necesita leer las credenciales de conexión. Por ello debe usarse
una cuenta MySQL técnica de privilegios mínimos, limitada a los esquemas y al
origen de red necesarios. La protección del fichero evita modificaciones por
usuarios normales, pero no pretende ocultar a un usuario que ejecuta la
aplicación una credencial que el propio proceso necesita consumir.

## Instalación inicial

1. Verificar el ZIP y el `MANIFEST-SHA256.csv` recibido.
2. Extraer el paquete en una carpeta temporal controlada.
3. Abrir PowerShell como administrador.
4. Ejecutar desde el paquete:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\instalar_qontrolmed_rc.ps1
```

El instalador inicial se detiene si detecta contenido previo en
`C:\Program Files\Qontrolmed`. No realiza actualizaciones ni elimina versiones.
Tampoco migra certificados, salidas históricas ni ningún otro dato operativo.

## Configuración

El directorio de configuración queda protegido para que los usuarios normales
solo puedan leerlo. La creación y modificación del `.env` se realiza mediante
el script administrativo incluido en la RC. El script crea el fichero desde la
plantilla si falta, abre el editor elevado y reaplica propietario y ACL al
cerrarlo.

1. Abrir PowerShell como administrador.
2. Ejecutar:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\configurar_qontrolmed_env.ps1
```

3. Completar los valores directamente en el editor abierto por el script.
4. Usar `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`.
5. Cerrar el editor; el script restaurará propietario y permisos.
6. No enviar el `.env` por correo ni incorporarlo a ZIP, documentación o
   copias del programa.
7. Ejecutar como usuario normal:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verificar_qontrolmed_rc.ps1
```

La verificación comprueba presencia y nombres de variables sin mostrar sus
valores, confirma que no existe un `.env` junto al ejecutable, comprueba
propietario y ACL del `.env`, la lectura de los archivos instalados, el permiso
de ejecución del EXE y la escritura en la carpeta de salida compartida.

### Corrección incorporada en RC5

En la instalación limpia validada el 2026-07-16 fue necesario intervenir sobre
los permisos y la propiedad del directorio o del fichero para completar la
configuración. RC5 incorpora `configurar_qontrolmed_env.ps1` para evitar esa
intervención manual y `verificar_qontrolmed_rc.ps1` rechaza propietario o
permisos distintos del modelo previsto.

Paquete preparado:

- versión: `2026.07.16-rc5`;
- ZIP: `Qontrolmed-RC-2026.07.16-rc5.zip`;
- comprobar siempre el fichero `.zip.sha256` antes de extraer;
- no reutilizar el `.env` instalado por RC4: completar o revisar la
  configuración mediante el script administrativo de RC5.

Si solo se necesita reparar propietario y ACL sin abrir el editor:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\configurar_qontrolmed_env.ps1 `
  -RepairOnly
```

## Acceso a salidas y exportación de auditoría

La portada incluye el botón `Abrir salidas`, que abre directamente
`C:\ProgramData\Qontrolmed\output` sin que el usuario tenga que navegar por una
carpeta oculta.

La exportación CSV de auditoría solo aparece para usuarios autorizados. Antes de
exportar muestra una advertencia sobre la posible inclusión de datos sensibles
y solicita el nombre y la ruta de destino. El fichero debe guardarse en una
ubicación protegida; los dispositivos extraíbles solo deben usarse con las
medidas autorizadas por la organización.

Este comportamiento fue validado correctamente en la instalación limpia del
2026-07-16.

## Inicio limpio de datos operativos

Las salidas y certificados existentes en el entorno de desarrollo son ejemplos
de trabajo y no son válidos para el piloto. Esto incluye todos los PDF
actualmente presentes: son pruebas funcionales sintéticas, no documentos
reales. No deben copiarse ni incorporarse al ZIP.

La primera instalación debe comenzar con estas carpetas vacías:

- `C:\ProgramData\Qontrolmed\output`;
- `C:\ProgramData\Qontrolmed\docs\certificados`.

Solo se conservarán los subdirectorios vacíos creados por el instalador. Los
informes, intercambios y certificados válidos se generarán o incorporarán ya
dentro del circuito productivo, con su trazabilidad correspondiente.

## Validación funcional mínima

- iniciar sesión con contraseña y usuario normal;
- confirmar que el usuario solo ve los módulos permitidos;
- abrir `Gestión`, Preventivos y Quirófanos según permisos;
- generar informes de Preventivos y Quirófanos y comprobar que aparecen en las
  rutas previstas bajo `ProgramData`;
- exportar e importar un fichero de prueba controlado con tablet;
- comprobar consulta y exportación CSV de auditoría;
- cerrar y volver a abrir la aplicación con otro usuario Windows autorizado.

Resultado de la validación del 2026-07-16:

- instalación completa desde cero: correcta;
- scripts SQL e instalación de los tres esquemas: correctos;
- instalación y arranque de la aplicación: correctos;
- solicitud de contraseña para el usuario inicial `administrador`: correcta;
- acceso del administrador y creación de nuevos usuarios: correctos;
- nuevos informes de Quirófanos y Preventivos: correctos y publicados en las
  rutas configuradas;
- exportación CSV: correcta, con advertencia de sensibilidad y selección de
  ruta;
- configuración del `.env`: funcional tras intervención manual sobre permisos;
  procedimiento corregido en RC5.

Resultado adicional comunicado el 2026-07-17 sobre RC5:

- instalación completada sin incidencias;
- creación del `.env` mediante el procedimiento administrativo: correcta;
- generación de PDF: correcta y en las rutas previstas bajo `ProgramData`;
- ACL generales y accesos funcionales según permisos: ya validados en RC3/RC4
  y no afectados por cambios de RC5;
- regresión puntual de RC5 confirmada: el usuario Windows normal puede ejecutar
  la aplicación y no puede modificar binarios ni configuración.

No es necesario repetir en RC5 toda la matriz de roles, visibilidad y acceso a
módulos salvo que se modifique posteriormente el código de autenticación o
autorización.

## No salida

No continuar si:

- el paquete contiene un `.env` real;
- falta el manifiesto de hashes;
- la aplicación escribe dentro de `Program Files`;
- aparecen salidas o certificados de ejemplo en `ProgramData`;
- un usuario normal puede modificar los binarios o la configuración;
- la propiedad o las ACL de configuración quedan en un estado distinto del
  modelo previsto;
- no se ha ensayado backup/restauración;
- falla el login normal o algún módulo necesario para el primer corte.
