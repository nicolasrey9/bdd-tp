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
        SELECT Proveedor_Localidad, (SELECT prov_id from BASADOS.provincia where prov_nombre = Proveedor_Provincia) FROM gd_esquema.Maestra WHERE Proveedor_Localidad IS NOT NULL
        UNION
        SELECT Cliente_Localidad, (SELECT prov_id from BASADOS.provincia where prov_nombre = Cliente_Provincia) FROM gd_esquema.Maestra WHERE Cliente_Localidad IS NOT NULL
        UNION
        SELECT Sucursal_Localidad, (SELECT prov_id from BASADOS.provincia where prov_nombre = Sucursal_Provincia) FROM gd_esquema.Maestra WHERE Sucursal_Localidad IS NOT NULL

    INSERT BASADOS.sucursal(suc_numero, suc_mail, suc_telefono, suc_direccion, suc_localidad)
        SELECT DISTINCT Sucursal_NroSucursal, Sucursal_mail, Sucursal_telefono, Sucursal_Direccion, (
            SELECT local_id from BASADOS.localidad 
            where Sucursal_Localidad=local_nombre and local_provincia=
                (select prov_id from BASADOS.provincia where prov_nombre=Sucursal_Provincia)
        ) from gd_esquema.Maestra

    INSERT BASADOS.proveedor(prov_cuit, prov_razon_social, prov_telefono, prov_mail, prov_direccion, prov_localidad)
        SELECT DISTINCT Proveedor_Cuit, Proveedor_RazonSocial, Proveedor_Telefono, Proveedor_Mail, Proveedor_Direccion, 
        (SELECT local_id from BASADOS.localidad 
            where Proveedor_Localidad=local_nombre and local_provincia=
                (select prov_id from BASADOS.provincia where prov_nombre=Proveedor_Provincia)) from gd_esquema.Maestra where Proveedor_Cuit is not null

    INSERT BASADOS.compra(comp_numero, comp_fecha, comp_total, comp_sucursal, comp_proveedor)
        SELECT Compra_Numero, Compra_Fecha, Compra_Total, Sucursal_NroSucursal, Proveedor_Cuit FROM gd_esquema.Maestra where Compra_Numero is not null

    INSERT BASADOS.tipo_material(tipo_nombre)
        SELECT DISTINCT Material_Tipo FROM gd_esquema.Maestra where Material_Tipo is not NULL

    INSERT BASADOS.material(mat_nombre, mat_descripcion, mat_precio, mat_tipo)
        SELECT DISTINCT Material_Nombre, Material_Descripcion, Material_Precio, (SELECT tipo_id FROM BASADOS.tipo_material WHERE tipo_nombre = Material_Tipo) FROM gd_esquema.Maestra WHERE Material_Nombre is not NULL
END
GO


