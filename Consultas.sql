-- TC 01 Insertar usuario con datos válidos y rol 'jefe de tienda'
INSERT INTO Usuario (nombre_usuario, gmail, contrasena, rol, geolocalizacion) 
VALUES ('Pedro', 'pedro@example.com', 'abc1234', 'administrador', '-33.45, -70.66');

-- TC 02 Insertar usuario con correo NULL
INSERT INTO Usuario (nombre_usuario, gmail, contrasena, rol, geolocalizacion)
VALUES ('María García', NULL, '1234', 'cliente', '-33.45, -70.66');

-- TC 03 Insertar usuario con rol inexistente
INSERT INTO Usuario (nombre_usuario, gmail, contrasena, rol, geolocalizacion)
VALUES ('Juana García', 'juana@gmail.com', '1234', 'manager', '-33.45, -70.66');

-- TC 04 Insertar usuario cliente con datos válidos
INSERT INTO Usuario (nombre_usuario, gmail, contrasena, rol, geolocalizacion)
VALUES ('Camila Rojas', 'camila.rojas@gmail.com', '1234', 'cliente', '-33.50, -70.70');

-- TC 05 Insertar videojuego con stock negativo
INSERT INTO Videojuego (nombre_juego, precio, url_imagen, stock, descripcion, id_tienda)
VALUES ('Zelda', 25000, 'url.jpg', -3, 'Prueba', 1);

-- TC 06 Insertar videojuego con categoría inexistente
INSERT INTO Videojuego_Categoria (id_videojuego, id_categoria)
VALUES (1, 99); --No hay restricciones de categorias

-- TC 07 Insertar videojuego con datos válidos
INSERT INTO Videojuego (nombre_juego, precio, url_imagen, stock, descripcion, id_tienda)
VALUES ('Zelda OK', 25000, 'url.jpg', 5, 'Correcto', 1);

-- TC 09 Usuario agrega videojuego a su lista de deseos
INSERT INTO Videojuego (nombre_juego, precio, url_imagen, stock, descripcion, id_tienda)
VALUES ('Fortnite', 19990, 'https://ejemplo.cl/fortnite.jpg', 9999, 'Battle Royale multijugador', 2);

-- TC 10 Usuario intenta agregar dos veces el mismo videojuego a la lista
INSERT INTO Lista_Deseos VALUES (1, 1);
INSERT INTO Lista_Deseos VALUES (1, 1);

-- TC 11 Mostrar la lista de deseos de un usuario
SELECT 
    u.nombre_usuario,
    v.nombre_juego
FROM Lista_Deseos ld
JOIN Usuario u ON ld.id_usuario = u.id_usuario
JOIN Videojuego v ON ld.id_videojuego = v.id_videojuego
WHERE ld.id_usuario = 3;

-- TC 12 Agregar un producto al carrito de compras
INSERT INTO Carro_Videojuego VALUES (1, 1, 1);

-- TC 13 Mostrar los productos del carrito de compras
SELECT 
    v.nombre_juego,
    cv.cantidad
FROM Carro c
JOIN Carro_Videojuego cv ON c.id_carro = cv.id_carro
JOIN Videojuego v ON cv.id_videojuego = v.id_videojuego
WHERE c.id_usuario=1

-- TC 14 Mostrar el precio total a pagar por el carrito de compras
SELECT SUM(cantidad * precio) FROM Carro_Videojuego
JOIN Videojuego USING (id_videojuego) 
WHERE id_carro = 1;

-- TC 15 Eliminar un producto del carrito de compras
DELETE FROM Carro_Videojuego WHERE id_carro = 1 AND id_videojuego = 1;

-- TC 16 Cliente agrega videojuegos al carrito con stock disponible
INSERT INTO Carro_Videojuego VALUES (1, 1, 2);

-- TC 17 Cliente intenta comprar más unidades que el stock disponible
INSERT INTO Carro_Videojuego VALUES (1, 1, 9999);

