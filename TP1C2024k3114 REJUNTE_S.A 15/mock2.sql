USE [GD1C2024]

SELECT
    id_rango_cliente as [Rango etario de los clientes],
    SUM(importe_cuota_promedio * cantidad_pagos_cuotas) / SUM(cantidad_pagos_cuotas) as [Promedio importe cuota ($)]
FROM [REJUNTESA].BI_pago
GROUP BY id_rango_cliente

SELECT
    AVG(importe/cuotas) as ic,
    [REJUNTESA].obtener_rango_etario_cliente(dp.id_cliente, p.fecha_pago) as rango
FROM REJUNTESA.pago p
LEFT JOIN [REJUNTESA].detalle_pago dp on dp.id_detalle_pago = p.id_detalle_pago
JOIN [REJUNTESA].BI_tiempo t ON MONTH(p.fecha_pago) = t.mes AND YEAR(p.fecha_pago) = t.anio
LEFT JOIN REJUNTESA.cliente c ON dp.id_cliente = c.id_cliente
JOIN [REJUNTESA].venta v ON v.id_venta = p.id_venta
WHERE cuotas > 1
GROUP BY [REJUNTESA].obtener_rango_etario_cliente(dp.id_cliente, p.fecha_pago)