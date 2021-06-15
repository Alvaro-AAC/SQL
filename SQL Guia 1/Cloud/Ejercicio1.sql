-- User: ADMIN

-- Crear un usuario nuevo para el owner
CREATE USER ERROR_EMPLEADO IDENTIFIED BY ora1234_CLOUD DEFAULT TABLESPACE DATA QUOTA 1M ON DATA;

-- Otorgar privilegios para CONECTAR y RECURSOS
GRANT CONNECT, RESOURCE TO ERROR_EMPLEADO;

-- User: ERROR_EMPLEADO

-- Crear tabla EMPLEADO
CREATE TABLE EMPLEADO( 
	id_emp            NUMBER(7)    NOT NULL CONSTRAINT PK_EMPLEADO PRIMARY KEY,
  	apell_pat         VARCHAR2(25) NOT NULL,
 	primer_nombre     VARCHAR2(20) NOT NULL,
  	salario           NUMBER(8)    NOT NULL,
  	cod_depto         NUMBER(7)    NOT NULL
);