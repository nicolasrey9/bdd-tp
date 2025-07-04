CREATE TABLE BASADOS.BI_Hecho_Pedido (
    pedido_numero DECIMAL(18,0) PRIMARY KEY,
    turno_id TINYINT,
    suc_id INT,
    tiempo_id INT,
    estado_id TINYINT,
    
    CONSTRAINT FK_Turno FOREIGN KEY (turno_id) REFERENCES BASADOS.BI_Dim_Turno(turno_id),
    CONSTRAINT FK_Sucursal FOREIGN KEY (suc_id) REFERENCES BASADOS.BI_Dim_Sucursal(suc_id),
    CONSTRAINT FK_Tiempo FOREIGN KEY (tiempo_id) REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id),
    CONSTRAINT FK_Estado FOREIGN KEY (estado_id) REFERENCES BASADOS.BI_Dim_EstadoPedido(estado_id)
);
CREATE INDEX IX_HechoPedido_Tiempo ON BASADOS.BI_Hecho_Pedido(tiempo_id);
CREATE INDEX IX_HechoPedido_Sucursal ON BASADOS.BI_Hecho_Pedido(suc_id);
CREATE INDEX IX_HechoPedido_Turno ON BASADOS.BI_Hecho_Pedido(turno_id);
CREATE INDEX IX_HechoPedido_Estado ON BASADOS.BI_Hecho_Pedido(estado_id);