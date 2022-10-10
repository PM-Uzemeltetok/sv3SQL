# Mentés, visszaállítás Backup / Restore

## Videólista

1. [NA - 4. Microsoft SQL Server 2017 adatbázisok mentése és visszaállítása](https://e-learning.training360.com/courses/take/na-4-microsoft-sql-server-2017-adatbazisok-mentese-es-visszaallitasa/lessons/17741814-1-1-az-adatfajlok-es-tranzakcionaplo-fajlok-megismerese)
2. [NA - 5. Microsoft SQL Server 2017 feladatok automatizálása](https://e-learning.training360.com/courses/take/na-5-microsoft-sql-server-2017-feladatok-automatizalasa/lessons/17741837-1-az-sql-server-agent-inditasi-beallitasai)  

Források és részeletes leírások:
- [Backup Overview (SQL Server)](https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/backup-overview-sql-server?view=sql-server-ver15)  
- [SQL Server Backup Options and Commands Tutorial](https://www.mssqltips.com/sqlservertutorial/1/sql-server-backup-options-and-commands-tutorial/)

## Recovery Modell  
Meghatározza milyen mentés típusokat készíthetünk  

* Simple (Nincs log mentés)  
* Full 
* Bulk-logged

## Mentési típusok  

* [Full Database Backup](https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/full-database-backups-sql-server?view=sql-server-ver15)
* [Differential](https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/differential-backups-sql-server?view=sql-server-ver15)
* [Tranzaction log](https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/transaction-log-backups-sql-server?view=sql-server-ver15)
* [Tail-log](https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/tail-log-backups-sql-server?view=sql-server-ver15)

## Mentési helyek

**Backup device:** Névvel eltárolt mentési hely, kényelmes, javasolt  
Instance\Server Object\Backup Devices  

[SQL Server BACKUP DATABASE command](https://www.mssqltips.com/sqlservertutorial/20/sql-server-backup-database-command/)

```sql
BACKUP DATABASE DatabaseName TO DISK 'drive:\path\filename.bak' -- TO DISK nélkül default utvonalra ment
BACKUP DATABASE DatabaseName TO DISK 'drive:\path\filename.bak' WITH DIFFERENTIAL
BACKUP DATABASE DemoDB TO DemoDBBackupDevice WITH DIFFERENTIAL; 
BACKUP LOG DataBaseName TO 'drive:\path\filename.trn'
BACKUP LOG DataBaseName TO DeviceName; 

RESTORE DATABASE DatabaseName FROM DISK 'drive:\path\filename.bak'

RESTORE HEADERONLY FROM DISK = N'C:\Databases\Backup\DemoDB.bak' 
RESTORE HEADERONLY FROM BackupDevice
```  
 
## Transaction Log
[Reading the transaction log in SQL Server – from hacks to solutions](https://www.sqlshack.com/how-to-read-a-sql-server-transaction-log/)
```sql
-- Transaction log lekérdezés
SELECT [Current LSN],
       [Operation],
       [Transaction Name],
       [Transaction ID],
       [Transaction SID],
       [SPID],
       [Begin Time]
FROM   fn_dblog(null,null)
ORDER BY [Begin Time] DESC

```  

# Automatizáció  

SQL Server Agent szolgáltatásnak futnia kell

## Jobok  

[Create a Job](https://docs.microsoft.com/en-us/sql/ssms/agent/create-a-job?view=sql-server-ver15)  

* Kategóriákba sorolva, előre definiált, sajátot is létrehozhatunk
* Ki/be kapcsolható (Enable/Disable)
* Lépésenkénti végrehajtás
    - A lépések SQL utasítások 
* Időzítési lehetőség
* Job Activity Monitor
* Job history
* Figyelmeztetések (Alerts) - hiba esetén
    - SQL hibaüzentre 
    - Server event
    - WMI event
* Ertesítések (Notifications) - siker esetén
    - Email
    - Application log bejegyzés
    - Job törlése 



[SQL Server technical documentation](https://docs.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver15())


SQL Server Recovery Models
There are three types of SQL Server database recovery models: Simple, Full and Bulk-Logged. The database recovery model determines the following:

 New call-to-action
How long to keep data in the transaction log
Which types of backups you can perform
Which types of database restore you can perform
Simple Recovery
For databases using the Simple Recovery model, SQL Server automatically truncates the log on checkpoint operations, freeing up used space in the transaction log for additional transactions. When using Simple Recovery, transaction log backups are not supported.

In terms of transaction log backup management, this model is the simplest, but it eliminates the ability to perform point-in-time restores of databases. If your data changes frequently, and you’re running infrequent full and differential backups, this can result in unacceptable data loss if a database needs to be restored.

Point-in-time restores are not supported and you can only restore the database up to the time of the latest full or differential database backup. The frequency of these backups determines how much data loss you may experience if a database using the Simple Recovery model needs to be restored.

As an example, you will be able to restore to a more current point in time if you run differential backups every 4 hours as compared to only running a full backup once a day. Data loss depends entirely on the frequency you execute full and differential backups.

Full Recovery
Under a Full Recovery model, all transactions remain in the transaction log file until you run a transaction log backup. The transaction log will never be auto-truncated as would occur under the Simple Recovery model.

With the Full Recovery model, you can recover your database to any point in time within a transaction log backup. As an example, if you run transaction log backups every 30 minutes, you can recover a database to the 15-minute mark within a transaction log backup; before that delete or update statement incorrectly changed data in the database. Data loss is minimized.

If you are using the Full Recovery model for your database, you should keep in mind that the transaction log continues to store information as changes are made to the database. In order to prevent your transaction logs from growing to enormous sizes and potentially filling up your disk drive, you need to perform regular transaction log backups. Once the transaction log backup is complete, the information that was backed up from the transaction log is cleared and space can be re-used for new transactions.

It’s important to note that the size of the transaction log on disk will not change, and you should not expect it to. Transaction logs should be pre-sized based on expected activity and as a preventive measure can be set to auto-grow if the available space in the transaction log is used up. You should avoid shrinking these files using SQL Server T-SQL commands unless absolutely necessary.

Bulk-Logged Recovery
The Bulk-Logged Recovery model is similar to Full Recovery except that certain bulk operations are not fully logged in the transaction log (this is called minimal logging). Operations like SELECT INTO, BULK import, and TRUNCATE operations are examples of minimally logged operations. With the Bulk-Logged Recovery model, your transaction logs may not become as large as they would under the Full Recovery model.

The downside, however, is that bulk-logged operations in this model prevent you from performing a point-in-time restore. So there is a potential for more data loss. If you’re not sure that Bulk-Logged is the right recovery model for your needs, it’s recommended you stick with Full Recovery.