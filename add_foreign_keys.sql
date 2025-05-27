/*

25 FOREIGN KEYS

*/

ALTER TABLE cliente
ADD CONSTRAINT FK_Cliente_Direccion 
FOREIGN KEY (clie_direccion)
REFERENCES direccion(direc_id)

ALTER TABLE localidad
ADD CONSTRAINT FK_Localidad_Provincia 
FOREIGN KEY (local_provincia) 
REFERENCES provincia(prov_id)

ALTER TABLE direccion
ADD CONSTRAINT FK_Direccion_Localidad 
FOREIGN KEY (direc_localidad)
REFERENCES localidad(local_id)

ALTER TABLE sucursal
ADD CONSTRAINT FK_Sucursal_Direccion 
FOREIGN KEY (suc_direccion)
REFERENCES direccion(direc_id)

ALTER TABLE pedido
ADD CONSTRAINT FK_Pedido_Sucursal 
FOREIGN KEY (ped_sucursal)
REFERENCES sucursal(suc_numero)

ALTER TABLE pedido
ADD CONSTRAINT FK_Pedido_Cliente 
FOREIGN KEY (ped_cliente)
REFERENCES cliente(clie_id)

ALTER TABLE cancelacion
ADD CONSTRAINT FK_Cancelacion_Pedido 
FOREIGN KEY (canc_pedido)
REFERENCES pedido(ped_numero)

ALTER TABLE detalle_pedido
ADD CONSTRAINT FK_DetallePedido_Pedido 
FOREIGN KEY (det_pedido) 
REFERENCES pedido(ped_numero)

ALTER TABLE detalle_pedido    
ADD CONSTRAINT FK_DetallePedido_Sillon 
FOREIGN KEY (det_sillon) 
REFERENCES sillon(sill_id)

ALTER TABLE proveedor
ADD CONSTRAINT FK_Proveedor_Direccion 
FOREIGN KEY (prov_direccion)
REFERENCES direccion(direc_id)

ALTER TABLE compra
ADD CONSTRAINT FK_Compra_Sucursal 
FOREIGN KEY (comp_sucursal)
REFERENCES sucursal(suc_numero)

ALTER TABLE compra
ADD CONSTRAINT FK_Compra_Proveedor 
FOREIGN KEY (comp_proveedor)
REFERENCES provedor(prov_cuit)

ALTER TABLE factura
ADD CONSTRAINT FK_Factura_Cliente 
FOREIGN KEY (fact_cliente) 
REFERENCES cliente(clie_id)

ALTER TABLE factura        
ADD CONSTRAINT FK_Factura_Sucursal 
FOREIGN KEY (fact_sucursal)
REFERENCES sucursal(suc_numero)

ALTER TABLE envio
ADD CONSTRAINT FK_Envio_Factura 
FOREIGN KEY (env_factura)
REFERENCES factura(fact_numero)

ALTER TABLE detalle_compra
ADD CONSTRAINT FK_Detalle_Compra
FOREIGN KEY (det_compra)
REFERENCES compra(comp_numero)

ALTER TABLE detalle_compra
ADD CONSTRAINT FK_Detalle_Compra
FOREIGN KEY (det_material)
REFERENCES material(mat_id)

ALTER TABLE detalle_factura
ADD CONSTRAINT FK_Detalle_Factura
FOREIGN KEY (det_factura)
REFERENCES factura(fact_numero)

ALTER TABLE detalle_factura
ADD CONSTRAINT FK_Detalle_Factura
FOREIGN KEY (det_sillon)
REFERENCES detalle_pedido(det_sillon)

ALTER TABLE sillon
ADD CONSTRAINT FK_Sillon
FOREIGN KEY (sill_medida_alto)
REFERENCES medida(med_alto)

ALTER TABLE sillon
ADD CONSTRAINT FK_Sillon
FOREIGN KEY (sill_medida_ancho)
REFERENCES medida(med_ancho)

ALTER TABLE sillon
ADD CONSTRAINT FK_Sillon
FOREIGN KEY (sill_medida_profundidad)
REFERENCES medida(med_profundidad)

ALTER TABLE material_por_sillon
ADD CONSTRAINT FK_Material_Por_Sillon
FOREIGN KEY (mat_sillon)
REFERENCES sillon(sill_codigo)

ALTER TABLE material_por_sillon
ADD CONSTRAINT FK_Material_Por_Sillon
FOREIGN KEY (mat_material)
REFERENCES material(mat_id)

ALTER TABLE material
ADD CONSTRAINT FK_Material
FOREIGN KEY (mat_tipo)
REFERENCES tipo_material(tipo_id)
