/*
@@@@@ HECHO PEDIDO @@@@@ --chequear
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
    (select count(distinct ped_numero))

from BASADOS.pedido p 

left join BASADOS.BI_Dim_Turno turno 
ON CAST(p.ped_fecha AS TIME) >= turno.hora_desde 
AND (
    CAST(p.ped_fecha AS TIME) < turno.hora_hasta
    OR (turno.hora_hasta = '20:00' AND CAST(p.ped_fecha AS TIME) = '20:00')
    )

join BASADOS.BI_Dim_Sucursal sucursal on sucursal.suc_id = p.ped_sucursal

join BASADOS.BI_Dim_Tiempo tiempo on   
                        year(p.ped_fecha) = tiempo.anio and MONTH(p.ped_fecha) = tiempo.mes

join BASADOS.BI_Dim_EstadoPedido estado on
                        estado.ped_estado = p.ped_estado

group by turno.turno_id,
    sucursal.suc_id, 
    tiempo.tiempo_id, 
    estado.estado_id
/*
@@@@@ HECHO COMPRA @@@@@ --chequear
*/
insert into BASADOS.BI_Hecho_Compra(
    tipo_id, tiempo_id, suc_id, 
    
    valor_total_compras, valor_promedio_compras
)

select BI_Dim_TipoMaterial.tipo_id, BI_Dim_Tiempo.tiempo_id, BI_Dim_Sucursal.suc_id, sum(comp_total), avg(comp_total)
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

join BASADOS.BI_Dim_Sucursal BI_Dim_Sucursal on
BI_Dim_Sucursal.suc_id = comp_sucursal

group by BI_Dim_TipoMaterial.tipo_id, BI_Dim_Tiempo.tiempo_id, BI_Dim_Sucursal.suc_id

/*
@@@@@ HECHO ENVIO @@@@@ --chequear
*/
insert into BASADOS.BI_Hecho_Envio(
    tiempo_id,
    ubicacion_id,

    porcentaje_cumplimiento_envios,
    valor_promedio_envios
)
select BI_Dim_Tiempo.tiempo_id, BI_Dim_Ubicacion_Cliente.ubicacion_id,

--(porcentajeCumplimiento),
avg(env_importe_subida+env_importe_traslado)
    
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
    suc_id, tiempo_id,
    rango_id, ubicacion_id,modelo_id,

    tiempo_fabricacion, valor_promedio_ventas, valor_total_ventas
)
select BI_Dim_Sucursal.suc_id, 
    BI_Dim_Tiempo.tiempo_id, 
    BI_Dim_RangoEtario.rango_id, 
    BI_Dim_Ubicacion_Cliente.ubicacion_id,
    --(tiempo de fabricacion),
    avg(detfact.det_precio_unitario*detfact.det_cantidad),
    sum(detfact.det_precio_unitario*detfact.det_cantidad)
    
from BASADOS.factura 

join BASADOS.detalle_factura detfact
on det_factura=fact_numero 

join BASADOS.detalle_pedido detpedido
on detfact.det_numero=detpedido.det_numero and 
detfact.det_pedido=detpedido.det_pedido

join BASADOS.sillon on detpedido.det_sillon=sill_codigo

join BASADOS.BI_Dim_Sucursal BI_Dim_Sucursal on
BI_Dim_Sucursal.suc_id = fact_sucursal

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

join BASADOS.localidad on sucursal.suc_localidad=localidad.local_id

join BASADOS.provincia on provincia.prov_id=localidad.local_provincia

join BASADOS.BI_Dim_Ubicacion_Cliente BI_Dim_Ubicacion_Cliente on BI_Dim_Ubicacion_Cliente.prov_nombre=provincia.prov_nombre
and BI_Dim_Ubicacion_Cliente.local_nombre = localidad.local_nombre

join BASADOS.BI_Dim_Modelo mod on mod.modelo_id=sill_modelo

join BASADOS.medida on sill_medida_ancho=med_ancho
and sill_medida_alto=med_alto
and sill_medida_profundidad=med_profundidad

group by BI_Dim_Sucursal.suc_id, 
    BI_Dim_Tiempo.tiempo_id, 
    BI_Dim_RangoEtario.rango_id, 
    BI_Dim_Ubicacion_Cliente.ubicacion_id