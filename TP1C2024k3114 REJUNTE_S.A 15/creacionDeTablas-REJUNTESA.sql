USE [GD1C2024]
GO

-- Borra todas las FKs
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) +
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @sql;
GO

-- Borra todas las tablas en el esquema REJUNTESA
DECLARE @dropTableSQL NVARCHAR(MAX) = N'';
SELECT @dropTableSQL += 'DROP TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME(name) + '; '
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) = 'REJUNTESA';
EXEC sp_executesql @dropTableSQL;
GO

-- INICIO: DROP SPs
IF EXISTS(	select
		*
	from sys.sysobjects
	where xtype = 'P' and name like 'migrar_%'
	)
	BEGIN
	
	PRINT 'Existen procedures de una ejecucion pasada'
	PRINT 'Se procede a borrarlos...'
	DECLARE @sql NVARCHAR(MAX) = N'';
	SELECT @sql += N'
	DROP PROCEDURE [REJUNTESA].'
	  + QUOTENAME(name) + ';'
	FROM sys.sysobjects
	WHERE xtype = 'P' and name like '%migrar_%'
	--PRINT @sql;
	EXEC sp_executesql @sql
	END
-- FIN: DROP SPs

-- INICIO: CREACION DE ESQUEMA
IF EXISTS(
SELECT * FROM sys.schemas where name = 'REJUNTESA'
)
BEGIN
	DROP SCHEMA [REJUNTESA]
END
GO

CREATE SCHEMA [REJUNTESA];
GO
-- FIN: CREACION DE ESQUEMA

-- Datos de negocio

CREATE TABLE [REJUNTESA].[categoria] (
  [id_categoria] int IDENTITY(1,1),
  [categoria] nvarchar(255),
  PRIMARY KEY ([id_categoria])
);

CREATE TABLE [REJUNTESA].[subcategoria] (
  [id_subcategoria] int IDENTITY(1,1),
  [id_categoria] int,
  [subcategoria] nvarchar(255),
  PRIMARY KEY ([id_subcategoria]),
  CONSTRAINT [FK_id_categoria.id_categoria]
    FOREIGN KEY ([id_categoria])
      REFERENCES [REJUNTESA].[categoria]([id_categoria])
);

CREATE TABLE [REJUNTESA].[producto] (
  [id_producto] int IDENTITY(1,1),
  [id_subcategoria] int,
  [nombre] nvarchar(255),
  [descripcion] nvarchar(255),
  [precio] decimal(18,2),
  [marca] nvarchar(255),
  PRIMARY KEY ([id_producto]),
  CONSTRAINT [FK_id_subcategoria.id_subcategoria]
    FOREIGN KEY ([id_subcategoria])
      REFERENCES [REJUNTESA].[subcategoria]([id_subcategoria])
);

CREATE TABLE [REJUNTESA].[regla] (
  [id_regla] int IDENTITY(1,1),
  [descripcion] nvarchar(255),
  [descuento] decimal(18,2),
  [cantidad_aplicable_regla] decimal(18,0),
  [cantidad_aplicable_descuento] decimal(18,0),
  [veces_aplicable] decimal(18,0),
  [misma_marca] decimal(18,0),
  [mismo_producto] decimal(18,0),
  PRIMARY KEY ([id_regla])
);

CREATE TABLE [REJUNTESA].[promocion_producto] (
  [cod_promocion] int IDENTITY(1,1),
  [descripcion] nvarchar(255),
  [fecha_inicio] datetime,
  [fecha_final] datetime,
  PRIMARY KEY ([cod_promocion])
);

CREATE TABLE [REJUNTESA].[medio_pago] (
  [id_medio_pago] int IDENTITY(1,1),
  [tipo] nvarchar(255),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_medio_pago])
);

CREATE TABLE [REJUNTESA].[descuento_medio_pago] (
  [cod_descuento] int IDENTITY(1,1),
  [descripcion] nvarchar(255),
  [fecha_inicio] datetime,
  [fecha_final] datetime,
  [porcentaje] decimal(18,2),
  [tope] decimal(18,2),
  PRIMARY KEY ([cod_descuento])
);

CREATE TABLE [REJUNTESA].[localidad] (
  [id_localidad] int IDENTITY(1,1),
  [id_provincia] int,
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_localidad])
);

CREATE TABLE [REJUNTESA].[provincia] (
  [id_provincia] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_provincia])
);

