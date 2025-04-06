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
WHERE string_to_array(LOWER(name), ' ') && ARRAY['мой','my']; 


--	ЗАДАНИЕ 3

-- 1) Количество исполнителей в каждом жанре.
SELECT g.name AS "Жанр", COUNT(s.id_genres) AS "Кол-во исполнителей" 
FROM S_Perfomer_genres s
LEFT JOIN Genres g ON s.id_genres = g.id_genres
GROUP BY g.name
ORDER BY COUNT(s.id_genres) DESC;

-- 2) Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(t.id_track) FROM track t /* Количество айди треков из таблицы треков */
JOIN album ON album.id_album = t.id_track /* Делаем объединение от таблицы треков к альбомам */
WHERE EXTRACT(YEAR FROM album.year_of_release) BETWEEN 2019 AND 2020; /* Где год альбома находится в требуемом промежутке */

-- 3) Средняя продолжительность треков по каждому альбому.
SELECT a.name, COALESCE(ROUND(AVG(t.length),0), 0) AS "Средняя длина трека" 
FROM track t 
JOIN album a ON a.id_album = t.id_album
GROUP BY a.id_album
ORDER BY a.id_album;

-- 4) Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT p.name/* миожно использовать DISTINCT или группировка :) для удаления дублей из выборки */
FROM Performer p  
WHERE p.name NOT IN ( 
					    SELECT p.name /* Получаем имена исполнителей */
					    FROM Performer p 
					    JOIN S_Performer_album s ON s.id_performer = p.id_performer 
					    JOIN album a ON a.id_album = s.id_album 
					    WHERE EXTRACT(YEAR FROM year_of_release) = 2020 
)
GROUP BY p.name
ORDER BY p.name;

-- 5) Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT DISTINCT a.name /* Имена сборников */
FROM collection c /* Из таблицы сборников */
JOIN s_collection_track s1 ON s1.id_collection = c.id_collection/* Объединяем с промежуточной таблицей между сборниками и треками */
JOIN track t ON s1.id_track = t.id_track /* Объединяем с треками */
JOIN album a ON t.id_album = a.id_album /* Объединяем с альбомами */
JOIN s_performer_album s2 ON a.id_album = s2.id_album  /* Объединяем с промежуточной таблицей между альбомами и исполнителями */
JOIN performer p  ON s2.id_performer = p.id_performer /* Объединяем с исполнителями */
WHERE p.name = 'Ария'; /* Где имя исполнителя равно определенному шаблону имени */



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
SELECT t.name AS "Название трека" FROM track t /* Имена треков из таблицы треков */
LEFT JOIN s_collection_track s1 ON t.id_track = s1.id_track /* Делаем левый джойн с промежуточной таблицей между треками и сборниками */
WHERE s1.id_track is NULL; /* Где id трека из промежуточной таблицы является NULL */

-- 3) Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT p.name FROM S_Performer_album s
FULL JOIN Performer p ON s.id_performer = p.id_performer
FULL JOIN track t ON s.id_album = t.id_album
WHERE t.length IS NOT NULL 
	AND t.name IS NOT NULL
	AND p.name IS NOT NULL
	AND t.length IN(SELECT min(track.length) FROM track);

-- 4) Названия альбомов, содержащих наименьшее количество треков.
SELECT a.name /* Названия альбомов */
FROM album a
JOIN track t ON t.id_album = a.id_album /* Объединяем альбомы и треки */
GROUP BY a.id_album /* Группируем по айди альбомов */
HAVING COUNT(1) = ( /* Где количество треков равно вложенному запросу, в котором получаем наименьшее количество треков в одном альбоме */
    SELECT COUNT(t2.id_track) FROM track t2 /* Получаем поличество айди треков из таблицы треков*/
    GROUP BY t2.id_album /* Группируем по айди альбомов */
    ORDER BY 1 /* Сортируем по первому столбцу */
    LIMIT 1 /* Получаем первую запись */
)
ORDER BY name;