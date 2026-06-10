-- Script PostgreSQL para la empresa de comida rápida

-- Creación de esquemas
CREATE SCHEMA IF NOT EXISTS productos;
CREATE SCHEMA IF NOT EXISTS operaciones;
CREATE SCHEMA IF NOT EXISTS backupProductos;

-- Creación de tablas del esquema productos
CREATE TABLE productos.sucursal (
    num INTEGER PRIMARY KEY,
    direcc VARCHAR(100) NOT NULL,
    tel VARCHAR(20) NOT NULL,
    provincia VARCHAR(50) NOT NULL
);

CREATE TABLE productos.producto (
    cod INTEGER,
    num INTEGER REFERENCES productos.sucursal(num) ON DELETE CASCADE,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    PRIMARY KEY (cod, num)
);

CREATE TABLE productos.ingrediente (
    cod INTEGER,
    num INTEGER,
    nombre VARCHAR(100) NOT NULL,
    kcal INTEGER NOT NULL CHECK (kcal >= 0),
    PRIMARY KEY (cod, num, nombre),
    FOREIGN KEY (cod, num) REFERENCES productos.producto(cod, num) ON DELETE CASCADE
);

-- Creación de tablas del esquema operaciones
CREATE TABLE operaciones.factura (
    num INTEGER PRIMARY KEY,
    fecha DATE NOT NULL,
    calif INTEGER CHECK (calif BETWEEN 1 AND 5)
);

CREATE TABLE operaciones.detalle (
    numf INTEGER REFERENCES operaciones.factura(num) ON DELETE CASCADE,
    cod INTEGER,
    num INTEGER,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (numf, cod, num),
    FOREIGN KEY (cod, num) REFERENCES productos.producto(cod, num)
);

-- Inserción de datos en la tabla sucursal
INSERT INTO productos.sucursal VALUES 
(1, 'Av. Libertador 123', '2644111111', 'San Juan'),
(2, 'Av. Las Heras 456', '2644222222', 'San Juan'),
(3, 'Av. San Martín 789', '2615555555', 'Mendoza'),
(4, 'Av. Mitre 101', '2615666666', 'Mendoza'),
(5, 'Av. Illia 202', '2664777777', 'San Luis'),
(6, 'Av. Rivadavia 303', '2664888888', 'San Luis'),
(7, 'Av. Córdoba 404', '1144444444', 'Buenos Aires'),
(8, 'Av. Santa Fe 505', '1144555555', 'Buenos Aires'),
(9, 'Av. 9 de Julio 606', '3514444444', 'Córdoba'),
(10, 'Av. Colón 707', '3514555555', 'Córdoba');

-- Inserción de datos en la tabla producto
INSERT INTO productos.producto VALUES
(101, 1, 'Pizza muzzarella', 1200.00, 50),
(102, 1, 'Pizza napolitana', 1400.00, 45),
(103, 1, 'Pizza napolitana especial', 1600.00, 30),
(104, 1, 'Pizza con jamón', 1350.00, 40),
(105, 1, 'Hamburguesa simple', 800.00, 60),
(106, 1, 'Hamburguesa completa', 1000.00, 55),

(101, 2, 'Pizza muzzarella', 1250.00, 45),
(102, 2, 'Pizza napolitana', 1450.00, 40),
(103, 2, 'Pizza napolitana especial', 1650.00, 35),
(105, 2, 'Hamburguesa simple', 850.00, 65),
(106, 2, 'Hamburguesa completa', 1050.00, 50),

(101, 3, 'Pizza muzzarella', 1300.00, 40),
(102, 3, 'Pizza napolitana', 1500.00, 35),
(104, 3, 'Pizza con jamón', 1400.00, 30),
(105, 3, 'Hamburguesa simple', 900.00, 55),
(107, 3, 'Papas fritas', 600.00, 80),

(101, 4, 'Pizza muzzarella', 1350.00, 35),
(103, 4, 'Pizza napolitana especial', 1700.00, 25),
(104, 4, 'Pizza con jamón', 1450.00, 30),
(106, 4, 'Hamburguesa completa', 1100.00, 45),
(107, 4, 'Papas fritas', 650.00, 75),

(102, 5, 'Pizza napolitana', 1550.00, 30),
(103, 5, 'Pizza napolitana especial', 1750.00, 25),
(105, 5, 'Hamburguesa simple', 950.00, 50),
(106, 5, 'Hamburguesa completa', 1150.00, 40),
(107, 5, 'Papas fritas', 700.00, 70),

