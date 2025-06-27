--Vista 4
CREATE VIEW BASADOS.BI_VOLUMEN_PEDIDOS AS
SELECT 
    t.anio Anio,
    t.mes Mes,
    s.suc_numero NumeroSucursal,
    tu.descripcion Turno,
    COUNT(*) as CantidadPedidos
FROM 
    BASADOS.BI_Hecho_Pedido p
    JOIN BASADOS.BI_Dim_Tiempo t ON p.tiempo_id = t.tiempo_id
    JOIN BASADOS.BI_Dim_Sucursal s ON p.suc_id = s.suc_id
    JOIN BASADOS.BI_Dim_Turno tu ON p.turno_id = tu.turno_id
GROUP BY 
    t.anio, t.mes, s.suc_numero, tu.descripcion
GO

-- select * from BASADOS.BI_VOLUMEN_PEDIDOS order by 1,2,3,4
-- drop view BASADOS.BI_VOLUMEN_PEDIDOS
