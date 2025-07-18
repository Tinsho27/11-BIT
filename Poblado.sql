-- Usuarios
INSERT INTO Usuario (nombre_usuario, gmail, contrasena, rol, geolocalizacion) VALUES
('juanito1', 'juanito1@gmail.com', 'pass1234', 'cliente', '-33.44, -70.65'),
('admin22', 'admin22@gmail.com', 'adminpass', 'administrador', '-32.88, -71.22'),
('justingray', 'justingray@gmail.com', 'Ts5cOFxAK^', 'cliente', '-10.78607, 146.74215'),
('yolandataylor', 'yolandataylor@gmail.com', 'l%Phl5_t(2', 'administrador', '-45.09363, 154.25912'),
('candaceclark', 'candaceclark@gmail.com', '(ug2C_GokX', 'administrador', '85.68673, 105.54830'),
('chadmartinez', 'chadmartinez@gmail.com', '@7d#)EnjgA', 'cliente', '22.36658, -32.08468'),
('bevans', 'bevans@gmail.com', '^6tuOScsJt', 'administrador', '-20.04260, -153.48289'),
('johnpeterson', 'johnpeterson@gmail.com', ')C8t*UGds^', 'administrador', '19.86752, 130.22724'),
('handerson', 'handerson@gmail.com', 'F$6hlzHznq', 'cliente', '-87.63781, -66.94925'),
('jamesdavis', 'jamesdavis@gmail.com', '&401McT8+u', 'administrador', '43.13281, 106.11684'),
('eavery', 'eavery@gmail.com', 'M0Xn(O*g&8', 'cliente', '85.99174, 131.07986'),
('isuarez', 'isuarez@gmail.com', ')w&KHLwn!4', 'cliente', '-64.62145, 138.60554'),
('andrewbishop', 'andrewbishop@gmail.com', '$gGM3S*uj@', 'administrador', '-0.21906, 57.73426'),
('malonejim', 'malonejim@gmail.com', 'qtrmQR(x@2', 'administrador', '57.56618, -105.66398'),
('rasmussendawn', 'rasmussendawn@gmail.com', 'dfes1LJc!Q', 'administrador', '-30.14665, 59.96105'),
('sandramendez', 'sandramendez@gmail.com', '2$s8Qb(v&_', 'administrador', '21.56635, -59.39627'),
('bridget25', 'bridget25@gmail.com', 'zFq)0DdNku', 'cliente', '-37.37216, 93.52697'),
('johnhumphrey', 'johnhumphrey@gmail.com', 'CHA&GliR^2', 'cliente', '-2.67470, -92.35775'),
('amanda88', 'amanda88@gmail.com', ')_D2HRDzhA', 'cliente', '-48.72218, 114.28744'),
('trowe', 'trowe@gmail.com', '@1D+b2LvR)', 'administrador', '31.11641, 53.25836'),
('zsolomon', 'zsolomon@gmail.com', '$LR1qYBwZ4', 'cliente', '35.10788, -168.63627');

-- Tiendas
INSERT INTO Tienda (nombre_tienda, descripcion, id_administrador, ubicacion) VALUES
('GameStore Chile', 'Tienda oficial de videojuegos', 2, 'Viña del mar'),
('PixelPlay', 'Tienda de clásicos y nuevos títulos', 2, 'Santiago'),
('RetroWorld', 'Juegos retro y nostálgicos', 4, 'Chillan'),
('NextGen Games', 'Última generación en consolas y juegos', 7, 'Santiago');

-- Categorías
INSERT INTO Categoria (nombre_categoria) VALUES
('Aventura'), ('Estrategia'), ('Acción'), ('Deportes'), ('RPG'), ('Simulación');

