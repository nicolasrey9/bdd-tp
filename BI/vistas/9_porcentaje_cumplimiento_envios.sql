-- 9. Porcentaje de cumplimiento de envíos en los tiempos programados por mes.
-- Se calcula teniendo en cuenta los envíos cumplidos en fecha sobre el total de
-- envíos para el período.
CREATE VIEW BASADOS.BI_Cumplimiento_Envios_Por_Mes AS
select 

t.anio Anio, 

t.mes Mes,
        
(count(*) * 100 
/             
(select count(*) from BASADOS.BI_Hecho_envio e2 WHERE e2.tiempo_id = t.tiempo_id)) PorcentajeCumplimiento

from BASADOS.BI_Hecho_Envio e
join BASADOS.BI_Dim_Tiempo t on e.tiempo_id = t.tiempo_id

where t.fecha = e.fecha_programada

group by t.anio, t.mes, t.tiempo_id 

-- SELECT * from BASADOS.BI_Cumplimiento_Envios_Por_Mes

-- DROP VIEW BASADOS.BI_Cumplimiento_Envios_Por_Mes