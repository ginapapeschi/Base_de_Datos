/*
Las siguientes relaciones corresponden a la base de datos de una agencia de viajes que vende paquetes turísticos y posee varias sucursales.

cliente = {nroDoc, nombre, direc, tel, email} 
suc = {codS, direcc, whatsapp, localidad} 
paqTur = {codP, precio, descrip, paisDestino, fSalida, cantDias}
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

/* Práctica con GPT */

-- 1. Mostrar el código y descripción de los paquetes que fueron vendidos tanto en efectivo como con tarjeta de crédito.

SELECT p.codP, p.descrip FROM paqTur p
JOIN venta v ON p.codP = v.codP
WHERE v.formaPago = 'Efectivo'

INTERSECT

SELECT p.codP, p.descrip FROM paqTur p
JOIN venta v ON p.codP = v.codP
WHERE v.formaPago = 'Tarjeta de crédito';

    -- Alternativa:
    SELECT p.codP, p.descrip FROM paqTur p
    WHERE p.codP IN(
        SELECT v.codP FROM venta v
        WHERE v.formaPago = 'Efectivo'
    )
    AND p.codP IN(
        SELECT v.codP FROM venta v
        WHERE v.formaPago = 'Tarjeta de crédito'
    );

    -- Alternativa:
    SELECT p.codP, p.descrip FROM paqTur p
    JOIN venta v ON p.codP = v.codP
    WHERE v.formaPago IN ('Tarjeta de crédito', 'Efectivo')
    GROUP BY p.codP, p.descrip
    HAVING COUNT(DISTINCT v.formaPago) = 2;

-- 2. Mostrar los clientes (nombre) que compraron paquetes con destino a Brasil y también paquetes con destino a España.

SELECT c.nombre FROM cliente c
JOIN venta v ON v.nroDoc = c.nroDoc
JOIN paqTur p ON v.codP = p.codP
WHERE p.paisDestino = 'Brasil'

INTERSECT

SELECT c.nombre FROM cliente c
JOIN venta v ON v.nroDoc = c.nroDoc
JOIN paqTur p ON v.codP = p.codP
WHERE p.paisDestino = 'España';

    -- Alternativa:
    SELECT c.nombre FROM cliente c
    WHERE c.nroDoc IN(
        SELECT v.nroDoc FROM venta v
        JOIN paqTur p ON v.codP = p.codP
        WHERE p.paisDestino = 'Brasil'
    )
    AND c.nroDoc IN(
        SELECT v.nroDoc FROM venta v
        JOIN paqTur p ON v.codP = p.codP
        WHERE p.paisDestino = 'España'
    );

    -- Alternativa:
    SELECT c.nombre FROM cliente c
    JOIN venta v ON c.nroDoc = v.nroDoc
    JOIN paqTur p ON v.codP = p.codP
    WHERE p.paisDestino IN ('Brasil', 'España')
    GROUP BY c.nroDoc, c.nombre
    HAVING COUNT(DISTINCT p.paisDestino) = 2;

-- 3. Mostrar los nombres de clientes que compraron paquetes con destino a Chile o realizaron compras en sucursales de Capital (sin repetir clientes).

SELECT c.nombre FROM cliente c
JOIN venta v ON c.nroDoc = v.nroDoc
JOIN paqTur p ON v.codP = p.codP
WHERE p.paisDestino = 'Chile'

UNION

SELECT c.nombre FROM cliente c
JOIN venta v ON c.nroDoc = v.nroDoc
JOIN suc s ON v.codS = s.codS
WHERE s.localidad = 'Capital';

    -- Alternativa:
    SELECT c.nombre FROM cliente c
    WHERE c.nroDoc IN(
        SELECT v.nroDoc FROM venta v
        JOIN paqTur p ON v.codP = p.codP
        WHERE p.paisDestino = 'Chile'
    )
    OR c.nroDoc IN(
        SELECT v.nroDoc FROM venta v
        JOIN suc s ON v.codS = s.codS
        WHERE s.localidad 'Capital'
    );
    
    -- Alternativa:
    SELECT DISTINCT c.nombre FROM cliente c
    JOIN venta v ON c.nroDoc = v.nroDoc
    JOIN paqTur p ON v.codP = p.codP
    JOIN suc s ON v.codS = s.codS
    WHERE p.paisDestino = 'Chile' OR s.localidad 'Capital';

