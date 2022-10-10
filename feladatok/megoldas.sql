-- 1 a/b.


SELECT 
    soh.ContactID,
    CONCAT(c.Firstname, ' ', c.LastName) CustomerName,
    -- FORMAT(SUM(soh.TotalDue), 2) TotalOrder -- stringet ad vissza, de olvashatóbb
    -- TRUNCATE(SUM(soh.TotalDue), 2) TotalOrder
    ROUND(SUM(soh.TotalDue), 2) TotalOrder
FROM
    salesorderheader soh
        JOIN
    contact c ON soh.ContactID = c.ContactID
WHERE
    OrderDate BETWEEN 20010701 AND 20021231
GROUP BY c.ContactID, CONCAT(c.Firstname, ' ', c.LastName)
HAVING SUM(TotalDue) >= 8000
ORDER BY SUM(soh.TotalDue) DESC
LIMIT 10;

-- 2

-- korrelált lekérdezéssel

-- outer
SELECT SOH.SalesOrderID, CONCAT(P.Firstname,' ',P.Lastname) AS CustomerName, SOH.TotalDue, SOH.ContactID
FROM salesorderheader AS SOH
INNER JOIN contact P ON SOH.ContactID = P.ContactID
where SOH.ContactID = 15; 

-- contactid-val kötöm össze a külső és belső selecteket
-- mivel ugyanaz a tábla ezért alias használata kötelező

-- inner
select contactid, MAX(TotalDue) 
from salesorderheader
where ContactID = 15
group by contactid;
 
SELECT SOH.SalesOrderID, SOH.DueDate, CONCAT(P.Firstname,' ',P.Lastname) AS CustomerName, SOH.TotalDue, SOH.ContactID
FROM salesorderheader AS SOH
INNER JOIN contact P ON SOH.ContactID = P.ContactID
WHERE SOH.Totaldue = (
        SELECT MAX(TotalDue)
        FROM salesorderheader SOH2
        WHERE SOH.ContactID = SOH2.ContactID AND OrderDate BETWEEN  '2001.04.01' and '2002.12.31' -- --'2012-07-01' AND '2013-12-31'
) AND OrderDate BETWEEN  '2001.04.01' and '2002.12.31'
ORDER BY SOH.TotalDue DESC, SOH.DueDate DESC, SOH.ContactID ASC;

-- másik megoldás havinggel

select
    concat(contact.FirstName, ' ', contact.LastName) as CustomerName,
    max(TotalDue) as HighestValuePurchase,
    sh.SalesOrderID,
    sh.DueDate
from
    salesorderheader as sh
    join contact on sh.ContactID = contact.ContactID
group by
    sh.ContactID, sh.SalesOrderID
having
    (select max(TotalDue) from salesorderheader where ContactID = sh.ContactID and OrderDate between '2001-04-01' and '2002-12-31') = HighestValuePurchase
order by
   sh.TotalDue DESC, sh.DueDate DESC, sh.ContactID ASC
   -- sh.ContactID
;

-- 3

SELECT	SOH.CustomerID, COUNT(SOH.CustomerID) AS 'Vásárlások száma',
		SOD.ProductID, SUM(SOD.OrderQty) AS 'Vásárolt mennyiség'
FROM salesorderheader SOH
INNER JOIN salesorderdetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY SOH.CustomerID, SOD.ProductID
ORDER BY 4 DESC;

-- 4

-- megoldás 1
SELECT 	CONCAT(P.Firstname,' ',P.Lastname) AS CustomerName,
		YEAR(DueDate) AS 'Ev',
		SUM(SOH.TotalDue) AS 'Forgalom'
FROM salesorderheader AS SOH
INNER JOIN contact P ON SOH.ContactID = P.ContactID
WHERE YEAR(SOH.DueDate) IN (2001,2002,2003)
GROUP BY CONCAT(P.Firstname,' ',P.Lastname), YEAR(DueDate)
HAVING SUM(SOH.TotalDue) < 4000
ORDER BY SUM(SOH.TotalDue) DESC, CONCAT(P.Firstname,' ',P.Lastname) ASC
LIMIT 10;

-- megoldás 2 eredményhalmazon
with forgalmak as (
    select
      concat(contact.FirstName, ' ', contact.LastName) as CustomerName,
      year(DueDate) as Ev,
      sum(TotalDue) as Forgalom
    from
      salesorderheader
      join contact on salesorderheader.ContactID = contact.ContactID
    where year(DueDate) in (2001,2002,2003)
    group by
      CustomerName,
      Ev
  )
select * from forgalmak where Forgalom < 4000 order by Forgalom desc, CustomerName asc limit 10;