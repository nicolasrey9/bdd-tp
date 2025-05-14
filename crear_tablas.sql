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

