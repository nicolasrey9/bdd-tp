--------------------------
---- DIMENSION TIEMPO ----
--------------------------
CREATE TABLE BASADOS.BI_Dim_Tiempo (
    tiempo_id      INT IDENTITY(1,1) PRIMARY KEY,
    fecha          DATE NOT NULL,
    anio           INT NOT NULL,
    cuatrimestre   TINYINT NOT NULL,
    mes            TINYINT NOT NULL
);

-- Rango de fechas automático
DECLARE @MinDate DATE = (SELECT MIN(min_fecha) FROM (
    SELECT MIN(ped_fecha) AS min_fecha FROM BASADOS.pedido
    UNION ALL
    SELECT MIN(fact_fecha) FROM BASADOS.factura
    UNION ALL
    SELECT MIN(comp_fecha) FROM BASADOS.compra
) AS fechas),
@MaxDate DATE = (SELECT MAX(max_fecha) FROM (
    SELECT MAX(ped_fecha) AS max_fecha FROM BASADOS.pedido
    UNION ALL
    SELECT MAX(fact_fecha) FROM BASADOS.factura
    UNION ALL
    SELECT MAX(comp_fecha) FROM BASADOS.compra
) AS fechas);

-- CTE para generar calendario
;WITH dias AS (
    SELECT @MinDate AS fecha
    UNION ALL
    SELECT DATEADD(DAY, 1, fecha)
    FROM dias
    WHERE fecha < @MaxDate
)
INSERT INTO BASADOS.BI_Dim_Tiempo (fecha, anio, cuatrimestre, mes)
SELECT 
    fecha,
    YEAR(fecha),
    ((MONTH(fecha) - 1)/4) + 1,
    MONTH(fecha)
FROM dias
OPTION (MAXRECURSION 0);
-----------------------------
---- DIMENSION UBICACION-----
-----------------------------
CREATE TABLE BASADOS.BI_Dim_Ubicacion (
    -- direccion_id NVARCHAR(255), sacar y reemplazar por
    ubicacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    local_nombre NVARCHAR(255),
    prov_nombre NVARCHAR(255)
);

-- ALTER TABLE BASADOS.BI_Dim_Ubicacion
-- ADD CONSTRAINT PK_Dim_Ubicacion 
-- PRIMARY KEY (direccion_id,local_nombre,prov_nombre);

-- INSERT INTO BASADOS.BI_Dim_Ubicacion (direccion_id,local_nombre, prov_nombre)
--     SELECT distinct clie_direccion, local_nombre, prov_nombre from BASADOS.cliente
--                                     join BASADOS.localidad on clie_localidad = local_id
--                                     join BASADOS.provincia on prov_id = local_provincia
--     UNION
--     SELECT distinct suc_direccion, local_nombre, prov_nombre from BASADOS.sucursal
--                                     join BASADOS.localidad on suc_localidad = local_id
--                                     join BASADOS.provincia on prov_id = local_provincia
--     UNION
--     SELECT distinct prov_direccion, local_nombre, prov_nombre from BASADOS.proveedor
--                                     join BASADOS.localidad on prov_localidad = local_id
--                                     join BASADOS.provincia on prov_id = local_provincia
-- podriamos reemplazarlo por esto?
INSERT INTO BASADOS.BI_Dim_Ubicacion (prov_nombre, local_nombre)
SELECT DISTINCT 
    prov.prov_nombre, 
    loc.local_nombre
FROM BASADOS.localidad loc
JOIN BASADOS.provincia prov ON loc.local_provincia = prov.prov_id;

/**********************************************************************
DIMENSIÓN RANGO ETARIO CLIENTES
**********************************************************************/
CREATE TABLE BASADOS.BI_Dim_RangoEtario
(
     rango_id     TINYINT     PRIMARY KEY,
     descripcion  NVARCHAR(20),
     edad_min     TINYINT,        -- inclusive
     edad_max     TINYINT         -- inclusive, NULL = sin tope
);

INSERT BASADOS.BI_Dim_RangoEtario (rango_id, descripcion, edad_min, edad_max)
VALUES (1, '<25',     0,   24),
       (2, '25-35',   25,  35),
       (3, '35-50',   36,  50),
       (4, '>50',     51,  200);

/**********************************************************************
DIMENSIÓN TURNO DE VENTA
**********************************************************************/
CREATE TABLE BASADOS.BI_Dim_Turno
(
     turno_id     TINYINT      PRIMARY KEY,
     descripcion  NVARCHAR(20),
     hora_desde   TIME,
     hora_hasta   TIME
);

INSERT BASADOS.BI_Dim_Turno (turno_id, descripcion, hora_desde, hora_hasta)
VALUES (1, '08:00-14:00', '08:00', '14:00'),
       (2, '14:00-20:00', '14:00', '20:00');
------------------------------------
---- DIMENSION TIPO DE MATERIAL ----
------------------------------------
CREATE TABLE BASADOS.BI_Dim_TipoMaterial (
    tipo_id     BIGINT PRIMARY KEY,
    tipo_nombre NVARCHAR(255)
);

INSERT INTO BASADOS.BI_Dim_TipoMaterial (tipo_id, tipo_nombre)
SELECT tipo_id, tipo_nombre
FROM BASADOS.tipo_material;

------------------------------------
---- DIMENSION MODELO DE SILLON ----
------------------------------------
CREATE TABLE BASADOS.BI_Dim_Modelo (
    modelo_id           BIGINT IDENTITY(1,1) PRIMARY KEY,
    modelo_codigo       BIGINT,
    medida_ancho        decimal(18,2),
    medida_alto         decimal(18,2),
    medida_profundidad  decimal(18,2),
    modelo              NVARCHAR(255),
    descripcion         NVARCHAR(255)
);

INSERT INTO BASADOS.BI_Dim_Modelo (modelo_codigo,
    medida_ancho, medida_alto, medida_profundidad,
    modelo, descripcion)
SELECT
    distinct
    mod_codigo,
    med_ancho,
    med_alto,
    med_profundidad,
    mod_modelo,
    mod_descripcion
FROM BASADOS.sillon join BASADOS.modelo
on sill_modelo=mod_codigo join BASADOS.medida on sill_medida_alto=med_alto and
sill_medida_ancho=med_ancho and
sill_medida_profundidad=med_profundidad

------------------------------------
---- DIMENSION ESTADO DE PEDIDO (A CHEQUEAR!!!)----!!
------------------------------------
CREATE TABLE BASADOS.BI_Dim_EstadoPedido (
   estado_id TINYINT IDENTITY(1,1) PRIMARY KEY,
   ped_estado NVARCHAR(255)
);

INSERT INTO BASADOS.BI_Dim_EstadoPedido (ped_estado)
SELECT distinct
    ped_estado
FROM BASADOS.pedido;
------------------------------------
---- DIMENSION SUCURSAL ----
------------------------------------
CREATE TABLE BASADOS.BI_Dim_Sucursal (
    suc_id INT IDENTITY(1,1) PRIMARY KEY,
    suc_numero BIGINT
);

INSERT INTO BASADOS.BI_Dim_Sucursal (suc_numero)
SELECT 
    suc_numero
FROM BASADOS.sucursal;