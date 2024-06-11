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
    TICKET_NUMERO                as nro_ticket,
    MAX(CAJA_NUMERO)             as nro_caja,
    MAX(s.id_sucursal)           as id_sucursal,
    MAX(e.legajo_empleado)       as legajo_empleado,
    MAX(mp.id_medio_pago)        as id_medio_pago,
    MAX(dp.id_detalle_pago)      as id_detalle_pago,
    MAX(PAGO_FECHA)              as fecha_pago,
    MAX(PAGO_IMPORTE)            as importe,
    MAX(PAGO_DESCUENTO_APLICADO) as descuento_aplicado
FROM [GD1C2024].[gd_esquema].[Maestra]

JOIN REJUNTESA.supermercado sup ON SUPER_NOMBRE = sup.nombre
JOIN REJUNTESA.sucursal s ON SUCURSAL_NOMBRE = s.nombre AND SUPER_NOMBRE = sup.nombre
LEFT OUTER JOIN REJUNTESA.empleado e ON e.dni = EMPLEADO_DNI
LEFT OUTER JOIN [GD1C2024].REJUNTESA.medio_pago mp ON mp.nombre = PAGO_MEDIO_PAGO
LEFT OUTER JOIN REJUNTESA.detalle_pago dp ON
    dp.nro_tarjeta = PAGO_TARJETA_NRO AND
    dp.cuotas = PAGO_TARJETA_CUOTAS AND
    dp.vencimiento_tarjeta = PAGO_TARJETA_FECHA_VENC

WHERE (PAGO_IMPORTE is not null OR CAJA_NUMERO is not null)

GROUP BY TICKET_NUMERO, TICKET_TOTAL_TICKET

ORDER BY TICKET_NUMERO