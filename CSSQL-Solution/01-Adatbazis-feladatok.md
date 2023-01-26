#### Coctails
```sql 
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
