USE [GD1C2024]

SELECT
    v.nro_ticket,
    v.sub_total,
    v.total,
    SUM(e.costo) as envios
FROM REJUNTESA.venta as v

LEFT OUTER JOIN REJUNTESA.envio e ON v.nro_ticket = e.nro_ticket

GROUP BY v.nro_ticket,v.sub_total,
    v.total

SELECT ENVIO_COSTO, PAGO_IMPORTE FROM gd_esquema.Maestra
WHERE TICKET_NUMERO = 1353722924 AND
    (PAGO_IMPORTE is not null or
     ENVIO_COSTO is not null)

SELECT * FROM REJUNTESA.pago where nro_ticket = 1353722924

SELECT * FROM REJUNTESA.envio where nro_ticket = 1353722924

SELECT sub_total - descuento_promociones - descuento_medio - total as dif, * FROM REJUNTESA.venta where nro_ticket = 1353722924

SELECT * FROM REJUNTESA.medio_pago