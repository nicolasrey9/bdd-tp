--7. Promedio de Compras: importe promedio de compras por mes.
CREATE VIEW BASADOS.BI_Vista_Promedio_Compras_Por_Mes AS
SELECT 
    t.anio,
    t.mes,
    AVG(c.valor_promedio_compras) AS promedio_compras
FROM BASADOS.BI_Hecho_Compra c
JOIN BASADOS.BI_Dim_Tiempo t ON c.tiempo_id = t.tiempo_id
GROUP BY t.anio, t.mes;