ALTER TABLE BASADOS.cliente
ADD CONSTRAINT FK_Cliente_Localidad 
FOREIGN KEY (clie_localidad)
REFERENCES BASADOS.localidad(local_id)

ALTER TABLE BASADOS.localidad
ADD CONSTRAINT FK_Localidad_Provincia 
FOREIGN KEY (local_provincia) 
REFERENCES BASADOS.provincia(prov_id)

ALTER TABLE BASADOS.sucursal
ADD CONSTRAINT FK_Sucursal_Localidad
FOREIGN KEY (suc_localidad)
REFERENCES BASADOS.localidad(local_id)

ALTER TABLE BASADOS.pedido
ADD CONSTRAINT FK_Pedido_Sucursal 
FOREIGN KEY (ped_sucursal)
REFERENCES BASADOS.sucursal(suc_numero)

ALTER TABLE BASADOS.pedido
ADD CONSTRAINT FK_Pedido_Cliente 
FOREIGN KEY (ped_cliente)
REFERENCES BASADOS.cliente(clie_id)

ALTER TABLE BASADOS.cancelacion
ADD CONSTRAINT FK_Cancelacion_Pedido 
FOREIGN KEY (canc_pedido)
REFERENCES BASADOS.pedido(ped_numero)

ALTER TABLE BASADOS.detalle_pedido
ADD CONSTRAINT FK_Detalle_Pedido_Pedido 
FOREIGN KEY (det_pedido) 
REFERENCES BASADOS.pedido(ped_numero)

ALTER TABLE BASADOS.detalle_pedido    
ADD CONSTRAINT FK_Detalle_Pedido_Sillon 
FOREIGN KEY (det_sillon) 
REFERENCES BASADOS.sillon(sill_codigo)

ALTER TABLE BASADOS.proveedor
ADD CONSTRAINT FK_Proveedor_Localidad
FOREIGN KEY (prov_localidad)
REFERENCES BASADOS.localidad(local_id)

ALTER TABLE BASADOS.compra
ADD CONSTRAINT FK_Compra_Sucursal 
FOREIGN KEY (comp_sucursal)
REFERENCES BASADOS.sucursal(suc_numero)

ALTER TABLE BASADOS.compra
ADD CONSTRAINT FK_Compra_Proveedor 
FOREIGN KEY (comp_proveedor)
REFERENCES BASADOS.proveedor(prov_cuit)

ALTER TABLE BASADOS.factura
ADD CONSTRAINT FK_Factura_Cliente 
FOREIGN KEY (fact_cliente) 
REFERENCES BASADOS.cliente(clie_id)

ALTER TABLE BASADOS.factura        
ADD CONSTRAINT FK_Factura_Sucursal 
FOREIGN KEY (fact_sucursal)
REFERENCES BASADOS.sucursal(suc_numero)

ALTER TABLE BASADOS.envio
ADD CONSTRAINT FK_Envio_Factura 
FOREIGN KEY (env_factura)
REFERENCES BASADOS.factura(fact_numero)

ALTER TABLE BASADOS.detalle_compra
ADD CONSTRAINT FK_Detalle_Compra_Compra
FOREIGN KEY (det_compra)
REFERENCES BASADOS.compra(comp_numero)

ALTER TABLE BASADOS.detalle_compra
ADD CONSTRAINT FK_Detalle_Compra_Material
FOREIGN KEY (det_material)
REFERENCES BASADOS.material(mat_id)

ALTER TABLE BASADOS.detalle_factura
ADD CONSTRAINT FK_Detalle_Factura_Factura
FOREIGN KEY (det_factura)
REFERENCES BASADOS.factura(fact_numero)

ALTER TABLE BASADOS.detalle_factura
ADD CONSTRAINT FK_Detalle_Factura_Detalle_Pedido
FOREIGN KEY (det_pedido, det_numero)
REFERENCES BASADOS.detalle_pedido(det_pedido, det_numero)


ALTER TABLE BASADOS.sillon
ADD CONSTRAINT FK_Sillon_Medida
FOREIGN KEY (sill_medida_alto, sill_medida_ancho, sill_medida_profundidad)
REFERENCES BASADOS.medida(med_alto, med_ancho, med_profundidad);

ALTER TABLE BASADOS.material_por_sillon
ADD CONSTRAINT FK_Material_Por_Sillon_Sillon
FOREIGN KEY (mat_sillon)
REFERENCES BASADOS.sillon(sill_codigo)

ALTER TABLE BASADOS.material_por_sillon
ADD CONSTRAINT FK_Material_Por_Sillon_Material
FOREIGN KEY (mat_material)
REFERENCES BASADOS.material(mat_id)

ALTER TABLE BASADOS.material
ADD CONSTRAINT FK_Material_Tipo_Material
FOREIGN KEY (mat_tipo)
REFERENCES BASADOS.tipo_material(tipo_id)

ALTER TABLE BASADOS.tela
ADD CONSTRAINT FK_Tela_Material
FOREIGN KEY (tela_material)
REFERENCES BASADOS.material(mat_id)

ALTER TABLE BASADOS.relleno
ADD CONSTRAINT FK_Relleno_Material
FOREIGN KEY (rell_material)
REFERENCES BASADOS.material(mat_id)

ALTER TABLE BASADOS.madera
ADD CONSTRAINT FK_Madera_Material
FOREIGN KEY (mad_material)
REFERENCES BASADOS.material(mat_id)