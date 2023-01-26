## Adatbázis tervezés gyakorló feladatok
Bontsd különálló táblákra az alábbi adatokat. Használj megszorításokat.  
Minden táblán legyen elsõdleges kulcs (Primary key), kivéve az esetleges kapcsolótáblákon.  
A feladatokhoz hozz létre különálló adatbázist.  
Készíts diagrammot az elkészült struktúráról.  
Készítsd el hozzá a törléseket is.   

#### 1. Feladat: World  
```sql
CREATE TABLE NonNormalWorld(
	Kontinens nvarchar(10),
	Orszag nvarchar(30),
	Fovaros nvarchar(50),
	Kozlekedes nvarchar(100)
);

INSERT INTO NonNormal VALUES
('Ázsia','Kína','Peking','Busz, Metro, Bicikli'),
('Európa','Magyarország','Budapest','Busz, Metro, Villamos'),
('Európa','Németország','Berlin','Busz, Villamos, Bicikli'),
('Amerika','Kolumbia','Bogotá','Busz, Bicikli');

Select * from NonNormal;
/* kapcsolódási típusok
1:1 Orszag:Fovaros 
1:N Kontinens : Orszag
N:M Fovaros : Kozlekedes
*/
```

#### 2. Feladat: Coctails
A `Type` és a `Glass` csak egyedi lehet.  
Használj automatikus sorszámozást egyedi kulcsnál a táblákban. A neve legyen "PK_idneve".    

```sql  
-- írd ide a saját adatbázisod nevét!
USE ..... ;

CREATE TABLE NonNormalCoctail (
	Name nvarchar(50),
	Type nvarchar(30), -- 1:N 
	Glass nvarchar(20), -- 1:N
	Ingredients nvarchar(100) -- N:M - kapcsolótábla
);

INSERT INTO NonNormalCoctail VALUES
('Limonádé','Alkohol mentes','Vizes','Citrom, Cukor, Szóda'),
('Vodka-szóda','Longdrink','Vizes','Vodka, Szóda, Citrom'),
('Cuba Libre','Longdrink','Vizes','Cola, Rum, Citrom'),
('Tequila','Shot','Feles','Tequila, Citrom, Só');

Select * from NonNormalCoctail;
```