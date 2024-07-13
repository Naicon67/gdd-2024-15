USE [GD1C2024]

/*SELECT DISTINCT
      PRODUCTO_NOMBRE,
      PRODUCTO_MARCA,
      PRODUCTO_PRECIO,
      TICKET_DET_PRECIO
FROM [gd_esquema].[Maestra]
WHERE PRODUCTO_PRECIO != TICKET_DET_PRECIO*/

--WHERE TICKET_NUMERO = 1351318368--1351426113--1351318349--1353722924--1352375255
/*

SELECT
      AVG(importe/cuotas) as i_cuota,
      [REJUNTESA].obtener_rango_etario_cliente(c.id_cliente, p.fecha_pago) as rango
FROM [REJUNTESA].[pago] p
LEFT JOIN REJUNTESA.detalle_pago dp ON dp.id_detalle_pago = p.id_detalle_pago
LEFT JOIN REJUNTESA.cliente c ON dp.id_cliente = c.id_cliente
WHERE cuotas > 1
GROUP BY [REJUNTESA].obtener_rango_etario_cliente(c.id_cliente, p.fecha_pago)

*/

/* SELECT
      t.anio,
      t.cuatrimestre,
      [REJUNTESA].obtener_rango_etario_cliente(c.id_cliente, e.fecha_entrega) as rango,
      COUNT(*)
FROM REJUNTESA.envio e
LEFT JOIN REJUNTESA.cliente c ON c.id_cliente = e.id_cliente
JOIN [REJUNTESA].BI_tiempo t ON MONTH(e.fecha_entrega) = t.mes AND YEAR(e.fecha_entrega) = t.anio
GROUP BY
      t.anio,
      t.cuatrimestre,
      [REJUNTESA].obtener_rango_etario_cliente(c.id_cliente, e.fecha_entrega) */

SELECT
      SUM(CASE
            WHEN dp.cuotas is not null AND dp.cuotas > 1 THEN p.importe
            ELSE 0
      END) as suma_importe_cuotas,
      SUM(CASE
            WHEN dp.cuotas is null OR dp.cuotas <= 1 THEN p.importe
            ELSE 0
      END) as suma_importe_contado,
      SUM(CASE
            WHEN dp.cuotas is not null AND dp.cuotas > 1 THEN p.importe / dp.cuotas
            ELSE 0
      END)
            /
      SUM(CASE
            WHEN dp.cuotas is not null AND dp.cuotas > 1 THEN 1
            ELSE 0
      END) as importe_cuota_promedio
FROM REJUNTESA.pago p
LEFT JOIN [REJUNTESA].detalle_pago dp on dp.id_detalle_pago = p.id_detalle_pago
JOIN [REJUNTESA].BI_tiempo t ON MONTH(p.fecha_pago) = t.mes AND YEAR(p.fecha_pago) = t.anio
LEFT JOIN REJUNTESA.cliente c ON dp.id_cliente = c.id_cliente
JOIN [REJUNTESA].venta v ON v.id_venta = p.id_venta
GROUP BY
      p.id_medio_pago,
      t.id_tiempo,
      v.id_sucursal,
      [REJUNTESA].obtener_rango_etario_cliente(dp.id_cliente, p.fecha_pago)