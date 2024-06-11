USE [GD1C2024]

SELECT 
    TICKET_NUMERO                      as nro_ticket,
    MAX(CAJA_NUMERO)                   as nro_caja,
    TICKET_FECHA_HORA                  as fecha,
    TICKET_TIPO_COMPROBANTE            as tipo_comprobante,
    TICKET_SUBTOTAL_PRODUCTOS          as sub_total,
    TICKET_TOTAL_DESCUENTO_APLICADO    as descuento_promociones,
    TICKET_TOTAL_DESCUENTO_APLICADO_MP as descuento_medio,
    TICKET_TOTAL_TICKET                as total,
    SUM(ENVIO_COSTO)                  as total_costo_envios
FROM gd_esquema.Maestra as ma

GROUP BY TICKET_NUMERO, TICKET_SUBTOTAL_PRODUCTOS,
    TICKET_TOTAL_DESCUENTO_APLICADO,TICKET_TOTAL_DESCUENTO_APLICADO_MP,
    TICKET_TOTAL_TICKET, TICKET_FECHA_HORA, TICKET_TIPO_COMPROBANTE

ORDER BY total_costo_envios DESC

/*

TICKET_NUMERO                      as nro_ticket, 
s.id_sucursal                      as id_sucursal,
CAJA_NUMERO                        as nro_caja,
e.legajo_empleado                  as legajo_empleado,
TICKET_FECHA_HORA                  as fecha,
TICKET_TIPO_COMPROBANTE            as tipo_comprobante,
TICKET_SUBTOTAL_PRODUCTOS          as sub_total,
TICKET_TOTAL_DESCUENTO_APLICADO    as descuento_promociones,
TICKET_TOTAL_DESCUENTO_APLICADO_MP as descuento_medio,
TICKET_TOTAL_TICKET                as total,
ENVIO_COSTO as total_costo_envios

*/