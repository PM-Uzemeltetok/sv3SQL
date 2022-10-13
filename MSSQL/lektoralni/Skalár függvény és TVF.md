## Skalár függvény

A skalár függvények egyetlen adatot adnak vissza, ami lehet szám, dátum, szöveg stb. kivéve rowversion, cursor és table adattípus. Ezt az adatot a függvény belsejébe elhelyezett RETURN utasítással tudjuk visszaadni. 
A skalár függvényeknél a BEGIN END utasítás pár használata kötelező. 
A skalár függvények bárhol meghívhatóak, ahova kifejezés írható.

## A skalár függvények szabályszerűségei

- jellemzően egy vagy több paraméterrel rendelkezik
- meghíváskor kötelező a sémanév.függvénynév forma
- hiba esetén a függvény működése leáll és a struktúrált hibakezelés a függvény belsejében nem megengedett
- A függvényben nem lehet olyan utasítás aminek mellékhatása van például nem módosíthatja az adatbázist (INSERT, UPDATE, DELETE), nem hívhatunk meg tárolt eljárást.
- elvárás velük szemben, hogy determenisztikus legyen azaz ugyanarra az input paraméter kombinációra mindig ugyanazt az eredményt adja vissza
- egy függvényről kideríthető, hogy determinisztikus-e SELECT OBJECTPROPERTY(objektum_ID('sémanév.függvénynév'),'IsDeterministic')

Példa:

```sql
CREATE OR ALTER FUNCTION dbo.EndOfPreviousMonth (@Date date) RETURNS date AS
	BEGIN
		DECLARE @D date
		SET @D=DATEADD(day, 0 - DAY(@Date),@Date)
		RETURN @D
	END
GO;
```

Kipróbálás

```sql
SELECT dbo.EndOfPreviousMonth(SYSDATETIME())
```

Determinisztikusság ellenőrzése

```sql
SELECT OBJECTPROPERTY(Object_ID('dbo.EndOfPreviousMonth'),'IsDeterministic')
```

## Tanácsok a skalár függvények alkalmazásához

1. Lehetőleg kis függvényeket építsünk egy-egy feladatra. 
2. SELECT listában és WHERE feltételben alkalmazva minden egyes rekordnál meghívásra kerül ezért érdemes elkerülni.
3. A függvények használatakor az szerver nem tudja felhasználni az indexeket ezért érdemes elkerülni őket. Ez nem csak az általunk készített függvényekre igaz.

## Table-Valued Function (TVF)

Olyan függvény ami table típusú adatot (rekordhalmazt) ad vissza. Gyakorlatilag egy nézet, ami képes paramétert fogadni.

Kétféle megvalósítása van

Inline TVF:
Ebben az esetben egyetlen RETURN van amiben egyetlen SELECT található, de a SELECT lehet bonyolult.
A táblát nem definiáljuk előre, azt a SELECT teszi meg épp ezért minden oszlopnak kell hogy legyen alias neve.
Ez a TVF bárhol meghívható ahova táblakifejezés írható.

Szintaktika: 
CREATE OR ALTER FUNCTION sémanév.eljárásnév (paraméter1 adattípus1 , paraméter2 adattípus2)
RETURNS TABLE AS RETURN SELECT...

Példa: Az alábbi példa lekéri a készletet azon termékekből, amiket megadunk a meghíváskori változódeklarációkor, ami akár kaphatná az értékét a programtól

Létrehozás:

```sql
CREATE OR ALTER FUNCTION dbo.stock (@Pname nvarchar(50), @PSCName nvarchar(50))
RETURNS TABLE AS RETURN
	SELECT P.Name ProductName, PSC.Name CategoryName, SUM(I.Quantity) SumQuantity
		from Production.Product P inner join Production.ProductInventory  I
			ON P.ProductID=I.ProductID inner JOIN Production.ProductSubcategory PSC
			ON PSC.ProductSubcategoryID=P.ProductSubcategoryID
		WHERE P.Name LIKE '%'+@Pname+'%' AND PSC.Name LIKE '%'+@PSCName+'%'
GROUP BY P.Name, PSC.Name
```
meghívás:

```sql
DECLARE  @PSCName nvarchar(50)='Brakes'
DECLARE @Pname nvarchar(50)='%Brakes%'

Select * from dbo.stock(@Pname, @PSCName)
```

Multistatment TVF:
BEGIN END között több utasítás is lehet. Ennél a verziónál már deklarálni kell egy table adattípusú változót természetesen mezőnevekkel és adattípusokkal, ahogy más tábláknál is. Erre a táblára viszont már ki lehet adni DML utasításokat (INSERT, UPDATE, DELETE) majd ennek a táblának az eredményét adja vissza a RETURN utasítás.
Ez is bárhol meghívható, aholva táblakifejezés írható.

## TVF hatékonyság

Az inline függvényeket az optimizer be tudja építeni a meghívó utasításokba ugyanezt a multistatement-ekkel nem tudja megtenni ezért utóbbi annyiszor fog lefutni ahányszor meghívják.
Megjelentek olyan függvények, amiket korábban TVF-el oldottunk meg például a STRING_SPLIT vagy a ROW_NUMBER.

## TVF vs Tárolt eljárás 

Ha DML utasítás kell akkor csak tárolt eljárást használthatunk mert a TVF-ben csak arra az eredményhalmazra adhatunk ki DML utasítást, amit a TVF visszaad más táblákra nem.
Ha struktúrált hibakezelésre van szükségünk akkor szintén csak (TRY Catch) mert ez függvényben nem alkalmazható.
Közbenső eredményhalmaz esetén jobb a TVF. Tárolt eljárással is megoldható, de sokkal problémásabb.
A CROSS APPLY-al meghívott TVF esetén érdemes ellenőrizni a teljesítményt.

## TVF vs Nézet

A nézetet bármely eljárás kényelmesen eléri, de a nézet nem tud paramétereket kezelni. 
A nézet UPDATE-elhető de a multistatment TVF nem update-elhető.
A nézetre építhető INSTEAD OF trigger a TVF-re nem.
A multistatment TVF csak akkor jó, ha más megoldás végképp nincs. Ló helyett jó lesz a szamár is tipikus esete.
Az inline TVF-nél nem használhatunk megszemélyesítést (impersonation).





