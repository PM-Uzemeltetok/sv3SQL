## Tárolt eljárás

SQL utasításokból felépített metódus/szubrutin, aminek vannak input paraméterei és vannak output paraméterei valamint egymásba ágyazhatóak. Ma már .NET CLR-ben is megírható. Képest eredményhalmazt is visszaadni. Komoly előnye, hogy elég a tárolt eljárásra jogot adni a felhasználónak vagy alkalmazásnak és azt utána meghívhatja másik alkalmazás vagy akár másik tárolt eljárás is. A tárolt eljárásokat az exec paranncsal tudjuk meghívni.
A halasztott névfeloldásnak köszönhetően a tárolt eljárásokban hivatkozhatunk olyan objektumokra, amit maga a tárolt eljárás hoz létre. Nyilván a létrehozásnak hamarabb kell megtörténnie mint a meghívásnak.
Hatékonyság tekintetében a tárolt eljárás lefordítás után a procedure cache-be kerül ahonnan újra és újra meghívható újabb fordítás nélkül. Ha viszont változik a kód akkor újra kell fordítani.

## Rendszer tárolt eljárások
sp_ karaktersorral kezdődik és bármely adatbázison álva meghívható. A bővített rendszer tárolt eljárások xp_ karaktersorral kezdődnek, de ma már elavultnak számítanak.

sp_configure adatbázis beállításait tartalmazza
A reconfingure paranccsal és a 'show advaced options'-el kiegészítve minden beállítás látható és módosítható.
EXEC sp_configure 'show advanced options', 1
RECONFIGURE

sp_help 'táblanév' egy tábla adatait tudjuk lekérni vele.

## Tárolt eljárás létrehozása

CREATE OR ALTER Procedure sémanév.tárolt eljárás neve as parancs kötelező.

A tárolt eljárások csak külön batchben fut és az aktuális session SET-jei alapján működik. Csak az aktuális adatbázisban tudunk tárolt eljárást létrehozni.
A tárolt eljárás írásakor nem kötelező az utasításokat a BEGIN END közé rakni, de lehet.
RETURN utasítással lehet kiugrani belőle, ami után egy numerikus számot megadhatunk státusz azonosítóként.

## tiltott utasítások

- Nem lehet másik objektumot létrehozni vele (VIEW, PROCEDURE, FUNCTIONm TRIGER, SCHEMA) viszont táblát lehet létrehozni.
- nem lehet olyan SET-et módosítani ami kihat a QUERRY tervekre pl PARSEONLY.
- nem lehet USE utasítással váltani az adatbázisok között.

Ugyanakkor más adatbázis vagy szerver objektumára hivatkozhatunk, de akkor az elérési utakat ennek megfelelően kell meghatározni.

## ALTER PROCEDURE

ALTER PROCEDURE-al módosíthatjuk a tárolt eljárásainkat. A módosítás előnye a törlés és újralétrehozással szemben, hogy a jogosultságok megmaradnak. Ugyanakkor ha módosítunk akkor a módosításkori SET-ek szerint fog működni a tárolt eljárás.

## Tárolt eljárások meghívása

EXEC sémanév.eljárásnév. Ha RETURN utasítással adunk vissza paramétert akkor deklarálni kell egy változót és futtatni az exec @változónév=sémanév.eljárásnév szintakszissal tudjuk kinyerni.
A sémanevet érdemes megadni mind az eljárás létrehozásakor mind az eljáráson belül a tábláknál különben futtatáskori sémafeloldás lesz. 
Ha egy eljárás neve sp_előtaggal kezdődik akkor a szerver először a master adatbázis sys sémájában fogja keresni, utána a user default sémában majd utána a dbo sémában. Épp ezért érdemes kerülni az sp_ előtagot.

## Példa

létrhozás:
```sql
CREATE OR ALTER Procedure watis as
	SET NOCOUNT ON --Ne adjon vissza plussz infót, bizonyos kliens programokat megzavarhat ha nincs beállítva
SELECT P.Name, P.ListPrice
FROM Production.Product P
WHERE P.ListPrice>100
ORDER BY P.ListPrice
```
Futtatás:
```sql
exec watis
```

## Hibakezelés tárolt eljárásban

A BEGIN TRY END TRY vagy a BEGIN CATCH END CATCH javasolt, aminek a CATCH ágában a következő rendszerfüggvények érhetőek el:
ERROR_NUMBER() hibakód
ERROR_SEVERITY() súlyosság
ERROR_STATE() állapot
ERROR_PROCEDURE() melyik eljárás
ERROR_LINE() eljárás hányadik sora
ERROR_MESSAGE() hibaüzenet szövege

Ezzel összefüggésben felmerül a tranzakciókezelés a tárolt eljárásokban, de ezzel majd külön modulban foglalkozunk.

## Tárolt eljárás függőségei

A függőségeket a sys.sql_expression_dependencies katalógus nézettel vagy a sys.dm_sql_referenced_entities vagy sys.dm_sql_referencing_entities TVF-ekkel tudjuk ellenőrizni.

## Tárolt eljárás újrafordítása

Mivel a tárolt eljárás készítésekor sokszor a kód a procedure cache-be kerül ezért gond lehet az adatszerekezet módosulása esetén. Az újrafordításra két lehetőségünk van.

Újrafordítás minden meghívásnál:
CREATE OR ALTER PROC sémanév.eljárásnév WITH RECOMPILE AS. 