(101, 6, 'Pizza muzzarella', 1400.00, 35),
(102, 6, 'Pizza napolitana', 1600.00, 30),
(103, 6, 'Pizza napolitana especial', 1800.00, 20),
(105, 6, 'Hamburguesa simple', 1000.00, 45),
(108, 6, 'Ensalada', 800.00, 30),

(101, 7, 'Pizza muzzarella', 1450.00, 40),
(104, 7, 'Pizza con jamón', 1550.00, 35),
(105, 7, 'Hamburguesa simple', 1050.00, 55),
(106, 7, 'Hamburguesa completa', 1250.00, 50),
(108, 7, 'Ensalada', 850.00, 35),

(102, 8, 'Pizza napolitana', 1650.00, 35),
(103, 8, 'Pizza napolitana especial', 1850.00, 30),
(104, 8, 'Pizza con jamón', 1600.00, 40),
(107, 8, 'Papas fritas', 750.00, 80),
(108, 8, 'Ensalada', 900.00, 40),

(101, 9, 'Pizza muzzarella', 1500.00, 45),
(102, 9, 'Pizza napolitana', 1700.00, 40),
(103, 9, 'Pizza napolitana especial', 1900.00, 35),
(106, 9, 'Hamburguesa completa', 1300.00, 55),
(108, 9, 'Ensalada', 950.00, 45),

(101, 10, 'Pizza muzzarella', 1550.00, 50),
(102, 10, 'Pizza napolitana', 1750.00, 45),
(104, 10, 'Pizza con jamón', 1650.00, 40),
(107, 10, 'Papas fritas', 800.00, 85),
(108, 10, 'Ensalada', 1000.00, 50);

-- Inserción de datos en la tabla ingrediente
INSERT INTO productos.ingrediente VALUES
(101, 1, 'Masa', 200),
(101, 1, 'Queso muzzarella', 250),
(101, 1, 'Salsa de tomate', 50),

(102, 1, 'Masa', 200),
(102, 1, 'Queso muzzarella', 250),
(102, 1, 'Salsa de tomate', 50),
(102, 1, 'Tomate', 30),
(102, 1, 'Ajo', 5),

(103, 1, 'Masa', 200),
(103, 1, 'Queso muzzarella', 300),
(103, 1, 'Salsa de tomate', 50),
(103, 1, 'Tomate', 40),
(103, 1, 'Ajo', 10),
(103, 1, 'Aceitunas', 15),

(104, 1, 'Masa', 200),
(104, 1, 'Queso muzzarella', 250),
(104, 1, 'Salsa de tomate', 50),
(104, 1, 'Jamón', 100),

(105, 1, 'Pan', 150),
(105, 1, 'Carne', 200),
(105, 1, 'Lechuga', 10),
(105, 1, 'Tomate', 15),

(106, 1, 'Pan', 150),
(106, 1, 'Carne', 200),
(106, 1, 'Lechuga', 10),
(106, 1, 'Tomate', 15),
(106, 1, 'Queso', 80),
(106, 1, 'Huevo', 70),
(106, 1, 'Jamón', 50);

-- Inserción de datos en la tabla factura
INSERT INTO operaciones.factura VALUES
(1001, '2020-01-15', 4),
(1002, '2020-02-20', 5),
(1003, '2020-03-10', 3),
(1004, '2020-04-05', 4),
(1005, '2020-05-12', 5),
(1006, '2020-06-18', 4),
(1007, '2020-07-22', 3),
(1008, '2020-08-30', 5),
(1009, '2020-09-14', 4),
(1010, '2020-10-25', 4),
(1011, '2020-11-07', 5),
(1012, '2020-12-19', 3),
(1013, '2021-01-05', 4),
(1014, '2021-02-14', 5),
(1015, '2021-03-20', 3);

-- Inserción de datos en la tabla detalle
INSERT INTO operaciones.detalle VALUES
-- Facturas para San Juan (sucursales 1 y 2)
(1001, 101, 1, 1200.00, 2), -- Pizza muzzarella en sucursal 1
(1001, 102, 1, 1400.00, 1), -- Pizza napolitana en sucursal 1
(1002, 103, 1, 1600.00, 3), -- Pizza napolitana especial en sucursal 1
(1002, 105, 1, 800.00, 2),  -- Hamburguesa simple en sucursal 1
(1003, 101, 2, 1250.00, 1), -- Pizza muzzarella en sucursal 2
(1003, 103, 2, 1650.00, 2), -- Pizza napolitana especial en sucursal 2

