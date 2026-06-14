DROP TABLE IF EXISTS Sigue CASCADE;
DROP TABLE IF EXISTS Actua CASCADE;
DROP TABLE IF EXISTS Dirige CASCADE;
DROP TABLE IF EXISTS Pelicula CASCADE;
DROP TABLE IF EXISTS Persona CASCADE;

/*
Persona = {idP, nombre, fechaNac, paisNac}  
Película = {idPel, titulo, fEstreno, lema, genero, paisOrigen}  
Dirige = {idP, idPel} 
Actua = {idP, idPeltitulo} 
Sigue = {idSeguido (Persona), idSeguidor (Persona)}
*/

-- Creación de tablas
CREATE TABLE Persona (
    idP SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fechaNac DATE NOT NULL,
    paisNac VARCHAR(50) NOT NULL
);

CREATE TABLE Pelicula (
    idPel SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    fEstreno DATE NOT NULL,
    lema VARCHAR(200),
    genero VARCHAR(50) NOT NULL,
    paisOrigen VARCHAR(50) NOT NULL
);

CREATE TABLE Dirige (
    idP INTEGER REFERENCES Persona(idP) ON DELETE CASCADE,
    idPel INTEGER REFERENCES Pelicula(idPel) ON DELETE CASCADE,
    PRIMARY KEY (idP, idPel)
);

CREATE TABLE Actua (
    idP INTEGER REFERENCES Persona(idP) ON DELETE CASCADE,
    idPel INTEGER REFERENCES Pelicula(idPel) ON DELETE CASCADE,
    PRIMARY KEY (idP, idPel)
);

CREATE TABLE Sigue (
    idSeguido INTEGER REFERENCES Persona(idP) ON DELETE CASCADE,
    idSeguidor INTEGER REFERENCES Persona(idP) ON DELETE CASCADE,
    PRIMARY KEY (idSeguido, idSeguidor),
    CHECK (idSeguido <> idSeguidor)
);

-- Inserción de datos de prueba

-- Inserción de personas (actores y directores)
INSERT INTO Persona (nombre, fechaNac, paisNac) VALUES
('Keanu Reeves', '1964-09-02', 'Canadá'),
('Carrie-Anne Moss', '1967-08-21', 'Canadá'),
('Laurence Fishburne', '1961-07-30', 'EEUU'),
('Hugo Weaving', '1960-04-04', 'Nigeria'),
('Lana Wachowski', '1965-06-21', 'EEUU'),
('Lilly Wachowski', '1967-12-29', 'EEUU'),
('Steven Spielberg', '1946-12-18', 'EEUU'),
('Harrison Ford', '1942-07-13', 'EEUU'),
('Mark Hamill', '1951-09-25', 'EEUU'),
('Carrie Fisher', '1956-10-21', 'EEUU'),
('George Lucas', '1944-05-14', 'EEUU'),
('Ricardo Darín', '1957-01-16', 'Argentina'),
('Guillermo Francella', '1955-02-14', 'Argentina'),
('Juan José Campanella', '1959-07-19', 'Argentina'),
('Natalia Oreiro', '1977-05-19', 'Uruguay'),
('Leonardo DiCaprio', '1974-11-11', 'EEUU'),
('Christopher Nolan', '1970-07-30', 'Reino Unido'),
('Tom Hanks', '1956-07-09', 'EEUU'),
('Robert Zemeckis', '1952-05-14', 'EEUU'),
('James Cameron', '1954-08-16', 'Canadá'),
('Sam Worthington', '1976-08-02', 'Australia');
-- Inserción de películas

