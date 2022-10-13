## Dml trigger

A triggerek speciális tárolt eljárások, amik más eljárások hatására fut le automatikusan. Két nagy csoportjuk van a DDL trigger, amit a CREATE, ALTER és DROP utasításokkal köthetünk össze és a DML trigger, ami az INSERT, UPDATE és DELETE utasításokkal köthető össze. Ez az anyag az utóbbi csoporttal foglakozik.

A triggerek célja a redundancia megvalósítása például naplózás által vagy készletkezelés illetve az adatellenőrzés olyan esetekben, amikor a CHECK contraint-el ez nem megoldható. A trigerek az eredeti utasítással közös tranzakcióban futnak le és a trigerben kiadott ROLLBACK utasítással visszavonhatóak az eredeti utasítás által végzett módosítások. Fontos különbség a CHECK constaint-ek és a trigerek között, hogy míg az előbbi először ellenőriz és csak utána hajtja végre a módosítást, addig a triger esetén először megtörténik a módosítás és ha az nem kívánt eredményt hoz akkor a trigger ezt visszavonhatja. Ezért nem célszerű a triggereket a CHECK constraint-ek helyett használni csak azok kiegészítéseként.
Fontos hogy TRUNCATE TABLE esetében nem futnak le a triggerek.


## Trigger típusok

## AFTER vagy FOR trigger

A trigger a DML utasítás után után fut le. Egy DML utasításhoz egy triggerfutás kapcsolódik függetlenül attól, hogy a DML parancs mennyi változtatást csinál. Tehát ha 1 sort szúr csak be vagy ha 1000-et a hozzá tartozó trigger csak egyszer fut le egy közös tranzakcióban a DML utasítással.

## INSTEAD OF trigger

Az adott DML utasítás helyett fut le trigger. Tehát a DML trigger nem fog lefutni. Például nem aktualizálható nézeteknél szokás használni. 

## BEFORE trigger

A T-SQL-ben nem létezik ugyan, de más SQL verziókban igen.

## Virtuális táblák a trigger belsejében

A virtuális táblák a triger típusától függeltlenül ugyanúgy léteznek és működnek. Ezekben tároljuk a változtatni kívánt és a megváltoztatott rekordok eredeti változatát az adott DML utasításnak megfelelően. Ezek a virtuális táblák csak a trigger belsejénben érhetőek el és jellemzően JOIN-al kapcsoljuk őket az eredeti táblához.

Inserted tábla:

INSERT utasításnál az adott DML utasítással éppen felvett sorok komplett tartalma kerül bele. Beleértve az IDENTITY és DEFAULT értékeket is. 
UPDATE utasításnál pedig a módosított sorok módosítás utáni komplett tartalma kerül bele. 

Deleted tábla:
DELETE utasításnál az éppen törölt sorok komplett tartalma kerül bele.
UPDATE utsasításnál pedig a módosított sorok eredeti, módosítás előtti komplett tartalma. 

Mint látható az UPDATE esetében két virtuális tábla is létrejön ezeket a trigger belsejében egyszerre is elérhetjük.

## DML trigger létrehozása

Szintakszis: CREATE OR ALTER TRIGGER sémanév.triggernév ON táblanév trigger típusa (FOR|AFTER) DML Utasítás INSERT|UPDATE|DELETE
A különböző DML utasításokra lehet külön-külön triggert is írni, de akár egyben is megírhatjuk. Utóbbi esetben a virtuális táblák alapján tudjuk eldönteni, hogy milyen művelet volt.
INSERT utasításnál csak az Inserted táblában van adat, DELETE utasításnál csak a deleted táblában van adata és az UPDATE utasítás esetén mindkét táblában van adat.

Példa: Az alábbi kis példa arra való, hogy ha új rekordot szúrunk be akkor beírja a létrehozás dátumát.

```sql
CREATE OR ALTER TRIGGER TrgInsCustomer ON dbo.Customer AFTER INSERT
AS
UPDATE dbo.Customer
    SET createdAt=SYSDATETIME()
    from inserted I INNER JOIN dbo.customer C ON I.CustomerID=C.CustomerID

GO
```

## Trigerek egymásba ágyazása

A triggerek is egymásba ágyazhatóak abban az esetben ha a triggeren belül is van DML utasítás. Ehhez az szükséges, hogy a nested triggers beállítás értéke 1-re legyen állítva. Ugyanakkor pont az egymásba ágyazhatóság miatt fontos, hogy a recursive_triggers kapcsoló off-ra legyen állítva különben végtelen ciklus alakul ki, ami ugyan 32 szint után hibával elszáll, de akkor is fölöslegesen fut le sokszor.

## INSTEAD OF TRIGGER

Létrehozása ugyanolyan mint az AFTER trigeré.
Szintakszis: CREATE OR ALTER TRIGGER sémanév.triggernév ON táblanév trigger típusa (INSTEAD OF) DML Utasítás INSERT|UPDATE|DELETE

Felhasználása nem update-elhető nézetek update-elhetővé tétele. Illetve update-elhető view-ek esetén a több táblát érintő UPDATE-ek kezelése. Az INSTEAD OF TRIGGER ugyanis kiadható view-kra is kivéve ha a nézetnél a WITH CHECK OPTION-t használtuk.

példa: Az alábbi példában a triggerünk törlés esetén nem törli a rekordot, csak beállítja a törlés dátumát az aktuális dátumra

```sql
CREATE OR ALTER TRIGGER TrgDelCustomer ON dbo.Customer INSTEAD OF DELETE
AS 
UPDATE dbo.Customer
    SET deletedAt=SYSDATETIME()
        from deleted D INNER JOIN dbo.customer C ON D.CustomerID=C.CustomerID
        

GO
```

## Tudnivalók a triggerekről

Akárcsak a tárolt eljárásoknál a triggereknél is érdemes a SET NOCOUNT-ot ON-ra állítani már a trigger elején mert a kliens programokat megzavarhatja.
A triggerek nem szoktak rekordhalmazt visszaadni, ezt a korábbi SQL verziók még engedték, de a microsoft abba az irányba halad, hogy ezt teljesen megtiltsa.
Ezt manuálisan már most is letilthatjuk az sp_configure segítségével kell a disallow results from triggers értékét 1-re állítani.
Az inserted és deleted táblák a tempdb-ben tárolódnak, ami ugyan a hatékonyságot növeli, de a tempdb használatot is.
Ugyanúgy mint a sokszoros egymásba ágyazásnál a túl bonyolult triggerek is nehézkessé teszik a hibakezelést és hibakeresést.
A trigger az eredeti hívó nevében fut le és ha az a sysadmin akkor az visszaélésekre ad lehetőséget ezért a sys.triggers és a sys.server.triggers nézeteket érdemes időről időre megnézni.
Mivel a trigger kikapcsolható így kritikus biztonsági naplózásra nem alkalmas helyette az auditot kell használni.
Az IF UPDATE függvénnyel meg tudjuk vizsgálni, hogy egy oszlop szereplt-e az UPDATE utasításban, de azt már nem nézi, hogy változás is történt-e.
Ha egy tábla egy műveletéhez több trigger is van akkor a sorrendjük csak annyiban befolyásolható, hogy melyik legyen az első és melyik legyen az utolsó.

## Hasznos linkek

1. [TRIGGER SQLHACK.COM ](https://www.sqlshack.com/triggers-in-sql-server/)
2. [TRIGGER mssqltips.com](https://www.mssqltips.com/sqlservertip/5909/sql-server-trigger-example/)
