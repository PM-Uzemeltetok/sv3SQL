## Product, ProductSubCategory, ProductCategory  
  
1. Kérd le a termék és az alkategóriájának nevét. (product, productsubcategory)
2. Kérd le az egyes termékkategóriák nevét és  alkategóriáinak nevét. (productsubcategory, productcategory)
3. Számold meg hogy az egyes termékkategóriákba hány termékalkategória tartozik.
4. Számold meg hogy az egyes termékalkategóriákban hány termék tartozik.
5. Keresd meg hogy mennyibe kerül a legolcsóbb és legdrágább termék az egyes termékalkategóriákban és mi a nevük.
6. Kérdezd le az összes termék nevét, a termékalkategória nevét és a termékkategória nevét. (product, productsubcategory, productcategory)

---  
## SalesOrderHeader, SalesOrderDetail  

7. Kérd le, hogy melyik customerid-val milyen productID-jú termékből mennyit rendeltek. (SalesorderHeader, SalesOrderDetail)
8. Kérdezd le hogy vásárlók rendeléseit. Szerepeljen benne a SalesorderID rendelt termék neve éshogy mennyit rendelt valamint vásárlók neve(Firstname, middlename, lastname).  (contact, salesorderdetail, salesorderheader, product)
9. Kérdezd le, hogy melyik termékekből mennyit és milyen értékben vásároltak 2001. szeptermberében és rendezd rendelési érték majd a rendelési mennyiség végül a vásárló neve szerinti sorrendbe. A lekérdezés ne tartalmazza a 10 dollárnál olcsóbb termékeket valamint azokat a rendeléseket, amiknél kevesebb mint 3 darabot rendeltek az adott termékból.
