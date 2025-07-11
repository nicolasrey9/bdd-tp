CREATE VIEW BASADOS.BI_Vista_Volumen_Pedidos AS
SELECT 
    t.anio,
    t.mes,
    s.suc_id,
    tu.descripcion AS turno,
    SUM(p.cantidad_pedidos) AS total_pedidos
FROM BASADOS.BI_Hecho_Pedido p
JOIN BASADOS.BI_Dim_Tiempo t ON p.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON p.suc_id = s.suc_id
JOIN BASADOS.BI_Dim_Turno tu ON p.turno_id = tu.turno_id
GROUP BY t.anio, t.mes, s.suc_id, tu.turno_id, tu.descripcion;
GO