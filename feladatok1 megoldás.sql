/*SELECT feladatok
Kérdezd le az összes termék nevét színét és árát a product táblából.*/

Select PP.name, PP.Color, PP.ListPrice  from production.product PP

--Kérdezd le az összes termék alkategória nevet a productsubcategory táblából.
SELECT PSC.Name from Production.ProductSubcategory PSC

--Kérdezd le az összes termékkategória nevet a productcategory táblából.

Select PC.Name from Production.ProductCategory PC

--Kérdezd le az összes nevet a Person táblából.

SELECT PP.FirstName, PP.MiddleName, PP.LastName from Person.Person PP

--Kérdezd le az összes nevet és megszólítást  a Person táblából.

SELECT PP.FirstName, PP.MiddleName, PP.LastName, PP.Title from Person.Person PP

/*WHERE feladatok
Kérdezd le a kék termékek minden adatát a product táblából.*/
Select * from Production.Product PP
where PP.Color='Blue'
--Kérdezd le a 46-os méretû termékek nevét és színét a product táblából.
Select PP.Name, PP.Color from Production.Product PP
where PP.Size='46'

--Kérdezd le az S méretû termékek nevét és listaárát a product táblából.
Select PP.Name, PP.ListPrice from Production.Product PP
where PP.Size='S'

--Kérdezd le a Kim keresztnevû felhasználókat a Person táblából.

SELECT PP.FirstName, PP.MiddleName, PP.LastName from Person.Person PP
WHERE PP.FirstName='Kim'

--Kérdezd le az 50 forintnál olcsóbb listaárú termékeket a product táblából.
Select PP.Name, PP.ListPrice from Production.Product PP
where PP.ListPrice<'50'

--Kérdezd le a S-es kék termékeket a product táblából.
Select* from Production.Product PP
where PP.Color='Blue' AND PP.Size='S'
--Kérdezd le a 56-os piros termékeket a product táblából.
Select* from Production.Product PP
where PP.Color='Red' AND PP.Size='56'
--Kérdezd le a kék és a piros termékeket a product táblából.
Select* from Production.Product PP
where PP.Color='Red' or PP.Color='Blue'
--Kérdezd le a 42-es és 62-es méretû termékeket a product táblából.
Select* from Production.Product PP
where PP.Size='42' OR PP.Size='62'

--Kérdezd le azokat a termékeket amiknek a listaára 100 és 500 forint között van.
Select* from Production.Product PP
where PP.ListPrice>'100' and PP.ListPrice<'500'

-------------------------------------
--Kérdezd le azokat a rendelésazonosítókat amiket 2012.03.01 és 2012.03.20 között rendeltek a salesorderheader táblából.
Select * from Sales.SalesOrderHeader soh
where soh.OrderDate> '2012.03.01' and soh.OrderDate <'2012.03.20'
--Kérdezd le a 42-es méretû fekete termékeket.

Select * from Production.Product PP
WHERE PP.Size='42' AND PP.Color='Black'

--Kérdezd le a nem 42-es méretû termékeket.
Select * from Production.Product PP
WHERE PP.Size!='42' 
--Kérdezd le azokat a termékekekt amik nem fekete színûek.
Select * from Production.Product PP
WHERE PP.Color!='Black'

--Kérdezd le azokat a termékeket amiknek a nevében szerepel a bike szó.
Select * from Production.Product PP
WHERE PP.Name Like '%bike%'

--Kérdezd le azokat a termékeket amiknek a nevében szerepel a Sock szó.
Select * from Production.Product PP
WHERE PP.Name Like '%Sock%'

--Kérdezd le azokat a termékeket amikenk a neve a sport szóval kezdõdik.
Select * from Production.Product PP
WHERE PP.Name Like 'Sport%'

--Kérdezd le azokat a termékeket amiknek a neve Red szóra végzõdik.
Select * from Production.Product PP
WHERE PP.Name Like '%Red'
--Kérdezd le azokat a termékeket amiknek a nevében szerepel a Ball szó.
Select * from Production.Product PP
WHERE PP.Name Like '%Ball%'

--Kérdezd le a kék színû termékeket és a színét írd ki magyarul.
Select PP.Name, IIF(PP.Color='Blue','Kék','') from Production.Product PP
WHERE PP.Color='Blue'
--Kérdezd le a piros színû termékeket és a színét írd ki magyarul.
Select PP.Name, IIF(PP.Color='Red','Piros','') from Production.Product PP
WHERE PP.Color='Red'
/*Kérdezd le a termékek nevét, ha a sellenddate meg van adva írasd ki hogy már nem áruljuk
ha nincs megadva akkor azt hogy még áruljuk az áruljuk? nevû mezõbe.*/
Select PP.Name, IIF(PP.SellEndDate is NULL, 'már nem áruljuk', 'áruljuk') as 'áruljuk?'from Production.Product PP

--Kérdezd le azon termékek nevét amit már nem árusítunk és a állapot nevû mezõbe írd ki hogy nem forgalmazzuk.
Select PP.Name, 'nem forgalmazzuk' as 'állapot'
from Production.Product PP
WHERE PP.SellEndDate is null

--Rendezd a termékek nevét ABC sorrendbe.
Select PP.Name
from Production.Product PP
Order By PP.Name

--Rendezd a termékek nevét az listaáruk szerint.
Select PP.Name
from Production.Product PP
Order By PP.ListPrice

--Kérdezd le a termékek nevét, árát és színét és rendezd listaár szerint csökkenõ sorrendbe
Select PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
Order By PP.ListPrice desc

/*Kérdezd le a termékek nevét, árát és színét és rendezd listaár szerint csökkenõ sorrendbe 
valamint a termék neve szerint ABC sorrendbe*/
Select PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
Order By PP.ListPrice desc, PP.name

--Kérdezd le a 100 legdrágább terméket.

Select TOP 100 PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
Order By PP.ListPrice desc

--Kérdezd le a 100 legrégebb óta (sellstartdate) forgalmazott terméket
Select TOP 100 PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
Order By PP.SellStartDate

--Kérdezd le a 100 legrégebb óta (sellstartdate) forgalmazott terméket, amit még most is forgalmazunk
Select TOP 100 PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
where PP.SellEndDate is not null
Order By PP.SellStartDate

/*Kérdezd le a 100 legolcsóbb terméket, aminek a színe fekete, 
a neve tartalmazza a Mountain szót, az ára nem 0 és még mindig forgalmazzuk.*/
Select TOP 100  PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
where PP.SellEndDate is not null AND PP.Color='Black' AND PP.Name Like '%Mountain%' AND PP.ListPrice >'0'
Order By PP.ListPrice

--Kérdezd le a 10 legolcsóbb terméket, aminek az ára nagyobb 0-nál és a neve tartalmazza a Pedal szót.
Select TOP 10  PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
where PP.Name Like '%Pedal%' AND PP.ListPrice >'0'
Order By PP.ListPrice

--Kérdezd le a 20 legdrágább terméktõl a 30 utána következõ terméket, amik kékek és az áruk nem 0.

Select PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
where PP.color='Blue' and PP.ListPrice>0
Order By PP.ListPrice desc
OFFSET 19 ROWS FETCH NEXT 30 ROWS ONLY

