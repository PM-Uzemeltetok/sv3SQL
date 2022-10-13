# Database engine tuning advisor (DETA)

Egy adatbázis optimalizáló önálló program, ami az SSMS-ből indítható. Az első indításához sysadmin kell, mert táblákat hoz létre.

A DETA ajánlásokat tesz indexekre, indexelt nézetekre, az elavult statisztikák frissítésére, partíciók kialakítására. 
Ahhoz, hogy a DETA megfelelő ajánlásokat tudjon tenni be kell táplálnunk, hogy milyen feladatok milyen terhelés várható. Ehhez többféle formátumot használhatunk
T-SQL scriptet, SQL profiler trace file-t vagy táblát, használhatja a SSMS plan chache-t vagy adhatunk meg xml fájlt.

A megadott workload adatok alapján tud a DETA ajánlásokat csinálni ha rossz adatokat adunk meg vagy módosul a felhasználás például új gyakran használt lekérdezés kerül képbe akkor érdemes újra lefuttatni. A DETA futása egy komoly adatbázison hosszú ideig eltarthat ezt érdemes figyelembe venni.

A DETA elemzését finomhangolhatjuk és a következő lehetőségeink vannak:
    - megadhatjuk, hogy mely adatbázisra vagy akár mely táblákra vonatkozóan tegyen ajánlásokat. Nem kell az egészre sok esetben
    - mivel hosszú ideig futhat ezért adhatunk időkorlátot, hogy meddig futhat
    - megadhatjuk, hogy mi mindenre kérünk ajánlást pl.: csak indexere
    - megmondhatjuk, hogy mi az amit a meglévő adatbázisunkból tekintsen fixnek, ami nem változtatható.

Fontos, hogy az elemzés lefutása után, a DETA nem módosít semmit csak ajánlásokat tesz. Viszont jó hír hogy az ajánlott módosításokhoz legenerálja a kódot is, amit lefuttatva megcsinálhatjuk az általáunk választott módosításokat.