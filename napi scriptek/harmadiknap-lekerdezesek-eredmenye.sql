-- eredmények felhasználása (egyedi érték, tábla)

-- skaláris (1) érték kezelése
-- változó kezelés

set @maxertek := (Select max(listprice) from product);
select @maxertek;

Select avg(listprice) from product into @atlagertek;
select @atlagertek;

Select avg(listprice), max(ListPrice), min(ListPrice) from product into @atlagertek, @maxertek, @minertek;
select @atlagertek, @maxertek, @minertek;

Select FirstName, MiddleName, LastName  
into @fn, @mn, @ln 
from contact
where contactid = 345;
Select @fn, @mn, @ln ;

Select FirstName, MiddleName, LastName  
into @fn, @mn, @ln 
from contact
where contactid > 345 and contactid < 350
limit 1;
Select @fn, @mn, @ln;

set @fontosdatum = (Select min(OrderDate) from salesorderheader);
select * from salesorderheader where OrderDate = @fontosdatum;

-- ------------------------------------------------------------------------------

-- több sor az eredményben
SELECT * INTO @temptabla FROM contact
where contactid > 345 and contactid < 350;


-- ideiglenes táblában tároljuk további feldolgozásra
-- létrehozom
create temporary table temptabla (
	fn nvarchar(50),
    mn nvarchar(50),
    ln nvarchar(50)
);

-- select eredményét belerakom (insert)
insert into temptabla (fn, mn, ln)
Select FirstName, MiddleName, LastName  
from contact
where contactid > 345 and contactid < 350;

select * from temptabla;
-- drop temporary table temptabla;

select * from contact where FirstName in (Select fn from temptabla);
select connection_id();


-- ----------------------------------------------------------------------------------
-- másik adatbázisban szeretném tárolni az eredményt
-- előkészületek:
create database HAtemp;
use HAtemp;
create table eredmenytabla (
	fn nvarchar(50),
    mn nvarchar(50),
    ln nvarchar(50)
);

-- lekérdezés - vissza az aw-be és onnan írok másik adatbázisba
-- use adventureworks;
-- use sys;
-- truncate table HAtemp.eredmenytabla;

insert into HAtemp.eredmenytabla (fn, mn, ln)
Select FirstName, MiddleName, LastName  
from adventureworks.contact
where adventureworks.contact.ContactID > 361 and adventureworks.contact.ContactID < 370;

select * from HAtemp.eredmenytabla;
select * from contact where FirstName in (Select fn from HAtemp.eredmenytabla); -- ehhez kell use adventureworks
select * from adventureworks.contact where adventureworks.contact.FirstName in (Select fn from HAtemp.eredmenytabla); -- ehhez nem mert az adatbazis.tablanev.oszlop névre hivatkozok.
