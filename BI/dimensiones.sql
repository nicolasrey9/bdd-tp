--------------------------
---- DIMENSION TIEMPO ----
--------------------------
CREATE TABLE BASADOS.BI_Dim_Tiempo (
    tiempo_id      INT IDENTITY(1,1) PRIMARY KEY,
    anio           INT NOT NULL,
    cuatrimestre   TINYINT NOT NULL,
    mes            TINYINT NOT NULL
);

INSERT INTO BASADOS.BI_Dim_Tiempo (anio, cuatrimestre, mes)
SELECT YEAR(ped_fecha), (MONTH(ped_fecha) - 1) / 4 + 1 AS trimestre, MONTH(ped_fecha)
FROM BASADOS.pedido
WHERE ped_fecha IS NOT NULL

UNION

SELECT YEAR(fact_fecha), (MONTH(fact_fecha) - 1) / 4 + 1, MONTH(fact_fecha)
FROM BASADOS.factura
WHERE fact_fecha IS NOT NULL

UNION

SELECT YEAR(comp_fecha), (MONTH(comp_fecha) - 1) / 4 + 1, MONTH(comp_fecha)
FROM BASADOS.compra
WHERE comp_fecha IS NOT NULL

UNION

SELECT YEAR(env_fecha), (MONTH(env_fecha) - 1) / 4 + 1, MONTH(env_fecha)
FROM BASADOS.envio
WHERE env_fecha IS NOT NULL;

-----------------------------
---- DIMENSION UBICACION-----
-----------------------------
CREATE TABLE BASADOS.BI_Dim_Ubicacion_Cliente (
    ubicacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    prov_nombre NVARCHAR(255),
    local_nombre NVARCHAR(255),
);


INSERT INTO BASADOS.BI_Dim_Ubicacion_Cliente (prov_nombre, local_nombre)
SELECT DISTINCT 
    prov.prov_nombre, 
    loc.local_nombre
FROM BASADOS.cliente join
BASADOS.localidad loc on clie_localidad=loc.local_id
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
    tipo_id     BIGINT IDENTITY(1,1) PRIMARY KEY,
    tipo_nombre NVARCHAR(255),
    tipo_descripcion NVARCHAR(255),
);

INSERT INTO BASADOS.BI_Dim_TipoMaterial (
    tipo_nombre, tipo_descripcion
)
SELECT distinct tipo_nombre, mat_descripcion
FROM BASADOS.tipo_material join BASADOS.material
on mat_tipo=tipo_id

------------------------------------
---- DIMENSION MODELO DE SILLON ----
------------------------------------
CREATE TABLE BASADOS.BI_Dim_Modelo (
    modelo_id           BIGINT IDENTITY(1,1) PRIMARY KEY,
    modelo              NVARCHAR(255),
    descripcion         NVARCHAR(255)
);

INSERT INTO BASADOS.BI_Dim_Modelo (modelo, descripcion)
SELECT
    mod_modelo,
    mod_descripcion
from BASADOS.modelo

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
    localidad NVARCHAR(255),
    provincia NVARCHAR(255)
);

INSERT INTO BASADOS.BI_Dim_Sucursal (localidad, provincia)
SELECT
    local_nombre, prov_nombre
FROM BASADOS.sucursal join BASADOS.localidad on suc_localidad=local_id
join BASADOS.provincia on local_provincia=prov_id

