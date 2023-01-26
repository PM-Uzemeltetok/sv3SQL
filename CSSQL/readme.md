# SQL  
---  
### Szükséges szoftverek telepítése, 
[Infratruktúra telepítés](./00-Infrastruktura.md)  

### MSSQL server docker container
mssql szerver a saját gépen
[MSSQL docker container](./mssqldocker.md)  

--- 

# Adatbázisok 

## Az adatbázis kezelés alapjai  
- Adat, információ, tudás - adatbázisok, tudásbázisok  
- Fejlődés kőtáblától felhőig  
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

### SQL nyelv - avagy amivel az egészet kezeljük
[SQL nyelv](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10708968-a-t-sql-nyelvek)  
[T-SQL nyelvi elemek](https://e-learning.training360.com/courses/take/1bevezetes-az-sql-server-hasznalataba/lessons/10709002-a-t-sql-fontosabb-nyelvi-elemei)

---   

### CRUD műveletek
* DDL (Data Definition Language)
    - CREATE, ALTER, DROP
* DML (Data Manipulation Language)
    - INSERT, UPDATE, DELETE
* DQL (Data Query Language)
    - SELECT

---  

#### Tranzakciók
[Tranzakció kezelés](./03-transactions.md)  

---  

### Data Definition Language
[Adatbázis kezelés alapjai](./01-Adatbazis.md)  
[Adatbázis kezelés feladatok](./exercises/01-Adatbazis-feladatok.md)       

### Data Query Language
1. [Select,Where,Order BY,részhalmazok](./02-dql1-select-where.md)  
    [Select,Where feladatok](./exercises/02-dql1-select-where-feladatok.md)  
2. [Függvények, adatkonverziók](./02-dql2-functions.md)  
    [Függvények, adatkonverziók feladatok](./exercises/02-dql2-functions-feladatok.md)  
3. [Csoportosítás](./02-dql3-groupby.md)  
    [Csoportosítás feladatok](./exercises/02-dql3-groupby-feladatok_3.md)  
4. [Táblakapcsolatok](./02-dql4-join.md)  
    [Táblakapcsolatok feladatok](./exercises/02-dql4-join-feladatok.md)  

### Data Manipulation Language
[Insert, Update, Delete](./04-dml1-insert-update-delete.md)  

---  

# Docker
[Containerization repository](https://github.com/Progmaster-Bootcamp-2022-CSharp/Containerization)  