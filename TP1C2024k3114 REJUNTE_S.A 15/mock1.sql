USE [GD1C2024]

SELECT
    sub_total,
    descuento_promociones,
    descuento_medio,
    total,
    total_costo_envios,
    nro_ticket
FROM REJUNTESA.venta
WHERE id_venta = 1

SELECT
    *
FROM REJUNTESA.pago
WHERE id_venta = 1

SELECT
    SUM(precio_total)
FROM REJUNTESA.producto_vendido
WHERE id_venta = 1

SELECT
    *
FROM REJUNTESA.producto_vendido
WHERE id_venta = 1

SELECT
    *
FROM REJUNTESA.promocion_aplicada
WHERE id_venta = 1