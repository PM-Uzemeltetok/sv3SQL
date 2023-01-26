# DQL 1.

### Predikátumok, állítások.
Ezek segítségével is kialakíthatunk feltételeket , tehetünk állításokat vagy szűrhetünk. Ilyen például az IN a vizsgált adat a felsoroltak között van.
Összehasonlító operátorok =, >, < stb. ezeket kombinálhatjuk a felkiáltójellel ami azt jelenti, hogy nem igaz például !=   azt jelenti, hogy nem egyenlő.
Logikai operátorok AND, OR, NOT stb. ezekkel például feltételeket kapcsolhatunk össze logikailag stb.
Aritmetikai operátorok szorzás*, osztás / stb. A % szorul magyarázatra. Ez T-SQL-ben az egész osztás maradékát jelenti tehát a 11%2=0,5.
Karakteres összekapcsolásra a + jelet használjuk.

### Változók

A T-SQL mint más programnyelvek is használ változókat. A változó olyan ideiglenesen használt adattároló, ami hivatkozható, jellemzően nevet kap életciklusa és érvényességi köre van ezeken belül a változó neve egyedi kell hogy legyen hiszen egyértelműen tudnunk kell hivatkozni rájuk.  Azt hogy változóról van szó a @ jellel jelöljük a T-SQL-ben. A változókat mindig kötelező deklarálni és meg kell adni az adott változó adattípusát is. A deklarációkor nem kötelező az értékadás, de akkor tudatosan figyelni kell rá. A T-SQL-ben a változók hatóköre egy batch (batch) ez egy fordítás/futtatási egységet jelent. 
```sql
DECLARE @variable int
SET @variable = 20
```

### Kötegelt feldolgozás

Az SQL szerver az általunk írt scripteket / scriptsorozatokat kötegekben dolgozza fel. A feldolgozás során először szintaktikailag ellenőrzi majd értelmezi, lefordítja és végül végrehajtja. Kötegek feldolgozása tekintetében az utasítások két csoportba sorohatóak. Bizonyos parancsok használhatóak egy kötegen belül másokat pl.: create table külön kötegbe kell rendezni. A kötegek határát a GO szóval tudjuk jelölni a szervernek. A GO nem SQL utasítás csak egy szintaktikai jelölő.

### Adattípusok

A változók deklarálása kapcsán már felmerült az adattípusok kérdése. Mint sok más programnyelvben a T-SQL-ben is meg kell adni, hogy mikor milyen adattípusról van szó. Nem csak a változók, de a táblák mezőinek megadásakor is. Az adattípus határozza meg, hogy a program hogy értelmezze az adott karaktereket. Például ha az “5” mint karakter egy változóban valamilyen számként van definiálva akkor matematikai műveletekkel hozzáadható egy másik számhoz és az összegüket kapjuk vissza. Ha viszont szövegként van ugyanez a változó deklarálva akkor egy másik szöveghez fűzhetjük hozzá mint bármilyen más szöveget. Az értelmezésen túl az adattípus meghatározza azt is, hogy az adatbázis mekkora tárterületet foglal le egy-egy adat tárolásához illetve, hogy milyen értékeket vehet fel az adot karakter. 
A következő táblázat egy rövid áttekintést nyújt az adat típusokról. Fontos, hogy sok további információ kapcsolódik a használatukhoz arról a táblázat alatti linken érdemes tájékozódni.

