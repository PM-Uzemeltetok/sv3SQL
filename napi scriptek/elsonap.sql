-- Adatbázis létrehozás
create database HAFilm;
-- Melyik adatbázison 'ellen' végzem a tranzakciókat
use HAFilm;

-- Comment
/*
Hosszabb komment
*/

CREATE TABLE NonNormalMovie (
	FilmTitle nvarchar(50),
	Actor nvarchar(200),
	Genre nvarchar(200)
);

INSERT INTO NonNormalMovie VALUES
('Remény rabjai','Tim Robbins, Morgan Freeman','Dráma'),
('Nagy ugrás','Tim Robbins, Paul Newman','Dráma, Vigjáték'),
('A nagy balhé','Paul Newman, Robert Redford','Dráma, Vígjáték, Krimi');

Select * from NonNormalMovie;

-- --------------------------------------------------------------------------------
create table Film (
	FilmID int,
	Title nvarchar(100)
);
INSERT INTO Film (FilmID, Title)
	VALUES (1, 'Remény rabjai');

INSERT INTO Film (FilmID, Title)
	VALUES 	(2, 'Nagy ugrás'), (3, 'A nagy balhé');    
    
-- --------------------------------------------------------------------------------
-- Elsődleges kulcs használa, megszorítás megsértése azonos kulcs és null érték esetén
create table Actor (
	ActorID int primary key,
    Name nvarchar(100) not null
);

-- drop table Actor;
insert into Actor (ActorID, Name) 	
values  (1, 'Tim Robbins'), (2, 'Paul Newman');

insert into Actor (ActorID, Name) 	
values  (4, null);

-- --------------------------------------------------------------------------------
-- Auto increment elsődleges kulcs

create table Studio (
	StudioID int primary key auto_increment,
    StudioName nvarchar(100)
);    

insert into Studio (StudioName) values ('Warner Bros'),('MGM');
insert into Studio (StudioName) values ('MGM');
delete from Studio where StudioID = 2;

/*
-- 1:N kapcsolat
-- Alakítsunk ki egy 1:N kapcsolatot úgy, hogy 1 studióhoz több film tartozik de 1 filmhez csak 1 Studio.
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| StudioID   | int          | NO   | PRI | NULL    | auto_increment |			1 (Primary key - Elsődleges kulcs)
| StudioName | varchar(100) | YES  |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+

+--------+--------------+------+-----+---------+-------+
| Field  | Type         | Null | Key | Default | Extra |
+--------+--------------+------+-----+---------+-------+
| FilmID | int          | YES  |     | NULL    |       |						N  (Foreign key - Idegen kulcs)
| Title  | varchar(100) | YES  |     | NULL    |       |
+--------+--------------+------+-----+---------+-------+
*/

alter table Film
	add column StudioID int;
    
insert into Film (StudioID)    
	values (1),(1),(3);   -- hülyeséget csináltam, nem insert kell

-- Safe mode kikapcsolás (Edit->Preferences, Workbench újraindít)
    
delete from Film where FilmID is null;  -- DELETE/UPDATE NINCS feltétel nélkül, 
										-- különben az egész táblát írja

update Film set StudioID = 1;
update Film set StudioID = 3 where FilmID = 3;

select Film.*, S.StudioName  from Film
join Studio as S on Film.StudioID = S.StudioID;

alter table Film 
	add constraint foreign key (StudioID) references Studio (StudioID);
    
insert into Film (FilmID, Title, StudioID )
	values (4, 'Leszámolás kis Tokyoban', 3);  
-- --------------------------------------------------------------------------------

/*
ON UPDATE RESTRICT : the default : if you try to update a Studio_id in table Studio the engine will reject the operation if one Film at least links on this Studio.
ON UPDATE NO ACTION : same as RESTRICT.
ON UPDATE CASCADE : the best one usually : if you update a Studio_id in a row of table Studio the engine will update it accordingly on all Film rows referencing this Studio (but no triggers activated on Film table, warning). The engine will track the changes for you, it's good.
ON UPDATE SET NULL : if you update a Studio_id in a row of table Studio the engine will set related Films Studio_id to NULL (should be available in Film Studio_id field). I cannot see any interesting thing to do with that on an update, but I may be wrong.
And now on the ON DELETE side:

ON DELETE RESTRICT : the default : if you try to delete a Studio_id Id in table Studio the engine will reject the operation if one Film at least links on this Studio, can save your life.
ON DELETE NO ACTION : same as RESTRICT
ON DELETE CASCADE : dangerous : if you delete a Studio row in table Studio the engine will delete as well the related Films. This is dangerous but can be used to make automatic cleanups on secondary tables (so it can be something you want, but quite certainly not for a Studio<->Film example)
ON DELETE SET NULL : handful : if you delete a Studio row the related Films will automatically have the relationship to NULL. If Null is your value for Films with no Studio this can be a good behavior, for example maybe you need to keep the Films in your application, as authors of some content, but removing the Studio is not a problem for you.
usually my default is: ON DELETE RESTRICT ON UPDATE CASCADE. with some ON DELETE CASCADE for track tables (logs--not all logs--, things like that) and ON DELETE SET NULL when the master table is a 'simple attribute' for the table containing the foreign key, like a JOB table for the Film table.

Edit

It's been a long time since I wrote that. Now I think I should add one important warning. MySQL has one big documented limitation with cascades. Cascades are not firing triggers. So if you were over confident enough in that engine to use triggers you should avoid cascades constraints.
*/

