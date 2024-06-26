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
    descuento_medio DECIMAL(18,2),
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
CREATE FUNCTION [REJUNTESA].calcular_edad(@fecha_nacimiento DATE, @fechaEdad datetime)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, @fechaEdad);
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
CREATE FUNCTION [REJUNTESA].obtener_rango_etario_cliente(@id_cliente int, @fechaEdad datetime)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SELECT @edad = [REJUNTESA].calcular_edad(nacimiento, @fechaEdad)
    FROM [REJUNTESA].cliente
    WHERE id_cliente = @id_cliente;
    RETURN [REJUNTESA].obtener_rango_etario(@edad);
END

GO
CREATE FUNCTION [REJUNTESA].obtener_rango_etario_empleado(@legajo_empleado int, @fechaEdad datetime)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SELECT @edad = [REJUNTESA].calcular_edad(nacimiento, @fechaEdad)
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
        MAX([REJUNTESA].obtener_rango_etario_empleado(v.legajo_empleado, v.fecha)) as id_rango_empleado,
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
            WHEN    -- Distinta fecha
                CAST(fecha_programada as date) != CAST(fecha_entrega as date)
                OR  -- Fecha bien, fuera de horario
                (CAST(fecha_programada as date) = CAST(fecha_entrega as date)
                AND (DATEPART(HOUR, fecha_entrega) > hora_rango_final
                OR DATEPART(HOUR, fecha_entrega) < hora_rango_inicio)) THEN 0
            ELSE 1
        END as fecha_cumplida,
        v.id_sucursal,
        t.id_tiempo,
        [REJUNTESA].obtener_rango_etario_cliente(c.id_cliente, v.fecha) as id_rango_cliente,
        c.id_localidad,
        e.costo
    FROM [REJUNTESA].envio e
    JOIN [REJUNTESA].venta v ON v.id_venta = e.id_venta
    JOIN [REJUNTESA].cliente c ON e.id_cliente = c.id_cliente
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
    INSERT INTO [REJUNTESA].BI_pago(nro_pago, id_medio_pago, cuotas, id_tiempo, importe, descuento_medio, id_sucursal, id_rango_cliente, id_venta)
	SELECT 
        p.nro_pago,
        p.id_medio_pago,
        isnull(dp.cuotas, 1),
        t.id_tiempo,
        p.importe,
        p.descuento_aplicado,
        v.id_sucursal, 
        CASE
            WHEN dp.id_cliente IS NOT NULL THEN [REJUNTESA].obtener_rango_etario_cliente(dp.id_cliente, p.fecha_pago)
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

-- Vistas

GO -- 1
CREATE VIEW [REJUNTESA].BI_Ticket_Promedio_Mensual
AS 
SELECT 
    v.id_ubicacion as Localidad,
    t.anio as Año,
    t.mes as Mes,
    AVG(v.total) AS [Promedio de ventas ($)]
FROM [REJUNTESA].BI_venta v
JOIN [REJUNTESA].BI_tiempo t ON t.id_tiempo = v.id_tiempo
GROUP BY v.id_ubicacion, t.anio, t.mes;

GO -- 2
CREATE VIEW [REJUNTESA].BI_Cantidad_Unidades_Promedio
AS 
SELECT
	ti.anio AS Año,
    ti.cuatrimestre AS Cuatrimestre,
    v.id_turno AS Turno,
	AVG(v.cantidad_unidades) as [Cantidad promedio de unidades]
FROM [REJUNTESA].BI_venta v
JOIN [REJUNTESA].BI_tiempo ti ON ti.id_tiempo = v.id_tiempo
GROUP BY ti.anio, ti.cuatrimestre, v.id_turno

GO -- 3
CREATE VIEW [REJUNTESA].BI_Porcentaje_Anual_Ventas
AS 
SELECT
	t.anio AS Año,
    t.cuatrimestre AS Cuatrimestre,
    v.id_rango_empleado AS [Rango etario (E)], 
    v.id_tipo_caja AS [Tipo de caja],
    ROUND(count(*) * 100.0 / sum(count(*)) over(PARTITION BY t.anio), 4) AS [Porcentaje de ventas (%)]
FROM [REJUNTESA].BI_venta v
JOIN [REJUNTESA].BI_tiempo t ON t.id_tiempo = v.id_tiempo
GROUP BY t.anio, t.cuatrimestre, v.id_rango_empleado, v.id_tipo_caja

GO -- 4
CREATE VIEW [REJUNTESA].BI_Cantidad_Ventas_Registradas
AS 
SELECT
    t.anio AS Año,
    t.mes AS Mes,
	v.id_turno AS Turno,
    v.id_ubicacion AS Localidad,
    COUNT(v.id_venta) AS [Cantidad ventas]
FROM [REJUNTESA].BI_venta v
JOIN [REJUNTESA].BI_tiempo t ON t.id_tiempo = v.id_tiempo
GROUP BY t.anio, t.mes,v.id_turno, v.id_ubicacion

GO -- 5
CREATE VIEW [REJUNTESA].BI_Porcentaje_Descuento_Aplicado
AS 
SELECT
    t.anio AS Año, 
    t.mes AS Mes,
    CAST(ROUND((sum(v.descuento_total)/(sum(v.total)+sum(v.descuento_total))) * 100, 4) AS DECIMAL(12,4)) AS [Descuento aplicado (%)]
from [REJUNTESA].BI_Venta v
join [REJUNTESA].BI_tiempo t ON v.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes

