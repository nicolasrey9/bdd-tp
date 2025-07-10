CREATE VIEW BASADOS.BI_TOP_3_MODELOS_MAS_RENDIDORES AS
SELECT
    temp.anio,
    temp.cuatrimestre Cuatrimestre,
    rang.descripcion RangoEtario,
    ubi.local_nombre Localidad,
    mod.descripcion Modelo
    (select m.descripcion 
    
    from BASADOS.BI_Hecho_Venta v 
    join BASADOS.BI_Dim_Modelo m on m.modelo_id = v.modelo_id
    join BASADOS.BI_Dim_Tiempo t on t.tiempo_id = v.tiempo_id 
                                and t.anio = temp.anio 
                                and t.cuatrimestre = temp.cuatrimestre
    join BASADOS.BI_Dim_RangoEtario r on r.rango_id = rang.rango_id 
    join BASADOS.BI_Dim_Ubicacion u on u.ubicacion_id = v.ubicacion_id and u.local_nombre=ubi.local_nombre

    group by m.modelo_id,m.descripcion
    order by count(v.venta_numero) desc)

    from BASADOS.BI_Hecho_Venta venta
    join BASADOS.BI_Dim_Tiempo temp on venta.tiempo_id = temp.tiempo_id
    join BASADOS.BI_Dim_RangoEtario rang on venta.rango_id = rang.rango_id
    join BASADOS.BI_Dim_Ubicacion ubi on ubi.ubicacion_id = venta.ubicacion_id

    group by temp.anio, temp.cuatrimestre, rang.rango_id, rang.descripcion, ubi.local_nombre

GO

SELECT * from BASADOS.BI_TOP_3_MODELOS_MAS_RENDIDORES
go

CREATE VIEW BASADOS.BI_TOP_3_MODELOS_MAS_RENDIDORES AS
SELECT top 3
    temp.anio,
    temp.cuatrimestre Cuatrimestre,
    rang.descripcion RangoEtario,
    ubi.local_nombre Localidad,
    mod.descripcion Modelo

    from BASADOS.BI_Hecho_Venta venta
    join BASADOS.BI_Dim_Tiempo temp on venta.tiempo_id = temp.tiempo_id
    join BASADOS.BI_Dim_RangoEtario rang on venta.rango_id = rang.rango_id
    join BASADOS.BI_Dim_Ubicacion ubi on ubi.ubicacion_id = venta.ubicacion_id

    where mod.modelo_id in (
        select m.modelo_id 
    
    from BASADOS.BI_Hecho_Venta v 
    join BASADOS.BI_Dim_Modelo m on m.modelo_id = v.modelo_id
    join BASADOS.BI_Dim_Tiempo t on t.tiempo_id = v.tiempo_id 
                                and t.anio = temp.anio 
                                and t.cuatrimestre = temp.cuatrimestre
    join BASADOS.BI_Dim_RangoEtario r on r.rango_id = rang.rango_id 
    join BASADOS.BI_Dim_Ubicacion u on u.ubicacion_id = v.ubicacion_id and u.local_nombre=ubi.local_nombre

    group by m.modelo_id,m.descripcion
    order by count(v.venta_numero) desc)

    group by temp.anio, temp.cuatrimestre, rang.rango_id, rang.descripcion, ubi.local_nombre
GO

create VIEW BASADOS.BI_TOP_3_MODELOS_MAS_RENDIDORES as
select top 3 
    modelo.descripcion, 
    tiempo.cuatrimestre, 
    tiempo.anio,
    ubicacion.local_nombre, 
    rang.descripcion rango_etario,
    COUNT(*) AS cantidad_ventas
from 
    BASADOS.BI_Hecho_Venta HechoVenta 
join BASADOS.BI_Dim_Modelo modelo 
    ON modelo.modelo_id=HechoVenta.modelo_id 
join BASADOS.BI_Dim_RangoEtario rang 
    ON rang.rango_id=HechoVenta.rango_id
join BASADOS.BI_Dim_Tiempo tiempo 
    ON tiempo.tiempo_id=HechoVenta.tiempo_id 
join BASADOS.BI_Dim_Ubicacion ubicacion 
    ON ubicacion.ubicacion_id=HechoVenta.ubicacion_id
