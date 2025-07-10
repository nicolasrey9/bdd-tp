/*2. Factura promedio mensual. Valor promedio de las facturas (en $) según la
provincia de la sucursal para cada cuatrimestre de cada año. Se calcula en
función de la sumatoria del importe de las facturas sobre el total de las mismas
durante dicho período.*/
CREATE VIEW BASADOS.BI_FACTURA_PROMEDIO_MENSUAL AS
SELECT
    temp.anio Anio,
    temp.cuatrimestre Cuatrimestre,
    ubi.prov_nombre Provincia,
    sum(venta.venta_valor) 
    /
    count(venta.venta_numero) FacturaPromedio

    FROM BASADOS.BI_Hecho_Venta venta
    join BASADOS.BI_Dim_Ubicacion ubi on venta.ubicacion_id = ubi.ubicacion_id
    join BASADOS.BI_Dim_Tiempo temp on venta.tiempo_id = temp.tiempo_id

    GROUP BY ubi.prov_nombre, temp.anio, temp.cuatrimestre
GO

--SELECT * from BASADOS.BI_FACTURA_PROMEDIO_MENSUAL
go

CREATE VIEW BASADOS.BI_Vista_Factura_Promedio_Mensual AS
SELECT
    t.anio,
    t.cuatrimestre,
    s.provincia,
    SUM(v.valor_total_ventas) / COUNT(*) AS factura_promedio
FROM BASADOS.BI_Hecho_Venta v
JOIN BASADOS.BI_Dim_Tiempo t ON v.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON v.suc_id = s.suc_id
GROUP BY s.provincia, t.anio, t.cuatrimestre;
GO

---esta iria
SELECT
    t.anio,
    t.mes,
    s.provincia,
    avg(v.valor_promedio_ventas)
FROM BASADOS.BI_Hecho_Venta v
JOIN BASADOS.BI_Dim_Tiempo t ON v.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON v.suc_id = s.suc_id
GROUP BY s.provincia, t.anio, t.mes

go