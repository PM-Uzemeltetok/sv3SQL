create database HAMyAirline;
use HAMyAirline;

-- drop table Bookings;
CREATE TABLE Bookings(
BookingID int NOT NULL auto_increment PRIMARY KEY,
CustomerID int NOT NULL,
CCountry varchar(2) NOT NULL,
DepartureStation varchar(30) NOT NULL,
Date datetime NOT NULL DEFAULT (now()),
Price decimal default -1,
Seats int NOT NULL,
constraint CK_2betu check ( CCountry regexp '^[A-Za-z]{2}')
);

DROP PROCEDURE IF EXISTS BookingsTablaPop;

DELIMITER $$
-- ---------------------------------------------------
CREATE PROCEDURE BookingsTablaPop (IN j INT) 
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE customerID int;
    DECLARE ccountry VARCHAR(2);
    DECLARE departurestation varchar(30);
    DECLARE date datetime;
    DECLARE price decimal(10,2);
	DECLARE seats int;
    
	WHILE i <= j DO
		SELECT FLOOR(RAND()*(100-1+1)+1) INTO customerID;
		SELECT TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, '2022-01-01 00:00:00','2022-01-31 00:00:00')), '2022-01-01 00:00:00') into date;
		SELECT RAND()*(100-1+1)+1 INTO price;
		SELECT FLOOR(RAND()*(6-1+1)+1) INTO seats;    
		SELECT ELT(FLOOR(RAND() * 10) + 1, 'HU','PL','UK','DE','IT','FR','SP','HR','SK','RU') into ccountry;
		SELECT ELT(FLOOR(RAND() * 10) + 1, 'Budapest','Katovice','Luton','Berlin','Rome','Orly','Barcelona','Dubrovnik','Pozsony', 'Seremetyevo I') into departurestation;
      
		INSERT INTO Bookings(CustomerID,CCountry,DepartureStation,Date,Price,Seats) 
			VALUES (customerID, ccountry, departurestation, date, price, seats);
    
		SET i = i+1;
	END WHILE;
END$$
-- ---------------------------------------------------------------------
DELIMITER ;

Call BookingsTablaPop(30);
Select * from Bookings;

SHOW INDEXES FROM Bookings IN HAMyAirline;
SHOW INDEXES FROM HAMyAirline.Bookings;
SHOW KEYS FROM Bookings in HAMyAirline;

create index IX_HAindex1date on Bookings (Date);
create index IX_HAindex2 on Bookings (CustomerID, DepartureStation);