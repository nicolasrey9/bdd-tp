USE GD1C2025;
GO
-------------------------------------------------------------------------------------------------DIMENSIONES:

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

-------------------------------------------------------------------------------------------TABLAS HECHOS:
CREATE table BASADOS.BI_Hecho_Compra (
    compra_numero decimal(18,0) NOT NULL, 
    tipo_id BIGINT NOT NULL,
    tiempo_id INT,
    suc_id INT,
    compra_valor decimal(18,2),
)


ALTER TABLE BASADOS.BI_Hecho_Compra
ADD CONSTRAINT PK_Hecho_Compra
PRIMARY KEY (compra_numero, tipo_id);

-----

alter TABLE BASADOS.BI_Hecho_Compra
add CONSTRAINT FK_Hecho_Compra_Sucursal FOREIGN KEY (suc_id) 
REFERENCES BASADOS.BI_Dim_Sucursal(suc_id)

alter TABLE BASADOS.BI_Hecho_Compra
ADD CONSTRAINT FK_Hecho_Compra_Tipo
FOREIGN KEY (tipo_id)
REFERENCES BASADOS.BI_Dim_TipoMaterial(tipo_id)

alter TABLE BASADOS.BI_Hecho_Compra
ADD CONSTRAINT FK_Hecho_Compra_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

CREATE table BASADOS.BI_Hecho_Envio (
    envio_numero decimal(18,0) not null,
    tiempo_id INT,
    ubicacion_id BIGINT,
    costo_envio decimal(18,2),
    fecha_programada DATE
)

ALTER TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT PK_Hecho_Envio
PRIMARY KEY (envio_numero);

-----

alter TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT FK_Hecho_Envio_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT FK_Hecho_Envio_Ubicacion
FOREIGN KEY (ubicacion_id)
REFERENCES BASADOS.BI_Dim_Ubicacion(ubicacion_id)

CREATE TABLE BASADOS.BI_Hecho_Pedido (
    pedido_numero DECIMAL(18,0) PRIMARY KEY,
    turno_id TINYINT,
    suc_id INT,
    tiempo_id INT,
    estado_id TINYINT,
    
    CONSTRAINT FK_Turno FOREIGN KEY (turno_id) REFERENCES BASADOS.BI_Dim_Turno(turno_id),
    CONSTRAINT FK_Sucursal FOREIGN KEY (suc_id) REFERENCES BASADOS.BI_Dim_Sucursal(suc_id),
    CONSTRAINT FK_Tiempo FOREIGN KEY (tiempo_id) REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id),
    CONSTRAINT FK_Estado FOREIGN KEY (estado_id) REFERENCES BASADOS.BI_Dim_EstadoPedido(estado_id)
);

CREATE table BASADOS.BI_Hecho_Venta (
    venta_numero BIGINT not null,
    sillon_codigo BIGINT not null,
    modelo_id BIGINT not null,
    suc_id INT,
    tiempo_id INT,
    rango_id TINYINT,
    ubicacion_id BIGINT,
    venta_valor decimal(18,2),
    pedido_numero DECIMAL(18,0)
)


ALTER TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT PK_Hecho_Venta
PRIMARY KEY (venta_numero, modelo_id, sillon_codigo);

-----

