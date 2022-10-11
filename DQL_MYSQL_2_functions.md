## Adattípusok és kapcsolódó függvények

Mint minden programnyelvben az SQL-ben is minden értékhez hozzátartozik valamilyen adattípus ilyen szempontból mindegy, hogy változótról vagy egy adattábla mezőjéről van szó. 
Az adattípus sok esetben meghatározza, hogy milyen műveletek és hogyan hajthatóak végre az adott értékkel. Például ha van két változónk amiknek az értéke '1' és azok valamilyen számtípusként
vannak definiálva akkor változó1 + változó2 =2 viszont ha szövegtípusként vannak deklarálva akkor változó1 + változó2=11 mivel szöveg esetén T-SQL-ben a **+** jel összefűzést jelent.

Amikor adatokkal dolgozunk gyakran szükséges, hogy ezeket az adattípusokat konvertáljuk. Az SQL ebben segítségünkre van és sok esetben ezt automatikusan megteszi. Azonban vannak helyzetek, amikor erről nekünk kell gondoskodni.
Természetesen nem mindent lehet mindenné átkonvertálni. Ezt a következő táblázat foglalja össze, illetve az alatta lévő linken találhattok további információkat.

[T-SQL adattípus konverzió]([https://dev.mysql.com/doc/refman/8.0/en/cast-functions.html](https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-type-conversion-database-engine?view=sql-server-ver16))

A konvertálásra több függvényünk is van. A **CAST** és a **CONVERT** függvények közel teljesen egyenértékűek alapszinten, a CONVERT a nyelvfüggű beállításoknál rendelkezik extra funkcióval cserébe a CAST több SQL nyelvben használatos míg a CONVERT nem. A szintaktikájuk eltérő, ami a következőképpen néz ki.
CAST(konvertálandó AS adattípus) a CAST esetében fontos, hogy itt  az AS szó nem hagyható el mindig ki kell írni. A CONVERT(adattípus, konvertálandó) szintaktikája a fordítottja a CAST-énak.
A kovertáladó lehet változó mező stb. Az adattípus mindkét esetben az az adattípus amire konvertálni szeretnénk.
Fontos még megjegyezni, hogy vannak korlátai annak milyen adattípusokra lehet konvertálni. 

A következő kis példában a termékek méretét próbáljuk meg számmá konvertálni.
```sql
SELECT P.Name, P.Size, CAST(P.size AS decimal) sizeint
FROM Production.product P
```
Azt fogjuk tapasztalni, hogy a függvényünk csinál néhány furcsaságot annak függvényében, hogy az adott rekordban milyen érték van a size mezőben.
- Ha szám volt benne akkor gond nélkül átkonvertálja
- Ha NULL volt az értéke akkor konverzió után is NULL lesz.
- Ha szöveg volt akkor viszont a konverzió hibára fut. 
- 
Az utóbbi esetekre kínál megoldást a **TRY_CAST()** és a **TRY_CONVERT()**. A szintaktikájuk ugyanaz mint az alapváltozatoknak, de ha nem konvertálható értékkel találkoznak, akkor nem szállnak el hibával, hanem NULL értékkel térnek vissza. A TRY verziók ugyan megoldják, hogy ne fusson hibára a kódunk, de bánjunk vele körültekintően. A konvertált adatokkal további műveleteket fogunk végezni és a NULL nem egyenlő egy konkrét értékkel. 

A konverzióra van még egy különleges parancsunk a **PARSE()** és annak a **TRY_PARSE()** verziója. Szintén konverziós függvények viszont a CAST-al ellentétben
meg lehet adni a kultúrát/nyelvet és lekezeli az ebből fakadó eltéréseket. Az olyen esetekben mint a pénznem típusra konvertálás a CAST függvény helytelen eredményt adhat mert nem veszi figyelembe a nyelvi sajátosságokat. Ilyenkor kell nekünk a PARSE, amit csak string szám vagy date/time típusokká konvertálására lehet használni.

Az alábbi kis példa mutatja meg a PARSE használatát egy változón. 
```sql
	DECLARE @összeg varchar(30) = '1350,20'
	SELECT @összeg, Parse(@összeg as money using 'hu-hu')
```

## Szöveg függvények

Összegyűjtöttünk néhány olyan függvényt ami a szöveg típusú adatokhoz használható. Ezek megfelelői sok más programnyelvben megjelennek.
A legfontosabb közülük talán a szöveg összefűzésére szolgáló **CONCAT()** függvény, ami nem csinál mást, mint a megadott szövegeket vagy kifejezések értékét összefűzi egymás után.
Fontos kitétel, hogyha bármely összefűzni kívánt kifejezés értéke NULL akkor a CONCAT eredménye is NULL lesz. Természetesen erre is van megoldás, amit majd a NULL kezelés témakörében fogunk megnézni.

Az alábbi kis példa a termék nevét és színét fűzi össze egyetlen karakterlánccá.

```sql
SELECT P.Name, P.Color, CONCAT (P.name, P.Color)  as 'termék és szín'
FROM Production.product P
```	

A következő 3 fügvényt olyankor használjuk, amikor egy szöveg egy részére van szükségünk. Ezek a LEFT() a RIGHT() és a SUBSTRING().
Az előbbi kettő elég egyértelmű a SUBSTRING segítségével pedig egy karakterlánc közepéről szedhetünk ki karaktereket. 
A szintaktikájuk a következő:
	LEFT(szöveg, karakterek száma) Balról kezdve ad vissza megadott számú karaktert.
	RIGHT (szöveg, karakterek száma) A szöveg végéről indulva add vissza megadott számú karaktert.
	SUBSTRING (szöveg, honnantól,mennyit) A megadott számú karaktertől kezdve ad vissza megadott számú karaktert.

Az alábbi kis példa nem fog értelmes adatot visszaadni, de arra jó, hogy lássuk a szintaktikát élőben.
```sql
SELECT P.name, LEFT(P.name,5) eleje, RIGHT(P.name, 4) vége, SUBSTRING(P.name,3,3) közepe
FROM product P
```

A következő csoportba néhány olyan függvényt soroltunk, amik a karakterlánc hosszát valamint a közök ' ' eltávolítását teszik lehetővé.
**DATALENGTH (szöveg)** Egy karakterlánc karaktereinek számát adja vissza közökkel együtt.
**LEN (szöveg)** Ugyanaz mint a DATALENGTH, de a karakterlánc végén lévő közöket nem számolja bele.
**LTRIM (szöveg)** Levágja a karakterlánc elejéről a fölösleges közöket.
**RTRIM(szöveg)** Levágja a fölösleges közöket egy karakterlánc végéről.
**TRIM (szöveg)** 2017 óta használható. A karakterlánc mindkét végéről levágja a fölösleges közöket.

Végül pedig a **CHARINDEX**, amit bár gyakran használunk a közök kezeléséhez egy karakterláncban de ennél többet tud.
A CHARINDEX segítségével egy szövegrészre kereshetünk rá egy karakterláncban és visszaadja, hogy hányadik karakternél találta meg. A számolást 1-től kezdi. Ha nem találja meg a keresett szövegrészt, akkor 0 értékkel tér vissza.
Nézzünk is egy gyakorlati példát a karakterfüggvények használatára. Gyakran előfordul, hogy a vezetéknevet és keresztnevet egy cellába mentik el és sokszor külön külön is szükség lenne rájuk.

Ilyenkor jön jól az alábbi programocska, amivel most a termékek nevét fogjuk szétbontani.
```sql
	SELECT P.name, 
		CHARINDEX(' ', P.Name) as köz, --első köz helye, ha több is van akkor az első helyét adja vissza
		LEFT(P.name, CHARINDEX(' ', P.Name)) as eleje, --visszaadja a karakterlánc elejét a közig
		RIGHT(P.name, LEN(P.name)-CHARINDEX(' ', P.Name)) as vége -- visszaadja a karakterlánc végét a köztől
			FROM Production.Product P
```
Mint látható a függvények paramétereinek helyére írhatunk kifejezéseket. 

Az utolsó szövegfüggvény amivel most foglalkozunk az a **REPLACE**. Segítségével egy karaktert vagy karakter láncot cserélhetünk ki egy másikra egy szövegben.
Erre meglepően gyakran van szükség. Például a magyar ékezetes betűket német nyelvterületen szeretik karakterkombinációval helyettesíteni például é helyet ai-t írnak.
Vagy például szövegként mentenek el számokat és a tizedesvesszőt mint karaktert eltárolják. Ilyen esetekben jön jól a REPLACE.

A következő példában a közök helyére alávonást '_' írunk. 
```sql
	SELECT P.name, REPLACE(P.name,' ','_')
		FROM Production.Product p
```
## Dátum függvények

A másik fügvénycsoport amivel foglalkozunk most azok a dátum formátumhoz kapcsolódó függvények. A legegyszerűbb közülük amikor csak a dátum egy részére van szükségünk évre, hónapra, adott napra külön külön.
Erre való a **YEAR()**, **MONTH()** és **DAY()** függvények amik mögé csak zárójelbe meg kell adnunk az adatot.
Egy egyszerű kis példa erre.
```sql
SELECT P.name, P.SellStartDate, YEAR(P.SellStartDate) év, MONTH(P.SellStartDate) hónap, DAY(P.SellStartDate) nap
	FROM Production.Product P
```
Ezek a függvények számként adják vissza a kért adatot.

A **DATEPART()** függvény további adatokat tud adni nekünk egy adott dátumról, annak függvényében, hogy milyen paraméterrel használjuk.
Néhány paraméter:
	- YYYY az évszámot adja vissza mint a YEAR függvény
	- Y hányadik napja az adott évnek
	- q visszaadja a negyedévet ahova a dátum esik
	- ww hányadik hétre esik a dátum
	- w visszaadja, hogy az adott hét hányadik napjára esik a dátum.

Nézzünk erre egy rövid kis példát. Ami a fent felsorolt paraméterek szerint visszaadja a termékek eladásának kezdetére vonatkozó infókat.
Ahhoz hogy a DATEPART függvények biztos helyesen működjön érdemes beállítani a hét kezdőnapját különben a nyelvi beállítások függvényében előfordulhat hogy helytelen adatot kapunk, amikor lekérdezzük hányadik napjára esik a hétnek az adott dátum ehhez a **SET DATEFIRST 1** parancsot kell kiadnunk.

```sql
SET DATEFIRST 1 
SELECT P.name, 
		P.SellStartDate,
		DATEPART(yyyy,P.SellStartDate) év,
		DATEPART(y,P.SellStartDate) 'nap az évben',
		DATEPART(q,P.SellStartDate) negyedév,
		DATEPART(ww,P.SellStartDate) 'hányadik hét',
		DATEPART(w,P.SellStartDate) 'nap a héten'
		FROM Production.Product P
```
Lehetőségünk van arra is, hogy az adott hónap nevét és az adott nap nevét tudjuk meg. Erre használható a **DATENAME()** függvény. A w paraméterrel a napot m paraméterrel a hónap nevét kapjuk meg
A **SET LANGUAGE** parancsal pedig a nyelvet módosíthatjuk annak megfelelően hogy milyen nyelven szeretnénk visszakapni az eredményet.
Itt egy kis példa a használatára.

```sql
SET LANGUAGE MAGYAR
SELECT P.name, P.SellStartDate,DATENAME(w, P.SellStartDate), DATENAME(m, P.SellStartDate)
	FROM Production.Product P
```	

Az aktuális dátumot és időt is lekérhetjük SQL segítségével. Több függvény is képes erre és a részletekre oda kell figyelni a használatukkor.
A GETDATE** és a SYSDATETIME függvények az aktuális időpontot kérik le az utóbbi pontosabb. Arra viszont oda kell figyelni a használatukkor, hogy az SQL szerver szerinti időzónát használják.
Ezt küszöböli ki a GETUTCDATE függvény, ami mindig a greenwichi időt adja vissza.

## NULL kezelés

Az SQL nyelvben a NULL nem egyenlő a matematikai nullával vagy semmivel. A NULL azt jelenti, hogy az adott értéket nem ismerjük. Éppen ezért sokszor kell kezelnünk
ezt az esetet, mert a NULL-al való összehasonlítás eredménye mindig FALSE illetve a NULL-al végzet bármilyen művelet például az összeadás értéke mindig NULL lesz.
Ezt az esetet tudja kezelni például a COALESCE függvény, aminek a szintaktikája COALESCE (mezőnév, helyettesítő érték). 
A COALESCE használatakor ha az adott mezőben egy rekord értéke NULL akkor a helyettesítő értéket használja az SQL.
Az alábbi példában lekérjük a termékeink nevét és ahol nincs megadva szín oda beírjuk hogy színtelen.

```sql
SELECT P.Name, P.Color, COALESCE(P.Color,'szintelen') as 'szín'
FROM product P
```	
Fontos még tudni, hogy COALESCE függvénynél akár a mezőnév helyére akár a helyettesítő érték helyére írhatunk kifejezéseket is. Az előbbi példát kicsit továbbvive.
A következő rövid kis lekérdezésben összefűzzük egy mezőbe a termék nevét és színét és kezeljük azokat az eseteket ha akár a név akár a szín mezőben NULL van.
```sql
SELECT P.Name, P.Color, CONCAT (COALESCE(P.name, 'név?'), COALESCE(P.Color, 'szín?'))  as 'termék és szín'
FROM product P
```	

Számok és dátumok esetén az IFNULL függvényt is használhatjuk és akár csak a COALESCE-nél meg kell adnunk egy helyettesítő értéket.
Az alábbi kis példában ha nincs megadva a termék súlya akkor automatikusan beírja hogy 2 legyen.
```sql
SELECT P.Name, P.Weight, ifnull(P.weight, '2')
FROM product P
```	
Vannak olyan esetek, amikor arra vagyunk kíváncsiak, hogy egy adott mező értéke NULL vagy nem NULL.

Az alábbi kis példában kigyűjtjük azokat a termékeket, amiknek nincs megadva a színe.
```sql
SELECT P.Name, P.color
FROM product P
WHERE P.Color IS NULL
```
Ennek az ellentéte amikor arra vagyunk kíváncsiak, hogy mely termékeknek van megadva a színe. Erre használhatjuk az IS NOT NULL kifejezést.
```sql
SELECT P.Name, P.color
FROM product P
WHERE P.Color IS NOT NULL
```
