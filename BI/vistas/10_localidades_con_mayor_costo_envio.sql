-- 10. Localidades que pagan mayor costo de envío. Las 3 localidades (tomando la
-- localidad del cliente) con mayor promedio de costo de envío (total).

CREATE VIEW BASADOS.BI_Top3_Localidades_Mayor_Costo_Envio AS
SELECT TOP 3 local_nombre NombreLocalidad
FROM BASADOS.BI_Hecho_Envio e
JOIN BASADOS.BI_Dim_Ubicacion u ON e.ubicacion_id = u.ubicacion_id
GROUP BY local_nombre
ORDER BY AVG(costo_envio) DESC;
GO 

select * from BASADOS.BI_Top3_Localidades_Mayor_Costo_Envio

DROP view BASADOS.BI_Top3_Localidades_Mayor_Costo_Envio