Úgy hívjuk meg az eljárást, hogy újrafordítjuk
EXEC sémanév.eljárásnév WITH RECOMPILE

Terv érvénytelenítése: (ilyenkor csak érvénytelenítjük a tervet és csak a következő futatáskor kerül újrafordításra)
EXC sp_recompile 'sémanév.eljárásnév'

## Tanácsok a tárolt eljárásokkal kapcsolatban

- Használjuk a sémaneveket, hogy ne futás közbeni névfeloldás legyen.
- A RETURN  utasítással valamilyen státuszt adjunk vissza ne üzleti adatot. A RETURN utasíásra legyen valamilyen konvenciónk, ami szerint minden tárolt eljárásunkban ugyanazt jelentse az adott státusz.
- Használuk a set nocount on opciót, hogy ne kavarjon be a kényesebb alkalmazásoknak.
- A @@NESTLEVEL tárolja, hogy hány eljárást ágyaztunk egymásba.
- Ne használjuk a WITH ENCRYPTION opciót vagy tároljuk el máshol is a kódunk, ha be van kapcsolva akkor a szerveren nem tudjuk megnézni az eljárásunk kódját.

## Paraméteres tárolt eljárások

Kétféle paraméterünk lehet. Az INPUT paraméterrel adunk értéket az eljárásunknak. Ha az átadott paraméterrel az eljárásunk műveleteket hajt végre, aminek az eredményét szeretnénk visszakapni akkor kell Output paramétert használnunk. A RETURN utasítással return value típusú paramétert használhatunk.

## INPUT paraméter
Létrehozás:

CREATE OR ALTER PROC sémanév.eljárásnév
@paraméter1 adattípus (ez esetben nincs alapértelmezett értéke a paraméternek)
@paraméter2 adattípus = alapértelmezett érték (ez esetben adunk alapértelmezett értéket a paraméternek)
AS

Meghívás:
-Név szerinti paraméterátadással: (ebben az esetben a paraméterek sorrendje felcserélhető)
    EXEC eljárásnév @paraméter1=érték1, @paraméter2=érték2
-Lista szerinti paraméterátadás (fix a paraméterek sorrendje)
    EXEC eljárásnév érték1, érték2

Ha egy paraméternek van alapértelmezett értéke akkor meghíváskor nem muszáj megadni, de az elhagyásukra vonatkozóan van egy megkötés. Ha név szerinti paraméterátadás van akkor gond nélkül elhagyhatjuk, de ha lista szerinti az átadás akkor csak az utolsó paraméter esetében hagyható el az értékadás.

## OUTPUT paraméter

Létrehozáskor az output paramétert a paraméter után az out szóval jelöljük.
```sql
CREATE OR ALTER PROC sémanév.eljárásnév
@paraméter1 adattípus
@paraméter1 adattípus OUT AS
```
Meghíváskor 
```sql
DECLARE @Para2 int
EXEC eljárásnév @Paraméter1=érték1, @paraméter2=@Para2 OUTPUT
```
vagy
```sql
DECLARE @Para2 int
EXEC eljárásnév érték1, @Para2 OUTPUT
```

## Példa a tárolt eljárásra

```sql
CREATE OR ALTER PROC dbo.GetProductByColor
@Color varchar(20),
@NoOfProducts int OUTPUT
AS
SET NOCOUNT ON

SELECT P.ProductID, P.Name, P.Color, P.Size, P.ListPrice
FROM Production.Product P
WHERE P.Color=@Color or @Color='No color' AND P.Color IS NULL
ORDER BY P.Name

Set @NoOfProducts=@@ROWCOUNT
```

Meghívása:

```sql
DECLARE @R int
exec dbo.GetProductByColor @Color='Blue', @NoOfProducts=@R OUTPUT
SELECT @R
```

## Végrehajtási kontextus

Biztonsági tokenek

Login token, ahogy az aktuális felhasználó belép az SQL szerverre. A SELECT * FROM sys.login_token paranccsal tudjuk lekérni, ami az elsódleges identity-n túl a csoporttagságok miatt
a másodlagos identity-ket is megmutatja.

User token mutatja meg, hogy az egyes adatbázisokat milyen userként éri el. Lekérdezni a SELECT * FROM sys.user_token paranccsal tudjuk.

## Megszemélyesítés

Megadjuk, hogy a tárolt eljárást milyen felhasználóként szeretnénk futatni. Erre azért lehet szükség, mert a tárolt eljárás hivatkozhat olyan táblára, aminek az adott felhasználónak nincs joga.

Explicit megszemélyesítés:
Futtatáskor mondjuk meg kinek a nevében fusson.

Szerver szintű: EXECUTE AS LOGIN='felhasználónév'
Adatbázis szintű EXECUTE AS USER='user1'

REVERT ezzel az usasítással térünk vissza a bejelentkezési userhez.

Implicit megszemélyesítés:
Ebben az esetben már a tárolt eljárásban meghatározzuk, hogy kinek a nevében fusson.

szerver szintű: WITH EXECUTE AS CALLER|SELF|OWNER|'login1'
adatbázis szintű: WITH EXECUTE AS CALLER|SELF|OWNER|'user1'

Fontos, hogy a megszemélyesítés csak adott adatbázis belül működik, ahol kiadjuk. Ezzel nem férünk hozzá másik adatbázishoz hacsak nincs ahhoz is jogunk.