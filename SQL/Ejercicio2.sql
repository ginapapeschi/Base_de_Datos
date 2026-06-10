/*
1. Cree la base de datos comercioMinorista en base al modelo conceptual realizado en la Práctica N°1 - Segunda Parte - Caso 1.

Un comercio dedicado a la venta de productos de almacén necesita gestionar y mantener los datos de los productos que comercializa, así como de las facturas de venta que genera. A continuación, se detallan los datos específicos a considerar:

- Productos: Código (único), nombre, rubro, precio actual y condición de almacenamiento.
- Facturas: Numero de factura (único), fecha, productos incluidos (especificando el precio al que se vendió y la cantidad de unidades vendidas), importe total y CUIL del cliente.

Restricciones: 
- Los clientes son argentinos.
- La condición de almacenamiento refiere a si necesita ser refrigerado, congelado, mantenido en un ambiente seco, etc.
- La condición de almacenamiento es la misma para todos los productos pertenecientes a un mismo rubro.

2. Cree las tablas correspondientes e inserte tuplas para luego realizar las consultas propuestas (considere los datos solicitados en las consultas).  

*/

CREATE SCHEMA ejercicio2;
SET search_path TO ejercicio2;

-- Se consideran las siguientes relaciones:
/*
producto = {codP, nombre, precioAct, nomR}
factura = {numF, fecha, cuilCli}
tiene = {codP, numF, precioVta, cantUni}
rubro = {nomR, condicionAlm}
*/

CREATE TABLE rubro (
    nomR VARCHAR(50) PRIMARY KEY,
	condicionAlm VARCHAR(50)
);

CREATE TABLE producto (
    codP INTEGER PRIMARY KEY,
    nombre VARCHAR(40),
	precioAct NUMERIC(10,2),
	nomR VARCHAR (50),
    FOREIGN KEY (nomR)
	REFERENCES rubro(nomR)
);

CREATE TABLE factura (
    numF INTEGER PRIMARY KEY,
	fecha DATE,
	cuil VARCHAR(20)
    -- El importe total no se almacena porque es derivado (calculado).
);

CREATE TABLE tiene (
    codP INTEGER,
    numF INTEGER,
	precioVta NUMERIC(10,2),
    cantUni INTEGER,
    PRIMARY KEY (codP, numF),
	FOREIGN KEY (codP) REFERENCES producto(codP),
    FOREIGN KEY (numF) REFERENCES factura(numF)
);

-- Insertamos rubros
-- Se especifican las columnas en las que se van a insertar valores
INSERT INTO rubro (nomR, condicionAlm) VALUES
('Lácteos', 'Heladera 4°C a 8°C'),
('Bebidas', 'Lugar fresco y oscuro'),
('Secos', 'Lugar seco y ventilado'),
('Limpieza', 'Lejos de alimentos');

-- Insertamos productos
INSERT INTO producto (codP, nombre, precioAct, nomR) VALUES
(1, 'Yogurt La Serenisima', 2800.00, 'Lácteos'), -- Para actualizar en consulta 9
(2, 'Gaseosa Cola 2L', 1800.00, 'Bebidas'),      -- Sin ventas, para eliminar en consulta 10
(3, 'Leche Entera 1L', 1200.00, 'Lácteos'),
(4, 'Agua Mineral 1.5L', 800.00, 'Bebidas'),
(5, 'Cerveza Rubia 1L', 2500.00, 'Bebidas'),
(6, 'Fideos Espagueti', 1100.00, 'Secos'),
(7, 'Detergente Lavavajillas', 1900.00, 'Limpieza');

-- Insertamos facturas
INSERT INTO factura (numF, fecha, cuil) VALUES
(1001, '2023-05-12', '20-12345678-9'), -- Mayo 2023
(1002, '2023-05-25', '27-98765432-1'), -- Mayo 2023
(1003, '2023-08-10', '20-11112222-3'), -- 2023, pero no mayo
(1004, '2023-11-05', '23-55556666-9'), -- 2023, pero no mayo
(1005, '2024-01-15', '20-12345678-9'); -- 2024 (Fuera de los filtros temporales)

-- Insertamos tuplas a la relación "tiene"
INSERT INTO tiene (codP, numF, precioVta, cantUni) VALUES
-- Factura 1001 (Mayo 2023: Mixta - Lácteos, Secos y Limpieza)
(1, 1001, 2500.00, 5),   -- Yogurt (Lácteos)
(3, 1001, 1100.00, 10),  -- Leche (Lácteos)
(6, 1001, 1000.00, 4),   -- Fideos (Secos)
(7, 1001, 1850.00, 1),   -- Detergente (Limpieza)

-- Factura 1002 (Mayo 2023: SOLO Bebidas para la Consulta 7)
(4, 1002, 750.00, 3),    -- Agua (Bebidas)
(5, 1002, 2400.00, 6),   -- Cerveza (Bebidas)

-- Factura 1003 (Agosto 2023: Mixta)
(1, 1003, 2600.00, 2),   -- Yogurt (Lácteos)
(4, 1003, 800.00, 5),    -- Agua (Bebidas)

