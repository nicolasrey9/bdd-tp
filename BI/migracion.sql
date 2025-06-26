insert into BASADOS.BI_Hecho_Pedido(
    pedido_numero, turno_id, 
    suc_id, tiempo_id, estado_id)
select ped_numero, turno.turno_id,
    sucursal.suc_id, tiempo.tiempo_id, estado.estado_id
from BASADOS.pedido join BASADOS.BI_Dim_Turno turno 
on CAST(ped_fecha AS TIME) BETWEEN hora_desde AND hora_hasta
join BASADOS.BI_Dim_Sucursal sucursal on
sucursal.suc_numero = ped_sucursal
join BASADOS.BI_Dim_Tiempo tiempo on
CAST(ped_fecha AS DATE) = tiempo.fecha
join BASADOS.BI_Dim_EstadoPedido estado
on estado.ped_estado = ped_estado