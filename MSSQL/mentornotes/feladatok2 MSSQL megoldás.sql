-- 1. Kérdezd le a Person táblából a neveket és fûzd össze õket egyetlen mezõbe. A mezõ neve legyen teljes név.
--csúnya megoldás, de a feladatot teljesíti
SELECT P.FirstName+' '+Coalesce(P.MiddleName,' ')+P.LastName as 'Teljes név'
FROM Person.Person P
--Szép megoldás a közöket is a helyén kezeli
SELECT Concat(P.FirstName,' ', Coalesce(P.MiddleName+' ',''), P.LastName), P.MiddleName
FROM Person.Person P

-- 2.Kérdezd le a Person táblából a vezetékneveket és fûzd hozzá a titulushoz. A titulus és a név között legyen köz.
SELECT Coalesce (P.Title+' ','') + P.LastName 
from Person.Person P

-- 3. Kérdezd le a terméknév elsõ 5 karakterét a product táblából.

SELECT LEFT(P.Name,5)
From Production.Product P

-- 4. Kérdezd le a terméknév utolsó 5 karakterét a product táblából.

SELECT RIGHT(P.Name,5)
From Production.Product P

-- 5. Kérdezd le a terméknevet az 5. karaktertõl a 10. karakterig a product táblából.

SELECT SUBSTRING(P.name,5,5)
From Production.Product P

-- 6. Határozd meg, hogy hányadik karakter az elsõ köz a terméknévben a product táblában.

SELECT CHARINDEX(' ',P.Name)
From Production.Product P

-- 7. Határozd meg a termék nevének hosszát a product táblában.

SELECT LEN(P.name)
From Production.Product P

-- 8. Kérd le a termék nevét az elsõ közig a product táblából és a termék nevét az elsõ köztõl külön mezõben.
SELECT LEFT(P.name ,CHARINDEX(' ',P.Name)), SUBSTRING(P.name, CHARINDEX(' ',P.Name)+1, LEN(P.name)-CHARINDEX(' ',P.Name))
From Production.Product P

-- 9. Szedd ki a termék méretét a termék nevébõl a product táblában.
SELECT P.Name, P.Size, SUBSTRING(P.name, CHARINDEX(',',P.Name)+1, LEN(P.name)-CHARINDEX(' ',P.Name))
from Production.Product P
WHERE P.size Is not null

-- 10. Cseréld ki a a közöket kötõjelre a termék nevében.

SELECT REPLACE(P.name, ' ', '_') 
FROM Production.Product P

-- 11. Kérd le a termék nevét és hogy melyik évben kezdték el árulni a product táblából.

SELECT P.name, YEAR(P.Sellstartdate)
from Production.Product P

-- 12. Kérd le a termék nevét és hogy melyik hónapban kezdték el árulni a product táblából.

SELECT P.name, DATENAME(m,P.Sellstartdate)
from Production.Product P

-- 13. Kérd le a termék nevét és hogy hányadik hónapban kezdték el árulni a product táblából.

SELECT P.name, MONTH(P.Sellstartdate)
from Production.Product P

-- 14. Kérd le a termék nevét és hogy melyik napon kezdték el árulni a product táblából.

SELECT P.name, DAY(P.Sellstartdate)
from Production.Product P

-- 15. Kérd le a termék nevét és hogy a hét melyik napján kezdték el árulni a product táblából.

SELECT P.name, DATENAME(DW, P.Sellstartdate)
from Production.Product P

-- 16. Kérd le a termék nevét és hogy a hét melyik napján kezdték el árulni és írd ki betûvel magyarul a product táblából.
SET LANGUAGE MAGYAR
SELECT P.name, DATENAME(DW, P.Sellstartdate)
from Production.Product P

-- 17. Kérdezd le azon termékek nevét amiknek nincs megadva a mérete a product táblából.

SELECT P.Name
FROM Production.Product P
WHERE P.Size is null

-- 18. Kérdezd le azon termékek nevét, méretét és árát, amiknek meg van adva a mérete és rendezd név és méret és ár szerint növekvõ sorrendbe.

SELECT P.Name, P.Size, P.ListPrice
FROM Production.Product P
WHERE P.Size is not null
Order by P.Name, P.Size, P.ListPrice

/*19. Kérdezd le azon termékek nevét, méretét (a névbõl függvénnyel) és árát, 
amiknek meg van adva a mérete és rendezd név és méret és ár szerint növekvõ sorrendbe.*/

SELECT P.Name, SUBSTRING(P.name, CHARINDEX(',',P.Name)+1, LEN(P.name)-CHARINDEX(' ',P.Name))
FROM Production.Product P
WHERE P.Size is not null
ORDER BY P.Name, P.Size, P.ListPrice

-- 20. Kérdezd le a termékek nevét és színét, ahol a szín nincs megadva ott szerepeljen az hogy színtelen.

SELECT P.name, Coalesce(P.color,'szintelen')
FROM Production.Product P
/* 21. Fûzd össze egy mezõbe a termékek nevét, színét és méretét. 
Ha a szín nincs megadva szerepejen az hogy színtelen, ha a méret nincs megadva szerepeljen az hogy nincs méret. 
Az összefûzött adatok között legyen kötõjel.*/

SELECT P.name+'-'+Coalesce(P.color,'szintelen')+'-'+Coalesce(P.size,'nincs méret')
FROM Production.Product P
-- 22. Kérd le a termékek nevét és súlyát, ha a súly nincs megadva legyen 2.

SELECT P.name, Coalesce(P.Weight,'2')
From Production.Product P