INSERT INTO Pelicula (titulo, fEstreno, lema, genero, paisOrigen) VALUES
('The Matrix', '1999-03-31', 'Welcome to the Real World', 'Ciencia Ficción', 'EEUU'),
('The Matrix Reloaded', '2003-05-15', 'Free your mind', 'Ciencia Ficción', 'EEUU'),
('The Matrix Revolutions', '2003-11-05', 'Everything that has a beginning has an end', 'Ciencia Ficción', 'EEUU'),
('Star Wars: Episode IV', '1977-05-25', 'May the Force be with you', 'Ciencia Ficción', 'EEUU'),
('Star Wars: Episode V', '1980-05-21', 'The Empire Strikes Back', 'Ciencia Ficción', 'EEUU'),
('El secreto de sus ojos', '2009-08-13', 'Un crimen sin castigo, un amor sin olvido', 'Drama', 'Argentina'),
('El hijo de la novia', '2001-08-16', 'Volver a empezar', 'Drama', 'Argentina'),
('El robo del siglo', '1990-05-17', 'Robar no es un crimen, el verdadero crimen es que te roben', 'Comedia', 'Argentina'),
('Titanic', '1997-12-19', 'Nothing on Earth could come between them', 'Romance', 'EEUU'),
('Avatar', '2009-12-18', 'Enter the World', 'Ciencia Ficción', 'EEUU'),
('Inception', '2010-07-16', 'Your mind is the scene of the crime', 'Ciencia Ficción', 'EEUU'),
('Forrest Gump', '1994-07-06', 'The world will never be the same once you have seen it through the eyes of Forrest Gump', 'Drama', 'EEUU'),
('John Wick', '2014-10-24', 'Don''t set him off', 'Acción', 'EEUU'),
('Constantine', '2005-02-18', 'Hell wants him, Heaven won''t take him, Earth needs him', 'Acción', 'EEUU'),
('Speed', '1990-06-10', 'Get ready for rush hour', 'Acción', 'EEUU'),
('Point Break', '1990-07-12', 'Veinte segundos para cambiar tu vida para siempre', 'Acción', 'EEUU'),
('Moon', '2009-07-10', 'El último lugar donde esperarías encontrarte a ti mismo', 'Ciencia Ficción', 'Reino Unido'),
('Memento', '2000-09-05', 'Some memories are best forgotten', 'Thriller', 'EEUU'),
('Interstellar', '2014-11-07', 'Mankind was born on Earth. It was never meant to die here', 'Ciencia Ficción', 'EEUU'),
('Avatar 2', '2022-12-16', 'Return to Pandora', 'Ciencia Ficción', 'EEUU'),
('The Matrix Resurrections', '2021-12-22', 'Return to the source', 'Ciencia Ficción', 'EEUU');

INSERT INTO Dirige (idP, idPel) VALUES
(5, 1), -- Lana Wachowski - The Matrix
(6, 1), -- Lilly Wachowski - The Matrix
(5, 2), -- Lana Wachowski - The Matrix Reloaded
(6, 2), -- Lilly Wachowski - The Matrix Reloaded
(5, 3), -- Lana Wachowski - The Matrix Revolutions
(6, 3), -- Lilly Wachowski - The Matrix Revolutions
(11, 4), -- George Lucas - Star Wars: Episode IV
(11, 5), -- George Lucas - Star Wars: Episode V
(14, 6), -- Juan José Campanella - El secreto de sus ojos
(14, 7), -- Juan José Campanella - El hijo de la novia
(14, 8), -- Juan José Campanella - El robo del siglo
(20, 9), -- James Cameron - Titanic
(20, 10), -- James Cameron - Avatar
(17, 11), -- Christopher Nolan - Inception
(19, 12), -- Robert Zemeckis - Forrest Gump
(1, 13), -- Keanu Reeves - John Wick (director ficticio para el ejercicio)
(20, 20), -- James Cameron - Avatar 2
(17, 18), -- Christopher Nolan - Memento
(17, 19), -- Christopher Nolan - Interstellar
(7, 17); -- Steven Spielberg - Moon (ficticio para el ejercicio) 

