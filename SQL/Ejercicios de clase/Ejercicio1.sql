CREATE TABLE ciu1 (
  idCiu INT PRIMARY KEY,
  nomCiu VARCHAR(100) NOT NULL,
  cantHab INT DEFAULT 0
);

CREATE TABLE pers1(
  cuil VARCHAR(15) PRIMARY KEY,
  nom VARCHAR(50),
  idCiu INTEGER,
  edad INTEGER CHECK (edad > 0),
  trabaja VARCHAR(2) DEFAULT 'Sí',
 
 CONSTRAINT fk_ciudad /* Pone nombre a la restricción */
    FOREIGN KEY (idCiu) /* La tabla depende DEPENDE de la columna idCiu de otra tabla */
    REFERENCES ciu1(idCiu) /* Especifica la tabla referenciada (ciu1) y la columna referenciada (idCiu) */
    ON DELETE RESTRICT /* Cuando se borre se aplica el modo de restricción, por lo que no deja borrar una ciudad si alguien más la usa */
    ON UPDATE CASCADE /* Si cambia el id de una ciudad entonces se propaga el cambio a otras tablas */
);

/* 
a)
    INSERT INTO pers1 VALUES 
        ('20-11111111-1', 'Juan Perez', 1, 35, 'si'), 
        ('27-22222222-2', 'Ana Gomez', 2, 28, 'no'), 
        ('23-33333333-3', 'Carlos Diaz', 1, 40, 'si'), 
        ('25-44444444-4', 'María Lopez', 3, 22, 'no');

    No permite insertar debido a que no existe ninguna ciudad con ID 1, 2 y/o 3.

b)
    INSERT INTO pers1 VALUES ('20-55555555-1', 'Juan Sanchez', 10, 35, 'si');
    
    No permite insertar por la misma razón que a).

c)
    INSERT INTO persCiud.ciu1 VALUES (1, 'Buenos Aires', 3000000); 
    INSERT INTO persCiud.ciu1 VALUES (2, 'Rosario', null); 
    INSERT INTO persCiud.ciu1 VALUES (3, null, 1400000); 
    INSERT INTO persCiud.ciu1 VALUES (4, 'Mendoza', -800000);

    No permite insertar porque existe un null y la restricción nomCiu VARCHAR(100) NOT NULL no lo permite.

d)
    INSERT INTO persCiud.ciu1 VALUES (3, 'San Juan', 822853); 
    INSERT INTO persCiud.ciu1 VALUES (4, 'Mendoza',  2043540);

    Sí permite insertar.
*/

INSERT INTO ciu1 VALUES (1, 'Buenos Aires', 3000000); 
INSERT INTO ciu1 VALUES (2, 'Rosario', null); 
INSERT INTO ciu1 VALUES (3, 'San Juan', 1400000); 
INSERT INTO ciu1 VALUES (4, 'Mendoza', -800000);

INSERT INTO pers1 VALUES (21464075327, 'Gina Papeschi', 1, 21, 'No');

--DELETE from ciu1
--where idCiu=1;

UPDATE ciu1
SET idCiu = 10
WHERE idCiu = 1;

CREATE TABLE ciu2 (
  idCiu INT PRIMARY KEY,
  nomCiu VARCHAR(100) NOT NULL,
  cantHab INT DEFAULT 0
);

CREATE TABLE pers2(
  cuil VARCHAR(15) PRIMARY KEY,
  nom VARCHAR(50),
  idCiu INTEGER,
  edad INTEGER,
  trabaja VARCHAR(2),

  CONSTRAINT fk_ciudad2
    FOREIGN KEY (idCiu)
    REFERENCES ciu2(idCiu)
    ON DELETE SET NULL /* Si se borra una ciudad las personas NO se borran, sino que se le asigna null */
    ON UPDATE RESTRICT /* No se puede cambiar el idCiu si se está utilizando */
);

-- RESTRICT -> Impide
-- CASCADE -> Propaga
-- SET NULL -> Pone NULL
-- SET DEFAULT -> Si se BORRA o CAMBIA la columna, la FK toma el valor POR DEFECTO de la columna

INSERT INTO ciu2 VALUES (1, 'Buenos Aires', 3000000); 
INSERT INTO ciu2 VALUES (2, 'Rosario', null); 
INSERT INTO ciu2 VALUES (3, 'San Juan', 1400000); 
INSERT INTO ciu2 VALUES (4, 'Mendoza', -800000);

INSERT INTO pers2 VALUES (21464075327, 'Gina Papeschi', 3, 21, 'No');

SELECT * FROM ciu2, pers2;

DELETE from ciu2
where idCiu=1;

SELECT * FROM ciu2, pers2;

INSERT INTO pers1  VALUES ('20-66666666-1', 'Ignacio Perez', 10, 33);

-- UPDATE pers1
-- SET edad=0 
-- WHERE cuil='20-66666666-1';

SELECT * FROM ciu1;
SELECT * FROM pers1;

DROP TABLE pers2;
DROP TABLE ciu2;

CREATE TABLE ciu3(
  idCiu INT PRIMARY KEY,
  nomCiu VARCHAR(100) NOT NULL,
  cantHab INT DEFAULT 0
);

CREATE TABLE pers3(
  cuil VARCHAR(20) PRIMARY KEY,
  nom VARCHAR(50),
  idCiu INTEGER DEFAULT 0,
  edad INTEGER CHECK (edad > 0),
  trabaja VARCHAR(2) DEFAULT 'Sí',
  
  CONSTRAINT fk_ciudad3
    FOREIGN KEY (idCiu)
    REFERENCES ciu3(idCiu)
    ON DELETE NO ACTION
    ON UPDATE SET DEFAULT
);

INSERT INTO ciu3 VALUES (0, 'Sin ciudad', 0);
INSERT INTO ciu3 VALUES (1, 'Buenos Aires', 3000000);

INSERT INTO pers3
VALUES ('20-11111111-1', 'Juan Perez', 1, 35);

SELECT * FROM ciu3;
SELECT * FROM pers3;

-- DELETE FROM ciu3 No permite porque el ID de la ciudad está siendo referenciada en pers3.
-- WHERE idCiu = 1; NO ACTION impide la eliminación cuando existen registros relacionados.

UPDATE ciu3
SET idCiu = 10
WHERE idCiu = 1;

SELECT * FROM ciu3;
SELECT * FROM pers3;

-- ON DELETE NO ACTION: no permite eliminar una ciudad cuando existen personas asociadas a ella, preservando la integridad referencial.
-- ON UPDATE SET DEFAULT: al modificarse la clave primaria de una ciudad, las referencias en la tabla pers3 se reemplazan por el valor por defecto definido para idCiu.
-- Para que SET DEFAULT funcione correctamente, el valor por defecto debe ser válido respecto de la clave foránea (por ejemplo, existir una ciudad con idCiu = 0).