-- Facturas para Mendoza (sucursales 3 y 4)
(1004, 101, 3, 1300.00, 2), -- Pizza muzzarella en sucursal 3
(1004, 104, 3, 1400.00, 1), -- Pizza con jamón en sucursal 3
(1005, 101, 4, 1350.00, 3), -- Pizza muzzarella en sucursal 4
(1005, 103, 4, 1700.00, 2), -- Pizza napolitana especial en sucursal 4
(1005, 107, 4, 650.00, 4),  -- Papas fritas en sucursal 4

-- Facturas para San Luis (sucursales 5 y 6)
(1006, 102, 5, 1550.00, 2), -- Pizza napolitana en sucursal 5
(1006, 103, 5, 1750.00, 1), -- Pizza napolitana especial en sucursal 5
(1006, 105, 5, 950.00, 2),  -- Hamburguesa simple en sucursal 5
(1007, 101, 6, 1400.00, 3), -- Pizza muzzarella en sucursal 6
(1007, 102, 6, 1600.00, 2), -- Pizza napolitana en sucursal 6
(1007, 103, 6, 1800.00, 1), -- Pizza napolitana especial en sucursal 6
(1008, 105, 6, 1000.00, 4), -- Hamburguesa simple en sucursal 6
(1008, 108, 6, 800.00, 2),  -- Ensalada en sucursal 6

-- Facturas para Buenos Aires (sucursales 7 y 8)
(1009, 101, 7, 1450.00, 2), -- Pizza muzzarella en sucursal 7
(1009, 104, 7, 1550.00, 1), -- Pizza con jamón en sucursal 7
(1009, 105, 7, 1050.00, 3), -- Hamburguesa simple en sucursal 7
(1010, 102, 8, 1650.00, 2), -- Pizza napolitana en sucursal 8
(1010, 103, 8, 1850.00, 1), -- Pizza napolitana especial en sucursal 8
(1010, 104, 8, 1600.00, 2), -- Pizza con jamón en sucursal 8

-- Facturas para Córdoba (sucursales 9 y 10)
(1011, 101, 9, 1500.00, 3), -- Pizza muzzarella en sucursal 9
(1011, 102, 9, 1700.00, 2), -- Pizza napolitana en sucursal 9
(1011, 103, 9, 1900.00, 1), -- Pizza napolitana especial en sucursal 9
(1012, 101, 10, 1550.00, 2), -- Pizza muzzarella en sucursal 10
(1012, 102, 10, 1750.00, 1), -- Pizza napolitana en sucursal 10
(1012, 104, 10, 1650.00, 2), -- Pizza con jamón en sucursal 10

-- Más facturas para ampliar datos (2020)
(1013, 101, 1, 1200.00, 4), -- Pizza muzzarella en sucursal 1
(1013, 104, 1, 1350.00, 2), -- Pizza con jamón en sucursal 1
(1014, 102, 5, 1550.00, 3), -- Pizza napolitana en sucursal 5
(1014, 107, 5, 700.00, 5),  -- Papas fritas en sucursal 5
(1015, 108, 9, 950.00, 3);  -- Ensalada en sucursal 9

/*
Productos:
    - sucursal = {num, direcc, tel, provincia} 
    - producto = {cod, num (número de sucursal), nombre, precio, stock} 
    - ingrediente = {cod (código del producto), num, nombre, kcal (cantidad de calorías)} 

Operaciones: 
    - factura = {num (número de factura), fecha, calif (calificación otorgada)} 
    - detalle = {numf (número de factura), cod (código del producto), num (número de la sucursal), precio, cantidad}
*/

-- 3. Nombre de productos vendidos en San Juan.

SELECT DISTINCT p.nombre FROM productos.producto
JOIN operaciones.detalle d ON p.cod = d.cod AND p.num = d.num
    -- Relaciona cada detalle de venta con el producto vendido.
    -- Coincide el producto (código) y la misma sucursal (num).
JOIN productos.sucursal s ON p.num = s.num
    -- Coincide la sucursal donde se vende ese producto.
