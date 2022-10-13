-- 1. K�rdezd le a Person t�bl�b�l a neveket �s f�zd �ssze �ket egyetlen mez�be. A mez� neve legyen teljes n�v.
--cs�nya megold�s, de a feladatot teljes�ti
SELECT P.FirstName+' '+Coalesce(P.MiddleName,' ')+P.LastName as 'Teljes n�v'
FROM Person.Person P
--Sz�p megold�s a k�z�ket is a hely�n kezeli
SELECT Concat(P.FirstName,' ', Coalesce(P.MiddleName+' ',''), P.LastName), P.MiddleName
FROM Person.Person P

-- 2.K�rdezd le a Person t�bl�b�l a vezet�kneveket �s f�zd hozz� a titulushoz. A titulus �s a n�v k�z�tt legyen k�z.
SELECT Coalesce (P.Title+' ','') + P.LastName 
from Person.Person P

-- 3. K�rdezd le a term�kn�v els� 5 karakter�t a product t�bl�b�l.

SELECT LEFT(P.Name,5)
From Production.Product P

-- 4. K�rdezd le a term�kn�v utols� 5 karakter�t a product t�bl�b�l.

SELECT RIGHT(P.Name,5)
From Production.Product P

-- 5. K�rdezd le a term�knevet az 5. karaktert�l a 10. karakterig a product t�bl�b�l.

SELECT SUBSTRING(P.name,5,5)
From Production.Product P

-- 6. Hat�rozd meg, hogy h�nyadik karakter az els� k�z a term�kn�vben a product t�bl�ban.

SELECT CHARINDEX(' ',P.Name)
From Production.Product P

-- 7. Hat�rozd meg a term�k nev�nek hossz�t a product t�bl�ban.

SELECT LEN(P.name)
From Production.Product P

-- 8. K�rd le a term�k nev�t az els� k�zig a product t�bl�b�l �s a term�k nev�t az els� k�zt�l k�l�n mez�ben.
SELECT LEFT(P.name ,CHARINDEX(' ',P.Name)), SUBSTRING(P.name, CHARINDEX(' ',P.Name)+1, LEN(P.name)-CHARINDEX(' ',P.Name))
From Production.Product P

-- 9. Szedd ki a term�k m�ret�t a term�k nev�b�l a product t�bl�ban.
SELECT P.Name, P.Size, SUBSTRING(P.name, CHARINDEX(',',P.Name)+1, LEN(P.name)-CHARINDEX(' ',P.Name))
from Production.Product P
WHERE P.size Is not null

-- 10. Cser�ld ki a a k�z�ket k�t�jelre a term�k nev�ben.

SELECT REPLACE(P.name, ' ', '_') 
FROM Production.Product P

-- 11. K�rd le a term�k nev�t �s hogy melyik �vben kezdt�k el �rulni a product t�bl�b�l.

SELECT P.name, YEAR(P.Sellstartdate)
from Production.Product P

-- 12. K�rd le a term�k nev�t �s hogy melyik h�napban kezdt�k el �rulni a product t�bl�b�l.

SELECT P.name, DATENAME(m,P.Sellstartdate)
from Production.Product P

-- 13. K�rd le a term�k nev�t �s hogy h�nyadik h�napban kezdt�k el �rulni a product t�bl�b�l.

SELECT P.name, MONTH(P.Sellstartdate)
from Production.Product P

-- 14. K�rd le a term�k nev�t �s hogy melyik napon kezdt�k el �rulni a product t�bl�b�l.

SELECT P.name, DAY(P.Sellstartdate)
from Production.Product P

-- 15. K�rd le a term�k nev�t �s hogy a h�t melyik napj�n kezdt�k el �rulni a product t�bl�b�l.

SELECT P.name, DATENAME(DW, P.Sellstartdate)
from Production.Product P

-- 16. K�rd le a term�k nev�t �s hogy a h�t melyik napj�n kezdt�k el �rulni �s �rd ki bet�vel magyarul a product t�bl�b�l.
SET LANGUAGE MAGYAR
SELECT P.name, DATENAME(DW, P.Sellstartdate)
from Production.Product P

-- 17. K�rdezd le azon term�kek nev�t amiknek nincs megadva a m�rete a product t�bl�b�l.

SELECT P.Name
FROM Production.Product P
WHERE P.Size is null

-- 18. K�rdezd le azon term�kek nev�t, m�ret�t �s �r�t, amiknek meg van adva a m�rete �s rendezd n�v �s m�ret �s �r szerint n�vekv� sorrendbe.

SELECT P.Name, P.Size, P.ListPrice
FROM Production.Product P
WHERE P.Size is not null
Order by P.Name, P.Size, P.ListPrice

/*19. K�rdezd le azon term�kek nev�t, m�ret�t (a n�vb�l f�ggv�nnyel) �s �r�t, 
amiknek meg van adva a m�rete �s rendezd n�v �s m�ret �s �r szerint n�vekv� sorrendbe.*/

SELECT P.Name, SUBSTRING(P.name, CHARINDEX(',',P.Name)+1, LEN(P.name)-CHARINDEX(' ',P.Name))
FROM Production.Product P
WHERE P.Size is not null
ORDER BY P.Name, P.Size, P.ListPrice

-- 20. K�rdezd le a term�kek nev�t �s sz�n�t, ahol a sz�n nincs megadva ott szerepeljen az hogy sz�ntelen.

SELECT P.name, Coalesce(P.color,'szintelen')
FROM Production.Product P
/* 21. F�zd �ssze egy mez�be a term�kek nev�t, sz�n�t �s m�ret�t. 
Ha a sz�n nincs megadva szerepejen az hogy sz�ntelen, ha a m�ret nincs megadva szerepeljen az hogy nincs m�ret. 
Az �sszef�z�tt adatok k�z�tt legyen k�t�jel.*/

SELECT P.name+'-'+Coalesce(P.color,'szintelen')+'-'+Coalesce(P.size,'nincs m�ret')
FROM Production.Product P
-- 22. K�rd le a term�kek nev�t �s s�ly�t, ha a s�ly nincs megadva legyen 2.

SELECT P.name, Coalesce(P.Weight,'2')
From Production.Product P