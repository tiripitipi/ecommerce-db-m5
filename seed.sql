-- datos de ejemplo para probar todas las funcionalidades del e-commerce

-- categorias: reciclo las mismas del módulo 3
INSERT INTO categorias (nombre, descripcion) VALUES
    ('raquetas',   'Raquetas de tenis de diferentes marcas y modelos'),
    ('calzado',    'Zapatillas especializadas para tenis'),
    ('pelotas',    'Pelotas de tenis para todo nivel'),
    ('accesorios', 'Accesorios varios para mejorar el juego'),
    ('ropa',       'Ropa deportiva para tenis');

-- productos: los 6 del módulo 3 más 4 extras para llegar a 10
INSERT INTO productos (nombre, descripcion, precio, id_categoria) VALUES
    -- raquetas (id_categoria = 1)
    ('Raqueta Wilson Pro Staff',        'Raqueta profesional usada por Roger Federer',         89990, 1),
    ('Raqueta Babolat Pure Drive',      'Raqueta potente ideal para jugadores agresivos',      79990, 1),

    -- calzado (id_categoria = 2)
    ('Zapatillas Asics Gel-Dedicate 8', 'Zapatillas con amortiguación gel para todo terreno',  49990, 2),
    ('Zapatillas Nike Court Lite 3',    'Zapatillas livianas para canchas duras',               39990, 2),

    -- pelotas (id_categoria = 3)
    ('Pelotas Babolat x4',             'Pack de 4 pelotas de presurización estándar',           8990, 3),
    ('Pelotas Wilson Championship x3', 'Pack de 3 pelotas para entrenamiento',                  6990, 3),

    -- accesorios (id_categoria = 4)
    ('Overgrip Wilson Pro x3',         'Pack de 3 overgrips para mejor agarre',                 4990, 4),
    ('Antivibrador Head Xtra Damp x2', 'Pack de 2 antivibradores para reducir vibraciones',     8990, 4),

    -- ropa (id_categoria = 5)
    ('Camiseta Torino Verde Ellesse',  'Camiseta deportiva transpirable manga corta',           19990, 5),
    ('Shorts Adidas Club 3 Bandas',    'Shorts cómodos para partidos y entrenamientos',         14990, 5);

-- usuarios: 1 admin y 4 clientes
INSERT INTO usuarios (nombre, email, password, rol) VALUES
    ('Kevin Gamboa',   'kevin@admin.com',   'admin123',  'admin'),
    ('Ana Torres',     'ana@gmail.com',     'cliente123', 'cliente'),
    ('Luis Pérez',     'luis@gmail.com',    'cliente123', 'cliente'),
    ('María Soto',     'maria@gmail.com',   'cliente123', 'cliente'),
    ('Jorge Ramírez',  'jorge@gmail.com',   'cliente123', 'cliente');

-- stock: un registro por cada producto
INSERT INTO stock (id_producto, cantidad, stock_minimo) VALUES
    (1,  15, 3),   -- Raqueta Wilson Pro Staff
    (2,  10, 3),   -- Raqueta Babolat Pure Drive
    (3,  20, 5),   -- Zapatillas Asics
    (4,  18, 5),   -- Zapatillas Nike
    (5,  50, 10),  -- Pelotas Babolat
    (6,  40, 10),  -- Pelotas Wilson
    (7, 100, 20),  -- Overgrip Wilson
    (8,  80, 20),  -- Antivibrador Head
    (9,  30, 5),   -- Camiseta Ellesse
    (10, 25, 5);   -- Shorts Adidas

-- pedidos: 3 pedidos de distintos clientes
INSERT INTO pedidos (id_usuario, estado, total) VALUES
    (2, 'confirmado', 139980),  -- Ana compró raqueta + zapatillas
    (3, 'confirmado',  27960),  -- Luis compró pelotas + overgrip
    (4, 'pendiente',   49990);  -- María tiene un pedido pendiente

-- detalle_pedidos: los productos de cada pedido
INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario) VALUES
    -- pedido 1: Ana compró 1 raqueta Wilson + 1 zapatillas Asics
    (1, 1, 1, 89990),
    (1, 3, 1, 49990),

    -- pedido 2: Luis compró 2 pelotas Babolat + 2 overgrip Wilson
    (2, 5, 2, 8990),
    (2, 7, 2, 4990),  -- 2x8990 + 2x4990 = 17980 + 9980

    -- pedido 3: María quiere 1 zapatillas Asics
    (3, 3, 1, 49990);