-- Inserción de relaciones actua (actor-película)
INSERT INTO Actua (idP, idPel) VALUES
(1, 1), -- Keanu Reeves - The Matrix
(2, 1), -- Carrie-Anne Moss - The Matrix
(3, 1), -- Laurence Fishburne - The Matrix
(4, 1), -- Hugo Weaving - The Matrix
(1, 2), -- Keanu Reeves - The Matrix Reloaded
(2, 2), -- Carrie-Anne Moss - The Matrix Reloaded
(3, 2), -- Laurence Fishburne - The Matrix Reloaded
(4, 2), -- Hugo Weaving - The Matrix Reloaded
(1, 3), -- Keanu Reeves - The Matrix Revolutions
(2, 3), -- Carrie-Anne Moss - The Matrix Revolutions
(3, 3), -- Laurence Fishburne - The Matrix Revolutions
(4, 3), -- Hugo Weaving - The Matrix Revolutions
(8, 4), -- Harrison Ford - Star Wars: Episode IV
(9, 4), -- Mark Hamill - Star Wars: Episode IV
(10, 4), -- Carrie Fisher - Star Wars: Episode IV
(8, 5), -- Harrison Ford - Star Wars: Episode V
(9, 5), -- Mark Hamill - Star Wars: Episode V
(10, 5), -- Carrie Fisher - Star Wars: Episode V
(12, 6), -- Ricardo Darín - El secreto de sus ojos
(13, 6), -- Guillermo Francella - El secreto de sus ojos
(15, 6), -- Natalia Oreiro - El secreto de sus ojos
(12, 7), -- Ricardo Darín - El hijo de la novia
(13, 7), -- Guillermo Francella - El hijo de la novia
(12, 8), -- Ricardo Darín - El robo del siglo
(13, 8), -- Guillermo Francella - El robo del siglo
(16, 9), -- Leonardo DiCaprio - Titanic
(16, 11), -- Leonardo DiCaprio - Inception
(18, 12), -- Tom Hanks - Forrest Gump
(1, 13), -- Keanu Reeves - John Wick
(1, 14), -- Keanu Reeves - Constantine
(1, 15), -- Keanu Reeves - Speed
(1, 16), -- Keanu Reeves - Point Break
(21, 10), -- Sam Worthington - Avatar
(21, 20), -- Sam Worthington - Avatar 2
(16, 19), -- Leonardo DiCaprio - Interstellar (ficticio para el ejercicio)
(18, 18); -- Tom Hanks - Memento (ficticio para el ejercicio)

-- Inserción de relaciones sigue (seguidor-seguido)
INSERT INTO Sigue (idSeguido, idSeguidor) VALUES
(1, 2), -- Carrie-Anne Moss sigue a Keanu Reeves
(1, 3), -- Laurence Fishburne sigue a Keanu Reeves
(1, 4), -- Hugo Weaving sigue a Keanu Reeves
(1, 5), -- Lana Wachowski sigue a Keanu Reeves
(5, 6), -- Lilly Wachowski sigue a Lana Wachowski
(6, 5), -- Lana Wachowski sigue a Lilly Wachowski
(11, 7), -- Steven Spielberg sigue a George Lucas
(7, 11), -- George Lucas sigue a Steven Spielberg
(12, 14), -- Juan José Campanella sigue a Ricardo Darín
(14, 12), -- Ricardo Darín sigue a Juan José Campanella
(13, 12), -- Ricardo Darín sigue a Guillermo Francella
(15, 12), -- Ricardo Darín sigue a Natalia Oreiro
(16, 20), -- James Cameron sigue a Leonardo DiCaprio
(20, 21), -- Sam Worthington sigue a James Cameron
(17, 16), -- Leonardo DiCaprio sigue a Christopher Nolan
(18, 19), -- Robert Zemeckis sigue a Tom Hanks
(19, 18), -- Tom Hanks sigue a Robert Zemeckis
(20, 16), -- Leonardo DiCaprio sigue a James Cameron
(1, 16), -- Leonardo DiCaprio sigue a Keanu Reeves
(16, 1); -- Keanu Reeves sigue a Leonardo DiCaprio

-- 1. Personas (nombre) junto a la cantidad de películas de Ciencia Ficción (género) que ha dirigido.

