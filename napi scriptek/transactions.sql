-- előkészület
create database transactiondemo;
use transactiondemo;
create table szamla (
	id int auto_increment primary key,
    nev nvarchar(50),
    szamlaszam nvarchar(20),
    osszeg int
);
insert into szamla (nev,szamlaszam,osszeg)
values ('Juli','0000-000-0001', 200),
('Marcsi','0000-000-0002', 300);
select * from szamla;

-- aktuális kapcsolatom ID-ja
select connection_id();

-- aktuális userem amivel csatlakozom
select current_user();

-- csatlakozott userek
SELECT SUBSTRING_INDEX(host, ':', 1) AS host_short,
       GROUP_CONCAT(DISTINCT user) AS users,
       COUNT(*) AS threads
FROM information_schema.processlist
GROUP BY host_short
ORDER BY COUNT(*), host_short;


-- SHOW FULL PROCESSLIST;
-- SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
show variables like '%isola%';
-- kill 438;

SET autocommit=1; -- autocommit
SET autocommit=0; -- nincs autocommit (automatikusan tranzakciót nyit) - saját sessionben

--  ---------------------------------------------------------------------------
use transactiondemo;

SELECT @@global.transaction_ISOLATION;

insert into szamla (nev,szamlaszam,osszeg)
values ('Juli','0000-000-0001', 200);

update szamla set szamlaszam = '1111-2222-3333' where id = 2;

-- egyszerre nem ment mert izolációs szintet sért.

select * from szamla;

start transaction;
set @ertek = 200;
set @id = 1;
-- insert into szamla (nev,szamlaszam,osszeg) values ('Béla','0000-000-0033', 1000);

select osszeg from szamla where id = @id into @szamlaosszeg;
update szamla set osszeg = osszeg - @ertek where id = 1;
update szamla set osszeg = osszeg + @ertek where id = 2;

-- autocommit;
-- commit;
-- rollback;

-- --------------------------------------------------------
-- drop procedure utalas;

DELIMITER $$
CREATE PROCEDURE utalas (IN ertek int, id1 int, id2 int)
BEGIN
	start transaction;
		select osszeg from szamla where id = id1 into @szamlaosszeg;
		select @szamlaosszeg, ertek as ennyitvonnankle;
		update szamla set osszeg = osszeg - ertek where id = id1;
		update szamla set osszeg = osszeg + ertek where id = id2;

	if @szamlaosszeg < @ertek
	then rollback;
	else commit;
	end if;
END$$
DELIMITER ;

Call utalas (10000,2,1);
select * from szamla;
