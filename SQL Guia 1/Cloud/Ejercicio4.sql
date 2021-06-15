-- User: ADMIN

-- Crear un usuario nuevo para el owner
CREATE USER SABORES IDENTIFIED BY ora1234_CLOUD DEFAULT TABLESPACE DATA QUOTA 5M ON DATA;

-- Otorgar privilegios para CONECTAR y RECURSOS
GRANT CONNECT, RESOURCE TO SABORES;

-- User: SABORES

-- Crear tabla CLIENTE
CREATE TABLE CLIENTE(
	id_cliente        NUMBER(5)    NOT NULL CONSTRAINT PK_CLIENTE PRIMARY KEY,
	primer_nombre     VARCHAR2(25) NOT NULL,
	segundo_nombre    VARCHAR2(25),
	apell_paterno     VARCHAR2(25) NOT NULL,
	apell_materno     VARCHAR2(25) NOT NULL,
	direccion         VARCHAR2(30) NOT NULL
);

-- Crear tabla EMPLEADO
CREATE TABLE EMPLEADO( 
	id_empleado       NUMBER(6)    NOT NULL CONSTRAINT PK_EMPLEADO PRIMARY KEY,
	primer_nombre     VARCHAR2(25) NOT NULL,
	segundo_nombre    VARCHAR2(25),
	apell_paterno     VARCHAR2(25) NOT NULL,
	apell_materno     VARCHAR2(25) NOT NULL,
	fecha_contrato    DATE         NOT NULL
);

-- Crear tabla PEDIDO
CREATE TABLE PEDIDO(
	nro_pedido    NUMBER(6)   NOT NULL    CONSTRAINT PK_PEDIDO    PRIMARY KEY,
	fecha_pedido  DATE        NOT NULL,
	fecha_entrega DATE        NOT NULL,
	id_cliente    NUMBER(5)   NOT NULL    CONSTRAINT FK_PEDIDO_CLIENTE    REFERENCES CLIENTE  (id_cliente),
	id_empleado   NUMBER(6)   NOT NULL    CONSTRAINT FK_PEDIDO_EMPLEADO   REFERENCES EMPLEADO (id_empleado)
);