-- --------------------------------------------------------------------------------

/*
-- N:M kapcsolat (Many - Many)
-- Egy filmben több szinész játszhat és egy szinész több filmeb is játszik
*/

create table FilmActor (
	-- FilmActor int primary key auto_increment 
    FilmID int,
    ActorID int    
    -- FilmDate date
    -- Salary bigint
    -- Ha nincs plusz adat nem szükséges elsődleges kulcs
);   
INSERT INTO FilmActor (FilmID, ActorID) VALUES (1,1),(1,2),(2,1),(2,3),(3,3),(3,4);

-- Idegen kulcsok létrehozása
ALTER TABLE FilmActor ADD CONSTRAINT FK_Actor_FilmActor FOREIGN KEY (ActorID) REFERENCES Actor (ActorID);
ALTER TABLE FilmActor ADD CONSTRAINT FK_Film_FilmActor FOREIGN KEY (FilmID) REFERENCES Film (FilmID);

-- Mindkettő megsérti a megszorításokat.
-- Feloldom
insert into Actor (ActorID, Name) values (4, 'Dolph Lundgren'); -- nincs ID=4 szinész
ALTER TABLE Film ADD PRIMARY KEY (FilmID); -- Nincs primary key, adok hozzá

select F.*, A.Name from Film as F
join FilmActor as FA on F.FilmID = FA.FilmID
join Actor as A on FA.ActorID = A.ActorID;
-- --------------------------------------------------------------------------------

-- összetett kulcs (egyedi érték több oszlop alapján)
truncate table FilmActor;
alter table FilmActor add constraint primary key (FilmID, ActorID);


-- --------------------------------------------------------------------------------
-- Műfajok 

create table Genre (
	GenreID int auto_increment,
    Genre nvarchar(40),
    constraint PK_Genre primary key (GenreID)
);

create table FilmGenre (
	FilmID int,
    GenreID int
);

ALTER TABLE FilmGenre ADD CONSTRAINT FK_Genre_FilmGenre FOREIGN KEY (GenreID) REFERENCES Genre (GenreID);
ALTER TABLE FilmGenre ADD CONSTRAINT FK_Film_FilmGenre FOREIGN KEY (FilmID) REFERENCES Film (FilmID);

INSERT INTO FilmGenre VALUES (1,1),(2,1),(2,2),(3,1),(3,2),(3,3);
INSERT INTO Genre (Genre) VALUES ('Dráma'),('Vígjáték'),('Krimi');


select F.*, G.Genre from Film as F
join FilmGenre as FG on F.FilmID = FG.FilmID
join Genre as G on FG.GenreID = G.GenreID;


select F.*, G.Genre, A.Name from Film as F
join FilmGenre as FG on F.FilmID = FG.FilmID
join Genre as G on FG.GenreID = G.GenreID
join FilmActor as FA on F.FilmID = FA.FilmID
join Actor as A on FA.ActorID = A.ActorID;


-- --------------------------------------------------------------------------------
-- segédek
select * from Film;
select * from Actor;
Select * from Studio;
select * from FilmActor;




-- Nem kötelező gyakorló feladat:
/*
Adatbázis tervezés
Adott az alábbi tábla (NonNormalCoctail).
Bontsd külön táblákra az adatokat.
Minden táblán legyen elsõdleges kulcs (Primary key), kivéve az esetleges kapcsolótáblákon.

A Type és a Glass csak egyedi lehet.
A megoldásban nincs adat esetleg töltsd fel adattal :)
Készíts egy reverse engeneering rajzot a kész táblákról
*/

-- írd ide a saját adatbázisod nevét!
CREATE DATABASE ...... ;
USE ..... ;

CREATE TABLE NonNormalCoctail (
	Name nvarchar(50),
	Type nvarchar(30), -- 1:N 
	Glass nvarchar(20), -- 1:N
	Ingredients nvarchar(100) -- N:M - kapcsolótábla
);

INSERT INTO NonNormalCoctail VALUES
('Limonádé','Alkohol mentes','Vizes','Citrom, Cukor, Szóda'),
('Vodka-szóda','Longdrink','Vizes','Vodka, Szóda, Citrom'),
('Cuba Libre','Longdrink','Vizes','Cola, Rum, Citrom'),
('Tequila','Shot','Feles','Tequila, Citrom, Só');

Select * from NonNormalCoctail;

-- ----------------------
-- másik feladat

INSERT INTO NonNormal VALUES
('Ázsia','Kína','Peking','Busz, Metro, Bicikli'),
('Európa','Magyarország','Budapest','Busz, Metro, Villamos'),
('Európa','Németország','Berlin','Busz, Villamos, Bicikli'),
('Amerika','Kolumbia','Bogotá','Busz, Bicikli');

Select * from NonNormal;
/* kapcsolódási típusok
1:1 Orszag:Fovaros - 
1:N Kontinens : Orszag
N:1 
N:M Fovaros : Kozlekedes
*/