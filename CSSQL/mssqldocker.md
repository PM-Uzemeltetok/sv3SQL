### MSSQL docker container

Docker-cheat-sheet https://github.com/wsargent/docker-cheat-sheet


### Saját könyvtárrakkal
#### Könyvtárak létrehozása
Az alábbi könyvtárstruktúrára szükséges: 

```
\..\
└───mssql-docker  
    ├───data  
    ├───log  
    └───secrets  
```
  
Ezt a parancsot kell kiadni terminálban hogy elkészítsd az mssql kontainert  
*-v után cseréld ki az útvonalakat a megfelelőre*     

```
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Password123!" `
   --name "sql2022" -p 1433:1433 `
   -v c:/db/mssql-docker/data:/var/opt/mssql/data  `
   -v c:/db/mssql-docker/log:/var/opt/mssql/log  `
   -v c:/db/mssql-docker/secrets:/var/opt/mssql/secrets `
   -d mcr.microsoft.com/mssql/server:2022-latest
```

1 line version 
```
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Password123!" --name "sql2022" -p 1433:1433 -v c:/db/mssql-docker/data:/var/opt/mssql/data -v c:/dbssql-docker/log:/var/opt/mssql/log -v c:/db/mssql-docker/secrets:/var/opt/mssql/secrets -d mcr.microsoft.com/mssql/server:2022-latest
```

### Default helyen tárolt volume-mal
```
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Password123!" \`    
   --name "sql1" -p 1433:1433 \`  
   -v sql1data:/var/opt/mssql \`  
   -d mcr.microsoft.com/mssql/server:2019-latest  
```

---  

## AdwentureWorks sample db bemásolása a containerbe, sqlcmd visszaállítás

#### Backup dir létrehozás
```docker exec -it sql2022 mkdir /var/opt/mssql/backup```  

#### #AW2019 letöltés 
git-ről az aktuális könyvtáraba:
```
curl -OutFile "adventureworks2019.bak" "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak"
```  

#### Bemásolás a containerbe az aktuális könytárból
```
docker cp "adventureworks2019.bak" sql2022:/var/opt/mssql/backup
```

#### Adatbázis visszaállítása
```
docker exec -it sql2022 /opt/mssql-tools/bin/sqlcmd `
   -S localhost -U SA -P "Password123!" `
   -Q "RESTORE DATABASE AdventureWorks2019 FROM DISK = '/var/opt/mssql/backup/adventureworks2019.bak' WITH MOVE 'AdventureWorks2017' TO '/var/opt/mssql/data/
   AdventureWorks2019.mdf', MOVE 'AdventureWorks2017_log' TO '/var/opt/mssql/data/AdventureWorks2019_Log.ldf' "
```

#### Ellenőrzés
```
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd `
   -S localhost -U SA -P "Password123!" `
   -Q "SELECT Name FROM sys.Databases"
```

#### Egyéb parancsok amiket közben használtam:   
lehúzza az utolsó imaget a docker hubról
```docker pull mcr.microsoft.com/mssql/server``` 

futtat 1 konténert a 2019-es sql szerverből
```docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=yourStrong(!)Password" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest```


##### Change SA password   
```
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd `
   -S localhost -U SA -P "<YourStrong!Passw0rd>" `
   -Q "ALTER LOGIN SA WITH PASSWORD='<YourNewStrong!Passw0rd>'"   
``` 

#### Filenév ellenőrzés
```  
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd -S localhost `
   -U SA -P "Password123!" `
   -Q "RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/adventureworks2019.bak'"   
```  