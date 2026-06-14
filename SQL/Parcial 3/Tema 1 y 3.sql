/*
Las siguientes relaciones corresponden a la bd de una agencia de viajes que vende paquetes turísticos y posee varias sucursales.

cliente = {cuil, nombre, direc, tel, email}
suc = {codS, direcc, whatsapp, localidad}
paqTur = {codP, precio, descrip, paisDestino, fSalida, cantDias}
venta = {codP, codS, cuil, fVta, formaPago (tarj.crédito, tarj.débito, efectivo…)}
*/

-- 1. Obtener el nombre y teléfono de los clientes que compraron TODOS los paquetes turísticos con destino a Italia. Pueden existir varios paquetes al mismo destino.

SELECT c.nombre, c.tel FROM cliente c
WHERE NOT EXISTS(
    SELECT 1 FROM paqTur p
    WHERE p.paisDestino = 'Italia'
    AND NOT EXISTS(
        SELECT 1 FROM venta v
        WHERE c.cuil = v.cuil AND v.codP = p.codP
    )
);

-- 2. Mostrar los paquetes (código y descripción) que se vendieron tanto en sucursales de Rivadavia como de Rawson.

SELECT p.codP, p.descrip FROM paqTur p
JOIN venta v ON p.codP = v.codP
JOIN suc s ON v.codS = s.codS
WHERE s.localidad = 'Rivadavia'

INTERSECT

SELECT p.codP, p.descrip FROM paqTur p
JOIN venta v ON p.codP = v.codP
JOIN suc s ON v.codS = s.codS
WHERE s.localidad = 'Rawson';

    -- Alternativa:
    SELECT p.codP, p.descrip FROM paqTur p
    JOIN venta v ON p.codP = v.codP
    JOIN suc s ON v.codS = s.codS
    WHERE s.localidad IN ('Rivadavia', 'Rawson')
    GROUP BY p.codP, p.descrip
    HAVING COUNT(DISTINCT s.localidad) = 2;

-- 3. Obtener los paquetes (todos sus datos) que no fueron vendidos por ninguna sucursal. En SQL, resolverlo de dos maneras diferentes.

SELECT p.* FROM paqTur p

EXCEPT

    SELECT p.* FROM paqTur p
    JOIN venta v ON p.codP = v.codP;

SELECT p.* FROM paqTur p
WHERE NOT EXISTS (
    SELECT 1 FROM venta v
    WHERE v.codP = p.codP
);

    -- Alternativa:
    SELECT p.* FROM paqTur p
    WHERE p.codP NOT IN (
        SELECT v.codP FROM venta v
    );

-- 4. Mostrar para cada sucursal de Rawson, el código de sucursal junto a la cantidad de paquetes turísticos vendidos con tarjeta de crédito.

SELECT s.codS, COUNT(*) AS cant_vendida FROM suc s
JOIN venta v ON s.codS = v.codS
WHERE s.localidad = 'Rawson' AND v.formaPago = 'Tarjeta de crédito'
GROUP BY s.codS;

    -- Alternativa para mostrar las sucursales con 0 ventas:
    SELECT s.codS, COUNT(*) AS cant_vendida FROM suc s
    LEFT JOIN venta v ON s.codS = v.codS AND v.formaPago = 'Tarjeta de crédito'
    WHERE s.localidad = 'Rawson'
    GROUP BY s.codS;
        -- LEFT JOIN trae las filas de la tabla de la izquierda aunque NO TENGAN COINCIDENCIA en la derecha.
        -- Si se quiere conservar NULOS, la condición va en ON y no en WHERE.
        -- Los filtros de la tabla OPCIONAL (la derecha, es decir, venta) suelen ir en ON.
        -- Los filtros de la tabla que se quiere CONSERVAR (la izquierda, es decir, suc) suelen ir en WHERE.

-- 5. Sucursales (código) que vendieron sólo paquetes turísticos a República Dominicana.