WHERE s.provincia = 'San Juan';

    -- Alternativa con subconsulta e IN:
    SELECT DISTINCT p.nombre FROM productos.producto p
    WHERE EXISTS (
        SELECT 1 FROM operaciones.detalle d
        WHERE d.num = p.num AND d.cod = p.cod
            -- Existe un producto vendido.
    )
    AND EXISTS (
        SELECT 1 FROM productos.sucursal s      
        WHERE s.num = p.num AND s.provincia = 'San Juan'
            -- Ese mismo producto se vende en una sucursal de San Juan.
    );

-- 4. Provincias donde se venden más de un producto.

SELECT s.provincia FROM productos.sucursal s
JOIN operaciones.detalle d ON s.num = d.num
GROUP BY s.provincia              -- Se agrupa según el dato que deseo mostrar (SELECT).
HAVING COUNT(DISTINCT d.cod) > 1; -- Se coloca aquello que QUIERO CONTAR en los paréntesis.
    -- Va el DISTINCT porque puede haber más de un a venta de un mismo producto.

-- 5. Sucursales (todos los datos) que venden tanto Pizza napolitana como Pizza napolitana especial.

SELECT s.* FROM productos.sucursal s
JOIN operaciones.detalle d ON s.num = d.num
JOIN productos.producto p ON d.cod = p.cod AND d.num = p.num
WHERE p.nombre = 'Pizza napolitana' INTERSECT (
    SELECT s.* FROM productos.sucursal s
    JOIN operaciones.detalle d ON s.num = d.num
    JOIN productos.producto p ON d.cod = p.cod AND d.num = p.num
    WHERE p.nombre = 'Pizza napolitana especial'
);

    -- Alternativa con GROUP BY e IN:
    SELECT s.* FROM productos.sucursal s
    JOIN operaciones.detalle d ON s.num = d.num
    JOIN productos.producto p ON d.cod = p.cod AND d.num = p.num
    WHERE p.nombre IN ('Pizza napolitana', 'Pizza napolitana especial')
    GROUP BY s.*
    HAVING COUNT(DISTINCT p.nombre) = 2;

-- 6. Productos (nombre y stock) comercializados en las provincias de Cuyo (San Juan, Mendoza y San Luis).

SELECT DISTINCT p.nombre, p.stock FROM productos.producto p
JOIN operaciones.detalle d ON p.cod = d.cod AND p.num = d.num
JOIN productos.sucursal s ON d.num = s.num
WHERE s.provincia IN ('Mendoza', 'San Juan', 'San Luis');

-- 7. Provincias que no venden Pizza muzzarella.

SELECT s.provincia FROM productos.sucursal s
JOIN operaciones.detalle d ON s.num = d.num
JOIN productos.producto p ON d.cod = p.cod AND d.num = p.num
EXCEPT (
    SELECT s.provincia FROM productos.sucursal s
    JOIN operaciones.detalle d ON s.num = d.num
    JOIN productos.producto p ON d.cod = p.cod AND d.num = p.num
    WHERE p.nombre = 'Pizza muzzarella'
);

    -- Alternativa con NOT EXISTS:
    SELECT DISTINCT s.provincia FROM productos.sucursal s
    WHERE NOT EXISTS(
        SELECT 1 FROM operaciones.detalle d
        JOIN productos.producto p ON d.cod = p.cod AND d.num = p.num
        WHERE d.num = s.num AND p.nombre = 'Pizza Muzarella'
    );

-- 8. Sucursales que no venden el producto Pizza con jamón.

SELECT s.num FROM productos.sucursal s
JOIN operaciones.detalle d ON s.num = d.num
JOIN productos.producto p ON d.cod = p.cod AND d.num = p.num
EXCEPT (
    SELECT s.num FROM productos.sucursal s
    JOIN operaciones.detalle d ON s.num = d.num
    JOIN productos.producto p ON d.cod = p.cod AND d.num = p.num
    WHERE p.nombre = 'Pizza con jamón'
);

    -- Alernativa con NOT EXISTS:
    SELECT s.num FROM productos.sucursal s
    WHERE NOT EXISTS (
        SELECT 1 FROM operaciones.detalle d
        JOIN productos.producto p ON d.cod = p.cod AND d.num = p.num
        WHERE p.nombre = 'Pizza con jamón' AND d.num = s.num
    );

    -- Si sólo se cuenta los productos que OFRECE la sucursal y no los que han venido (puede haber alguna sucursal sin ventas y que NO ofrezca Pizza con jamón):
    SELECT s.num FROM productos.sucursal s
    EXCEPT (
        SELECT p.num FROM productos.producto p
        -- Basta con p.num porque sólo se quiere sacar las SUCURSALES.
        WHERE p.nombre = 'Pizza con jamón'
    );

