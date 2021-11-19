-- Ejercicio 1 (Ya enviado)
CREATE TABLE MOVIMIENTOS_CLIENTE AS
SELECT 
    TO_CHAR(TO_NUMBER(SUBSTR(RUTCLIENTE, 1, LENGTH(RUTCLIENTE)-2)), '09G999G999') 
        || '-' || SUBSTR(RUTCLIENTE, LENGTH(RUTCLIENTE), 1) AS RUT_CLI,
    INITCAP(TO_CHAR(FECHA, 'month')) || ' ' || EXTRACT(YEAR FROM FECHA) AS PERIODO,
    LPAD(TOTAL, 10, 0) AS MONTO_BOLETA
FROM BOLETA
WHERE
    (CODPAGO = 2 OR CODPAGO IS NULL) AND                 --Medio de pago Debito o NULL
    CODBANCO IN (1, 3) AND                               --Banco Chile o BCI
    EXTRACT(YEAR FROM FECHA)<EXTRACT(YEAR FROM SYSDATE); --Años anteriores al actual
SELECT * FROM movimientos_cliente;


-- Ejercicio 2
SELECT
    TO_CHAR(TO_NUMBER(SUBSTR(RUTVENDEDOR, 1, LENGTH(RUTVENDEDOR)-2)), '99G999G999') 
        || '-' || SUBSTR(RUTVENDEDOR, LENGTH(RUTVENDEDOR), 1) AS "RUT VENDEDOR",
    SUELDO_BASE AS "SUELDO_BASE",
    TRUNC((SYSDATE-FECHA_NAC)/365) AS EDAD,
    NVL(TO_CHAR(COMISION, '0.9'), 'NO TIENE COMISIÓN') AS "COMISIÓN",
    TO_CHAR((CASE
        WHEN 
            TRUNC((SYSDATE-FECHA_NAC)/365) 
            BETWEEN 18 AND 25 
            THEN 0.055
        WHEN 
            TRUNC((SYSDATE-FECHA_NAC)/365) 
            BETWEEN 26 AND 30 
            THEN 0.10
        WHEN 
            TRUNC((SYSDATE-FECHA_NAC)/365) 
            > 30 
            THEN 0.15
        ELSE 0
    END * SUELDO_BASE) + SUELDO_BASE, '$9G999G999G999') AS "SUELDO REAJUSTADO"
FROM VENDEDOR
WHERE 
    CODCOMUNA IN (9, 7, 5) OR
    INSTR(LOWER(DIRECCION), 'alameda', 1) != 0;


