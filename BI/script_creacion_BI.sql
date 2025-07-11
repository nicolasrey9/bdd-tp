USE GD1C2025;
GO
--------------------------------------------------------------------------------------DIMENSIONES:
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
---- DIMENSION UBICACION CLIENTE-----
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


--------------------------------------------------------------------------------------TABLAS HECHOS:
CREATE table BASADOS.BI_Hecho_Compra (
    tipo_id BIGINT NOT NULL,
    tiempo_id INT NOT NULL,
    suc_id INT NOT NULL,

    valor_total_compras decimal(18,2),
    valor_promedio_compras decimal(18,2)
)


ALTER TABLE BASADOS.BI_Hecho_Compra
ADD CONSTRAINT PK_Hecho_Compra
PRIMARY KEY (tipo_id, tiempo_id, suc_id);

-----

alter TABLE BASADOS.BI_Hecho_Compra
ADD CONSTRAINT FK_Hecho_Compra_Tipo
FOREIGN KEY (tipo_id)
REFERENCES BASADOS.BI_Dim_TipoMaterial(tipo_id)

alter TABLE BASADOS.BI_Hecho_Compra
ADD CONSTRAINT FK_Hecho_Compra_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Compra
add CONSTRAINT FK_Hecho_Compra_Sucursal FOREIGN KEY (suc_id) 
REFERENCES BASADOS.BI_Dim_Sucursal(suc_id)

CREATE table BASADOS.BI_Hecho_Envio (
    tiempo_id INT not null,
    ubicacion_id BIGINT not null,

    porcentaje_cumplimiento_envios DECIMAL(5,2),
    valor_promedio_envios decimal(18,2)
)

ALTER TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT PK_Hecho_Envio
PRIMARY KEY (tiempo_id, ubicacion_id);

-----

alter TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT FK_Hecho_Envio_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Envio
ADD CONSTRAINT FK_Hecho_Envio_Ubicacion
FOREIGN KEY (ubicacion_id)
REFERENCES BASADOS.BI_Dim_Ubicacion_Cliente(ubicacion_id)

CREATE TABLE BASADOS.BI_Hecho_Pedido (
    turno_id TINYINT NOT NULL,
    suc_id INT NOT NULL,
    tiempo_id INT NOT NULL,
    estado_id TINYINT NOT NULL,

    cantidad_pedidos BIGINT
);


ALTER TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT PK_Hecho_Pedido
PRIMARY KEY (turno_id, suc_id, tiempo_id, estado_id);

-----

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Turno
FOREIGN KEY (turno_id)
REFERENCES BASADOS.BI_Dim_Turno(turno_id)

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Sucursal
FOREIGN KEY (suc_id)
REFERENCES BASADOS.BI_Dim_Sucursal(suc_id)

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Tiempo
FOREIGN KEY (tiempo_id)
REFERENCES BASADOS.BI_Dim_Tiempo(tiempo_id)

alter TABLE BASADOS.BI_Hecho_Pedido
ADD CONSTRAINT FK_Hecho_Pedido_Estato
FOREIGN KEY (estado_id)
REFERENCES BASADOS.BI_Dim_EstadoPedido(estado_id)

CREATE table BASADOS.BI_Hecho_Venta (
    suc_id INT not null,
    tiempo_id INT not null,
    rango_id TINYINT not null,
    ubicacion_id BIGINT not null,
    modelo_id BIGINT not null,

    tiempo_promedio_fabricacion_en_dias INT,
    valor_promedio_ventas DECIMAL(18,2),
    valor_total_ventas DECIMAL(18,2)
)


ALTER TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT PK_Hecho_Venta
PRIMARY KEY (suc_id, tiempo_id, rango_id, 
    ubicacion_id, modelo_id);

-----

alter TABLE BASADOS.BI_Hecho_Venta
add CONSTRAINT FK_Hecho_Venta_Sucursal FOREIGN KEY (suc_id) 
REFERENCES BASADOS.BI_Dim_Sucursal(suc_id)

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
REFERENCES BASADOS.BI_Dim_Ubicacion_Cliente(ubicacion_id)

