select c.FirstName, c.LastName, soh.* 
from salesorderheader soh
-- inner join 
right join contact c on soh.ContactID = c.ContactID
--                           FK				PK
-- where soh.ContactID = 378
order by soh.SalesOrderID;

--  ------------------------------------------

select c.FirstName, c.LastName, soh.*
from contact c
left join salesorderheader soh on soh.ContactID = c.ContactID
-- inner join salesorderheader soh on soh.ContactID = c.ContactID;
--                           		FK				PK
order by soh.SalesOrderID;

-- drop view if exists v_HA_allsales;
-- create or replace view v_HA_allsales as
select 	concat(c.FirstName, ' ' ,c.LastName) as CustomerName,
		soh.OrderDate, soh.SalesOrderID, SalesOrderNumber,
        p.Name as ProductName,
		sod.OrderQty, sod.UnitPrice, sod.UnitPriceDiscount, sod.LineTotal,
        case year(soh.orderdate) 
			when 2001 then 'nyúl éve'
            when 2002 then 'kacsa éve'
			else 'masik állat éve'
			end as kinaiev
from salesorderheader soh
inner join salesorderdetail sod on soh.SalesOrderID = sod.SalesOrderID
inner join contact c on soh.ContactID = c.ContactID
inner join product p on sod.ProductID = p.ProductID
;

select * from v_HA_allsales;
