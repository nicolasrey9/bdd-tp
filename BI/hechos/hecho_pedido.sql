CREATE TABLE BASADOS.BI_Hecho_Pedido (
    turno_id TINYINT NOT NULL,
    suc_id INT NOT NULL,
    tiempo_id INT NOT NULL,
    estado_id TINYINT NOT NULL,

    cantidad_pedidos BIGINT
);


ALTER TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT PK_Hecho_Pedido
PRIMARY KEY (turno_id, suc_id, tiempo_id, estado_id);

-----

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Turno
FOREIGN KEY (turno_id)
REFERENCES BASADOS.BI_Dim_Turno(turno_id)

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Sucursal
FOREIGN KEY (suc_id)
REFERENCES BASADOS.BI_Dim_Sucursal(suc_id)

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Estato
FOREIGN KEY (estado_id)
REFERENCES BASADOS.BI_Dim_EstadoPedido(estado_id)