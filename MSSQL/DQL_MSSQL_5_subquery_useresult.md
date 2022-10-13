# Subquery - beágyazott / al / segéd lekérdezés

- A subquery egy másik lekérdezésbe (avagy külső lekérdezésbe) beágyazott lekérdezés.
- A subquery-ket használhatjuk SELECT, INSERT, UPDATE vagy DELETE műveleteknél egyaránt.  
- Egy subquery beágyazható egy másik subquerybe.  
- A subqueryt belső (inner) lekérdezésnek, míg az subqueryt tartalmazó lekérdezést külső (outer) lekérdezésnek nevezzük.   
- Egy allekérdezés bárhol használható, ahol ezt a kifejezést használják, és zárójelben kell zárni.  
- Egy allekérdezés független lekérdezésként is működik. Ez azt jelenti, hogy az allekérdezést önálló lekérdezésként is végrehajtható kivéve a korrelált lekérdezésnél. 
- A korrelált részlekérdezés a külső lekérdezéstől függ

Példa:  
```sql
select * from table1
where searchfield in (select searchfield from table2 where someexpression );
```
A lekérdezés végrehajtásakor az RDMS először a részlekérdezést értékeli ki, és a segédlekérdezés eredményét használja fel a külső lekérdezéshez.

## SELECT
A subquery csak 1 értéket adhat vissza. 
```sql
-- beágyazott rész
select avg(TotalDue) from Sales.salesorderheader
--
select 	soh.OrderDate, sum(soh.TotalDue), 
        (select avg(TotalDue) from sales.SalesOrderHeader) as atlag -- 1 érték! nem több sor 
from sales.salesorderheader soh
group by soh.OrderDate;
```  

## WHERE
Használhat összehasonlító operátorokat, például =, >, < az allekérdezés által visszaadott egyetlen érték összehasonlításához a WHERE záradékban található kifejezéssel.
```sql
-- Melyek azok a termékek, amelyek a termékek átlagáránál 20%-kal drágábbak?
-- Az átlagártól való eltérést is jelenítsük meg az eredményhalmazban! (selectben allekérdezés)
-- A ListPrice=0 termékeket ne vegyük figyelembe az átlagár számításánál!

SELECT P.ProductID, P.Name, P.ListPrice, 
	P.ListPrice - (SELECT AVG(P.ListPrice) FROM Production.product P WHERE P.ListPrice > 0) PriceDiff
FROM Production.product P
WHERE P.ListPrice > (SELECT AVG(P.ListPrice) FROM Production.product P WHERE P.ListPrice > 0) * 1.2;
```

### subquery IN és NOT IN operátorokkal
```sql
-- beágyazott rész
select * from Sales.salesorderheader where OrderDate = '2012-07-07';
--  
select ContactID from Sales.salesorderheader where OrderDate = '2012-07-07';
select ContactID from Sales.salesorderheader where OrderDate = '2012-07-07';

select * from Sales.salesorderdetail 
where SalesOrderID in (select SalesOrderID from Sales.salesorderheader where OrderDate = '2012-07-07');

select * from Sales.salesorderdetail 
where SalesOrderID not in (select SalesOrderID from Sales.salesorderheader where OrderDate = '2012-07-07');

```  

```sql
-- IN klauzula használata (csak egy oszlop lehet a SELECT-ben)
-- Melyek azok a termékek amelyek termékalkategóriája Brakes és mennyi a listaáruk.

Select PP.Name, PP.ListPrice from Production.Product PP
WHERE PP.ProductSubcategoryID IN (SELECT PSC.ProductSubcategoryID 
								from Production.ProductSubcategory PSC
								WHERE PSC.Name='Brakes'	)
-- Az előző feladat megoldása JOIN-nal
-- Hasonlítsuk össze a két megoldást a végrehajtási terv alapján
SELECT PP.Name, PP.ListPrice from Production.Product PP 
		inner join Production.ProductSubcategory PSC on PP.ProductSubcategoryID=PSC.ProductSubcategoryID
		WHERE PSC.Name='Brakes'

-- inner join nélkül ugyanaz a táblakapcsolás

SELECT PP.Name, PP.ListPrice from Production.Product PP, Production.ProductSubcategory PSC
WHERE PP.ProductSubcategoryID=PSC.ProductSubcategoryID AND PSC.Name='Brakes'
```

