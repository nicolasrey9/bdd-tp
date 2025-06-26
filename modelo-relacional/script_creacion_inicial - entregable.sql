
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
CREATE TABLE BASADOS.cliente(
    clie_id BIGINT IDENTITY(1,1) NOT NULL,
    clie_dni BIGINT NOT NULL,
    clie_nombre NVARCHAR(255) NOT NULL,
    clie_apellido NVARCHAR(255) NOT NULL,
    clie_mail NVARCHAR(255),
    clie_telefono NVARCHAR(255),
    clie_fecha_nac DATETIME2(6),
    clie_direccion NVARCHAR(255),
    clie_localidad BIGINT
)

CREATE TABLE BASADOS.localidad(
    local_id BIGINT IDENTITY(1,1) NOT NULL,
    local_nombre NVARCHAR(255) NOT NULL,
    local_provincia BIGINT NOT NULL
)

CREATE TABLE BASADOS.provincia(
    prov_id BIGINT IDENTITY(1,1) NOT NULL,
    prov_nombre NVARCHAR(255) NOT NULL
)

CREATE TABLE BASADOS.sucursal(
    suc_numero BIGINT NOT NULL,
    suc_mail NVARCHAR(255),
    suc_telefono NVARCHAR(255),
    suc_direccion NVARCHAR(255),
    suc_localidad BIGINT
)

CREATE TABLE BASADOS.pedido(
    ped_numero DECIMAL(18,0) NOT NULL,
    ped_fecha DATETIME2(6),
    ped_estado NVARCHAR(255),
    ped_total DECIMAL(18,2),
    ped_sucursal BIGINT,
    ped_cliente BIGINT
)

CREATE TABLE BASADOS.detalle_pedido(
    det_pedido DECIMAL(18,0) NOT NULL,
    det_numero BIGINT NOT NULL,
    det_cantidad BIGINT,
    det_sillon BIGINT
)

CREATE TABLE BASADOS.cancelacion(
    canc_pedido DECIMAL(18,0) NOT NULL,
    canc_fecha DATETIME2(6),
    canc_motivo VARCHAR(255)
)

CREATE TABLE BASADOS.proveedor(
    prov_cuit NVARCHAR(255) NOT NULL,
    prov_razon_social NVARCHAR(255),
    prov_telefono NVARCHAR(255),
    prov_mail NVARCHAR(255),
    prov_direccion NVARCHAR(255),
    prov_localidad BIGINT
)

CREATE TABLE BASADOS.compra(
    comp_numero DECIMAL(18,0) NOT NULL,
    comp_fecha DATETIME2(6),
    comp_total DECIMAL(18,2),
    comp_sucursal BIGINT,
    comp_proveedor NVARCHAR(255)
)

CREATE TABLE BASADOS.detalle_compra(
    det_compra DECIMAL(18,0) NOT NULL,
    det_material BIGINT NOT NULL,
    det_precio_unitario DECIMAL(18,2),
    det_cantidad DECIMAL(18,0)
)

CREATE TABLE BASADOS.factura(
    fact_numero BIGINT NOT NULL,
    fact_fecha DATETIME2(6),
    fact_cliente BIGINT,
    fact_sucursal BIGINT
)

CREATE TABLE BASADOS.detalle_factura(
    det_factura BIGINT NOT NULL,
    det_pedido DECIMAL(18,0) NOT NULL,
    det_numero BIGINT NOT NULL,
    det_precio_unitario DECIMAL(18,2),
    det_cantidad BIGINT
)

CREATE TABLE BASADOS.envio(
    env_numero DECIMAL(18,0) NOT NULL,
    env_fecha_programada DATETIME2(6),
    env_fecha DATETIME2(6),
    env_importe_traslado DECIMAL(18,2),
    env_importe_subida DECIMAL(18,2),
    env_factura BIGINT
)


CREATE TABLE BASADOS.modelo(
    mod_codigo BIGINT NOT NULL,
    mod_modelo NVARCHAR(255),
    mod_descripcion NVARCHAR(255),
    mod_precio_base DECIMAL(18,2)
)


