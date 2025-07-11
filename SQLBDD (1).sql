CREATE TABLE USUARIO (
    ID_usuario INT PRIMARY KEY,
    nombre_usuario VARCHAR(100),
    gmail VARCHAR(100),
    contrasena VARCHAR(100),
    rol VARCHAR(20),
    geolocalizacion VARCHAR(20)
);

CREATE TABLE CATEGORIA (
    ID_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50)
);

CREATE TABLE CARRO (
	ID_carro INT PRIMARY KEY,
	ID_usuario INT,
	activo BOOL,
	FOREIGN KEY (ID_usuario) REFERENCES USUARIO(ID_usuario)
);

CREATE TABLE BOLETA (
    ID_boleta INT PRIMARY KEY,
    ID_usuario INT,
    dia INT,
	mes INT,
	anio INT,
	metodo_pago VARCHAR(50),
	factura FLOAT,
	FOREIGN KEY (ID_usuario) REFERENCES USUARIO(ID_usuario)
);

CREATE TABLE TIENDA (
    ID_tienda INT PRIMARY KEY,
    nombre_tienda VARCHAR(100),
    descripcion TEXT,
	ID_administradores INT,
	FOREIGN KEY (ID_administradores) REFERENCES USUARIO(ID_usuario)
);

CREATE TABLE VIDEOJUEGO (
    ID_videojuego INT PRIMARY KEY,
    nombre_juego VARCHAR(100),
    precio FLOAT,
	url_imagen TEXT,
	stock INT,
	descripcion TEXT,
	ID_tienda INT,
	FOREIGN KEY (ID_tienda) REFERENCES TIENDA(ID_tienda)
);

CREATE TABLE CARRO_VIDEOJUEGO (
    ID_carro INT,
	ID_videojuego INT,
    cantidad INT,
	FOREIGN KEY (ID_carro) REFERENCES CARRO(ID_carro),
	FOREIGN KEY (ID_videojuego) REFERENCES VIDEOJUEGO(ID_videojuego),
	PRIMARY KEY(ID_carro, ID_videojuego)
);

CREATE TABLE BOLETA_VIDEOJUEGO (
    ID_boleta INT,
	ID_videojuego INT,
    cantidad INT,
	precio_unitario FLOAT,
	FOREIGN KEY (ID_boleta) REFERENCES BOLETA(ID_boleta),
	FOREIGN KEY (ID_videojuego) REFERENCES VIDEOJUEGO(ID_videojuego),
	PRIMARY KEY(ID_boleta, ID_videojuego)
);

CREATE TABLE VIDEOJUEGO_CATEGORIA (
    ID_categoria INT,
	ID_videojuego INT,
	FOREIGN KEY (ID_categoria) REFERENCES CATEGORIA(ID_categoria),
	FOREIGN KEY (ID_videojuego) REFERENCES VIDEOJUEGO(ID_videojuego),
	PRIMARY KEY(ID_categoria, ID_videojuego)
);

CREATE TABLE VALORACION (
    ID_usuario INT,
	ID_videojuego INT,
	puntaje INT,
	comentario TEXT,
	FOREIGN KEY (ID_usuario) REFERENCES USUARIO(ID_usuario),
	FOREIGN KEY (ID_videojuego) REFERENCES VIDEOJUEGO(ID_videojuego),
	PRIMARY KEY(ID_usuario, ID_videojuego)
);

CREATE TABLE LISTA_DESEOS (
    ID_usuario INT,
	ID_videojuego INT,
	FOREIGN KEY (ID_usuario) REFERENCES USUARIO(ID_usuario),
	FOREIGN KEY (ID_videojuego) REFERENCES VIDEOJUEGO(ID_videojuego),
	PRIMARY KEY(ID_usuario, ID_videojuego)
);
