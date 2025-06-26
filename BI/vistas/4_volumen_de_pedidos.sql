--Vista 4?
CREATE VIEW BASADOS.BI_Volumen_Pedidos AS
SELECT 
    t.anio AS Año,
    t.cuatrimestre AS Cuatrimestre,
    t.mes AS Mes,
    s.suc_numero AS Sucursal,
    tu.descripcion AS Turno,
    COUNT(p.pedido_numero) AS Cantidad_Pedidos
FROM 
    BASADOS.BI_Hecho_Pedido p
    JOIN BASADOS.BI_Dim_Tiempo t ON p.tiempo_id = t.tiempo_id
    JOIN BASADOS.BI_Dim_Sucursal s ON p.suc_id = s.suc_id
    JOIN BASADOS.BI_Dim_Turno tu ON p.turno_id = tu.turno_id
GROUP BY 
    t.anio, t.cuatrimestre, t.mes, s.suc_numero, tu.descripcion

GO
select * from BASADOS.BI_Volumen_Pedidos

drop view BASADOS.volumen_de_pedidos
go
