# Feladat: SQL Lekérdezés II.
*Nehézség (3/10)* 

### Megoldáshoz szükésges  
* 4 táblás lekérdezés
* Aliasok használata
* LEFT JOIN, INNER JOIN
* COALESCE
* YEAR, MONTH, DAY függvény használata
* Számított mező

## Feladat:  
Készítsd el a képen látható táblák összekapcsolt lekérdezésést.

*kép SQLFeladatII.png*

A lekérdezésben:  
A **Person.Person** táblát a **BusinessEntityID - CustomerID** segítségével kösd a **Sales.SalesOrderHeader** táblához, úgy hogy azok a megrendelések is jelenjenek meg amikhez nincs adat a **Person.Person** táblában.  
A **Production.Product** táblát a **ProductID - ProuductID** segítségével kösd a **Sales.SalesOrderDetai** táblához, úgy hogy azok a megrendelések is jelenjenek meg amikhez nincs adat a **Production.Product** táblában.  
A **Sales.SalesOrderHeader** táblát a **Sales.SalesOrderDetai** táblával idegen kulcsával kösd össze.
A tábláknak adj alias nevet a lekérdezésben.  

A lekérdezés tartalmazza a

* A megrendelés számát **SalesOrderID**
* A vevő keresztnevét **Person.Person.Firstname**, 'N/A' értékkel ha NULL *Keresztnév* néven
* A vevő vezetéknevét **Person.Person.Lastname**, 'N/A' értékkel ha NULL *Vezetéknév* néven
* Az megrendelés dátumát 3 külön oszlopban (Év, hónap, nap) **OrderDate** *Év*, *Hónap*, *Nap* néven
* A termék nevét **Name** *Terméknév* néven
* A termég színét **Color** *Szin* néven
* A rendelt darabszámot **OrderQty** *Mennyiség* néven
* Az egységárat **UnitPrice** *Egységár* néven
* Számított mezőként a darabszam * egységár 45%-al csökkentett értékét *Profit* néven  

oszlopokat.  

Készíts a lekérdezésből egy **View-t** SalesOrderProfit néven


## Megoldás  
```sql
CREATE VIEW
AS
SELECT	SOH.SalesOrderID,
		COALESCE(PE.FirstName,'N/A') AS 'Keresztnév',
		COALESCE(PE.LastName,'N/A') AS 'Vezetéknév',
		YEAR(SOH.DueDate) AS 'Év',
		MONTH(SOH.DueDate) AS 'Hónap',
		DAY(SOH.DueDate) AS 'Nap',		
		PR.Name AS 'Terméknév', PR.Color AS 'Szin',
		SOD.OrderQty AS 'Mennyiség',
		SOD.UnitPrice AS 'Egységár',
		((SOD.UnitPrice * SOD.OrderQty) * 0.55) AS 'Profit'
FROM Sales.SalesOrderHeader SOH
INNER JOIN [Sales].[SalesOrderDetail] SOD ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN [Person].[Person] PE ON SOH.CustomerID = PE.BusinessEntityID
LEFT JOIN [Production].[Product] PR ON SOD.ProductID = PR.ProductID
```

## Pontozás  
*121317 sor*
- Megfelelő oszlopok leválogatva (10%)  
- Van számított mező, matematikailag helyes(20%)
- ```COLAESCE``` függvény helyes használata (10%)
- Jó táblák összekötése INNER JOIN-nal és LEFT JOIN-nal (30%)
- ``YEAR(), MOUNTH(), DAY()`` függvények használata (10%)
- Aliasok használata(10%)
- Viewként elkészítve (10%)


## További feladat lehetőségek/variációk:  
* WHERE feltétel kérése
* DATEDIFF() függvény használata
* ROUND(), FORMAT() függvény használat