CREATE TABLE [REJUNTESA].[cliente] (
  [id_cliente] int IDENTITY(1,1),
  [dni] decimal(18,0),
  [nombre] nvarchar(255),
  [apellido] nvarchar(255),
  [domicilio] nvarchar(255),
  [registro] datetime,
  [telefono] decimal(18,0),
  [mail] nvarchar(255),
  [nacimiento] date,
  [id_localidad] int,
  [id_provincia] int,
  PRIMARY KEY ([id_cliente]),
  CONSTRAINT [FK_id_localidad_en_cliente.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [REJUNTESA].[localidad]([id_localidad]),
  CONSTRAINT [FK_id_provincia_en_cliente.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [REJUNTESA].[provincia]([id_provincia])
);

CREATE TABLE [REJUNTESA].[detalle_pago] (
  [id_detalle_pago] int IDENTITY(1,1),
  [id_cliente] int,
  [nro_tarjeta] nvarchar(255),
  [vencimiento_tarjeta] datetime,
  [cuotas] decimal(18,0),
  PRIMARY KEY ([id_detalle_pago]),
  CONSTRAINT [FK_id_cliente.id_cliente]
    FOREIGN KEY ([id_cliente])
      REFERENCES [REJUNTESA].[cliente]([id_cliente])
);

CREATE TABLE [REJUNTESA].[supermercado] (
  [id_supermercado] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  [razon_social] nvarchar(255),
  [cuit] nvarchar(255),
  [iibb] nvarchar(255),
  [domicilio] nvarchar(255),
  [fecha_inicio_actividad] datetime,
  [comision_fiscal] nvarchar(255),
  [id_localidad] int,
  [id_provincia] int,
  PRIMARY KEY ([id_supermercado]),
  CONSTRAINT [FK_id_localidad_en_supermercado.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [REJUNTESA].[localidad]([id_localidad]),
  CONSTRAINT [FK_id_provincia_en_supermercado.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [REJUNTESA].[provincia]([id_provincia])
);

CREATE TABLE [REJUNTESA].[sucursal] (
  [id_sucursal] int IDENTITY(1,1),
  [id_supermercado] int,
  [nombre] nvarchar(255),
  [direccion] nvarchar(255),
  [id_localidad] int,
  [id_provincia] int,
  PRIMARY KEY ([id_sucursal]),
  CONSTRAINT [FK_id_supermercado.id_supermercado]
    FOREIGN KEY ([id_supermercado])
      REFERENCES [REJUNTESA].[supermercado]([id_supermercado]),
  CONSTRAINT [FK_id_localidad.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [REJUNTESA].[localidad]([id_localidad]),
  CONSTRAINT [FK_id_provincia.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [REJUNTESA].[provincia]([id_provincia])
);

CREATE TABLE [REJUNTESA].[tipo_caja] (
  [id_tipo_caja] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_tipo_caja])
);


CREATE TABLE [REJUNTESA].[caja] (
  [nro_caja] decimal(18,0),
  [id_sucursal] int,
  [id_tipo_caja] int,
  PRIMARY KEY ([nro_caja], [id_sucursal]),
  CONSTRAINT [FK_id_sucursal_en_caja.id_sucursal]
    FOREIGN KEY ([id_sucursal])
      REFERENCES [REJUNTESA].[sucursal]([id_sucursal]),
  CONSTRAINT [FK_id_tipo_caja.id_tipo_caja]
    FOREIGN KEY ([id_tipo_caja])
      REFERENCES [REJUNTESA].[tipo_caja]([id_tipo_caja])
);

CREATE TABLE [REJUNTESA].[empleado] (
  [legajo_empleado] decimal(18,0),
  [id_sucursal] int,
  [dni] decimal(18,0),
  [nombre] nvarchar(255),
  [apellido] nvarchar(255),
  [telefono] decimal(18,0),
  [mail] nvarchar(255),
  [nacimiento] date,
  [registro] datetime,
  PRIMARY KEY ([legajo_empleado]),
  CONSTRAINT [FK_id_sucursal_en_empleado.id_sucursal]
    FOREIGN KEY ([id_sucursal])
      REFERENCES [REJUNTESA].[sucursal]([id_sucursal])
);

CREATE TABLE [REJUNTESA].[venta] (
  [nro_ticket] decimal(18,0),
  [id_sucursal] int,
  [nro_caja] decimal(18,0),
  [legajo_empleado] decimal(18,0),
  [fecha] datetime,
  [tipo_comprobante] nvarchar(255),
  [sub_total] decimal(18,2),
  [descuento_promociones] decimal(18,2),
  [descuento_medio] decimal(18,2),
  [total] decimal(18,2),
  PRIMARY KEY ([nro_ticket]),
  CONSTRAINT [FK_id_sucursal_en_venta.id_sucursal]
    FOREIGN KEY ([id_sucursal])
      REFERENCES [REJUNTESA].[sucursal]([id_sucursal]),
  CONSTRAINT [FK_venta_nro_caja_id_sucursal]
    FOREIGN KEY ([nro_caja], [id_sucursal])
      REFERENCES [REJUNTESA].[caja]([nro_caja], [id_sucursal]),
  CONSTRAINT [FK_legajo_empleado.legajo_empleado]
    FOREIGN KEY ([legajo_empleado])
      REFERENCES [REJUNTESA].[empleado]([legajo_empleado])
);

CREATE TABLE [REJUNTESA].[pago] (
  [nro_pago] int IDENTITY(1,1),
  [nro_ticket] decimal(18,0),
  [id_medio_pago] int,
  [id_detalle_pago] int,
  [fecha_pago] datetime,
  [importe] decimal(18,2),
  [descuento_aplicado] decimal(18,2),
  PRIMARY KEY ([nro_pago]),
  CONSTRAINT [FK_nro_ticket.nro_ticket]
    FOREIGN KEY ([nro_ticket])
      REFERENCES [REJUNTESA].[venta]([nro_ticket]),
  CONSTRAINT [FK_id_medio_pago.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [REJUNTESA].[medio_pago]([id_medio_pago]),
  CONSTRAINT [FK_id_detalle_pago.id_detalle_pago]
    FOREIGN KEY ([id_detalle_pago])
      REFERENCES [REJUNTESA].[detalle_pago]([id_detalle_pago])
);

CREATE TABLE [REJUNTESA].[envio] (
  [id_envio] int IDENTITY(1,1),
  [nro_ticket] decimal(18,0),
  [id_cliente] int,
  [fecha_programada] datetime,
  [hora_rango_inicio] decimal(18,0),
  [hora_rango_final] decimal(18,0),
  [costo] decimal(18,2),
  [estado] nvarchar(255),
  [fecha_entrega] datetime,
  PRIMARY KEY ([id_envio]),
  CONSTRAINT [FK_id_cliente_en_envio.id_cliente]
    FOREIGN KEY ([id_cliente])
      REFERENCES [REJUNTESA].[cliente]([id_cliente]),
  CONSTRAINT [FK_nro_ticket_en_envio.nro_ticket]
    FOREIGN KEY ([nro_ticket])
      REFERENCES [REJUNTESA].[venta]([nro_ticket])
);

CREATE TABLE [REJUNTESA].[producto_vendido] (
  [nro_ticket] decimal(18,0),
  [id_producto] int,
  [cantidad] decimal(18,0),
  [precio_total] decimal(18,2),
  PRIMARY KEY ([nro_ticket], [id_producto]),
  CONSTRAINT [FK_id_producto.id_producto]
    FOREIGN KEY ([id_producto])
      REFERENCES [REJUNTESA].[producto]([id_producto]),
  CONSTRAINT [FK_nro_ticket_en_producto_vendido.nro_ticket]
    FOREIGN KEY ([nro_ticket])
      REFERENCES [REJUNTESA].[venta]([nro_ticket])
);

CREATE TABLE [REJUNTESA].[promocion_aplicada] (
  [nro_ticket] decimal(18,0),
  [id_producto] int,
  [cod_promocion] int,
  [descuento_total] decimal(18,2),
  PRIMARY KEY ([nro_ticket], [id_producto], [cod_promocion]),
  CONSTRAINT [FK_nro_ticket_en_promocion_aplicada.nro_ticket]
    FOREIGN KEY ([nro_ticket],[id_producto])
      REFERENCES [REJUNTESA].[producto_vendido]([nro_ticket],[id_producto]),
  CONSTRAINT [FK_cod_promocion.cod_promocion]
    FOREIGN KEY ([cod_promocion])
      REFERENCES [REJUNTESA].[promocion_producto]([cod_promocion])
);

-- Intermedias

CREATE TABLE [REJUNTESA].[producto_x_promocion_producto] (
  [id_producto] int,
  [cod_promocion] int,
  PRIMARY KEY ([id_producto], [cod_promocion]),
  CONSTRAINT [FK_id_producto_en_producto_x_promocion_producto.id_producto]
    FOREIGN KEY ([id_producto])
      REFERENCES [REJUNTESA].[producto]([id_producto]),
  CONSTRAINT [FK_cod_promocion_en_producto_x_promocion_producto.cod_promocion]
    FOREIGN KEY ([cod_promocion])
      REFERENCES [REJUNTESA].[promocion_producto]([cod_promocion])
);

CREATE TABLE [REJUNTESA].[promocion_producto_x_regla] (
  [cod_promocion] int,
  [id_regla] int,
  PRIMARY KEY ([cod_promocion], [id_regla]),
  CONSTRAINT [FK_cod_promocion_en_promocion_producto_x_regla.cod_promocion]
    FOREIGN KEY ([cod_promocion])
      REFERENCES [REJUNTESA].[promocion_producto]([cod_promocion]),
  CONSTRAINT [FK_id_regla.id_regla]
    FOREIGN KEY ([id_regla])
      REFERENCES [REJUNTESA].[regla]([id_regla])
);

CREATE TABLE [REJUNTESA].[descuento_x_medio_pago] (
  [id_medio_pago ] int,
  [cod_descuento] int,
  PRIMARY KEY ([id_medio_pago], [cod_descuento]),
  CONSTRAINT [FK_id_medio_pago_en_descuento_x_medio_pago.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [REJUNTESA].[medio_pago]([id_medio_pago]),
  CONSTRAINT [FK_cod_descuento.cod_descuento]
    FOREIGN KEY ([cod_descuento])
      REFERENCES [REJUNTESA].[descuento_medio_pago]([cod_descuento])
);

-- FIN: CREACION DE TABLAS

-- INICIO: NORMALIZACION DE DATOS - STORED PROCEDURES.


GO
CREATE PROCEDURE [REJUNTESA].migrar_tipo_caja 
AS 
BEGIN
  INSERT INTO [REJUNTESA].tipo_caja(nombre)
  SELECT DISTINCT
    CAJA_TIPO as nombre
  FROM gd_esquema.Maestra
  WHERE CAJA_TIPO is not null

  IF @@ERROR != 0
  PRINT('SP TIPO CAJA FAIL!')
  ELSE
  PRINT('SP TIPO CAJA OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_categoria 
AS 
BEGIN
  INSERT INTO [REJUNTESA].categoria(categoria)
  SELECT DISTINCT
    PRODUCTO_CATEGORIA as categoria
  FROM gd_esquema.Maestra
  WHERE PRODUCTO_CATEGORIA is not null

  IF @@ERROR != 0
  PRINT('SP CATEGORIA FAIL!')
  ELSE
  PRINT('SP CATEGORIA OK!')
END


GO
CREATE PROCEDURE [REJUNTESA].migrar_subcategoria 
AS 
BEGIN
  INSERT INTO [REJUNTESA].subcategoria(id_categoria, subcategoria)
  SELECT DISTINCT
    c.id_categoria,
    PRODUCTO_SUB_CATEGORIA as subcategoria
  FROM gd_esquema.Maestra
  JOIN categoria c ON c.categoria = PRODUCTO_CATEGORIA
  WHERE 
  PRODUCTO_CATEGORIA      is not null and
  PRODUCTO_SUB_CATEGORIA  is not null
  IF @@ERROR != 0
  PRINT('SP SUBCATEGORIA FAIL!')
  ELSE
  PRINT('SP SUBCATEGORIA OK!')
END


GO
CREATE PROCEDURE [REJUNTESA].migrar_producto 
AS 
BEGIN
  INSERT INTO [REJUNTESA].producto(id_subcategoria, nombre, descripcion, precio, marca)
  SELECT DISTINCT
    sc.id_subcategoria    as id_subcategoria,
    PRODUCTO_NOMBRE       as nombre,
    PRODUCTO_DESCRIPCION  as descripcion,
    PRODUCTO_PRECIO       as precio,
    PRODUCTO_MARCA        as marca
  FROM gd_esquema.Maestra
  JOIN subcategoria sc ON sc.subcategoria = PRODUCTO_SUB_CATEGORIA
  WHERE 
  PRODUCTO_SUB_CATEGORIA  is not null and
  PRODUCTO_NOMBRE         is not null and
  PRODUCTO_DESCRIPCION    is not null and
  PRODUCTO_PRECIO         is not null and
  PRODUCTO_MARCA          is not null
  IF @@ERROR != 0
  PRINT('SP PRODUCTO FAIL!')
  ELSE
  PRINT('SP PRODUCTO OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_regla 
AS 
BEGIN
  INSERT INTO [REJUNTESA].regla(descripcion, descuento, cantidad_aplicable_regla, cantidad_aplicable_descuento, veces_aplicable, misma_marca, mismo_producto)
  SELECT DISTINCT
    REGLA_DESCRIPCION               as descripcion,
    REGLA_DESCUENTO_APLICABLE_PROD  as descuento,
    REGLA_CANT_APLICABLE_REGLA      as cantidad_aplicable_regla,
    REGLA_CANT_APLICA_DESCUENTO     as cantidad_aplicable_descuento,
    REGLA_CANT_APLICABLE_REGLA      as veces_aplicable,
    REGLA_APLICA_MISMA_MARCA        as misma_marca,
    REGLA_APLICA_MISMO_PROD         as mismo_producto
  FROM gd_esquema.Maestra
  WHERE 
  PRODUCTO_SUB_CATEGORIA is not null and
  PRODUCTO_NOMBRE        is not null and
  PRODUCTO_DESCRIPCION   is not null and
  PRODUCTO_PRECIO        is not null and
  PRODUCTO_MARCA         is not null
  IF @@ERROR != 0
  PRINT('SP REGLA FAIL!')
  ELSE
  PRINT('SP REGLA OK!')
END


GO
CREATE PROCEDURE [REJUNTESA].migrar_promocion_producto 
AS 
BEGIN
  INSERT INTO [REJUNTESA].promocion_producto(descripcion, fecha_inicio, fecha_final)
  SELECT DISTINCT
    PROMOCION_DESCRIPCION   as descripcion,
    PROMOCION_FECHA_INICIO  as fecha_inicio,
    PROMOCION_FECHA_FIN     as fecha_final
  FROM gd_esquema.Maestra
  WHERE 
  PROMOCION_DESCRIPCION  is not null and
  PROMOCION_FECHA_INICIO is not null and
  PROMOCION_FECHA_FIN    is not null
  IF @@ERROR != 0
  PRINT('SP PROMOCION FAIL!')
  ELSE
  PRINT('SP PROMOCION OK!')
END


GO
CREATE PROCEDURE [REJUNTESA].migrar_medio_pago 
AS 
BEGIN
  INSERT INTO [REJUNTESA].medio_pago(tipo, nombre)
  SELECT DISTINCT
    PAGO_TIPO_MEDIO_PAGO  as tipo,
    PAGO_MEDIO_PAGO       as nombre
  FROM gd_esquema.Maestra
  WHERE 
  PAGO_MEDIO_PAGO      is not null and
  PAGO_TIPO_MEDIO_PAGO is not null
  IF @@ERROR != 0
  PRINT('SP MEDIO PAGO FAIL!')
  ELSE
  PRINT('SP MEDIO PAGO OK!')
END

SELECT TOP 1000 [SUPER_NOMBRE]
      ,[SUPER_RAZON_SOC]
      ,[SUPER_CUIT]
      ,[SUPER_IIBB]
      ,[SUPER_DOMICILIO]
      ,[SUPER_FECHA_INI_ACTIVIDAD]
      ,[SUPER_CONDICION_FISCAL]
      ,[SUPER_LOCALIDAD]
      ,[SUPER_PROVINCIA]
      ,[SUCURSAL_NOMBRE]
      ,[SUCURSAL_DIRECCION]
      ,[SUCURSAL_LOCALIDAD]
      ,[SUCURSAL_PROVINCIA]
      ,[TICKET_NUMERO]
      ,[TICKET_FECHA_HORA]
      ,[TICKET_TIPO_COMPROBANTE]
      ,[TICKET_SUBTOTAL_PRODUCTOS]
      ,[TICKET_TOTAL_DESCUENTO_APLICADO]
      ,[TICKET_TOTAL_DESCUENTO_APLICADO_MP]
      ,[TICKET_TOTAL_ENVIO]
      ,[TICKET_TOTAL_TICKET]
      ,[EMPLEADO_NOMBRE]
      ,[EMPLEADO_APELLIDO]
      ,[EMPLEADO_DNI]
      ,[EMPLEADO_FECHA_REGISTRO]
      ,[EMPLEADO_TELEFONO]
      ,[EMPLEADO_MAIL]
      ,[EMPLEADO_FECHA_NACIMIENTO]
      ,[CAJA_NUMERO]
      ,[CAJA_TIPO]
      ,[TICKET_DET_CANTIDAD]
      ,[TICKET_DET_PRECIO]
      ,[TICKET_DET_TOTAL]
      ,[PRODUCTO_NOMBRE]
      ,[PRODUCTO_DESCRIPCION]
      ,[PRODUCTO_PRECIO]
      ,[PRODUCTO_MARCA]
      ,[PRODUCTO_SUB_CATEGORIA]
      ,[PRODUCTO_CATEGORIA]
      ,[PROMO_APLICADA_DESCUENTO]
      ,[PROMO_CODIGO]
      ,[PROMOCION_DESCRIPCION]
      ,[PROMOCION_FECHA_INICIO]
      ,[PROMOCION_FECHA_FIN]
      ,[REGLA_APLICA_MISMA_MARCA]
      ,[REGLA_APLICA_MISMO_PROD]
      ,[REGLA_CANT_APLICA_DESCUENTO]
      ,[REGLA_CANT_APLICABLE_REGLA]
      ,[REGLA_CANT_MAX_PROD]
      ,[REGLA_DESCRIPCION]
      ,[REGLA_DESCUENTO_APLICABLE_PROD]
      ,[PAGO_FECHA]
      ,[PAGO_IMPORTE]
      ,[PAGO_MEDIO_PAGO]
      ,[PAGO_TIPO_MEDIO_PAGO]
      ,[PAGO_TARJETA_NRO]
      ,[PAGO_TARJETA_CUOTAS]
      ,[PAGO_TARJETA_FECHA_VENC]
      ,[PAGO_DESCUENTO_APLICADO]
      ,[DESCUENTO_CODIGO]
      ,[DESCUENTO_DESCRIPCION]
      ,[DESCUENTO_FECHA_INICIO]
      ,[DESCUENTO_FECHA_FIN]
      ,[DESCUENTO_PORCENTAJE_DESC]
      ,[DESCUENTO_TOPE]
      ,[ENVIO_COSTO]
      ,[ENVIO_FECHA_PROGRAMADA]
      ,[ENVIO_HORA_INICIO]
      ,[ENVIO_HORA_FIN]
      ,[ENVIO_FECHA_ENTREGA]
      ,[ENVIO_ESTADO]
      ,[CLIENTE_NOMBRE]
      ,[CLIENTE_APELLIDO]
      ,[CLIENTE_DNI]
      ,[CLIENTE_FECHA_REGISTRO]
      ,[CLIENTE_TELEFONO]
      ,[CLIENTE_MAIL]
      ,[CLIENTE_FECHA_NACIMIENTO]
      ,[CLIENTE_DOMICILIO]
      ,[CLIENTE_LOCALIDAD]
      ,[CLIENTE_PROVINCIA]
  FROM [GD1C2024].[gd_esquema].[Maestra]
  
GO
CREATE PROCEDURE [REJUNTESA].migrar_localidad
AS 
BEGIN
	INSERT INTO [REJUNTESA].localidad(nombre, id_provincia)
	(SELECT DISTINCT CLIENTE_LOCALIDAD, p.id_provincia FROM gd_esquema.Maestra
	 JOIN provincia p on p.nombre = CLIENTE_PROVINCIA
	 WHERE CLIENTE_LOCALIDAD is not null
	 and CLIENTE_PROVINCIA is not null)
     UNION 
    (SELECT DISTINCT SUPER_LOCALIDAD, p.id_provincia 
	FROM gd_esquema.Maestra
	 JOIN provincia p on p.nombre = SUPER_PROVINCIA
	 WHERE SUPER_LOCALIDAD is not null
	 and SUPER_PROVINCIA is not null)
	UNION 
    (SELECT DISTINCT SUCURSAL_LOCALIDAD, p.id_provincia
	 FROM gd_esquema.Maestra 
	 JOIN REJUNTESA.provincia p on p.nombre = SUCURSAL_PROVINCIA
	 WHERE SUCURSAL_LOCALIDAD is not null
	 and SUCURSAL_PROVINCIA is not null)
	IF @@ERROR != 0
	PRINT('SP LOCALIDAD FAIL!')
	ELSE
	PRINT('SP LOCALIDAD OK!')
END

GO
CREATE PROCEDURE [REJUNTESA].migrar_provincia
AS 
BEGIN
	INSERT INTO [REJUNTESA].provincia(nombre)
	(SELECT DISTINCT CLIENTE_PROVINCIA as nombre 
	FROM gd_esquema.Maestra 
	WHERE CLIENTE_PROVINCIA is not null)
    UNION 
    (SELECT DISTINCT SUPER_PROVINCIA
	 FROM gd_esquema.Maestra 
	 WHERE SUPER_PROVINCIA is not null)
	UNION 
    (SELECT DISTINCT SUCURSAL_PROVINCIA
	 FROM gd_esquema.Maestra 
	 WHERE SUCURSAL_PROVINCIA is not null)
	IF @@ERROR != 0
	PRINT('SP PROVINCIA FAIL!')
	ELSE
	PRINT('SP PROVINCIA OK!')
END

CREATE TABLE [REJUNTESA].[cliente] (
  [id_cliente] int IDENTITY(1,1),
  [dni] decimal(18,0),
  [nombre] nvarchar(255),
  [apellido] nvarchar(255),
  [domicilio] nvarchar(255),
  [registro] datetime,
  [telefono] decimal(18,0),
  [mail] nvarchar(255),
  [nacimiento] date,
  [id_localidad] int,
  [id_provincia] int,
  PRIMARY KEY ([id_cliente]),
  CONSTRAINT [FK_id_localidad_en_cliente.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [REJUNTESA].[localidad]([id_localidad]),
  CONSTRAINT [FK_id_provincia_en_cliente.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [REJUNTESA].[provincia]([id_provincia])
);


GO
CREATE PROCEDURE [REJUNTESA].migrar_cliente 
AS 
BEGIN
  INSERT INTO [REJUNTESA].cliente(dni, nombre, apellido, domicilio, registro, telefono, mail, nacimiento, id_localidad, id_provincia)
  SELECT DISTINCT
    CLIENTE_NOMBRE              as dni,
    CLIENTE_APELLIDO            as nombre,
    CLIENTE_DNI                 as apellido,
    CLIENTE_FECHA_REGISTRO      as domicilio,
    CLIENTE_TELEFONO            as registro,
    CLIENTE_MAIL                as telefono,
    CLIENTE_FECHA_NACIMIENTO    as mail,
    CLIENTE_DOMICILIO           as nacimiento,
    CLIENTE_LOCALIDAD           as id_localidad,
    CLIENTE_PROVINCIA           as id_provincia
  FROM gd_esquema.Maestra
  WHERE 
    CLIENTE_NOMBRE            is not null and
    CLIENTE_APELLIDO          is not null and
    CLIENTE_DNI               is not null and
    CLIENTE_FECHA_REGISTRO    is not null and
    CLIENTE_TELEFONO          is not null and
    CLIENTE_MAIL              is not null and
    CLIENTE_FECHA_NACIMIENTO  is not null and
    CLIENTE_DOMICILIO         is not null and
    CLIENTE_LOCALIDAD         is not null and
    CLIENTE_PROVINCIA         is not null
  IF @@ERROR != 0
  PRINT('SP MIGRAR CLIENTE FAIL!')
  ELSE
  PRINT('SP MIGRAR CLIENTE OK!')
END


-- FIN: NORMALIZACION DE DATOS - STORED PROCEDURES.

-- INICIO: EJECUCION DE PROCEDURES.

GO
EXEC REJUNTESA.migrar_tipo_caja

GO
EXEC REJUNTESA.migrar_categoria

GO
EXEC REJUNTESA.migrar_subcategoria

GO
EXEC REJUNTESA.migrar_producto

GO
EXEC REJUNTESA.migrar_regla

GO
EXEC REJUNTESA.migrar_promocion_producto

GO
EXEC REJUNTESA.migrar_medio_pago

-- FIN: EJECUCION DE PROCEDURES.

SELECT * FROM [GD1C2024].[REJUNTESA].[medio_pago];
SELECT * FROM [GD1C2024].[REJUNTESA].[promocion_producto];
SELECT * FROM [GD1C2024].[REJUNTESA].[producto];
SELECT * FROM [GD1C2024].[REJUNTESA].[subcategoria];
SELECT * FROM [GD1C2024].[REJUNTESA].[categoria];
SELECT * FROM [GD1C2024].[REJUNTESA].[tipo_caja];
SELECT * FROM [GD1C2024].[REJUNTESA].[regla];
