CREATE VIEW BASADOS.BI_Vista_Rendimiento_Modelos AS
WITH VentasRankeadas AS (
    SELECT
        modelo.modelo_id,
        modelo.modelo,
        modelo.descripcion AS modelo_descripcion,
        tiempo.anio,
        tiempo.cuatrimestre,
        sucursal.localidad AS sucursal_localidad,
        rango.descripcion AS rango_etario,
        SUM(venta.valor_total_ventas) AS total_ventas,
        ROW_NUMBER() OVER (
            PARTITION BY tiempo.anio, tiempo.cuatrimestre, sucursal.localidad, rango.rango_id
            ORDER BY SUM(venta.valor_total_ventas) DESC
        ) AS ranking
    FROM BASADOS.BI_Hecho_Venta venta
    JOIN BASADOS.BI_Dim_Modelo modelo ON modelo.modelo_id = venta.modelo_id
    JOIN BASADOS.BI_Dim_RangoEtario rango ON rango.rango_id = venta.rango_id
    JOIN BASADOS.BI_Dim_Tiempo tiempo ON tiempo.tiempo_id = venta.tiempo_id
    JOIN BASADOS.BI_Dim_Sucursal sucursal ON sucursal.suc_id = venta.suc_id
    GROUP BY 
        modelo.modelo_id,
        modelo.modelo,
        modelo.descripcion,
        tiempo.anio,
        tiempo.cuatrimestre,
        sucursal.localidad,
        rango.rango_id,
        rango.descripcion
)
SELECT 
    anio,
    cuatrimestre,
    sucursal_localidad,
    rango_etario,
    --modelo_id,
    modelo,
    total_ventas,
    ranking
FROM VentasRankeadas
WHERE ranking <= 3