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
!!!!---- DIMENSION LOCALIDAD (A CHEQUEAR!!) ----!!!
-----------------------------
CREATE TABLE BASADOS.BI_Dim_Localidad (
    local_id BIGINT PRIMARY KEY,
    local_provincia BIGINT
);

INSERT INTO BASADOS.BI_Dim_Localidad (local_id, local_provincia)
SELECT 
    loc.local_id,
    loc.local_provincia
FROM BASADOS.localidad loc
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
       (4, '>50',     51,  NULL);

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
    modelo_id      BIGINT PRIMARY KEY,
    modelo         NVARCHAR(255),
    descripcion    NVARCHAR(255),
    precio_base    DECIMAL(18,2)
);

INSERT INTO BASADOS.BI_Dim_Modelo (modelo_id, modelo, descripcion, precio_base)
SELECT 
    mod_codigo,
    mod_modelo,
    mod_descripcion,
    mod_precio_base
FROM BASADOS.modelo;
------------------------------------
!!---- DIMENSION ESTADO DE PEDIDO (A CHEQUEAR!!!)----!!
------------------------------------
CREATE TABLE BASADOS.BI_Dim_Estado_Pedido (
   ped_estado NVARCHAR(255) PRIMARY KEY
);

INSERT INTO BASADOS.BI_Dim_Estado_Pedido (ped_estado)
SELECT 
    ped_estado
FROM BASADOS.pedido;
/**********************************************************************
TABLA DE HECHOS VENTAs
**********************************************************************/
/**********************************************************************
TABLA DE HECHOS COMPRAs
**********************************************************************/
/**********************************************************************
TABLA DE HECHOS PEDIDOs
**********************************************************************/
/**********************************************************************
TABLA DE HECHOS ENVIOs
**********************************************************************/
