### Kupon feladat
Áruházunk kuponokat oszt legjobb vevőinek a 2004-es évre (2003-es összforgalom alapján)  

- Gyémánt vevők 1-5 : 10%-os kedvezmény  
- Arany vevők 6-50 : 8%-os kedvezmény  
- Ezüst vevők 51-200 : 5%-os kedvezmény  
- Bronz vevők 201-500 : 2%-os kedvezmény  

Amire kiváncsi vagyok:  
- melyik vevő melyik kategóriába tartozik  
- Hogy alakulna a 2004-es forgalom a kedvezmények levonása után egy-egy vevő esetében (ID alapján hasonlítsa össze)  
- Hogy alakulna az összesített forgalom a 2004-es évre.  

```sql
-- 2003-as év forgalama vevőnként
select contactid, sum(TotalDue) from salesorderheader
where year(OrderDate) = 2003
group by contactid
order by 2 desc;
```

### Megoldás
```sql
-- temp tábla segítsével
use adventureworks;

drop table if exists HAvevosorrendtabla;
create temporary table HAvevosorrendtabla (
	cid int,
	szazalek int);
    
--  ellenőrzés
-- select * from HAvevosorrendtabla;
    
insert INTO HAvevosorrendtabla (cid, szazalek) Select base.cid, 10
from (select contactid as cid, sum(TotalDue) from salesorderheader
				where year(OrderDate) = 2003
				group by contactid order by 2 desc) base
limit 5; 

insert INTO HAvevosorrendtabla (cid, szazalek) select base.cid, 8
from (select contactid as cid, sum(TotalDue) from salesorderheader
				where year(OrderDate) = 2003
				group by contactid order by 2 desc) base
limit 45 offset 5; 

insert INTO HAvevosorrendtabla (cid, szazalek) select base.cid, 5
from (select contactid as cid, sum(TotalDue) from salesorderheader
				where year(OrderDate) = 2003
				group by contactid order by 2 desc) base
limit 150 offset 50;

insert INTO HAvevosorrendtabla (cid, szazalek) select base.cid, 2
from (select contactid as cid, sum(TotalDue) from salesorderheader
				where year(OrderDate) = 2003
				group by contactid order by 2 desc) base
limit 300 offset 200; 

insert INTO HAvevosorrendtabla (cid, szazalek) select base.cid, 0
from (select contactid as cid, sum(TotalDue) from salesorderheader
				where year(OrderDate) = 2003
				group by contactid order by 2 desc) base
limit 18446744073709551615 offset 500; 

-- -------------------------------------------------------------------------------------
-- alaptábla

select soh.ContactID, soh.totaldue, st.szazalek
from salesorderheader soh
inner join HAvevosorrendtabla st on soh.ContactID = st.cid
where year(soh.OrderDate) = 2004;

-- -------------------------------------------------------------------------------------
-- teljes feladat megoldás

select 	soh.ContactID,   
		concat(c.Firstname, ' ', c.Lastname),  
        soh.OrderDate,  
		soh.totaldue szumma,   
        st.szazalek discount,  
        case 	when st.szazalek = 10 THEN 'Diamond'  
				when st.szazalek = 8 THEN 'Gold'  
                when st.szazalek = 5 THEN 'Silver'  
                when st.szazalek = 2 THEN 'Bronze'  
				else 'N/a'  
		end as fokozat,
        TRUNCATE(soh.totaldue * (st.szazalek /100) ,2) kedvezmeny,   
        TRUNCATE(soh.totaldue - (soh.totaldue * (st.szazalek /100)),2) kedvezmenyesar        
from salesorderheader soh  
inner join contact c on c.ContactID = soh.ContactID  
inner join HAvevosorrendtabla st on soh.ContactID = st.cid  
where year(soh.OrderDate) = 2004;  

-- -------------------------------------------------------------------------
-- teljes 2004-es forgalom különbség

with eredmenyhalmaz as (
select 	soh.ContactID, 
		concat(c.Firstname, ' ', c.Lastname) as customername,
        soh.OrderDate,
		soh.totaldue szumma, 
        st.szazalek discount,
        case 	when st.szazalek = 10 THEN 'Diamond'
				when st.szazalek = 8 THEN 'Gold'
                when st.szazalek = 5 THEN 'Silver'
                when st.szazalek = 2 THEN 'Bronze'
				else 'N/a'
		end as fokozat,
        TRUNCATE(soh.totaldue * (st.szazalek /100) ,2) kedvezmeny, 
        truncate(soh.totaldue - (soh.totaldue * (st.szazalek /100)),2) kedvezmenyesar      
from salesorderheader soh
inner join contact c on c.ContactID = soh.ContactID
inner join HAvevosorrendtabla st on soh.ContactID = st.cid
where year(soh.OrderDate) = 2004)

select FORMAT(sum(eredmenyhalmaz.szumma),2) as ennyilenne, FORMAT(sum(eredmenyhalmaz.kedvezmenyesar),2) from eredmenyhalmaz;

-- -----------------------------------------------------------------------------------------------------

-- ranking függvénnyel

select ROW_NUMBER() OVER(ORDER BY SUM(TotalDue) DESC) 
    AS rownumber, contactid, sum(totaldue), 
case 
    when ROW_NUMBER() OVER(ORDER BY SUM(TotalDue) DESC) < 6 THEN sum(totaldue)* 0.9
    when (ROW_NUMBER() OVER(ORDER BY SUM(TotalDue) DESC) between 6 and 50) then (select sum(soh2.totaldue) from salesorderheader as soh2 where year(orderdate) = 2004) * 0.92
    when (ROW_NUMBER() OVER(ORDER BY SUM(TotalDue) DESC) between 51 and 200) then sum(totaldue) * 0.95
	when (ROW_NUMBER() OVER(ORDER BY SUM(TotalDue) DESC) between 201 and 500) then sum(totaldue) * 0.98
    else sum(totaldue) 
    end as akciós_ár,
case 
    when ROW_NUMBER() OVER(ORDER BY SUM(TotalDue) DESC) < 6 THEN 'diamond'
    when (ROW_NUMBER() OVER(ORDER BY SUM(TotalDue) DESC) between 6 and 50) then 'gold'
    when (ROW_NUMBER() OVER(ORDER BY SUM(TotalDue) DESC) between 51 and 200) then 'silver'
	when (ROW_NUMBER() OVER(ORDER BY SUM(TotalDue) DESC) between 201 and 500) then 'bronze'
    else 'none'
end as category
from salesorderheader
where year(orderdate) = 2003
    
group by contactid
order by 3 desc
 ;

 -- ------------------------------------------------------------------------------
-- with tábláva

with
    Diamond as 
    (select s.ContactID as ID, sum(s.TotalDue) as CashFlow from salesorderheader as s where year(OrderDate) = 2003 group by s.ContactID order by CashFlow desc limit 5 ),

    Gold as 
    ( select s.ContactID as ID, sum(s.TotalDue) as CashFlow from salesorderheader as s where year(OrderDate) = 2003 group by s.ContactID order by CashFlow desc limit 45 offset 5),

    Silver as
    (select s.ContactID as ID, sum(s.TotalDue) as CashFlow from salesorderheader as s where year(OrderDate) = 2003 group by s.ContactID order by CashFlow desc limit 150 offset 50),

    Bronze as
    (select s.ContactID as ID, sum(s.TotalDue) as CashFlow from salesorderheader as s where year(OrderDate) = 2003 group by s.ContactID order by CashFlow desc limit 300 offset 200), 

    SumOf2004 as
    (select sum(s.TotalDue) as td , s.contactid from salesorderheader as s where year(OrderDate) = 2004 group by s.ContactID)

select
    concat(c.FirstName, ' ', c.LastName) as CustomerName,
    sum(s.TotalDue) as PurchasesIn2003,
    case
        when s.ContactID in (select Diamond.ID from Diamond) then 'Diamond'
        when s.ContactID in (select Gold.ID from Gold) then 'Gold'
        when s.ContactID in (select Silver.ID from Silver) then 'Silver'
        when s.ContactID in (select Bronze.ID from Bronze) then 'Bronze'
        else 'No Coupon'
    end as Tier,
    case
        -- when s.ContactID in (select Diamond.ID from Diamond) then sum(s.TotalDue) * 0.90
        when s.ContactID in (select Diamond.ID from Diamond) then (select td from SumOf2004 as so2 where so2.contactid = s.ContactID) * 0.90
        when s.ContactID in (select Gold.ID from Gold) then sum(s.TotalDue) * 0.92
        when s.ContactID in (select Silver.ID from Silver) then sum(s.TotalDue) * 0.95
        when s.ContactID in (select Bronze.ID from Bronze) then sum(s.TotalDue) * 0.98
        else sum(s.TotalDue)
    end as '2004 %'
from salesorderheader as s
join contact as c on s.ContactID = c.ContactID
where year(s.OrderDate) = 2003
group by s.ContactID
order by CustomerName;
-- --------------------------------------------------------------------------

-- próbálkozások / ellenőrzések
-- 2003-as év forgalama vevőnként
select contactid, sum(TotalDue) from salesorderheader where year(OrderDate) = 2003
group by contactid order by 2 desc;

-- top 5 - gyémánt
select contactid, sum(TotalDue) from salesorderheader where year(OrderDate) = 2003
group by contactid order by 2 desc limit 5;

-- 6-50 - arany
select contactid, sum(TotalDue) from salesorderheader where year(OrderDate) = 2003
group by contactid order by 2 desc limit 45 offset 5;

-- 51- 200. - ezüst
select contactid, sum(TotalDue) from salesorderheader where year(OrderDate) = 2003
group by contactid order by 2 desc limit 150 offset 50;

-- 201-500 - bronz 
select contactid, sum(TotalDue) from salesorderheader where year(OrderDate) = 2003
group by contactid order by 2 desc limit 300 offset 200;
```