alter TABLE BASADOS.BI_Hecho_Venta
ADD CONSTRAINT FK_Hecho_Venta_Modelo
FOREIGN KEY (modelo_id)
REFERENCES BASADOS.BI_Dim_Modelo(modelo_id)
--------------------------------------------------------------------------------------MIGRACION
/*
@@@@@ HECHO PEDIDO @@@@@
*/
insert into BASADOS.BI_Hecho_Pedido(
    turno_id, 
    suc_id, 
    tiempo_id, 
    estado_id,
    cantidad_pedidos)
select 
    turno.turno_id,
    sucursal.suc_id, 
    tiempo.tiempo_id, 
    estado.estado_id,
    (select count(distinct ped_numero)) 'Cantidad Pedidos'

from BASADOS.pedido p 

left join BASADOS.BI_Dim_Turno turno 
ON CAST(p.ped_fecha AS TIME) >= turno.hora_desde 
AND (
    CAST(p.ped_fecha AS TIME) < turno.hora_hasta
    OR (turno.hora_hasta = '20:00' AND CAST(p.ped_fecha AS TIME) = '20:00')
    )

join BASADOS.sucursal sucursalBasados on p.ped_sucursal=sucursalBasados.suc_numero
join BASADOS.localidad localidadBasados on sucursalBasados.suc_localidad=localidadBasados.local_id
join BASADOS.provincia provinciaBasados on provinciaBasados.prov_id=localidadBasados.local_provincia
join BASADOS.BI_Dim_Sucursal sucursal on sucursal.localidad = localidadBasados.local_nombre
and sucursal.provincia = provinciaBasados.prov_nombre

join BASADOS.BI_Dim_Tiempo tiempo on   
                        year(p.ped_fecha) = tiempo.anio and MONTH(p.ped_fecha) = tiempo.mes

join BASADOS.BI_Dim_EstadoPedido estado on
                        estado.ped_estado = p.ped_estado

group by turno.turno_id,
    sucursal.suc_id, 
    tiempo.tiempo_id, 
    estado.estado_id
GO

/*
@@@@@ HECHO COMPRA @@@@@
*/
insert into BASADOS.BI_Hecho_Compra(
    tipo_id, tiempo_id, suc_id, 
    
    valor_total_compras, valor_promedio_compras
)

select BI_Dim_TipoMaterial.tipo_id, BI_Dim_Tiempo.tiempo_id, sucursal.suc_id, 
    sum(det_precio_unitario * det_cantidad) valor_total_compras, 
    avg(det_precio_unitario * det_cantidad) valor_promedio_compras

from BASADOS.compra 

join BASADOS.detalle_compra on det_compra=comp_numero

join BASADOS.material on mat_id=det_material 

join BASADOS.tipo_material tipoMaterial
on tipo_id=mat_tipo 

join BASADOS.BI_Dim_TipoMaterial BI_Dim_TipoMaterial 
on tipoMaterial.tipo_nombre=BI_Dim_TipoMaterial.tipo_nombre
and BI_Dim_TipoMaterial.tipo_descripcion=mat_descripcion

join BASADOS.BI_Dim_Tiempo BI_Dim_Tiempo on
        year(comp_fecha) = BI_Dim_Tiempo.anio and MONTH(comp_fecha) = BI_Dim_Tiempo.mes


join BASADOS.sucursal sucursalBasados on comp_sucursal=sucursalBasados.suc_numero
join BASADOS.localidad localidadBasados on sucursalBasados.suc_localidad=localidadBasados.local_id
join BASADOS.provincia provinciaBasados on provinciaBasados.prov_id=localidadBasados.local_provincia
join BASADOS.BI_Dim_Sucursal sucursal on sucursal.localidad = localidadBasados.local_nombre
and sucursal.provincia = provinciaBasados.prov_nombre


group by BI_Dim_TipoMaterial.tipo_id, BI_Dim_Tiempo.tiempo_id, sucursal.suc_id
GO
/*
@@@@@ HECHO ENVIO @@@@@
*/
insert into BASADOS.BI_Hecho_Envio(
    tiempo_id,
    ubicacion_id,

    porcentaje_cumplimiento_envios,
    valor_promedio_envios
)
select BI_Dim_Tiempo.tiempo_id, BI_Dim_Ubicacion_Cliente.ubicacion_id,

