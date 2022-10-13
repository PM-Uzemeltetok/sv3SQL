/*SELECT feladatok
K�rdezd le az �sszes term�k nev�t sz�n�t �s �r�t a product t�bl�b�l.*/

Select PP.name, PP.Color, PP.ListPrice  from production.product PP

--K�rdezd le az �sszes term�k alkateg�ria nevet a productsubcategory t�bl�b�l.
SELECT PSC.Name from Production.ProductSubcategory PSC

--K�rdezd le az �sszes term�kkateg�ria nevet a productcategory t�bl�b�l.

Select PC.Name from Production.ProductCategory PC

--K�rdezd le az �sszes nevet a Person t�bl�b�l.

SELECT PP.FirstName, PP.MiddleName, PP.LastName from Person.Person PP

--K�rdezd le az �sszes nevet �s megsz�l�t�st  a Person t�bl�b�l.

SELECT PP.FirstName, PP.MiddleName, PP.LastName, PP.Title from Person.Person PP

/*WHERE feladatok
K�rdezd le a k�k term�kek minden adat�t a product t�bl�b�l.*/
Select * from Production.Product PP
where PP.Color='Blue'
--K�rdezd le a 46-os m�ret� term�kek nev�t �s sz�n�t a product t�bl�b�l.
Select PP.Name, PP.Color from Production.Product PP
where PP.Size='46'

--K�rdezd le az S m�ret� term�kek nev�t �s lista�r�t a product t�bl�b�l.
Select PP.Name, PP.ListPrice from Production.Product PP
where PP.Size='S'

--K�rdezd le a Kim keresztnev� felhaszn�l�kat a Person t�bl�b�l.

SELECT PP.FirstName, PP.MiddleName, PP.LastName from Person.Person PP
WHERE PP.FirstName='Kim'

--K�rdezd le az 50 forintn�l olcs�bb lista�r� term�keket a product t�bl�b�l.
Select PP.Name, PP.ListPrice from Production.Product PP
where PP.ListPrice<'50'

--K�rdezd le a S-es k�k term�keket a product t�bl�b�l.
Select* from Production.Product PP
where PP.Color='Blue' AND PP.Size='S'
--K�rdezd le a 56-os piros term�keket a product t�bl�b�l.
Select* from Production.Product PP
where PP.Color='Red' AND PP.Size='56'
--K�rdezd le a k�k �s a piros term�keket a product t�bl�b�l.
Select* from Production.Product PP
where PP.Color='Red' or PP.Color='Blue'
--K�rdezd le a 42-es �s 62-es m�ret� term�keket a product t�bl�b�l.
Select* from Production.Product PP
where PP.Size='42' OR PP.Size='62'

--K�rdezd le azokat a term�keket amiknek a lista�ra 100 �s 500 forint k�z�tt van.
Select* from Production.Product PP
where PP.ListPrice>'100' and PP.ListPrice<'500'

-------------------------------------
--K�rdezd le azokat a rendel�sazonos�t�kat amiket 2012.03.01 �s 2012.03.20 k�z�tt rendeltek a salesorderheader t�bl�b�l.
Select * from Sales.SalesOrderHeader soh
where soh.OrderDate> '2012.03.01' and soh.OrderDate <'2012.03.20'
--K�rdezd le a 42-es m�ret� fekete term�keket.

Select * from Production.Product PP
WHERE PP.Size='42' AND PP.Color='Black'

--K�rdezd le a nem 42-es m�ret� term�keket.
Select * from Production.Product PP
WHERE PP.Size!='42' 
--K�rdezd le azokat a term�kekekt amik nem fekete sz�n�ek.
Select * from Production.Product PP
WHERE PP.Color!='Black'

--K�rdezd le azokat a term�keket amiknek a nev�ben szerepel a bike sz�.
Select * from Production.Product PP
WHERE PP.Name Like '%bike%'

--K�rdezd le azokat a term�keket amiknek a nev�ben szerepel a Sock sz�.
Select * from Production.Product PP
WHERE PP.Name Like '%Sock%'

