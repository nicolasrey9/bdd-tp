USE GD1C2025;
GO

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

PRINT '=== PROCESO DE CREACION COMPLETADO ==='
PRINT 'Todos los objetos fueron creados en el esquema BASADOS'
GO

PRINT 'INICIANDO PROCESO DE MIGRACION'
PRINT 'Todos los objetos fueron creados en el esquema BASADOS'
GO

PRINT 'Ejecutando migrate_tables.sql...'
GO
:r "migrate_tables.sql"
GO
PRINT 'Tablas migradas en esquema BASADOS'
GO

PRINT '=== PROCESO DE MIGRACION COMPLETADO ==='
PRINT 'Todos los objetos fueron creados en el esquema BASADOS'
GO
