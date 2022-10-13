
## Nézet (View)

A view nem más mint egy előre megírt lekérdezés s bár nem teljes értékű, de sokoldalúan használható. Két nagy előnye is van. Az első IT biztonsághoz kapcsolódik, ugyanis az előre megírt nézetekhez adhatunk jogot a felhasználóknak így nem kell hozzáférést adnunk magukhoz az adattáblákhoz. A másik nagy előnye, hogy elrejti a táblázatok közötti kapcsolatokat a felhasználók elől így nekik nem kell ezekkel foglakozni. Jellemzően 1-1 nézetben soktáblás lekérdezéseket tárolunk. A view-k eredményét nem csak felhasználókkal hanem programoknak is átadhatjuk.
Fontos hogy ezekre a nézetekre vonatkozóan írhatunk saját lekérdezéseket. Gyakorlatilag táblaként funkciónálnak ilyen szempontból.

## View korlátai

A sima nézetek nem tudnak paramétereket paramétereket fogadni ilyen célra a TVF használható. Az egymásba ágyazásnak eleve van korlátja max 32 szintig lehetséges. Viszont az átláthatóság és a hatékonyság témaköre komoly problémákat jelent. 

## Rendszer nézetek

## Katalógus nézetek
A rendszer metaadatairól ad infókat sys. kezdetűek. Nagyon sok van belőlük érdemes célirányosan feltérképzeni őket egy-egy feladathoz. 
Gyakoribb általános célú nézetek:
    - sys.objects
    - sys.columns
    - sys.tables
    - sys.views
    - sys.schemas
    - sys.all_objects


## Dynamic Management View és fügyvények
Ebbe a csoportba nézetek és függvények is tartoznak. Van ahol Dynamic management object-ként hivatkoznak rájuk. Minden esetben sys.dm_ karakterlánccal kezdődik a nevük.
Az elérési útvonaluk viszont eltérő. 
A DMV-k a felhasználói adatbázis\views\system views alatt találhatóak míg a DMF-ek a master adatbázis\Programablility\functions\table-valued functions-ben. Ezek az objektumok egy rejtett adatbázisból nyernek ki infókat, ahova az SQL szerver tárol le rengeteg információt. A feladatuk, hogy segítséget nyújtanak a szerver problémáinak diagnosztizálásában és finomhangolásában.
Ezek az objektumok jogosultság szempontjából két csoportra oszthatóak. Vannak szerver hatókörű objektumok amelyekhez view server state jogosultság kell és vannak olyanok amik  adatbázis hatókörűek ehhez view databes state jog kell.
Ezeknél az objetumoknál a táblaszerkezet változhat ezért a select után a * használata kerülendő.

## Information schema nézetek
Ezek ISO szabvány szerinti nézetek és ami fontos, hogy ezekben az adatok jól olvashatóak nincsenek kódolva.
Ezek a nézetek a felhasználói adatbázis\nézetek részén találhatóak meg és mindig information_schema karakterlánccal kezdődnek. Ezekben a nézetekben könnyen lehet oszlopokat, kulcsokat, kapcsolatokat megszorításokat keresni.

## Kompatibilitási nézetek

Korábban e nézetek alpjául szolgáló táblákat is meg lehetett nézni. Ma már e táblák nem elérhetőek csak a nézetek ezért érdemes elkerülni a használatukat, hisz nem tudjuk ellenőrizni hogy milyen adathalmazból dolgoznak. E nézetek neve mindig úgy kezdődik, hogy sys.sys*

## Nézetek létrehozása és kezelése

Létrehozáskor lehet használni azt a formulát, hogy CREATE OR ALTER VIEW így ismételt futtatásnál lefut gond nélkül.
Nevet kötelező adni a view-nak sémát pedig illik.
Oszlopszerkezet adható a view-nak, de csak akkor kötelező, ha a SELECT utasítás oszlopainak nem adunk nevet például számított mezők vagy a benne hagyunk azonos nevű oszlopokat.
A view névadásakor oda kell figyelni rá, hogy a nézetek és a táblák egy névtérben vannak ezért a nézetnek nem lehet meglévő táblával azonos neve.

Korlátozások a VIEW-ban lévő SELECT-ekre:
    - nem lehet benne INTO és OPTION klauzula valamint for XML és for JSON sem
    - nem lehet benne ideiglenes táblára vagy táblaváltozóra hivatkozni
    - ORDER BY csak akkor lehet benne ha van benne TOP vagy OFFSET

## Nézet attribútumok

A nézet attribútumokat a nézetek létrehozásakor és módosításakor lehet beállítani.

WITH ENCRYPTION: Nem a lekérdezés eredményét titkosítja hanem magát a lekrédezés kódját. Ha használjuk akkor mi magunk sem tudjuk utána megnézni vagy módosítani. Ha módosítani akarunk akkor újra létre kell hoznunk a nézetet.

WITH SCHEMABINDING: Van amikor kötelező használni. Használata nélkül a kapcsolódó táblák módosíthatóak, aminek hatására a nézet használhatatlanná válik. Ha használjuk akkor a kapcsolódó táblák nem módosíthatóak úgy hogy az a nézetet befolyásolja.

WITH VIEW METADATA: Használatával az ODBC (ezzel kapcsolódnak a kliens programok az adatbázisunkhoz) nem az adatáblákról hanem a nézetről ad vissza adatokat így a tábláink adatait titokban tudjuk tartani.

WITH CHECK OPTION: Akkor van jelentősége, ha adatokat akarunk módosítani (INSERT, UPDATE, DELETE). Ilyenkor természetesen a nézet mögött álló táblában módosulnak az adatok. Ha ezt az atribútumot használjuk akkor csak olyan adatok módosíthatóak és csak úgy, amik megfelelnek a nézetben lévő SELECT WHERE feltételének.

## Nézet törlése

DROP VIEW [IF EXIST] nézet törlése ha létezik. Vesszővel elválasztva több nézet is törölhető. A nézet törlésével törlődnek a kiosztott jogok is.