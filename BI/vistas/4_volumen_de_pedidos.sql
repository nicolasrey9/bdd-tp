--Vista 4?
CREATE VIEW BASADOS.volumen_de_pedidos AS
SELECT 

count(distinct pedido_numero) PedidosRegistrados, 

tur.descripcion Turno, 

suc_numero Sucursal,

concat(t.anio,t.mes) MesDelAnio 

from BASADOS.BI_Hecho_Pedido p
join BASADOS.BI_Dim_Tiempo t on t.tiempo_id = p.tiempo_id
join BASADOS.BI_Dim_Turno tur on tur.turno_id = p.turno_id

GROUP BY t.anio,t.mes, pedido_numero, suc_numero, turno_id
order by t.anio,t.mes
GO