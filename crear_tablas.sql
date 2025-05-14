CREATE TABLE cliente(
    clie_id BIGINT NOT NULL,
    clie_dni BIGINT NOT NULL,
    clie_nombre NVARCHAR(255) NOT NULL,
    clie_apellido NVARCHAR(255) NOT NULL,
    clie_mail NVARCHAR(255),
    clie_telefono NVARCHAR(255),
    cle_fecha_nac DATETIME2(6),
    clie_ubicacion BIGINT )


CREATE TABLE ubicacion(
    ubi_id BIGINT NOT NULL,
    ubi_provincia NVARCHAR(255) NOT NULL,
    ubi_localidad NVARCHAR(255) NOT NULL,
    ubi_direccion NVARCHAR(255) NOT NULL)

CREATE TABLE sucursal(
    suc_numero BIGINT NOT NULL,
    suc_mail NVARCHAR(255),
    suc_telefono NVARCHAR(255),
    suc_ubicacion BIGINT)

CREATE TABLE pedido(
    ped_numero DECIMAL(18,0) NOT NULL,
    ped_fecha DATETIME2(6),
    ped_estado NVARCHAR(255),
    ped_total DECIMAL(18,2), --! creo que esta mal
    ped_sucursal BIGINT,
    ped_cliente BIGINT
)

CREATE TABLE cancelacion(
    canc_pedido DECIMAL(18,0) NOT NULL,
    canc_fecha DATETIME2(6),
    canc_motivo VARCHAR(255)
)

CREATE TABLE detalle_pedido(
    det_pedido DECIMAL(18,0) NOT NULL,
    det_sillon BIGINT NOT NULL,
    det_cantidad BIGINT,
    det_linea BIGINT
)