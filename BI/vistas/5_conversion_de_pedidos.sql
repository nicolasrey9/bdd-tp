CREATE VIEW BASADOS.BI_Vista_Conversion_Pedidos AS
SELECT 
    t.anio,
    t.cuatrimestre,
    p.suc_id,
    e.ped_estado,
    SUM(p.cantidad_pedidos) AS total_pedidos,
    (SUM(p.cantidad_pedidos) * 100.0 / 
        (select sum(p2.cantidad_pedidos) from BASADOS.BI_Hecho_Pedido p2 join
        BASADOS.BI_Dim_Tiempo t2 on p2.tiempo_id=t2.tiempo_id
        where t2.cuatrimestre=t.cuatrimestre and t2.anio=t.anio
        and p2.suc_id=p.suc_id)
    ) AS porcentaje_conversion
FROM BASADOS.BI_Hecho_Pedido p
JOIN BASADOS.BI_Dim_Tiempo t ON p.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_EstadoPedido e ON p.estado_id = e.estado_id
GROUP BY t.anio, t.cuatrimestre, p.suc_id, e.ped_estado;
GO