## Adatbázis tervezés gyakorló feladatok
Bontsd különálló táblákra az alábbi adatokat. Használj megszorításokat.  
Minden táblán legyen elsõdleges kulcs (Primary key), kivéve az esetleges kapcsolótáblákon.  
A feladatokhoz hozz létre különálló adatbázist.  
Készíts diagrammot az elkészült struktúráról.  

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




-- --------------------------------------------------------------------------------
-- Megoldás

CREATE TABLE Coctail (
	CoctailID INT auto_increment,
	Name NVARCHAR(50),
	CoctailTypeID INT,
	CoctailGlassID INT,
	PRIMARY KEY (CoctailID)
);

CREATE TABLE CoctailType (
	CoctailTypeID INT auto_increment,
	Name NVARCHAR(50) UNIQUE,
	PRIMARY KEY (CoctailTypeID)
);
CREATE TABLE CoctailGlass (
	CoctailGlassID INT auto_increment,
	Name NVARCHAR(20) UNIQUE,
	PRIMARY KEY (CoctailGlassID)
);
CREATE TABLE Ingredient (
	IngredientID INT auto_increment,
	Name NVARCHAR(50),
	PRIMARY KEY (IngredientID)
);
CREATE TABLE CoctailIngredients (
	CoctailID INT,
	IngredientID INT
);

/*
-- Idegen kulcsok összekapcsolása erről hétfőn még beszélgetünk, de soronként lefuttatható
ALTER TABLE Coctail ADD CONSTRAINT FK_Coctail_CoctailType FOREIGN KEY (CoctailTypeID) REFERENCES CoctailType (CoctailTypeID);
ALTER TABLE Coctail Add CONSTRAINT FK_Coctail_CoctailGlass FOREIGN KEY (CoctailGlassID) REFERENCES CoctailGlass (CoctailGlassID);
ALTER TABLE CoctailIngredients ADD CONSTRAINT FK_Coctail_CoctailIngredients FOREIGN KEY (CoctailID) REFERENCES Coctail (CoctailID);
ALTER TABLE CoctailIngredients ADD CONSTRAINT FK_Ingredient_CoctailIngredients FOREIGN KEY (IngredientID) REFERENCES Ingredient (IngredientID);
*/


-- Az összekapcsolt lekérdezés, az ellenőrzés miatt - szintén később megérted :)
SELECT C.Name, CT.Name, CG.Name, I.Name
FROM Coctail C
INNER JOIN CoctailType CT ON C.CoctailTypeID = CT.CoctailTypeID
INNER JOIN CoctailGlass CG ON C.CoctailGlassID = CG.CoctailGlassID
INNER JOIN CoctailIngredients CI ON C.CoctailID = CI.CoctailID
INNER JOIN Ingredient I ON CI.IngredientID = I.IngredientID;

-- takarítás
Drop Table CoctailIngredients;
Drop Table Ingredient;
Drop Table CoctailGlass;
Drop Table CoctailType;
Drop Table Coctail;
```