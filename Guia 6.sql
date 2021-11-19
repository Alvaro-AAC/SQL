-- Ejercicio 1
SELECT 
    U.nombre AS unidad, 
    M.pnombre || ' ' || M.apaterno || ' ' || M.amaterno AS medico, 
    SUBSTR(u.nombre, 1, 2) || SUBSTR(M.apaterno, -3, 2) || 
        SUBSTR(M.telefono, 1, 3) || EXTRACT(YEAR FROM M.fecha_contrato) || '@medicocktk.cl'  AS correo,
    COUNT(A.med_rut) AS "ATENCIONES MEDICAS"
FROM medico M
LEFT JOIN atencion A
    ON M.med_rut = A.med_rut 
        AND EXTRACT (YEAR FROM A.fecha_atencion) = EXTRACT (YEAR FROM sysdate) -1
JOIN unidad U
    ON M.uni_id = U.uni_id
--WHERE EXTRACT (YEAR FROM A.fecha_atencion) = EXTRACT (YEAR FROM sysdate) -1 or A.fecha_atencion is null
GROUP BY M.med_rut, M.pnombre, M.apaterno, M.amaterno, U.nombre, M.telefono, M.fecha_contrato
HAVING count(A.med_rut) < 
    (SELECT MAX(COUNT(med_rut)) 
        FROM atencion 
        WHERE EXTRACT (YEAR FROM fecha_atencion) = EXTRACT (YEAR FROM sysdate) -1
        GROUP BY med_rut)
ORDER BY 1, M.apaterno;

-- Ejercico 2.1
SELECT
    TO_CHAR(fecha_atencion, 'MM/YYYY') as "MES Y ANNIO",
    COUNT(ate_id) as "TOTAL DE ATENCIONES",
    TO_CHAR(SUM(costo), '$9g999g999') as "VALOR TOTAL DE LAS ATENCIONES"
FROM atencion
WHERE EXTRACT(YEAR FROM fecha_atencion) = EXTRACT (YEAR FROM ADD_MONTHS(sysdate, -12))
GROUP BY TO_CHAR(fecha_atencion, 'MM/YYYY')
HAVING COUNT(ate_id) > (
    SELECT
        AVG(COUNT(ate_id))
    FROM atencion
    WHERE EXTRACT(YEAR FROM fecha_atencion) = EXTRACT (YEAR FROM sysdate)-1
    GROUP BY TO_CHAR(fecha_atencion, 'MM/YYYY')
)
ORDER BY 1;

-- Ejercicio 2.2
SELECT
    P.pac_rut || '-' || P.dv_rut AS "RUT PACIENTE",
    INITCAP(P.apaterno) AS apaterno,
    A.ate_id,
    TO_CHAR(PA.fecha_venc_pago, 'DD/MM/YYYY') AS fecha_venc_pago,
    TO_CHAR(PA.fecha_pago, 'DD/MM/YYYY') AS fecha_pago,
    PA.fecha_pago - PA.fecha_venc_pago AS dias_morosidad,
    (PA.fecha_pago - PA.fecha_venc_pago) * 1000 AS multa
FROM pago_atencion PA
JOIN atencion A
    ON (PA.ate_id = A.ate_id)
JOIN paciente P
    ON (A.pac_rut = P.pac_rut)
WHERE 
    PA.fecha_pago - PA.fecha_venc_pago < (
        SELECT
            AVG(fecha_pago - fecha_venc_pago)
        FROM pago_atencion
        WHERE EXTRACT (YEAR FROM fecha_pago) = EXTRACT (YEAR FROM sysdate) -1
    ) AND
    PA.fecha_pago - PA.fecha_venc_pago > 0 AND
    EXTRACT (YEAR FROM fecha_pago) = EXTRACT (YEAR FROM sysdate) -1
ORDER BY PA.fecha_venc_pago ASC, 6 DESC;

-- ACTUALIZADO PARA 2021
SELECT
    P.pac_rut || '-' || P.dv_rut AS "RUT PACIENTE",
    INITCAP(P.apaterno) AS apaterno,
    A.ate_id,
    TO_CHAR(PA.fecha_venc_pago, 'DD/MM/YYYY') AS fecha_venc_pago,
    TO_CHAR(PA.fecha_pago, 'DD/MM/YYYY') AS fecha_pago,
    PA.fecha_pago - PA.fecha_venc_pago AS dias_morosidad,
    (PA.fecha_pago - PA.fecha_venc_pago) * 1000 AS multa
FROM pago_atencion PA
JOIN atencion A
    ON (PA.ate_id = A.ate_id)
JOIN paciente P
    ON (A.pac_rut = P.pac_rut)
WHERE 
    PA.fecha_pago - PA.fecha_venc_pago < (
        SELECT
            AVG(fecha_pago - fecha_venc_pago)
        FROM pago_atencion
        WHERE EXTRACT (YEAR FROM fecha_pago) = EXTRACT (YEAR FROM sysdate)
    ) AND
    PA.fecha_pago - PA.fecha_venc_pago > 0 AND
    EXTRACT (YEAR FROM fecha_pago) = EXTRACT (YEAR FROM sysdate)
ORDER BY PA.fecha_venc_pago ASC, 6 DESC;

-- Ejercicio 3
SELECT
    TS.descripcion || ',' || S.descripcion AS sistema_salud,
    COUNT(A.ate_id)
FROM SALUD S
JOIN TIPO_SALUD TS
    ON (S.tipo_sal_id = TS.tipo_sal_id)
JOIN PACIENTE P
    ON (S.sal_id = P.sal_id)
JOIN ATENCION A
    ON (P.pac_rut = A.pac_rut)
WHERE TO_CHAR(A.fecha_atencion, 'MM/YYYY') = TO_CHAR(ADD_MONTHS(sysdate, -4), 'MM/YYYY')
GROUP BY (TS.descripcion || ',' || S.descripcion)
ORDER BY 1;

-- Ejercicio 4
SELECT
    LOWER(E.nombre) AS especialidad,
    TO_CHAR(M.med_rut, '09g999g999') || '-' || M.dv_rut AS rut,
    M.pnombre || ' ' || M.snombre || ' ' || M.apaterno || ' ' || M.amaterno AS medico
FROM especialidad E
JOIN especialidad_medico EM
    ON (E.esp_id = EM.esp_id)
JOIN medico M
    ON (EM.med_rut = M.med_rut)
JOIN atencion A
    ON (A.med_rut = M.med_rut)
WHERE EXTRACT (YEAR FROM A.fecha_atencion) = EXTRACT (YEAR FROM sysdate) - 1
HAVING (COUNT(A.ate_id) < 10)
GROUP BY (TO_CHAR(M.med_rut, '09g999g999') || '-' || M.dv_rut, LOWER(E.nombre), M.pnombre || ' ' || M.snombre || ' ' || M.apaterno || ' ' || M.amaterno)
;