-- Videojuegos
INSERT INTO Videojuego (nombre_juego, precio, url_imagen, stock, descripcion, id_tienda) VALUES
('Zelda: Breath of the Wild', 45990, 'https://ejemplo.cl/zelda.jpg', 15, 'Aventura épica en mundo abierto', 1),
('Minecraft', 25990, 'https://ejemplo.cl/minecraft.jpg', 30, 'Juego de construcción en bloques', 2),
('FIFA 24', 58990, 'https://ejemplo.cl/fifa24.jpg', 20, 'Simulación deportiva de fútbol', 1),
('Age of Empires IV', 34990, 'https://ejemplo.cl/aoe4.jpg', 10, 'Estrategia en tiempo real', 2),
('God of War', 56538, 'https://ejemplo.cl/gow.jpg', 25, 'Acción épica en la mitología nórdica', 3),
('The Sims 4', 22071, 'https://ejemplo.cl/sims4.jpg', 40, 'Simulación de vida', 3),
('Final Fantasy XVI', 40590, 'https://ejemplo.cl/ff16.jpg', 18, 'RPG en mundo de fantasía', 3),
('Hollow Knight', 32830, 'https://ejemplo.cl/hollow.jpg', 22, 'Metroidvania desafiante y atmosférico', 4),
('NBA 2K24', 29990, 'https://ejemplo.cl/nba2k24.jpg', 15, 'Baloncesto profesional', 4),
('Fortnite', 19990, 'https://ejemplo.cl/fortnite.jpg', 9999, 'Battle Royale multijugador', 2);
INSERT INTO Videojuego VALUES
(12,'FreeFire', 990, 'https://ejemplo.cl/FreeFire.jpg', 0, 'Aventura épica en mundo abierto', 1);


-- Videojuego_Categoria
INSERT INTO Videojuego_Categoria VALUES
(1, 1), (2, 2), (3, 4), (4, 2), (5, 3), (6, 6), (7, 5), (8, 1), (9, 4), (10, 3);

-- Carros
INSERT INTO Carro (id_usuario, activo) VALUES
(1, TRUE), (1, FALSE), (2, TRUE), (3, TRUE), (4, TRUE), (5, TRUE), (6, TRUE), (7, TRUE),
(8, TRUE), (9, TRUE), (10, TRUE), (11, TRUE), (12, TRUE), (13, TRUE), (14, TRUE), (15, TRUE),
(16, TRUE), (17, TRUE), (18, TRUE), (19, TRUE), (20, TRUE);

-- Carro_Videojuego
INSERT INTO Carro_Videojuego VALUES
(1, 1, 2), (1, 2, 1), (3, 2, 4), (4, 3, 1), (5, 4, 2), (6, 5, 1), (7, 6, 1),
(8, 7, 3), (9, 8, 2), (10, 9, 1), (11, 10, 5);

-- Boletas
INSERT INTO Boleta (id_usuario, fecha, metodo_pago, factura) VALUES
(1, '2022-03-21', 'Tarjeta', 'F101'),
(2, '2025-05-12', 'Efectivo', 'F102'),
(3, '2021-03-31', 'Transferencia', 'F103'),
(4, '2024-01-10', 'Tarjeta', 'F104'),
(5, '2025-06-01', 'Efectivo', 'F105'),
(6, '2023-07-19', 'Transferencia', 'F106'),
(7, '2023-02-21', 'Tarjeta', 'F107'),
(8, '2025-02-25', 'Efectivo', 'F108'),
(9, '2022-02-11', 'Transferencia', 'F109'),
(10, '2022-02-15', 'Tarjeta', 'F110'),
(11, '2025-02-19', 'Efectivo', 'F111'),
(12, '2025-02-20', 'Transferencia', 'F112'),
(13, '2025-02-17', 'Tarjeta', 'F113'),
(14, '2024-02-25', 'Efectivo', 'F114'),
(15, '2023-02-22', 'Transferencia', 'F115'),
(16, '2023-02-19', 'Tarjeta', 'F116'),
(17, '2025-02-13', 'Efectivo', 'F117'),
(18, '2024-02-14', 'Transferencia', 'F118'),
(19, '2024-02-09', 'Tarjeta', 'F119'),
(20, '2023-02-08', 'Efectivo', 'F120');

-- Boleta_Videojuego
INSERT INTO Boleta_Videojuego VALUES
(1, 1, 1, 45990),
(1, 2, 1, 25990),
(2, 3, 2, 58990),
(3, 4, 1, 34990),
(4, 5, 1, 56538),
(5, 6, 2, 22071),
(6, 7, 1, 40590),
(7, 8, 1, 32830),
(8, 9, 2, 29990),
(9, 10, 3, 19990);

-- Valoraciones
INSERT INTO Valoracion VALUES
(1, 1, 5, 'Excelente juego!'),
(2, 2, 4, 'Muy entretenido'),
(3, 3, 3, 'Está bien'),
(4, 4, 2, 'No me gustó mucho'),
(5, 5, 1, 'Mal optimizado');

-- Listas de deseos
INSERT INTO Lista_Deseos VALUES
(1, 3), (2, 1), (3, 5), (4, 2), (5, 4);