SELECT p.nombre, COUNT(pel.idPel) AS cant_peliculas FROM Persona p
LEFT JOIN Dirige d ON p.idP = d.idP
LEFT JOIN Pelicula pel ON d.idPel = pel.idPel AND pel.genero = 'Ciencia Ficción'
GROUP BY p.idP, p.nombre
ORDER BY cant_peliculas; -- Opcional.

    -- Alternativa con subconsulta:
    SELECT p.nombre, (
        SELECT COUNT(*) FROM Dirige d
        JOIN Pelicula pel ON d.idPel = pel.idPel
        WHERE d.idP = p.idP AND pel.genero = 'Ciencia Ficción'
    ) AS cant_peliculas
    FROM persona p
    ORDER BY cant_peliculas DESC;

    -- Alternativa con COUNT y FILTER:
    SELECT p.nombre, COUNT(pel.idPel)
    FILTER (WHERE pel.genero = 'Ciencia Ficción') AS cant_peliculas FROM Persona p
    LEFT JOIN Dirige d ON p.idP = d.idP
    LEFT JOIN Pelicula pel ON d.idPel = pel.idPel
    GROUP BY p.idP, p.nombre
    ORDER BY cant_peliculas DESC;

-- 2. Personas (nombre) que han dirigido más de 3 películas de Ciencia Ficción (género). 

SELECT p.nombre, COUNT(pel.idPel) AS cant_peliculas FROM Persona p
JOIN Dirige d ON p.idP = d.idP
JOIN Pelicula pel ON d.idPel = pel.idPel AND pel.genero = 'Ciencia Ficción'
GROUP BY p.idP, p.nombre
HAVING COUNT(pel.idPel) >= 3
ORDER BY cant_peliculas DESC;

    -- Alternativa con IN:
    SELECT p.nombre FROM Persona p
    WHERE p.idP IN (
        SELECT d.idP FROM Dirige d
        JOIN Pelicula pel ON d.idPel = pel.idPel
        WHERE pel.genero = 'Ciencia Ficción'
        GROUP BY d.idP
        HAVING COUNT(*) >= 3
    );

-- 3. Personas (nombre) que han actuado en más de una película estrenada en el año 1990. 

SELECT p.nombre FROM Persona p
JOIN Actua a ON p.idP = a.idP
JOIN Pelicula pel ON a.idPel = pel.idPel AND pel.fEstreno BETWEEN '1990-01-01' AND '1990-12-31'
GROUP BY p.idP, p.nombre
HAVING COUNT(*) > 1;

    -- Alternativa con IN:
    SELECT p.nombre FROM Persona p
    WHERE p.idP IN(
        SELECT a.idP FROM Actua a
        JOIN Pelicula pel ON a.idPel = pel.idPel
        WHERE pel.fEstreno BETWEEN '1990-01-01' AND '1990-12-31'
        GROUP BY a.idP
        HAVING COUNT(*) > 1;
    )

    -- Alternativa subconsulta relacionada:
    SELECT p.nombre FROM Persona p
    WHERE (
        SELECT COUNT(*) FROM Actua a
        JOIN Pelicula pel ON a.idPel = pel.idPel
        WHERE a.idP = p.idP AND pel.fEstreno BETWEEN '1990-01-01' AND '1990-12-31'
    ) > 1;

-- 4. Películas (título y lema) en las que han actuado solamente argentinos.

SELECT DISTINCT pel.titulo, pel.lema FROM Pelicula pel
WHERE EXISTS (               -- Evalúa que hayan actores en esa película.
    SELECT 1 FROM Actua a
    WHERE a.idPel = pel.idPel
)
AND NOT EXISTS (             -- Evalúa que esos actores no sean argentinos y los descarta.
    SELECT 1 FROM Actua a
    JOIN Persona p ON a.idP = p.idP
    WHERE a.idPel = pel.idPel
    AND p.paisNac <> 'Argentina'
);

    -- Alternativa con EXCEPT:
    SELECT pel.titulo, pel.lema FROM Pelicula pel
    JOIN Actua a ON pel.idPel = a.idPel EXCEPT ( -- Except actúa como resta.
        SELECT pel.titulo, pel.lema FROM Pelicula pel
        JOIN Actua a ON pel.idPel = a.idPel
        JOIN Persona p ON a.idP = p.idP
        WHERE p.paisNac <> 'Argentina'
    );

-- 5. Título y fecha de estreno de las películas dirigidas por Keanu Reeves. 

SELECT pel.titulo, pel.fEstreno FROM Pelicula pel
JOIN Dirige d ON pel.idPel = d.idPel
JOIN Persona p ON d.idP = p.idP
WHERE p.nombre = 'Keanu Reeves';

    -- Alternativa con subconsulta e IN:
    SELECT titulo, fEstreno FROM Pelicula
    WHERE idPel IN (
        SELECT d.idPel FROM Dirige d
        JOIN Persona p ON d.idP = p.idP
        WHERE p.nombre = 'Keanu Reeves'
    );

