--Vista 5 ?
CREATE VIEW BASADOS.conversion_de_pedidos AS
SELECT 
(count(p.pedido_numero) / (select count(pedido_numero) from BASADOS.BI_Hecho_Pedido)) PorcentajeDePedidosSegunEstado,
ep.ped_estado Estado,
concat(t.anio,t.cuatrimestre) CuatrimestreDelAnio,
p.suc_numero Sucursal

from BASADOS.BI_Hecho_Pedido p
join BASADOS.BI_Dim_Estado_Pedido ep on ep.ped_estado = p.ped_estado
join BASADOS.BI_Dim_Tiempo t on t.tiempo_id = p.tiempo_id

GROUP by ep.ped_estado, t.cuatrimestre,p.suc_numero
ORDER by t.anio,t.cuatrimestre