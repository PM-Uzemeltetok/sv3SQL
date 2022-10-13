# Adattípusok és indexek

Az indexhasználat hasznossága nagyban függ attól, hogy milyen adattípusokra építjük illetve, hogy milyen adatokat is tárolunk az adott mezőben. Azok milyen gyakran fordulnak elő a rekordok között. E témával kapcsolatban pár fogalmat tisztáznunk kell.

Az első közülük a szelektivitás ami a lekért sorok arányát jelenti a tábla összes sorához képest. Például egy egyedi értékeket tartalmazó mezőre vonatkozó WHERE feltétel jellemzően magas szelektivitást eredményez különösképpen ha egyenlőség jel van benne. Ha a szelektivitás magas akkor arra érdemes nonclustered indexet építeni.

A következő a sűrűség ami azt jelenti, hogy hányféle érték jelenik meg az adott mezőben. Az elsődleges kulcsnál és a UNIQUE megszorítássokkal rendelkező mezőknél a legkisebb. Minnél kisebb annál jobb az indexek szempontjából.

Indexmélység azt jelenti, hogy hány ugrásra lépésre van szükség ahhoz, hogy eljussunk a tényleges adatlapokhoz a tényleges adatokhoz. Jellemzően 3-4 lépés van nagyobb tábláknál.

## Adattípusok
### Szám adattípusok

Gyakran építünk indexeket szám adattípusokra különösképpen ha IDENTITY-t állítunk be, hisz erősen szelektív és a töredezettségtől sem kell tartani. Az olyan adattípusoknál pl.: tinyint ahol kicsi a variációs lehetőség már ez gondot jelenthet, de természetesen attól is függ, hogy hány rekordot tartalmaz az adattábla. Az int típusú adatok használatának nagy előnye, hogy kevés helyet foglalnak az karakteres adattípusokhoz képest.

### Karakteres adatok

A szövegalapú természetes kulcsoknál fordulhat elő (hétköznapi emberi nyelvben is használjuk) például devizanem kódja (HUF) ezekre érdemes indexet építeni. Vagy termékkódok estében ha beszédes a termékkód.

Ezekre a mezőkre jellemzően nonclustered idexeket szoktunk építeni, hogy a kereséseket gyorsítjuk például megnevezés jellegű mezőkben. Ugyanakkor a töredezés jellemzően probléma. 

### Dátum típusok

Előnye, hogy könnyű benne keresni hisz rövid mező, kevés helyet foglal. Ugyanakkor elsődleges kulcsként ritkán alkalmazható és nonclustered indexként is inkább csak más mezőkkel kombinálva jó használni. Magában használva gyakkori lehet ezért nem alkalmas indexépítés alapjául. Ugyanakkor viszont ha időrendben érkeznek az új adatok például logolásnál akkor a töredezettség nem jelent problémát. 

### GlobalUniqueIdentifier adatok

Előnye, hogy mivel a világon egyedi ezért nagy a szelektivitása ugyanakkor nagyon hosszú (16 bájt) ezért ennek az adattípusnak és a rá épülő indexeknek használata erősen meggondolandó ráadásul töredezik is.

### Számított oszlop

Fontos megkötés, hogy indexet csak determinisztikus képletre lehet építeni, tehát például a dátum adattípusokkal dolgozó számított oszlopokkal már gyakran gond lehet. Szintén probléma ha gyakran újra kell kalkulálni egy mező értékét.