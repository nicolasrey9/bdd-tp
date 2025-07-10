/*
@@@@@ HECHO PEDIDO @@@@@
*/
insert into BASADOS.BI_Hecho_Pedido(
    turno_id, 
    suc_id, 
    tiempo_id, 
    estado_id,
    cantidad_pedidos)
select 
    turno.turno_id,
    sucursal.suc_id, 
    tiempo.tiempo_id, 
    estado.estado_id,
    (select count(distinct ped_numero)) 'Cantidad Pedidos'

from BASADOS.pedido p 

left join BASADOS.BI_Dim_Turno turno 
ON CAST(p.ped_fecha AS TIME) >= turno.hora_desde 
AND (
    CAST(p.ped_fecha AS TIME) < turno.hora_hasta
    OR (turno.hora_hasta = '20:00' AND CAST(p.ped_fecha AS TIME) = '20:00')
    )

join BASADOS.sucursal sucursalBasados on p.ped_sucursal=sucursalBasados.suc_numero
join BASADOS.localidad localidadBasados on sucursalBasados.suc_localidad=localidadBasados.local_id
join BASADOS.provincia provinciaBasados on provinciaBasados.prov_id=localidadBasados.local_provincia
join BASADOS.BI_Dim_Sucursal sucursal on sucursal.localidad = localidadBasados.local_nombre
and sucursal.provincia = provinciaBasados.prov_nombre

join BASADOS.BI_Dim_Tiempo tiempo on   
                        year(p.ped_fecha) = tiempo.anio and MONTH(p.ped_fecha) = tiempo.mes

join BASADOS.BI_Dim_EstadoPedido estado on
                        estado.ped_estado = p.ped_estado

group by turno.turno_id,
    sucursal.suc_id, 
    tiempo.tiempo_id, 
    estado.estado_id


/*
@@@@@ HECHO COMPRA @@@@@
*/
insert into BASADOS.BI_Hecho_Compra(
    tipo_id, tiempo_id, suc_id, 
    
    valor_total_compras, valor_promedio_compras
)

select BI_Dim_TipoMaterial.tipo_id, BI_Dim_Tiempo.tiempo_id, sucursal.suc_id, 
    sum(det_precio_unitario * det_cantidad) valor_total_compras, 
    avg(det_precio_unitario * det_cantidad) valor_promedio_compras

from BASADOS.compra 

join BASADOS.detalle_compra on det_compra=comp_numero

join BASADOS.material on mat_id=det_material 

join BASADOS.tipo_material tipoMaterial
on tipo_id=mat_tipo 

join BASADOS.BI_Dim_TipoMaterial BI_Dim_TipoMaterial 
on tipoMaterial.tipo_nombre=BI_Dim_TipoMaterial.tipo_nombre
and BI_Dim_TipoMaterial.tipo_descripcion=mat_descripcion

join BASADOS.BI_Dim_Tiempo BI_Dim_Tiempo on
        year(comp_fecha) = BI_Dim_Tiempo.anio and MONTH(comp_fecha) = BI_Dim_Tiempo.mes


join BASADOS.sucursal sucursalBasados on comp_sucursal=sucursalBasados.suc_numero
join BASADOS.localidad localidadBasados on sucursalBasados.suc_localidad=localidadBasados.local_id
join BASADOS.provincia provinciaBasados on provinciaBasados.prov_id=localidadBasados.local_provincia
join BASADOS.BI_Dim_Sucursal sucursal on sucursal.localidad = localidadBasados.local_nombre
and sucursal.provincia = provinciaBasados.prov_nombre


group by BI_Dim_TipoMaterial.tipo_id, BI_Dim_Tiempo.tiempo_id, sucursal.suc_id

/*
@@@@@ HECHO ENVIO @@@@@
*/
insert into BASADOS.BI_Hecho_Envio(
    tiempo_id,
    ubicacion_id,

    porcentaje_cumplimiento_envios,
    valor_promedio_envios
)
select BI_Dim_Tiempo.tiempo_id, BI_Dim_Ubicacion_Cliente.ubicacion_id,

SUM(CASE WHEN env_fecha <= env_fecha_programada THEN 1 ELSE 0 END)
    * 100.0 / COUNT(*) AS porcentaje_cumplimiento_envios,

avg(env_importe_subida+env_importe_traslado) valor_promedio_envios
    
from BASADOS.envio
join BASADOS.BI_Dim_Tiempo BI_Dim_Tiempo on
    year(env_fecha) = BI_Dim_Tiempo.anio and MONTH(env_fecha) = BI_Dim_Tiempo.mes

