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

CREATE VIEW BASADOS.BI_Vista_Top3_Localidades_Mayor_Costo_Envio AS
SELECT TOP 3 
    u.local_nombre AS localidad,
    u.prov_nombre AS provincia,
    AVG(e.valor_promedio_envios) AS promedio_costo_envio
FROM BASADOS.BI_Hecho_Envio e
JOIN BASADOS.BI_Dim_Ubicacion_Cliente u ON e.ubicacion_id = u.ubicacion_id
GROUP BY u.local_nombre, u.prov_nombre
ORDER BY AVG(e.valor_promedio_envios) DESC;