# SQL 1. nap - Telepítés, SSMS, Első adatbázis

## Videólista
1. [NA - 1. Microsoft SQL Server 2017 telepítése](https://e-learning.training360.com/courses/take/na-1-microsoft-sql-server-2017-telepitese/lessons/17741747-1-1-sql-server-telepitokeszlet-letoltese)  
2. [Az SQL Server bemutatása rész](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10709069-a-relacios-adatbazis-alapelemei)
3. [NA - 2. Microsoft SQL Server 2017 adatbázis létrehozása](https://e-learning.training360.com/courses/take/na-2-microsoft-sql-server-2017-adatbazis-letrehozasa/lessons/17741771-1-1-mi-az-az-adatbazis)

## Szükséges szoftverek, letöltések  
[SQL Server Developer (DEV) változat - csak az installert tölti le, utána a médiát is le kell](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)  
[Download SQL Server Management Studio (SSMS) - ingyenes utolsó verzió 18.10?](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)  
[AdventureWorks sample databases - OLTP AdventureWorks2019.bak](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)  
*Ez tartalmazza a visszatöltés lépéseit is*  
Az SQL szerver esetén a Download Media -t kell választani és ott ISO formátumot.

---  
# Telepítések  
  
## MSSQL szerver telepítés
- Filekezelés, Filegroupok
- Hozzáférési lehetőségek (Beépített Windows Account / SQL Server autentikáció)
- Alapértelmezett Collation (reginális beállítások)
- Első query ```SELECT @@version```

## SSMS 
[Az SQL Server Management Studio](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10708971-az-sql-server-management-studio)  
- Object explorer
- Solution explorer
- F7 object explorer - oszlopok, sorok száma, egyéb információk
- Reports / Tasks 
- Query ablak (Execution plan, statisztikák)
- [Tippek és trükkök](https://www.youtube.com/watch?v=AifgKqRFoZg)

---  

## Adventure Works 2019 adatbázis visszatöltése
[Restore lépései](https://e-learning.training360.com/courses/take/na-2-microsoft-sql-server-2017-adatbazis-letrehozasa/lessons/17741783-2-2-adatbazis-adatainak-feltoltese-mentesbol)

## Linkek 
[SQL Server technical documentation](https://docs.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver15)  
[Szerver kiadások és verziók](https://docs.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-version-15?view=sql-server-ver15)  

---  
# Az adatbázis kezelés alapjai  

- Adat, információ, tudás - adatbázisok, tudásbázisok
- A Database is a set of Data stored in a computer(usually in a Data Storage). In order to work with Databases, we use Database Management Systems(DBMS). Not every set of Data(stored in computers) is considered a Database.
- Adatbáisok típusai (a legelterjettebbek)
    * Hierarchikus
    * Relációs 
    * Object Oriented model(NoSQL)  
- Relációs adatbázisok típusai  
    * OLTP
    * DW  
- RDBMS rendszerek (relációs adatbázis kezelő rendszerek)
    * NAGY mennyiségű adat tárolása
    * Rendezett tárolási elvek
    * Tranzakció kezelés megvalósítása (Konkurens hozzáférés kezelés)
    * Effektív adattárolás
    * Hozzáférési jogosultságok kezelése
    * Karbantartási, üzemeltetési feladatok 

## SQL nyelv - avagy amivel az egészet kezeljük
[SQL nyelv](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10708968-a-t-sql-nyelvek)
[T-SQL nyelvi elemek](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10709002-a-t-sql-fontosabb-nyelvi-elemei)

### CRUD műveletek
* DDL (Data Definition Language)
    - CREATE, ALTER, DROP, SHOW
* DML (Data Manipulation Language)
    - SELECT, INSERT, UPDATE, DELETE

---  
# Első adatbázisom 

## Videólista  
[A relációs adatbázis](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10709069-a-relacios-adatbazis-alapelemei)  
[Normalizálás](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10708994-normalizalas)  
[Adattípusok](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10844155-adattipusok-attekintese)

## Relációs adatbázis elemei    

### Normálformák
* Alapfogalmak: kulcsok (primary, foreign, természetes kulcsok, összetett kulcsok, tulajdonságok, függőségek, redundancia)
* 1NF atomi részekre bontás
* 2NF összetett kulcsok feloldása
* 3NF tranzitív függőségek feloldása

## Relációk táblák között
* 1:1 - One to one 
* 1:N, N:1 - One to Many
* N:M - Many to Many

## Kulcsok/ Keys
* Elsődleges kulcsok - egyedi érték (PRIMARY KEY)
* Természetes kulcsok
* Többes kulcsok - feloldjuk 2NF-nál
* Idegen kulcsok (FOREIGN KEY)

## Adattípusok  
### Numerikus
* INT, BIGINT, SMALLINT - egész számok
* FLOAT - lebegőpontos
* DECIMAL(hossz, tizedes)  

### Szöveg
* CHAR(N) - fix hosszú, elfoglalja a tárhelyet
* NCHAR(N) - CHAR csak unicode, ékezetkezelés
* VARCHAR(N) - nem fix, 2x akkora tárolási hely, MAX érték
* NVARCHAR(N) - VARCHAR csak unicode, ékezetkezelés

### Dátum
* DATE
* TIME
* DATETIME

## Megszorítások/Constraints
* NOT NULL - Ensures that a column cannot have a NULL value
* UNIQUE - Ensures that all values in a column are different
* PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
* FOREIGN KEY - Prevents actions that would destroy links between tables
* CHECK - Ensures that the values in a column satisfies a specific condition
* DEFAULT- Sets a default value for a column if no value is specified

