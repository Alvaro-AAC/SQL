-- User: SYSTEM

-- Crear un usuario nuevo para el owner
CREATE USER C##HAPPY_STUDENT IDENTIFIED BY 1234 DEFAULT TABLESPACE SYSAUX QUOTA 8M ON SYSAUX;

-- Otorgar privilegios para CONECTAR y RECURSOS
GRANT CONNECT, RESOURCE TO C##HAPPY_STUDENT;

-- User: C##HAPPY_STUDENT

-- Crear tabla NOTA_ALUMNO
CREATE TABLE NOTA_ALUMNO
(	numrut_alumno NUMBER(10)      NOT NULL,
	sigla_asignatura VARCHAR2(10) NOT NULL,
	nota1 NUMBER(2,1) NOT NULL,
	nota2 NUMBER(2,1) NOT NULL,
	nota3 NUMBER(2,1) NOT NULL,
	nota4 NUMBER(2,1) NOT NULL,
	nota5 NUMBER(2,1),
	promedio_final NUMBER(2,1)    NOT NULL,
	situacion_final VARCHAR2(1)   NOT NULL,
    CONSTRAINT PK_NOTA_ALUMNO PRIMARY KEY(numrut_alumno, sigla_asignatura)
);