group by 
    tiempo.cuatrimestre, 
    tiempo.anio, 
    ubicacion.local_nombre, 
    HechoVenta.rango_id,
    rang.descripcion, 
    modelo.descripcion
order by count(*) desc

GO

create VIEW BASADOS.BI_TOP_3_MODELOS_MAS_RENDIDORES as
select
    modelo.descripcion, 
    tiempo.cuatrimestre, 
    tiempo.anio,
    ubicacion.local_nombre, 
    rang.descripcion rango_etario
from
    BASADOS.BI_Hecho_Venta HechoVenta 
join BASADOS.BI_Dim_Modelo modelo 
    ON modelo.modelo_id=HechoVenta.modelo_id 
join BASADOS.BI_Dim_RangoEtario rang 
    ON rang.rango_id=HechoVenta.rango_id
join BASADOS.BI_Dim_Tiempo tiempo 
    ON tiempo.tiempo_id=HechoVenta.tiempo_id 
join BASADOS.BI_Dim_Ubicacion ubicacion 
    ON ubicacion.ubicacion_id=HechoVenta.ubicacion_id
where modelo.modelo_id in (
    select top 3 
        modelo.modelo_id 
    from 
        BASADOS.BI_Hecho_Venta H
    join BASADOS.BI_Dim_Modelo m
        ON m.modelo_id=H.modelo_id 
    join BASADOS.BI_Dim_RangoEtario r
        ON r.rango_id=H.rango_id
    join BASADOS.BI_Dim_Tiempo t
        ON t.tiempo_id=H.tiempo_id 
    join BASADOS.BI_Dim_Ubicacion u
        ON u.ubicacion_id=H.ubicacion_id
    where r.rango_id=rang.rango_id and t.anio=tiempo.anio and t.cuatrimestre=tiempo.cuatrimestre
    and u.local_nombre=ubicacion.local_nombre
    group by 
        t.cuatrimestre, 
        t.anio, 
        u.local_nombre, 
        H.rango_id,
        r.descripcion, 
        m.modelo_id
    order by count(*) desc
)
group by 
    tiempo.cuatrimestre, 
    tiempo.anio, 
    ubicacion.local_nombre, 
    HechoVenta.rango_id,
    rang.descripcion, 
    modelo.descripcion
go

CREATE VIEW BASADOS.BI_TOP_3_MODELOS_MAS_RENDIDORES AS
WITH VentasRankeadas AS (
    SELECT
        modelo.modelo_id,
        modelo.descripcion,
        tiempo.cuatrimestre,
        tiempo.anio,
        ubicacion.local_nombre,
        rango.descripcion AS rango_etario,
        COUNT(*) AS cantidad_ventas,
        ROW_NUMBER() OVER (
            PARTITION BY tiempo.cuatrimestre, tiempo.anio, ubicacion.local_nombre, rango.rango_id
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM BASADOS.BI_Hecho_Venta AS venta
    JOIN BASADOS.BI_Dim_Modelo modelo ON modelo.modelo_id = venta.modelo_id
    JOIN BASADOS.BI_Dim_RangoEtario rango ON rango.rango_id = venta.rango_id
    JOIN BASADOS.BI_Dim_Tiempo tiempo ON tiempo.tiempo_id = venta.tiempo_id
    JOIN BASADOS.BI_Dim_Ubicacion ubicacion ON ubicacion.ubicacion_id = venta.ubicacion_id
    GROUP BY 
        modelo.modelo_id,
        modelo.descripcion,
        tiempo.cuatrimestre,
        tiempo.anio,
        ubicacion.local_nombre,
        rango.rango_id,
        rango.descripcion
)
SELECT 
    modelo_id,
    descripcion,
    cuatrimestre,
    anio,
    local_nombre,
    rango_etario
FROM VentasRankeadas
WHERE rn <= 3;
GO

-- este no tengo idea, le pregunte a claudia sonnet y me tiro esto, lo dejo por si sirve
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
    modelo_id,
    modelo,
    modelo_descripcion,
    total_ventas,
    ranking
FROM VentasRankeadas
WHERE ranking <= 3;
