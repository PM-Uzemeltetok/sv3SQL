use adventureworks;


set @variable = 3;
SELECT ProductID, Color as szin, 4 as negy, @variable
FROM product;


-- WHERE

SELECT ProductID, Color as szin, 4 as negy
FROM product
WHERE color not in ('blue', 'black');

SELECT ProductID, Color, ListPrice
FROM product
WHERE color like "%ilv%";

SELECT ProductID, Color, ListPrice
FROM product
WHERE size = 'L';

SELECT ProductID, Color, ListPrice as lp
FROM product
WHERE ListPrice > 20
order by lp;

-- case / when

SELECT ProductID, Color, ListPrice
FROM product
WHERE ListPrice between 60 and 200;

SELECT P.ProductID, P.Name,
	CASE P.Color WHEN 'Blue' THEN 'Kék'
				 WHEN 'Red' THEN 'Piros'
				 WHEN 'Silver' THEN 'Ezüst'
				 WHEN 'Black' THEN 'Fekete'
				 ELSE 'N/A'
				 END as Szín
FROM product P;

-- visszadhatunk oszlopot is értkéként

Select Productline,
	CASE
		when (Productline = 'R') THEN Color
		when (Productline = 'M') THEN Size
		when (Productline = 'T') THEN Class
		else Name	
	end as Valami,
	ProductID
from product; 

SELECT P.ProductID, P.Name, P.Color, IF(P.Color="Blue", P.ListPrice, P.StandardCost) keke
FROM product P;


-- egyedi értékek

Select distinct color, size from product
order by 2; -- oszlop sorszáma szerinti sorrend

Select name, color, size
from product
order by ProductID; 


-- nem csak select utáni mezőkre tudunk rendezni és szűrni

Select name, color, size
from product
order by name;

--  
--  Adattípus konverzió
SELECT P.Name, P.Size, CAST(P.size AS decimal) sizeint
FROM product P;

-- szövegfüggvények

Select lower(name), upper(color), size
from product
order by name;

Select concat(name, ' ', color) nevszin, size
from product
order by name;

Select P.name, REPLACE(P.name,' ','_') nevszin, size
from product P
order by name;

-- numerikus függvények

Select listprice, round(listprice,1), floor(listprice), ceiling(listprice)
from product
where listprice > 0;


-- dátum függvények

Select SellStartDate, year(SellStartDate), month(SellStartDate), day(SellStartDate),
hour(SellStartDate), date(SellStartDate), time(SellStartDate)
from product
where year(SellStartDate) = 2001;

Select SellStartDate, adddate(SellStartDate, interval 2 year),
		adddate(SellStartDate, interval 3 month)
from product
-- where year(SellStartDate) = 2001
;

Select SellStartDate, adddate(SellStartDate, interval 2 hour),
		adddate(SellStartDate, interval 3 minute)
from product
-- where year(SellStartDate) = 2001
;

Select SellStartDate, adddate(SellStartDate, interval 2 hour),
		adddate(SellStartDate, interval 3 minute)
from product
-- where SellStartDate = '2001.07.01'
where SellStartDate = makedate(2001, 182)
;

SELECT DATEDIFF("2017-06-25", "2017-06-15");

SELECT DAYOFWEEK("2022-09-06"), dayofyear(now()) , dayname(now());
select makedate(2001, 182);
select now();
select date_format(now(),'%y-%Y');

-- show collation where Charset = 'latin1';

-- ---------------------------------------------------
-- null kezelés

select coalesce(color, 'nincs megadva') from product;

SELECT P.Name, P.Color, CONCAT (COALESCE(P.name, 'név?'), '-', COALESCE(P.Color, 'szín?'))  as 'termék és szín'
FROM product P
order by 3;

SELECT P.Name, P.Weight, ifnull(P.weight, '2')
FROM product P;

select name, color, nullif(color,'Blue')
from product
where color in ('Black', 'Blue');

-- feladatmegoldások

select name,  if(SellEndDate is not null, 'áruljuk', 'nem áruljuk') as 'áruljuk/' from product;

select * from product 
where ( ListPrice != 0 ) and (color = 'Blue')
order by ListPrice desc
limit 30 offset 20;

-- Kérdezd le azokat a rendelésazonosítókat amiket 2003.03.10 és 2003.03.20. között rendeltek.

select * from salesorderheader as soh 
where OrderDate between '2003-03-10' and '2003-03-20';