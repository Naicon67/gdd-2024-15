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
CREATE PROCEDURE [REJUNTESA].migrar_BI_turno
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

DECLARE @primerAnio int = 1900;
DECLARE @primerMes int = 1;
SELECT @primerAnio = YEAR(MIN(fecha)), @primerMes = MONTH(MIN(fecha))
FROM [REJUNTESA].venta

DECLARE @cantidadMeses int = 12;
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

DECLARE @i int = @primerMes - 1;
WHILE @i < @cantidadMeses + @primerMes -1
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

GO
CREATE FUNCTION [REJUNTESA].calcular_edad(@fecha_nacimiento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE());
    RETURN @edad;
END

GO
CREATE FUNCTION [REJUNTESA].obtener_rango_etario(@edad int)
RETURNS INT
AS
BEGIN
    DECLARE @id INT;
    SELECT @id = id_rango_etario
    FROM [REJUNTESA].BI_rango_etario
    WHERE @edad BETWEEN edad_min AND edad_max;
    RETURN isnull(@id,1);
END

GO
CREATE FUNCTION [REJUNTESA].obtener_rango_etario_cliente(@id_cliente int)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SELECT @edad = [REJUNTESA].calcular_edad(nacimiento)
    FROM [REJUNTESA].cliente
    WHERE id_cliente = @id_cliente;
    RETURN [REJUNTESA].obtener_rango_etario(@edad);
END

GO
CREATE FUNCTION [REJUNTESA].obtener_rango_etario_empleado(@legajo_empleado int)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SELECT @edad = [REJUNTESA].calcular_edad(nacimiento)
    FROM [REJUNTESA].empleado
    WHERE legajo_empleado = @legajo_empleado
    RETURN [REJUNTESA].obtener_rango_etario(@edad)
END

