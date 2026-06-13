-- Migracion funcional de `gestion.cecos` a maestro ampliado de Centros.
-- Compatible con servidores MySQL que no aceptan `ADD COLUMN IF NOT EXISTS`.
-- No renombra la tabla ni la columna legacy `Proyecto`; se mantiene como
-- nombre tecnico por compatibilidad con la aplicacion actual.

SET @schema_name := 'gestion';
SET @table_name := 'cecos';

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'direccion'
    ),
    'SELECT ''Columna direccion ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `direccion` varchar(255) DEFAULT NULL AFTER `Proyecto`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'codigo_postal'
    ),
    'SELECT ''Columna codigo_postal ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `codigo_postal` varchar(12) DEFAULT NULL AFTER `direccion`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'ciudad'
    ),
    'SELECT ''Columna ciudad ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `ciudad` varchar(120) DEFAULT NULL AFTER `codigo_postal`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'contacto_principal'
    ),
    'SELECT ''Columna contacto_principal ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `contacto_principal` varchar(120) DEFAULT NULL AFTER `ciudad`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'telefono_principal'
    ),
    'SELECT ''Columna telefono_principal ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `telefono_principal` varchar(30) DEFAULT NULL AFTER `contacto_principal`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'telefono_alternativo'
    ),
    'SELECT ''Columna telefono_alternativo ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `telefono_alternativo` varchar(30) DEFAULT NULL AFTER `telefono_principal`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'correo_electronico'
    ),
    'SELECT ''Columna correo_electronico ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `correo_electronico` varchar(180) DEFAULT NULL AFTER `telefono_alternativo`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'contacto_mantenimiento'
    ),
    'SELECT ''Columna contacto_mantenimiento ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `contacto_mantenimiento` varchar(120) DEFAULT NULL AFTER `correo_electronico`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'telefono_mantenimiento'
    ),
    'SELECT ''Columna telefono_mantenimiento ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `telefono_mantenimiento` varchar(30) DEFAULT NULL AFTER `contacto_mantenimiento`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'correo_mantenimiento'
    ),
    'SELECT ''Columna correo_mantenimiento ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `correo_mantenimiento` varchar(180) DEFAULT NULL AFTER `telefono_mantenimiento`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'documentacion_ref'
    ),
    'SELECT ''Columna documentacion_ref ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `documentacion_ref` varchar(255) DEFAULT NULL AFTER `correo_mantenimiento`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
    EXISTS(
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = @table_name
          AND COLUMN_NAME = 'observaciones'
    ),
    'SELECT ''Columna observaciones ya existe''',
    'ALTER TABLE `gestion`.`cecos` ADD COLUMN `observaciones` text DEFAULT NULL AFTER `documentacion_ref`'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
