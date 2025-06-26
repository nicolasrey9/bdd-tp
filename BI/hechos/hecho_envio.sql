CREATE table BASADOS.BI_Hecho_Envio (
    envio_numero decimal(18,0) not null,
    tiempo_id INT,
    ubicacion_id BIGINT,
    costo_envio decimal(18,2),
    fecha_programada DATE
)

ALTER TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT PK_Hecho_Envio
PRIMARY KEY (envio_numero);

-----

alter TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT FK_Hecho_Envio_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT FK_Hecho_Envio_Ubicacion
FOREIGN KEY (ubicacion_id)
REFERENCES BASADOS.BI_Dim_Ubicacion(ubicacion_id)