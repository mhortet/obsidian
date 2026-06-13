---
tags:
  - software
  - Error
  - SQL
Creado:
Autor:
Relacionado:
---
## Resumen

## Descripción


Sí, puedes restablecerla fácilmente directamente con tu usuario con "plenos poderes" si este cuenta con el privilegio `GRANT OPTION` o acceso a la tabla `mysql.user`, sin necesidad de reiniciar el servidor. Si por alguna razón ese usuario no tuviese permisos suficientes sobre la cuenta de root, tendrás que usar el método tradicional reiniciando el servicio en modo seguro. [1, 2]

A continuación, se presentan las dos opciones estructuradas paso a paso.

---

## Método 1: Usando tu usuario con "plenos poderes" (Sin reiniciar)

Si tu usuario alternativo realmente tiene privilegios globales de administración (como `CREATE USER`, `ALTER USER` o `SUPER`), ejecuta lo siguiente:

## 1. Iniciar sesión

Accede a MySQL utilizando la terminal o consola de comandos con tu usuario administrador:

```bash
mysql -u TU_USUARIO_ADMIN -p
```

## 2. Cambiar la contraseña

Una vez dentro de la consola de MySQL, ejecuta la consulta correspondiente según la versión de tu servidor: [2]

- Para MySQL 5.7, MySQL 8.0 o versiones superiores:
    
    ```sql
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'NuevaContraseña123';
    FLUSH PRIVILEGES;
    ```
    
- Para versiones antiguas (MySQL 5.6 o inferiores):
    
    ```sql
    UPDATE mysql.user SET Password=PASSWORD('NuevaContraseña123') WHERE User='root' AND Host='localhost';
    FLUSH PRIVILEGES;
    ```
    
    [2, 3]

Si este método te devuelve un error de "Access denied" (Acceso denegado), significa que tu usuario actual no tiene el nivel de autorización requerido sobre el usuario root. En ese caso, recurre al método alternativo. [2]

---

## Método 2: Modo seguro `--skip-grant-tables` (Requiere acceso al S.O.)

Si el primer método falla, puedes saltarte temporalmente la comprobación de contraseñas de MySQL. Para esto es obligatorio que tengas acceso de administrador (root/sudo) al sistema operativo donde corre el servidor. [2, 4, 5]

## 1. Detener el servicio

Para modificar el comportamiento del motor, primero debes apagar el proceso activo de MySQL: [2]

- En Linux (Systemd):
    
    ```bash
    sudo systemctl stop mysql
    ```
    
- En Windows (CMD como Administrador):
    
    ```cmd
    net stop mysql
    ```
    
    [1, 2, 6]

## 2. Iniciar en modo seguro

Reinicia el servicio saltándote las tablas de privilegios y desactivando la red externa por seguridad: [1, 2]

- En Linux:
    
    ```bash
    sudo mysqld_safe --skip-grant-tables --skip-networking &
    ```
    
- En Windows: Navega con `cd` hasta la carpeta `bin` de tu instalación de MySQL y ejecuta:
    
    ```cmd
    mysqld --skip-grant-tables --skip-networking
    ```
    
    [1, 2, 6]

## 3. Acceder y actualizar

Abre una nueva ventana de la terminal (ya que la anterior se quedará ejecutando el proceso) y entra directamente sin introducir contraseña: [1, 2]

```bash
mysql -u root
```

Dentro de la consola, recarga los privilegios para habilitar el comando de edición y cambia la clave: [4]

```sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'NuevaContraseña123';
FLUSH PRIVILEGES;
EXIT;
```

## 4. Restaurar el servicio normal

Es sumamente crítico volver a levantar el servidor de forma habitual para no dejar la base de datos expuesta: [2]

- En Linux:
    
    ```bash
    sudo pkill mysqld
    sudo systemctl start mysql
    ```
    
- En Windows: Cierra la ventana del proceso seguro y ejecuta:
    
    ```cmd
    net start mysql
    ```
    
    [2, 6]

---

## ✅ Restablecimiento Exitoso

Al finalizar cualquiera de estos dos procedimientos, la contraseña del usuario administrador principal habrá sido actualizada. Podrás comprobar inmediatamente la conexión ejecutando de forma habitual: `mysql -u root -p`. [2]

Si experimentas algún inconveniente durante el proceso, indícame:

- ¿Qué sistema operativo utiliza tu servidor? (Ubuntu, CentOS, Windows, etc.)
- ¿Qué versión exacta de MySQL estás ejecutando?
- ¿Qué error específico se despliega al intentar el Método 1?

Con estos datos adicionales podré proporcionarte los comandos exactos ajustados a tu entorno.

  

[1] [https://codigofacilito.com](https://codigofacilito.com/articulos/restablecer_password_root_mysql)

[2] [https://help.clouding.io](https://help.clouding.io/hc/es/articles/360011456619-C%C3%B3mo-recuperar-la-contrase%C3%B1a-de-root-de-MySQL)

[3] [https://www.ochobitshacenunbyte.com](https://www.ochobitshacenunbyte.com/2018/06/13/cambiar-contrasenas-de-usuarios-en-mysql-y-mariadb/)

[4] [https://dev.mysql.com](https://dev.mysql.com/doc/refman/9.6/en/resetting-permissions.html)

[5] [https://www.arsys.es](https://www.arsys.es/blog/cambiar-contrasena-linux)

[6] [https://www.youtube.com](https://www.youtube.com/watch?v=bcY1AhMH23I)