[MSSQL Adattípusok](https://www.sqlservertutorial.net/sql-server-basics/sql-server-data-types/)

### Kifejezések

A kifejezések mezőket, változókat, függvényeket és operátorokat tartalmazhatnak. A végrehajtási sorrendet zárojelekkel befolyásolhatjuk ha az alapértelmezett számunkra nem megfelelő. A kifejezések mindenhol használhatóak, ahol a szintaktika megengedi.

### Kommentelés

A kommentelés segít nekünk és a kollégáinknak, hogy az általunk írtakat értelmezni tudjuk. Ezek a megjegyzések nem kerülnek értelmezésre futáskor épp ezért akár arra is használhatjuk, hogy a kódunk egy részét ne futtassuk le ha éppen nem szeretnénk. A kommenteket kétféleképpen jelölhetjük. 
```sql
-- a sor végéig kommenté válik amit mögé írunk. (inline komment)  
/* 
több soros komment
*/ 
```  
A kommenteket az MSSM zöld színnel jelzi.  

--- 

## Lekérdezések 

A lekérdezések segítségével tudunk egy adatbázisból adatokat kinyerni és azokat utána új struktúrában tudjuk őket felhasználni. A lekérdezés nem más mint egy rövid program, ami utasítja az adatbázis szervert, hogy milyen adatokat milyen formában gyűjtsön össze. Automatikusan sem a lekérdezés kódja sem a lekérdezés eredménye nem kerül mentésre, de lehetőségünk van mindkettőt elmenteni vagy továbbirányítani például változóba.

A **SELECT** utasítás végrehajtási sorrendje és szintaktikája sajnos nem egyezik meg viszont mindkettőt tudnunk kell. 

A végrehajtási sorrend határozza meg, hogy a szerver az utasításainkat milyen sorrendben hajtja végre. Ez nagyban befolyásolja a végeredményt is.Az alábbi végrehajtási sorrend nem minden eleme kötelező csak a **SELECT** és a **FROM**. 
A végrehajtási sorrend:  
* FROM (melyik adatbázis melyik táblázatából, táblázataiból szeretnénk az adatokat)  
* (JOIN) (amennyiben több táblából szeretnénk dolgozni)
* WHERE (itt határozhatjuk meg a feltételeket ami alapján leszűrjük az eredményt)  
* GROUP BY (itt a feltételeinknek megfelelő rekordokat csoportosíthatjuk)  
* HAVING (ugyanúgy mint a WHERE parancsnál feltételeket adhatunk meg ami alapján szűrjük az eredményt, de ezúttal már nem az egyes rekordokra szűrünk, hanem a GROUP BY által képzett csoportok közül választhatjuk ki a nekünk szükségeseket)   
* SELECT (itt választhatjuk azokat a mezőket, amiket szeretnénk megjeleníteni, fontos itt a mezőket (oszlopokat) adjuk meg amiket látni   szeretnénk  
* DISTINCT (ezzel a paraméterrel tudjuk csak az egyedi értékekeket értékkombinációkat megjeleníteni)  
* ORDER BY (a legkérdezésünk eddigi eredményét valamilyen sorrendbe rendezhetjük akár több szempont alapján is)  
* LIMIT (it meghatározhatjuk hogy a lekérdezett és sorba rendezett rekordok közül hányat szeretnénk látni)  

A szintaktikai sorrend pedig az alábbi:  
* SELECT DISTINCT   
* TOP ()
* FROM  
* (JOIN)
* WHERE  
* GROUP BY  
* HAVING  
* ORDER BY  
  

## Egytáblás SELECT: 

## Mezők kiválasztása és módosítása

A **SELECT** után egyértelműen meg kell határoznunk a megjeleníteni kívánt mezőket. Ha csak egyetlen táblát használunk a lekérdezésünkben (FROM után csak egy tábla van) akkor a mezőnév megadásakor az őt tartalmazó táblázat neve elhagyható. Mivel azonban az egytáblás lekérdezések viszonylag ritkák így már a kezdeteknél érdemes rászokni, hogy a mezőnév előtt megadjuk a tábla nevét is a táblanév.mezőnév formában. Hiszen a mezőneveknek csak táblán belül kell egyedinek lennie. Másik tábla már tartalmazhat azonos mezőnevet. Fontos megjegyezni, hogy a T-SQL case sensitive lehet a táblaneveket illetően ez a szerver beállításaitól függ.

A lekérdezések végére írjunk (írhatunk) pontosvesszőt (;) ellenkező esetben a SSMS hibára futhat ha mögé írjuk a következő lekérdezést vagy más utasítást.

### Aliasok
A kényelmünk érdekében lehetőség van arra, hogy egy-egy lekérdezésen belül aliasokkal hivatkozzunk adattáblákra, vagy oszlopok nevére, hogy ne kelljen mindig kiírni a teljes nevüket. Táblák esetén az aliasokat akkor ismeri föl a szerver ha a *FROM*-ba már beleírtuk. Ezért gyakori hogy először a select utána csak egy csillagot írunk utána megírjuk a *FROM* részt majd visszatérünk a SELECT-hez amikor már felismeri a program az aliasaink és ki tudja egészíteni.
```sql
SELECT P.ProductID
FROM Production.Product P 
```
Aliasokat az **AS** szóval jelölhetjük ami T-SQL-ben elhagyható vannak olyan SQL nyelvek amik megkövetelik a használatát. 


A SELECT-nek van rejtett paramétere az ALL ezt cseréljük le DISTINCT-re amikor csak az egyedi értékeket vagy egyedi értékkombinációkat szeretnénk.  
```sql
SELECT DISTINCT P.Color
FROM Production.product P 
```
A fenti kis kód a táblázatunk Color mezőjében szereplő színeket fogja megjeleníteni.

Használhatunk képleteket és kifejezéseket amiknek utána aliast adhatunk. Fontos, hogy mivel a WHERE hamarabb hajtódik végre, ezért a SELECT-ben definiált aliasok nem hivatkozhatóak a WHERE részben. Az itt megadott alias lesz a lekérdezésünk eredményében az oszlop neve ha nem adunk meg akkor No column name fog megjelenni. 
```sql
SELECT P.StandardCost, P.ListPrice, P.StandardCost + P.ListPrice as összeg
FROM Production.product as P
```

Használhatunk képleteket és kifejezéseket amiknek utána aliast adhatunk. Fontos, hogy mivel a WHERE hamarabb hajtódik végre, ezért a SELECT-ben definiált aliasok nem hivatkozhatóak a WHERE részben. Az itt megadott alias lesz a lekérdezésünk eredményében az oszlop neve ha nem adunk meg akkor No column name fog megjelenni. Több programnak problémája lehet azzal ha egy mezőnek nincs neve ezért kerülendő
```sql
SELECT P.name+ P.Productnumber as hosszunév
FROM Production.Product P 
```
A fenti példában a névhez hozzáfűzzük a productnumber-t folytatólagosan. Ha szeretnénk valamilyen fix karakterláncot hozzáfűzni egy mező értékéhez akkor azt aposztrófok (‘) közé kell tenni. 
```sql
SELECT P.name + ‘ ‘ + P.Productnumber as hosszunév
FROM Production.Product P 
```
Így már lesz egy space a productnumber és a ProductNumber között.

---  

## WHERE 
Természetesen amikor lekérdezést csinálunk akkor nem mindig akarjuk látni az összes rekordot, hanem valamilyen szempont szerint szeretnénk szűrni ezeket. Erre szolgál a **WHERE** kulcsszó. A legegyszerűbb eset, amikor egyetlen szempont szerint szeretnénk szűrni. Mint az alábbi példa mutatja.
```sql
SELECT P.ProductID, P.Name, P.Color
FROM Production.product P
WHERE P.Color ="Red"
```
Ebben az esetben a lekérdezésünk a piros színű termékeket fogja kiszűrni. Fontos, hogy szűréskor a feltétel értékét (jelen esetben a Red szót) aposztrofok (') közé kell tenni. 
Természetesen nem mindig csak egy értékre akarunk szűrni. Ha ugyanannak a mezőnek több lehetséges értékére is kíváncsiak vagyunk akkor azt kétféleképpen is leírhatjuk. 
A különböző feltételeket az **OR** szó használatával összefűzhetjük vagy akár az **IN** szó használatával fel is sorohatjuk. Tehát a WHERE feltétel után a következő két kifejezés egyenértékű
```sql
SELECT P.ProductID, P.Name, P.Color
FROM Production.product P
WHERE P.Color ='Red' OR P.Color='Blue' -- a két where feltétel közül az egyiket használd egyenértékűek
WHERE P.Color IN ('Red', 'Blue')
```
Az **IN** szó használatakor a lehetséges értékekeket zárójelek között vesszővel elválasztva kell felsorolni. 
Ha számokról vagy dátumokról van szó, akkor használhatjuk a BETWEEN szót. Így nem kell minden lehetséges értéket felsorolni, hanem elég az intervallumot megadni. Lásd az alábbi példa.  
```sql
SELECT SOH.SalesOrderID, SOH.DueDate
FROM Sales.salesorderheader SOH
WHERE SOH.DueDate BETWEEN '20120301' AND '20120331'
```

A fenti lekérdezéssel a márciusi rendeléseket kapjuk meg. A BETWEEN után az értékeket aposztrofok között az **AND** szóval kell megadni.Természetesen ilyen esetekben használhatjuk a relációs jeleket is. 
```sql
SELECT SOH.SalesOrderID, SOH.DueDate
FROM Sales.salesorderheader SOH
WHERE SOH.DueDate >= '20120301' AND SOH.DueDate < '20120404'
```
Az **AND** logikai és. Tehát mindkét feltételnek teljesülnie kell. Fontos, hogy a nagyobb és a nagyobb egyenlő közti különbségekre ilyen esetben odafigyeljünk.
 
Ha csak az egyes értékek egy részére szeretnénk szűrni például minden olyan termékre ami a Socks szóval kezdődik akkor a **LIKE-ot** kell használnunk. SQL-ben a % jel a joker karakter. 
Az alábbi példa minden olyan terméket kigyűjt, ahol a Name mezőben Chain-el kezdődő érték van.
```sql	
SELECT P.ProductID, P.Name		
FROM Production.product P
WHERE P.Name LIKE 'Chain%'
```
Fontos hogy sok programnyelvel  ellentétben SQL-ben a joker karaktert is aposztrofok közé kell tenni. 

Sok esetben előfordul, hogy hogy nem azt az értéket szeretnénk megjeleníteni, ami az adattáblánkban van hanem a tábla tartalmától függően valamilyen más értéket. Erre használhatjuk a **CASE** függvényt. A CASE függvényben a CASE szó után írjuk a mező nevét amire a feltételeink vonatkoznak. A **WHEN** szóval kezdjük az adott ágat, utána írjuk a feltételt majd a **THEN** szó után hogy mire cserélje. A CASE függvénynek lehet **ELSE** ága, ami minden fel nem sorolt esetet jelent. A CASE függvényt **END-el** zárjuk le. Az alábbi példában a neveket szeretném magyarul megjeleníteni. 
```sql	
SELECT P.ProductID, P.Name,
	CASE P.Color WHEN 'Blue' THEN 'Kék'
				 WHEN 'Red' THEN 'Piros'
				 WHEN 'Silver' THEN 'Ezüst'
				 WHEN 'Black' THEN 'Fekete'
				 ELSE 'N/A'
				 END as Szín
FROM Production.product P
```
Lehetőségünk van arra is, hogy egy mező értékét valamilyen feltételhez kötve adjuk meg. Ehhez az **IIF** parancsot kell használni aminek a szintaktikája IIF (feltétel, érték ha igaz, érték ha hamis). Használatára lásd az alábbi példát.
```sql		
SELECT E.LoginID, IIF(E.Gender='M', 'Male', 'Female') Gendername
FROM Humanresources.employee E
```
--- 

## ORDER BY
A rendezés a következő olyan funkció, amit gyakran használunk. Alapértelmezésként az SQL növekvő sorrendbe rendez a megadott mező szerint. Ha csökkenő sorrendet szeretnénk akkor a DESC kitétel használata szükséges. .Ha akarunk akkor rendezhetünk több szempont szerint ilyenkor a beírt mezők sorrendjében fog rendezni a program.A mezőkre hivatkozhatunk a nevükkel vagy a sorszámukkal is (hányadik mező a SELECT-ben) Mint a alábbi példában látható.
```sql
SELECT P.ProductID, P.Name, P.Color
FROM Production.product P
ORDER BY P.name, P.Color DESC
```
## Részhalmazok lekérdezésbe

Vannak olyan esetek, amikor nincs szükségünk egy lekérdezés összes adatára, hanem csak valamilyen szempont szerint az első 10. Erre használhatjuk a **TOP** utasítást.
Így lekorlátozni a darabszámot többnyire akkor szoktunk miután valamilyen szempont szerint már sorbarendeztük az adatainkat. Klasszikus példa amikor a legocsóbb termékekre vagyunk kíváncsiak.
Ezt fogjuk megnézni a következő ki példában.

```sql
SELECT TOP (10) P.name, P.ListPrice 
FROM Production.Product P
WHERE P.ListPrice >0
Order BY P.ListPrice
```
```sql
SELECT TOP (5) PERCENT P.name, P.ListPrice 
FROM Production.Product P
WHERE P.ListPrice >0
Order BY P.ListPrice
```

Másik gyakori eset amikor részhalmazra van szükség például egy webáruház oldala, amikor nem akarjuk egyszerre megjeleníteni az összes adatot, hanem egyszerre csak kevesebbet.
Jellemzően 10-20 terméket mondjuk majd utána újabb 10-20 terméket. Ezt az **OFFSET** és **FETCH** parancs kombinációval tehetjük meg. Ahol az OFFSET után kell megadni, hogy hány rekordot nem szeretnénk látni (az utána következőtől látjuk majd) és a FETCH után hogy hány sort jelenítsen meg.
A következő kis példa 25 sort fog megmutatni a 51. rekordtól. 
```sql
SELECT P.ProductID, P.name, P.ListPrice
FROM Production.Product P
ORDER BY P.ProductID
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY
```