--K�rdezd le azokat a term�keket amikenk a neve a sport sz�val kezd�dik.
Select * from Production.Product PP
WHERE PP.Name Like 'Sport%'

--K�rdezd le azokat a term�keket amiknek a neve Red sz�ra v�gz�dik.
Select * from Production.Product PP
WHERE PP.Name Like '%Red'
--K�rdezd le azokat a term�keket amiknek a nev�ben szerepel a Ball sz�.
Select * from Production.Product PP
WHERE PP.Name Like '%Ball%'

--K�rdezd le a k�k sz�n� term�keket �s a sz�n�t �rd ki magyarul.
Select PP.Name, IIF(PP.Color='Blue','K�k','') from Production.Product PP
WHERE PP.Color='Blue'
--K�rdezd le a piros sz�n� term�keket �s a sz�n�t �rd ki magyarul.
Select PP.Name, IIF(PP.Color='Red','Piros','') from Production.Product PP
WHERE PP.Color='Red'
/*K�rdezd le a term�kek nev�t, ha a sellenddate meg van adva �rasd ki hogy m�r nem �ruljuk
ha nincs megadva akkor azt hogy m�g �ruljuk az �ruljuk? nev� mez�be.*/
Select PP.Name, IIF(PP.SellEndDate is NULL, 'm�r nem �ruljuk', '�ruljuk') as '�ruljuk?'from Production.Product PP

--K�rdezd le azon term�kek nev�t amit m�r nem �rus�tunk �s a �llapot nev� mez�be �rd ki hogy nem forgalmazzuk.
Select PP.Name, 'nem forgalmazzuk' as '�llapot'
from Production.Product PP
WHERE PP.SellEndDate is null

--Rendezd a term�kek nev�t ABC sorrendbe.
Select PP.Name
from Production.Product PP
Order By PP.Name

--Rendezd a term�kek nev�t az lista�ruk szerint.
Select PP.Name
from Production.Product PP
Order By PP.ListPrice

--K�rdezd le a term�kek nev�t, �r�t �s sz�n�t �s rendezd lista�r szerint cs�kken� sorrendbe
Select PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
Order By PP.ListPrice desc

/*K�rdezd le a term�kek nev�t, �r�t �s sz�n�t �s rendezd lista�r szerint cs�kken� sorrendbe 
valamint a term�k neve szerint ABC sorrendbe*/
Select PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
Order By PP.ListPrice desc, PP.name

--K�rdezd le a 100 legdr�g�bb term�ket.

Select TOP 100 PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
Order By PP.ListPrice desc

--K�rdezd le a 100 legr�gebb �ta (sellstartdate) forgalmazott term�ket
Select TOP 100 PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
Order By PP.SellStartDate

--K�rdezd le a 100 legr�gebb �ta (sellstartdate) forgalmazott term�ket, amit m�g most is forgalmazunk
Select TOP 100 PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
where PP.SellEndDate is not null
Order By PP.SellStartDate

/*K�rdezd le a 100 legolcs�bb term�ket, aminek a sz�ne fekete, 
a neve tartalmazza a Mountain sz�t, az �ra nem 0 �s m�g mindig forgalmazzuk.*/
Select TOP 100  PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
where PP.SellEndDate is not null AND PP.Color='Black' AND PP.Name Like '%Mountain%' AND PP.ListPrice >'0'
Order By PP.ListPrice

--K�rdezd le a 10 legolcs�bb term�ket, aminek az �ra nagyobb 0-n�l �s a neve tartalmazza a Pedal sz�t.
Select TOP 10  PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
where PP.Name Like '%Pedal%' AND PP.ListPrice >'0'
Order By PP.ListPrice

--K�rdezd le a 20 legdr�g�bb term�kt�l a 30 ut�na k�vetkez� term�ket, amik k�kek �s az �ruk nem 0.

Select PP.Name, PP.ListPrice, PP.Color
from Production.Product PP
where PP.color='Blue' and PP.ListPrice>0
Order By PP.ListPrice desc
OFFSET 19 ROWS FETCH NEXT 30 ROWS ONLY