CREATE TABLE BASADOS.sillon(
    sill_codigo BIGINT NOT NULL,
    sill_modelo BIGINT,
    sill_medida_alto DECIMAL(18,2),
    sill_medida_ancho DECIMAL(18,2),
    sill_medida_profundidad DECIMAL(18,2)
)

CREATE TABLE BASADOS.medida(
    med_alto DECIMAL(18,2) NOT NULL,
    med_ancho DECIMAL(18,2) NOT NULL,
    med_profundidad DECIMAL(18,2) NOT NULL,
    med_precio DECIMAL(18,2)
)

CREATE TABLE BASADOS.material_por_sillon(
    mat_sillon BIGINT NOT NULL,
    mat_material BIGINT NOT NULL
)

CREATE TABLE BASADOS.material(
    mat_id BIGINT IDENTITY(1,1) NOT NULL,
    mat_nombre NVARCHAR(255),
    mat_descripcion NVARCHAR(255),
    mat_precio DECIMAL(38,2),
    mat_tipo BIGINT
)

CREATE TABLE BASADOS.tipo_material(
    tipo_id BIGINT IDENTITY(1,1) NOT NULL,
    tipo_nombre NVARCHAR(255)
)

CREATE TABLE BASADOS.tela(
    tela_material BIGINT NOT NULL,
    tela_color NVARCHAR(255),
    tela_textura NVARCHAR(255)
)

CREATE TABLE BASADOS.relleno(
    rell_material BIGINT NOT NULL,
    rell_densidad DECIMAL(38,2)
)

CREATE TABLE BASADOS.madera(
    mad_material BIGINT NOT NULL,
    mad_color NVARCHAR(255),
    mad_dureza NVARCHAR(255)
)
GO

PRINT 'Tablas creadas en esquema BASADOS'

PRINT 'Ejecutando add_primary_keys.sql...'
GO
ALTER TABLE BASADOS.cliente
ADD CONSTRAINT PK_cliente 
PRIMARY KEY (clie_id);

ALTER TABLE BASADOS.provincia
ADD CONSTRAINT PK_provincia 
PRIMARY KEY (prov_id);

ALTER TABLE BASADOS.localidad
ADD CONSTRAINT PK_localidad 
PRIMARY KEY (local_id);

ALTER TABLE BASADOS.sucursal
ADD CONSTRAINT PK_sucursal 
PRIMARY KEY (suc_numero);

ALTER TABLE BASADOS.pedido
ADD CONSTRAINT PK_pedido 
PRIMARY KEY (ped_numero);

ALTER TABLE BASADOS.cancelacion
ADD CONSTRAINT PK_cancelacion 
PRIMARY KEY (canc_pedido);

ALTER TABLE BASADOS.detalle_pedido
ADD CONSTRAINT PK_detalle_pedido 
PRIMARY KEY (det_pedido, det_numero);

ALTER TABLE BASADOS.proveedor
ADD CONSTRAINT PK_proveedor 
PRIMARY KEY (prov_cuit);

ALTER TABLE BASADOS.compra
ADD CONSTRAINT PK_compra 
PRIMARY KEY (comp_numero);

ALTER TABLE BASADOS.factura
ADD CONSTRAINT PK_factura 
PRIMARY KEY (fact_numero);

ALTER TABLE BASADOS.envio
ADD CONSTRAINT PK_envio 
PRIMARY KEY (env_numero);

ALTER TABLE BASADOS.detalle_factura
ADD CONSTRAINT PK_detalle_factura 
PRIMARY KEY (det_factura, det_pedido, det_numero);

ALTER TABLE BASADOS.detalle_compra
ADD CONSTRAINT PK_detalle_compra
PRIMARY KEY (det_compra, det_material);

ALTER TABLE BASADOS.sillon
ADD CONSTRAINT PK_sillon
PRIMARY KEY (sill_codigo);

ALTER TABLE BASADOS.material
ADD CONSTRAINT PK_material
PRIMARY KEY (mat_id);

