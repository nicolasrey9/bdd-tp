/*
@@@@@ HECHO PEDIDO @@@@@
*/
insert into BASADOS.BI_Hecho_Pedido(
    pedido_numero, turno_id, 
    suc_id, tiempo_id, estado_id)
select 
    p.ped_numero, 
    turno.turno_id,
    sucursal.suc_id, 
    tiempo.tiempo_id, 
    estado.estado_id
from BASADOS.pedido p join BASADOS.BI_Dim_Turno turno 
on CAST(p.ped_fecha AS TIME) BETWEEN hora_desde AND hora_hasta
join BASADOS.BI_Dim_Sucursal sucursal on
sucursal.suc_numero = p.ped_sucursal
join BASADOS.BI_Dim_Tiempo tiempo on
CAST(p.ped_fecha AS DATE) = tiempo.fecha
join BASADOS.BI_Dim_EstadoPedido estado
on estado.ped_estado = p.ped_estado


/*
@@@@@ HECHO VENTA @@@@@
*/
insert into BASADOS.BI_Hecho_Venta(
    venta_numero, modelo_id, suc_id, tiempo_id,
    rango_id, ubicacion_id, venta_valor
)
select fact_numero, mod_codigo, sucursal.suc_id, 
    tiempo.tiempo_id, rango.rango_id, ubi.ubicacion_id, 
    detfact.det_precio_unitario * detfact.det_cantidad
from BASADOS.factura join BASADOS.detalle_factura detfact
on det_factura=fact_numero join BASADOS.detalle_pedido detpedido
on detfact.det_numero=detpedido.det_numero and 
detfact.det_pedido=detpedido.det_pedido
join BASADOS.sillon on detpedido.det_sillon=sill_codigo
join BASADOS.modelo on sill_modelo=mod_codigo
join BASADOS.BI_Dim_Sucursal sucursal on
sucursal.suc_numero = fact_sucursal
join BASADOS.BI_Dim_Tiempo tiempo on
CAST(fact_fecha AS DATE) = tiempo.fecha
join BASADOS.cliente on clie_id=fact_cliente
join BASADOS.BI_Dim_RangoEtario rango on
(
  DATEDIFF(YEAR, clie_fecha_nac, fact_fecha) 
  - CASE 
      WHEN MONTH(fact_fecha) < MONTH(clie_fecha_nac)
        OR (MONTH(fact_fecha) = MONTH(clie_fecha_nac) AND DAY(fact_fecha) < DAY(clie_fecha_nac))
      THEN 1 
      ELSE 0 
    END
) between rango.edad_min and rango.edad_max
join BASADOS.sucursal on fact_sucursal=suc_numero
join BASADOS.localidad on suc_localidad=local_id
join BASADOS.provincia on prov_id=local_provincia
join BASADOS.BI_Dim_Ubicacion ubi on ubi.prov_nombre=prov_nombre
and ubi.local_nombre = local_nombre

/*
@@@@@ HECHO COMPRA @@@@@
*/
insert into BASADOS.BI_Hecho_Compra(
    
)





/*
@@@@@ HECHO ENVIO @@@@@
*/