## FROM
A FROM után használt allekérdezésből visszaadott eredménykészlet ideiglenes táblaként kerül felhasználásra. Ezt a táblát származtatott táblának vagy materializált részlekérdezésnek nevezik. A táblát aliasszal kell ellátni
```sql 
-- 1. verzió: Származtatott tábla (Derived table)
SELECT X.NoOfSales, COUNT(1) SalesNo
FROM (SELECT SOH.CustomerID, COUNT(1) NoOfSales
	  FROM Sales.SalesOrderHeader SOH
	  GROUP BY SOH.CustomerID) X
GROUP BY X.NoOfSales
ORDER BY 1;


/* Készítsünk kimutatást a Sales.SalesOrderHeader tábla alapján, 
	hogy hány olyan vevőnk volt, aki 1-szer, hány olyan, aki kétszer, háromszor stb. 
	vásárolt. Az eredmény az alábbi formájú legyen:

Vásárlások száma	Hány partner
	1					1200
	2					 210
	3					  40
	4
	27
	28					  2*/

-- egy vevőnk hányszor vásárolt
SELECT SOH.customerid, COUNT(1) NoOfSales
	  FROM sales.SalesOrderHeader SOH
	  GROUP BY SOH.customerid;

-- 1. verzió: Származtatott tábla (Derived table)
SELECT innerselect.NoOfSales, COUNT(1) as SalesNo
FROM (SELECT SOH.CustomerID, COUNT(1) as NoOfSales
	  FROM sales.SalesOrderHeader SOH
	  GROUP BY SOH.CustomerID) innerselect
GROUP BY innerselect.NoOfSales
ORDER BY 1;

-- 2. verzió: CTE - Common Table Expression
;WITH X AS (SELECT SOH.CustomerID, COUNT(1) NoOfSales
	  FROM sales.SalesOrderHeader SOH
	  GROUP BY SOH.CustomerID)
SELECT X.NoOfSales, COUNT(1) SalesNo
FROM X
GROUP BY X.NoOfSales
ORDER BY 1;

-- 3. verzió temp táblával
```

## Korrelált lekérdezés
Az önálló segédlekérdezésekkel ellentétben a korrelált részlekérdezés egy olyan segédlekérdezés, amely a külső lekérdezés adatait használja. Más szavakkal, egy korrelált részlekérdezés a külső lekérdezéstől függ. A korrelált részlekérdezést a rendszer egyszer értékeli a külső lekérdezés minden sorához.
Abban az esetben ha korrelált  lekérdezés ugyanabból a táblára hivatkozik a külső lekérdezéshez táblaaliast kell használni.
```sql
-- Keresd meg hogy mennyibe kerül a legolcsóbb és legdrágább termék az egyes termékalkategóriákban és 
SELECT 	productsubcategory.productsubcategoryID
		, productsubcategory.productcategoryID
        -- belső (inner query) lekérdezés hivatkozik a külső lekérdezés értékeire
		, (SELECT MAX(ListPrice) FROM Production.Product
            WHERE product.productsubcategoryID = productsubcategory.productsubcategoryID ) as maxprice	
		, (SELECT min(ListPrice) FROM Production.Product
            WHERE product.productsubcategoryID = productsubcategory.productsubcategoryID ) as minprice
		-- --------------------------------------
FROM Production.ProductSubcategory;
```
```sql
-- Korrelált SELECT példa (itt is csak skalár érték lehet)
-- Melyek azok a termékek, amelyek az alcsoportjuk átlagáránál 20%-kal drágábbak? 
-- A ListPrice=0 termékeket ne vegyük figyelembe az átlagár számításánál!

SELECT P1.ProductID, P1.Name, P1.ListPrice
FROM production.Product P1
WHERE P1.ListPrice > 
	(SELECT AVG(P2.ListPrice) 
	 FROM Production.Product P2 
	 WHERE ( P1.ProductSubcategoryID = P2.ProductSubcategoryID 
				OR P1.ProductSubcategoryID IS NULL 
				AND P2.ProductSubcategoryID IS NULL)
				AND P2.ListPrice > 0
	) * 1.2;
```  


## allekérdezés EXISTS és NOT EXISTS operátorokkal

Ha egy allekérdezést a EXISTS vagy NOT EXISTS operátorral használunk, az allekérdezés IGAZ vagy HAMIS logikai értéket ad vissza.

[Introduction to MySQL EXISTS operator](https://www.mysqltutorial.org/mysql-exists/)  



