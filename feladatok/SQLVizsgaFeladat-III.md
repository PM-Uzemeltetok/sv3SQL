# Feladat: SQL Lekérdezés III.
*Nehézség (4/10)* 

### Megoldáshoz szükésges  
* 2 táblás lekérdezés (INNER JOIN)
* Alias használat  
* Aggregáció és megszámlálás használata (SUM(), COUNT())  
* GROUP BY használat  
* ORDER BY használat  


## Feladat:  

Kérdezd le, hogy 1 vevő hányszor vásárolt, termékenként a vásárolt darabszámot összesítve.  

Készítsd el a **SalesOrderHeader** és **SalesOrderDetail tábláinak összkapcsolt lekérdezését.  
A **Sales.SalesOrderHeader** táblát a **Sales.SalesOrderDetail** táblával idegen kulcsával kösd össze.  

A vásárolt mennyiséget a **SalesOrderDetail.OrderQty** oszlop tartalmazza
A lekérdezés tartalmazza a
* **CustomerID** 
* *'Vásárlások száma'*
* **ProductID**
* *'Vásárolt mennyiség'*  

oszlopokat.  
Rendezd a lekérdezést a vásárolt mennyiség szerint csökkenő sorrendbe


## Megoldás  
```sql
SELECT	SOH.CustomerID, COUNT(SOH.CustomerID) AS 'Vásárlások száma',
		SOD.ProductID, SUM(SOD.OrderQty) AS 'Vásárolt mennyiség'
FROM Sales.SalesOrderHeader SOH
INNER JOIN [Sales].[SalesOrderDetail] SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY SOH.CustomerID, SOD.ProductID
ORDER BY 4 DESC
```

## Pontozás
- Megfelelő oszlopok leválogatva és alias használata (10%)
- SUM és GROUP BY használata (30%) -helytelen oszlop esetén (10%)
- COUNT() GROUP BY használata (30%) -helytelen oszlop esetén (10%)
- Jó táblák összekötése INNER JOINNAL (10%)
- Megfelelő rendezés (10%)
- Helyes eredmény (10%)

## További feladat lehetőségek/variációk:  
* A legobb 10-et jelenítsd meg ```( TOP(10) )```
* Csak azokat a tételeket jelenítsd meg ahol a SUM(SOD.OrderQty) legalább 100 ``` ( HAVING SUM(SOD.OrderQty) > 100 )``` *(5/10)*
* WHERE feltétel