ALTER TABLE BASADOS.material_por_sillon
ADD CONSTRAINT PK_material_por_sillon
PRIMARY KEY (mat_sillon,mat_material);

ALTER TABLE BASADOS.modelo
ADD CONSTRAINT PK_modelo
PRIMARY KEY (mod_codigo);

ALTER TABLE BASADOS.medida
ADD CONSTRAINT PK_medida
PRIMARY KEY (med_alto, med_ancho, med_profundidad);

ALTER TABLE BASADOS.tipo_material
ADD CONSTRAINT PK_tipo_material
PRIMARY KEY (tipo_id);

ALTER TABLE BASADOS.tela
ADD CONSTRAINT PK_tela
PRIMARY KEY (tela_material);

ALTER TABLE BASADOS.relleno
ADD CONSTRAINT PK_relleno
PRIMARY KEY (rell_material);

ALTER TABLE BASADOS.madera
ADD CONSTRAINT PK_madera
PRIMARY KEY (mad_material);
GO
PRINT 'Primary keys agregadas en esquema BASADOS'

PRINT 'Ejecutando add_foreign_keys.sql...'
GO
ALTER TABLE BASADOS.cliente
ADD CONSTRAINT FK_Cliente_Localidad 
FOREIGN KEY (clie_localidad)
REFERENCES BASADOS.localidad(local_id)

ALTER TABLE BASADOS.localidad
ADD CONSTRAINT FK_Localidad_Provincia 
FOREIGN KEY (local_provincia) 
REFERENCES BASADOS.provincia(prov_id)

ALTER TABLE BASADOS.sucursal
ADD CONSTRAINT FK_Sucursal_Localidad
FOREIGN KEY (suc_localidad)
REFERENCES BASADOS.localidad(local_id)

ALTER TABLE BASADOS.pedido
ADD CONSTRAINT FK_Pedido_Sucursal 
FOREIGN KEY (ped_sucursal)
REFERENCES BASADOS.sucursal(suc_numero)

ALTER TABLE BASADOS.pedido
ADD CONSTRAINT FK_Pedido_Cliente 
FOREIGN KEY (ped_cliente)
REFERENCES BASADOS.cliente(clie_id)

ALTER TABLE BASADOS.cancelacion
ADD CONSTRAINT FK_Cancelacion_Pedido 
FOREIGN KEY (canc_pedido)
REFERENCES BASADOS.pedido(ped_numero)

ALTER TABLE BASADOS.detalle_pedido
ADD CONSTRAINT FK_Detalle_Pedido_Pedido 
FOREIGN KEY (det_pedido) 
REFERENCES BASADOS.pedido(ped_numero)

ALTER TABLE BASADOS.detalle_pedido    
ADD CONSTRAINT FK_Detalle_Pedido_Sillon 
FOREIGN KEY (det_sillon) 
REFERENCES BASADOS.sillon(sill_codigo)

ALTER TABLE BASADOS.proveedor
ADD CONSTRAINT FK_Proveedor_Localidad
FOREIGN KEY (prov_localidad)
REFERENCES BASADOS.localidad(local_id)

ALTER TABLE BASADOS.compra
ADD CONSTRAINT FK_Compra_Sucursal 
FOREIGN KEY (comp_sucursal)
REFERENCES BASADOS.sucursal(suc_numero)

ALTER TABLE BASADOS.compra
ADD CONSTRAINT FK_Compra_Proveedor 
FOREIGN KEY (comp_proveedor)
REFERENCES BASADOS.proveedor(prov_cuit)

ALTER TABLE BASADOS.factura
ADD CONSTRAINT FK_Factura_Cliente 
FOREIGN KEY (fact_cliente) 
REFERENCES BASADOS.cliente(clie_id)

ALTER TABLE BASADOS.factura        
ADD CONSTRAINT FK_Factura_Sucursal 
FOREIGN KEY (fact_sucursal)
REFERENCES BASADOS.sucursal(suc_numero)

ALTER TABLE BASADOS.envio
ADD CONSTRAINT FK_Envio_Factura 
FOREIGN KEY (env_factura)
REFERENCES BASADOS.factura(fact_numero)

