-- User: SYSTEM

-- Crear un usuario nuevo para el owner
CREATE USER C##ERROR_EMPLEADO IDENTIFIED BY 1234 DEFAULT TABLESPACE SYSAUX QUOTA 8M ON SYSAUX;

-- Otorgar privilegios para CONECTAR y RECURSOS
GRANT CONNECT, RESOURCE TO C##ERROR_EMPLEADO;

-- User: C##ERROR_EMPLEADO

-- Crear tabla EMPLEADO
CREATE TABLE EMPLEADO( 
	id_emp            NUMBER(7)    NOT NULL CONSTRAINT PK_EMPLEADO PRIMARY KEY,
  	apell_pat         VARCHAR2(25) NOT NULL,
 	primer_nombre     VARCHAR2(20) NOT NULL,
  	salario           NUMBER(8)    NOT NULL,
  	cod_depto         NUMBER(7)    NOT NULL
);