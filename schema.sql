-- acá defino todas las tablas y relaciones del e-commerce El Rincón del Tenis

-- borro las tablas en orden inverso para no tener problemas con las FK
-- si no lo hago en este orden PostgreSQL me tira error
DROP TABLE IF EXISTS detalle_pedidos;
DROP TABLE IF EXISTS stock;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS usuarios;

-- tabla usuarios, pueden ser admin o cliente
-- el CHECK en rol evita que se ingrese cualquier valor
CREATE TABLE usuarios (
    id         SERIAL PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE,
    password   VARCHAR(100) NOT NULL,
    rol        VARCHAR(10)  NOT NULL CHECK (rol IN ('admin', 'cliente')),
    created_at TIMESTAMP DEFAULT NOW()
);

-- tabla categorias, agrupan los productos del catálogo
CREATE TABLE categorias (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- tabla productos, cada producto pertenece a una categoría
-- si se borra una categoría no se puede mientras tenga productos asociados
CREATE TABLE productos (
    id           SERIAL PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    descripcion  TEXT,
    precio       INTEGER NOT NULL CHECK (precio > 0),
    id_categoria INTEGER NOT NULL REFERENCES categorias(id) ON DELETE RESTRICT
);

-- tabla stock, relación 1:1 con productos, controla la disponibilidad
-- si se borra un producto tampoco se puede borrar si tiene stock
CREATE TABLE stock (
    id_producto  INTEGER PRIMARY KEY REFERENCES productos(id) ON DELETE RESTRICT,
    cantidad     INTEGER NOT NULL CHECK (cantidad >= 0),
    stock_minimo INTEGER NOT NULL DEFAULT 5
);

-- tabla pedidos, cada pedido pertenece a un usuario
-- si se borra un usuario no se puede mientras tenga pedidos
CREATE TABLE pedidos (
    id         SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE RESTRICT,
    fecha      TIMESTAMP DEFAULT NOW(),
    estado     VARCHAR(20) NOT NULL DEFAULT 'pendiente'
               CHECK (estado IN ('pendiente', 'confirmado', 'cancelado')),
    total      INTEGER NOT NULL DEFAULT 0
);

-- tabla detalle_pedidos, tabla intermedia del N:M entre pedidos y productos
-- guarda precio_unitario al momento de la compra por si el precio cambia después
-- si se borra un pedido se borran también sus detalles con CASCADE
-- el UNIQUE evita que el mismo producto aparezca dos veces en el mismo pedido
CREATE TABLE detalle_pedidos (
    id              SERIAL PRIMARY KEY,
    id_pedido       INTEGER NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
    id_producto     INTEGER NOT NULL REFERENCES productos(id) ON DELETE RESTRICT,
    cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario INTEGER NOT NULL CHECK (precio_unitario > 0),
    CONSTRAINT uq_pedido_producto UNIQUE (id_pedido, id_producto)
);