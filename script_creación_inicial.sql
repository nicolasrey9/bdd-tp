-- 1. Primero creamos el esquema BASADOS si no existe
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'BASADOS')
BEGIN
    EXEC('CREATE SCHEMA BASADOS')
    PRINT 'Esquema BASADOS creado exitosamente'
END
ELSE
BEGIN
    PRINT 'El esquema BASADOS ya existía'
END
GO

-- 2. Ahora establecemos el esquema por defecto para esta conexión
-- Esto hace que todos los objetos que creemos vayan a BASADOS automáticamente
DECLARE @sql NVARCHAR(200) = 'ALTER USER [' + USER_NAME() + '] WITH DEFAULT_SCHEMA = BASADOS';
EXEC sp_executesql @sql;
PRINT 'Esquema por defecto establecido a BASADOS para esta sesión'
GO

-- 3. Ejecutamos tus scripts originales SIN MODIFICARLOS
-- Como establecimos BASADOS como esquema por defecto, todo se creará allí
PRINT 'Ejecutando create_tables.sql...'
GO
:r "create_tables.sql"
GO
PRINT 'Tablas creadas en esquema BASADOS'

PRINT 'Ejecutando add_primary_keys.sql...'
GO
:r "add_primary_keys.sql"
GO
PRINT 'Primary keys agregadas en esquema BASADOS'

PRINT 'Ejecutando add_foreign_keys.sql...'
GO
:r "add_foreign_keys.sql"
GO
PRINT 'Foreign keys agregadas en esquema BASADOS'
GO



PRINT '=== PROCESO COMPLETADO ==='
PRINT 'Todos los objetos fueron creados en el esquema BASADOS'
GO