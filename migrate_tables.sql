
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

    INSERT BASADOS.localidad (local_nombre, local_provincia)
    SELECT DISTINCT
        m.Proveedor_Localidad, p.prov_id
    FROM gd_esquema.Maestra m
    JOIN BASADOS.provincia p
        ON p.prov_nombre = m.Proveedor_Provincia
    WHERE m.Proveedor_Localidad IS NOT NULL
    
    UNION
    
    SELECT Cliente_Localidad,
        (SELECT prov_id
        from BASADOS.provincia
        where prov_nombre = Cliente_Provincia)
    FROM gd_esquema.Maestra
    WHERE Cliente_Localidad IS NOT NULL
    UNION
    SELECT Sucursal_Localidad, (SELECT prov_id
        from BASADOS.provincia
        where prov_nombre = Sucursal_Provincia)
    FROM gd_esquema.Maestra
    WHERE Sucursal_Localidad IS NOT NULL

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
    (ped_numero, ped_estado, ped_total, ped_sucursal, ped_cliente)
    SELECT distinct Pedido_Numero, Pedido_Estado, Pedido_Total,
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