USE [GD1C2024]
GO

-- Crea dimension Rango_Etario
CREATE TABLE REJUNTESA.BI_rango_etario (
    id_rango_etario INT IDENTITY(1,1),
    edad_min INT,
    edad_max INT,
    PRIMARY KEY (id_rango_etario)
);

-- Crea dimension Turno
CREATE TABLE REJUNTESA.BI_turno (
    id_turno INT IDENTITY(1,1),
    inicio_turno INT,
    fin_turno INT,
    PRIMARY KEY (id_turno)
);

-- Crea dimension Ubicacion
CREATE TABLE REJUNTESA.BI_provincia (
    id_provincia INT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_provincia)
);

CREATE TABLE REJUNTESA.BI_ubicacion (
    id_localidad INT,
    nombre NVARCHAR(255),
    id_provincia INT,
    PRIMARY KEY (id_localidad),
    CONSTRAINT [FK_id_provincia_en_BI_ubicacion.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [REJUNTESA].[BI_provincia]([id_provincia])
);

-- Crea dimension Tipo_Caja
CREATE TABLE REJUNTESA.BI_tipo_caja (
    id_tipo_caja INT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_tipo_caja)
);

-- Crea dimension Sucursal
CREATE TABLE REJUNTESA.BI_sucursal (
    id_sucursal INT,
    nombre NVARCHAR(255),
    id_ubicacion INT,
    PRIMARY KEY (id_sucursal),
    CONSTRAINT [FK_id_ubicacion_en_BI_sucursal.id_ubicacion]
    FOREIGN KEY ([id_ubicacion])
      REFERENCES [REJUNTESA].[BI_ubicacion]([id_localidad])
);

-- Crea dimension Categoria/Subcategoria
CREATE TABLE REJUNTESA.BI_categoria (
    id_categoria INT,
    categoria NVARCHAR(255),
    PRIMARY KEY (id_categoria)
);

CREATE TABLE REJUNTESA.BI_subcategoria (
    id_subcategoria INT,
    subcategoria NVARCHAR(255),
    id_categoria INT,
    PRIMARY KEY (id_subcategoria),
    CONSTRAINT [FK_id_categoria_en_BI_subcategoria.id_categoria]
    FOREIGN KEY ([id_categoria])
      REFERENCES [REJUNTESA].[BI_categoria]([id_categoria])
);

-- Crea dimension Producto
CREATE TABLE REJUNTESA.BI_producto (
    id_producto INT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_producto)
);

-- Crea dimension Tiempo
CREATE TABLE REJUNTESA.BI_tiempo (
    id_tiempo INT IDENTITY(1,1),
    mes INT,
    cuatrimestre INT,
    anio INT,
    PRIMARY KEY (id_tiempo)
);

-- Crea dimension Medio_Pago
CREATE TABLE REJUNTESA.BI_medio_pago (
    id_medio_pago INT,
    nombre NVARCHAR(255),
    PRIMARY KEY (id_medio_pago)
);

-- Crea tabla Venta
CREATE TABLE REJUNTESA.BI_venta (
    id_venta INT,
    id_ubicacion INT,
    id_tiempo INT,
    total DECIMAL(18,2),
    descuento_total DECIMAL(18,2),
    id_turno INT,
    cantidad_unidades decimal(18,0),
    id_rango_empleado INT,
    id_tipo_caja INT,
    PRIMARY KEY (id_venta),
    CONSTRAINT [FK_id_ubicacion_en_BI_venta.id_ubicacion]
        FOREIGN KEY ([id_ubicacion])
        REFERENCES [REJUNTESA].[BI_ubicacion]([id_localidad]),
    CONSTRAINT [FK_id_tiempo_en_BI_venta.id_tiempo]
        FOREIGN KEY ([id_tiempo])
        REFERENCES [REJUNTESA].[BI_tiempo]([id_tiempo]),
    CONSTRAINT [FK_id_turno_en_BI_venta.id_turno]
        FOREIGN KEY ([id_turno])
        REFERENCES [REJUNTESA].[BI_turno]([id_turno]),
    CONSTRAINT [FK_id_rango_empleado_en_BI_venta.id_rango_empleado]
        FOREIGN KEY ([id_rango_empleado])
        REFERENCES [REJUNTESA].[BI_rango_etario]([id_rango_etario]),
    CONSTRAINT [FK_id_tipo_caja_en_BI_venta.id_tipo_caja]
        FOREIGN KEY ([id_tipo_caja])
        REFERENCES [REJUNTESA].[BI_tipo_caja]([id_tipo_caja])
);

