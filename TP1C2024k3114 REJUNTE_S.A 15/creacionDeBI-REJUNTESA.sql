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
      REFERENCES [REJUNTESA].[BI_ubicacion]([id_ubicacion])
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
        REFERENCES [REJUNTESA].[BI_ubicacion]([id_ubicacion]),
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
        REFERENCES [REJUNTESA].[BI_ubicacion]([id_ubicacion])
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