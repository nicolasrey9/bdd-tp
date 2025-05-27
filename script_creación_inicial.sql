CREATE TABLE cliente(
    clie_id BIGINT NOT NULL PRIMARY KEY,
    clie_dni BIGINT NOT NULL,
    clie_nombre NVARCHAR(255) NOT NULL,
    clie_apellido NVARCHAR(255) NOT NULL,
    clie_mail NVARCHAR(255),
    clie_telefono NVARCHAR(255),
    cle_fecha_nac DATETIME2(6),
    clie_direccion BIGINT, --podríamos ponerle not null?
    CONSTRAINT FK_Cliente_Direccion FOREIGN KEY (clie_direccion)
        REFERENCES direccion(direc_id))


-- la más independiente
CREATE TABLE provincia(
    prov_id BIGINT NOT NULL PRIMARY KEY,
    prov_nombre NVARCHAR(255) NOT NULL
)

-- localidad (depende de provincia)
CREATE TABLE localidad(
    local_id BIGINT NOT NULL PRIMARY KEY,
    local_nombre NVARCHAR(255) NOT NULL,
    local_provincia BIGINT NOT NULL,
    CONSTRAINT FK_Localidad_Provincia FOREIGN KEY (local_provincia) 
        REFERENCES provincia(prov_id)
)

-- direccion (depende de localidad)
CREATE TABLE direccion(
    direc_id BIGINT NOT NULL PRIMARY KEY,
    direc_nombre NVARCHAR(255) NOT NULL,
    direc_localidad BIGINT NOT NULL,
    CONSTRAINT FK_Direccion_Localidad FOREIGN KEY (direc_localidad) --agregué la FK de esta manera (?)
        REFERENCES localidad(local_id)
)

CREATE TABLE sucursal(
    suc_numero BIGINT NOT NULL PRIMARY KEY,
    suc_mail NVARCHAR(255),
    suc_telefono NVARCHAR(255),
    suc_direccion BIGINT,
    CONSTRAINT FK_Sucursal_Direccion FOREIGN KEY (suc_direccion)
        REFERENCES direccion(direc_id))

CREATE TABLE pedido(
    ped_numero DECIMAL(18,0) NOT NULL,
    ped_fecha DATETIME2(6),
    ped_estado NVARCHAR(255),
    ped_total DECIMAL(18,2), --! creo que esta mal
    ped_sucursal BIGINT,
    ped_cliente BIGINT,
    CONSTRAINT FK_Pedido_Sucursal FOREIGN KEY (ped_sucursal)
        REFERENCES sucursal(suc_numero)
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (ped_cliente)
        REFERENCES cliente(clie_id)
)

CREATE TABLE cancelacion(
    canc_pedido DECIMAL(18,0) NOT NULL,
    canc_fecha DATETIME2(6),
    canc_motivo VARCHAR(255)
    CONSTRAINT FK_Cancelacion_Pedido FOREIGN KEY (canc_pedido)
        REFERENCES pedido(ped_numero)
)

CREATE TABLE detalle_pedido(
    det_pedido DECIMAL(18,0) NOT NULL,
    det_sillon BIGINT NOT NULL,
    det_cantidad BIGINT,
    det_linea BIGINT,
    
    CONSTRAINT PK_DetallePedido PRIMARY KEY (det_pedido, det_sillon),
    
    CONSTRAINT FK_DetallePedido_Pedido FOREIGN KEY (det_pedido) 
        REFERENCES pedido(ped_numero),
    
    CONSTRAINT FK_DetallePedido_Sillon FOREIGN KEY (det_sillon) 
        REFERENCES sillon(sill_id) -- Ajustar según tu nombre de tabla
) -- se complicó un poco pq es compuesta por 2 FK la PK :)

CREATE TABLE proveedor(
    prov_cuit NVARCHAR(255) NOT NULL PRIMARY KEY,
    prov_razonSocial NVARCHAR(255),
    prov_telefono NVARCHAR(255),
    prov_mail NVARCHAR(255),
    prov_direccion BIGINT,
        CONSTRAINT FK_Proveedor_Direccion FOREIGN KEY (prov_direccion)
            REFERENCES direccion(direc_id)
)--chequear NOT NULLS

CREATE TABLE compra(
    comp_numero DECIMAL(18,0) NOT NULL PRIMARY KEY,
    comp_fecha DATETIME2(6),
    comp_total DECIMAL(18,2),
    comp_sucursal BIGINT,
    comp_proveedor NVARCHAR(255),

        CONSTRAINT FK_Compra_Sucursal FOREIGN KEY (comp_sucursal)
            REFERENCES sucursal(suc_numero)
        CONSTRAINT FK_Compra_Proveedor FOREIGN KEY (comp_proveedor)
            REFERENCES provedor(prov_cuit)
)

CREATE TABLE factura(
    fact_numero BIGINT NOT NULL PRIMARY KEY,
    fact_fecha DATETIME2(6),
    fact_cliente BIGINT,
    fact_sucursal BIGINT,

        CONSTRAINT FK_Factura_Cliente FOREIGN KEY (fact_cliente) 
            REFERENCES cliente(clie_id)
        CONSTRAINT FK_Factura_Sucursal FOREIGN KEY (fact_sucursal)
            REFERENCES sucursal(suc_numero)
)

CREATE TABLE envio(
    env_numero DECIMAL(18,0) NOT NULL PRIMARY KEY,
    env_fecha_programada DATETIME2(6),
    env_fecha DATETIME2(6),
    env_importe_traslado DECIMAL(18,2),
    env_importeSubida DECIMAL(18,2),
    env_factura BIGINT,

        CONSTRAINT PK_Envio_Factura FOREIGN KEY (env_factura)
            REFERENCES factura(fact_numero)
)

CREATE TABLE detalle_compra()
CREATE TABLE modelo()
CREATE TABLE detalle_factura()
CREATE TABLE detalle_pedido()
CREATE TABLE sillon()
CREATE TABLE material()
CREATE TABLE modelo()
CREATE TABLE medida()