-- 4. Mostrar los códigos de sucursal que vendieron paquetes a Brasil o aceptaron pagos en efectivo.

SELECT DISTINCT v.codS FROM venta v
JOIN paqTur p ON v.codP = p.codP
WHERE p.paisDestino = 'Brasil' OR v.formaPago = 'Efectivo';

    -- Alternativa:
    SELECT v.codS FROM venta v
    JOIN paqTur p ON v.codP = p.cod
    WHERE p.paisDestino = 'Brasil'
    
    UNION

    SELECT v.codS FROM venta v
    WHERE v.formaPago = 'Efectivo';

-- 5. Obtener los clientes que compraron algo pero nunca pagaron con tarjeta de crédito.

SELECT c.* FROM cliente c
JOIN venta v ON c.nroDoc = v.nroDoc

EXCEPT

SELECT c.* FROM cliente c
JOIN venta v ON c.nroDoc = v.nroDoc
WHERE v.formaPago = 'Tarjeta de crédito';

    -- Alternativa:
    SELECT c.* FROM cliente c
    WHERE EXISTS(
        SELECT 1 FROM venta v
        WHERE v.nroDoc = c.nroDoc
    )
    AND NOT EXISTS(
        SELECT 1 FROM venta v
        WHERE v.nroDoc = c.nroDoc AND v.formaPago = 'Tarjeta de crédito'
    );

    -- Alternativa:
    SELECT DISTINCT c.* FROM cliente c
    JOIN venta v ON c.nroDoc = v.nroDoc
    WHERE c.nroDoc NOT IN(
        SELECT v.nroDoc FROM venta v
        WHERE v.formaPago = 'Tarjeta de crédito'
    );

-- 6. Mostrar los paquetes que nunca fueron vendidos.

SELECT p.* FROM paqTur p
WHERE NOT EXISTS(
    SELECT 1 FROM venta v
    WHERE v.codP = p.codP
);

    -- Alternativas:
    SELECT p.* FROM paqTur p

    EXCEPT

    SELECT p.* FROM paqTur p
    JOIN venta v ON p.codP = v.codP;

    -- Alternativa:
    SELECT p.* FROM paqTur p
    WHERE p.codP NOT IN(
        SELECT v.codP FROM venta v
    );

    -- Alternativa:
    SELECT p.* FROM paqTur
    LEFT JOIN venta v ON p.codP = v.codP
    WHERE v.codP IS NULL;

-- 7. Obtener la sucursal que realizó la mayor cantidad de ventas.

SELECT s.codS FROM suc s
JOIN venta v ON s.codS = v.codS
GROUP BY s.codS
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*) FROM venta v
    GROUP BY v.codS
);

    -- Alternativa:
    SELECT s.codS FROM suc s
    JOIN venta v ON s.codS = v.codS
    GROUP BY s.codS
    HAVING COUNT(*) = (
        SELECT MAX(cant) FROM (
            SELECT COUNT(*) AS cant FROM venta v
            GROUP BY codS
        ) t
    );

-- 8. Mostrar el paquete turístico más barato (código, descripción y precio).

SELECT p.codP, p.descrip, p.precio FROM paqTur p
WHERE p.precio = (
    SELECT MIN(precio) from paqTur
);

    -- Alternativa:
    SELECT p.codP, p.descrip, p.precio FROM paqTur p
    WHERE p.precio <= ALL(
        SELECT p2.precio FROM paqTur p2
    );

    -- Alternativa:
    SELECT p.codP. p.descrip, p.precio FROM paqTur p
    WHERE NOT EXISTS(
        SELECT 1 FROM paqTur p2
        WHERE p2.precio < p.precio
    );

-- 9. Mostrar el código de sucursal y la cantidad de ventas de la(s) sucursal(es) que realizó(aron) la menor cantidad de ventas.

SELECT s.codS, COUNT(*) AS cant_vendida FROM suc s
JOIN venta v ON s.codS = v.codS
GROUP BY s.codS
HAVING COUNT(*) <= ALL(
    SELECT COUNT(*) FROM venta v
    GROUP BY v.codS
);

-- 10. Mostrar el país destino que tiene más paquetes turísticos registrados.

