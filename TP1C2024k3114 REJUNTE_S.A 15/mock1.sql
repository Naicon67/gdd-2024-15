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

SELECT CLIENTE_DNI, CLIENTE_APELLIDO, CLIENTE_DOMICILIO, CLIENTE_FECHA_REGISTRO, CLIENTE_MAIL, CLIENTE_NOMBRE, CLIENTE_TELEFONO FROM gd_esquema.Maestra
WHERE TICKET_NUMERO = 1354414840

SELECT * FROM REJUNTESA.pago where nro_ticket = 1353722924

SELECT * FROM REJUNTESA.envio where nro_ticket = 1353722924

SELECT sub_total - descuento_promociones - descuento_medio - total as dif, * FROM REJUNTESA.venta where nro_ticket = 1353722924

SELECT * FROM REJUNTESA.medio_pago

SELECT * FROM REJUNTESA.detalle_pago WHERE id_cliente is null

SELECT * FROM REJUNTESA.pago where id_detalle_pago = 5776