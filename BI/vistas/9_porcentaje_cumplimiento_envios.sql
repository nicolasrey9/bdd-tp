-- 9. Porcentaje de cumplimiento de envíos en los tiempos programados por mes.
-- Se calcula teniendo en cuenta los envíos cumplidos en fecha sobre el total de
-- envíos para el período.
CREATE VIEW BASADOS.BI_Vista_Cumplimiento_Envios_Por_Mes AS
SELECT 
    t.anio,
    t.mes,
    AVG(e.porcentaje_cumplimiento_envios) AS porcentaje_cumplimiento_promedio
FROM BASADOS.BI_Hecho_Envio e
JOIN BASADOS.BI_Dim_Tiempo t ON e.tiempo_id = t.tiempo_id
GROUP BY t.anio, t.mes;