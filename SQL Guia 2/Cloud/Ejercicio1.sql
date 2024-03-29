-- User: ADMIN

-- Crear un usuario nuevo para el owner
CREATE USER POSTULACIONES_IT IDENTIFIED BY ora1234_CLOUD DEFAULT TABLESPACE DATA QUOTA 8M ON DATA;

-- Otorgar privilegios para CONECTAR y RECURSOS
GRANT CONNECT, RESOURCE TO POSTULACIONES_IT;

-- User: POSTULACIONES_IT

-- Crear tabla ESTADO_CIVIL
CREATE TABLE ESTADO_CIVIL(
	ID_ESTCIVIL NUMBER(1)		NOT NULL CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY,
	DESCRIP 	VARCHAR2(25) 	NOT NULL
);

-- Crear tabla REGION
CREATE TABLE REGION(
	ID_REGION 	NUMBER(2) 		NOT NULL CONSTRAINT REGION_PK PRIMARY KEY,
	NOMBRE_REG	VARCHAR2(25)	NOT NULL
);

-- Crear tabla CIUDAD
CREATE TABLE CIUDAD(
	ID_CIUD 	NUMBER(4) 		NOT NULL,
	ID_REG 		NUMBER(2)		NOT NULL CONSTRAINT CIUDAD_REG_FK REFERENCES REGION (ID_REGION),
	NOMBRE_CIUD	VARCHAR2(25)	NOT NULL,
	CONSTRAINT CIUDAD_PK        PRIMARY KEY (ID_CIUD, ID_REG)
);

-- Crear tabla COMUNA
CREATE TABLE COMUNA(
	ID_COMUNA	NUMBER(4)		NOT NULL,
	ID_CIUDAD 	NUMBER(4) 		NOT NULL,
	ID_REG 		NUMBER(2)		NOT NULL,
	COMUNA		VARCHAR2(25)	NOT NULL,
	CONSTRAINT  COMUNA_PK PRIMARY KEY (ID_COMUNA, ID_CIUDAD,ID_REG),
	CONSTRAINT  COM_CI_FK FOREIGN KEY (ID_CIUDAD, ID_REG) REFERENCES CIUDAD (ID_CIUD, ID_REG)
);

-- Crear tabla CATALOGO_LENGUAJES_PROG
CREATE TABLE CATALOGO_LENGUAJES_PROG(
	ID_LENGUAJE		NUMBER(2)		NOT NULL CONSTRAINT HERRAMIENTA_PK PRIMARY KEY,	
	NOMBRE_LENGUAJE	VARCHAR2(25)	NOT NULL
);

-- Crear tabla POSTULANTE
CREATE TABLE POSTULANTE(
	ID_POSTULANTE NUMBER(5)	 NOT NULL CONSTRAINT POSTULANTE_PK PRIMARY KEY,
	RUT			  NUMBER(8)  CONSTRAINT POSTULANTE_RUT_UN UNIQUE,
	DV			  CHAR(1)	 NOT NULL CONSTRAINT POSTULANTE_DV_CK CHECK 
	(DV IN ('0','1','2','3','4','5','6','7','8','9','K')),
	P_NOMBRE	VARCHAR2(25) NOT NULL,
	S_NOMBRE	VARCHAR2(25),
	A_PATERNO	VARCHAR2(25) NOT NULL,
	A_MATERNO	VARCHAR2(25),
	CALLE 		VARCHAR2(25) NOT NULL,
	N_CALLE		NUMBER(4)	 NOT NULL,
	GENERO		CHAR(1)		 NOT NULL CONSTRAINT POSTULANTE_GENERO_CK CHECK
	(GENERO IN ('F','M')),
	EMAIL		VARCHAR2(30),
	FECHA_NCTO	DATE 		 NOT NULL CONSTRAINT POSTULANTE_FECHA_NCTO_CK CHECK
	(FECHA_NCTO > TO_DATE('01-12-2001','DD-MM-YYYY')),
	FONO 		NUMBER(8)	 NOT NULL,
	ENLACE_WEB	VARCHAR2(250),
	RENTA		NUMBER(7)	 NOT NULL CONSTRAINT POSTULANTE_RENTA_CK CHECK
	(RENTA > 350000),
	ID_COM 		NUMBER(4)	 NOT NULL,
	ID_ECIVIL 	NUMBER(1)	 CONSTRAINT POST_ECV_FK REFERENCES ESTADO_CIVIL (ID_ESTCIVIL),
	ID_CIUD 	NUMBER(4)	 NOT NULL,
	ID_REG 		NUMBER(2)	 NOT NULL, 
	CONSTRAINT P_COMU_FK     FOREIGN KEY (ID_COM, ID_CIUD, ID_REG) REFERENCES COMUNA (ID_COMUNA, ID_CIUDAD,ID_REG)
);

