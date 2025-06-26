CREATE table BASADOS.BI_Hecho_Pedido (
    turno_id TINYINT,
    suc_numero BIGINT,
    tiempo_id INT,
    ped_estado TINYINT,
    pedido_numero decimal(18,0),
)

ALTER TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT PK_Hecho_Pedido
PRIMARY KEY (pedido_numero);

-----

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Turno
FOREIGN KEY (turno_id)
REFERENCES BASADOS.BI_Dim_Turno(turno_id)

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Pedido_Estado
FOREIGN KEY (ped_estado)
REFERENCES BASADOS.BI_Dim_EstadoPedido(ped_estado)