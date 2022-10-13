# Feladat: SQL Lekérdezés I.
*Nehézség (4/10)* 

### Megoldáshoz szükésges  
* 2 táblás lekérdezés (INNER JOIN)
* Aggregáció használat (SUM())
* GROUP BY használat
* CONCAT függvény használat
* Dátum intervallum szűrés  

## Feladat:
Írj lekérdezést, ami visszaadja az AdventureWorks2019 adatbázis
**SalesOrderHeader** táblájának ügyfelenként összesített **(TotalDue)** rendeléseit 2012 2. negyedévétől és 2013 végéig.  

A lekérdezés tartalmazza a
* **Customer** nevét **'Firstnam Lastname'** formában *CustomerName* néven
* **TotalDue** összesített értékét *TotalOrder* néven    

oszlopokat.  
Kösd hozzá a **Person.Person** táblát a **BusinessEntityID - CustomerID** segítségével  
Rendezd rendelések szerint csökkenő sorrendbe  

## Megoldás  
```sql
SELECT CONCAT(P.Firstname,' ',P.Lastname) AS CustomerName, SUM(SOH.TotalDue) AS TotalOrder
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Person.Person P ON SOH.CustomerID = P.BusinessEntityID
WHERE OrderDate BETWEEN '2012-07-01' AND '2013-12-31'
GROUP BY CONCAT(P.Firstname,' ',P.Lastname)
ORDER BY 2 DESC
```

## Pontozás
- Megfelelő oszlopok leválogatva (10%)
- CONCAT függvény helyes használata (10%)
- Jó táblák összekötése INNER JOINNAL (20%)
- SUM és GROUP BY használata (30%)
- WHERE dátum feltétel helyes (20%)
- Megfelelő rendezés (10%)

## További feladat lehetőségek/variációk:  
* TotalOrder-t 2 tizedesig jelenítsd meg ```( FORMAT(1, 'N1'))```
* A legobb 10-et jelenítsd meg ```( TOP(10) )```
* Csak azokat a tételeket jelenítsd meg ahol a TotalOrder legalább 8000 ``` ( HAVING SUM(SOH.TotalDue) > 8000 )```