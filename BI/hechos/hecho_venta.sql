CREATE table BASADOS.BI_Hecho_Venta (
    suc_id INT not null,
    tiempo_id INT not null,
    rango_id TINYINT not null,
    ubicacion_id BIGINT not null,
    modelo_id BIGINT not null,

    tiempo_promedio_fabricacion_en_dias INT,
    valor_promedio_ventas DECIMAL(18,2),
    valor_total_ventas DECIMAL(18,2)
)


ALTER TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT PK_Hecho_Venta
PRIMARY KEY (suc_id, tiempo_id, rango_id, 
    ubicacion_id, modelo_id);

-----

alter TABLE BASADOS.BI_Hecho_Venta
add CONSTRAINT FK_Hecho_Venta_Sucursal FOREIGN KEY (suc_id) 
REFERENCES BASADOS.BI_Dim_Sucursal(suc_id)

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
REFERENCES BASADOS.BI_Dim_Ubicacion_Cliente(ubicacion_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Modelo
FOREIGN KEY (modelo_id)
REFERENCES BASADOS.BI_Dim_Modelo(modelo_id)