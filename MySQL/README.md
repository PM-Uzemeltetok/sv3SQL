# SQL 

## Szükséges szoftverek, letöltések  
- Adatbázis kezelő applikáció
    * [MySQL Workbench](https://www.mysql.com/products/workbench/)
    * [DBeaver](https://dbeaver.io/)

## MySQL szerver  
- host: pl1sql.westeurope.cloudapp.azure.com
- user/password a discordon

## Példa adatbázis  
Adventureworks 

![image1](/.pics/awdiag1.png)
*diagram kép*

## Linkek 

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

---  

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


![image1](/.pics/isolationlevels.png)  

Forrás és részletes leírás:  
[Izolációs szintek adatbázisokban](http://javagyik.blogspot.com/2011/03/izolacios-szintek-adatbazisokban.html)  
[Tranzakciókezelés adatbázisokban](https://bmeviauac01.github.io/adatvezerelt/jegyzet/transactions/)   
[Understanding MySQL Transaction Isolation Levels by Example](https://medium.com/analytics-vidhya/understanding-mysql-transaction-isolation-levels-by-example-1d56fce66b3d)  
  
[SQL Murder Mystery](https://mystery.knightlab.com/)