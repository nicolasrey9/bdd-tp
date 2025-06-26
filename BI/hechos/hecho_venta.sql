CREATE table BASADOS.BI_Hecho_Venta (
    venta_numero BIGINT not null,
    modelo_id BIGINT not null,
    suc_id INT,
    tiempo_id INT,
    rango_id TINYINT,
    ubicacion_id BIGINT,
    venta_valor decimal(18,2),
)


ALTER TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT PK_Hecho_Venta
PRIMARY KEY (venta_numero, modelo_id);

-----

alter TABLE BASADOS.BI_Hecho_Venta
add CONSTRAINT FK_Hecho_Venta_Sucursal FOREIGN KEY (suc_id) 
REFERENCES BASADOS.BI_Dim_Sucursal(suc_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Modelo
FOREIGN KEY (modelo_id)
REFERENCES BASADOS.BI_Dim_Modelo(modelo_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Rango
FOREIGN KEY (rango_id)
REFERENCES BASADOS.BI_Dim_RangoEtario(rango_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Ubicacion
FOREIGN KEY (ubicacion_id)
REFERENCES BASADOS.BI_Dim_Ubicacion(ubicacion_id)