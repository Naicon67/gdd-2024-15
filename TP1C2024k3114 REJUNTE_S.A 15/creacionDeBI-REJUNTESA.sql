USE [GD1C2024]
GO

-- Crea dimension TIEMPO (mes - cuatrimestre - año)
CREATE TABLE REJUNTESA.BI_tiempo (
    id INT IDENTITY(1,1),
    mes INT,
    anio INT,
    cuatri INT,
    PRIMARY KEY (id)
);

-- Crea dimension UBICACION (localidad - provincia)
CREATE TABLE REJUNTESA.BI_ubicacion (
    id INT IDENTITY(1,1),
    mes INT,
    anio INT,
    cuatri INT,
    PRIMARY KEY (id)
);