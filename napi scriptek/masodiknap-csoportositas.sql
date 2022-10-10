select * from salesorderheader soh;

select min(TotalDue), max(TotalDue), avg(TotalDue), sum(TotalDue) from salesorderheader as soh;

select TotalDue from salesorderheader soh
where TotalDue is null;

select contactid, avg(TotalDue)
from salesorderheader as soh
group by ContactID;


select year(OrderDate), avg(TotalDue), min(TotalDue), max(TotalDue)
from salesorderheader as soh
group by year(OrderDate);


select count(*), count(CurrencyRateID) from salesorderheader soh;
select count(CurrencyRateID) from salesorderheader soh;

-- több oszlop
select TerritoryID, year(OrderDate), sum(TotalDue) from salesorderheader soh
group by TerritoryID, year(OrderDate)
order by 2,1;

select TerritoryID, year(OrderDate), sum(TotalDue) from salesorderheader soh
group by year(OrderDate), TerritoryID
order by 1,2;


-- having
select ContactID, sum(TotalDue) as osszeg from salesorderheader soh
-- where sum(TotalDue) > 3000
group by ContactID
having sum(TotalDue) > 200000
order by 2 desc;


-- feladat megoldások

-- 1. Számold meg hogy melyik alkategória ID-hoz hány termék tartozik

select ProductSubcategoryID, count(ProductSubcategoryID)
from product
group by ProductSubcategoryID;

-- 2. Számold meg hogy hány vásárlás történt az egyes napokon a Salesorderheader tábla adatai szerint. (orderdate-et vedd alapul)
-- és a legforgalmasabb nap

select soh.OrderDate, count(soh.OrderDate) from salesorderheader soh
group by soh.OrderDate
order by 2 desc
limit 1;


-- 3. Számold ki mennyit költöttek összesen az egyes napokon a Salesorderheader tábla adatai szerint. (orderdate-et vedd alapul)
-- és hasonlítsd össze az összes átlagával - beágyazott lekérdezés

-- select avg(TotalDue) from salesorderheader as soh; -- ez van zárójelben a select után - 1 értéket ad vissza

select 	soh.OrderDate, 
		sum(soh.TotalDue), 
        (select avg(TotalDue) from salesorderheader as soh) as atlag, -- 1 érték! nem több sor 
        sum(soh.TotalDue) - (select avg(TotalDue) from salesorderheader as soh) as differencia
from salesorderheader soh
group by soh.OrderDate;

-- miért nem csak simán szerepel oszlopként:
-- csoportosítja naponként
select 	soh.OrderDate, 
		sum(soh.TotalDue), 
        avg(TotalDue)        
from salesorderheader soh
group by soh.OrderDate;


-- 5. Számold ki hogy ki vásárolt a legtöbbet és a legkevesebbet (customerID) összeg szerint (TotalDue)
select ContactID, max(TotalDue), min(TotalDue)  from salesorderheader
group by ContactID
order by 2 desc;

-- kik költötték a legtöbbet és a legkevesebbet összeg szerint
select ContactID, sum(totaldue) from salesorderheader
group by ContactID
order by 2 desc
limit 1;

select ContactID, sum(totaldue) from salesorderheader
group by ContactID
order by 2 asc
limit 1;

-- 8. Nézd meg hogy az egyes területeken (TeritoryID) ki költött a legtöbbet, legkevesebbet és mennyi volt az átlag költés.

select TerritoryID, ContactID, min(TotalDue) mintd, max(TotalDue) maxtd from salesorderheader
group by TerritoryID, ContactID
order by TerritoryID;


-- Kiadott fealadatok: (6,7,9,10)

-- 6. Számold ki hogy ki vásárolt a legtöbbet és a legkevesebbet (customerID) összeg szerint (TotalDue) 2002 júniusában.
select CustomerID, avg(TotalDue), min(TotalDue), max(TotalDue), count(TotalDue) 
from salesorderheader
where OrderDate between '2002.06.01' and '2002-06-30'
group by CustomerID;

-- 7. Számold ki hogy ki vásárolt a legtöbbet és legkevesebbet valamint mennyi volt az átlagos vásárlás (customerID) összeg szerint (TotalDue).
select CustomerID, avg(TotalDue), min(TotalDue), max(TotalDue), count(TotalDue) from salesorderheader
group by CustomerID;


-- 9. Kérd le a 10 legtöbb alkalommal várásló CustomerID-ját
select CustomerID, count(CustomerID) 
from salesorderheader 
group by CustomerID
order by count(CustomerID)  desc
limit 10;

-- 10. Kérd le a 10 legtöbb költő várásló CustomerID-ját 2002 decemberében (orderdate-et vedd alapul)
select CustomerID, sum(TotalDue) from salesorderheader
where (year(OrderDate) = 2002) and (month(OrderDate) = 12)
group by CustomerID
order by sum(TotalDue) desc
limit 10;









-- -----------------------------------------------------------------------------------------------------------------------------
-- lekérdezés eredményének használata, select, where, from után

-- select példa - csak 1 értéket adhat vissza

-- select avg(TotalDue) from salesorderheader as soh; -- ez van zárójelben a select után - 1 értéket ad vissza

select 	soh.OrderDate, 
		sum(soh.TotalDue), 
        (select avg(TotalDue) from salesorderheader as soh) as atlag, -- 1 érték! nem több sor 
        sum(soh.TotalDue) - (select avg(TotalDue) from salesorderheader as soh) as differencia
from salesorderheader soh
group by soh.OrderDate;


-- where példa - több értéket is visszaadhat

select * from salesorderheader where OrderDate = '2001-07-07';
select ContactID from salesorderheader where OrderDate = '2001-07-07';

-- Vevők adatai akik 2001. 07.07.-én vásároltak
select * from contact
where ContactID in (select ContactID from salesorderheader where OrderDate = '2001-07-07');


-- lekérdezés egy eredményhalnazon

-- from után 1.példa 
(select * from salesorderheader where OrderDate = '2001-07-07'); -- ezen a napon ezek a megrendelések voltak

select X.ShipDate 
from (select * from salesorderheader where OrderDate = '2001-07-07') as X;
-- ugyanaz mint ez:
select ShipDate from salesorderheader where OrderDate = '2001-07-07';


-- from után 2. példa
select TerritoryID, ContactID, min(TotalDue) mintd, max(TotalDue) maxtd from salesorderheader
group by TerritoryID, ContactID
order by TerritoryID;

select x.TerritoryID, min(x.mintd) 
from (select TerritoryID, ContactID, min(TotalDue) mintd, max(TotalDue) maxtd from salesorderheader
group by TerritoryID, ContactID
order by TerritoryID) as x
group by TerritoryID;