SELECT s.codS FROM suc s
WHERE NOT EXISTS(
    SELECT 1 FROM venta v
    JOIN paqTur p ON v.codP = p.codP
    WHERE v.codS = s.codS AND p.paisDestino <> 'República Dominicana'
        -- Se muestra una sucursal para la cual no existe una venta en un país destino distinto a República Dominicana.
        -- El 'sólo' expresa que se traiga una sucursal tal que NO exista una venta de esa sucursal cuyo paquete tenga destino DISTINTO a República Dominicana.
);

    -- Alternativa con NOT IN:
    SELECT s.codS FROM suc s
    WHERE s.codS NOT IN(
        SELECT v.codS FROM venta v
        JOIN paqTur p ON v.codP = p.codP
        WHERE p.paisDestino <> 'República Dominicana'
    );
        -- El 'sólo' expresa que se traiga una sucursal cuyo código NO ESTÉ entre los códigos de sucursales que hicieron ventas en destinos DISTINTOS a República Dominicana.
        
/*
¿La negación es sobre UN VALOR?
    → <>, NOT LIKE, NOT BETWEEN

¿La negación es sobre LA EXISTENCIA de filas relacionadas?
    → NOT EXISTS
*/

-- EJERCICIOS ADICIONALES --

-- Obtener el nombre de los clientes que compraron paquetes turísticos EN TODAS las sucursales ubicadas en Rawson.

SELECT c.nombre FROM cliente c
WHERE NOT EXISTS(
    SELECT 1 FROM suc s
    WHERE s.localidad = 'Rawson'
    AND NOT EXISTS(
        SELECT 1 FROM venta v
        WHERE v.cuil = c.cuil AND v.codS = s.codS
    )
);

-- Obtener el nombre de los clientes que compraron TODOS los paquetes turísticos que fueron vendidos en sucursales de Rivadavia.

SELECT c.nombre FROM cliente c
WHERE NOT EXISTS(
    SELECT 1 FROM venta v
    JOIN suc s ON v.codS = s.codS
    WHERE s.localidad = 'Rivadavia'
    AND NOT EXISTS(
        SELECT 1 FROM venta v2
        WHERE v2.cuil = c.cuil AND v2.codP = v.codP
    )
);

-- Obtener el nombre de los clientes que compraron paquetes turísticos en TODAS las sucursales que realizaron al menos una venta con tarjeta de crédito.

SELECT c.nombre FROM cliente c
WHERE NOT EXISTS(
    SELECT 1 FROM suc s
    JOIN venta v ON s.codS = v.codS
    WHERE v.formaPago = 'Tajeta de Crédito'
    AND NOT EXISTS(
        SELECT 1 FROM venta v2
        WHERE v2.cuil = c.cuil AND v2.codS = s.codS
    )
);
    -- Se consulta por TODAS las sucursales, por lo que debe ser el primer NOT EXISTS. "que realizaron al menos una venta" implica que debe haber un JOIN con venta.
    -- Se consulta, además, por los clientes que COMPRARON un paquete turístico (por lo que debe haber una venta registrada), por eso se selecciona de otra venta en la que se la relaciona con el cliente y esa misma sucursal que cumple que tuvo al menos una venta con tarjeta de crédito.

-- Obtener el nombre de los clientes que compraron TODOS los paquetes turísticos con destino a países para los cuales hubo al menos una venta en sucursales de Rawson.

SELECT c.nombre FROM cliente c
WHERE NOT EXISTS (
    SELECT 1 FROM paqTur p
    WHERE p.paisDestino IN(
        SELECT DISTINCT p2.paisDestino FROM paqTur p2
        JOIN venta v ON p2.codP = v.codP
        JOIN suc s ON s.codS = v.codS
        WHERE s.localidad = 'Rawson'
    )
    AND NOT EXISTS(
        SELECT 1 from venta v2
        WHERE v2.cuil = c.cuil AND v2.codP = p.codP
    )
);