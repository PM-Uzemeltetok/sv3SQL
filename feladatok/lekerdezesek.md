# Feladatok

## 1. feladat:
### a.  
Írj lekérdezést, ami visszaadja az AdventureWorks adatbázis
SalesOrderHeader táblájának ügyfelenként összesített (TotalDue) rendeléseit
2012 2. negyedévétõl és 2013 végéig.  
A lekérdezés tartalmazza a  
- Customer nevét 'Firstnam Lastname' formában CustomerName néven  (Contact tábla - ContactID)
- TotalDue összesített értékét TotalOrder néven  
  
oszlopokat.  
Kösd hozzá a contact táblát a ContactID segítségével  
Rendezd rendelések szerint csökkenõ sorrendbe.  

## b.  
Egészíts ki a lekérdezést:  
- TotalOrder-t 2 tizedesig jelenítsd meg  
- A legjobb 10-et jelenítsd meg   
- Csak azokat a tételeket jelenítsd meg ahol a TotalOrder legalább 8000  

--- 

## 2. feladat:  
*beágyazott lekérdezzéssel*  
A lekérdezés Ügyfelenként csak a legynagyobb értékû rendelést adja vissza!   
Írj lekérdezést, ami visszaadja az AdventureWorks adatbázis  
SalesOrderHeader táblájának legnagyobb értékû (TotalDue) rendeléseit 2012 2. negyedévétõl és 2013 végéig. (2001-2013) 
A lekérdezés tartalmazza a	
- SalesOrderID  
- DueDate,
- Customer nevét 'Firstnam Lastname' formában CustomerName néven
- TotalDue
oszlopokat.
Kösd hozzá a contact táblát a contactid segítségével

---  

## 3. Feladat:  
Kérdezd le, hogy 1 vevő hányszor vásárolt, termékenként a vásárolt darabszámot összesítve.  
Készítsd el a **SalesOrderHeader** és **SalesOrderDetail** tábláinak összkapcsolt lekérdezését. *(SalesOrderID)* 
A vásárolt mennyiséget a **SalesOrderDetail.OrderQty** oszlop (4) tartalmazza  
A lekérdezés tartalmazza a  
- **CustomerID**  
- 'Vásárlások száma' néven   
- **ProductID**  
- 'Vásárolt mennyiség' néven  
oszlopokat.  
Rendezd a lekérdezést a vásárolt mennyiség szerint csökkenő sorrendbe.  

## 4. Feladat:
Írj lekérdezést, ami visszaadja az AdventureWorks adatbázis SalesOrderHeader táblájából az ügyfelek éves rendeléseinek összesített értékét 2011, 2012,2013 évre (DueDate) alapján.  
A lekérdezés tartalmazza a
- Customer nevét 'Firstnam Lastname' formában CustomerName néven  
- Az évet 'Ev' néven  
- Az éves forgalmat 'Forgalom' néven  
oszlopokat.
Kösd hozzá a contact táblát a contactid segítségével  
Az eredményt rendezze Forgalom szerint csökkenõ, név szerint növekvõ sorrendbe.  
Csak az elsõ 10 olyan eredményre vagyok kiváncsi ami kevesebb mint 4000.  