ALTER TABLE BASADOS.detalle_compra
ADD CONSTRAINT FK_Detalle_Compra_Compra
FOREIGN KEY (det_compra)
REFERENCES BASADOS.compra(comp_numero)

ALTER TABLE BASADOS.detalle_compra
ADD CONSTRAINT FK_Detalle_Compra_Material
FOREIGN KEY (det_material)
REFERENCES BASADOS.material(mat_id)

ALTER TABLE BASADOS.detalle_factura
ADD CONSTRAINT FK_Detalle_Factura_Factura
FOREIGN KEY (det_factura)
REFERENCES BASADOS.factura(fact_numero)

ALTER TABLE BASADOS.detalle_factura
ADD CONSTRAINT FK_Detalle_Factura_Detalle_Pedido
FOREIGN KEY (det_pedido, det_numero)
REFERENCES BASADOS.detalle_pedido(det_pedido, det_numero)


ALTER TABLE BASADOS.sillon
ADD CONSTRAINT FK_Sillon_Medida
FOREIGN KEY (sill_medida_alto, sill_medida_ancho, sill_medida_profundidad)
REFERENCES BASADOS.medida(med_alto, med_ancho, med_profundidad);

ALTER TABLE BASADOS.material_por_sillon
ADD CONSTRAINT FK_Material_Por_Sillon_Sillon
FOREIGN KEY (mat_sillon)
REFERENCES BASADOS.sillon(sill_codigo)

ALTER TABLE BASADOS.material_por_sillon
ADD CONSTRAINT FK_Material_Por_Sillon_Material
FOREIGN KEY (mat_material)
REFERENCES BASADOS.material(mat_id)

ALTER TABLE BASADOS.material
ADD CONSTRAINT FK_Material_Tipo_Material
FOREIGN KEY (mat_tipo)
REFERENCES BASADOS.tipo_material(tipo_id)

ALTER TABLE BASADOS.tela
ADD CONSTRAINT FK_Tela_Material
FOREIGN KEY (tela_material)
REFERENCES BASADOS.material(mat_id)

ALTER TABLE BASADOS.relleno
ADD CONSTRAINT FK_Relleno_Material
FOREIGN KEY (rell_material)
REFERENCES BASADOS.material(mat_id)

ALTER TABLE BASADOS.madera
ADD CONSTRAINT FK_Madera_Material
FOREIGN KEY (mad_material)
REFERENCES BASADOS.material(mat_id)
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
CREATE INDEX idx_prov_nombre ON BASADOS.provincia (prov_nombre);
CREATE INDEX idx_local_nombre_provincia ON BASADOS.localidad (local_nombre, local_provincia);
CREATE INDEX idx_clie_dni_direccion ON BASADOS.cliente (clie_dni, clie_direccion);
CREATE INDEX idx_mat_nombre_tipo ON BASADOS.material (mat_nombre, mat_tipo);
CREATE INDEX idx_tipo_nombre ON BASADOS.tipo_material (tipo_nombre);
CREATE INDEX idx_localidad_provincia ON BASADOS.localidad(local_provincia);
CREATE INDEX idx_sucursal_localidad ON BASADOS.sucursal(suc_localidad);
CREATE INDEX idx_cliente_localidad ON BASADOS.cliente(clie_localidad);
CREATE INDEX idx_pedido_sucursal ON BASADOS.pedido(ped_sucursal);
CREATE INDEX idx_pedido_cliente ON BASADOS.pedido(ped_cliente);
CREATE INDEX idx_factura_cliente ON BASADOS.factura(fact_cliente);
CREATE INDEX idx_factura_sucursal ON BASADOS.factura(fact_sucursal);
CREATE INDEX idx_compra_sucursal ON BASADOS.compra(comp_sucursal);
CREATE INDEX idx_compra_proveedor ON BASADOS.compra(comp_proveedor);
CREATE INDEX idx_sillon_modelo ON BASADOS.sillon(sill_modelo);