-- 9. Para cada sucursal de la provincia de San Luis, obtener el número e importe total facturado.

SELECT s.num, SUM(d.precio * d.cantidad) AS importe_total FROM productos.sucursal s
JOIN operaciones.detalle d ON s.num = d.num
WHERE s.provincia = 'San Luis'
GROUP BY s.num;
    -- Siempre que se quiera mostrar una operación que implique un agrupamiento, pero no necesariamente un filtro de ese grupo, el cálculo va en el SELECT.

    -- Alternativa con subconsulta:
    SELECT num, SUM(precio * cantidad) AS importe_total FROM operaciones.detalle
    WHERE num IN (
        SELECT num FROM productos.sucursal
        WHERE provincia = 'San Luis'
    )
    GROUP BY num;

-- 10. Provincias donde se venden más de un producto.

SELECT s.provincia FROM productos.sucursal s
JOIN operaciones.detalle d ON s.num = d.num
JOIN productos.producto p ON p.cod = d.cod AND p.num = d.num
GROUP BY s.provincia
HAVING COUNT(DISTINCT p.cod) > 1;

    -- Alternativa con EXISTS:
    SELECT DISTINCT s1.provincia FROM productos.sucursal s1
    JOIN operaciones.detalle d1 ON s1.num = d1.num
    WHERE EXISTS (
        SELECT 1 FROM productos.sucursal s2
        JOIN operaciones.detalle d on s2.num = d2.num
        WHERE s2.provincia = s1.provincia AND d2.cod <> d1.cod
        -- Hay un producto distinto para la MISMA PROVINCIA
    );

-- 11. Provincia/s que más facturó durante el 2020.

SELECT s.provincia FROM productos.sucursal s
JOIN operaciones.detalle d ON s.num = d.num
JOIN operaciones.factura f ON d.numf = f.num
WHERE f.fecha BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY s.provincia
HAVING SUM(d.precio * d.cantidad) >= ALL (
    SELECT SUM(d.precio * d.cantidad) FROM productos.sucursal s
    JOIN operaciones.detalle d ON s.num = d.num
    JOIN operaciones.factura f ON d.numf = f.num
    WHERE f.fecha BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY s.provincia
);

    -- Se calcula el total facturado por cada provincia y se compara ese resultado obtenido (>= ALL) con el resultado del resto de provincias (se repite la misma sintaxis, sólo cambia el SELECT con lo mismo que se está comparando en el HAVING).

    -- Alternativa con MAX:
    SELECT s.provincia FROM productos.sucursal s
    JOIN operaciones.detalle d ON s.num = d.num
    JOIN operaciones.factura f ON d.numf = f.num
    WHERE f.fecha BETWEEN '2020-01-01' AND '2020-31-12'
    GROUP BY s.provincia
    HAVING SUM(d.precio * d.cantidad) = (
        SELECT MAX(total) FROM (
            SELECT SUM(d.precio * d.cantidad) as total FROM productos.sucursal s
            JOIN operaciones.detalle d ON s.num = d.num
            JOIN operaciones.facutra ON d.numf = f.num
            WHERE f.fecha BETWEEN '2020-01-01' AND '2020-31-12'
            GROUP BY s.provincia
        ) t
    );

-- 12. Sucursales (todos los datos) que vendieron todos los productos que se comercializan en San Luis.

SELECT s.* FROM productos.sucursal s
WHERE NOT EXISTS (
    SELECT 1 FROM productos.producto p
    JOIN productos.sucursal s ON p.num = s.num
    WHERE s.provincia = 'San Luis'
        AND NOT EXISTS (
            SELECT 1 FROM operaciones.detalle d
            WHERE d.num = s.num AND d.cod = p.cod
        )
);

    /*
        WHERE NOT EXISTS (
            conjunto_de_todos_los_elementos (relación distinta a antes del WHERE).
            JOIN relacion_necesaria
            WHERE condicion_del_conjunto
              AND NOT EXISTS (
                  relacion_que_deberia_existir con WHERE, NO HAY JOIN.
              )
        );

    "No hay un/a ____ que no haya ____".

    */