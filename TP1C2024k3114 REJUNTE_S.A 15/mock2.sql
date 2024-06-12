/*USE [GD1C2024]

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

SELECT
    nro_ticket,
    MIN(fecha_p) as fecha,
    tipo_comprobante,
    SUM(sub_total_p) as sub_total,
    SUM(descuento_promociones_p) as descuento_promociones,
    SUM(descuento_medio_p) as descuento_medio,
    SUM(total_p) as total,
    SUM(total_costo_envios_p) as total_costo_envios
FROM (SELECT
        TICKET_NUMERO                           as nro_ticket,
        MIN(TICKET_FECHA_HORA)                  as fecha_p,
        MAX(TICKET_TIPO_COMPROBANTE)            as tipo_comprobante,
        MAX(TICKET_SUBTOTAL_PRODUCTOS)          as sub_total_p,
        MAX(TICKET_TOTAL_DESCUENTO_APLICADO)    as descuento_promociones_p,
        MAX(TICKET_TOTAL_DESCUENTO_APLICADO_MP) as descuento_medio_p,
        MAX(TICKET_TOTAL_TICKET)                as total_p,
        MAX(TICKET_TOTAL_ENVIO) as total_costo_envios_p
    FROM [GD1C2024].[gd_esquema].[Maestra] as p
    GROUP BY TICKET_NUMERO, TICKET_TOTAL_TICKET, TICKET_TOTAL_ENVIO) as v
GROUP BY nro_ticket, tipo_comprobante