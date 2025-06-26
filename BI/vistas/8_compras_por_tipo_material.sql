-- 8. Compras por Tipo de Material. Importe total gastado por tipo de material,
-- sucursal y cuatrimestre.
create view BASADOS.BI_Compras_Por_Tipo_Material AS
select tipo_nombre, sum(compra_valor), suc_numero, cuatrimestre
from BASADOS.BI_Hecho_Compra c
join BASADOS.BI_Dim_TipoMaterial tm  on c.tipo_id = tm.tipo_id
join BASADOS.BI_Dim_Sucursal s on c.suc_id = s.suc_id
join BASADOS.BI_Dim_Tiempo t on c.tiempo_id = t.tiempo_id
group by c.tipo_id, tm.tipo_nombre, s.suc_id, t.cuatrimestre

-- select * from BASADOS.BI_Compras_Por_Tipo_Material
-- drop view BASADOS.BI_Compras_Por_Tipo_Material