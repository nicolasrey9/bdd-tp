CREATE table BASADOS.BI_Hecho_Compra (
    tipo_id BIGINT NOT NULL,
    tiempo_id INT NOT NULL,
    suc_id INT NOT NULL,

    valor_total_compras decimal(18,2),
    valor_promedio_compras decimal(18,2)
)


ALTER TABLE BASADOS.BI_Hecho_Compra
ADD CONSTRAINT PK_Hecho_Compra
PRIMARY KEY (tipo_id, tiempo_id, suc_id);

-----

alter TABLE BASADOS.BI_Hecho_Compra
ADD CONSTRAINT FK_Hecho_Compra_Tipo
FOREIGN KEY (tipo_id)
REFERENCES BASADOS.BI_Dim_TipoMaterial(tipo_id)

alter TABLE BASADOS.BI_Hecho_Compra
ADD CONSTRAINT FK_Hecho_Compra_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Compra
add CONSTRAINT FK_Hecho_Compra_Sucursal FOREIGN KEY (suc_id) 
REFERENCES BASADOS.BI_Dim_Sucursal(suc_id)