-- 1. Ganancias: Total de ingresos (facturación) - total de egresos (compras), por
-- cada mes, por cada sucursal.

CREATE VIEW BASADOS.BI_Tiempo_Promedio_Fabricacion AS
select 
anio, 
mes, 
suc_numero NumeroSucursal, 

(isnull(sum(venta_valor),0) - 
    (select isnull(sum(compra_valor),0) 
        from BASADOS.BI_Hecho_Compra c
        join BASADOS.BI_Dim_Tiempo t2 on t2.tiempo_id = c.tiempo_id
        where t2.anio = t.anio and t2.mes = t.mes and c.suc_id = v.suc_id)) Ganancias
    
    from BASADOS.BI_Hecho_Venta v
    join BASADOS.BI_Dim_Tiempo t on t.tiempo_id = v.tiempo_id
    join BASADOS.BI_Dim_Sucursal s on s.suc_id = v.suc_id
    
    group by anio, mes, suc_numero,v.suc_id
GO

-- SELECT * from BASADOS.BI_Tiempo_Promedio_Fabricacion