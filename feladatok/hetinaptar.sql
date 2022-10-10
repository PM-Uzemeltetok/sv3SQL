/*
Az alábbi kódrészlet visszaadja egy dátum hetének első napját
*/
set @mydate = '2022-09.06';
select DATE_ADD(@mydate, INTERVAL(-WEEKDAY(@mydate)) DAY);

/*
Készíts lekérdezést ami visszadja 
azt a táblát ami a keresett dátum egész hetét tartalmazza DATE típusú oszlopokban
A keresett dátumot a function paraméterként kapja
Mezők nevei: Keresett dátum, Hétfő, Kedd, Szerda, Csütörtök, Péntek, Szombat, Vasárnap
*/