-- Crea tabla Producto_Vendido
CREATE TABLE REJUNTESA.BI_producto_vendido (
    id_venta INT,
    id_producto INT,
    cantidad DECIMAL(18,0),
    precio_total DECIMAL(18,2),
    descuento_promo DECIMAL(18,2),
    precio_unitario DECIMAL(18,2),
    id_categoria INT,
    id_subcategoria INT,
    PRIMARY KEY (id_venta, id_producto),
    CONSTRAINT [FK_id_venta_en_BI_producto_vendido.id_venta]
        FOREIGN KEY ([id_venta])
        REFERENCES [REJUNTESA].[BI_venta]([id_venta]),
    CONSTRAINT [FK_id_producto_en_BI_producto_vendido.id_producto]
        FOREIGN KEY ([id_producto])
        REFERENCES [REJUNTESA].[BI_producto]([id_producto]),
    CONSTRAINT [FK_id_categoria_en_BI_producto_vendido.id_categoria]
        FOREIGN KEY ([id_categoria])
        REFERENCES [REJUNTESA].[BI_categoria]([id_categoria]),
    CONSTRAINT [FK_id_subcategoria_en_BI_producto_vendido.id_subcategoria]
        FOREIGN KEY ([id_subcategoria])
        REFERENCES [REJUNTESA].[BI_subcategoria]([id_subcategoria])
);

-- Crea tabla Envio
CREATE TABLE REJUNTESA.BI_envio (
    id_envio INT,
    fecha_cumplida BIT,
    id_sucursal INT,
    id_tiempo INT,
    id_rango_cliente INT,
    id_ubicacion_destino INT,
    costo DECIMAL(18,2),
    PRIMARY KEY (id_envio),
    CONSTRAINT [FK_id_sucursal_en_BI_envio.id_sucursal]
        FOREIGN KEY ([id_sucursal])
        REFERENCES [REJUNTESA].[BI_sucursal]([id_sucursal]),
    CONSTRAINT [FK_id_tiempo_en_BI_envio.id_tiempo]
        FOREIGN KEY ([id_tiempo])
        REFERENCES [REJUNTESA].[BI_tiempo]([id_tiempo]),
    CONSTRAINT [FK_id_rango_cliente_en_BI_envio.id_rango_cliente]
        FOREIGN KEY ([id_rango_cliente])
        REFERENCES [REJUNTESA].[BI_rango_etario]([id_rango_etario]),
    CONSTRAINT [FK_id_ubicacion_destino_en_BI_envio.id_ubicacion_destino]
        FOREIGN KEY ([id_ubicacion_destino])
        REFERENCES [REJUNTESA].[BI_ubicacion]([id_localidad])
);

-- Crea tabla Pago
CREATE TABLE REJUNTESA.BI_pago (
    nro_pago INT,
    id_medio_pago INT,
    cuotas DECIMAL(18,0),
    id_tiempo INT,
    importe DECIMAL(18,2),
    decuento_medio DECIMAL(18,2),
    id_sucursal INT,
    id_rango_cliente INT,
    id_venta INT,
    PRIMARY KEY (nro_pago),
    CONSTRAINT [FK_id_sucursal_en_BI_pago.id_sucursal]
        FOREIGN KEY ([id_sucursal])
        REFERENCES [REJUNTESA].[BI_sucursal]([id_sucursal]),
    CONSTRAINT [FK_id_tiempo_en_BI_pago.id_tiempo]
        FOREIGN KEY ([id_tiempo])
        REFERENCES [REJUNTESA].[BI_tiempo]([id_tiempo]),
    CONSTRAINT [FK_id_rango_cliente_en_BI_pago.id_rango_cliente]
        FOREIGN KEY ([id_rango_cliente])
        REFERENCES [REJUNTESA].[BI_rango_etario]([id_rango_etario]),
    CONSTRAINT [FK_id_medio_pago_en_BI_pago.id_medio_pago]
        FOREIGN KEY ([id_medio_pago])
        REFERENCES [REJUNTESA].[BI_medio_pago]([id_medio_pago]),
    CONSTRAINT [FK_id_venta_en_BI_pago.id_venta]
        FOREIGN KEY ([id_venta])
        REFERENCES [REJUNTESA].[BI_venta]([id_venta])
);

