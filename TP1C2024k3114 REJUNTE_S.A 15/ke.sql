USE [GD1C2024]

/*SELECT DISTINCT
      PRODUCTO_NOMBRE,
      PRODUCTO_MARCA,
      PRODUCTO_PRECIO,
      TICKET_DET_PRECIO
FROM [gd_esquema].[Maestra]
WHERE PRODUCTO_PRECIO != TICKET_DET_PRECIO*/

--WHERE TICKET_NUMERO = 1351318368--1351426113--1351318349--1353722924--1352375255

SELECT 
      p.id_medio_pago,
      t.id_tiempo,
      v.id_sucursal, 
      CASE
            WHEN dp.id_cliente IS NOT NULL THEN [REJUNTESA].obtener_rango_etario_cliente(dp.id_cliente, p.fecha_pago)
            ELSE NULL
      END as id_rango_cliente,
      SUM(CASE
            WHEN dp.cuotas is not null AND dp.cuotas > 1 THEN p.importe
            ELSE 0
      END) as suma_importe_cuotas,
      SUM(CASE
            WHEN dp.cuotas is null OR dp.cuotas <= 1 THEN p.importe
            ELSE 0
      END) as suma_importe_contado
FROM [REJUNTESA].pago p
JOIN [REJUNTESA].medio_pago mp on mp.id_medio_pago = p.id_medio_pago
JOIN [REJUNTESA].venta v ON v.id_venta = p.id_venta
LEFT JOIN [REJUNTESA].detalle_pago dp on dp.id_detalle_pago = p.id_detalle_pago
JOIN [REJUNTESA].BI_tiempo t ON MONTH(p.fecha_pago) = t.mes AND YEAR(p.fecha_pago) = t.anio
GROUP BY
      p.id_medio_pago,
      t.id_tiempo,
      v.id_sucursal,
      CASE
            WHEN dp.id_cliente IS NOT NULL THEN [REJUNTESA].obtener_rango_etario_cliente(dp.id_cliente, p.fecha_pago)
            ELSE NULL
      END