CREATE VIEW BASADOS.BI_Vista_Compras_Por_Tipo_Material AS
SELECT 
    t.cuatrimestre,
    tm.tipo_nombre AS material,
    s.suc_id,
    SUM(c.valor_total_compras) AS importe_total_gastado
FROM BASADOS.BI_Hecho_Compra c
JOIN BASADOS.BI_Dim_TipoMaterial tm ON c.tipo_id = tm.tipo_id
JOIN BASADOS.BI_Dim_Tiempo t ON c.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON c.suc_id = s.suc_id
GROUP BY 
t.cuatrimestre,
tm.tipo_id,
tm.tipo_nombre, 
s.suc_id
