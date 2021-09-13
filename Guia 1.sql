--Ejercicio 1
SELECT 'El empleado ' || NOMBRE_EMP ||' '|| APPATERNO_EMP ||' '|| APMATERNO_EMP ||' nació el '|| TO_CHAR(fecnac_emp,'DD/mm/YYYY' ) AS "LISTADO DE CUMPLEAÑOS"
FROM EMPLEADO
ORDER BY fecnac_emp ASC, appaterno_emp;

--Ejercicio 2
SELECT 
NUMRUT_CLI AS "NUMERO RUT",
DVRUT_CLI AS "DIGITO VERIFICADOR",
APPATERNO_CLI ||' '|| APMATERNO_CLI ||' '|| NOMBRE_CLI AS "NOMBRE CLIENTE",
RENTA_CLI AS "RENTA",
FONOFIJO_CLI AS "TELEFONO FIJO",
CELULAR_CLI AS "CELULAR"
FROM cliente
ORDER BY appaterno_cli, apmaterno_cli;

--Ejercicio 3
SELECT
nombre_emp ||' '|| appaterno_emp ||' '|| apmaterno_emp AS "NOMBRE EMPLEADO",
sueldo_emp as "SUELDO",
ROUND(sueldo_emp/2) as "BONO POR CAPACITACION"
FROM empleado
ORDER BY 3 DESC; --ORDER BY ROUND(sueldo_emp/2) --DESC; ORDER BY "BONO POR CAPACITACION" DESC;


--AfterClass

--Ejercicio 1
SELECT 'El empleado ' || NOMBRE_EMP ||' '|| APPATERNO_EMP ||' '|| APMATERNO_EMP ||' nació el '|| TO_CHAR(fecnac_emp,'DD/mm/YYYY' ) AS "LISTADO DE CUMPLEAÑOS"
FROM EMPLEADO
ORDER BY fecnac_emp ASC, appaterno_emp;

--Ejercicio 2
SELECT 
NUMRUT_CLI AS "NUMERO RUT",
DVRUT_CLI AS "DIGITO VERIFICADOR",
APPATERNO_CLI ||' '|| APMATERNO_CLI ||' '|| NOMBRE_CLI AS "NOMBRE CLIENTE",
RENTA_CLI AS "RENTA",
FONOFIJO_CLI AS "TELEFONO FIJO",
CELULAR_CLI AS "CELULAR"
FROM cliente
ORDER BY appaterno_cli, apmaterno_cli;

--Ejercicio 3 (mejorada)
SELECT
INITCAP(nombre_emp ||' '|| appaterno_emp ||' '|| apmaterno_emp) AS "NOMBRE EMPLEADO",
TO_CHAR(sueldo_emp, '$9g999g999') as "SUELDO",
TO_CHAR(ROUND(sueldo_emp/2),'$9g999g999') as "BONO POR CAPACITACION",
NVL(CELULAR_EMP, 0) as CELULAR --Si es null
FROM empleado
ORDER BY 3 DESC; --ORDER BY ROUND(sueldo_emp/2) --DESC; ORDER BY "BONO POR CAPACITACION" DESC;}

--Ejercicio 6
SELECT
INITCAP(nombre_emp ||' '|| appaterno_emp ||' '|| apmaterno_emp) AS "NOMBRE EMPLEADO",
TO_CHAR(SUELDO_EMP,'$9g999g999') salario,
TO_CHAR(ROUND(sueldo_emp*0.055),'$9g999g999') colacion,
TO_CHAR(ROUND(sueldo_emp*0.178),'$9g999g999') movilizacion,
TO_CHAR(ROUND(sueldo_emp*0.078),'$9g999g999') salud,
TO_CHAR(ROUND(sueldo_emp*0.065),'$9g999g999') afp,
TO_CHAR(ROUND(sueldo_emp) + ROUND(sueldo_emp*0.055) + ROUND(sueldo_emp*0.178) - ROUND(sueldo_emp*0.078) - ROUND(sueldo_emp*0.065),'$9g999g999') as "ALCANCE LÍQUIDO"
FROM empleado
--WHERE sueldo_emp*0.065 > 100000
ORDER BY APPATERNO_EMP;