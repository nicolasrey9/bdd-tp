--7. Promedio de Compras: importe promedio de compras por mes.
create view BASADOS.BI_Promedio_Compras_Por_Mes as
select anio Anio, mes Mes, avg(compra_valor) PromedioCompras
from BASADOS.BI_Hecho_Compra c
join BASADOS.BI_Dim_Tiempo t on c.tiempo_id = t.tiempo_id
group by anio, mes

-- select * from BASADOS.BI_Promedio_Compras_Por_Mes order by 1,2

