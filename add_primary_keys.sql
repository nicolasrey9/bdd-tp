ALTER TABLE BASADOS.cliente
ADD CONSTRAINT PK_cliente 
PRIMARY KEY (clie_id);

ALTER TABLE BASADOS.provincia
ADD CONSTRAINT PK_provincia 
PRIMARY KEY (prov_id);

ALTER TABLE BASADOS.localidad
ADD CONSTRAINT PK_localidad 
PRIMARY KEY (local_id);

ALTER TABLE BASADOS.direccion
ADD CONSTRAINT PK_direccion 
PRIMARY KEY (direc_id);

ALTER TABLE BASADOS.sucursal
ADD CONSTRAINT PK_sucursal 
PRIMARY KEY (suc_numero);

ALTER TABLE BASADOS.pedido
ADD CONSTRAINT PK_pedido 
PRIMARY KEY (ped_numero);

ALTER TABLE BASADOS.cancelacion
ADD CONSTRAINT PK_cancelacion 
PRIMARY KEY (canc_pedido);

ALTER TABLE BASADOS.detalle_pedido
ADD CONSTRAINT PK_detalle_pedido 
PRIMARY KEY (det_pedido, det_sillon);

ALTER TABLE BASADOS.proveedor
ADD CONSTRAINT PK_proveedor 
PRIMARY KEY (prov_cuit);

ALTER TABLE BASADOS.compra
ADD CONSTRAINT PK_compra 
PRIMARY KEY (comp_numero);

ALTER TABLE BASADOS.factura
ADD CONSTRAINT PK_factura 
PRIMARY KEY (fact_numero);

ALTER TABLE BASADOS.envio
ADD CONSTRAINT PK_envio 
PRIMARY KEY (env_numero);

ALTER TABLE BASADOS.detalle_factura
ADD CONSTRAINT PK_detalle_factura 
PRIMARY KEY (det_factura, det_sillon);

ALTER TABLE BASADOS.detalle_compra
ADD CONSTRAINT PK_detalle_compra
PRIMARY KEY (det_compra, det_material);

ALTER TABLE BASADOS.sillon
ADD CONSTRAINT PK_sillon
PRIMARY KEY (sill_codigo);

ALTER TABLE BASADOS.material
ADD CONSTRAINT PK_material
PRIMARY KEY (mat_id);

ALTER TABLE BASADOS.material_por_sillon
ADD CONSTRAINT PK_material_por_sillon
PRIMARY KEY (mat_sillon,mat_material);

ALTER TABLE BASADOS.modelo
ADD CONSTRAINT PK_modelo
PRIMARY KEY (mod_codigo);

ALTER TABLE BASADOS.medida
ADD CONSTRAINT PK_medida
PRIMARY KEY (med_alto, med_ancho, med_profundidad);

ALTER TABLE BASADOS.tipo_material
ADD CONSTRAINT PK_tipo_material
PRIMARY KEY (tipo_id);

ALTER TABLE BASADOS.tela
ADD CONSTRAINT PK_tela
PRIMARY KEY (tela_material);

ALTER TABLE BASADOS.relleno
ADD CONSTRAINT PK_relleno
PRIMARY KEY (rell_material);

ALTER TABLE BASADOS.madera
ADD CONSTRAINT PK_madera
PRIMARY KEY (mad_material);