-- 6. Personas (todos sus datos) que han participado como actores y directores en alguna ocasión.

SELECT DISTINCT p.* FROM Persona p
JOIN Actua a ON p.idP = a.idP
JOIN Dirige d ON p.idP = d.idP;

    -- Alternativa con IN e INTERSECT:
    SELECT * FROM Persona
    WHERE idP IN (
        SELECT idP FROM Actua
        INTERSECT
        SELECT idP FROM Dirige
    );

-- 7. Personas (todos los datos) que han actuado en todas las películas.

SELECT p.* FROM Persona p
WHERE NOT EXISTS (
    SELECT 1 FROM Pelicula pel
    -- No existe una película.
    WHERE NOT EXISTS (
        SELECT 1 FROM Actua a
        WHERE a.idP = p.idP AND a.idPel = pel.idPel
        -- Para la cual no exista una actuación de la persona en ESA película.
    )
);

    /* Siempre que hay división:
        WHERE NOT EXISTS (
            conjunto_de_todos_los_elementos
            WHERE NOT EXISTS (
                relación_que_debería_existir
            )
        );
    */

    -- Alternativa con HAVING COUNT.
        SELECT p.* FROM Persona p
        JOIN Actua a ON p.idP = a.idP
        GROUP BY p.*
        HAVING COUNT(DISTINCT a.idPel) = (
            -- Cuenta cuántas películas distintas actuó esa persona particular.
            SELECT COUNT(*) FROM Pelicula
            -- Cuenta cuántas películas hay en total.
        );
        -- Si coincide la cantidad de películas distintas en las que actúa con la cantidad total de películas que hay, entonces muestra los datos de la persona.

-- 8. Personas (todos los datos) que han actuado en todas las películas producidas por EEUU.

SELECT p.* FROM Persona p
WHERE NOT EXISTS (
    SELECT 1 FROM Pelicula pel
    WHERE pel.paisOrigen = 'EEUU'
        AND NOT EXISTS (
            SELECT 1 FROM Actua a
            WHERE a.idP = p.idP AND a.idPel = pel.idPel
        )
);

    /* En este caso la condición:
        WHERE NOT EXISTS (
            conjunto_de_todos_los_elementos
            WHERE condicion_del_conjunto
              AND NOT EXISTS (
                  relacion_que_deberia_existir
              )
        );
    */

    -- Alternativa con HAVING COUNT:
    SELECT p.* FROM Persona p
    JOIN Actua a ON p.idP = a.idP
    JOIN Pelicula pel ON a.idPel = pel.idPel
    WHERE pel.paisOrigen = 'EEUU'
    GROUP BY p.*
    HAVING COUNT(DISTINCT pel.idPel) = (
        SELECT COUNT(*) FROM Pelicula
        WHERE paisOrigen = 'EEUU'
    );

-- 9. Personas (todos los datos) que han actuado en todas las películas dirigidas por Keanu Reeves.

SELECT p.* FROM Persona p
WHERE NOT EXISTS (
    SELECT 1 FROM Pelicula pel
    JOIN Dirige d ON pel.idPel = d.idPel
    JOIN Persona dir ON d.idP = dir.idP
    WHERE dir.nombre = 'Keanu Reeves'
        AND NOT EXISTS(
            SELECT 1 FROM Actua a
            WHERE a.idP = p.idP AND pel.idPel = a.idPel
        )
);

    -- Alternativa con HAVING COUNT:
    SELECT p.* FROM Persona p
    JOIN Actua a ON p.idP = a.idP
    JOIN Pelicula pel ON a.idPel = pel.idPel
    JOIN Dirige d ON pel.idPel = d.idPel
    JOIN Persona dir ON d.idP = dir.idP
    WHERE dir.nombre = 'Keanu Reeves'
    GROUP BY p.*
    HAVING COUNT(DISTINCT pel.idPel) = (
        SELECT COUNT(*) FROM Pelicula pel
        JOIN Dirige d ON pel.idPel = d.idPel
        JOIN Persona dir ON d.idP = dir.idP
        WHERE dir.nombre = 'Keanu Reeves'
    );