SUM(CASE WHEN env_fecha <= env_fecha_programada THEN 1 ELSE 0 END)
    * 100.0 / COUNT(*) AS porcentaje_cumplimiento_envios,

avg(env_importe_subida+env_importe_traslado) valor_promedio_envios
    
from BASADOS.envio
join BASADOS.BI_Dim_Tiempo BI_Dim_Tiempo on
    year(env_fecha) = BI_Dim_Tiempo.anio and MONTH(env_fecha) = BI_Dim_Tiempo.mes

join BASADOS.factura on fact_numero=env_factura
join BASADOS.cliente on fact_cliente=clie_id
join BASADOS.localidad localidad on localidad.local_id=clie_localidad
join BASADOS.provincia provincia on provincia.prov_id=localidad.local_provincia
join BASADOS.BI_Dim_Ubicacion_Cliente BI_Dim_Ubicacion_Cliente 
            on localidad.local_nombre = BI_Dim_Ubicacion_Cliente.local_nombre and provincia.prov_nombre = BI_Dim_Ubicacion_Cliente.prov_nombre

group by BI_Dim_Tiempo.tiempo_id, BI_Dim_Ubicacion_Cliente.ubicacion_id
GO
/*
@@@@@ HECHO VENTA @@@@@
*/
insert into BASADOS.BI_Hecho_Venta(
    suc_id, 
    tiempo_id,
    rango_id, 
    ubicacion_id,
    modelo_id,

    tiempo_promedio_fabricacion_en_dias, 
    valor_promedio_ventas, 
    valor_total_ventas
)
select BI_Dim_Sucursal.suc_id, 
    BI_Dim_Tiempo.tiempo_id, 
    BI_Dim_RangoEtario.rango_id, 
    BI_Dim_Ubicacion_Cliente.ubicacion_id,
    BI_Dim_Modelo.modelo_id,

    avg(DATEDIFF(DAY,ped.ped_fecha,fact_fecha)) tiempo_promedio_fabricacion_en_dias,
    avg(detfact.det_precio_unitario*detfact.det_cantidad) valor_promedio_ventas,
    sum(detfact.det_precio_unitario*detfact.det_cantidad) valor_total_ventas
    
from BASADOS.factura 

join BASADOS.detalle_factura detfact
on detfact.det_factura=fact_numero 

join BASADOS.detalle_pedido detpedido
on detfact.det_numero=detpedido.det_numero and 
detfact.det_pedido=detpedido.det_pedido

join BASADOS.pedido ped on detpedido.det_pedido = ped.ped_numero

join BASADOS.sillon on detpedido.det_sillon=sill_codigo

join BASADOS.BI_Dim_Tiempo BI_Dim_Tiempo on
        year(fact_fecha) = BI_Dim_Tiempo.anio and MONTH(fact_fecha) = BI_Dim_Tiempo.mes

join BASADOS.cliente on clie_id=fact_cliente

join BASADOS.BI_Dim_RangoEtario BI_Dim_RangoEtario on
(
  DATEDIFF(YEAR, clie_fecha_nac, fact_fecha) 
  - CASE 
      WHEN MONTH(fact_fecha) < MONTH(clie_fecha_nac)
        OR (MONTH(fact_fecha) = MONTH(clie_fecha_nac) AND DAY(fact_fecha) < DAY(clie_fecha_nac))
      THEN 1 
      ELSE 0 
    END
) between BI_Dim_RangoEtario.edad_min and BI_Dim_RangoEtario.edad_max

join BASADOS.sucursal on fact_sucursal=sucursal.suc_numero

join BASADOS.localidad loca on sucursal.suc_localidad=loca.local_id

join BASADOS.provincia prov on prov.prov_id=loca.local_provincia

join BASADOS.BI_Dim_Sucursal BI_Dim_Sucursal on
BI_Dim_Sucursal.localidad = loca.local_nombre and BI_Dim_Sucursal.provincia = prov.prov_nombre

join BASADOS.localidad loca1 on clie_localidad = loca1.local_id

join BASADOS.provincia prov1 on prov1.prov_id = loca1.local_provincia

