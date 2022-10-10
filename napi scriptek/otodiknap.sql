create database ateadatbázisneved;

CREATE TABLE valamilyenujtablanev SELECT * FROM contact;
-- exakt példa
create database HAtemp;
CREATE TABLE HAtemp.hacontact SELECT * FROM adventureworks.contact;
select * from HAtemp.hacontact;


-- ----------------------------------------------------------------------------

-- DELETE 

select count(*) from HAtemp.hacontact; -- 19972 sor 19861
select count(*) from HAtemp.hacontact where YEAR(HAtemp.hacontact.ModifiedDate) >= 2004; -- 7111

-- Selecttel mindig ellenőrizd amit törölni akarsz, és számold is meg.
-- általában a where feltétel mögött egyedi ID szűrünk
-- timestamp oszlopok
-- CreatedDate, ModifiedDate, DeletedDate

-- törölöm az összes 2004-ben és után módosított contactot
delete from HAtemp.hacontact
where YEAR(HAtemp.hacontact.ModifiedDate) >= 2004; 

-- ----------------------------------------------------------------------------

-- UPDATE
-- Az EmailPromotion értéke legyen 9 ahol nincs középső név (MiddleName)

-- ellenőrzés előtte
select count(*) from HAtemp.hacontact where MiddleName is null; -- 5473

update HAtemp.hacontact
set EmailPromotion = 9
where MiddleName is null;

-- ModifiedDate értékével együtt, hogy konzisztens maradjon az adatbázis
update HAtemp.hacontact
set	EmailPromotion = 9,
	ModifiedDate = now()
where MiddleName is null;

-- javítsuk vissza az eredeti EmailPromotion értékét az eredeti táblából
-- ez az összes sort módosítja mivel nincs where feltétel

UPDATE HAtemp.hacontact -- 12861
inner JOIN adventureworks.contact ON -- 19972 ennyi van a aw.contact táblában
    HAtemp.hacontact.ContactID = adventureworks.contact.ContactID
SET
    HAtemp.hacontact.EmailPromotion  = adventureworks.contact.EmailPromotion,
    HAtemp.hacontact.ModifiedDate = now();

-- ----------------------------------------------------------------

-- csak azokat ahol a két táblában eltérő az érték
UPDATE HAtemp.hacontact -- 12861
inner JOIN adventureworks.contact ON -- 19972 ennyi van a aw.contact táblában
    HAtemp.hacontact.ContactID = adventureworks.contact.ContactID
SET
    HAtemp.hacontact.EmailPromotion = adventureworks.contact.EmailPromotion,
    HAtemp.hacontact.ModifiedDate = now()
WHERE HAtemp.hacontact.EmailPromotion != adventureworks.contact.EmailPromotion;

-- UGYANAZ csak hasonlóan mint a selectnél a FROM után (UPDATE után) felsoroljuk a táblákat és a WHERE feltételben adjuk meg a JOIN ON utáni feltételt.

UPDATE HAtemp.hacontact, adventureworks.contact
SET	HAtemp.hacontact.EmailPromotion = adventureworks.contact.EmailPromotion,
	HAtemp.hacontact.ModifiedDate = now()      
WHERE (HAtemp.hacontact.ContactID = adventureworks.contact.ContactID)
	AND (HAtemp.hacontact.EmailPromotion != adventureworks.contact.EmailPromotion)
;

-- ----------------------------------------------------------------
-- INSERT 

-- előkészítés
create table HAtemp.hac2 (
	id int auto_increment primary key,
    nev nvarchar(100),
    teloszam varchar(25)
);

select * from HAtemp.hac2;
truncate HAtemp.hac2;


insert into HAtemp.hac2 (nev, teloszam) 
	values ('Brown','555-1010'),('Black','554-1020');
 
-- ------------------------------------------------------
 
INSERT INTO HAtemp.hac2 (nev, teloszam) 
SELECT 
   concat(HAtemp.hacontact.Firstname, ' ', HAtemp.hacontact.Lastname),
   HAtemp.hacontact.Phone
FROM 
   HAtemp.hacontact
WHERE HAtemp.hacontact.MiddleName is null
;    


-- Hogy tudjuk lekérdeni, hogy az egyik táblában benne van a másikban nincs
-- hogy tudnánk felvenni a hiányzó sorokat az új táblába

select * from HAtemp.hacontact;
select * from adventureworks.contact;


SELECT ContactID FROM adventureworks.contact t1
  WHERE NOT EXISTS (SELECT 1 FROM HAtemp.hacontact t2 WHERE t1.ContactID = t2.ContactID);

insert into HAtemp.hacontact (`ContactID`,  `NameStyle`,
  `Title`,  `FirstName`,  `MiddleName`,  `LastName`,   `Suffix`,  `EmailAddress`,  `EmailPromotion`,  `Phone`,
  `PasswordHash`,  `PasswordSalt`,  `AdditionalContactInfo`,  `rowguid`,  `ModifiedDate` )
select `ContactID`,  `NameStyle`,
  `Title`,  `FirstName`,  `MiddleName`,  `LastName`,   `Suffix`,  `EmailAddress`,  `EmailPromotion`,  `Phone`,
  `PasswordHash`,  `PasswordSalt`,  `AdditionalContactInfo`,  `rowguid`,  `ModifiedDate`
from adventureworks.contact
where adventureworks.contact.ContactID IN 
			( SELECT ContactID FROM adventureworks.contact t1
		WHERE NOT EXISTS (SELECT 1 FROM HAtemp.hacontact t2 WHERE t1.ContactID = t2.ContactID) )
;

