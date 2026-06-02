-- Script PostgreSQL para el Instituto Superior del Sur - Cursos de Verano
-- Se consideran las siguientes relaciones:
CREATE SCHEMA ejercicio3;
SET search_path TO ejercicio3;

/*
pers (personas) = {correo, nomU (nombre usuario), nombre}
curso (cursos) = {nom, cH (carga horaria)}
insc (inscribe) = {correo, nom, correoD, nota}
dicta = {correo, nom}
temas = {nom, tema}
*/

-- Eliminación de tablas si existen
DROP TABLE IF EXISTS temas CASCADE;
DROP TABLE IF EXISTS insc CASCADE;
DROP TABLE IF EXISTS dicta CASCADE;
DROP TABLE IF EXISTS curso CASCADE;
DROP TABLE IF EXISTS pers CASCADE;

-- Creación de tablas
CREATE TABLE pers (
    correo VARCHAR(50) PRIMARY KEY,
    nomU VARCHAR(50) NOT NULL,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE curso (
    nom VARCHAR(50) PRIMARY KEY,
    cH INTEGER NOT NULL CHECK (cH > 0)
);

CREATE TABLE dicta (
    correo VARCHAR(50),
    nom VARCHAR(50),
    PRIMARY KEY (correo, nom),
    FOREIGN KEY (correo) REFERENCES pers(correo),
    FOREIGN KEY (nom) REFERENCES curso(nom)
);

CREATE TABLE insc (
    correo VARCHAR(50),
    nom VARCHAR(50),
    correoD VARCHAR(50),
    nota NUMERIC(4,2) CHECK (nota >= 0 AND nota <= 10),
    
    PRIMARY KEY (correo, nom),
    
    -- Claves foráneas individuales movidas al nivel de tabla
    FOREIGN KEY (correo) REFERENCES pers(correo),
    FOREIGN KEY (nom) REFERENCES curso(nom),
    FOREIGN KEY (correoD) REFERENCES pers(correo),
    
    -- Garantizamos por diseño que un alumno no pueda ser evaluado por un profesor que no dicta ese curso
    FOREIGN KEY (correoD, nom) REFERENCES dicta(correo, nom)
);

CREATE TABLE temas (
    nom VARCHAR(50),
    tema VARCHAR(100) NOT NULL,
    
    PRIMARY KEY (nom, tema),
    FOREIGN KEY (nom) REFERENCES curso(nom)
);

-- Inserción de personas (docentes y alumnos)
INSERT INTO pers VALUES ('pedroibañez@yahoo.com.ar', 'pedro_i', 'Pedro Ibañez');
INSERT INTO pers VALUES ('mlopez@gmail.com', 'mlopez', 'María López');
INSERT INTO pers VALUES ('rperez@hotmail.com', 'rperez', 'Roberto Pérez');
INSERT INTO pers VALUES ('anagarcia@gmail.com', 'anagarcia', 'Ana García');
INSERT INTO pers VALUES ('jgomez@outlook.com', 'jgomez', 'Juan Gómez');
INSERT INTO pers VALUES ('carmenv@gmail.com', 'carmenv', 'Carmen Vázquez');
INSERT INTO pers VALUES ('luisf@yahoo.com', 'luisf', 'Luis Fernández');
INSERT INTO pers VALUES ('rosam@gmail.com', 'rosam', 'Rosa Martínez');
INSERT INTO pers VALUES ('rosap@yahoo.com.ar', 'rosap', 'Rosa Paredes');
INSERT INTO pers VALUES ('carlosr@gmail.com', 'carlosr', 'Carlos Rodríguez');
INSERT INTO pers VALUES ('mariaf@hotmail.com', 'mariaf', 'María Fernández');
INSERT INTO pers VALUES ('davidm@yahoo.com', 'davidm', 'David Martínez');
INSERT INTO pers VALUES ('evam@gmail.com', 'evam', 'Eva Morales');

-- Inserción de cursos
INSERT INTO curso VALUES ('Python I', 30);
INSERT INTO curso VALUES ('Python II', 45);
INSERT INTO curso VALUES ('Java I', 40);
INSERT INTO curso VALUES ('Java II', 50);
INSERT INTO curso VALUES ('Ruby', 40);
INSERT INTO curso VALUES ('Ruby I', 25);
INSERT INTO curso VALUES ('Kotlin I', 35);
INSERT INTO curso VALUES ('JavaScript', 30);
INSERT INTO curso VALUES ('PHP', 25);
INSERT INTO curso VALUES ('C++', 55);
INSERT INTO curso VALUES ('HTML', 20);

-- Inserción de relaciones dicta (profesor-curso)
INSERT INTO dicta VALUES ('pedroibañez@yahoo.com.ar', 'Python I');
INSERT INTO dicta VALUES ('pedroibañez@yahoo.com.ar', 'Python II');
INSERT INTO dicta VALUES ('mlopez@gmail.com', 'Java I');
INSERT INTO dicta VALUES ('mlopez@gmail.com', 'Java II');
INSERT INTO dicta VALUES ('rperez@hotmail.com', 'Ruby');
INSERT INTO dicta VALUES ('rperez@hotmail.com', 'Ruby I');
INSERT INTO dicta VALUES ('anagarcia@gmail.com', 'Kotlin I');
INSERT INTO dicta VALUES ('jgomez@outlook.com', 'JavaScript');
INSERT INTO dicta VALUES ('carmenv@gmail.com', 'PHP');
INSERT INTO dicta VALUES ('luisf@yahoo.com', 'C++');
INSERT INTO dicta VALUES ('evam@gmail.com', 'Python I'); 
INSERT INTO dicta VALUES ('carmenv@gmail.com', 'HTML');

-- Inserción de inscripciones (alumno-curso-profesor-nota)
INSERT INTO insc VALUES ('rosam@gmail.com', 'Python I', 'pedroibañez@yahoo.com.ar', 8.5);
INSERT INTO insc VALUES ('rosam@gmail.com', 'Python II', 'pedroibañez@yahoo.com.ar', 7.8);
INSERT INTO insc VALUES ('rosap@yahoo.com.ar', 'Python I', 'pedroibañez@yahoo.com.ar', 9.0);
INSERT INTO insc VALUES ('carlosr@gmail.com', 'Python I', 'pedroibañez@yahoo.com.ar', 7.0);
INSERT INTO insc VALUES ('carlosr@gmail.com', 'Java I', 'mlopez@gmail.com', 8.2);
INSERT INTO insc VALUES ('mariaf@hotmail.com', 'Java I', 'mlopez@gmail.com', 9.5);
INSERT INTO insc VALUES ('mariaf@hotmail.com', 'Java II', 'mlopez@gmail.com', 8.7);
INSERT INTO insc VALUES ('davidm@yahoo.com', 'Ruby', 'rperez@hotmail.com', 7.5);
INSERT INTO insc VALUES ('pedroibañez@yahoo.com.ar', 'Java I', 'mlopez@gmail.com', 9.2);
INSERT INTO insc VALUES ('mlopez@gmail.com', 'Python I', 'pedroibañez@yahoo.com.ar', 8.9);

-- Inserción de temas por curso
INSERT INTO temas VALUES ('Python I', 'Introducción a Python');
INSERT INTO temas VALUES ('Python I', 'Estructuras de datos básicas');
INSERT INTO temas VALUES ('Python II', 'Programación orientada a objetos');
INSERT INTO temas VALUES ('Python II', 'Módulos y paquetes');
INSERT INTO temas VALUES ('Java I', 'Fundamentos de Java');
INSERT INTO temas VALUES ('Java II', 'Interfaces gráficas con Swing');
INSERT INTO temas VALUES ('Ruby', 'Sintaxis básica');
INSERT INTO temas VALUES ('Ruby I', 'Introducción a Ruby');
INSERT INTO temas VALUES ('Kotlin I', 'Fundamentos de Kotlin');
INSERT INTO temas VALUES ('JavaScript', 'DOM y eventos');
INSERT INTO temas VALUES ('PHP', 'Conexión a bases de datos');
INSERT INTO temas VALUES ('C++', 'Punteros y memoria dinámica');
INSERT INTO temas VALUES ('HTML', 'Estructura de documentos web');

-- 1. Actualice la carga horaria del curso Ruby por 60.
/*
UPDATE curso
SET cH = 60
WHERE nom = 'Ruby';
*/

-- 2. Elimine el curso Ruby I.

-- DELETE FROM curso WHERE nom = 'Ruby I';

-- CONSULTAS

-- 3. Correo y nombre de todas las personas.

SELECT p.correo, p.nombre FROM pers p;

-- 4. Cantidad de cursos registrados.

SELECT COUNT(nom) AS cursos_registrados FROM curso;

-- 5. Cantidad de cursos con inscriptos.

SELECT COUNT(DISTINCT i.nom) AS cursos_con_inscriptos FROM insc i;
    -- Se usa DISTINCT para evitar repetidos en un mismo curso.

-- 6. Nota máxima obtenida en el curso ’Python I‘.

SELECT MAX(i.nota) FROM insc i
WHERE i.nom = 'Python I';

-- 7. Nombre de los cursos registrados, ordenados ascendentemente por nombre.

SELECT nom FROM curso
ORDER BY nom ASC;

-- 8. Cursos (todos los datos) cuya carga horaria sea superior a las 40 horas reloj.

SELECT * FROM curso
WHERE cH > 40;

-- 9. Cursos (todos los datos) cuya carga horaria se encuentre entre 40 y 45 horas reloj.

SELECT * FROM curso
WHERE cH BETWEEN 40 AND 45;
    -- El BETWEEN es para incluir también el 40 y el 45.
    -- Puede hacerse también con >= y <=.

-- 10. Cursos que tienen una carga horaria superior a la del curso “Kotlin I”, ordenados descendentemente por cantidad de horas.

SELECT * FROM curso
WHERE cH > (SELECT cH FROM curso WHERE nom = 'Kotlin I')
ORDER BY cH DESC;

-- 11. Nombre del curso que tiene una carga horaria superior a la de todos los cursos que dicta el profesor “pedroibañez@yahoo.com.ar”.

SELECT nom FROM curso
WHERE cH > 
    (SELECT MAX(c.cH) FROM curso c
        JOIN dicta d ON c.nom = d.nom
        WHERE d.correo = 'pedroibañez@yahoo.com.ar'
    );

-- 12. Personas, docentes o alumnos (todos sus datos), que se llamen Rosa.

SELECT * FROM pers
WHERE nombre LIKE 'Rosa%';
    -- Como el nombre se guarda con el apellido en el mismo campo, LIKE permite que empiece con 'Rosa' y termine con lo que sea.
    -- LIKE 'Rosa%' -> Empieza con Rosa.
    -- LIKE '%Rosa%' -> Contiene Rosa en cualquier parte.

-- 13. Cursos (nombre) junto a los datos del docente que los dicta.

SELECT c.nom, p.correo, p.nombre, p.nomU FROM curso c
JOIN dicta d ON c.nom = d.nom
JOIN pers p ON d.correo = p.correo
ORDER BY c.nom; -- Opcional.

-- 14. Cursos (todos los datos) junto a los datos de los alumnos inscriptos. Se deben incluir todos los cursos registrados más allá que no tengan alumnos inscriptos.

SELECT c.nom, c.cH, p.correo, p.nombre, p.nomU FROM curso c
LEFT JOIN insc i ON c.nom = i.nom
LEFT JOIN pers p ON i.correo = p.correo;
    -- LEFT JOIN insc mantiene TODOS LOS CURSOS, incluso SIN INSCRIPTOS.
    -- LEFT JOIN pers trae todos los datos de los alumnos SI EXISTE INSCRIPCIÓN.
    -- pers debe ir con LEFT JOIN también porque DEPENDE del LEFT JOIN de insc (una tabla que puede quedar NULL).

-- 15. Docentes (correo) que dictan el curso Python I y/o Python II.

SELECT correo FROM dicta
WHERE nom = 'Python I' OR nom = 'Python II';
    -- También puede ser WHERE nom IN ('Python I', 'Python II').

-- 16. Docentes (correo) que dictan los cursos Python I y Python II.

SELECT correo FROM dicta
WHERE nom = 'Python I' INTERSECT (
    SELECT correo FROM dicta WHERE nom = 'Python II'
    );

-- 17. Docentes (todos los datos) que cursaron algún curso de verano.

SELECT * FROM pers p
JOIN dicta d ON d.correo = p.correo INTERSECT ( -- Docentes
    SELECT * FROM pers p2
    JOIN insc i ON p2.correo = i.correo         -- Alumnos
    );
    -- En esta versión se consideran los docentes que también son alumnos.
    -- Elimina duplicados automáticamente.

SELECT DISTINCT * FROM pers p
JOIN dicta d ON p.correo = d.correo
JOIN insc i ON p.correo = i.correo;
    -- Puede generar duplicados por múltiples inscripciones o múltiples cursos dictados, por eso se usa DISTINCT.

-- 18. Alumnos (correo) que se inscribieron en más de un curso de verano.

-- 19. Docentes (todos los datos) que dictan más de un curso cuya carga horaria sea inferior a 30 horas reloj.

-- 20. Pares de alumnos (todos los datos) que cursaron algún curso en común. 

-- TABLAS VIRTUALES/VISTAS de SQL
-- 24. Especifique la Vista “cursosCortos” que tenga los siguientes atributos nombre, carga horaria. Los cursos cortos son aquellos cuya carga horaria es inferior a las 40 horas.

-- 25. Muestre los datos contenidos en la vista, ordenados según el nombre.

-- 26. Inserte el curso “DBA PostgreSQL” con una carga horaria de 50 horas, a través de la vista.

-- 27. Especifique la Vista “cursosCortosCO” idem a la anterior, pero agregando la especificación “WITH CHECK OPTION ”.

-- 28. Inserte el curso “DBA Oracle” con una carga horaria de 55 horas, a través de la vista.

-- 29. Especifique la Vista “alumnosPython1” que tenga los siguientes atributos correo, nombre de usuario, nombre y representan a los alumnos que se inscribieron en el curso “PYTHON I”.

-- 30. Muestre los datos contenidos en la vista creada en el punto anterior, cuyo correo sea una cuenta de Gmail.

-- 31. Especifique la Vista “alumnosPython2” que tenga los siguientes atributos nombre de usuario, nombre y representan a los alumnos que se inscribieron en el curso “PYTHON II”.

-- 32. Muestre los datos contenidos en la vista.

-- 33. Inserte un nuevo alumno con los siguientes datos: < orm@gmail.com, or, Orlando Martin >

-- GESTIÓN DE USUARIOS
-- 34. Cree el usuario “alumno” con contraseña “alumno1”.

-- 35. Cambie su contraseña, por “alumno”.

-- 36. Concédale el permiso de SELECT e INSERT sobre la tabla CURSO.

-- 37. A través de una consulta al catálogo del sistema, visualice los permisos del usuario “alumno”.

-- 38. Acceda con el usuario mencionado en el punto anterior (debe generar una nueva instancia que referencie al mismo servidor, pero con el usuario “alumno”), ejecute un SELECT sobre la tabla CURSO y luego, sobre la tabla DICTA. Analice las respuestas.

-- 39. Elimine el permiso SELECT sobre la tabla DICTA.

-- 40. Visualice nuevamente los permisos del usuario “alumno”. 

-- CONSULTAS AL CATÁLOGO
-- 41. Muestre los datos de las bases de datos creadas.

-- 42. Muestre las tablas de la base de datos actual.

-- 43. Muestre las columnas e índices de una tabla.

-- 44. Muestra los usuarios conectados.

-- 45. Muestre el tamaño que ocupa la tabla DICTA.