# CURSOR / FETCH


A kurzor lehetővé teszi az eredményhalmazok soronkénti feldolgozását. A kurzort az eredményhalmazhoz használjuk, és egy lekérdezésből adjuk vissza. A kurzor használatával iterálhat, vagy lépegethet a lekérdezések eredményei között, és bizonyos műveleteket hajthat végre az egyes sorokon. A kurzor lehetővé teszi az eredményhalmazban való iterációt, majd a további feldolgozást csak azokon a sorokon hajthatja végre, amelyek ezt igénylik.

1. **READ ONLY** A kurzor csak olvasható, és nem frissítheti vagy távolíthatja el az eljárás eredményhalmazának adatait.   
2. **Non scrollable** Csak a select utasításban megadott sorrendben kérheti le az adatokat, és nem fordított sorrendben.  
3. **Asensitive / Insensitve:** Az Asensitive kurzor a tényleges adatokra mutat, míg az adatok ideiglenes másolatát egy Insensitve kurzor használja. Az Asensitive kurzor gyorsabban működik, mint egy Insensitve, mivel nem kell ideiglenes másolatot készítenie az adatokról.  

- **Cursor deklarálás ```DECLARE cursor_name CURSOR FOR SELECT_expression;```** A kurzort használat előtt deklarálni kell. A kurzor definíciója csak egy lépés, amely megmondja a MySQL-nek, hogy létezik ilyen kurzor, és nem kéri le az adatokat. 
- **Cursor megnyitás ```OPEN cursor_name;```** A kurzort meg kell nyitni  
- **Adat felolvasás (FETCH) ```FETCH cursor_name INTO variables;```** 
- **Cursor lezárása ```CLOSE cursor_name```**  

![image1](/.pics/cursor1.png)  