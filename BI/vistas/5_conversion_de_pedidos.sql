--Vista 5
CREATE VIEW BASADOS.BI_CONVERSION_PEDIDOS AS
SELECT 
    t.anio Anio,
    t.cuatrimestre Cuatrimestre,
    s.suc_numero NumeroSucursal,
    e.ped_estado EstadoPedido,
    COUNT(*) as Cantidad,
    (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY t.anio, t.cuatrimestre, s.suc_numero)) as PorcentajeDelTotal
FROM 
    BASADOS.BI_Hecho_Pedido p
    JOIN BASADOS.BI_Dim_Tiempo t ON p.tiempo_id = t.tiempo_id
    JOIN BASADOS.BI_Dim_Sucursal s ON p.suc_id = s.suc_id
    JOIN BASADOS.BI_Dim_EstadoPedido e ON p.estado_id = e.estado_id
GROUP BY 
    t.anio, t.cuatrimestre, s.suc_numero, e.ped_estado
GO

-- SELECT * from BASADOS.BI_CONVERSION_PEDIDOS

-- DROP VIEW BASADOS.BI_CONVERSION_PEDIDOS