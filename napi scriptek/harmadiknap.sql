use adventureworks;
-- -------------------------------------------------------------------------------------------------
-- 4. feladatsor 


-- 8. feladat

--                    ezt adja vissza ha c.Middlename nem null                 ezt ha null
select 	coalesce( concat(c.FirstName, ' ', c.MiddleName,' ', c.Lastname),  concat(c.FirstName, ' ', c.Lastname) ) 
		,concat(c.FirstName, ' ', coalesce( concat(c.MiddleName, ' ') , '' ) , c.LastName ) as CustomerName
		,soh.OrderDate, soh.SalesOrderID, SalesOrderNumber
        ,p.Name as ProductName
		,sod.OrderQty, sod.UnitPrice, sod.UnitPriceDiscount, sod.LineTotal
from salesorderheader soh
inner join salesorderdetail sod on soh.SalesOrderID = sod.SalesOrderID
inner join contact c on soh.ContactID = c.ContactID
inner join product p on sod.ProductID = p.ProductID
-- where c.contactid = 1
;

-- concat/coalesce - javítandó
-- concat(c.FirstName, ' ', coalesce(c.MiddleName, '' , concat(c.MiddleName,' ','.') ), c.LastName) as CustomerName

-- így jó:
-- concat(c.FirstName, ' ', coalesce( concat(c.MiddleName, ' ') , '' ) , c.LastName ) as CustomerName

select * from contact
where MiddleName is null;

-- -------------------------------------------------------------------------------------------------
-- 9. feladat
-- Kérdezd le, hogy melyik termékekből mennyit és milyen értékben vásároltak (ki vásárolta)

-- where year(orderdate) = 2001 and month(orderdate) = 9
-- 2001. szeptermberében és 

-- rendezd rendelési érték majd a rendelési mennyiség végül a vásárló neve szerinti sorrendbe.
-- 
--  A lekérdezés ne tartalmazza a 10 dollárnál olcsóbb termékeket --where / having 
--  valamint azokat a rendeléseket, amiknél (összesen) kevesebb mint 3 darabot rendeltek az adott termékból. --where / having

select 	coalesce( concat(c.FirstName, ' ', c.MiddleName,' ', c.Lastname),  concat(c.FirstName, ' ', c.Lastname) ) as CustomerName  
		,p.name
        ,sum(sod.OrderQty) as rendelesimennyiseg
        ,round(sum(sod.Linetotal),2) as osszertek
from salesorderheader soh
inner join salesorderdetail sod on soh.SalesOrderID = sod.SalesOrderID
inner join contact c on soh.ContactID = c.ContactID
inner join product p on sod.ProductID = p.ProductID

where 	(year(soh.orderdate) = 2001 and month(soh.orderdate) = 9) -- 2001. szeptermberében és 
		 and (sod.UnitPrice > 10) --  A lekérdezés ne tartalmazza a 10 dollárnál olcsóbb termékeket
         
group by  coalesce( concat(c.FirstName, ' ', c.MiddleName,' ', c.Lastname),  concat(c.FirstName, ' ', c.Lastname) ), p.name
having  sum(sod.OrderQty) >= 3 --  valamint azokat a rendeléseket, amiknél kevesebb mint 3 darabot rendeltek az adott termékból.

-- rendezd rendelési érték majd a rendelési mennyiség végül a vásárló neve szerinti sorrendbe.
order by osszertek, rendelesimennyiseg, CustomerName
-- order by  CustomerName, p.name, osszertek desc -- más rendezéssel
;

-- ---------------------------------------------------------------------------------

select * from productsubcategory;
select count(*) from productsubcategory;
select * from productcategory;

select 	psc.name as productsubcategoryname
		,pc.name as productcategory
		,p.* 
from product p
join productsubcategory psc on p.ProductSubcategoryID = psc.ProductSubcategoryID
join productcategory pc on pc. ProductCategoryID = psc.ProductCategoryID
;

-- -------------------------------------------------------------------------------------------