-- 10. Personas (nombre) que han actuado en ambas películas: The Matrix y The Matrix Revolutions.

SELECT p.nombre FROM Persona p
JOIN Actua a ON p.idP = a.idP
JOIN Pelicula pel ON a.idPel = pel.idPel
WHERE pel.titulo = 'The Matrix' INTERSECT (
    SELECT p.nombre FROM Persona p
    JOIN Actua a ON p.idP = a.idP
    JOIN Pelicula pel ON a.idPel = pel.idPel
    WHERE pel.titulo = 'The Matrix Revolutions'
);

    -- Alternativa con GROUP BY y HAVING:
    SELECT p.nombre FROM Persona p
    JOIN Actua a ON p.idP = a.idP
    JOIN Pelicula pel ON a.idPel = pel.idPel
    WHERE pel.Titulo IN ('The Matrix', 'The Matrix Revolutions')
    GROUP BY p.idP, p.nombre
    HAVING COUNT(DISTINCT pel.titulo) = 2;

-- 11. Personas (nombre) que han participado (como actor o director) en ambas películas: The Matrix y The Matrix Revolutions.

SELECT p.nombre FROM Persona p
JOIN (SELECT * FROM Actua UNION SELECT * FROM Dirige) tabla ON p.idP = tabla.idP
JOIN Pelicula pel ON tabla.idPel = pel.idPel
WHERE pel.titulo = 'The Matrix' INTERSECT (
    SELECT p.nombre FROM Persona p
    JOIN (SELECT * FROM Actua UNION SELECT * FROM Dirige) tabla ON p.idP = tabla.idP
    JOIN Pelicula pel ON tabla.idPel = pel.idPel
    WHERE pel.titulo = 'The Matrix Revolutions'
);

    -- Alternativa con GROUP BY y HAVING:
    SELECT p.nombre FROM Persona p
    JOIN (SELECT * FROM Actua UNION SELECT * FROM Dirige) tabla ON p.idP = tabla.idP
    JOIN Pelicula pel ON tabla.idPel = pel.idPel
    WHERE pel.titulo IN ('The Matrix', 'The Matrix Revolutions')
    GROUP BY p.idP, p.nombre
    HAVING COUNT(DISTINCT pel.titulo) = 2;

-- 12. Persona/s (todos los datos) que ha/n dirigido más películas.

SELECT p.* FROM Persona p
JOIN Dirige d ON p.idP = d.idP
GROUP BY p.*
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*) FROM Dirige
    GROUP BY idP
);

    -- Alternativa con MAX y FROM:
    SELECT p.* FROM Persona p
    JOIN Dirige d ON p.idP = d.idP
    GROUP BY p.*
    HAVING COUNT(*) = (
        SELECT MAX(cant) FROM (
            SELECT COUNT(*) AS cant FROM Dirige
            GROUP BY idP
        ) tabla
    );

-- 13. Personas (todos sus datos) que han participado actuando y dirigiendo la misma película.

SELECT p.* FROM Persona p
JOIN (SELECT * FROM Actua INTERSECT SELECT * FROM Dirige) tabla ON p.idP = tabla.idP;

    -- Alternativa con JOIN:
    SELECT p.* FROM Persona p
    JOIN Actua a ON p.idP = a.idP
    JOIN Dirige d ON p.idP = d.idP AND a.idPel = d.idPel;

-- 14. Personas (nombre) junto a sus seguidores directos (nombre). 

SELECT p1.nombre, p2.nombre FROM Sigue s
JOIN Persona p1 ON s.idSeguido = p1.idP
JOIN Persona p2 ON s.idSeguidor = p2.idP;

-- 15. Actores (nombre) junto a sus seguidores directos (nombre). 

SELECT actor.nombre, seguidor.nombre FROM Sigue s
JOIN Persona actor ON s.idSeguido = actor.idP
JOIN Actua a ON actor.idP = a.idP
JOIN Persona seguidor ON s.idSeguidor = seguidor.idP;