-- Migraciones

GO 
CREATE PROCEDURE [REJUNTESA].migrar_BI_rango_etario
AS 
BEGIN
	INSERT INTO [REJUNTESA].BI_rango_etario(edad_min, edad_max) VALUES(0,25)
	INSERT INTO [REJUNTESA].BI_rango_etario(edad_min, edad_max) VALUES(25,35)
	INSERT INTO [REJUNTESA].BI_rango_etario(edad_min, edad_max) VALUES(35,50)
	INSERT INTO [REJUNTESA].BI_rango_etario(edad_min, edad_max) VALUES(50,200)
	IF @@ERROR != 0
	PRINT('SP RANGO ETARIO BI FAIL!')
	ELSE
	PRINT('SP RANGO ETARIO BI OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_rango_horario
AS 
BEGIN
	INSERT INTO [REJUNTESA].BI_turno(inicio_turno, fin_turno) VALUES(8,12)
	INSERT INTO [REJUNTESA].BI_turno(inicio_turno, fin_turno) VALUES(12,16)
	INSERT INTO [REJUNTESA].BI_turno(inicio_turno, fin_turno) VALUES(16,20)
	IF @@ERROR != 0
	PRINT('SP RANGO HORARIO BI FAIL!')
	ELSE
	PRINT('SP RANGO HORARIO BI OK!')
END
GO

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_provincia
AS 
BEGIN
	INSERT INTO [REJUNTESA].BI_provincia(id_provincia, nombre)
	SELECT
		id_provincia,
        nombre
	FROM REJUNTESA.provincia
	IF @@ERROR != 0
	PRINT('SP BI_Provincia  FAIL!')
	ELSE
	PRINT('SP BI_Provincia OK!')
END
GO

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_ubicacion
AS 
BEGIN
	INSERT INTO [REJUNTESA].BI_ubicacion(id_localidad, nombre, id_provincia)
	SELECT
		id_localidad,
        nombre,
		id_provincia
	FROM REJUNTESA.localidad
	IF @@ERROR != 0
	PRINT('SP BI_ubicacion  FAIL!')
	ELSE
	PRINT('SP BI_ubicacion OK!')
END
GO

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_tipo_caja
AS 
BEGIN
    INSERT INTO [REJUNTESA].BI_tipo_caja(id_tipo_caja, nombre)
    SELECT
		id_tipo_caja,
        nombre
    FROM [REJUNTESA].tipo_caja
    IF @@ERROR != 0
    PRINT('SP TIPO CAJA BI FAIL!')
    ELSE
    PRINT('SP TIPO CAJA BI OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_sucursal
AS 
BEGIN
    INSERT INTO [REJUNTESA].BI_sucursal(id_sucursal, nombre, id_ubicacion)
    SELECT
		id_sucursal,
        nombre,
        id_localidad
    FROM [REJUNTESA].sucursal
    IF @@ERROR != 0
    PRINT('SP BI sucursal FAIL!')
    ELSE
    PRINT('SP BI sucursal OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_categoria
AS 
BEGIN
    INSERT INTO [REJUNTESA].BI_categoria(id_categoria, categoria)
    SELECT
		id_categoria,
        categoria
    FROM [REJUNTESA].categoria
    IF @@ERROR != 0
    PRINT('SP BI categoria FAIL!')
    ELSE
    PRINT('SP BI categoria OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_subcategoria
AS 
BEGIN
    INSERT INTO [REJUNTESA].BI_subcategoria(id_subcategoria, subcategoria, id_categoria)
    SELECT
		id_subcategoria,
        subcategoria,
        id_categoria
    FROM [REJUNTESA].subcategoria
    IF @@ERROR != 0
    PRINT('SP BI subcategoria FAIL!')
    ELSE
    PRINT('SP BI subcategoria OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_medio_pago
AS 
BEGIN
    INSERT INTO [REJUNTESA].BI_medio_pago(id_medio_pago, nombre)
    SELECT
		id_medio_pago,
        nombre
    FROM [REJUNTESA].medio_pago
    IF @@ERROR != 0
    PRINT('SP BI medio pago FAIL!')
    ELSE
    PRINT('SP BI medio pago OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_producto
AS 
BEGIN
    INSERT INTO [REJUNTESA].BI_producto(id_producto, nombre)
    SELECT
		id_producto,
        nombre
    FROM [REJUNTESA].producto
    IF @@ERROR != 0
    PRINT('SP BI Producto FAIL!')
    ELSE
    PRINT('SP BI Producto OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_tiempo
AS

DECLARE @primerAnio int = 1900
SELECT @primerAnio = YEAR(MIN(fecha))
FROM [REJUNTESA].venta

DECLARE @cantidadMeses int = 12
SELECT @cantidadMeses = DATEDIFF(month,MIN(f.fecha),MAX(f.fecha)) + 1
FROM (
    SELECT fecha FROM [REJUNTESA].venta
    UNION
    SELECT fecha_pago as fecha FROM [REJUNTESA].pago
    UNION
    SELECT fecha_programada as fecha FROM [REJUNTESA].envio
    UNION
    SELECT fecha_entrega as fecha FROM [REJUNTESA].envio
) as f

DECLARE @i int = 0
WHILE @i < @cantidadMeses
BEGIN
    INSERT INTO [REJUNTESA].BI_tiempo(mes, cuatrimestre, anio) VALUES(
        (@i%12) + 1,
        ((@i/4)%3) + 1,
        @i/12 + @primerAnio
    )
    SET @i = @i + 1
    IF @@ERROR != 0
    PRINT('SP BI Tiempo FAIL!')
    ELSE
    PRINT('SP BI Tiempo OK!')
END

/*GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_venta
AS 
BEGIN
    INSERT INTO [REJUNTESA].BI_venta(id_venta, id_ubicacion, total, descuento_total, id_turno, cantidad_unidades, id_rango_empleado, id_tipo_caja)
    SELECT
		v.id_venta,
        u.id_ubicacion,
        v.total,
        1, -- Aca iria tiempo, para mi es la fecha 
        v.descuento_promociones, -- Esto se calcula asi?
        -- id_turno
        -- cantidad unidades,
        -- id_rango_empleado
        v.tipo_caja
    FROM [REJUNTESA].venta v
    JOIN [REJUNTESA].sucursal s on s.id_sucursal = v.sucursal
    JOIN [REJUNTESA].ubicacion u on s.id_localidad = u.id_localidad and s.id_provincia = u.id_provincia
    JOIN [REJUNTESA].caja c on c.nro_caja = v.nro_caja and c.sucursal = v.sucursal
    JOIN [REJUNTESA].BI_turno BITU on v.fecha BETWEEN BITU.
    IF @@ERROR != 0
    PRINT('SP BI Producto FAIL!')
    ELSE
    PRINT('SP BI Producto OK!')
END*/
USE [GD1C2024]
GO

CREATE PROCEDURE [REJUNTESA].migrar_BI_producto_venidido
AS
BEGIN

    INSERT INTO [REJUNTESA].BI_producto_vendido (id_venta, id_producto,cantidad,precio_total,descuento_promo,precio_unitario,id_categoria,id_subcategoria)
  
	SELECT 

	pv.id_venta,
	pv.id_producto,
	pv.cantidad,
	v.total, -- o sub_total?	
	v.descuento_promociones,
	p.precio,
	c.id_categoria,
	sc.id_categoria

	from [REJUNTESA].producto_vendido pv
	join [REJUNTESA].venta v on pv.id_venta = v.id_venta 
	join [REJUNTESA].producto p on pv.id_producto = p.id_producto  
	join [REJUNTESA].subcategoria sc on sc.id_subcategoria = p.id_subcategoria
	join [REJUNTESA].categoria c on c.id_categoria = sc.id_categoria

END


CREATE FUNCTION calcular_edad(@fecha_nacimiento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE());
    RETURN @edad;
END;

CREATE FUNCTION obtener_rango_etario(@id_cliente int)
RETURNS INT
AS
BEGIN
	--DECLARE @re_id INT
	DECLARE @edad INT

	--SELECT @re_id = re.id_rango_etario  from [REJUNTESA].BI_rango_etario re
	--JOIN cliente c ON c.dni = @id_cliente
	
	 SELECT @edad = dbo.calcular_edad(c.nacimiento) from Cliente c
	 WHERE c.dni = @id_cliente

	 RETURN 
	 CASE
        WHEN @edad < 25 THEN 0
        WHEN @edad BETWEEN 25 AND 35 THEN 1
        WHEN @edad BETWEEN 35 AND 50 THEN 2
        WHEN @edad > 50 THEN 3 END
	
END


CREATE PROCEDURE [REJUNTESA].migrar_envio
AS
BEGIN

 INSERT INTO [REJUNTESA].BI_envio (id_envio, fecha_cumplida, id_sucursal, id_tiempo, id_rango_cliente, id_ubicacion_destino, costo)
  
  SELECT 
  e.id_envio, 
  e.fecha_entrega,
  v.id_sucursal,
  1, -- ??
  dbo.obtener_rango_etario(c.dni),
  u.id_localidad,
  e.costo

  FROM [REJUNTESA].envio e
  JOIN [REJUNTESA].venta v ON v.id_venta = e.id_venta
  JOIN [REJUNTESA].cliente c ON e.id_cliente = c.dni
  JOIN [REJUNTESA].sucursal s ON s.id_sucursal = v.id_sucursal
  JOIN [REJUNTESA].ubicacion u ON s.id_localidad = u.id_localidad and s.id_provincia = u.id_provincia

END



	CREATE PROCEDURE [REJUNTESA].migrar_BI_pago
AS
BEGIN

    INSERT INTO [REJUNTESA].BI_pago(nro_pago, id_medio_pago, cuotas, id_tiempo, importe, decuento_medio, id_sucursal, id_rango_cliente, id_venta)
	SELECT 
	p.nro_pago,
	p.id_medio_pago,
	isnull(dp.cuotas, 0),
	1, -- ??
	p.importe,
	v.descuento_medio,
	v.id_sucursal, 
	dbo.obtener_rango_etario(dp.id_cliente),
	v.id_venta
	FROM [REJUNTESA].pago p

	JOIN [REJUNTESA].medio_pago mp on mp.id_medio_pago = p.id_medio_pago
	JOIN [REJUNTESA].venta v ON v.id_venta = p.id_venta
	JOIN [REJUNTESA].descuento_x_medio_pago dxmp on dxmp.id_medio_pago = mp.id_medio_pago
	JOIN [REJUNTESA].descuento_medio_pago dmp on dxmp.cod_descuento = dmp.cod_descuento
	JOIN [REJUNTESA].detalle_pago dp on dp.id_detalle_pago = p.id_detalle_pago

END


-- Vistas


--1) Ticket  Promedio  mensual.  Valor  promedio  de  las  ventas  (en  $)  según  la 
--localidad,  año  y  mes.  Se  calcula  en  función  de  la  sumatoria  del  importe  de  las 
--ventas sobre el total de las mismas.

CREATE VIEW BI_Ticket_Promedio_Mensual
AS SELECT 

u.id_localidad,
t.anio,
t.mes,
(sum(v.total)/ count(v.id_venta)) 

FROM BI_venta v
join BI_tiempo t on t.id_tiempo = v.id_tiempo
join BI_ubicacion u on v.id_ubicacion = u.id_provincia

group by u.id_localidad, t.anio, t.mes


--2) Cantidad  unidades  promedio.  Cantidad  promedio  de  artículos  que  se  venden 
--en  función  de  los  tickets  según  el  turno  para  cada  cuatrimestre  de  cada  año.  Se 
--obtiene  sumando  la  cantidad  de  artículos  de  todos  los  tickets  correspondientes 
--sobre  la  cantidad  de  tickets.  Si  un  producto  tiene  más  de  una  unidad  en  un  ticket, 
--para el indicador se consideran todas las unidades. 


CREATE VIEW BI_Cantidad_Unidades_Promedio
AS SELECT

t.cuatrimestre as Cuatrimestre,
t.anio  as Año,
(v.cantidad_unidades)/
(select count(distinct v2.id_venta) as [Cantidad unidades promedio]
from BI_venta v2
join BI_tiempo t2 on v2.id_venta = t2.id_tiempo
where (t2.id_tiempo = t.id_tiempo))

FROM BI_venta v
join BI_producto_vendido pv on pv.id_venta = v.id_venta
join BI_tiempo t on t.id_tiempo = v.id_tiempo

GROUP BY  t.cuatrimestre, t.anio


--3.  Porcentaje  anual  de  ventas  registradas  por  rango  etario  del  empleado  según  el 
--tipo  de  caja  para  cada  cuatrimestre.  Se  calcula  tomando  la  cantidad  de  ventas 
--correspondientes sobre el total de ventas anual. 


CREATE VIEW BI_Porcentaje_Anual_Ventas
AS SELECT
t.cuatrimestre as Cuatrimestre,
re.id_rango_etario as [Rango etario (E)], 
tc.id_tipo_caja as [Tipo de caja],
(
count (distinct v.id_venta)
)/
(select count(distinct v2.id_venta) from Venta v2
join BI_tiempo t2 on t2.id_tiempo = t.id_tiempo
)

from BI_venta v
join BI_tiempo t on t.id_tiempo = v.id_tiempo
join BI_rango_etario re on v.id_rango_empleado = re.id_rango_etario
join BI_tipo_caja tc on tc.id_tipo_caja = v.id_tipo_caja

group by t.cuatrimestre, re.id_rango_etario, tc.id_tipo_caja

--4.  Cantidad  de  ventas  registradas  por  turno  para  cada  localidad  según  el  mes  de 
--cada año. 

CREATE VIEW BI_Cantidad_Ventas_Registradas
AS SELECT
t.anio as Año,
t.mes as Mes,
u.id_localidad as Localidad,
count(distinct v.id_venta) as [Cantidad ventas]
from BI_venta v
join BI_tiempo t on t.id_tiempo = v.id_tiempo
join BI_ubicacion u on u.id_localidad = v.id_ubicacion
group by t.anio, t.mes, u.id_localidad

--5.  Porcentaje  de  descuento  aplicados  en  función  del  total  de  los  tickets  según  el 
--mes de cada año. 

CREATE VIEW BI_Porcentaje_Descuento_Aplicado
AS SELECT
t.anio as Año, 
t.mes as Mes,
(v.descuento_total / v.total) * 100
/
(select count(distinct v2.id_venta) from BI_venta v2
 join BI_tiempo t2 on v.id_tiempo = t2.id_tiempo
 where t.id_tiempo = t2.id_tiempo) as [Descuento aplicado(%)]

from BI_Venta v
join BI_tiempo t on v.id_tiempo = t.id_tiempo
group by t.anio, t.mes


--6.  Las  tres  categorías  de  productos  con  mayor  descuento  aplicado  a  partir  de 
--promociones para cada cuatrimestre de cada año. 


CREATE VIEW BI_Categorias_con_mayor_Descuento
AS SELECT
top 3 

c.categoria as Categoria

from BI_categoria c
join BI_producto_vendido pv on pv.id_categoria = c.id_categoria

group by c.id_categoria

order by sum(pv.descuento_promo) desc

--7.  Porcentaje  de  cumplimiento  de  envíos  en  los  tiempos  programados  por 
--sucursal por año/mes (desvío) 

CREATE VIEW BI_Cumplimiento_Envios
AS SELECT

count(e.fecha_cumplida) / count(*) 

from BI_envio e
left join BI_tiempo t on e.id_tiempo = t.id_tiempo
left join BI_sucursal s on s.id_sucursal = e.id_sucursal

group by t.anio, t.cuatrimestre

--8.  Cantidad  de  envíos  por  rango  etario  de  clientes  para  cada  cuatrimestre  de 
--cada año. 

CREATE VIEW BI_Envios_Rango_Etario
AS SELECT

t.anio, 
t.cuatrimestre,
e.id_rango_cliente,
count(distinct e.id_envio)

from BI_envio e
join BI_tiempo t on e.id_tiempo = t.id_tiempo
join BI_rango_etario re on re.id_rango_etario = e.id_rango_cliente

group by t.anio, t.cuatrimestre, e.id_rango_cliente


--9.  Las 5 localidades (tomando la localidad del cliente) con mayor costo de envío.

CREATE VIEW BI_Localidades_Mayor_Costo
AS SELECT
select 
top 5 

