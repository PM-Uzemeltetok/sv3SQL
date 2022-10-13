## Product, ProductSubCategory, ProductCategory  
  
1. Kérdezd le a termék és az alkategóriájának nevét. (product, productsubcategory)
2. Kérdezd le az egyes termékkategóriák nevét és  alkategóriáinak nevét. (productsubcategory, productcategory)
3. Kapcsold össze a product - productsubcategory - productcategory táblákat
    * használj aliast a táblákhoz
    * használj aliast az oszlopokhoz
    * készíts viewt a lekérdezésből amely tartalmazza kategóriák és alkategóriák nevét és a termék adatait
4. Kapcsold a **3.** feladat lekérdezéséhez a productlistpricehistory táblát ott ahol a EndDate nem null  
    * egészítsd ki a lekérdezést a termék árával  
    * azokat a termékeket is jelenítsd meg amelyiknek nincs ára  

### group by használattal  

1. Számold meg hogy az egyes termékkategóriákba hány termékalkategória tartozik.
2. Számold meg hogy az egyes termékalkategóriákban hány termék tartozik.
3. Keresd meg hogy mennyibe kerül 
    * a legolcsóbb 
    * a legdrágább  
termék az egyes termék alkategóriákban és mi a nevük.  

---  
## SalesOrderHeader, SalesOrderDetail  

1. Kérdezd le, hogy melyik contactID-val milyen productID-jú termékből mennyit rendeltek. (SalesorderHeader, SalesOrderDetail)
2. Kérdezd le hogy vásárlók rendeléseit. Szerepeljen benne a SalesorderID rendelt termék neve éshogy mennyit rendelt valamint vásárlók neve(Firstname, middlename, lastname).  (contact, salesorderdetail, salesorderheader, product)
3. Kérdezd le, hogy melyik termékekből mennyit és milyen értékben vásároltak 2001. szeptermberében és rendezd rendelési érték majd a rendelési mennyiség végül a vásárló neve szerinti sorrendbe. 
    * A lekérdezés ne tartalmazza a 10 dollárnál olcsóbb termékeket valamint azokat a rendeléseket, amiknél kevesebb mint 3 darabot rendeltek az adott termékból.

---   
## Öszetett
1. Kérdezd le melyik *termékalkategória* volt a legsikeresebb darabszám szerint (OrderQty) (salesorderdetail (ProductID))
    * a 2001-es évben (salesorderheader (OrderDate))
    * csak a legjobb 5-öt jelenítsd meg
1. Kérdezd le melyik *termékkategória* volt a legsikeresebb összeg szerint (salesorderdetail (ProductID))
    * III. negyedévben (salesorderheader (OrderDate)) 
    * csak a legjobb 5-öt jelenítsd meg    