INSERT BASADOS.provincia
    (prov_nombre)
    SELECT DISTINCT Proveedor_Provincia
    FROM gd_esquema.Maestra
    WHERE Proveedor_Provincia IS NOT NULL
    UNION
    SELECT Cliente_Provincia
    FROM gd_esquema.Maestra
    WHERE Cliente_Provincia IS NOT NULL
    UNION
    SELECT Sucursal_Provincia
    FROM gd_esquema.Maestra
    WHERE Sucursal_Provincia IS NOT NULL


INSERT BASADOS.localidad
    (local_nombre, local_provincia)
    SELECT Proveedor_Localidad, prov_id
    FROM gd_esquema.Maestra JOIN
    BASADOS.provincia on prov_nombre=Proveedor_Provincia
    UNION
    SELECT Cliente_Localidad, prov_id
    FROM gd_esquema.Maestra JOIN
    BASADOS.provincia on prov_nombre=Cliente_Provincia
    UNION
    SELECT Sucursal_Localidad, prov_id
    FROM gd_esquema.Maestra JOIN
    BASADOS.provincia on prov_nombre=Sucursal_Provincia



INSERT BASADOS.sucursal
    (suc_numero, suc_mail, suc_telefono, suc_direccion, suc_localidad)
    SELECT DISTINCT Sucursal_NroSucursal, Sucursal_mail, Sucursal_telefono, Sucursal_Direccion,
        (
                SELECT local_id
        from BASADOS.localidad
        where Sucursal_Localidad=local_nombre and local_provincia=
                    (select prov_id
            from BASADOS.provincia
            where prov_nombre=Sucursal_Provincia)
            )
    from gd_esquema.Maestra

INSERT BASADOS.proveedor
    (prov_cuit, prov_razon_social, prov_telefono, prov_mail, prov_direccion, prov_localidad)
    SELECT DISTINCT
        Proveedor_Cuit,
        Proveedor_RazonSocial,
        Proveedor_Telefono,
        Proveedor_Mail,
        Proveedor_Direccion,
        (SELECT local_id
        from BASADOS.localidad
        where 
                        Proveedor_Localidad=local_nombre AND
            local_provincia=
                    (select prov_id
            from BASADOS.provincia
            where prov_nombre=Proveedor_Provincia)
            )
    from gd_esquema.Maestra
    where Proveedor_Cuit is not null

INSERT BASADOS.tipo_material
    (tipo_nombre)
    SELECT DISTINCT Material_Tipo
    FROM gd_esquema.Maestra
    where Material_Tipo is not NULL

INSERT BASADOS.material
    (mat_nombre, mat_descripcion, mat_precio, mat_tipo)
    SELECT DISTINCT Material_Nombre, Material_Descripcion, Material_Precio,
        (
                SELECT tipo_id
        FROM BASADOS.tipo_material
        WHERE tipo_nombre = Material_Tipo
            )
    FROM gd_esquema.Maestra
    WHERE Material_Nombre is not NULL

INSERT BASADOS.tela
    (tela_material, tela_color, tela_textura)
    SELECT DISTINCT
        (
                    SELECT mat_id
        FROM BASADOS.material
        WHERE   mat_nombre = Material_Nombre AND
            mat_tipo = 
                                (
                                    SELECT tipo_id
            FROM BASADOS.tipo_material
            WHERE tipo_nombre = Material_Tipo
                                )
                ),
        Tela_Color,
        Tela_Textura
    FROM gd_esquema.Maestra
    where Material_Tipo = 'Tela'

INSERT BASADOS.relleno
    (rell_material, rell_densidad)
    SELECT DISTINCT
        (SELECT mat_id
        FROM BASADOS.material
        WHERE mat_nombre = Material_Nombre
            AND mat_tipo = (SELECT tipo_id
            FROM BASADOS.tipo_material
            WHERE tipo_nombre = Material_Tipo)
            ),
        Relleno_Densidad
    FROM gd_esquema.Maestra
    WHERE Material_Tipo = 'Relleno'