-- Ejercicio 3 (Pregunta 'Competencia empleabilidad' al final)
SELECT
INITCAP(
SUBSTR(TRIM(NOMBRE), 1, INSTR(TRIM(NOMBRE), ' ', 1)) ||
SUBSTR(TRIM(SUBSTR(TRIM(NOMBRE), INSTR(TRIM(NOMBRE), ' ', 1), LENGTH(TRIM(NOMBRE)))), 1, INSTR(TRIM(SUBSTR(TRIM(NOMBRE),  INSTR(TRIM(NOMBRE), ' ', 1), LENGTH(TRIM(NOMBRE)))), ' ', 1, 1)) ||
TRIM(SUBSTR(TRIM(TRIM(SUBSTR(TRIM(NOMBRE), INSTR(TRIM(NOMBRE), ' ', 1), LENGTH(TRIM(NOMBRE))))), INSTR(TRIM(SUBSTR(TRIM(NOMBRE), INSTR(TRIM(NOMBRE), ' ', 1), LENGTH(TRIM(NOMBRE)))), ' ', 1,1 ), LENGTH(TRIM(NOMBRE))))
) AS VENDEDOR, -- ¿Posible optimizar?
TO_CHAR(CASE
    WHEN 
        UPPER(SUBSTR(TRIM(DIRECCION),1 ,1))
        BETWEEN 'A' AND 'E'
        THEN LAST_DAY(ADD_MONTHS(SYSDATE, 6))
    WHEN
        UPPER(SUBSTR(TRIM(DIRECCION),1 ,1))
        IN ('F', 'H', 'J', 'K', 'L', 'M', 'N')
        THEN LAST_DAY(ADD_MONTHS(SYSDATE, 7))
    WHEN 
        UPPER(SUBSTR(TRIM(DIRECCION),1 ,1))
        BETWEEN 'O' AND 'R'
        THEN LAST_DAY(ADD_MONTHS(SYSDATE, 8))
    ELSE
        LAST_DAY(ADD_MONTHS(SYSDATE, 9))
END, 'DD') -- Último día
|| ' de ' ||
trim(TO_CHAR(CASE
    WHEN 
        UPPER(SUBSTR(TRIM(DIRECCION),1 ,1))
        BETWEEN 'A' AND 'E'
        THEN LAST_DAY(ADD_MONTHS(SYSDATE, 6))
    WHEN
        UPPER(SUBSTR(TRIM(DIRECCION),1 ,1))
        IN ('F', 'H', 'J', 'K', 'L', 'M', 'N')
        THEN LAST_DAY(ADD_MONTHS(SYSDATE, 7))
    WHEN 
        UPPER(SUBSTR(TRIM(DIRECCION),1 ,1))
        BETWEEN 'O' AND 'R'
        THEN LAST_DAY(ADD_MONTHS(SYSDATE, 8))
    ELSE
        LAST_DAY(ADD_MONTHS(SYSDATE, 9))
END, 'Month')) -- Mes
|| ' del ' ||
TO_CHAR(CASE
    WHEN 
        UPPER(SUBSTR(TRIM(DIRECCION),1 ,1))
        BETWEEN 'A' AND 'E'
        THEN LAST_DAY(ADD_MONTHS(SYSDATE, 6))
    WHEN
        UPPER(SUBSTR(TRIM(DIRECCION),1 ,1))
        IN ('F', 'H', 'J', 'K', 'L', 'M', 'N')
        THEN LAST_DAY(ADD_MONTHS(SYSDATE, 7))
    WHEN 
        UPPER(SUBSTR(TRIM(DIRECCION),1 ,1))
        BETWEEN 'O' AND 'R'
        THEN LAST_DAY(ADD_MONTHS(SYSDATE, 8))
    ELSE
        LAST_DAY(ADD_MONTHS(SYSDATE, 9))
END, 'YYYY') AS "Citado el  ", -- Año
LOWER(SUBSTR(TRIM(NOMBRE), 1, INSTR(TRIM(NOMBRE), ' ', 1, 1)-1)) || -- Nombre minusculas
SUBSTR(TO_CHAR(TELEFONO), LENGTH(TELEFONO)-2, 3) ||                 -- 3 Últimos dígitos
'@almacenesSyS.cl' AS "Enviar mail a"                               -- Correo final
FROM VENDEDOR
ORDER BY 1, 2 DESC;
-- P: Explique con sus palabras cómo abordó el problema de la construcción del mail que contiene un nombre no Normalizado en la base de datos.
-- R: Lo primero era extraer el primer nombre del vendedor, para esto use apliqué un SubString que comenzara desde el inicio del nombre (limpiado) hasta el primer espacio que detectara. 
--      Luego limpie esto por si había algun espacio demás.
--      Lo siguiente fue concatenar los últimos 3 digitos del número, para lo cual converti a String el numero de telefono y, de eso, saqué un SubString que comenzara en la longitud del string menos 2 y acabara al final del String.
--      Lo último fue derechamente concatenar el correo ya otorgado (estandar: '@almacenesSyS.cl').


-- Ejercicio 4 (Pregunta 'Competencia empleabilidad' al final)
CREATE TABLE HORAS_EXTRAS_VENDEDOR AS
SELECT
    TO_CHAR(SUBSTR(TRIM(RUTVENDEDOR), 1, LENGTH(RUTVENDEDOR)-2), '099G999G999') AS RUT_VENDEDOR,
    SUBSTR(TRIM(RUTVENDEDOR), -1, 1) AS DV,
    TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2)) || ':' || TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 4, 2)) AS HRA_INI,
    TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 1, 2)) || ':' || SUBSTR(TRIM(TURNO_FIN), 4, 2) AS HRA_FIN,
    TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 1, 2)) - TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2)) + 
    CASE -- Si la hora empieza a las xx:00 y termina a las xx:30, se le suma media hora (0.5)
        WHEN
        TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 4, 2)) = 0
        AND
        TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 4, 2)) = 30
        THEN 0.5
        ELSE 0
    END AS HH_EXTRAS_PAGAR,
    TO_CHAR((TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 1, 2)) - TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2)) + 
    CASE
        WHEN
        TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 4, 2)) = 0
        AND
        TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 4, 2)) = 30
        THEN 0.5
        ELSE 0
    END) * 6500, '$999G999') AS MONTO_A_PAGO