-- Factura 1004 (Noviembre 2023: SOLO Bebidas para la Consulta 7)
(4, 1004, 800.00, 15),   -- Agua (Bebidas) -> Con esto el Agua será el más vendido

-- Factura 1005 (Enero 2024: No debe salir en las de 2023)
(3, 1005, 1200.00, 6),   -- Leche (Lácteos)
(6, 1005, 1100.00, 2);   -- Fideos (Secos)


-- CONSULTAS
-- 3. Nombre de los productos vendidos en mayo de 2023.

SELECT DISTINCT p.nombre FROM producto p -- El DISTINCT es para que no figuren repetidos.
JOIN tiene t ON p.codP = t.codP
JOIN factura f ON t.numF = f.numF
WHERE f.fecha BETWEEN '2023-05-01' AND '2023-05-31';

-- 4.  Facturas (número y fecha) que incluyeron productos del rubro “Lácteos”.

SELECT DISTINCT f.numF, f.fecha FROM factura f
JOIN tiene t ON f.numF = t.numF
JOIN producto p ON t.codP = p.codP
WHERE p.nomR = 'Lácteos';

-- 5.  Productos junto con la cantidad total vendida en 2023.

SELECT p.codP, p.nombre, p.precioAct, p.nomR, SUM(t.cantUni) AS total_vendido
FROM producto p

JOIN tiene t ON p.codP = t.codP
JOIN factura f ON t.numF = f.numF
WHERE f.fecha BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY p.codP, p.nombre, p.precioAct, p.nomR;

    -- Al usar SUM junto con GROUP BY no suele ser necesario utilizar DISTINCT.
    -- Se agrupa según todas las columnas que se vayan a mostrar en el SELECT.

-- 6. Nombre del producto más vendido (en cantidad total).

SELECT p.nombre FROM producto p
JOIN tiene t ON p.codP = t.codP
GROUP BY p.codP, p.nombre       
    -- Conviene agrupar por CLAVE PRIMARIA para identificar unívocamente cada producto.
ORDER BY SUM(t.cantUni) DESC
LIMIT 1;
    -- Toda columna que aparezca en el SELECT y no esté dentro de una función de agregación debe estar en el GROUP BY.
    -- ORDER BY ordena de forma descendiente (DESC - Mayor a menor) la SUMA de la cantidad total de unidades vendidas (ventas realizadas).
    -- LIMIT 1 Devuelve solamente el primer resultado (el producto más vendido).

-- Para ver también la cantidad de ventas realizadas:
SELECT p.nombre, SUM(t.cantUni) as total_vendido FROM producto p
JOIN tiene t ON p.codP = t.codP
GROUP BY p.codp, p.nombre
ORDER BY total_vendido DESC
LIMIT 1;

-- 7. Facturas que hayan incluido solamente productos del rubro “Bebidas”.

SELECT f.numF, f.fecha, f.cuil FROM factura f
JOIN tiene t ON f.numF = t.numF
JOIN producto p ON t.codP = p.codP
GROUP BY f.numF, f.fecha, f.cuil
HAVING COUNT(DISTINCT p.nomR) = 1 AND MAX(p.nomR) = 'Bebidas';
    -- HAVING filtra grupos YA ARMADOS, mientras que WHERE trabaja con FILAS INDIVIDUALES.
    -- COUNT(DISTINCT p.nomR) = 1 verifica que de todas las facturas se quede sólo con aquellas que tienen UN RUBRO DISTINTO (es decir, el mismo rubro, incluso si se repite en la misma factura).
    -- AND MAX(p.nomR) = 'Bebidas'; verifica que de la lista de productos de un mismo rubro, sean del tipo 'Bebidas' y no otro.
    -- Por ejemplo, el COUNT puede dar bien para una factura con 'Lácteos', 'Lácteos', 'Lácteos' (cumple que no hay más de un rubro distinto), pero no cumple con el filtro de MAX ('Lácteos' != 'Bebidas').

-- WHERE -> filtra filas.
-- GROUP BY -> arma grupos.
-- HAVING -> filtra grupos.

-- ACTUALIZACIÓN DE DATOS

-- 8. Insertar un nuevo producto: “Arroz Fino”, rubro “Secos”, precio 1580.50.

INSERT INTO producto (codP, nombre, nomR, precioAct) VALUES(
    8, 'Arroz Fino', 'Secos', 1580.50
);

SELECT * FROM producto WHERE codp = 8;

-- 9. Actualizar el precio actual del producto “Yogurt La Serenisima” a 3550.

UPDATE producto
SET precioAct = 3550
WHERE nombre = 'Yogurt La Serenisima';

SELECT * FROM producto WHERE nombre = 'Yogurt La Serenisima';

-- 10. Eliminar el producto “Gaseosa Cola 2L”.

DELETE FROM producto WHERE nombre = 'Gaseosa Cola 2L';
    -- No produce problemas porque la gaseosa no tiene ninguna referencia en la tabla TIENE, caso contrario hubiera dado problemas de integridad referencial.
SELECT * FROM producto WHERE nombre = 'Gaseosa Cola 2L';