alter TABLE BASADOS.BI_Hecho_Venta
add CONSTRAINT FK_Hecho_Venta_Sucursal FOREIGN KEY (suc_id) 
REFERENCES BASADOS.BI_Dim_Sucursal(suc_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Modelo
FOREIGN KEY (modelo_id)
REFERENCES BASADOS.BI_Dim_Modelo(modelo_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Rango
FOREIGN KEY (rango_id)
REFERENCES BASADOS.BI_Dim_RangoEtario(rango_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Ubicacion
FOREIGN KEY (ubicacion_id)
REFERENCES BASADOS.BI_Dim_Ubicacion(ubicacion_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Pedido
FOREIGN KEY (pedido_numero)
REFERENCES BASADOS.BI_Hecho_Pedido(pedido_numero)

--------------------------------------------------------------------------------------MIGRACION
/*
@@@@@ HECHO COMPRA @@@@@
*/
insert into BASADOS.BI_Hecho_Compra(
    compra_numero, tipo_id, tiempo_id, suc_id, compra_valor
)
select comp_numero, BItipoMaterial.tipo_id, 
    tiempo.tiempo_id, sucu.suc_id, det_precio_unitario*det_cantidad
from BASADOS.compra join BASADOS.detalle_compra on det_compra=comp_numero
join BASADOS.material on mat_id=det_material join BASADOS.tipo_material tipoMaterial
on tipo_id=mat_tipo join BASADOS.BI_Dim_TipoMaterial BItipoMaterial 
on tipoMaterial.tipo_nombre=BItipoMaterial.tipo_nombre
and BItipoMaterial.tipo_descripcion=mat_descripcion
join BASADOS.BI_Dim_Tiempo tiempo on
CAST(comp_fecha AS DATE) = tiempo.fecha
join BASADOS.BI_Dim_Sucursal sucu on
sucu.suc_numero = comp_sucursal

/*
@@@@@ HECHO ENVIO @@@@@
*/
insert into BASADOS.BI_Hecho_Envio(
    envio_numero,
    tiempo_id,
    ubicacion_id,
    costo_envio,
    fecha_programada
)
select env_numero, tiempo.tiempo_id, BI_Ubicacion.ubicacion_id,
    env_importe_subida+env_importe_traslado, CAST(env_fecha_programada as date)
from BASADOS.envio
join BASADOS.BI_Dim_Tiempo tiempo on
CAST(env_fecha AS DATE) = tiempo.fecha
join BASADOS.factura on fact_numero=env_factura
join BASADOS.sucursal sucursal on sucursal.suc_numero=fact_sucursal
join BASADOS.localidad localidad on localidad.local_id=sucursal.suc_localidad
join BASADOS.provincia provincia on provincia.prov_id=localidad.local_provincia
join BASADOS.BI_Dim_Ubicacion BI_Ubicacion 
on BI_Ubicacion.local_nombre=localidad.local_nombre
and BI_Ubicacion.prov_nombre=provincia.prov_nombre 
/*
@@@@@ HECHO PEDIDO @@@@@
*/
insert into BASADOS.BI_Hecho_Pedido(
    pedido_numero, turno_id, 
    suc_id, tiempo_id, estado_id)
select 
    p.ped_numero, 
    turno.turno_id,
    sucursal.suc_id, 
    tiempo.tiempo_id, 
    estado.estado_id
from BASADOS.pedido p left join BASADOS.BI_Dim_Turno turno 
ON CAST(p.ped_fecha AS TIME) >= turno.hora_desde 
AND (
    CAST(p.ped_fecha AS TIME) < turno.hora_hasta
    OR (turno.hora_hasta = '20:00' AND CAST(p.ped_fecha AS TIME) = '20:00')
    )
join BASADOS.BI_Dim_Sucursal sucursal on
sucursal.suc_numero = p.ped_sucursal
join BASADOS.BI_Dim_Tiempo tiempo on
CAST(p.ped_fecha AS DATE) = tiempo.fecha
join BASADOS.BI_Dim_EstadoPedido estado
on estado.ped_estado = p.ped_estado


/*
@@@@@ HECHO VENTA @@@@@
*/
insert into BASADOS.BI_Hecho_Venta(
    venta_numero, sillon_codigo,modelo_id, suc_id, tiempo_id,
    rango_id, ubicacion_id, venta_valor, pedido_numero
)
select fact_numero, sill_codigo, mod.modelo_id, sucu.suc_id, 
    tiempo.tiempo_id, rango.rango_id, ubi.ubicacion_id, 
    detfact.det_precio_unitario * detfact.det_cantidad, detpedido.det_pedido
from BASADOS.factura join BASADOS.detalle_factura detfact
on det_factura=fact_numero join BASADOS.detalle_pedido detpedido
on detfact.det_numero=detpedido.det_numero and 
detfact.det_pedido=detpedido.det_pedido
join BASADOS.sillon on detpedido.det_sillon=sill_codigo
join BASADOS.BI_Dim_Sucursal sucu on
sucu.suc_numero = fact_sucursal
join BASADOS.BI_Dim_Tiempo tiempo on
CAST(fact_fecha AS DATE) = tiempo.fecha
join BASADOS.cliente on clie_id=fact_cliente
join BASADOS.BI_Dim_RangoEtario rango on
(
  DATEDIFF(YEAR, clie_fecha_nac, fact_fecha) 
  - CASE 
      WHEN MONTH(fact_fecha) < MONTH(clie_fecha_nac)
        OR (MONTH(fact_fecha) = MONTH(clie_fecha_nac) AND DAY(fact_fecha) < DAY(clie_fecha_nac))
      THEN 1 
      ELSE 0 
    END
) between rango.edad_min and rango.edad_max
join BASADOS.sucursal on fact_sucursal=sucursal.suc_numero
join BASADOS.localidad on sucursal.suc_localidad=localidad.local_id
join BASADOS.provincia on provincia.prov_id=localidad.local_provincia
join BASADOS.BI_Dim_Ubicacion ubi on ubi.prov_nombre=provincia.prov_nombre
and ubi.local_nombre = localidad.local_nombre
join BASADOS.BI_Dim_Modelo mod on mod.modelo_codigo=sill_modelo
and sill_medida_ancho=medida_ancho
and sill_medida_alto=medida_alto
and sill_medida_profundidad=medida_profundidad
join BASADOS.medida on sill_medida_ancho=med_ancho
and sill_medida_alto=med_alto
and sill_medida_profundidad=med_profundidad
GO
--------------------------------------------------------------------------------------VISTAS:
-- 1. Ganancias: Total de ingresos (facturación) - total de egresos (compras), por
-- cada mes, por cada sucursal.

CREATE VIEW BASADOS.BI_Ganancias AS
select 
anio, 
mes, 
suc_numero NumeroSucursal, 

(isnull(sum(venta_valor),0) - 
    (select isnull(sum(compra_valor),0) 
        from BASADOS.BI_Hecho_Compra c
        join BASADOS.BI_Dim_Tiempo t2 on t2.tiempo_id = c.tiempo_id
        where t2.anio = t.anio and t2.mes = t.mes and c.suc_id = v.suc_id)) Ganancias
    
    from BASADOS.BI_Hecho_Venta v
    join BASADOS.BI_Dim_Tiempo t on t.tiempo_id = v.tiempo_id
    join BASADOS.BI_Dim_Sucursal s on s.suc_id = v.suc_id
    
    group by anio, mes, suc_numero,v.suc_id
GO
/*2. Factura promedio mensual. Valor promedio de las facturas (en $) según la
provincia de la sucursal para cada cuatrimestre de cada año. Se calcula en
función de la sumatoria del importe de las facturas sobre el total de las mismas
durante dicho período.*/
CREATE VIEW BASADOS.BI_FACTURA_PROMEDIO_MENSUAL AS
SELECT
    temp.anio Anio,
    temp.cuatrimestre Cuatrimestre,
    ubi.prov_nombre Provincia,
    sum(venta.venta_valor) 
    /
    count(venta.venta_numero) FacturaPromedio

    FROM BASADOS.BI_Hecho_Venta venta
    join BASADOS.BI_Dim_Ubicacion ubi on venta.ubicacion_id = ubi.ubicacion_id
    join BASADOS.BI_Dim_Tiempo temp on venta.tiempo_id = temp.tiempo_id

    GROUP BY ubi.prov_nombre, temp.anio, temp.cuatrimestre
GO
--vista 3
CREATE VIEW BASADOS.BI_TOP_3_MODELOS_MAS_RENDIDORES AS
WITH VentasRankeadas AS (
    SELECT
        modelo.modelo_id,
        modelo.descripcion,
        tiempo.cuatrimestre,
        tiempo.anio,
        ubicacion.local_nombre,
        rango.descripcion AS rango_etario,
        COUNT(*) AS cantidad_ventas,
        ROW_NUMBER() OVER (
            PARTITION BY tiempo.cuatrimestre, tiempo.anio, ubicacion.local_nombre, rango.rango_id
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM BASADOS.BI_Hecho_Venta AS venta
    JOIN BASADOS.BI_Dim_Modelo modelo ON modelo.modelo_id = venta.modelo_id
    JOIN BASADOS.BI_Dim_RangoEtario rango ON rango.rango_id = venta.rango_id
    JOIN BASADOS.BI_Dim_Tiempo tiempo ON tiempo.tiempo_id = venta.tiempo_id
    JOIN BASADOS.BI_Dim_Ubicacion ubicacion ON ubicacion.ubicacion_id = venta.ubicacion_id
    GROUP BY 
        modelo.modelo_id,
        modelo.descripcion,
        tiempo.cuatrimestre,
        tiempo.anio,
        ubicacion.local_nombre,
        rango.rango_id,
        rango.descripcion
)
SELECT 
    modelo_id,
    descripcion,
    cuatrimestre,
    anio,
    local_nombre,
    rango_etario
FROM VentasRankeadas
WHERE rn <= 3;
GO
--Vista 4
CREATE VIEW BASADOS.BI_VOLUMEN_PEDIDOS AS
SELECT 
    t.anio Anio,
    t.mes Mes,
    s.suc_numero NumeroSucursal,
    tu.descripcion Turno,
    COUNT(*) as CantidadPedidos
FROM 
    BASADOS.BI_Hecho_Pedido p
    JOIN BASADOS.BI_Dim_Tiempo t ON p.tiempo_id = t.tiempo_id
    JOIN BASADOS.BI_Dim_Sucursal s ON p.suc_id = s.suc_id
    JOIN BASADOS.BI_Dim_Turno tu ON p.turno_id = tu.turno_id
GROUP BY 
    t.anio, t.mes, s.suc_numero, tu.descripcion
GO
--Vista 5
CREATE VIEW BASADOS.BI_CONVERSION_PEDIDOS AS
SELECT 
    t.anio Anio,
    t.cuatrimestre Cuatrimestre,
    s.suc_numero NumeroSucursal,
    e.ped_estado EstadoPedido,
    COUNT(*) Cantidad,
    (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY t.anio, t.cuatrimestre, s.suc_numero)) PorcentajeDelTotal
FROM 
    BASADOS.BI_Hecho_Pedido p
    JOIN BASADOS.BI_Dim_Tiempo t ON p.tiempo_id = t.tiempo_id
    JOIN BASADOS.BI_Dim_Sucursal s ON p.suc_id = s.suc_id
    JOIN BASADOS.BI_Dim_EstadoPedido e ON p.estado_id = e.estado_id
GROUP BY 
    t.anio, t.cuatrimestre, s.suc_numero, e.ped_estado
GO
--vISTA 6
CREATE VIEW BASADOS.BI_Tiempo_Promedio_Fabricacion AS
SELECT
    t_fact.cuatrimestre,
    s.suc_numero,
    AVG(DATEDIFF(DAY, t_ped.fecha, t_fact.fecha)) AS TiempoPromedioEnDias
FROM BASADOS.BI_Hecho_Venta v
       JOIN BASADOS.BI_Hecho_Pedido p 
              ON v.pedido_numero = p.pedido_numero
JOIN BASADOS.BI_Dim_Tiempo t_ped 
              ON p.tiempo_id = t_ped.tiempo_id
JOIN BASADOS.BI_Dim_Tiempo t_fact 
              ON v.tiempo_id = t_fact.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s 
              ON v.suc_id = s.suc_id
GROUP BY t_fact.cuatrimestre, s.suc_numero
GO
--7. Promedio de Compras: importe promedio de compras por mes.
create view BASADOS.BI_Promedio_Compras_Por_Mes as
select anio Anio, mes Mes, avg(compra_valor) PromedioCompras
from BASADOS.BI_Hecho_Compra c
join BASADOS.BI_Dim_Tiempo t on c.tiempo_id = t.tiempo_id
group by anio, mes
GO
--vista 8
CREATE VIEW BASADOS.BI_Compras_Por_Tipo_Material AS
SELECT 
    t.anio AS Anio,
    t.cuatrimestre AS Cuatrimestre,
    tm.tipo_nombre AS Material,
    suc.suc_numero Sucursal,
    sum(c.compra_valor) AS ImporteGastado
FROM 
    BASADOS.BI_Hecho_Compra c
    JOIN BASADOS.BI_Dim_TipoMaterial tm ON c.tipo_id = tm.tipo_id
    JOIN BASADOS.BI_Dim_Tiempo t ON c.tiempo_id = t.tiempo_id
    join BASADOS.BI_Dim_Sucursal suc on c.suc_id = suc.suc_id
GROUP BY 
    t.anio, 
    t.cuatrimestre, 
    tm.tipo_nombre,
    suc.suc_numero
GO
--9
CREATE VIEW BASADOS.BI_Cumplimiento_Envios_Por_Mes AS
select 

t.anio Anio, 

t.mes Mes,
        
(count(*) * 100 
/             
(select count(*) from BASADOS.BI_Hecho_envio e2 
join BASADOS.BI_Dim_Tiempo t2 on t2.tiempo_id = e2.tiempo_id
where t2.mes = t.mes and t2.anio = t.anio)) PorcentajeCumplimiento

from BASADOS.BI_Hecho_Envio e
join BASADOS.BI_Dim_Tiempo t on e.tiempo_id = t.tiempo_id

where t.fecha = e.fecha_programada

group by t.anio, t.mes
GO
--10
CREATE VIEW BASADOS.BI_Top3_Localidades_Mayor_Costo_Envio AS
SELECT TOP 3 local_nombre NombreLocalidad
FROM BASADOS.BI_Hecho_Envio e
JOIN BASADOS.BI_Dim_Ubicacion u ON e.ubicacion_id = u.ubicacion_id
GROUP BY local_nombre
ORDER BY AVG(costo_envio) DESC;
GO 
