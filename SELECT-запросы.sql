--	ЗАДАНИЕ 2
-- 1) Название и продолжительность самого длительного трека.
SELECT name, length  FROM Track
WHERE length = (SELECT MAX(length) FROM Track);
-- 2) Название треков, продолжительность которых не менее 3,5 минут.
SELECT name FROM Track
WHERE length >= (3.5*60);
-- 3) Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name FROM Collection c
WHERE EXTRACT(YEAR FROM year_of_release) BETWEEN 2018 AND 2022;
-- 4) Исполнители, чьё имя состоит из одного слова.
SELECT name FROM Performer p 
WHERE name NOT LIKE ('% %');
-- 5) Название треков, которые содержат слово «мой» или «my».
SELECT name FROM Track t
WHERE LOWER(name) LIKE ('%мой%') OR name LIKE ('%my%');


--	ЗАДАНИЕ 3
-- 1) Количество исполнителей в каждом жанре.
SELECT g.name AS "Жанр", COUNT(s.id_genres) AS "Кол-во исполнителей" 
FROM S_Perfomer_genres s
LEFT JOIN Genres g ON s.id_genres = g.id_genres
GROUP BY g.name
ORDER BY COUNT(s.id_genres) DESC;
-- 2) Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(s.id_track) AS "Кол-во трэков"
FROM S_Collection_track s
WHERE s.id_collection IN (SELECT id_collection FROM Collection c
							WHERE EXTRACT(YEAR FROM year_of_release) BETWEEN 2019 AND 2020);
-- 3) Средняя продолжительность треков по каждому альбому.
SELECT 
	COALESCE(c.name, 'НЕ в сборнике') AS "Название сборника",
	COALESCE(ROUND(AVG(t.length),0), 0) AS "Средняя длина трека"
FROM S_Collection_track s
FULL JOIN Collection c ON s.id_collection = c.id_collection
FULL JOIN Track t ON s.id_track = t.id_track
GROUP BY c.name
ORDER BY c.name;
-- 4) Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT p.name AS "Performer" FROM S_Performer_album s
FULL JOIN Performer p ON s.id_performer = p.id_performer
FULL JOIN album a ON a.id_album = s.id_album
WHERE EXTRACT(YEAR FROM year_of_release) != 2020
GROUP BY p.name
ORDER BY p.name;
-- 5) Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT a.name FROM S_Performer_album s
FULL JOIN Performer p ON s.id_performer = p.id_performer
FULL JOIN album a ON a.id_album = s.id_album
WHERE p.name = 'Баста';


--ЗАДАНИЕ 4(необязательное)

-- 1) Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT a.name FROM S_Performer_album s
FULL JOIN Performer p ON s.id_performer = p.id_performer
FULL JOIN album a ON a.id_album = s.id_album
WHERE p.name IN (SELECT x FROM (SELECT p.name AS x,count(*) FROM S_Perfomer_genres s
								FULL JOIN Performer p ON s.id_performer = p.id_performer
								FULL JOIN genres g ON s.id_genres = g.id_genres
								GROUP BY p.name
								HAVING count(*)>1));
-- 2) Наименования треков, которые не входят в сборники.
SELECT t.name AS "Название трека" FROM S_Collection_track s
FULL JOIN Collection c ON s.id_collection = c.id_collection
FULL JOIN Track t ON s.id_track = t.id_track
WHERE c.name IS NULL;
-- 3) Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT p.name FROM S_Performer_album s
FULL JOIN Performer p ON s.id_performer = p.id_performer
FULL JOIN track t ON s.id_album = t.id_album
WHERE t.length IS NOT NULL 
	AND t.name IS NOT NULL
	AND p.name IS NOT NULL
	AND t.length IN(SELECT min(track.length) FROM track);

-- 4) Названия альбомов, содержащих наименьшее количество треков.
SELECT name FROM album
WHERE id_album IN(SELECT X FROM (SELECT id_album AS X, COUNT(id_album) AS y FROM track 
					GROUP BY id_album
					HAVING COUNT(id_album) = (SELECT min(Z) AS min_count FROM (SELECT id_album, count(id_album) AS Z FROM track GROUP BY id_album))))
ORDER BY name;