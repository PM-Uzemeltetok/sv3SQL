use adventureworks;

select EmailAddress from contact
limit 10;

-- /*
SET @emailList = "a"; 
CALL HAcreateEmailList(@emailList); 
SELECT @emailList;
-- */

-- drop procedure HAcreateEmailList;

DELIMITER $$
CREATE PROCEDURE HAcreateEmailList (
	INOUT emailList varchar(4000)
)
BEGIN
    -- deklarálom a használt változókat
    DECLARE emailadd NVARCHAR(50) DEFAULT ""; -- ebbe a változóba fetcheljük az értéket  
    DECLARE finished INT DEFAULT 0; -- ebben figyeljük, hogy a lista végére értünk-e

    -- cursor deklarálás , select sql statement
    DECLARE cursoremail CURSOR FOR 
            -- select EmailAddress from contact limit 5;
			select c.EmailAddress from salesorderheader soh
			inner join contact c on soh.contactID = c.ContactID
			order by TotalDue desc limit 5;

        -- Így csak mindenki egyszer van benne (az első 5 különböző)
        Select distinct base.EmailAddress as EmailAddress from 
        (select c.EmailAddress from salesorderheader soh
        inner join contact c on soh.contactID = c.ContactID
        order by TotalDue desc) base limit 5;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;  -- "continue" hibakezelő, "NOT FOUND" errort kap akkor SET utáni dolog történik        

    OPEN cursoremail; -- megnyitom a cursort

    getemail : LOOP
        FETCH cursoremail INTO emailadd; -- felolvasom 
        IF finished = 1 THEN  -- megvizsgálom van-e benne adat
            LEAVE getemail;  -- ha már nincs akkor kilépek a LOOP-ból
        END IF;       
        -- select emailaddress; -- teszt
        SET emailList = CONCAT(emailadd,"; ",emailList); -- összefüzöm egyenként az elemeket            
    END LOOP getemail;
    CLOSE cursoremail;      
END$$
DELIMITER ;