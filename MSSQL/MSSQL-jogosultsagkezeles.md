# Jogosultság kezelés

## Videólista

1. [NA - 3. A Microsoft SQL Server 2017 jogosultsági rendszere](https://e-learning.training360.com/courses/take/na-3-a-microsoft-sql-server-2017-jogosultsagi-rendszere/lessons/17741793-1-loginok-es-userek-windows-es-sql-autentikacio)

Részeletes leírások:  
- [Security for SQL Server Database Engine and Azure SQL Database](https://docs.microsoft.com/en-us/sql/relational-databases/security/security-center-for-sql-server-database-engine-and-azure-sql-database?view=sql-server-ver15)    
- [Determining Effective Database Engine Permissions](https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/determining-effective-database-engine-permissions?view=sql-server-ver15)  

## Komponensek  
**Securable:** [Securables](https://docs.microsoft.com/en-us/sql/relational-databases/security/securables?view=sql-server-ver15)  
The server and database resources for which access is regulated  
- Server-Level – For example databases, logins, endpoints, availability groups and server roles  
- Database-Level – For example database role, application roles, schema, certificate, full text catalog, user  
- Schema-Level – For example table, view, procedure, function, synonym   

**Permissions:** [Permissions](https://docs.microsoft.com/en-us/sql/relational-databases/security/permissions-database-engine?view=sql-server-ver15)  
The types of access that principals have to specific securables 
- ```GRANT```
- ```DENY```
- ```REVOKE```
- [Permissions Hierarchy](https://docs.microsoft.com/en-us/sql/relational-databases/security/permissions-hierarchy-database-engine?view=sql-server-ver15)

**Principals:** [Principals](https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/principals-database-engine?view=sql-server-ver15)   
People or processes that are authorized to access a particular SQL Server instance. 
A security principal is an identity that uses SQL Server and can be granted permission to access and modify data. 
Principals can be individuals, groups of users, roles or entities that are treated as people (such as dbowner, dbo or sysadmin).  

## Roles  
* Role-Based Security
* [Server-Level Roles](https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/server-level-roles?view=sql-server-ver15)
    - Fixed server roles  
    - User-defined server roles   ```CREATE SERVER ROLE serverrole | ALTER SERVER ROLE serverrole ADD MEMBER [test\exampleuser] ```
* [Database-Level Roles](https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/database-level-roles?view=sql-server-ver15)
    - Fixed database roles 
    - User-defined database roles ``` CREATE ROLE dbrole | GRANT SELECT ON DATABASE::TestDatabase TO dbrole | ALTER ROLE dbrole ADD MEMBER exampleuser2 ```  
* [Application Roles](https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/application-roles?view=sql-server-ver15)


```sql
-- List all built in permissions
-- fn_my_permissions ( securable , 'securable_class' )
SELECT * FROM sys.fn_builtin_permissions(DEFAULT);

--List all securables
SELECT distinct class_desc FROM sys.fn_builtin_permissions(DEFAULT); 

--List all my server level effective permission on SQL Server Instance
SELECT * FROM fn_my_permissions(NULL, 'SERVER');  

--List all effective permissions on database "AdventureWorks2019"
USE AdventureWorks2019
GO
SELECT * FROM fn_my_permissions(NULL, 'Database');  
GO

--List all effective permissions for user test in database AdventureWorks2019
EXECUTE AS USER = 'test' -- léteznie kell
GO
USE AdventureWorks2019
GO
SELECT * FROM fn_my_permissions(null, 'database'); 
GO

```
```sql
-- Server login

CREATE LOGIN csoportlogin   
    WITH PASSWORD = 'Password123'; 
GO

-- DB USER létrehozás
CREATE USER csoportlogin FROM LOGIN csoportlogin;

-- --------------------------------------
-- DB ROLE 
CREATE ROLE [Filmkezelo]
GO

--  ADD ROLE Member (Role tagjai)
ALTER ROLE Filmkezelo
    ADD MEMBER csoportlogin;  

--  DROP ROLE Member (Role tagjai)
ALTER ROLE Filmkezelo
    DROP MEMBER csoportlogin

EXEC sp_addrolemember 'Filmkezelo', 'csoportlogin';

-- --------------------------------------
-- Jogosultság kiosztás
-- AUTHORIZATION  PERMISSION  ON  SECURABLE::NAME  TO  PRINCIPAL;

GRANT SELECT ON OBJECT::dbo.Genre TO Filmkezelo; GRANT UPDATE ON OBJECT::dbo.Genre TO Filmkezelo; GRANT INSERT ON OBJECT::dbo.Genre TO Filmkezelo;
GRANT SELECT ON OBJECT::dbo.Actor TO Filmkezelo; GRANT UPDATE ON OBJECT::dbo.Actor TO Filmkezelo; GRANT INSERT ON OBJECT::dbo.Actor TO Filmkezelo;
GRANT SELECT ON OBJECT::dbo.Film TO Filmkezelo; GRANT UPDATE ON OBJECT::dbo.Film TO Filmkezelo; GRANT INSERT ON OBJECT::dbo.Film TO Filmkezelo;
GRANT SELECT ON OBJECT::dbo.FilmActor TO Filmkezelo; GRANT UPDATE ON OBJECT::dbo.FilmActor TO Filmkezelo; GRANT INSERT ON OBJECT::dbo.FilmActor TO Filmkezelo;
GRANT SELECT ON OBJECT::dbo.FilmGenre TO Filmkezelo; GRANT UPDATE ON OBJECT::dbo.FilmGenre TO Filmkezelo; GRANT INSERT ON OBJECT::dbo.FilmGenre TO Filmkezelo;

GRANT EXEC ON OBJECT::dbo.UjFilm TO Filmkezelo;
-- --------------------------------------
```

### Források
[List SQL Server Login and User Permissions with fn_my_permissions](https://www.mssqltips.com/sqlservertip/6828/sql-server-login-user-permissions-fn-my-permissions/)  
[Guide to SQL Server Permissions](https://blog.netwrix.com/2020/10/16/guide-to-sql-server-permissions/)  

### Feladatok
- Hozz létre egy sql server felhasználót (scripteltesd le a szerverrel)  
- Kösd a saját adatbázisodhoz a saját adatbázisodhoz (scripteltesd le a szerverrel - nézd meg a változást)  
- csak reader és writer jogot adj a felhasználónak a db-hez (scripteltesd le a szerverrel - nézd meg a változást)  
- próbálj meg új táblát létrehozni az új felhasználóval, sikerült?  
- készíts egy másik felhasználót akinek csak read joga van az adatbázishoz - TSQL scripttel.  

[SQL Server technical documentation](https://docs.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver15())