-- Crear tabla DETALLE_LENG
CREATE TABLE DETALLE_LENG(
	ID_POST NUMBER(5) NOT NULL CONSTRAINT LGJE_PRO_POSTU_FK REFERENCES POSTULANTE (ID_POSTULANTE),
	ID_LENG NUMBER(2) NOT NULL CONSTRAINT LGJE_PRO_HTA_FK	REFERENCES CATALOGO_LENGUAJES_PROG (ID_LENGUAJE),
	NIVEL	NUMBER(1) NOT NULL,
	CONSTRAINT LGJE_PROGRAMA_PK PRIMARY KEY (ID_POST, ID_LENG)
);


-- CREAR SECUENCIAS

-- Secuencia para región
CREATE SEQUENCE SEQ_REGION 
	START WITH 5 
	INCREMENT BY 5;

CREATE SEQUENCE SEQ_CIUDAD;

CREATE SEQUENCE SEQ_COMUNA
	START WITH 10 
	INCREMENT BY 10;

CREATE SEQUENCE SEQ_POSTULANTE;

CREATE SEQUENCE SEQ_EST_CIVIL;

CREATE SEQUENCE SEQ_CATALOGO_LENG_PROG;


-- POBLADO DE INFORMACIÓN

-- Poblado de estados civiles
INSERT INTO estado_civil VALUES (SEQ_EST_CIVIL.nextval,'Soltero');

INSERT INTO estado_civil VALUES (SEQ_EST_CIVIL.nextval,'Casado');

INSERT INTO estado_civil VALUES (SEQ_EST_CIVIL.nextval,'Viudo');

INSERT INTO estado_civil VALUES (SEQ_EST_CIVIL.nextval,'Divorciado');

-- Poblado de regiones
INSERT INTO region VALUES (SEQ_REGION.nextval,'Metropolitana de Santiago');

INSERT INTO region VALUES (SEQ_REGION.nextval,'Antofagasta');

INSERT INTO region VALUES (SEQ_REGION.nextval,'Valparaiso');

-- Poblado de ciudades (Necesarias para creación de comunas)
INSERT INTO ciudad VALUES (SEQ_CIUDAD.nextval,5,'Santiago');

INSERT INTO ciudad VALUES (SEQ_CIUDAD.nextval,15,'Valparaiso');

-- Poblado de comunas
INSERT INTO comuna VALUES (SEQ_COMUNA.nextval,1,5,'Maipú');

INSERT INTO comuna VALUES (SEQ_COMUNA.nextval,1,5,'Cerrillos');

-- DE MEMORIA A DISCO
COMMIT;


--DESNORMALIZAR

-- A)
ALTER TABLE REGION ADD CONTADOR NUMBER(5) DEFAULT 0;

-- B)
ALTER TABLE CATALOGO_LENGUAJES_PROG ADD CANTIDAD_DOMINAN_LENG NUMBER(5) DEFAULT 0;

-- C)
ALTER TABLE COMUNA ADD RESIDENTES NUMBER(5) DEFAULT 0;

-- D)
ALTER TABLE ESTADO_CIVIL ADD POSTULANTES_ESTCIVIL NUMBER(5) DEFAULT 0;