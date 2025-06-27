-- 9. Porcentaje de cumplimiento de envíos en los tiempos programados por mes.
-- Se calcula teniendo en cuenta los envíos cumplidos en fecha sobre el total de
-- envíos para el período.
CREATE VIEW BASADOS.BI_Cumplimiento_Envios_Por_Mes AS
select 

t.anio Anio, 

t.mes Mes,
        
(count(*) * 100 
/             
(select count(*) from BASADOS.BI_Hecho_envio e2 
join BASADOS.BI_Dim_Tiempo t2 on t2.tiempo_id = e2.tiempo_id
where t2.mes = t.mes and t2.anio = t.anio)) PorcentajeCumplimiento

from BASADOS.BI_Hecho_Envio e
join BASADOS.BI_Dim_Tiempo t on e.tiempo_id = t.tiempo_id

where t.fecha = e.fecha_programada

group by t.anio, t.mes

-- SELECT * from BASADOS.BI_Cumplimiento_Envios_Por_Mes

-- DROP VIEW BASADOS.BI_Cumplimiento_Envios_Por_Mes