-- Ejercicio 1
SELECT
C.DESCRIPCION AS "NOMBRE CARRERA",
C.CARRERAID AS "IDENTIFICACION DE LA CARRERA",
e.descripcion,
COUNT(ALUMNOID) AS "TOTAL ALUMNOS MATRICULADOS", -- Es bueno contar PK (Por no ser null)
'Le corresponden ' || TO_CHAR(30200*COUNT(ALUMNOID), '$999G999') 
    || ' del presupuesto total asignado para pubicidad' AS "MONTO POR PUBLICIDAD"
FROM ALUMNO A INNER JOIN CARRERA C
ON (C.carreraid = A.carreraid)
INNER JOIN ESCUELA E
ON (E.escuelaid = c.escuelaid)
GROUP BY C.CARRERAID, C.DESCRIPCION, e.descripcion
HAVING (COUNT(ALUMNOID)>4)
ORDER BY 4 DESC, 2;

-- Ejercicio 2
SELECT
	DESCRIPCION,
	COUNT(ALUMNOID)
FROM ALUMNO A 
INNER JOIN CARRERA C
	ON (A.CARRERAID = C.CARRERAID)
GROUP BY (DESCRIPCION)
	HAVING COUNT(ALUMNOID) > 4
ORDER BY 1;

-- Ejercicio 4
SELECT
    A.ID_ESCOLARIDAD ESCOLARIDAD,
    DESC_ESCOLARIDAD "DESCRIPCIÓN ESCOLARIDAD",
    COUNT(RUN_EMP) "TOTAL DE EMPLEADOS",
    TO_CHAR(MAX(SALARIO), '$9G999G999') "SALARIO MÁXIMO",
    TO_CHAR(MIN(SALARIO), '$9G999G999') "SALARIO MINIMO",
    TO_CHAR(AVG(SALARIO), '$9G999G999') "SALARIO PROMEDIO"
FROM EMPLEADO A
INNER JOIN ESCOLARIDAD_EMP B
    ON (A.ID_ESCOLARIDAD = B.ID_ESCOLARIDAD)
GROUP BY (A.ID_ESCOLARIDAD, B.DESC_ESCOLARIDAD)
ORDER BY 3 DESC;

-- Ejercicio 6
SELECT
    TO_CHAR(RUN_EMP, '99G999G999') "RUN EMPLEADO",
    TO_CHAR(FECHA_INI_PRESTAMO, 'MM/YYYY') "MES PRESTAMOS LIBROS",
    COUNT(PRESTAMOID) "TOTAL PRESTAMOS ATENDIDOS",
    TO_CHAR(COUNT(PRESTAMOID)*10000, '$99,999') "ASIGNACION POR PRESTAMOS"
FROM PRESTAMO
WHERE 
    EXTRACT(YEAR FROM FECHA_INI_PRESTAMO) = 
    EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, -12))
GROUP BY    TO_CHAR(FECHA_INI_PRESTAMO, 'MM/YYYY'), 
            TO_CHAR(RUN_EMP, '99G999G999')
HAVING COUNT(PRESTAMOID)>2
ORDER BY 2 ASC, 4 DESC, 1 DESC;

-- Ejercicio 5
SELECT 
    T.tituloid AS "Codigo del libro",
    T.titulo "Titulo del libro",
    CASE
        WHEN COUNT(prestamoid)=1
            THEN 'No se requiere comprar nuevos ejemplares.'
        WHEN COUNT(prestamoid)>=2 AND COUNT(prestamoid)<=3
            THEN 'Se requiere comprar 1 nuevo ejemplar'
        WHEN COUNT(prestamoid)>=4 AND COUNT(prestamoid)<=5
            THEN 'Se requeire comprar 2 nuevos ejemplares'
        WHEN COUNT(prestamoid)>5
            THEN 'Se requeire comprar 4 nuevos ejemplares'
        ELSE 'El ejemplar no se pidio en los ultimos 12 meses.'
    END as SUGERENCIA
FROM PRESTAMO P
--RIGHT OUTER JOIN titulo T
JOIN titulo T
    ON (P.tituloid = T.tituloid)
WHERE
    EXTRACT(YEAR FROM fecha_ini_prestamo) = EXTRACT(YEAR FROM sysdate)-1
    -- MONTHS_BETWEEN(sysdate, fecha_ini_prestamo) <= 12
GROUP BY (T.tituloid, T.titulo)
ORDER BY count(prestamoid) DESC;

-- Ejercicio 3
SELECT
    TO_CHAR(run_jefe, '09g999g999')  || '-' ||
    CASE
        WHEN
            (11 -
            ((NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -1, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -2, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -3, 1) * 4), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -4, 1) * 5), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -5, 1) * 6), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -6, 1) * 7), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -7, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -8, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -9, 1) * 4), 0))
            -
            TRUNC((NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -1, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -2, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -3, 1) * 4), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -4, 1) * 5), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -5, 1) * 6), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -6, 1) * 7), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -7, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -8, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -9, 1) * 4), 0)) / 11) * 11))
            = 11
        THEN 'K'
        WHEN
            (11 -
            ((NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -1, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -2, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -3, 1) * 4), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -4, 1) * 5), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -5, 1) * 6), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -6, 1) * 7), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -7, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -8, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -9, 1) * 4), 0))
            -
            TRUNC((NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -1, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -2, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -3, 1) * 4), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -4, 1) * 5), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -5, 1) * 6), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -6, 1) * 7), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -7, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -8, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -9, 1) * 4), 0)) / 11) * 11))
            = 10
        THEN '0'
        ELSE
            TO_CHAR(11 -
            ((NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -1, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -2, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -3, 1) * 4), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -4, 1) * 5), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -5, 1) * 6), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -6, 1) * 7), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -7, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -8, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -9, 1) * 4), 0))
            -
            TRUNC((NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -1, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -2, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -3, 1) * 4), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -4, 1) * 5), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -5, 1) * 6), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -6, 1) * 7), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -7, 1) * 2), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -8, 1) * 3), 0) +
            NVL(TO_NUMBER(SUBSTR(TO_CHAR(run_jefe), -9, 1) * 4), 0)) / 11) * 11))
        END AS "RUN JEFE",
    COUNT(run_jefe) AS "TOTAL DE EMPLEADOS A SU CARGO",
    TO_CHAR(MAX(salario), '$99g999g999') AS "SALARIO MAXIMO", -- Se agrega $ a la izquierda
    (COUNT(run_jefe)/10)*100 || '% del Salario Máximo' AS "PORCENTAJE DE BONIFICACION",
    TO_CHAR((COUNT(run_jefe)/10)*MAX(salario), '$9g999g999') AS BONIFICACION
FROM empleado
WHERE
    run_jefe IS NOT NULL
GROUP BY (run_jefe)
ORDER BY 2;

SELECT
    TO_CHAR(J.run_emp, '09g999g999') || '-' || J.dv_run AS "RUN JEFE",
    COUNT(J.run_emp) AS "TOTAL DE EMPLEADOS A SU CARGO", -- COUNT(E.run_jefe)
    TO_CHAR(MAX(E.salario), '$99g999g999') AS "SALARIO MAXIMO",
    (COUNT(J.run_emp)/10)*100 || '% del Salario Máximo' AS "PORCENTAJE DE BONIFICACION",
    TO_CHAR((COUNT(J.run_emp)/10)*MAX(E.salario), '$9g999g999') AS BONIFICACION
FROM empleado J
JOIN empleado E ON
    J.run_emp = E.run_jefe
GROUP BY (J.run_emp, J.dv_run)
ORDER BY 2;