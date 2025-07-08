CREATE table BASADOS.BI_Hecho_Envio (
    tiempo_id INT not null,
    ubicacion_id BIGINT not null,

    porcentaje_cumplimiento_envios DECIMAL(5,2),
    valor_promedio_envios decimal(18,2)
)

ALTER TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT PK_Hecho_Envio
PRIMARY KEY (tiempo_id, ubicacion_id);

-----

alter TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT FK_Hecho_Envio_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT FK_Hecho_Envio_Ubicacion
FOREIGN KEY (ubicacion_id)
REFERENCES BASADOS.BI_Dim_Ubicacion_Cliente(ubicacion_id)