join BASADOS.BI_Dim_Ubicacion_Cliente BI_Dim_Ubicacion_Cliente on BI_Dim_Ubicacion_Cliente.prov_nombre=prov1.prov_nombre
and BI_Dim_Ubicacion_Cliente.local_nombre = loca1.local_nombre

join BASADOS.modelo on sill_modelo = mod_codigo

join BASADOS.BI_Dim_Modelo BI_Dim_Modelo on BI_Dim_Modelo.modelo=mod_modelo
and mod_descripcion=BI_Dim_Modelo.descripcion

group by BI_Dim_Sucursal.suc_id, 
    BI_Dim_Tiempo.tiempo_id, 
    BI_Dim_RangoEtario.rango_id, 
    BI_Dim_Ubicacion_Cliente.ubicacion_id,
    BI_Dim_Modelo.modelo_id
GO

--------------------------------------------------------------------------------------VISTAS:
CREATE VIEW BASADOS.BI_Vista_Ganancias AS
SELECT 
    t.anio, 
    t.mes, 
    v.suc_id,
    (SUM(v.valor_total_ventas) - 
        (SELECT ISNULL(SUM(c.valor_total_compras), 0) 
         FROM BASADOS.BI_Hecho_Compra c
         JOIN BASADOS.BI_Dim_Tiempo t2 ON t2.tiempo_id = c.tiempo_id
         WHERE t2.anio = t.anio AND t2.mes = t.mes AND c.suc_id = v.suc_id)
    ) AS ganancias
FROM BASADOS.BI_Hecho_Venta v
JOIN BASADOS.BI_Dim_Tiempo t ON t.tiempo_id = v.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON s.suc_id = v.suc_id
GROUP BY t.anio, t.mes, v.suc_id
GO

CREATE VIEW BASADOS.BI_Vista_Factura_Promedio_Mensual AS
SELECT
    t.anio,
    t.mes,
    s.provincia,
    avg(v.valor_promedio_ventas) valor_promedio_facturas
FROM BASADOS.BI_Hecho_Venta v
JOIN BASADOS.BI_Dim_Tiempo t ON v.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON v.suc_id = s.suc_id
GROUP BY s.provincia, t.anio, t.mes
GO

CREATE VIEW BASADOS.BI_Vista_Rendimiento_Modelos AS
WITH VentasRankeadas AS (
    SELECT
        modelo.modelo_id,
        modelo.modelo,
        modelo.descripcion AS modelo_descripcion,
        tiempo.anio,
        tiempo.cuatrimestre,
        sucursal.localidad AS sucursal_localidad,
        rango.descripcion AS rango_etario,
        SUM(venta.valor_total_ventas) AS total_ventas,
        ROW_NUMBER() OVER (
            PARTITION BY tiempo.anio, tiempo.cuatrimestre, sucursal.localidad, rango.rango_id
            ORDER BY SUM(venta.valor_total_ventas) DESC
        ) AS ranking
    FROM BASADOS.BI_Hecho_Venta venta
    JOIN BASADOS.BI_Dim_Modelo modelo ON modelo.modelo_id = venta.modelo_id
    JOIN BASADOS.BI_Dim_RangoEtario rango ON rango.rango_id = venta.rango_id
    JOIN BASADOS.BI_Dim_Tiempo tiempo ON tiempo.tiempo_id = venta.tiempo_id
    JOIN BASADOS.BI_Dim_Sucursal sucursal ON sucursal.suc_id = venta.suc_id
    GROUP BY 
        modelo.modelo_id,
        modelo.modelo,
        modelo.descripcion,
        tiempo.anio,
        tiempo.cuatrimestre,
        sucursal.localidad,
        rango.rango_id,
        rango.descripcion
)
SELECT 
    anio,
    cuatrimestre,
    sucursal_localidad,
    rango_etario,
    --modelo_id,
    modelo,
    total_ventas,
    ranking
FROM VentasRankeadas
WHERE ranking <= 3

GO
CREATE VIEW BASADOS.BI_Vista_Volumen_Pedidos AS
SELECT 
    t.anio,
    t.mes,
    s.suc_id,
    tu.descripcion AS turno,
    SUM(p.cantidad_pedidos) AS total_pedidos