INSERT BASADOS.madera
    (mad_material, mad_color, mad_dureza)
    SELECT DISTINCT
        (
                SELECT mat_id
        FROM BASADOS.material
        WHERE mat_nombre = Material_Nombre
            AND mat_tipo = 
                    (   SELECT tipo_id
            FROM BASADOS.tipo_material
            WHERE tipo_nombre = Material_Tipo
                    )
            ),
        Madera_Color,
        Madera_Dureza
    FROM gd_esquema.Maestra
    where Material_Tipo = 'Madera'

INSERT BASADOS.cliente
    (clie_dni, clie_nombre, clie_apellido, clie_mail, clie_telefono, clie_fecha_nac, clie_direccion, clie_localidad)
    SELECT DISTINCT Cliente_Dni, Cliente_Nombre, Cliente_Apellido, Cliente_Mail,
        Cliente_Telefono, Cliente_FechaNacimiento, Cliente_Direccion,
        (select local_id
        from BASADOS.localidad
        where local_nombre=Cliente_Localidad
            and local_provincia=
            (select prov_id
            from BASADOS.provincia
            where prov_nombre=Cliente_Provincia))
    from gd_esquema.Maestra
    WHERE Cliente_Dni is not NULL


INSERT BASADOS.pedido
    (ped_numero, ped_fecha,ped_estado, ped_total, ped_sucursal, ped_cliente)
    SELECT distinct Pedido_Numero, Pedido_Fecha,
        Pedido_Estado, Pedido_Total,
        Sucursal_NroSucursal,
        (select clie_id
        from BASADOS.cliente
        where clie_dni=Cliente_Dni and clie_direccion=Cliente_Direccion)
    FROM gd_esquema.Maestra
    WHERE Pedido_Numero is not NULL

INSERT BASADOS.factura
    (fact_numero, fact_fecha, fact_cliente, fact_sucursal)
    SELECT distinct Factura_Numero, Factura_Fecha,
        (select clie_id
        from BASADOS.cliente
        where clie_dni=Cliente_Dni
            and clie_direccion=Cliente_Direccion
        ),
        Sucursal_NroSucursal
    FROM gd_esquema.Maestra
    where Factura_Numero is not NULL

INSERT BASADOS.cancelacion
    (canc_pedido, canc_fecha, canc_motivo)
    SELECT DISTINCT Pedido_Numero, Pedido_Cancelacion_Fecha, Pedido_Cancelacion_Motivo
    FROM gd_esquema.Maestra
    WHERE Pedido_Estado = 'Cancelado' AND Pedido_Cancelacion_Fecha IS NOT NULL AND Pedido_Cancelacion_Motivo IS NOT NULL

INSERT BASADOS.envio
    (env_numero, env_fecha_programada,env_fecha, env_importe_traslado, env_importe_subida, env_factura)
    SELECT distinct Envio_Numero, Envio_Fecha_Programada, Envio_Fecha,
        Envio_ImporteTraslado, Envio_importeSubida,
        Factura_Numero
    FROM gd_esquema.Maestra
    where Envio_Numero is not null

INSERT BASADOS.modelo
    (mod_codigo, mod_modelo, mod_descripcion, mod_precio_base)
    SELECT distinct Sillon_Modelo_Codigo, Sillon_Modelo,
        Sillon_Modelo_Descripcion, Sillon_Modelo_Precio
    from gd_esquema.Maestra
    where Sillon_Modelo_Codigo is not null

INSERT BASADOS.medida
    (med_alto, med_ancho, med_profundidad, med_precio)
    SELECT distinct Sillon_Medida_Alto, Sillon_Medida_Ancho, Sillon_Medida_Profundidad,
        Sillon_Medida_Precio
    from gd_esquema.Maestra
    where Sillon_Medida_Alto is not null

INSERT BASADOS.compra
    (comp_numero, comp_fecha, comp_total, comp_sucursal, comp_proveedor)
    SELECT distinct Compra_Numero, Compra_Fecha, Compra_Total,
        Sucursal_NroSucursal, Proveedor_Cuit
    FROM gd_esquema.Maestra
    where Compra_Numero is not null

