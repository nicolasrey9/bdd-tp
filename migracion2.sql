CREATE PROCEDURE migracion
AS
BEGIN
    INSERT BASADOS.provincia(prov_nombre) 
        SELECT Proveedor_Provincia FROM gd_esquema.Maestra WHERE Proveedor_Provincia IS NOT NULL
        UNION
        SELECT Cliente_Provincia FROM gd_esquema.Maestra WHERE Cliente_Provincia IS NOT NULL
        UNION
        SELECT Sucursal_Provincia FROM gd_esquema.Maestra WHERE Sucursal_Provincia IS NOT NULL

    INSERT BASADOS.localidad(local_nombre, local_provincia) 
        SELECT Proveedor_Localidad, 
            (SELECT prov_id from BASADOS.provincia where prov_nombre = Proveedor_Provincia) 
                FROM gd_esquema.Maestra WHERE Proveedor_Localidad IS NOT NULL
        UNION
        SELECT Cliente_Localidad, 
            (SELECT prov_id from BASADOS.provincia where prov_nombre = Cliente_Provincia) 
                FROM gd_esquema.Maestra WHERE Cliente_Localidad IS NOT NULL
        UNION
        SELECT Sucursal_Localidad, (SELECT prov_id from BASADOS.provincia where prov_nombre = Sucursal_Provincia) FROM gd_esquema.Maestra WHERE Sucursal_Localidad IS NOT NULL

    INSERT BASADOS.sucursal(suc_numero, suc_mail, suc_telefono, suc_direccion, suc_localidad)
        SELECT DISTINCT Sucursal_NroSucursal, Sucursal_mail, Sucursal_telefono, Sucursal_Direccion, 
        (
            SELECT local_id from BASADOS.localidad 
            where Sucursal_Localidad=local_nombre and local_provincia=
                (select prov_id from BASADOS.provincia where prov_nombre=Sucursal_Provincia)
        ) from gd_esquema.Maestra

    INSERT BASADOS.cancelacion
        (
            canc_pedido,
            canc_fecha,
            canc_motivo
        )
        SELECT DISTINCT 
        Pedido_Numero, 
        Pedido_Cancelacion_Fecha, 
        Pedido_Cancelacion_Motivo
        FROM gd_esquema.Maestra 
        WHERE Pedido_Numero IS NOT NULL

    INSERT BASADOS.proveedor(prov_cuit, prov_razon_social, prov_telefono, prov_mail, prov_direccion, prov_localidad)
        SELECT DISTINCT 
        Proveedor_Cuit, 
        Proveedor_RazonSocial,
        Proveedor_Telefono,
        Proveedor_Mail,
        Proveedor_Direccion, 
        (SELECT local_id from BASADOS.localidad 
            where 
                    Proveedor_Localidad=local_nombre AND 
                    local_provincia=
                (select prov_id from BASADOS.provincia where prov_nombre=Proveedor_Provincia)
        ) from gd_esquema.Maestra where Proveedor_Cuit is not null

    INSERT BASADOS.compra(comp_numero, comp_fecha, comp_total, comp_sucursal, comp_proveedor)
        SELECT 
        Compra_Numero,
        Compra_Fecha,
        Compra_Total,
        Sucursal_NroSucursal,
        Proveedor_Cuit        
        FROM gd_esquema.Maestra 
        where Compra_Numero is not null

    INSERT BASADOS.detalle_compra
        (
            det_compra,
            det_material,
            det_precio_unitario,
            det_cantidad
        )
        SELECT
        Compra_Numero,
        /*
            aca se supone que va material, pero
            me entro la duda si se usa mat_id

        */
        Detalle_Compra_Precio,
        Detalle_Compra_Cantidad
        FROM gd_esquema.Maestra 
        WHERE Sillon_Modelo IS NOT NULL

    INSERT BASADOS.tipo_material(tipo_nombre)
        SELECT DISTINCT Material_Tipo 
        FROM gd_esquema.Maestra 
        where Material_Tipo is not NULL

    INSERT BASADOS.material(mat_nombre, mat_descripcion, mat_precio, mat_tipo)
        SELECT DISTINCT Material_Nombre, Material_Descripcion, Material_Precio, 
        (
            SELECT tipo_id 
            FROM BASADOS.tipo_material 
            WHERE tipo_nombre = Material_Tipo
        ) 
        FROM gd_esquema.Maestra 
        
        WHERE Material_Nombre is not NULL

    INSERT BASADOS.tela(tela_material, tela_color, tela_textura)
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
     
    INSERT BASADOS.relleno(rell_material, rell_densidad)
    SELECT DISTINCT
    /*
        creo que aca tendria que haber una vista tambien...
    */

        (SELECT mat_id FROM BASADOS.material 
            WHERE mat_nombre = Material_Nombre 
            AND mat_tipo = (SELECT tipo_id FROM BASADOS.tipo_material WHERE tipo_nombre = Material_Tipo)
        ),
        Relleno_Densidad
    FROM gd_esquema.Maestra

    INSERT BASADOS.madera(mad_material, mad_color, mad_dureza)
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


    INSERT BASADOS.sillon 
        (   
            sill_codigo, 
            sill_modelo,
            sill_medida_alto,
            sill_medida_ancho,
            sill_medida_profundidad
        )
    SELECT DISTINCT
        Sillon_Codigo,
        (
            SELECT mod_codigo 
            FROM BASADOS.modelo 
            WHERE mod_modelo = Sillon_Modelo
        ),
        Sillon_Medida_Alto,
        Sillon_Medida_Ancho,
        Sillon_Medida_Profundidad
    FROM gd_esquema.Maestra
    WHERE Sillon_Codigo IS NOT NULL

    INSERT BASADOS.material_por_sillon
        (   mat_sillon,
            mat_material
        )
    SELECT DISTINCT
        (
            SELECT mat_sillon 
            FROM BASADOS.sillon 
            WHERE mat_sillon = Sillon_Modelo_Codigo
        ),
        (
            SELECT mat_id FROM BASADOS.material 
            WHERE mat_nombre = Material_Nombre 
            AND mat_tipo =
                (   SELECT tipo_id 
                    FROM BASADOS.tipo_material 
                    WHERE tipo_nombre = Material_Tipo
                )
        )

    INSERT BASADOS.modelo
    (   mod_codigo,
        mod_modelo,
        mod_descripcion,
        mod_precio_base
    )
    SELECT 
        Sillon_Modelo_Codigo,
        Sillon_Modelo,
        Sillon_Modelo_Descripcion,
        Sillon_Modelo_Precio
    FROM gd_esquema.Maestra
    WHERE Sillon_Modelo_Codigo IS NOT NULL

    INSERT BASADOS.medida
    (
        med_alto,
        med_ancho,
        med_profundidad,
        med_precio
    )
    SELECT 
        Sillon_Medida_Alto,
        Sillon_Medida_Ancho,
        Sillon_Medida_Profundidad,
        Sillon_Medida_Precio
    FROM gd_esquema.Maestra

    INSERT BASADOS.cliente
        (
            clie_id,
            clie_dni,
            clie_nombre,
            clie_apellido,
            clie_mail,
            clie_telefono,
            clie_fecha_nac,
            clie_direccion,
            clie_localidad
        )
    SELECT 
        Cliente_Dni,
        Cliente_Nombre,
        Cliente_Apellido,
        Cliente_Mail,
        Cliente_Telefono,
        Cliente_FechaNacimiento,
        Cliente_Direccion,
        
        /*
        creo que podrias crear una vista aca...
        algo como:

        CREATE VIEW vw_localidad_resuelta AS
        SELECT
                *,
                l.local_id AS cliente_localidad_id
        FROM gd_esquema.Maestra JOIN BASADOS.localidad l
            ON Cliente_Localidad = l.local_nombre
            AND l.local_provincia = 
                (
                    SELECT prov_id FROM BASADOS.provincia 
                    WHERE prov_nombre = m.Cliente_Provincia
                )
        
        y luego llamar a la vista como:
            cliente_localidad_id
            FROM vw_localidad_resuelta
            WHERE Cliente_Dni IS NOT NULL
        
        */
        
        (SELECT local_id FROM BASADOS.localidad 
            WHERE Cliente_Localidad = local_nombre 
            AND local_provincia = 
            (SELECT prov_id FROM BASADOS.provincia WHERE prov_nombre = Cliente_Provincia)
        )
    FROM gd_esquema.Maestra
    WHERE /*se supone que seria el clie_id no? */ 
        Cliente_Dni IS NOT NULL
    IS NOT NULL
GO


