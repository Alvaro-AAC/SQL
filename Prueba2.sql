-- PRUEBA 2 - FORMA C - SECCION 005D
-- Brian Urbina y Álvaro Arenas

-- Ejercicio 1
CREATE TABLE RESUMEN_POR_PAIS AS
SELECT
    INITCAP(pa.nompais) AS pais_origen,
    INITCAP(u.descripcion) AS unidad,
    COUNT(codproducto) AS cantidad
FROM producto pr
JOIN pais pa
    ON (pr.codpais = pa.codpais)
JOIN UNIDAD_MEDIDA u
    ON (pr.codunidad = u.codunidad)
WHERE totalstock > (stkseguridad + 30) 
GROUP BY (pr.codpais, pa.nompais, u.descripcion)
HAVING COUNT(codproducto) <= (
    SELECT
        AVG(COUNT(NVL(codproducto, 0)))
    FROM producto pr
    RIGHT OUTER JOIN pais pa
        ON (pr.codpais = pa.codpais)
    GROUP BY (pa.codpais)
    )
ORDER BY 1, 3 DESC;

-- Querie a la tabla creada
SELECT
*
FROM RESUMEN_POR_PAIS;

-- Ejercicio 2
CREATE TABLE Resumen_Carga AS
SELECT
    NVL(TO_CHAR(fecha_carga, 'MM-YYYY'), '11-2021') AS cargado,
    LPAD(NVL(TO_CHAR(telefono, '099999999999'), 'Desconocido'), 13, ' ') AS fono,
    NVL(mail, 'No/Aplica') AS "E-MAIL",
    NVL(total, 0) AS monto_total,
    NVL(ba.descripcion, 'Sin Datos') AS banco
FROM CLIENTE CLI
JOIN BOLETA BO
    ON (cli.rutcliente = bo.rutcliente)
JOIN BANCO BA
    ON (bo.codbanco = ba.codbanco)
FULL JOIN COMUNA co
    ON (cli.codcomuna = co.codcomuna)
ORDER BY 1, 4; -- ASC (predeterminado)

-- Querie a la tabla creada

SELECT * FROM Resumen_Carga;

-- Ejercicio 3
SELECT
    TO_CHAR(TO_NUMBER(SUBSTR(rutvendedor, 0, INSTR(rutvendedor, '-')-1)), '09g999g999')
        || '-' || SUBSTR(rutvendedor, -1, 1) AS rut_vendedor,
    INITCAP(nombre) AS vendedor,
    UPPER(direccion) AS direccion,
    UPPER(c.descripcion) AS comuna,
    sueldo_base,
    ROUND((sueldo_base*NVL(comision, 0)) + (sueldo_base*porc_honorario)) AS incremento_con_comision,
    TO_CHAR(ROUND((sueldo_base*NVL(comision, 0)) + (sueldo_base*porc_honorario) + sueldo_base), '$9g999g999') AS a_pagar,
    CASE
        WHEN ROUND((sueldo_base*NVL(comision, 0)) + (sueldo_base*porc_honorario) + sueldo_base) > 800000
            THEN 'Alto'
        WHEN ROUND((sueldo_base*NVL(comision, 0)) + (sueldo_base*porc_honorario) + sueldo_base) BETWEEN 350001 AND 799999
            THEN 'Medio'
        WHEN ROUND((sueldo_base*NVL(comision, 0)) + (sueldo_base*porc_honorario) + sueldo_base) < 350000
            THEN 'Bajo'
    END AS rango -- 800.000 y 350.000 no considerado en base a lo determinado por el caso
FROM vendedor V
JOIN rangos_sueldos RS
    ON (sueldo_base BETWEEN sueldo_min AND sueldo_max)
JOIN comuna C
    ON (v.codcomuna = c.codcomuna);
-- ORDER BY 7 DESC; -- No se especifica order by, pero asi se ve como en la fotito

-- Caso 3.2
UPDATE vendedor vbase
    SET sueldo_reajustado = sueldo_base * (1 + NVL(comision, 0) +(
        SELECT
            NVL(porc_honorario, 0)
        FROM vendedor vsubq
        LEFT JOIN rangos_sueldos rs
            ON (sueldo_base BETWEEN sueldo_min AND sueldo_max)
        WHERE vbase.id_vendedor = vsubq.id_vendedor
    ));