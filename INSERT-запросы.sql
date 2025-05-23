INSERT INTO Performer (name) 
VALUES ('Баста'), ('Ария'), ('Король и Шут'), ('Ленинград'), ('Бах');

INSERT INTO Genres (name) 
VALUES ('Рок'), ('Рэп'), ('Попса'), ('Класика');

INSERT INTO Album (name,year_of_release) 
VALUES ('Альбом 1','2021-01-01'),('Альбом 2','2022-01-01'),('Альбом 3','2001-01-01'),('Альбом 4','2004-10-01'),('Альбом 5','2005-10-01'),('Альбом 6','2000-10-01'),('Альбом 7','2020-10-01');

INSERT INTO Track (name,length,id_album) 
VALUES ('Свобода',250,1),('Свобода-2',300,2),('Лесник',160,3),('Колизей',300,4),('WWW',200,5),
('Что то там ...',700,6),('my hard',550,6),('Мой мир',280,5),
('my own',280,5),('own my',280,5),('my',280,5),('oh my god',280,5),
('myself',280,5),('by myself',280,5),('bemy self',280,5),('myself by',280,5),
('by myself by',280,5),('beemy',280,5),('premyne',280,5);

INSERT INTO collection (name,year_of_release) 
VALUES ('Сборник-1','2017-01-01'),('Сборник-2','2018-01-01'),('Сборник-3','2019-01-01'),('Сборник-4','2020-03-01'),('Сборник-5','2021-03-01'),('Сборник-6','2022-03-01'),('Сборник-7','2023-03-01');

INSERT INTO S_Perfomer_Genres (id_performer,id_genres) 
VALUES (1,2), (2,1), (3,1), (4,1), (5,4),(5,3);

INSERT INTO S_Performer_Album (id_performer,id_album)
VALUES (1,1), (1,2), (3,3), (2,4), (4,5),(5,6),(2,7);

INSERT INTO S_Collection_Track (id_collection, id_track) 
VALUES (1,1), (1,2), (1,3), (2,4), (2,5),(2,6),(3,2),(3,5),(3,1),(4,6),(4,4);