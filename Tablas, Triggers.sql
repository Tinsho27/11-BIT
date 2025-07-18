--Tablas

CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    gmail VARCHAR(150) NOT NULL UNIQUE,
    contrasena TEXT NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('cliente', 'administrador')),
    geolocalizacion TEXT
);

CREATE TABLE Tienda (
    id_tienda SERIAL PRIMARY KEY,
    nombre_tienda VARCHAR(50) NOT NULL,
    descripcion TEXT,
    id_administrador INT REFERENCES Usuario(id_usuario),
    ubicacion TEXT
);

CREATE TABLE Videojuego (
    id_videojuego SERIAL PRIMARY KEY,
    nombre_juego VARCHAR(100) NOT NULL,
    precio NUMERIC(10, 2),
    url_imagen TEXT,
    stock INT CHECK (stock >= 0),
    descripcion TEXT,
    id_tienda INT REFERENCES Tienda(id_tienda)
);

CREATE TABLE Categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(20) NOT NULL
);

CREATE TABLE Videojuego_Categoria (
    id_videojuego INT REFERENCES Videojuego(id_videojuego),
    id_categoria INT REFERENCES Categoria(id_categoria),
    PRIMARY KEY (id_videojuego, id_categoria)
);

CREATE TABLE Carro (
    id_carro SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE Carro_Videojuego (
    id_carro INT REFERENCES Carro(id_carro),
    id_videojuego INT REFERENCES Videojuego(id_videojuego),
    cantidad INT NOT NULL CHECK(cantidad >0),
    PRIMARY KEY (id_carro, id_videojuego)
);

CREATE TABLE Boleta (
    id_boleta SERIAL PRIMARY KEY,
    id_usuario INTEGER,
    fecha DATE,
    metodo_pago TEXT,
    factura VARCHAR(50)
);

CREATE TABLE Boleta_Videojuego (
    id_boleta INT REFERENCES Boleta(id_boleta),
    id_videojuego INT REFERENCES Videojuego(id_videojuego),
    cantidad INT,
    precio_unitario NUMERIC(10,2),
    PRIMARY KEY (id_boleta, id_videojuego)
);

CREATE TABLE Valoracion (
    id_usuario INT REFERENCES Usuario(id_usuario),
    id_videojuego INT REFERENCES Videojuego(id_videojuego),
    puntaje INT CHECK (puntaje BETWEEN 1 AND 5),
    comentario VARCHAR(500),
    PRIMARY KEY (id_usuario, id_videojuego)
);

CREATE TABLE Lista_Deseos (
    id_usuario INT REFERENCES Usuario(id_usuario),
    id_videojuego INT REFERENCES Videojuego(id_videojuego),
    PRIMARY KEY (id_usuario, id_videojuego)
);


--Triggers
   
CREATE OR REPLACE FUNCTION verificar_stock()
RETURNS TRIGGER AS $$
DECLARE
stock_disponible INT;
BEGIN
SELECT stock INTO stock_disponible
FROM Videojuego
WHERE id_videojuego = NEW.id_videojuego;

IF stock_disponible IS NULL THEN
RAISE EXCEPTION 'El videojuego no existe.';
ELSIF NEW.cantidad > stock_disponible THEN
RAISE EXCEPTION 'Error: no se puede procesar la compra por stock insuficiente';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_stock
BEFORE INSERT ON Carro_Videojuego
FOR EACH ROW
EXECUTE FUNCTION verificar_stock();

CREATE OR REPLACE FUNCTION procesar_compra()
RETURNS TRIGGER AS $$
DECLARE
carrito_id INT;
item RECORD;
BEGIN
-- Buscar el carrito activo del usuario
SELECT id_carro INTO carrito_id
FROM Carro
WHERE id_usuario = NEW.id_usuario AND activo = TRUE
LIMIT 1;

IF carrito_id IS NULL THEN
RAISE EXCEPTION 'El usuario no tiene un carrito activo.';
END IF;

-- Procesar cada videojuego del carrito
FOR item IN
SELECT * FROM Carro_Videojuego WHERE id_carro = carrito_id
LOOP
-- Validar stock suficiente
PERFORM 1 FROM Videojuego
WHERE id_videojuego = item.id_videojuego AND stock >= item.cantidad;

IF NOT FOUND THEN
RAISE EXCEPTION 'Stock insuficiente para el videojuego con ID %', item.id_videojuego;
END IF;

-- Descontar stock
UPDATE Videojuego
SET stock = stock - item.cantidad
WHERE id_videojuego = item.id_videojuego;

-- Insertar en Boleta_Videojuego
INSERT INTO Boleta_Videojuego (id_boleta, id_videojuego, cantidad, precio_unitario)
VALUES (NEW.id_boleta,item.id_videojuego,item.cantidad,(SELECT precio FROM Videojuego WHERE id_videojuego = item.id_videojuego));
END LOOP;

-- Vaciar el carrito
DELETE FROM Carro_Videojuego WHERE id_carro = carrito_id;

-- Marcar el carrito como inactivo
UPDATE Carro
SET activo = FALSE
WHERE id_carro = carrito_id;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_procesar_compra
AFTER INSERT ON Boleta
FOR EACH ROW
EXECUTE FUNCTION procesar_compra();

--TC28 Trigger que registra cada vez que se inserta un videojuego
CREATE TABLE Auditoria_Videojuego (
    id_auditoria SERIAL PRIMARY KEY,
    id_videojuego INT,
    nombre_juego VARCHAR(100),
    usuario TEXT,          -- quién hizo la inserción
    accion VARCHAR(10),    -- tipo de acción: 'INSERT'
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION trg_auditoria_insert_videojuego()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO Auditoria_Videojuego (id_videojuego, nombre_juego, usuario, accion)
VALUES (NEW.id_videojuego,NEW.nombre_juego,current_user,    -- nombre del usuario DB que ejecutó la inserción'INSERT');
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auditoria_insert_videojuego
AFTER INSERT ON Videojuego
FOR EACH ROW
EXECUTE FUNCTION trg_auditoria_insert_videojuego();

--TC29 Trigger que registra actualización de stock de videojuegos
CREATE TABLE Auditoria_Stock (id_auditoria
SERIAL PRIMARY KEY,
id_videojuego INT,
nombre_juego VARCHAR(100),
usuario TEXT,
accion VARCHAR(10),
-- 'UPDATE'stock_anterior INT,
stock_nuevo INT,
fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE OR REPLACE FUNCTION trg_auditoria_update_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo registrar si el stock cambió
    IF OLD.stock IS DISTINCT FROM NEW.stock THEN
        INSERT INTO Auditoria_Stock (id_videojuego,nombre_juego,usuario,accion,stock_anterior,stock_nuevo
        ) VALUES (NEW.id_videojuego,NEW.nombre_juego,current_user,'UPDATE',OLD.stock,NEW.stock);
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auditoria_update_stock
AFTER UPDATE OF stock ON Videojuego
FOR EACH ROW
EXECUTE FUNCTION trg_auditoria_update_stock();

--TC30 Trigger de seguridad (DELETE)
CREATE OR REPLACE FUNCTION trg_no_delete_videojuego_comprado()
RETURNS TRIGGER AS $$
DECLARE
compras INT;
BEGIN
SELECT COUNT(*) INTO compras
FROM Boleta_Videojuego
WHERE id_videojuego = OLD.id_videojuego;

IF compras > 0 THEN
RAISE EXCEPTION 'Error: operación bloqueada. El videojuego con ID % ya ha sido comprado.', OLD.id_videojuego;
END IF;

RETURN OLD;  -- Permite la eliminación si no hay compras
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_seguridad_delete_videojuego
BEFORE DELETE ON Videojuego
FOR EACH ROW
EXECUTE FUNCTION trg_no_delete_videojuego_comprado();

