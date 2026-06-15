/*
Las siguientes relaciones corresponden a la base de datos de una agencia de viajes que vende paquetes turísticos y posee varias sucursales.

cliente = {nroDoc, nombre, direc, tel, email} 
suc = {codS, direcc, whatsapp, localidad} 
paqTur = {codP, precio, descrip, paisDestino, fSalida,cantDias}
venta = {codP, codS, nroDoc, fVta, formaPago (tarj.crédito, tarj.débito, efectivo…)}
*/

-- 1. Mostrar los paquetes (código y descripción) que se vendieron tanto en sucursales de Capital como de Caucete.

SELECT p.codP, p.descrip FROM paqTur p
JOIN venta v ON p.codP = v.codP
JOIN suc s ON v.codS = s.codS
WHERE s.localidad = 'Capital'

INTERSECT

SELECT p.codP, p.descrip FROM paqTur p
JOIN venta v ON p.codP = v.codP
JOIN suc s ON v.codS = s.codS
WHERE s.localidad = 'Caucete';

    -- Alternativa:
    SELECT p.codP, p.descrip FROM paqTur p
    JOIN venta v ON p.codP = v.codP
    JOIN suc s ON v.codS = s.codS
    WHERE s.localidad IN ('Capital', 'Caucete')
    GROUP BY p.codP, p.descrip
    HAVING COUNT(DISTINCT s.localidad) = 2;

-- 2. Obtener el nombre y teléfono de los clientes que compraron TODOS los paquetes turísticos con destino a España. Pueden existir varios paquetes al mismo destino.

SELECT c.nombre, c.tel FROM cliente c
WHERE NOT EXISTS(
    SELECT 1 FROM paqTur p
    WHERE p.paisDestino = 'España'
    AND NOT EXISTS(
        SELECT 1 FROM venta v
        WHERE v.codP = p.codP AND v.nroDoc = c.nroDoc
    )
);

-- 3. Mostrar para cada sucursal de Capital, el código de sucursal junto a la cantidad de paquetes turísticos vendidos en efectivo.

SELECT s.codS, COUNT(*) AS cant_vendida FROM suc s
JOIN venta v ON s.codS = v.codS
WHERE s.localidad = 'Capital' AND v.formaPago = 'Efectivo'
GROUP BY s.codS;

-- 4. Sucursales (código) que vendieron sólo paquetes turísticos a Brasil.

SELECT s.codS FROM suc s
JOIN venta v ON s.codS = v.codS
JOIN paqTur p ON v.codP = p.codP
WHERE p.paisDestino = 'Brasil'

EXCEPT

SELECT s.codS FROM suc s
JOIN venta v ON s.codS = v.codS
JOIN paqTur p ON v.codP = p.codP
WHERE p.paisDestino <> 'Brasil';

    -- Alternativa con EXISTS/NOT EXISTS:
    SELECT s.codS FROM suc s
    WHERE EXISTS(
        SELECT 1 FROM venta v
        WHERE v.codS = s.codS   -- Asegura que hubo al menos una venta.
    )
    AND NOT EXISTS(
        SELECT 1 FROM venta v
        JOIN paqTur p ON v.codP = p.codP
        WHERE p.paisDestino <> 'Brasil' AND v.codS = s.codS
    );

    -- Alternativa con NOT IN:
    SELECT s.codS FROM suc s
    JOIN venta v ON s.codS = v.codS
    WHERE s.codS NOT IN(
        SELECT v.codS FROM venta v
        JOIN paqTur p ON v.codP = p.codP
        WHERE p.paisDestino <> 'Brasil'
    );

    -- Alternativa con MAX:
    SELECT s.codS FROM suc s
    JOIN venta v ON s.codS = v.codS
    JOIN paqTur p ON v.codP = p.codP
    GROUP BY s.codS
    HAVING COUNT(DISTINCT p.paisDestino) = 1 AND MAX(p.paisDestino) = 'Brasil';

-- 5. Obtener los clientes registrados (todos sus datos) que no compraron ningún paquete. En SQL, resolverlo de dos maneras diferentes.   

SELECT c.* FROM cliente c

EXCEPT

SELECT c.* FROM cliente c
JOIN venta v ON c.nroDoc = v.nroDoc;

SELECT c.* FROM cliente c
WHERE NOT EXISTS(
    SELECT 1 FROM venta v
    WHERE v.nroDoc = c.nroDoc
);

    -- Alternativa con LEFT JOIN:
    SELECT c.* FROM cliente c
    LEFT JOIN venta v ON c.nroDoc = v.nroDoc
    WHERE v.nroDoc IS NULL;