SELECT p.paisDestino FROM paqTur p
GROUP BY p.paisDestino
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*) FROM paqTur p
    GROUP BY p.paisDestino
);

-- 11. Para cada sucursal, mostrar el paquete más barato que vendió.

SELECT s.codS, p.* FROM suc s
JOIN venta v ON s.codS = v.codS
JOIN paqTur p ON v.codP = p.codP
WHERE NOT EXISTS(
    SELECT 1 FROM venta v2
    JOIN paqTur p2 ON v2.codP = p2.codP
    WHERE v2.codS = s.codS AND p2.precio < p.precio
);

    -- Alternativa:
    SELECT s.codS, p.* FROM suc s
    JOIN venta v ON s.codS = v.codS
    JOIN paqTur p ON v.codP = p.codP
    WHERE p.precio = (
        SELECT MIN(p2.precio) FROM paqTur p2
        JOIN venta v2 ON p2.codP = v2.codP
        WHERE v2.codS = v.codS 
    );

-- 12. Obtener los paquetes menos vendidos por sucursal.

SELECT s.codS, p.* FROM paqTur p
JOIN venta v ON p.codP = v.codP
JOIN suc s ON v.codS = s.codS
GROUP BY s.codS, p.*
HAVING COUNT(*) <= ALL(
    SELECT COUNT(*) FROM paqTur p
    JOIN venta v ON p.codP = v.codP
    JOIN suc s ON v.codS = s.codS
    GROUP BY s.codS, p.*
    );

-- 13. Obtener clientes que compraron todos los paquetes que salen en enero.

SELECT c.* FROM cliente c
WHERE NOT EXISTS(
    SELECT 1 FROM paqTur p
    WHERE p.fSalida = 'Enero'
    AND NOT EXISTS(
        SELECT 1 FROM venta v
        WHERE v.nroDoc = c.nroDoc AND v.codP = p.codP
    )        
);

    -- Alternativa:
    SELECT c.* FROM cliente c
    WHERE NOT EXISTS(
        (SELECT codP FROM paqTur
        WHERE fSalida = 'Enero')

        EXCEPT

        (SELECT codP FROM venta v
        WHERE v.nroDoc = c.nroDoc)
);

-- 14. Mostrar sucursales que vendieron paquetes a todos los países existentes.

SELECT s.* FROM suc s
WHERE NOT EXISTS(
    SELECT DISTINCT p.paisDestino FROM paqTur p
    WHERE NOT EXISTS(
        SELECT 1 FROM venta v
        JOIN paqTur p2 On v.codP = p2.codP
        WHERE v.codS = s.codS AND p2.paisDestino = p.paisDestino
    )
);

    -- Alternativa:
    SELECT s.* FROM suc s
    WHERE NOT EXISTS(
        (SELECT DISTINCT paisDestino
         FROM paqTur)

        EXCEPT

        (SELECT DISTINCT p.paisDestino
         FROM venta v
         JOIN paqTur p ON v.codP=p.codP
         WHERE v.codS=s.codS)
    );

/*

=== CLAVES DE PARCIAL ===

Interpretación del enunciado:

* “tanto… como…”
  → INTERSECT
  → IN + IN
  → GROUP BY + HAVING COUNT(DISTINCT ...)

* “o”
  → UNION
  → OR (si es condición sobre filas)

* “solo / únicamente”
  → EXCEPT
  → NOT EXISTS
  → GROUP BY + HAVING

* “todos”
  → doble NOT EXISTS
  → EXCEPT vacío

* “máximo / mínimo”
  → atributo → MAX / MIN / NOT EXISTS
  → cantidad → GROUP BY + COUNT + HAVING >= ALL / <= ALL

* “nunca / ninguno / no realizó”
  → NOT EXISTS
  → EXCEPT
  → EXISTS + NOT EXISTS
  → NOT IN (con cuidado)

Preguntas guía:

1. ¿Qué estoy mostrando?
   → SELECT

2. ¿Qué tablas necesito relacionar?
   → JOIN

3. ¿Qué estoy agrupando?
   → GROUP BY

4. ¿Qué estoy comparando?
   * cantidad → COUNT
   * atributo → MIN / MAX

5. ¿Es global o por grupo?
   → ¿falta correlación?

6. ¿Dice TODOS?
   → NOT EXISTS(
   conjunto
   AND NOT EXISTS(...)
   )

*/
