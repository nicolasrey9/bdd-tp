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
from BASADOS.pedido p left join BASADOS.BI_Dim_Turno turno 
ON CAST(p.ped_fecha AS TIME) >= turno.hora_desde 
AND (
    CAST(p.ped_fecha AS TIME) < turno.hora_hasta
    OR (turno.hora_hasta = '20:00' AND CAST(p.ped_fecha AS TIME) = '20:00')
    )
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
    venta_numero, sillon_codigo,modelo_id, suc_id, tiempo_id,
    rango_id, ubicacion_id, venta_valor, pedido_numero
)
select fact_numero, sill_codigo, mod.modelo_id, sucu.suc_id, 
    tiempo.tiempo_id, rango.rango_id, ubi.ubicacion_id, 
    detfact.det_precio_unitario * detfact.det_cantidad, detpedido.det_pedido
from BASADOS.factura join BASADOS.detalle_factura detfact
on det_factura=fact_numero join BASADOS.detalle_pedido detpedido
on detfact.det_numero=detpedido.det_numero and 
detfact.det_pedido=detpedido.det_pedido
join BASADOS.sillon on detpedido.det_sillon=sill_codigo
join BASADOS.BI_Dim_Sucursal sucu on
sucu.suc_numero = fact_sucursal
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
join BASADOS.sucursal on fact_sucursal=sucursal.suc_numero
join BASADOS.localidad on sucursal.suc_localidad=localidad.local_id
join BASADOS.provincia on provincia.prov_id=localidad.local_provincia
join BASADOS.BI_Dim_Ubicacion ubi on ubi.prov_nombre=provincia.prov_nombre
and ubi.local_nombre = localidad.local_nombre
join BASADOS.BI_Dim_Modelo mod on mod.modelo_codigo=sill_modelo
and sill_medida_ancho=medida_ancho
and sill_medida_alto=medida_alto
and sill_medida_profundidad=medida_profundidad
join BASADOS.medida on sill_medida_ancho=med_ancho
and sill_medida_alto=med_alto
and sill_medida_profundidad=med_profundidad

/*
@@@@@ HECHO COMPRA @@@@@
*/
insert into BASADOS.BI_Hecho_Compra(
    compra_numero, tipo_id, tiempo_id, suc_id, compra_valor
)
select comp_numero, BItipoMaterial.tipo_id, 
    tiempo.tiempo_id, sucu.suc_id, det_precio_unitario*det_cantidad
from BASADOS.compra join BASADOS.detalle_compra on det_compra=comp_numero
join BASADOS.material on mat_id=det_material join BASADOS.tipo_material tipoMaterial
on tipo_id=mat_tipo join BASADOS.BI_Dim_TipoMaterial BItipoMaterial 
on tipoMaterial.tipo_nombre=BItipoMaterial.tipo_nombre
and BItipoMaterial.tipo_descripcion=mat_descripcion
join BASADOS.BI_Dim_Tiempo tiempo on
CAST(comp_fecha AS DATE) = tiempo.fecha
join BASADOS.BI_Dim_Sucursal sucu on
sucu.suc_numero = comp_sucursal


/*
@@@@@ HECHO ENVIO @@@@@
*/
insert into BASADOS.BI_Hecho_Envio(
    envio_numero,
    tiempo_id,
    ubicacion_id,
    costo_envio,
    fecha_programada
)
select env_numero, tiempo.tiempo_id, BI_Ubicacion.ubicacion_id,
    env_importe_subida+env_importe_traslado, CAST(env_fecha_programada as date)
from BASADOS.envio
join BASADOS.BI_Dim_Tiempo tiempo on
CAST(env_fecha AS DATE) = tiempo.fecha
join BASADOS.factura on fact_numero=env_factura
join BASADOS.sucursal sucursal on sucursal.suc_numero=fact_sucursal
join BASADOS.localidad localidad on localidad.local_id=sucursal.suc_localidad
join BASADOS.provincia provincia on provincia.prov_id=localidad.local_provincia
join BASADOS.BI_Dim_Ubicacion BI_Ubicacion 
on BI_Ubicacion.local_nombre=localidad.local_nombre
and BI_Ubicacion.prov_nombre=provincia.prov_nombre 