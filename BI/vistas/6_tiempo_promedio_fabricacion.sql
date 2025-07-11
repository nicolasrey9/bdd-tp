CREATE VIEW BASADOS.BI_Vista_Tiempo_Promedio_Fabricacion AS
SELECT 
    t.anio,
    t.cuatrimestre,
    s.suc_id,
    avg(v.tiempo_promedio_fabricacion_en_dias) AS tiempo_promedio_dias
FROM BASADOS.BI_Hecho_Venta v
JOIN BASADOS.BI_Dim_Tiempo t ON v.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON v.suc_id = s.suc_id
GROUP BY t.anio, t.cuatrimestre, s.suc_id

GO