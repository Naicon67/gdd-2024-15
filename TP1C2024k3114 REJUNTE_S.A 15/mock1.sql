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

SELECT DISTINCT TICKET_TIPO_COMPROBANTE
FROM gd_esquema.Maestra

SELECT * FROM REJUNTESA.pago where nro_ticket = 1353722924

SELECT * FROM REJUNTESA.envio where nro_ticket = 1353722924

SELECT TICKET_TIPO_COMPROBANTE, SUM(TICKET_TOTAL_TICKET), TICKET_NUMERO,
    COUNT(*) OVER (PARTITION BY TICKET_NUMERO) as repe
FROM gd_esquema.Maestra
GROUP BY TICKET_NUMERO, TICKET_TIPO_COMPROBANTE
ORDER BY repe DESC