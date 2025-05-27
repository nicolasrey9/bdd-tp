ALTER TABLE cliente
ADD CONSTRAINT PK_cliente 
PRIMARY KEY (clie_id);

ALTER TABLE provincia
ADD CONSTRAINT PK_provincia 
PRIMARY KEY (prov_id);

ALTER TABLE localidad
ADD CONSTRAINT PK_localidad 
PRIMARY KEY (local_id);

ALTER TABLE direccion
ADD CONSTRAINT PK_direccion 
PRIMARY KEY (direc_id);

ALTER TABLE sucursal
ADD CONSTRAINT PK_sucursal 
PRIMARY KEY (suc_numero);

ALTER TABLE pedido
ADD CONSTRAINT PK_pedido 
PRIMARY KEY (ped_numero);

ALTER TABLE cancelacion
ADD CONSTRAINT PK_cancelacion 
PRIMARY KEY (canc_pedido);

ALTER TABLE detalle_pedido
ADD CONSTRAINT PK_detalle_pedido 
PRIMARY KEY (det_pedido, det_sillon);

ALTER TABLE proveedor
ADD CONSTRAINT PK_proveedor 
PRIMARY KEY (prov_cuit);

ALTER TABLE compra
ADD CONSTRAINT PK_compra 
PRIMARY KEY (comp_numero);

ALTER TABLE factura
ADD CONSTRAINT PK_factura 
PRIMARY KEY (fact_numero);

ALTER TABLE envio
ADD CONSTRAINT PK_envio 
PRIMARY KEY (env_numero);

ALTER TABLE detalle_factura
ADD CONSTRAINT PK_detalle_factura 
PRIMARY KEY (det_factura, det_sillon);

ALTER TABLE detalle_compra
ADD CONSTRAINT PK_detalle_compra
PRIMARY KEY (det_compra, det_material);

ALTER TABLE sillon
ADD CONSTRAINT PK_sillon
PRIMARY KEY (sill_codigo);

ALTER TABLE material
ADD CONSTRAINT PK_material
PRIMARY KEY (mat_id);

ALTER TABLE material_por_sillon
ADD CONSTRAINT PK_material_por_sillon
PRIMARY KEY (mat_sillon,mat_material);

ALTER TABLE modelo
ADD CONSTRAINT PK_modelo
PRIMARY KEY (mod_codigo);

ALTER TABLE medida
ADD CONSTRAINT PK_medida
PRIMARY KEY (med_alto, med_ancho, med_profundidad);

ALTER TABLE tipo_material
ADD CONSTRAINT PK_tipo_material
PRIMARY KEY (tipo_id);

ALTER TABLE tela
ADD CONSTRAINT PK_tela
PRIMARY KEY (tela_material);

ALTER TABLE relleno
ADD CONSTRAINT PK_relleno
PRIMARY KEY (rell_material);

ALTER TABLE madera
ADD CONSTRAINT PK_madera
PRIMARY KEY (mad_material);
