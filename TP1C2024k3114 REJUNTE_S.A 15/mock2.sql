USE [GD1C2024]

SELECT
    v.id_venta                    as id_venta,
    p.id_producto                 as id_producto,
    PROMO_CODIGO                  as cod_promocion,
    SUM(PROMO_APLICADA_DESCUENTO) as descuento_total
FROM gd_esquema.Maestra
JOIN REJUNTESA.categoria c ON PRODUCTO_CATEGORIA = c.categoria
  JOIN REJUNTESA.subcategoria s ON
      s.subcategoria = PRODUCTO_SUB_CATEGORIA AND
      s.id_categoria = c.id_categoria
JOIN REJUNTESA.producto p ON
    s.id_subcategoria = p.id_subcategoria AND
    PRODUCTO_NOMBRE = p.nombre AND
    PRODUCTO_DESCRIPCION = p.descripcion AND
    PRODUCTO_PRECIO = p.precio AND
    PRODUCTO_MARCA = p.marca
JOIN REJUNTESA.supermercado sup ON SUPER_NOMBRE = sup.nombre
JOIN REJUNTESA.sucursal suc ON SUCURSAL_NOMBRE = suc.nombre AND SUPER_NOMBRE = sup.nombre
JOIN REJUNTESA.venta v ON
    TICKET_NUMERO = v.nro_ticket AND
    SUCURSAL_NOMBRE = suc.nombre AND
    TICKET_FECHA_HORA = v.fecha
WHERE PROMO_CODIGO is not null
GROUP BY v.id_venta, p.id_producto, PROMO_CODIGO