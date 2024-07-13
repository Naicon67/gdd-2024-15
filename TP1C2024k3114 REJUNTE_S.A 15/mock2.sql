USE [GD1C2024]

SELECT
    id_medio_pago,
    cuotas
FROM [REJUNTESA].pago p
LEFT JOIN [REJUNTESA].detalle_pago dp ON p.id_detalle_pago = dp.id_detalle_pago
WHERE id_medio_pago != 1
ORDER BY cuotas