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