## Csoportosító lekérdezés (GROUP BY)

Az SQL lehetőséget ad arra, hogy egy tábla valamilyen mezője szerint csoportokat alakítsunk ki, és utána az adott csoportra vonatkozóan végezzünk számításokat.
Csoportosítani a **GROUP BY** utasítással tudunk.
Az alábbi kis példában megszámolju, hogy melyik productsubcategory-ba hányféle termék található.

```sql
SELECT P.productsubcategoryID, COUNT(P.ProductSubcategoryID) 'termékfélék(db)'
		FROM Production.Product P
		GROUP BY P.ProductSubcategoryID
```
A **GROUP BY** használatakor fontos kikötés, hogy a **SELECT** részbe csak a csoportosító mező és olyan mezők lehetnek, amin valamilyen összesítő (aggregátor) függvényt használunk.
Természetesen a **WHERE** parancsot használhatjuk és még a csoportosítás előtt kiszűrhetjük a nekünk szükséges rekordokat.
A lenti lekérdezésből például szeretnénk eltávolítani azokat a rekordokat, amiknél nincs megadva a SubCategoryID.

```sql
SELECT P.productsubcategoryID, COUNT(P.ProductSubcategoryID) 'termékfélék(db)'
FROM Production.Product P
WHERE P.ProductSubcategoryID IS NOT NULL
GROUP BY P.ProductSubcategoryID
```
Hogy még több infót adjon a lekérdezésünk lehetőségünk van további információkat kiszámolni. Például a legolcsóbb, a legdrágább termékek árát valamit a csoportonként a termékek átlagárát.
Ehhez a **MIN()** (legkisebb érték), a **MAX()** (legnagyobb érték) és a **AVG()** (átlag) fügvényeket fogjuk használni.
```sql
SELECT 	P.productsubcategoryID, 
		COUNT(P.ProductSubcategoryID) 'termékfélék(db)', 
		MIN(P.Listprice) legolcsóbb,
		MAX(P.Listprice) legdrágább,
		AVG(P.ListPrice) átlagár
FROM Production.product P
WHERE P.ProductSubcategoryID IS NOTt NULL
GROUP BY P.ProductSubcategoryID
```

## HAVING

Mivel a fenti lekérdezésben az összesítő függvényeknek nincs értelme akkor, ha az adott kategóriában csak 1 termék van. Így azokat szeretném eltávolítani.
A GROUP BY által képzett csoportokra vonatkozóan a **HAVING** paranccsal tudunk szűrőfeltételeket megadni. Hasonlóan működik mint a WHERE feltétel csak a csoportokra vonatkozik.
Ezzel kapcsolatban fontos kikötés, hogy a SELECT részben létrehozott aliasokat a HAVING részben nem használhatjuk mert bár a SELECT szintaktikailag megelőzi a HAVING-et. A végrehajtási sorrendben a HAVING hamarabb hajtódik végre ezért olyankor még a SELECT-ben létrehozott aliasok nem léteznek. Ezért a HAVING részben ki kell számoltatnunk az értékeket.

```sql
SELECT 	P.productsubcategoryID, 
		COUNT(P.ProductSubcategoryID) 'termékfélék(db)', 
		MIN(P.Listprice) legolcsóbb,
		MAX(P.Listprice) legdrágább,
		AVG(P.ListPrice) átlagár
FROM Production.Product P
WHERE P.ProductSubcategoryID IS NOT NULL
GROUP BY P.ProductSubcategoryID
HAVING COUNT(P.ProductSubcategoryID) > 1
```  
Végül pedig, hogy rendezettebb képet kapjunk kiegészíthetjük a legkérdezésünket mondjuk egy sorbarendezéssel **ORDER BY** parancs. Amit érdemes megfigyelni, hogy itt már használható a SELECT-ben létrehozott aliasok mivel az ORDER BY viszont a SELECT után hajtódik végre.
```sql
SELECT 	P.productsubcategoryID, 
		COUNT(P.ProductSubcategoryID) 'termékfélék(db)', 
		MIN(P.Listprice) legolcsóbb,
		MAX(P.Listprice) legdrágább,
		AVG(P.ListPrice) átlagár
FROM Production.Product P
WHERE P.ProductSubcategoryID is not NULL
GROUP BY P.ProductSubcategoryID
HAVING COUNT(P.ProductSubcategoryID) > 1
ORDER BY átlagár
```  
![image1](/.pics/vegrehajtas.jpg)  