FROM BASADOS.BI_Hecho_Pedido p
JOIN BASADOS.BI_Dim_Tiempo t ON p.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON p.suc_id = s.suc_id
JOIN BASADOS.BI_Dim_Turno tu ON p.turno_id = tu.turno_id
GROUP BY t.anio, t.mes, s.suc_id, tu.turno_id, tu.descripcion;
GO

--Vista 5!!!!
CREATE VIEW BASADOS.BI_Vista_Conversion_Pedidos AS
SELECT 
    t.anio,
    t.cuatrimestre,
    p.suc_id,
    e.ped_estado,
    SUM(p.cantidad_pedidos) AS total_pedidos,
    (SUM(p.cantidad_pedidos) * 100.0 / 
        (select sum(p2.cantidad_pedidos) from BASADOS.BI_Hecho_Pedido p2 join
        BASADOS.BI_Dim_Tiempo t2 on p2.tiempo_id=t2.tiempo_id
        where t2.cuatrimestre=t.cuatrimestre and t2.anio=t.anio
        and p2.suc_id=p.suc_id)
    ) AS porcentaje_conversion
FROM BASADOS.BI_Hecho_Pedido p
JOIN BASADOS.BI_Dim_Tiempo t ON p.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_EstadoPedido e ON p.estado_id = e.estado_id
GROUP BY t.anio, t.cuatrimestre, p.suc_id, e.ped_estado;
GO

CREATE VIEW BASADOS.BI_Vista_Tiempo_Promedio_Fabricacion AS
SELECT 
    t.anio,
    t.cuatrimestre,
    s.suc_id,
    avg(v.tiempo_promedio_fabricacion_en_dias) AS tiempo_promedio_dias
FROM BASADOS.BI_Hecho_Venta v
JOIN BASADOS.BI_Dim_Tiempo t ON v.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON v.suc_id = s.suc_id
GROUP BY t.anio, t.cuatrimestre, s.suc_id

GO
--7. Promedio de Compras: importe promedio de compras por mes.
CREATE VIEW BASADOS.BI_Vista_Promedio_Compras_Por_Mes AS
SELECT 
    t.anio,
    t.mes,
    AVG(c.valor_promedio_compras) AS promedio_compras
FROM BASADOS.BI_Hecho_Compra c
JOIN BASADOS.BI_Dim_Tiempo t ON c.tiempo_id = t.tiempo_id
GROUP BY t.anio, t.mes;

GO
CREATE VIEW BASADOS.BI_Vista_Compras_Por_Tipo_Material AS
SELECT 
    t.cuatrimestre,
    tm.tipo_nombre AS material,
    s.suc_id,
    SUM(c.valor_total_compras) AS importe_total_gastado
FROM BASADOS.BI_Hecho_Compra c
JOIN BASADOS.BI_Dim_TipoMaterial tm ON c.tipo_id = tm.tipo_id
JOIN BASADOS.BI_Dim_Tiempo t ON c.tiempo_id = t.tiempo_id
JOIN BASADOS.BI_Dim_Sucursal s ON c.suc_id = s.suc_id
GROUP BY 
t.cuatrimestre, 
tm.tipo_nombre, 
s.suc_id
GO

CREATE VIEW BASADOS.BI_Vista_Cumplimiento_Envios_Por_Mes AS
SELECT 
    t.anio,
    t.mes,
    AVG(e.porcentaje_cumplimiento_envios) AS porcentaje_cumplimiento_promedio
FROM BASADOS.BI_Hecho_Envio e
JOIN BASADOS.BI_Dim_Tiempo t ON e.tiempo_id = t.tiempo_id
GROUP BY t.anio, t.mes;
go

CREATE VIEW BASADOS.BI_Vista_Top3_Localidades_Mayor_Costo_Envio AS
SELECT TOP 3 
    u.local_nombre AS localidad,
    u.prov_nombre AS provincia,
    AVG(e.valor_promedio_envios) AS promedio_costo_envio
FROM BASADOS.BI_Hecho_Envio e
JOIN BASADOS.BI_Dim_Ubicacion_Cliente u ON e.ubicacion_id = u.ubicacion_id
GROUP BY u.local_nombre, u.prov_nombre
ORDER BY AVG(e.valor_promedio_envios) DESC;
go