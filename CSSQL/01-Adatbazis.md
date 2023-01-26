# Relációs adatbázis elemei    
[A relációs adatbázis](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10709069-a-relacios-adatbazis-alapelemei)  
[Normalizálás](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10708994-normalizalas)  
[Adattípusok](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10844155-adattipusok-attekintese)

## Elemek, komponensek
* **Tábla** (Table)
* Nézet (View)
* Tárolt eljárás (Stored Procedure)
* Függvények (Function)
* Index (Index)
* Triggerek, System táblák, Ideiglenes táblák, Statisztikák, stb.

# Tábla
Sor(row) - Rekord(record), Oszlop(column), Mező(field)

### Normálformák
Adattárolási elvek
* 1NF atomi részekre bontás
* 2NF összetett kulcsok feloldása
* 3NF tranzitív függőségek feloldása

## Relációk táblák között
* 1:1 - One to one 
* 1:N, N:1 - One to Many
* N:M - Many to Many

### Kulcsok/ Keys
Egyedi sorok meghatározása, egyediség megkövetelése at adattárolási elvek (normálformák) alapján
* Elsődleges kulcsok - egyedi érték (PRIMARY KEY)  
* Természetes kulcsok  
* Többes kulcsok - feloldjuk 2NF-nál  
* Helyettesítő kulcsok (surrogate key)  
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

### NULL

## Megszorítások/Constraints
* NOT NULL - Ensures that a column cannot have a NULL value
* UNIQUE - Ensures that all values in a column are different
* PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
* FOREIGN KEY - Prevents actions that would destroy links between tables
* CHECK - Ensures that the values in a column satisfies a specific condition
* DEFAULT- Sets a default value for a column if no value is specified