GO
CREATE FUNCTION [REJUNTESA].obtener_turno(@fecha datetime)
RETURNS INT
AS
BEGIN
    DECLARE @hora INT = DATEPART(HOUR, @fecha)
    DECLARE @id INT;
    SELECT @id = id_turno
    FROM [REJUNTESA].BI_turno
    WHERE @hora BETWEEN inicio_turno AND fin_turno
    RETURN isnull(@id, 1)
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_venta
AS 
BEGIN
    INSERT INTO [REJUNTESA].BI_venta(id_venta, id_ubicacion, id_tiempo, total, descuento_total, id_turno, cantidad_unidades, id_rango_empleado, id_tipo_caja)
    SELECT
		v.id_venta,
        s.id_localidad,
        t.id_tiempo,
        v.total,
        MAX(v.descuento_promociones + v.descuento_medio) as descuento_total,
        MAX([REJUNTESA].obtener_turno(v.fecha)) as id_turno,
        SUM(pv.cantidad) as cantidad_unidades,
        MAX([REJUNTESA].obtener_rango_etario_empleado(v.legajo_empleado)) as id_rango_empleado,
        c.id_tipo_caja
    FROM [REJUNTESA].venta v
    JOIN [REJUNTESA].sucursal s on s.id_sucursal = v.id_sucursal
    JOIN [REJUNTESA].caja c on c.nro_caja = v.nro_caja and c.id_sucursal = v.id_sucursal
    JOIN [REJUNTESA].producto_vendido pv ON v.id_venta = pv.id_venta
    JOIN [REJUNTESA].BI_tiempo t ON MONTH(v.fecha) = t.mes AND YEAR(v.fecha) = t.anio
    GROUP BY
        v.id_venta,
        s.id_localidad,
        t.id_tiempo,
        v.total,
        c.id_tipo_caja
    IF @@ERROR != 0
    PRINT('SP BI Venta FAIL!')
    ELSE
    PRINT('SP BI Venta OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_producto_vendido
AS
BEGIN
    INSERT INTO [REJUNTESA].BI_producto_vendido (id_venta, id_producto,cantidad,precio_total,descuento_promo,precio_unitario,id_categoria,id_subcategoria)
	SELECT 
        pv.id_venta,
        pv.id_producto,
        pv.cantidad,
        pv.precio_total,
        isnull(pa.descuento_total,0),
        p.precio,
        c.id_categoria,
        sc.id_categoria
	from [REJUNTESA].producto_vendido pv
	join [REJUNTESA].venta v on pv.id_venta = v.id_venta 
	join [REJUNTESA].producto p on pv.id_producto = p.id_producto  
	join [REJUNTESA].subcategoria sc on sc.id_subcategoria = p.id_subcategoria
	join [REJUNTESA].categoria c on c.id_categoria = sc.id_categoria
    LEFT JOIN [REJUNTESA].promocion_aplicada pa ON pv.id_venta = pa.id_venta AND pv.id_producto = pa.id_producto
    IF @@ERROR != 0
    PRINT('SP BI Producto Vendido FAIL!')
    ELSE
    PRINT('SP BI Producto Vendido OK!')
END


GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_envio
AS
BEGIN
    INSERT INTO [REJUNTESA].BI_envio (id_envio, fecha_cumplida, id_sucursal, id_tiempo, id_rango_cliente, id_ubicacion_destino, costo)
    SELECT 
        e.id_envio,
        CASE 
           WHEN fecha_entrega <= fecha_programada THEN 1 
           ELSE 0 
        END,
        v.id_sucursal,
        t.id_tiempo,
        [REJUNTESA].obtener_rango_etario_cliente(c.id_cliente),
        c.id_localidad,
        e.costo
    FROM [REJUNTESA].envio e
    JOIN [REJUNTESA].venta v ON v.id_venta = e.id_venta
    JOIN [REJUNTESA].cliente c ON e.id_cliente = c.dni
    JOIN [REJUNTESA].sucursal s ON s.id_sucursal = v.id_sucursal
    JOIN [REJUNTESA].BI_tiempo t ON MONTH(e.fecha_entrega) = t.mes AND YEAR(e.fecha_entrega) = t.anio
    IF @@ERROR != 0
    PRINT('SP BI Envio FAIL!')
    ELSE
    PRINT('SP BI Envio OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_BI_pago
AS
BEGIN
    INSERT INTO [REJUNTESA].BI_pago(nro_pago, id_medio_pago, cuotas, id_tiempo, importe, decuento_medio, id_sucursal, id_rango_cliente, id_venta)
	SELECT 
        p.nro_pago,
        p.id_medio_pago,
        isnull(dp.cuotas, 1),
        t.id_tiempo,
        p.importe,
        p.descuento_aplicado,
        v.id_sucursal, 
        CASE
            WHEN dp.id_cliente IS NOT NULL THEN [REJUNTESA].obtener_rango_etario_cliente(dp.id_cliente)
            ELSE NULL
        END,
        v.id_venta
	FROM [REJUNTESA].pago p
	JOIN [REJUNTESA].medio_pago mp on mp.id_medio_pago = p.id_medio_pago
	JOIN [REJUNTESA].venta v ON v.id_venta = p.id_venta
	LEFT JOIN [REJUNTESA].detalle_pago dp on dp.id_detalle_pago = p.id_detalle_pago
    JOIN [REJUNTESA].BI_tiempo t ON MONTH(p.fecha_pago) = t.mes AND YEAR(p.fecha_pago) = t.anio
    IF @@ERROR != 0
    PRINT('SP BI Pago FAIL!')
    ELSE
    PRINT('SP BI Pago OK!')
END

GO
EXEC REJUNTESA.migrar_BI_rango_etario

GO
EXEC REJUNTESA.migrar_BI_turno

GO
EXEC REJUNTESA.migrar_BI_provincia

GO
EXEC REJUNTESA.migrar_BI_ubicacion

GO
EXEC REJUNTESA.migrar_BI_tipo_caja

GO
EXEC REJUNTESA.migrar_BI_sucursal

GO
EXEC REJUNTESA.migrar_BI_categoria

GO
EXEC REJUNTESA.migrar_BI_subcategoria

GO
EXEC REJUNTESA.migrar_BI_producto

GO
EXEC REJUNTESA.migrar_BI_tiempo

GO
EXEC REJUNTESA.migrar_BI_medio_pago

GO
EXEC REJUNTESA.migrar_BI_venta

GO
EXEC REJUNTESA.migrar_BI_producto_vendido

GO
EXEC REJUNTESA.migrar_BI_envio

GO
EXEC REJUNTESA.migrar_BI_pago

SELECT * FROM [REJUNTESA].BI_pago

/*
-- Vistas


--1) Ticket  Promedio  mensual.  Valor  promedio  de  las  ventas  (en  $)  seg�n  la 
--localidad,  a�o  y  mes.  Se  calcula  en  funci�n  de  la  sumatoria  del  importe  de  las 
--ventas sobre el total de las mismas.
GO
CREATE
VIEW [REJUNTESA].BI_Ticket_Promedio_Mensual
AS 
SELECT 
    u.id_localidad,
    t.anio,
    t.mes,
    (SUM(v.total) / COUNT(v.id_venta)) AS [Promedio de ventas $]
FROM 
    [REJUNTESA].BI_venta v
JOIN 
    [REJUNTESA].BI_tiempo t ON t.id_tiempo = v.id_tiempo
JOIN 
    [REJUNTESA].BI_ubicacion u ON v.id_ubicacion = u.id_localidad
GROUP BY 
    u.id_localidad, t.anio, t.mes;

select * from [REJUNTESA].BI_Ticket_Promedio_Mensual


--2) Cantidad  unidades  promedio.  Cantidad  promedio  de  art�culos  que  se  venden 
--en  funci�n  de  los  tickets  seg�n  el  turno  para  cada  cuatrimestre  de  cada  a�o.  Se 
--obtiene  sumando  la  cantidad  de  art�culos  de  todos  los  tickets  correspondientes 
--sobre  la  cantidad  de  tickets.  Si  un  producto  tiene  m�s  de  una  unidad  en  un  ticket, 
--para el indicador se consideran todas las unidades. 

-- Problema group by 

/*
GO
CREATE VIEW [REJUNTESA].BI_Cantidad_Unidades_Promedio
AS 
SELECT
	ti.anio AS 'Año',
    ti.cuatrimestre AS 'Cuatrimestre',
    v.id_turno AS 'Turno',
    v.cantidad_unidades /
    (SELECT COUNT(DISTINCT v2.id_venta)
     FROM [REJUNTESA].BI_venta v2
     JOIN [REJUNTESA].BI_tiempo t2 ON v2.id_tiempo = t2.id_tiempo
     WHERE t2.cuatrimestre = ti.cuatrimestre AND t2.anio = ti.anio) AS [Cantidad unidades promedio]
FROM 
    [REJUNTESA].BI_venta v
JOIN 
    [REJUNTESA].BI_producto_vendido pv ON pv.id_venta = v.id_venta
JOIN 
    [REJUNTESA].BI_tiempo ti ON ti.id_tiempo = v.id_tiempo
GROUP BY ti.anio, ti.cuatrimestre, v.id_turno;

select * from [REJUNTESA].BI_Cantidad_Unidades_Promedio */

--3.  Porcentaje  anual  de  ventas  registradas  por  rango  etario  del  empleado  seg�n  el 
--tipo  de  caja  para  cada  cuatrimestre.  Se  calcula  tomando  la  cantidad  de  ventas 
--correspondientes sobre el total de ventas anual. 

GO
CREATE VIEW [REJUNTESA].BI_Porcentaje_Anual_Ventas
AS 
SELECT
    t.cuatrimestre AS Cuatrimestre,
    re.id_rango_etario AS [Rango etario (E)], 
    tc.id_tipo_caja AS [Tipo de caja],
    (
        COUNT(DISTINCT v.id_venta) * 1.0 /
        (SELECT COUNT(DISTINCT v2.id_venta) 
         FROM [REJUNTESA].BI_venta v2
         JOIN [REJUNTESA].BI_tiempo t2 ON v2.id_tiempo = t2.id_tiempo
         WHERE t2.anio = t.anio)
    ) AS [Porcentaje de ventas]
FROM 
    [REJUNTESA].BI_venta v
JOIN 
    [REJUNTESA].BI_tiempo t ON t.id_tiempo = v.id_tiempo
JOIN 
    [REJUNTESA].BI_rango_etario re ON v.id_rango_empleado = re.id_rango_etario
JOIN 
    [REJUNTESA].BI_tipo_caja tc ON tc.id_tipo_caja = v.id_tipo_caja
GROUP BY 
    t.cuatrimestre, re.id_rango_etario, tc.id_tipo_caja, t.anio;

select * from [REJUNTESA].BI_Porcentaje_Anual_Ventas


--4.  Cantidad  de  ventas  registradas  por  turno  para  cada  localidad  seg�n  el  mes  de 
--cada a�o. 
GO
CREATE VIEW [REJUNTESA].BI_Cantidad_Ventas_Registradas
AS 
SELECT
    t.anio as Año,
    t.mes as Mes,
    u.id_localidad AS Localidad,
    COUNT(DISTINCT v.id_venta) AS [Cantidad ventas]
FROM 
    [REJUNTESA].BI_venta v
JOIN 
    [REJUNTESA].BI_tiempo t ON t.id_tiempo = v.id_tiempo
JOIN 
    [REJUNTESA].BI_ubicacion u ON u.id_localidad = v.id_ubicacion
GROUP BY 
    t.anio, t.mes, u.id_localidad;

select * from [REJUNTESA].BI_Cantidad_Ventas_Registradas


--5.  Porcentaje  de  descuento  aplicados  en  funci�n  del  total  de  los  tickets  seg�n  el 
--mes de cada a�o. 

-- Problema group by 

/*
GO
CREATE VIEW [REJUNTESA].BI_Porcentaje_Descuento_Aplicado
AS SELECT
t.anio as Ano, 
t.mes as Mes,
(v.descuento_total / v.total) * 100
/
(select count(distinct v2.id_venta) from [REJUNTESA].BI_venta v2
 join [REJUNTESA].BI_tiempo t2 on v.id_tiempo = t2.id_tiempo
 where t.id_tiempo = t2.id_tiempo) as [Descuento aplicado(%)]

from [REJUNTESA].BI_Venta v
join [REJUNTESA].BI_tiempo t on v.id_tiempo = t.id_tiempo
group by t.anio, t.mes
*/

--6.  Las  tres  categor�as  de  productos  con  mayor  descuento  aplicado  a  partir  de 
--promociones para cada cuatrimestre de cada a�o. 


CREATE VIEW [REJUNTESA].BI_Categorias_con_mayor_Descuento
AS SELECT
top 3  

c.categoria AS 'Categoria'

FROM [REJUNTESA].BI_categoria c
JOIN [REJUNTESA].BI_producto_vendido pv ON pv.id_categoria = c.id_categoria

GROUP BY  c.categoria 

ORDER BY  SUM(pv.descuento_promo) DESC


--7.  Porcentaje  de  cumplimiento  de  env�os  en  los  tiempos  programados  por 
--sucursal por a�o/mes (desv�o) 

-- No se estan cargando los envios en las migraciones, no se puede probar

CREATE VIEW [REJUNTESA].BI_Cumplimiento_Envios
AS SELECT

count(e.fecha_cumplida) / count(*) 

from [REJUNTESA].BI_envio e
left join [REJUNTESA].BI_tiempo t on e.id_tiempo = t.id_tiempo
left join [REJUNTESA].BI_sucursal s on s.id_sucursal = e.id_sucursal

group by t.anio, t.cuatrimestre

--8.  Cantidad  de  env�os  por  rango  etario  de  clientes  para  cada  cuatrimestre  de 
--cada a�o. 

-- No se estan cargando los envios en las migraciones, no se puede probar

CREATE VIEW [REJUNTESA].BI_Envios_Rango_Etario
AS SELECT

t.anio, 
t.cuatrimestre,
e.id_rango_cliente,
count(distinct e.id_envio)

from [REJUNTESA].BI_envio e
join [REJUNTESA].BI_tiempo t on e.id_tiempo = t.id_tiempo
join [REJUNTESA].BI_rango_etario re on re.id_rango_etario = e.id_rango_cliente

group by t.anio, t.cuatrimestre, e.id_rango_cliente


--9.  Las 5 localidades (tomando la localidad del cliente) con mayor costo de env�o.

CREATE VIEW BI_Localidades_Mayor_Costo
AS SELECT
select 
top 5 

*/