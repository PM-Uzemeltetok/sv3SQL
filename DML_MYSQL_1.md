# DML

## Adatok módosítása, felvitele adattáblába

Adatokat nem csak lekérdezni, hanem módosítani, törölni stb is szükséges most ezzel fogunk foglalkozni.

# Adatok felvitele

Adatot felvinni az INSERT paranccsal tudunk egy már meglévő táblázatba. A legegyszerűbb verzió, amikor tudjuk a konkrét adatokat amiket fel szeretnénk vinni. Ilyenkor az INSERT VALUES kombináció fogjuk használni. Fontos, hogy a táblára beállítot szabályokat be kell tartani például kötelező mezők, egyedi kulcsok stb. Ezek bertartása mellet viszont nem vagyunk kötelesek minden egyes mezőt kitölteni adatfelvitelkor épp ezért az INSERT részben meg kell adni a mezőket ahova adatot szeretnék felvinni és a VALUES részben a konkrét adatokat. Lehetőségünk van egyszerre több adatot is felvinni akkor a VALUES részen a következő rekordnak új zárójelet nyitunk és már írhatjuk is az adatokat. Ha több adatot is be akarunk illeszteni akkor a zárójel bezárása után vesszőt kell rakni jelezve hogy itt a vége a rekordnak.

Szintaktikailag a következőképpen néz ki.  
INSERT táblanév (mező1, mező2,mező3)  
VALUES ('érték1', 'érték2', 'érték3'),  
		('érték4', 'érték5', 'érték6')  

Nézzünk egy konkrét példát. Szeretnék egy új kategóriát létrehozni a ProductCategoryID táblázatban és itt pár fontos dologra oda is kell figyelnünk. Ebben a táblázatban a ProductCategoryID egy automatikusan generált egyedi érték ezért nekünk ide nem kell sőt nem is szabad értéket megadnunk. A másik speciális mezőnk ebben a táblázatba a rowguid, aminek pedig függvénnyel kell értéket kérnünk mivel ez az ID az egész világon egyedi. Ilyen értéket a NEWID függvénnyel kérhetünk. A modifiedDate mezőbe pedig egyszerűbb függvényt használni mint begépelni, ráadásul a csalásokat is szeretnénk elkerülni ezért a now() függvényt használjuk.  
A példánk pedig a következőképpen néz ki.  

```sql
INSERT Production.ProductCategory (Name,rowguid,ModifiedDate)
VALUES ('Swords', NEWID(), now())
```  
### Lekérdezés eredménye egy másik már létező táblázatba  

Az Insert után megadjuk a tábla és a mezők nevét, majd a select részben meghatározzuk, hogy mely mezők adatait szeretnénk ebbe a táblázatba beleírni. A select lehet akár egy nagyon bonyolult összetett lekérdezés is.  
Az **INSERT** után szereplő tábla adattípusainak és a tábla egyéb feltételeinek megfelelő értéket adjon a lekérdezésünk.

A szintaktika a következőképpen néz ki.  
INSERT #táblanév (mező1, mező2, mező3)  
SELECT (forrásmező1, forrásmező2, forrásmező3)  
FROM forrástábla  

### Select tartalma nem létező táblába - pl tábla másolás(backup), eredményhalmaz feldolgozás 

Ha nem létezne még a táblázatunk ahova szeretnénk egy lekérdezés eredményét eltárolni erre is van lehetőség. Ilyenkor azonban az SQL fogja automatikusan beállítani a táblázatunk mezőit és ad neveket a mezőknek. Ennek a szintaktikája a következőképpen néz ki.  

CREATE TABLE táblanév    
SELECT (forrásmezői1, forrásmező2, forrásmező3)  
FROM forrástábla  

Itt is igaz hogy a SELECT lehet egy nagyon bonyolult lekérdezés is. **Az adott nével nem lehet tábla az adatbázisunkban.**  

```sql
-- -----------------------
INSERT INTO table(c1,c2,...)
VALUES 
   (v11,v12,...),
   (v21,v22,...),
    ...
   (vnn,vn2,...);

SHOW VARIABLES LIKE 'max_allowed_packet'; --ennyi új rekordot tartalmazhat 1 insert tranzakció

INSERT INTO table_name(column_list)
SELECT 
   select_list 
FROM 
   another_table
WHERE
   condition;
-- -----------------------

CREATE TABLE ujtabla SELECT column1, column2, columnx FROM regitabla;

INSERT INTO table_name(field1, field2, field3)
VALUES 	( Select valami from valahonnan ),
		( Select valami from valahonnan ),
		( Select valami from valahonnan )
```

---  


# Adatok módosítása

Egy táblázatba nem csak új adatokat kell felvinnünk, hanem azokat módosítani is tudunk kell erre szolgál az UPDATE parancs. Ezzel lehetőségünk van megadott feltétel vagy feltételek alapján egy adatot módosítani.
Szintaktikailag a következőképpen néz ki.

UPDATE tablanev 
SET mezőnév = érték  
WHERE felvétel   

```sql
update tablename 
set col1 = value1,
	col2 = value2,
	...
where .....;


UPDATE tablenameA 
SET 
    columnname = (SELECT valami FROM tableb WHERE kifejezés) -- 1 érték
WHERE
    tableA ..... ;
```

### update másik tábla adataiból 

```sql
UPDATE tableA a
INNER JOIN tableB b ON a.name_a = b.name_b
SET 'tablaA column' = 'tableB column'
-- where clause can go here

UPDATE [table1_name] AS t1 
INNER JOIN [table2_name] AS t2 ON [t1.column1_name] = t2.[column1_name] 
SET t1.[column2_name] = [t2.column2_name];

-- több adatbázis között
UPDATE dbname1.content targetTable

LEFT JOIN dbname2.someothertable sourceTable ON
    targetTable.compare_field= sourceTable.compare_field
SET
    targetTable.col1  = sourceTable.cola,
    targetTable.col2 = sourceTable.colb, 
    targetTable.col3 = sourceTable.colc, 
    targetTable.col4 = sourceTable.cold   

```

# Adatok törlése

Természetesen törölnünk is kell rekordokat erre szolgál a DELETE parancs, aminek meg kell adnunk az érintett tábla nevét és a feltételt amelynek megfelelő rekordokat törölni szeretnénk. Gyakorlati példaként én a Kardok kategóriát szeretném törölni.  

```sql
DELETE FROM táblanév
WHERE feltétel
```
Ritkán ugyan, de szükség van arra, hogy egy táblázat összes rekordját töröljük. Ezt a TRUNCATE TABLE paranccsal tehetjük meg. NE FUTTASD LE hacsak nem hoztál létre külön táblázatot játszani. 
