# T-SQL Hiba-, Tranzakció kezelés, ACID elvek, Izolációs szintek

## Videólista

1. [Hibakezelés](https://e-learning.training360.com/courses/take/bevezetes-az-sql-server-hasznalataba-adatok-modositasa/lessons/18972684-hibakezeles)
2. [Tranzakciókezelés](https://e-learning.training360.com/courses/take/bevezetes-az-sql-server-hasznalataba-adatok-modositasa/lessons/18968850-a-tranzakciokezeles-alapjai)
3. [Szelekció, iteráció](https://e-learning.training360.com/courses/take/bevezetes-az-sql-server-hasznalataba-adatok-modositasa/lessons/18971282-szelekcio-es-iteracio)

## Tranzakció kezelés

* Minden SQL utasítás 1 tranzakció
* Autocommit
* Több SQL utasítás 1 tranzakcóként BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN
* Insert, Update, Delete eleve nyit tranzakciót
* Aktuális tranzakció állapota (0,1,-1)

## ACID elvek - minden tranzakcióra igaz, erről az RDBMS gondoskodik

### Atomicitás
Az atomicitás megköveteli, hogy több műveletet atomi (oszthatatlan) műveletként lehessen végrehajtani, azaz vagy az összes művelet sikeresen végrehajtódik, vagy egyik sem.  

### Konzisztencia
A konzisztencia biztosítja, hogy az adatok a tranzakció előtti érvényes állapotból ismét egy érvényes állapotba kerüljenek. Minden erre vonatkozó szabálynak (hivatkozási integritás, adatbázis triggerek stb.) érvényesülnie kell.  

### Izoláció
A tranzakciók izolációja azt biztosítja, hogy az egy időben zajló tranzakciók olyan állapothoz vezetnek, mint amilyet sorban végrehajtott tranzakciók érnének el. Egy végrehajtás alatt álló tranzakció hatásai nem láthatóak a többi tranzakcióból.  

### Tartósság
A végrehajtott tranzakciók változtatásait egy tartós adattárolón kell tárolni, hogy a szoftver vagy a hardver meghibásodása, áramszünet, vagy egyéb hiba esetén is megmaradjon.  

## Izolációs problémák

* Dirty Read (piszkos olvasás) 
* Non repetable read (Nem megismételhető olvasás)
* Lost update (Elveszett módosítás)
* Phantom read (Fantom rekordok)

## Izolációs szintek

**Read uncommitted:** nem nyújt megoldást egyik problémára se.  
**Read committed:** nincs piszkos olvasás.  
**Repeatable read:** nincs piszkos olvasás, se nem megismételhető olvasás.  
**Serializable:** egyik probléma sem fordulhat elő. Ez a legmagasabb izolációs szint. 

### Ellenőrző kérdések
* Milyen konkurens adathozzáférési problémákat ismersz?
* Milyen izolációs szintek vannak? Milyen problémákra adnak megoldást?
* Mik a tranzakciók alaptulajdonságai?

Forrás és részletes leírás:  
[Izolációs szintek adatbázisokban](http://javagyik.blogspot.com/2011/03/izolacios-szintek-adatbazisokban.html)  
[Tranzakciókezelés adatbázisokban](https://bmeviauac01.github.io/adatvezerelt/jegyzet/transactions/)  
(A T360 videóanyaga mélysége a mérvadó tudás)  


# TSQL megvalósítás

## Hibakezelés

* Hagyományos: **@@ERROR**
* Hiba generálása: **THROW**
* Struktúrált hibakezelés: **BEGIN TRY ... END TRY BEGIN CATCH ... END CATCH**
* Struktúrált hibakezelés tranzakció kezeléssel: **BEGIN TRY ... BEGIN TRAN... COMMIT TRAN END TRY BEGIN CATCH ... ROLLBACK END CATCH**

```sql
/**********************************************************************
	BEGIN TRANSACTION ... ROLLBACK / COMMIT
**********************************************************************/
BEGIN TRANSACTION
    -- SQL utasítások
COMMIT TRAN 
-- vagy
ROLLBACK TRAN

-- Tranzakció állapota (0,1,-1)
SELECT XACT_STATE()
SET XACT_ABORT ON | OFF -- Ha baj van automatikusan rollbackel
```  

```sql
/**********************************************************************
	Lock ellenőrzése
**********************************************************************/
SELECT
    OBJECT_NAME(P.object_id) AS TableName,
    Resource_type, request_status,  request_session_id
FROM
    sys.dm_tran_locks dtl
    join sys.partitions P
ON dtl.resource_associated_entity_id = p.hobt_id
```

### Hibakezelés és tranzakció kezelés üres példa

```sql
/**********************************************************************
	TRY ... CATCH használata tranzakciókezelés nélkül
**********************************************************************/
	DECLARE @Oszto int = 0, @Osztando int = 20
	BEGIN TRY
		SELECT 'Ez még megjelenik'
		SELECT 'Itt nincs értelme meghívni, mert üreset ad vissza: ', ERROR_MESSAGE()
		SELECT @Osztando / @Oszto
		SELECT 'Ez már nem jelenik meg'
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_PROCEDURE(), 
			   ERROR_SEVERITY(), ERROR_STATE()   
	END CATCH
	SELECT 'Itt sincs értelme meghívni, mert üreset ad vissza: ', ERROR_MESSAGE()
	GO

/**********************************************************************
	TRY ... CATCH használata tranzakciókezeléssel
**********************************************************************/
	
	BEGIN TRAN	
	BEGIN TRY
		 -- SQL utasítás sorozat
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		-- INSERT db.ErrorLog (ErrorMsg, ErrorNumber, ErrorLine, ErrorProc, ErrorSeverity, ErrorState)
		SELECT ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_PROCEDURE(), 
			   ERROR_SEVERITY(), ERROR_STATE()
	END CATCH

/**********************************************************************
	Hibakezelés és tranzakciókezelés együtt
**********************************************************************/

	BEGIN TRY
		BEGIN TRAN
			-- SQL utasítás sorozat
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER(), ERROR_MESSAGE()
		IF XACT_STATE() <> 0 ROLLBACK TRAN 
	END CATCH

```


## Órai példa  
``` sql
-- Demo adatbázis létrehozása
CREATE DATABASE StoredProcDemo
GO
-- DROP DATABASE StoredProcDemo
USE StoredProcDemo
GO
-- ------------------------------------------------------------------------------
/* Nem normalizált tábla - a Stored Procedure demohoz nem kell.
CREATE TABLE NonNormalMovie (
	FilmTitle nvarchar(50),
	Actor nvarchar(200),
	Genre nvarchar(200)
)
INSERT INTO NonNormalMovie VALUES
('Remény rabjai','Tim Robbins, Morgan Freeman','Dráma'),
('Nagy ugrás','Tim Robbins, Paul Newman','Dráma, Vigjáték'),
('A nagy balhé','Paul Newman, Robert Redford','Dráma, Vígjáték, Krimi')

SELECT * FROM NonNormalMovie
*/
-- 
-- Demotáblák létrehozása
-- 
CREATE TABLE Film (FilmID INT IDENTITY(1,1), Title NVARCHAR(50) NOT NULL,CONSTRAINT PK_FilmID PRIMARY KEY (FilmID))
INSERT INTO Film (Title) VALUES ('Remény rabjai'),('Nagy ugrás'),('A nagy balhé')
CREATE TABLE Actor (ActorID INT IDENTITY(1,1), Name NVARCHAR(50) NOT NULL, CONSTRAINT PK_ActorID PRIMARY KEY (ActorID))
INSERT INTO Actor (Name) VALUES ('Tim Robbins'),('Morgan Freeman'),('Paul Newman'),('Robert Redford')
CREATE TABLE Genre (GenreID INT IDENTITY(1,1), 	Genre NVARCHAR(20) NOT NULL UNIQUE, CONSTRAINT PK_GenreID PRIMARY KEY (GenreID))
INSERT INTO Genre (Genre) VALUES ('Dráma'),('Vígjáték'),('Krimi')
CREATE TABLE FilmGenre (FilmID INT, GenreID INT)
INSERT INTO FilmGenre VALUES (1,1),(2,1),(2,2),(3,1),(3,2),(3,3)
CREATE TABLE FilmActor (FilmID INT,	ActorID INT)
INSERT INTO FilmActor VALUES (1,1),(1,2),(2,1),(2,3),(3,3),(3,4)
ALTER TABLE FilmGenre ADD CONSTRAINT FK_Genre_FilmGenre FOREIGN KEY (GenreID) REFERENCES Genre (GenreID), CONSTRAINT FK_Film_FilmGenre FOREIGN KEY (FilmID) REFERENCES Film (FilmID)
ALTER TABLE FilmActor ADD CONSTRAINT FK_Actor_FilmActor FOREIGN KEY (ActorID) REFERENCES Actor (ActorID), CONSTRAINT FK_Film_FilmActor FOREIGN KEY (FilmID) REFERENCES Film (FilmID)
GO
-- 
--
ALTER VIEW AllFilmData AS
SELECT F.Title, A.Name, G.Genre FROM Film F
INNER JOIN FilmActor FA ON F.FilmID = FA.FilmID
INNER JOIN Actor A ON A.ActorID = FA.ActorID
INNER JOIN FilmGenre FG ON F.FilmID = FG.FilmID
INNER JOIN Genre G ON G.GenreID = FG.GenreID
GO

SELECT * FROM AllFilmData
--DROP DATABASE StoredProcDemo

-- Error log tábla a hibakezeléshez
--
CREATE TABLE [dbo].[ErrorLog](
	[ErrorLogID] [int] IDENTITY(1,1) NOT NULL, [ErrorTime] [datetime], [UserName] [sysname], [ErrorNumber] [int], [ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL, [ErrorProcedure] [nvarchar](126) NULL,	[ErrorLine] [int] NULL,	[ErrorMessage] [nvarchar](4000)
 CONSTRAINT [PK_ErrorLog_ErrorLogID] PRIMARY KEY CLUSTERED 
 )
GO

-- TRAN/TRY Példa

GO
CREATE OR ALTER PROCEDURE Ujfilm(
	@filmcim nvarchar (50),
	@mufajid int,
	@kimenoadat INT OUTPUT
)
AS
-- SET NOCOUNT ON
BEGIN TRANSACTION	
	BEGIN TRY 
		INSERT INTO Film (Title) /* OUTPUT inserted.FilmID */ VALUES (@filmcim)
		SET @kimenoadat = @@IDENTITY
		-- SELECT @@IDENTITY
		INSERT INTO FilmGenre (FilmID, GenreID) 
				VALUES (@@IDENTITY, @mufajid)
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
			INSERT INTO Errorlog 
				VALUES (Getdate(),SUSER_NAME(),ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),
						ERROR_PROCEDURE(),ERROR_LINE(),ERROR_MESSAGE())
	END CATCH
	
	
-- jó adattal
DECLARE @kapottadat int
EXEC Ujfilm 'Bolygó neve halál', 6, @kapottadat OUTPUT
Select 'Visszakapott adat', @kapottadat

-- hibás adattal
DECLARE @kapottadat int
EXEC Ujfilm 'Bolygó neve halál', 14, @kapottadat OUTPUT
Select 'Visszakapott adat', @kapottadat

-- összekapcsolt lekérdezés
Select film.Title, Genre.Genre from film 
inner join FilmGenre on film.FilmID = FilmGenre.FilmID
inner join Genre on Genre.GenreID = FilmGenre.GenreID
```

[How to identify slow running queries in SQL Server](https://www.sqlshack.com/how-to-identify-slow-running-queries-in-sql-server/)