
### Recuperación contraseña 
	FLUSH PRIVILEGES;
	ALTER USER 'root'@'localhost' IDENTIFIED BY 'NuevaContraseña123';
	FLUSH PRIVILEGES;
	EXIT;
### Protocolo de pass
	ALTER USER 'administrador'@'localhost'
	IDENTIFIED WITH caching_sha2_password BY 'TU_PASSWORD_REAL';
	
	ALTER USER 'administrador'@'127.0.0.1'
	IDENTIFIED WITH caching_sha2_password BY 'TU_PASSWORD_REAL';