INSERT BASADOS.detalle_compra
    (det_compra, det_material, det_precio_unitario, det_cantidad)
    SELECT Compra_Numero, (
                SELECT mat_id
        FROM BASADOS.material
        WHERE mat_nombre = Material_Nombre
            AND mat_tipo = 
                    (   SELECT tipo_id
            FROM BASADOS.tipo_material
            WHERE tipo_nombre = Material_Tipo
                    )
            ),
        Detalle_Compra_Precio, Detalle_Compra_Cantidad
    FROM gd_esquema.Maestra
    WHERE Compra_Numero IS NOT NULL


INSERT BASADOS.sillon
    (sill_codigo, sill_modelo, sill_medida_alto, sill_medida_ancho, sill_medida_profundidad)
    SELECT distinct Sillon_Codigo, Sillon_Modelo_Codigo, Sillon_Medida_Alto,
        Sillon_Medida_Ancho, Sillon_Medida_Profundidad
    FROM gd_esquema.Maestra
    WHERE Sillon_Codigo is not null

INSERT BASADOS.material_por_sillon
    (mat_sillon, mat_material)
    SELECT Sillon_Codigo, (SELECT mat_id
        FROM BASADOS.material
        WHERE mat_nombre = Material_Nombre
            AND mat_tipo = 
                    (   SELECT tipo_id
            FROM BASADOS.tipo_material
            WHERE tipo_nombre = Material_Tipo
                    ))
    FROM gd_esquema.Maestra
    WHERE Sillon_Codigo IS NOT NULL

INSERT INTO BASADOS.detalle_pedido
    (det_pedido, det_numero, det_cantidad, det_sillon)
    SELECT
        Pedido_Numero,
        ROW_NUMBER() OVER (PARTITION BY Pedido_Numero ORDER BY (SELECT NULL)),
        MAX(Detalle_Pedido_Cantidad),
        Sillon_Codigo
    FROM gd_esquema.Maestra
    WHERE Pedido_Numero IS NOT NULL
        AND Sillon_Codigo IS NOT NULL
    GROUP BY Pedido_Numero, Sillon_Codigo;



INSERT BASADOS.detalle_factura
    (det_factura, det_pedido, det_numero, det_precio_unitario, det_cantidad)
    SELECT
        Factura_Numero,
        Pedido_Numero,
        ROW_NUMBER() OVER (
                    PARTITION BY Pedido_Numero 
                    ORDER BY Detalle_Factura_Cantidad, Detalle_Factura_Precio
                ) AS det_numero,
        Detalle_Factura_Precio,
        Detalle_Factura_Cantidad
    FROM gd_esquema.Maestra
    WHERE Factura_Numero IS NOT NULL
        AND Pedido_Numero IS NOT NULL
        AND Detalle_Factura_Precio IS NOT NULL



DROP INDEX idx_prov_nombre ON BASADOS.provincia;
DROP INDEX idx_local_nombre_provincia ON BASADOS.localidad;
DROP INDEX idx_clie_dni_direccion ON BASADOS.cliente;
DROP INDEX idx_mat_nombre_tipo ON BASADOS.material;
DROP INDEX idx_tipo_nombre ON BASADOS.tipo_material;
DROP INDEX idx_localidad_provincia ON BASADOS.localidad;
DROP INDEX idx_sucursal_localidad ON BASADOS.sucursal;
DROP INDEX idx_cliente_localidad ON BASADOS.cliente;
DROP INDEX idx_pedido_sucursal ON BASADOS.pedido;
DROP INDEX idx_pedido_cliente ON BASADOS.pedido;
DROP INDEX idx_factura_cliente ON BASADOS.factura;
DROP INDEX idx_factura_sucursal ON BASADOS.factura;
DROP INDEX idx_compra_sucursal ON BASADOS.compra;
DROP INDEX idx_compra_proveedor ON BASADOS.compra;
DROP INDEX idx_sillon_modelo ON BASADOS.sillon;
GO
PRINT 'Tablas migradas en esquema BASADOS'
GO

PRINT '=== PROCESO DE MIGRACION COMPLETADO ==='
PRINT 'Todos los objetos fueron creados en el esquema BASADOS'
GO
