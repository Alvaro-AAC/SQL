-- Ejercicio 3
SELECT 
    TO_CHAR(cc.fecha_otorga_cred, 'MMYYYY') AS "MES TRANSACCION",
    UPPER(c.nombre_credito) AS "TIPO CREDITO",
    SUM(monto_credito) AS "MONTO SOLICITADO CREDITO",
    ROUND(CASE
        WHEN SUM(monto_credito)
            BETWEEN 100000 AND 1000000
            THEN 0.01
        WHEN SUM(monto_credito)
            BETWEEN 1000001 AND 2000000
            THEN 0.02
        WHEN SUM(monto_credito)
            BETWEEN 2000001 AND 4000000
            THEN 0.03
        WHEN SUM(monto_credito)
            BETWEEN 4000001 AND 6000000
            THEN 0.04
        WHEN SUM(monto_credito)
            > 6000000
            THEN 0.07
    END*SUM(monto_credito)) AS "APORTE A LA SBIF"
FROM credito_cliente CC
JOIN credito C
ON (cc.cod_credito = C.cod_credito)
WHERE EXTRACT(YEAR FROM cc.fecha_otorga_cred) = EXTRACT(YEAR FROM ADD_MONTHS(sysdate, -12))
GROUP BY TO_CHAR(cc.fecha_otorga_cred, 'MMYYYY'), UPPER(c.nombre_credito)
ORDER BY 1, 2;

--SET
-- UNION, UNION ALL, INTERSECT, MINUS

SELECT nro_cliente
FROM cliente
INTERSECT
SELECT nro_cliente
FROM credito_cliente;
