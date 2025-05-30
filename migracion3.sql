INSERT BASADOS.cliente(clie_dni, clie_nombre, clie_apellido, clie_mail, clie_telefono, clie_fecha_nac, clie_direccion, clie_localidad)
    SELECT distinct Cliente_Dni, Cliente_Nombre, Cliente_Apellido, Cliente_Mail, 
    Cliente_Telefono, Cliente_FechaNacimiento, Cliente_Direccion, 
    (select local_id from BASADOS.localidad where local_nombre=Cliente_Localidad 
    and local_provincia=(select prov_id from BASADOS.provincia where prov_nombre=Cliente_Provincia)) from gd_esquema.Maestra
    where Cliente_Dni is not null


INSERT BASADOS.factura(fact_numero, fact_fecha, fact_cliente, fact_sucursal)
    SELECT distinct Factura_Numero, Factura_Fecha, 
    (select clie_id from BASADOS.cliente where clie_dni=Cliente_Dni
    and clie_direccion=Cliente_Direccion
    ), 
    Sucursal_NroSucursal 
    FROM gd_esquema.Maestra where Factura_Numero is not NULL

INSERT BASADOS.envio(env_numero, env_fecha_programada,env_fecha, env_importe_traslado, env_importe_subida, env_factura)
    SELECT distinct Envio_Numero, Envio_Fecha_Programada, Envio_Fecha,
    Envio_ImporteTraslado, Envio_importeSubida,
    Factura_Numero FROM gd_esquema.Maestra where Envio_Numero is not null


INSERT BASADOS.modelo(mod_codigo, mod_modelo, mod_descripcion, mod_precio_base)
    SELECT distinct Sillon_Modelo_Codigo, Sillon_Modelo, 
    Sillon_Modelo_Descripcion, Sillon_Modelo_Precio from gd_esquema.Maestra
    where Sillon_Modelo_Codigo is not null

INSERT BASADOS.medida(med_alto, med_ancho, med_profundidad, med_precio)
    SELECT distinct Sillon_Medida_Alto, Sillon_Medida_Ancho, Sillon_Medida_Profundidad,
    Sillon_Medida_Precio from gd_esquema.Maestra
    where Sillon_Medida_Alto is not null

INSERT BASADOS.sillon(sill_codigo, sill_modelo, sill_medida_alto, sill_medida_ancho, sill_medida_profundidad)
    SELECT distinct Sillon_Codigo, Sillon_Modelo_Codigo, Sillon_Medida_Alto,
    Sillon_Medida_Ancho, Sillon_Medida_Profundidad FROM gd_esquema.Maestra
    WHERE Sillon_Codigo is not null

/*
CREATE PROCEDURE sp_insert_detalle_pedido
    @det_pedido decimal(18,0),
    @det_sillon bigint,
    @det_cantidad bigint
AS
BEGIN
    DECLARE @maxLinea bigint;

    SELECT @maxLinea = ISNULL(MAX(det_linea), 0)
    FROM Detalle_pedido
    WHERE det_pedido = @det_pedido;

    INSERT INTO Detalle_pedido (det_pedido, det_sillon, det_cantidad, det_linea)
    VALUES (@det_pedido, @det_sillon, @det_cantidad, @maxLinea + 1);
END;
*/
delete from BASADOS.detalle_pedido
select * from BASADOS.detalle_pedido order by 1,4

-- TODO: VER COMO REEMPLAZAR EL NULL
INSERT BASADOS.detalle_pedido(det_pedido, det_sillon, det_cantidad, det_linea)
    (SELECT distinct Pedido_Numero, Sillon_Codigo, Detalle_Pedido_Cantidad
    FROM gd_esquema.Maestra where Pedido_Numero is not NULL
    and Sillon_Codigo is not null order by 1,2,3 )
    
ROW_NUMBER() OVER (PARTITION BY Pedido_Numero ORDER BY (SELECT NULL)) AS det_linea


INSERT BASADOS.detalle_factura(det_factura, det_sillon, det_pedido, det_precio_unitario, det_linea, det_cantidad)
    SELECT Factura_Numero, Sillon_Codigo, Pedido_Numero,
    Detalle_Factura_Precio, 
    (SELECT det_linea from BASADOS.detalle_pedido where Sillon_Codigo=det_sillon 
    and Pedido_Numero=det_pedido) , Detalle_Compra_Cantidad from gd_esquema.Maestra
    where Factura_Numero is not null
    and Sillon_Codigo is not null

select Factura_Numero, Pedido_Numero, Detalle_Factura_Precio from gd_esquema.Maestra 
where Detalle_Factura_Precio is not NULL