join BASADOS.factura on fact_numero=env_factura
join BASADOS.cliente on fact_cliente=clie_id
join BASADOS.localidad localidad on localidad.local_id=clie_localidad
join BASADOS.provincia provincia on provincia.prov_id=localidad.local_provincia
join BASADOS.BI_Dim_Ubicacion_Cliente BI_Dim_Ubicacion_Cliente 
            on localidad.local_nombre = BI_Dim_Ubicacion_Cliente.local_nombre and provincia.prov_nombre = BI_Dim_Ubicacion_Cliente.prov_nombre

group by BI_Dim_Tiempo.tiempo_id, BI_Dim_Ubicacion_Cliente.ubicacion_id

/*
@@@@@ HECHO VENTA @@@@@ --chequear
*/
insert into BASADOS.BI_Hecho_Venta(
    suc_id, 
    tiempo_id,
    rango_id, 
    ubicacion_id,
    modelo_id,

    tiempo_promedio_fabricacion_en_dias, 
    valor_promedio_ventas, 
    valor_total_ventas
)
select BI_Dim_Sucursal.suc_id, 
    BI_Dim_Tiempo.tiempo_id, 
    BI_Dim_RangoEtario.rango_id, 
    BI_Dim_Ubicacion_Cliente.ubicacion_id,
    BI_Dim_Modelo.modelo_id,

    avg(DATEDIFF(DAY,ped.ped_fecha,fact_fecha)) tiempo_promedio_fabricacion_en_dias,--deberiamos chequear el tema de AVG, no estoy seguro
    avg(detfact.det_precio_unitario*detfact.det_cantidad) valor_promedio_ventas,
    sum(detfact.det_precio_unitario*detfact.det_cantidad) valor_total_ventas
    
from BASADOS.factura 

join BASADOS.detalle_factura detfact
on detfact.det_factura=fact_numero 

join BASADOS.detalle_pedido detpedido
on detfact.det_numero=detpedido.det_numero and 
detfact.det_pedido=detpedido.det_pedido

join BASADOS.pedido ped on detpedido.det_pedido = ped.ped_numero

join BASADOS.sillon on detpedido.det_sillon=sill_codigo

join BASADOS.BI_Dim_Tiempo BI_Dim_Tiempo on
        year(fact_fecha) = BI_Dim_Tiempo.anio and MONTH(fact_fecha) = BI_Dim_Tiempo.mes

join BASADOS.cliente on clie_id=fact_cliente

join BASADOS.BI_Dim_RangoEtario BI_Dim_RangoEtario on
(
  DATEDIFF(YEAR, clie_fecha_nac, fact_fecha) 
  - CASE 
      WHEN MONTH(fact_fecha) < MONTH(clie_fecha_nac)
        OR (MONTH(fact_fecha) = MONTH(clie_fecha_nac) AND DAY(fact_fecha) < DAY(clie_fecha_nac))
      THEN 1 
      ELSE 0 
    END
) between BI_Dim_RangoEtario.edad_min and BI_Dim_RangoEtario.edad_max

join BASADOS.sucursal on fact_sucursal=sucursal.suc_numero

join BASADOS.localidad loca on sucursal.suc_localidad=loca.local_id

join BASADOS.provincia prov on prov.prov_id=loca.local_provincia

join BASADOS.BI_Dim_Sucursal BI_Dim_Sucursal on
BI_Dim_Sucursal.localidad = loca.local_nombre and BI_Dim_Sucursal.provincia = prov.prov_nombre

join BASADOS.localidad loca1 on clie_localidad = loca1.local_id

join BASADOS.provincia prov1 on prov1.prov_id = loca1.local_provincia

join BASADOS.BI_Dim_Ubicacion_Cliente BI_Dim_Ubicacion_Cliente on BI_Dim_Ubicacion_Cliente.prov_nombre=prov1.prov_nombre
and BI_Dim_Ubicacion_Cliente.local_nombre = loca1.local_nombre

join BASADOS.modelo on sill_modelo = mod_codigo

join BASADOS.BI_Dim_Modelo BI_Dim_Modelo on BI_Dim_Modelo.modelo=mod_modelo

group by BI_Dim_Sucursal.suc_id, 
    BI_Dim_Tiempo.tiempo_id, 
    BI_Dim_RangoEtario.rango_id, 
    BI_Dim_Ubicacion_Cliente.ubicacion_id,
    BI_Dim_Modelo.modelo_id