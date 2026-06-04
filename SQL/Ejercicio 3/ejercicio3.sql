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

    -- Alternativa:
    SELECT COUNT(*) AS cursos_con_inscriptos FROM (
        -- Se cuentan las filas en cursos y el resultado se guarda en cursos_con_inscriptos.
        SELECT nom FROM insc
        GROUP BY nom -- Agrupa filas con el MISMO NOMBRE de curso.
    ) cursos; -- Quiere decir que es una TABLA TEMPORAL llamada cursos.

-- 6. Nota máxima obtenida en el curso ’Python I‘.

SELECT MAX(i.nota) FROM insc i
WHERE i.nom = 'Python I';

    -- Alternativa:
    SELECT i.nota FROM insc i
    WHERE i.nom = 'Python' AND i.nota >= ALL (
        SELECT i2.nota FROM insc i2 WHERE i2.nom = 'Python I'
    );

    -- ALternativa sin MAX ni ALL:
    SELECT i.nota FROM insc i
    WHERE i.nom = 'Python I'
    ORDER BY i.nota DESC
    LIMIT 1; -- Se ordenan las notas de mayor a menor y se toma la primera.

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

    -- Alternativa (SELF JOIN):
    SELECT c1.* FROM curso c1 -- Curso que se quiere mostrar (solo c1).
    JOIN curso c2 ON c2.nom = 'Kotlin I' 
        -- Se toma únicamente el registro cuyo nombre sea Kotlin I (curso de referencia).
        -- Después del JOIN cada fila de c1 se combina con esa única fila de c2.
    WHERE c1.cH > c2.CH -- Se compara cada curso con Kotlin I.
    ORDER BY c1.cH DESC;

-- 11. Nombre del curso que tiene una carga horaria superior a la de todos los cursos que dicta el profesor “pedroibañez@yahoo.com.ar”.

SELECT nom FROM curso
WHERE cH > (
    SELECT MAX(c.cH) FROM curso c
    JOIN dicta d ON c.nom = d.nom
    WHERE d.correo = 'pedroibañez@yahoo.com.ar'
    );

    -- Alternativa con ALL:
    SELECT nom FROM curso
    WHERE cH > ALL (
        SELECT c.cH FROM curso c
        JOIN dicta d ON c.nom = d.nom
        WHERE d.correo = 'pedroibañez@yahoo.com.ar'
    );

-- 12. Personas, docentes o alumnos (todos sus datos), que se llamen Rosa.

SELECT * FROM pers
WHERE nombre LIKE 'Rosa%';
    -- Como el nombre se guarda con el apellido en el mismo campo, LIKE permite que empiece con 'Rosa' y termine con lo que sea.
    -- LIKE 'Rosa%' -> Empieza con Rosa.
    -- LIKE '%Rosa%' -> Contiene Rosa en cualquier parte.

    -- Alternativa:
    SELECT * FROM pers
    WHERE LEFT(nombre, 4) = 'Rosa'; -- Compara los primeros 4 caracteres del nombre.

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
WHERE nom = 'Python I' OR nom = 'Python II';    -- Varias condiciones.
    
    -- Alternativa con IN:
    SELECT correo FROM dicta
    WHERE nom IN ('Python I', 'Python II');     -- Varias condiciones de forma compacta.

    -- Alternativa con UNION:
    SELECT correo FROM dicta
    WHERE nom = 'Python I' UNION (              -- Unión de conjuntos.
        SELECT correo FROM dicta
        WHERE nom = 'Python II'
    );

-- 16. Docentes (correo) que dictan los cursos Python I y Python II.