-- TC 18 Cliente intenta pagar carrito que contiene un videojuego sin stock
INSERT INTO Carro_Videojuego VALUES (2, 12, 1);

-- TC 19 Cliente realiza compra con productos válidos en el carrito
INSERT INTO Boleta (id_usuario, fecha, metodo_pago, factura)
VALUES (1, CURRENT_DATE, 'Tarjeta', 'F999');

-- TC 20 Cliente intentar registrar compra con medio de pago no permitido
INSERT INTO Boleta (id_usuario, fecha, metodo_pago, factura)
VALUES (1, CURRENT_DATE, 'Cheque', 'F998');

-- TC 21 Cliente valora el videojuego comprado
INSERT INTO Valoracion VALUES (1, 1, 5, 'Muy bueno');

-- TC 22 Cliente intenta valorar dos veces el mismo videojuego
INSERT INTO Valoracion VALUES (1, 1, 4, 'Otra opinión');

-- TC 23 Obtener los 3 videojuegos con más ventas
SELECT v.nombre_juego "Juego", SUM(bv.cantidad) AS Ventas
FROM Boleta_Videojuego bv
JOIN Videojuego v ON bv.id_videojuego = v.id_videojuego
GROUP BY v.id_videojuego, v.nombre_juego
ORDER BY Ventas DESC
LIMIT 3;

-- TC 24 Obtener videojuegos con más apariciones en listas de deseos
SELECT id_videojuego, SUM(cantidad) AS total_vendidos
FROM Boleta_Videojuego
GROUP BY id videojuego
ORDER BY total_vendidos DESC
LIMIT 3;

-- TC 25 Mostrar todos los productos que se vendan en una ubicación geográfica específica
SELECT  v.nombre_juego "Juego", t.ubicacion "Ubicacion"
FROM Videojuego v
JOIN Tienda t ON v.id_tienda = t.id_tienda
WHERE v.stock > 0
  AND t.ubicacion ILIKE 'Santiago';

-- TC 26 Mostrar ranking de los productos con más ventas
SELECT id_videojuego, SUM(cantidad) AS total
FROM Boleta_Videojuego
GROUP BY id_videojuego
ORDER BY total DESC;

-- TC 27 Videojuegos según ubicación del usuario,se debe de construir una relación entre tienda, usuario y ventas
INSERT INTO Videojuego (nombre_juego, precio, url_imagen, stock, descripcion, id_tienda)
VALUES ('Nuevo juego', 20000, 'url.jpg', 5, 'Auditable', 1);


--TC31 Actualizar precio de videojuegos por categoría
CREATE OR REPLACE PROCEDURE actualizar_precio_categoria(
    nombre_categoria_param VARCHAR,
    porcentaje_aumento NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Videojuego v
    SET precio = ROUND(precio * (1 + porcentaje_aumento / 100), 2)
    WHERE v.id_videojuego IN (
        SELECT vc.id_videojuego
        FROM Videojuego_Categoria vc
        JOIN Categoria c ON vc.id_categoria = c.id_categoria
        WHERE LOWER(c.nombre_categoria) = LOWER(nombre_categoria_param)
    );
END;
$$;

CALL actualizar_precio_categoria('aventura', 10);

--TC32 Generar reporte de ventas por usuario
CREATE OR REPLACE PROCEDURE reporte_ventas_usuario(
    p_id_usuario INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Devuelve la tabla con el reporte
    RETURN QUERY
    SELECT 
        v.nombre_juego,
        b.fecha,
        bv.cantidad,
        bv.precio_unitario,
        (bv.cantidad * bv.precio_unitario) AS monto_total
    FROM Boleta b
    JOIN Boleta_Videojuego bv ON b.id_boleta = bv.id_boleta
    JOIN Videojuego v ON bv.id_videojuego = v.id_videojuego
    WHERE b.id_usuario = p_id_usuario
    ORDER BY b.fecha DESC;
END;
$$;

CALL reporte_ventas_usuario(1);
