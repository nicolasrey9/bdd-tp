CREATE VIEW BASADOS.BI_Tiempo_Promedio_Fabricacion AS
SELECT
    t_fact.cuatrimestre,
    s.suc_numero,
    AVG(DATEDIFF(DAY, t_ped.fecha, t_fact.fecha)) AS TiempoPromedioEnDias
FROM BASADOS.BI_Hecho_Venta v
       JOIN BASADOS.BI_Hecho_Pedido p 
              ON v.pedido_numero = p.pedido_numero
JOIN BASADOS.BI_Dim_Tiempo t_ped 
              ON p.tiempo_id = t_ped.tiempo_id
JOIN BASADOS.BI_Dim_Tiempo t_fact 
              ON v.tiempo_id = t_fact.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s 
              ON v.suc_id = s.suc_id
GROUP BY t_fact.cuatrimestre, s.suc_numero
GO
-- select * from BASADOS.BI_Tiempo_Promedio_Fabricacion

DROP VIEW BASADOS.BI_Tiempo_Promedio_Fabricacion