-- 3. feladat
-- Számold meg hogy az egyes termékkategóriákba hány termékalkategória tartozik.

select
  productcategory.Name as Category,
  count(productsubcategory.Name) as Subcategories
from
  productcategory
  inner join productsubcategory on productcategory.ProductCategoryID = productsubcategory.ProductCategoryID
group by
  Category;
  
-- 4. Számold meg hogy az egyes termékalkategóriákban hány termék tartozik.
select
  productsubcategory.Name as Category,
  count(product.Name) as NumberOfProducts
from
  product
  inner join productsubcategory on product.ProductSubcategoryID = productsubcategory.ProductSubcategoryID
group by
  Category;

-- 4. feladat ellenőrzés (Chain - 1db)  
Select * from product where productsubcategoryID = 7;


-- 6. feladat megoldása
select 	psc.name as productsubcategoryname
		,pc.name as productcategory
		,p.* 
from product p
left join productsubcategory psc on p.ProductSubcategoryID = psc.ProductSubcategoryID
left join productcategory pc on pc. ProductCategoryID = psc.ProductCategoryID
;

-- Kérd le, hogy melyik customerid-val milyen productID-jú termékből mennyit rendeltek. (SalesorderHeader, SalesOrderDetail)

select soh.customerid, sod.productid, sum(sod.OrderQty)
from salesorderheader soh
inner join salesorderdetail sod on soh.SalesOrderID = sod.SalesOrderID
group by soh.customerid, sod.productid;

-- kiegészítve nevekkel a csatolt táblákból
select 	coalesce(concat(c.FirstName, ' ', c.MiddleName,' ', c.Lastname),  concat(c.FirstName, ' ', c.Lastname) ) as CustomerName  
		,p.name
		,sum(sod.OrderQty)
from salesorderheader soh
inner join salesorderdetail sod on soh.SalesOrderID = sod.SalesOrderID
inner join contact c on soh.ContactID = c.ContactID
inner join product p on sod.ProductID = p.ProductID
group by 1, 2
order by 3 desc;

-- Mario megoldása
select
  salesorderheader.ContactID as CID,
  salesorderdetail.ProductID as ProductID, 
  sum(salesorderdetail.Orderqty) as Itemsqty
from
  salesorderdetail
  inner join salesorderheader on salesorderdetail.SalesOrderID = salesorderheader.SalesOrderID
group by
  CID, ProductID
  order by 3 desc;

  -- Keresd meg hogy mennyibe kerül a legolcsóbb és legdrágább termék az egyes termékalkategóriákban és 
-- innen nehéz: (mi a nevük - termék neve).

select p.ProductSubcategoryID, max(p.listprice) 
from product p
group by p.ProductSubcategoryID;

select p.ProductSubcategoryID, min(p.listprice) 
from product p
group by p.ProductSubcategoryID;

-- Keresd meg hogy mennyibe kerül a legolcsóbb és legdrágább termék az egyes termékalkategóriákban és 
-- innen nehéz: (mi a nevük - termék neve).

-- az eleje 
select p.ProductSubcategoryID, max(p.listprice), min(p.listprice)
from product p
group by p.ProductSubcategoryID;

-- az eleje nevekkel
select psc.ProductSubcategoryID, psc.name as pscname, max(p.listprice) 
from product p
left join productsubcategory psc on p.ProductSubcategoryID = psc.ProductSubcategoryID
group by psc.ProductSubcategoryID, psc.name
order by 1;

-- --------------------------------------------------------------------
-- sub query, beágyazott lekérdezés

SELECT 	productsubcategory.productsubcategoryID
		, productsubcategory.productcategoryID
        -- belső (inner query) lekérdezés hivatkozik a külső lekérdezés értékeire
		, (SELECT MAX(ListPrice) FROM product
            WHERE product.productsubcategoryID = productsubcategory.productsubcategoryID ) as maxprice	
		, (SELECT min(ListPrice) FROM product
            WHERE product.productsubcategoryID = productsubcategory.productsubcategoryID ) as minprice
		-- --------------------------------------
FROM productsubcategory;