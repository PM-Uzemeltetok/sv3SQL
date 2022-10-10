/*
Cégünk kiállításra viszi a legdrágább bicikliket amit csak a termékpalettából össze lehet állítani kiegészítőkkel együtt. Készítsd el a "kiállított darab tartalmazza" listát.

1. legdrágább túra biciklit
2. alkategóriánként legdrágább kiegészítőket (Accessories) (nevüket és listaárukat)
3. legdrágább férfi L-es ruhaösszeállítást (alkategóriánként 1-1, minden férfi ami nem 'woman')
Mivel minden tétel a product táblából van ezért a táblázat tartalmazza a:

productcategory nevet
productsubcategory nevet
termék (product) nevét
termék számát (productnumber)
listaárát (ListPrice)
bekerülési költségét (StandardCost)
Hogy egészítenéd ki a lekérdezést, hogy a bicikli típus és a ruhatár neme választható legyen (pl: Mountain Bike, női ruhatárral (esetleg más méretel) és top kiegészítőkkel)

*/
use adventureworks;

-- 1.
 
where p.ListPrice = (select max(ListPrice) from product p2 where p2.productsubcategoryID = psc.productsubcategoryID)
and p.ProductSubcategoryID = 3

UNION -- minden azonos tétel 1x szerepel 
-- UNION ALL - minden tétel szerepel benne

-- 2     
select 	psc.name as productsubcategoryname
		,pc.name as productcategory
		,p.Name, p.ProductNumber, p.ListPrice, p.StandardCost
from product p
join productsubcategory psc on p.ProductSubcategoryID = psc.ProductSubcategoryID
join productcategory pc on pc. ProductCategoryID = psc.ProductCategoryID  
where pc.name = 'Accessories' and listprice = (SELECT MAX(ListPrice) FROM product p2
            WHERE p2.productsubcategoryID = psc.productsubcategoryID )
            
UNION -- minden azonos tétel 1x szerepel 
-- UNION ALL - minden tétel szerepel benne

-- 3            
select 	psc.name as productsubcategoryname
		,pc.name as productcategory
		,p.Name, p.ProductNumber, p.ListPrice, p.StandardCost
from product p
join productsubcategory psc on p.ProductSubcategoryID = psc.ProductSubcategoryID
join productcategory pc on pc. ProductCategoryID = psc.ProductCategoryID              
where pc.name = 'Clothing' and p.size like 'L' and p.name not like '%Women%' and listprice = (SELECT MAX(ListPrice) FROM product p2 
            WHERE p2.productsubcategoryID = psc.productsubcategoryID )            
;

/*
-- legdrágább túra biciklit
-- beágyazott
select * from product p
where p.ProductNumber = (select ProductNumber from product where  ProductSubcategoryID = 3 order by ListPrice desc limit 1);

-- korrelált lekérdezés
select * from product p
where p.ListPrice = (select max(ListPrice) from product where product.productsubcategoryID = psc.productsubcategoryID);


-- alkategóriánként legdrágább kiegészítőket (Accessories) (nevüket és listaárukat)
-- korrelált lekérdezés

where pc.name = 'Accessories' and listprice = (SELECT MAX(ListPrice) FROM product
            WHERE product.productsubcategoryID = psc.productsubcategoryID )

-- legdrágább férfi L-es ruhaösszeállítást (alkategóriánként 1-1, minden férfi ami nem 'woman')
-- korrelált lekérdezés

where pc.name = 'Clothing' and p.size like 'L' and p.name not like '%Women%' and listprice = (SELECT MAX(ListPrice) FROM product
            WHERE product.productsubcategoryID = psc.productsubcategoryID )
*/