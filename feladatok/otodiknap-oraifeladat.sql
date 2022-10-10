
/*4. Feladat
Adott az alábbi 2 tábla (InvoiceHeader, InvoiceDetail).
Készíts egy tárolt eljárást spInvoiceInsert néven amely paraméterként kapja
		CutomerName - vásárló nevét
		ProductName - termék nevét
		Quantity - mennyiség
értékeket.
A tárolt eljárás hozzon létre egy új rekordot az InvoiceHeader táblában.
Az értékek a paraméterként kapott változok értékei az InvoiceDate mező értéke az aktuális dátum.

Az új sor egyedi azonosítójával hozz létre egy új rekordot az InvoiceDetail táblában.
Az értékek a paraméterként kapott ProductName és Quantity értékek, valamint a létrehozott új InvoiceHeaderID
A CreatedAT értéke az rekord létrehozásának időpontja.
Az eljárás kimenete a CustomerName, ProductName, Quantity, új InvoiceHeaderID összefűzött szóközzel elválasztott értéke.

Hívd meg a tárolt eljárást a 'Vásárló','Termék',10 értékekkel, a visszatérési értéket írasd ki üzenetként
*/

CREATE TABLE InvoiceHeader (

	InvoiceHeaderID INT auto_increment primary key,
	CustomerName NVARCHAR(20),
	InvoiceDate DATETIME,
    CreatedAT DATETIME
);

CREATE TABLE InvoiceDetail (

	InvoiceDetailID INT auto_increment primary key,
	InvoiceHeaderID INT,
	ProductName NVARCHAR(20),
	Quantity INT,
    CreatedAT DATETIME 
);

ALTER TABLE InvoiceDetail
ADD CONSTRAINT FK_InvoiceDetail_InvoiceHeader FOREIGN KEY (InvoiceHeaderID) REFERENCES InvoiceHeader (InvoiceHeaderID);

SELECT IH.InvoiceHeaderID, IH.CustomerName, IH.InvoiceDate, ID.ProductName, ID.Quantity FROM InvoiceHeader IH
INNER JOIN InvoiceDetail ID ON IH.InvoiceHeaderID = ID.InvoiceHeaderID;