SELECT correo FROM dicta
WHERE nom = 'Python I' INTERSECT (
    SELECT correo FROM dicta WHERE nom = 'Python II'
    );

    -- Alternativa con GROUP BY e IN:
    SELECT correo FROM dicta
    WHERE nom IN ('Python I', 'Python II')
    GROUP BY correo
    HAVING COUNT(DISTINCT nom) = 2;
        -- HAVING COUNT filtra los grupos formados por cada docente, conservando únicamente aquellos que dictan AMBOS CURSOS.
        -- Esto significa que si un docente sólo dicta Python I o sólo Python II, la cantidad de cursos distintos será 1 y no será incluido en el resultado (por eso se coloca que la cantidad de cursos distintos es igual a 2).

-- 17. Docentes (todos los datos) que cursaron algún curso de verano.

SELECT p.* FROM pers p
JOIN dicta d ON d.correo = p.correo INTERSECT ( -- Docentes
    SELECT p2.* FROM pers p2
    JOIN insc i ON p2.correo = i.correo         -- Alumnos
    );
    -- En esta versión se consideran los docentes que también son alumnos.
    -- INTERSECT elimina duplicados automáticamente.
    
    -- Alternativa SIN INTERSECT
    SELECT DISTINCT p.* FROM pers p
    JOIN dicta d ON p.correo = d.correo
    JOIN insc i ON p.correo = i.correo;
        -- Puede generar duplicados por múltiples inscripciones o múltiples cursos dictados, por eso se usa DISTINCT.

-- 18. Alumnos (correo) que se inscribieron en más de un curso de verano.

SELECT correo FROM insc
GROUP BY correo
HAVING COUNT(nom) > 1;
    -- El DISTINCT no es necesario porque la clave primaria (correo, nom) impide que un alumno se inscriba más de una vez al mismo curso (por lo que no se repite el correo para un mismo curso).

    -- Alternativa con SELF JOIN:
    SELECT DISTINCT i1.correo FROM insc i1
    JOIN insc i2 ON i1.correo = i2.correo AND i1.nom <> i2.nom;
        -- Para un mismo correo inscripto, existen nombres de cursos distintos.

-- 19. Docentes (todos los datos) que dictan más de un curso cuya carga horaria sea inferior a 30 horas reloj.

SELECT p.* FROM pers p
JOIN dicta d ON p.correo = d.correo
JOIN curso c ON d.nom = c.nom
WHERE cH < 30
GROUP BY p.*
HAVING COUNT(*) > 1;
    -- COUNT(*) cuenta filas.
    -- COUNT(c.nom) cuenta valores NO NULL de c.nom. Como nom es la clave primaria de curso, NUNCA ES NULL en esas filas, por lo que se puede usar (*).

    -- Alternativa con subconsulta:
    SELECT p.* FROM pers p
    WHERE (
        SELECT COUNT(*) FROM dicta d
        JOIN curso c ON d.nom = c.nom
        WHERE d.correo = p.correo AND c.cH < 30
    ) > 1;
        -- Devuelve la cantidad de filas en dicta donde coincide el correo con la persona (es docente) y el curso con el que coincide el nombre tiene carga horaria menor a 30hs. Ese resultado debe ser mayor a 1.

-- 20. Pares de alumnos (todos los datos) que cursaron algún curso en común. 

SELECT p1.*, p2.*, i1.nom AS curso_comun FROM insc i1 -- Opcional para ver el curso.
JOIN insc i2 ON i1.nom = i2.nom AND i1.correo < i2.correo
JOIN pers p1 ON p1.correo = i1.correo
JOIN pers p2 ON p2.correo = i2.correo;
    -- Se usa < y no <> para evitar duplicados simétricos. Con < solo una de las combinaciones es verdadera y se descarta la otra, de lo contrario aparecerían ambos pares: (A,B) y (B, A).
    -- Es una técnica común para generar combinaciones de pares sin repetición.

    -- Alternativa con EXISTS:
    SELECT p1.*, p2.* FROM pers p1
    JOIN pers p2 ON p1.correo < p2.correo
    WHERE EXISTS (
        SELECT * FROM insc i1
        JOIN insc i2 ON i1.nom = i2.nom
        WHERE i1.correo = p1.correo AND i2.correo = p2.correo
    );