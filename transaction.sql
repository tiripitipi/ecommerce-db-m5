-- transaction.sql
-- operación de compra transaccional
-- uso BEGIN/COMMIT/ROLLBACK para asegurar consistencia en los datos

-- TRANSACCIÓN 1: compra exitosa
-- Jorge Ramírez (id=5) compra 1 raqueta Babolat y 2 pelotas Wilson
-- esta transacción se confirma con COMMIT porque todo sale bien

BEGIN;

-- paso 1: creo el pedido
INSERT INTO pedidos (id_usuario, estado, total)
VALUES (5, 'confirmado', 0);

-- paso 2: agrego los productos al detalle
-- 1x raqueta Babolat (id=2, precio=79990)
-- 2x pelotas Wilson (id=6, precio=6990)
INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario)
VALUES
    (currval('pedidos_id_seq'), 2, 1, 79990),
    (currval('pedidos_id_seq'), 6, 2,  6990);

-- paso 3: actualizo el total con la suma real de los productos
-- 1x79990 + 2x6990 = 93970
UPDATE pedidos
SET total = (
    SELECT SUM(cantidad * precio_unitario)
    FROM detalle_pedidos
    WHERE id_pedido = currval('pedidos_id_seq')
)
WHERE id = currval('pedidos_id_seq');

-- paso 4: descuento el stock de cada producto comprado
UPDATE stock SET cantidad = cantidad - 1 WHERE id_producto = 2;  -- Raqueta Babolat: -1
UPDATE stock SET cantidad = cantidad - 2 WHERE id_producto = 6;  -- Pelotas Wilson: -2

-- todo salió bien, confirmo la transacción
COMMIT;

-- verifico el pedido creado y el stock actualizado
SELECT
    pe.id        AS pedido,
    u.nombre     AS cliente,
    pe.estado,
    pe.total
FROM pedidos pe
JOIN usuarios u ON pe.id_usuario = u.id
WHERE pe.id = currval('pedidos_id_seq');

SELECT
    p.nombre     AS producto,
    s.cantidad   AS stock_actual,
    s.stock_minimo
FROM stock s
JOIN productos p ON s.id_producto = p.id
WHERE s.id_producto IN (2, 6);


-- TRANSACCIÓN 2: compra que falla — demostración del ROLLBACK
-- intento comprar 999 raquetas Wilson (id=1) pero el stock no alcanza
-- el CHECK (cantidad >= 0) del schema detecta el error
-- el ROLLBACK deshace todo y los datos quedan intactos

BEGIN;

-- paso 1: creo el pedido
INSERT INTO pedidos (id_usuario, estado, total)
VALUES (3, 'confirmado', 89990);

-- paso 2: agrego el producto al detalle
INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario)
VALUES (currval('pedidos_id_seq'), 1, 999, 89990);

-- paso 3: intento descontar 999 unidades del stock
-- esto va a fallar porque la raqueta Wilson tiene cantidad = 2 (stock bajo)
-- el CHECK (cantidad >= 0) lanza error y PostgreSQL deshace todo
UPDATE stock SET cantidad = cantidad - 999 WHERE id_producto = 1;

-- el COMMIT nunca se ejecuta porque el UPDATE de arriba ya falló
-- el ROLLBACK deshace todo explícitamente
ROLLBACK;

-- verifico que el pedido NO se creó y el stock quedó intacto
-- si el ROLLBACK funcionó bien no debería aparecer ningún pedido nuevo de Luis
SELECT
    pe.id        AS pedido,
    u.nombre     AS cliente,
    pe.estado,
    pe.total
FROM pedidos pe
JOIN usuarios u ON pe.id_usuario = u.id
ORDER BY pe.id DESC
LIMIT 3;

SELECT
    p.nombre     AS producto,
    s.cantidad   AS stock_actual
FROM stock s
JOIN productos p ON s.id_producto = p.id
WHERE s.id_producto = 1;