GO -- 6
CREATE VIEW [REJUNTESA].BI_Categorias_con_mayor_Descuento
AS 
SELECT
    t.anio as Año,
    t.cuatrimestre as Cuatrimestre,
    ROW_NUMBER() over(PARTITION BY t.anio, t.cuatrimestre ORDER BY SUM(pv.descuento_promo) DESC) as Puesto,
    pv.id_categoria as Categoria    
FROM [REJUNTESA].BI_producto_vendido pv
JOIN [REJUNTESA].BI_venta v ON pv.id_venta = v.id_venta
JOIN [REJUNTESA].BI_tiempo t ON v.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.cuatrimestre , pv.id_categoria

GO -- 7
CREATE VIEW [REJUNTESA].BI_Cumplimiento_Envios
AS 
SELECT
    t.anio AS Año,
    t.mes AS Mes,
    e.id_sucursal AS Sucursal,
    ROUND(100*(SUM(CAST(e.fecha_cumplida as decimal(18,2)))/COUNT(*)), 4) as [Porcentaje cumplimiento (%)]
FROM [REJUNTESA].BI_envio e
JOIN [REJUNTESA].BI_tiempo t on e.id_tiempo = t.id_tiempo
GROUP BY  t.anio, t.mes, e.id_sucursal

GO -- 8
CREATE VIEW [REJUNTESA].BI_Envios_Rango_Etario
AS 
SELECT
    t.anio AS Año, 
    t.cuatrimestre AS Cuatrimestre,
    e.id_rango_cliente AS [Rango etario de los clientes],
    COUNT(e.id_envio) AS [Cantidad de envíos]
FROM [REJUNTESA].BI_envio e
JOIN [REJUNTESA].BI_tiempo t ON e.id_tiempo = t.id_tiempo
JOIN [REJUNTESA].BI_rango_etario re ON re.id_rango_etario = e.id_rango_cliente
GROUP BY t.anio, t.cuatrimestre, e.id_rango_cliente;

GO -- 9
CREATE VIEW [REJUNTESA].BI_Localidades_Mayor_Costo_Envio
AS 
SELECT
    e.id_ubicacion_destino as [Localidad destino],
    ROW_NUMBER() over(ORDER BY AVG(e.costo) DESC) as Puesto
FROM [REJUNTESA].BI_envio e
GROUP BY e.id_ubicacion_destino

GO -- 10
CREATE VIEW [REJUNTESA].BI_Sucursales_Mayor_Importe_Cuotas
AS 
SELECT
    t.anio as Año,
    t.mes as Mes,
    p.id_medio_pago as [Medio de pago],
    ROW_NUMBER() over(PARTITION BY t.anio, t.mes, p.id_medio_pago ORDER BY SUM(p.importe) DESC) as Puesto,
    p.id_sucursal as [Sucursal]    
FROM [REJUNTESA].BI_pago p
JOIN [REJUNTESA].BI_tiempo t ON p.id_tiempo = t.id_tiempo
WHERE cuotas > 1
GROUP BY t.anio, t.mes, p.id_medio_pago, p.id_sucursal

GO -- 11
CREATE VIEW [REJUNTESA].BI_Promedio_Importe_Cuota
AS
SELECT
    id_rango_cliente as [Rango etario de los clientes],
    AVG(importe / cuotas) as [Promedio importe cuota ($)]
FROM [REJUNTESA].BI_pago
WHERE cuotas > 1
GROUP BY id_rango_cliente

GO -- 12
CREATE VIEW [REJUNTESA].BI_Porcentaje_Descuento_Medio_Pago
AS 
SELECT
    t.anio as Año,
    t.cuatrimestre as Cuatrimestre, 
    p.id_medio_pago as [Medio de pago],
    ROUND(100*(SUM(p.descuento_medio)/(SUM(p.importe)+SUM(p.descuento_medio))), 4) as [Porcentaje de descuento (%)]
FROM [REJUNTESA].BI_pago p
JOIN [REJUNTESA].BI_tiempo t ON p.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.cuatrimestre, p.id_medio_pago

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

/* CONSULTAS DE VISTAS

-- 1
SELECT * FROM [REJUNTESA].BI_Ticket_Promedio_Mensual
-- 2
SELECT * FROM [REJUNTESA].BI_Cantidad_Unidades_Promedio
-- 3
SELECT * FROM [REJUNTESA].BI_Porcentaje_Anual_Ventas
-- 4
SELECT * FROM [REJUNTESA].BI_Cantidad_Ventas_Registradas
-- 5
SELECT * FROM [REJUNTESA].BI_Porcentaje_Descuento_Aplicado
-- 6
SELECT * FROM [REJUNTESA].BI_Categorias_con_mayor_Descuento
WHERE Puesto in (1,2,3)
-- 7
SELECT * FROM [REJUNTESA].BI_Cumplimiento_Envios
-- 8
SELECT * FROM [REJUNTESA].BI_Envios_Rango_Etario
-- 9
SELECT * FROM [REJUNTESA].BI_Localidades_Mayor_Costo_Envio
WHERE Puesto in (1,2,3,4,5)
-- 10
SELECT * FROM [REJUNTESA].BI_Sucursales_Mayor_Importe_Cuotas
WHERE Puesto in (1,2,3)
-- 11
SELECT * FROM [REJUNTESA].BI_Promedio_Importe_Cuota
-- 12
SELECT * FROM [REJUNTESA].BI_Porcentaje_Descuento_Medio_Pago

*/
