-- Ejercicio 1
SELECT
    TO_CHAR(NUMRUN, '09G999G999') || '-' || UPPER(DVRUN) RUT,
    INITCAP(TRIM(APPATERNO) || ' ' || TRIM(APMATERNO) || ' ' || TRIM(PNOMBRE)) NOMBRE_CLI,
    TO_CHAR(FECHA_NACIMIENTO, 'DD/MM/YYYY') FECHA_NAC,
    RPAD(CASE COD_TIPO_CLIENTE
        WHEN 1 THEN 'Dependiente'
        WHEN 2 THEN 'Independiente'
        WHEN 3 THEN 'Tercera Edad'
        ELSE 'NO APLICA'
    END, 14, ' ') TIPO_CLI
FROM CLIENTE
WHERE EXTRACT(YEAR FROM FECHA_NACIMIENTO) BETWEEN 1957 AND 1960 AND (COD_REGION IN (2, 3, 15) OR COD_PROF_OFIC IN (1 , 2 , 3))
--WHERE TO_NUMBER(TO_CHAR(FECHA_NACIMIENTO, 'YYYY')) BETWEEN 1957 AND 1960
ORDER BY 4, FECHA_NACIMIENTO DESC;

--Ejercicio 2
SELECT
    UPPER(TRIM(APPATERNO) || ' ' || TRIM(PNOMBRE)) NOMBRE,
    '30 ' ||
    CASE
        WHEN
            UPPER(SUBSTR(LTRIM(APPATERNO), 1, 1))
            IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I')
            THEN 'Septiembre'
        WHEN
            UPPER(SUBSTR(LTRIM(APPATERNO), 1, 1))
            IN ('J', 'K', 'N')
            THEN 'Octubre'
        WHEN
            UPPER(SUBSTR(LTRIM(APPATERNO), 1, 1))
            IN ('O', 'P', 'Q', 'R', 'S')
            THEN 'Noviembre'
        ELSE
            'Diciembre'
    END
     || ' del ' || to_char(sysdate, 'YYYY') AS "Habilitar encuesta el:",
    LOWER(SUBSTR(TRIM(PNOMBRE), 1, 2)) || '.' || LOWER(TRIM(APPATERNO)) || NRO_CLIENTE || '@gmail.com' "Enviar mail a:"
FROM CLIENTE
ORDER BY TRIM(APPATERNO) DESC;

--Ejercicio 3
SELECT
    TO_CHAR(NRO_CLIENTE, '000000') NUMERO_CLI,
    --TO_NUMBER(TO_CHAR(CURRENT_DATE, 'YYYY'))-TO_NUMBER(TO_CHAR(FECHA_INSCRIPCION, 'YYYY')) "AÑOS ANTIGÜEDAD",
    TRUNC(TO_NUMBER(CURRENT_DATE-FECHA_INSCRIPCION)/365) "AÑOS ANTIGÜEDAD",
    TO_CHAR(FECHA_NACIMIENTO, 'MM') MES_NACIMIENTO,
    TO_CHAR(CASE
        WHEN 
            EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM FECHA_INSCRIPCION)
            BETWEEN 5 AND 10
            THEN 500
        WHEN
            EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM FECHA_INSCRIPCION)
            BETWEEN 11 AND 20
            THEN 600
        WHEN
            EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM FECHA_INSCRIPCION)
            > 20
            THEN 700
        ELSE 0
    END * TO_NUMBER(TO_CHAR(FECHA_NACIMIENTO, 'MM')), '99G999G999') PUNTAJE
FROM CLIENTE
ORDER BY 4 DESC;

--Ejercicio 4
CREATE TABLE POSIBLES_CLIENTES AS
SELECT 
    TO_CHAR(TRIM(SUBSTR(RUN, 1, LENGTH(RUN)-1)), '09999999') || '-' || SUBSTR(RUN, -1) as RUT,
    INITCAP(TRIM(SUBSTR(TRIM(NOMBRE), 1, INSTR(TRIM(NOMBRE), '-')-1))) as NOMBRE_C,
    INITCAP(TRIM(SUBSTR(TRIM(NOMBRE), INSTR(TRIM(NOMBRE), '-', 1, 2)+1, LENGTH(TRIM(NOMBRE))))) as APELLIDO_C
FROM PROSPECTOS_CLIENTE
ORDER BY 2;
SELECT * FROM POSIBLES_CLIENTES;

--Ejercicio 5
SELECT
    UPPER(TRIM(APPATERNO) || ' ' || TRIM(APMATERNO) || ' ' || TRIM(PNOMBRE)) AS "NOMBRE CLIENTE",
    NVL(LOWER(CORREO), 'No Existe e-mail') AS CORREO,
    --NVL(TO_CHAR(FONO_CONTACTO, '00000000000000000'), 'Falta informacion') AS CONTACTO
    NVL(LPAD(FONO_CONTACTO, 17, '0'), 'Falta informacion') AS CONTACTO
FROM CLIENTE
WHERE 
    --SUBSTR(TRIM(UPPER(DIRECCION)), INSTR(UPPER(DIRECCION), 'SAN'), 3) = 'SAN'
    --UPPER(DIRECCION) LIKE '_V%'
    UPPER(DIRECCION) LIKE '%SAN%'
    AND 
    --(SUBSTR(UPPER(CORREO), INSTR(UPPER(CORREO), '.CL'), 3) = '.CL' OR CORREO IS NULL)
    (LOWER(CORREO) LIKE '%.cl' OR CORREO IS NULL)
ORDER BY 3 DESC, 2;