CREATE TABLE IF NOT EXISTS Performer (
		id_performer SERIAL PRIMARY KEY, 
		name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Genres (
		id_genres SERIAL PRIMARY KEY, 
		name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Album (
		id_album SERIAL PRIMARY KEY, 
		name VARCHAR(255) NOT null,
		year_of_release date not null check (year_of_release::date > '1999-12-31')
);

CREATE TABLE IF NOT EXISTS Track (
	  id_track SERIAL PRIMARY KEY, 
	  name VARCHAR(255) NOT null,
	  length INT  not null check (length > 100),
	  id_album INT NOT null,
	  FOREIGN KEY(id_album)	REFERENCES album(id_album)	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Collection (
	  id_collection SERIAL PRIMARY KEY, 
	  name VARCHAR(255) NOT null,
	  year_of_release date not null check (year_of_release::date > '1999-12-31')
) ;

CREATE TABLE IF NOT EXISTS S_Perfomer_Genres (
		id_perfomer_genres SERIAL PRIMARY KEY, 
		id_performer INT NOT null,
		id_genres INT NOT null,
	  
		FOREIGN KEY(id_performer)	REFERENCES performer(id_performer)	ON DELETE CASCADE,
		FOREIGN KEY(id_genres)	REFERENCES Genres(id_genres)	ON DELETE CASCADE
) ;

CREATE TABLE IF NOT EXISTS S_Performer_Album (
		id_Perfomer_Album SERIAL PRIMARY KEY, 
		id_performer INT NOT null,
		id_album INT NOT null,
	  
		FOREIGN KEY(id_performer)	REFERENCES performer(id_performer)	ON DELETE CASCADE,
		FOREIGN KEY(id_album)	REFERENCES Album(id_album)	ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS S_Collection_Track (
	  	id_collection_track SERIAL PRIMARY KEY, 
	  	id_collection INT NOT null,
	  	id_track INT NOT null,
	  	
		FOREIGN KEY(id_collection)	REFERENCES Collection(id_collection)	ON DELETE CASCADE,
		FOREIGN KEY(id_track)	REFERENCES Track(id_track)	ON DELETE CASCADE
);