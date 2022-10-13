# Első adatbázisom 

## SQL nyelv - avagy amivel az egészet kezeljük

### CRUD műveletek
* DDL (Data Definition Language)
    - CREATE, ALTER, DROP
* DML (Data Manipulation Language)
    - INSERT, UPDATE, DELETE
* DQL (Data Query Language)
    - SELECT, SHOW

## Relációs adatbázis elemei    
* Adatbázis (DB)  
* Táblák  
* Indexek  
* Nézetek (View)  
* Tárolt eljárások (Strored Procedure)  

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

### NULL

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