FROM TURNO_VENDEDOR
WHERE TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2)) BETWEEN 11 AND 24
ORDER BY MONTO_A_PAGO DESC;
SELECT * FROM HORAS_EXTRAS_VENDEDOR;

-- Ejercicio 4 (Pregunta 'Competencia empleabilidad' al final) Contabilizando TODO turno que termine después de las 11:00 AM.
CREATE TABLE HORAS_EXTRAS_VENDEDOR AS
SELECT
    TO_CHAR(SUBSTR(TRIM(RUTVENDEDOR), 1, LENGTH(RUTVENDEDOR)-2), '099G999G999') AS RUT_VENDEDOR,
    SUBSTR(TRIM(RUTVENDEDOR), -1, 1) AS DV,
    TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2)) || ':' || TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 4, 2)) AS HRA_INI,
    TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 1, 2)) || ':' || SUBSTR(TRIM(TURNO_FIN), 4, 2) AS HRA_FIN,
    TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 1, 2)) - 
    CASE -- Si la hora empieza antes de las 11:00, solo se contabilizan las horas exatra desde las 11:00.
        WHEN TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2)) < 11
        THEN 11
        ELSE TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2))
    END + 
    CASE -- Si la hora empieza a las xx:00 y termina a las xx:30, se le suma media hora (0.5) OR si el turno empezó antes de las 11, pero terminó después.
        WHEN
        (TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 4, 2)) = 0
        AND
        TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 4, 2)) = 30)
        OR
        TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2)) < 11
        THEN 0.5
        ELSE 0
    END AS HH_EXTRAS_PAGAR,
    TO_CHAR((TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 1, 2)) - 
    CASE
        WHEN TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2)) < 11
        THEN 11
        ELSE TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2))
    END + 
    CASE
        WHEN
        (TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 4, 2)) = 0
        AND
        TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 4, 2)) = 30)
        OR
        TO_NUMBER(SUBSTR(TRIM(TURNO_INI), 1, 2)) < 11
        THEN 0.5
        ELSE 0
    END) * 6500, '$999G999') AS MONTO_A_PAGO
FROM TURNO_VENDEDOR
WHERE TO_NUMBER(SUBSTR(TRIM(TURNO_FIN), 1, 2)) BETWEEN 11 AND 24
ORDER BY MONTO_A_PAGO DESC;
SELECT * FROM HORAS_EXTRAS_VENDEDOR;

-- P: ¿Cuál es la información significativa que necesita para resolver el problema?.
-- La información revelante es, de partida, la tabla a trabajar, en este caso, 'turno_vendedor'. 
--      Luego de eso, es importante discriminar la información, ya que solo nos interesa los turnos que terminen despues de las 11:00 (solo horas extras)
--      También nos interesa tener en cuenta la cantidad de dinero por hora extra, la cual nos dará el valor de la 4ta columna.
--      Y, para finalizar, el orden que va a llevar nuestra consulta, la cual sería el dinero total de mayor a menor, es decir, la 4ta columna de manera descendente.
-- P: Explique cómo resolvió el manejo de los turnos para generar los cálculos de las horas extras.
-- Para poder calcular las horas extras de manera correcta, lo primero que hice fue dividir la hora en HORAS y MINUTOS, ambos de manera numérica, así podría trabajar con ellos.
--      Luego, me interesaba saber la diferencia, es decir, Δ Hora (horaFin - horaIni). Así obtuve las horas, sin embargo, esta información es en extrema imprecisa.
--      Para mayor éxactitud en la hora, lo primero que hice fue determinar que horas empezaban en el minuto 00 y terminaban en el minuto 30, agregandole 0,5 a la hora si fuese el caso.
--      Esto era para lograr añadirle esa media hora a las horas extras de cada persona.
--      Una vez solucionado ese problema, decidí tomar la siguiente y última inexactitud, la cual era los horarios que comenzaban antes de las 11:00 AM, pero terminaban después de esta.
--      Entonces, para cada hora comenzada antes de las 11, pero terminada después, reemplaze horaIni por 11 en Δ Hora, obteniendo así solo el dato que nos interesaba (horas extras).