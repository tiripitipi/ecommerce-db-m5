-- consultas típicas de un e-commerce para obtener información relevante

-- 1) todos los productos junto a su categoría
--    uso JOIN para combinar las dos tablas
SELECT
    p.id,
    p.nombre        AS producto,
    p.precio,
    c.nombre        AS categoria
FROM productos p
JOIN categorias c ON p.id_categoria = c.id
ORDER BY c.nombre, p.nombre;

-- 2) buscar productos por nombre
--    uso ILIKE para que no importe si está en mayúsculas o minúsculas
SELECT
    p.id,
    p.nombre,
    p.precio,
    c.nombre AS categoria
FROM productos p
JOIN categorias c ON p.id_categoria = c.id
WHERE p.nombre ILIKE '%wilson%'
ORDER BY p.nombre;

-- 3) filtrar productos por categoría
SELECT
    p.id,
    p.nombre,
    p.precio
FROM productos p
JOIN categorias c ON p.id_categoria = c.id
WHERE c.nombre = 'accesorios'
ORDER BY p.precio;

-- 4) mostrar los productos asociados a un pedido
--    junto con la cantidad y el subtotal de cada ítem
SELECT
    dp.id_pedido,
    p.nombre            AS producto,
    dp.cantidad,
    dp.precio_unitario,
    dp.cantidad * dp.precio_unitario AS subtotal
FROM detalle_pedidos dp
JOIN productos p ON dp.id_producto = p.id
WHERE dp.id_pedido = 1
ORDER BY p.nombre;

-- 5) calcular el total de un pedido
--    uso SUM para sumar todos los subtotales
SELECT
    pe.id               AS pedido,
    u.nombre            AS cliente,
    pe.fecha,
    pe.estado,
    SUM(dp.cantidad * dp.precio_unitario) AS total_calculado
FROM pedidos pe
JOIN usuarios u        ON pe.id_usuario = u.id
JOIN detalle_pedidos dp ON pe.id = dp.id_pedido
WHERE pe.id = 1
GROUP BY pe.id, u.nombre, pe.fecha, pe.estado;

-- 6) identificar productos con stock bajo
--    stock bajo = cantidad menor o igual a stock_minimo
SELECT
    p.nombre        AS producto,
    s.cantidad      AS stock_actual,
    s.stock_minimo,
    c.nombre        AS categoria
FROM stock s
JOIN productos p    ON s.id_producto = p.id
JOIN categorias c   ON p.id_categoria = c.id
WHERE s.cantidad <= s.stock_minimo
ORDER BY s.cantidad ASC;

-- 7) resumen de todos los pedidos con su cliente y total
SELECT
    pe.id           AS pedido,
    u.nombre        AS cliente,
    pe.fecha,
    pe.estado,
    COUNT(dp.id)    AS cantidad_items,
    SUM(dp.cantidad * dp.precio_unitario) AS total
FROM pedidos pe
JOIN usuarios u         ON pe.id_usuario = u.id
JOIN detalle_pedidos dp ON pe.id = dp.id_pedido
GROUP BY pe.id, u.nombre, pe.fecha, pe.estado
ORDER BY pe.fecha DESC;