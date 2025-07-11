-- 8. Compras por Tipo de Material. Importe total gastado por tipo de material,
-- sucursal y cuatrimestre.
CREATE VIEW BASADOS.BI_Compras_Por_Tipo_Material AS
SELECT 
    t.anio AS Anio,
    t.cuatrimestre AS Cuatrimestre,
    tm.tipo_nombre AS Material,
    suc.suc_numero Sucursal,
    sum(c.compra_valor) AS ImporteGastado
FROM 
    BASADOS.BI_Hecho_Compra c
    JOIN BASADOS.BI_Dim_TipoMaterial tm ON c.tipo_id = tm.tipo_id
    JOIN BASADOS.BI_Dim_Tiempo t ON c.tiempo_id = t.tiempo_id
    join BASADOS.BI_Dim_Sucursal suc on c.suc_id = suc.suc_id
GROUP BY 
    t.anio, 
    t.cuatrimestre, 
    tm.tipo_nombre,
    suc.suc_numero
GO

/* PARA CHEQUEAR SIRVE, REVISAR!!
select comp_sucursal, sum(det_cantidad*det_precio_unitario), mat_descripcion from BASADOS.compra
join BASADOS.detalle_compra on det_compra = comp_numero
join BASADOS.material on det_material = mat_id

group by comp_sucursal, mat_descripcion

por ejemplo: La sucursal 37 compró 63 palos en madera y si vas sumando los importes por cuatri da eso
*/


CREATE VIEW BASADOS.BI_Vista_Compras_Por_Tipo_Material AS
SELECT 
   -- t.anio,
    t.cuatrimestre,
    tm.tipo_nombre AS material,
    --tm.tipo_descripcion,
    s.suc_id,
    SUM(c.valor_total_compras) AS importe_total_gastado
FROM BASADOS.BI_Hecho_Compra c
JOIN BASADOS.BI_Dim_TipoMaterial tm ON c.tipo_id = tm.tipo_id
JOIN BASADOS.BI_Dim_Tiempo t ON c.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON c.suc_id = s.suc_id
GROUP BY 
--t.anio, 
t.cuatrimestre, 
tm.tipo_nombre, 
--tm.tipo_descripcion, 
s.suc_id
