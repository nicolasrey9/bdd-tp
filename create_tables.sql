/*
    23 ENTIDADES
*/

CREATE TABLE BASADOS.cliente(
    clie_id BIGINT IDENTITY(1,1) NOT NULL,
    clie_dni BIGINT NOT NULL,
    clie_nombre NVARCHAR(255) NOT NULL,
    clie_apellido NVARCHAR(255) NOT NULL,
    clie_mail NVARCHAR(255),
    clie_telefono NVARCHAR(255),
    clie_fecha_nac DATETIME2(6),
    clie_direccion NVARCHAR(255),
    clie_localidad BIGINT
)


CREATE TABLE BASADOS.localidad(
    local_id BIGINT IDENTITY(1,1) NOT NULL,
    local_nombre NVARCHAR(255) NOT NULL,
    local_provincia BIGINT NOT NULL
)

CREATE TABLE BASADOS.provincia(
    prov_id BIGINT IDENTITY(1,1) NOT NULL,
    prov_nombre NVARCHAR(255) NOT NULL
)

CREATE TABLE BASADOS.sucursal(
    suc_numero BIGINT NOT NULL,
    suc_mail NVARCHAR(255),
    suc_telefono NVARCHAR(255),
    suc_direccion NVARCHAR(255),
    suc_localidad BIGINT
)

CREATE TABLE BASADOS.pedido(
    ped_numero DECIMAL(18,0) NOT NULL,
    ped_fecha DATETIME2(6),
    ped_estado NVARCHAR(255),
    ped_total DECIMAL(18,2),
    ped_sucursal BIGINT,
    ped_cliente BIGINT
)

CREATE TABLE BASADOS.detalle_pedido(
    det_pedido DECIMAL(18,0) NOT NULL,
    det_numero BIGINT NOT NULL,
    det_cantidad BIGINT,
    det_sillon BIGINT,
    det_precio_unitario DECIMAL(18,2)
)

CREATE TABLE BASADOS.cancelacion(
    canc_pedido DECIMAL(18,0) NOT NULL,
    canc_fecha DATETIME2(6),
    canc_motivo VARCHAR(255)
)

CREATE TABLE BASADOS.proveedor(
    prov_cuit NVARCHAR(255) NOT NULL,
    prov_razon_social NVARCHAR(255),
    prov_telefono NVARCHAR(255),
    prov_mail NVARCHAR(255),
    prov_direccion NVARCHAR(255),
    prov_localidad BIGINT
)

CREATE TABLE BASADOS.compra(
    comp_numero DECIMAL(18,0) NOT NULL,
    comp_fecha DATETIME2(6),
    comp_total DECIMAL(18,2),
    comp_sucursal BIGINT,
    comp_proveedor NVARCHAR(255)
)

CREATE TABLE BASADOS.detalle_compra(
    det_compra DECIMAL(18,0) NOT NULL,
    det_material BIGINT NOT NULL,
    det_precio_unitario DECIMAL(18,2),
    det_cantidad DECIMAL(18,0)
)

CREATE TABLE BASADOS.factura(
    fact_numero BIGINT NOT NULL,
    fact_fecha DATETIME2(6),
    fact_cliente BIGINT,
    fact_sucursal BIGINT
)

CREATE TABLE BASADOS.detalle_factura(
    det_factura BIGINT NOT NULL,
    det_pedido DECIMAL(18,0) NOT NULL,
    det_numero BIGINT NOT NULL,
    det_precio_unitario DECIMAL(18,2),
    det_cantidad BIGINT
)

CREATE TABLE BASADOS.envio(
    env_numero DECIMAL(18,0) NOT NULL,
    env_fecha_programada DATETIME2(6),
    env_fecha DATETIME2(6),
    env_importe_traslado DECIMAL(18,2),
    env_importe_subida DECIMAL(18,2),
    env_factura BIGINT
)


CREATE TABLE BASADOS.modelo(
    mod_codigo BIGINT NOT NULL,
    mod_modelo NVARCHAR(255),
    mod_descripcion NVARCHAR(255),
    mod_precio_base DECIMAL(18,2)
)


CREATE TABLE BASADOS.sillon(
    sill_codigo BIGINT NOT NULL,
    sill_modelo BIGINT,
    sill_medida_alto DECIMAL(18,2),
    sill_medida_ancho DECIMAL(18,2),
    sill_medida_profundidad DECIMAL(18,2)
)

CREATE TABLE BASADOS.medida(
    med_alto DECIMAL(18,2) NOT NULL,
    med_ancho DECIMAL(18,2) NOT NULL,
    med_profundidad DECIMAL(18,2) NOT NULL,
    med_precio DECIMAL(18,2)
)

CREATE TABLE BASADOS.material_por_sillon(
    mat_sillon BIGINT NOT NULL,
    mat_material BIGINT NOT NULL
)

CREATE TABLE BASADOS.material(
    mat_id BIGINT IDENTITY(1,1) NOT NULL,
    mat_nombre NVARCHAR(255),
    mat_descripcion NVARCHAR(255),
    mat_precio DECIMAL(38,2),
    mat_tipo BIGINT
)

CREATE TABLE BASADOS.tipo_material(
    tipo_id BIGINT IDENTITY(1,1) NOT NULL,
    tipo_nombre NVARCHAR(255)
)

CREATE TABLE BASADOS.tela(
    tela_material BIGINT NOT NULL,
    tela_color NVARCHAR(255),
    tela_textura NVARCHAR(255)
)

CREATE TABLE BASADOS.relleno(
    rell_material BIGINT NOT NULL,
    rell_densidad DECIMAL(38,2)
)

CREATE TABLE BASADOS.madera(
    mad_material BIGINT NOT NULL,
    mad_color NVARCHAR(255),
    mad_dureza NVARCHAR(255)
)