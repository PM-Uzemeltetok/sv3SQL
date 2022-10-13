# Indexek, adattárolás  

## Sor alapú tárolás

* Adatsor alapú tárolás
* Page-ek 16K méretűek
* B-tree, hierachikus formában
* Adatok levél szinten
* Töredezettség
* Telítettség
* Növekszik az adatbázis minden indexkszel
* Lassúló ```INSERT UPDATE DELETE``` tranzakciók végrehajtása több index esetén
* Megfelelő index használata esetén radikálisan csökkenthető a lekérdezések errőforrásigénye
* Indexek hasznosságának ellnőrzése (Elégszer van használva)

### Index típusok
* Clustered index - An index in which the logical order of the key values determines the physical order of the corresponding rows in a table. A clustered index on a view must be unique.
* Non Clustered Index -  An index that specifies the logical ordering of a table. With a nonclustered index, the physical order of the data rows is independent of their indexed order.
* Unique Index - A unique index is one in which no two rows are permitted to have the same index key value. 
* Filter Index - Creates a filtered index by specifying which rows to include in the index. The filtered index must be a nonclustered index on a table. ```WHERE <feltétel> | WHERE ComponentID IN (533, 324, 753)```

```sql
CREATE INDEX index_name ON table_name (column_list)
-- ---
CREATE CLUSTERED INDEX IndexName ON TableName (ID);
CREATE NONCLUSTERED  INDEX IndexName ON TableName (ColumnName);
CREATE NONCLUSTERED  INDEX IndexName ON TableName (ColumnName DESC, ColumnName ASC, ColumnName DESC);
-- ---
SELECT * FROM TableName WITH (INDEX(IndexName))
```

### Rebuild index
```sql
ALTER INDEX IndexName ON TableName REBUILD
```

### Források
[Top 10 questions and answers about SQL Server Indexes](https://www.sqlshack.com/top-10-questions-answers-sql-server-indexes/)  

## Indexek és adattárolás monitorzása

```sql
EXPLAIN SELECT * from tablename
```

### Fizikai adattárolás

![image1](/.pics/indexbtree.png)  
![image1](/.pics/pages.png)  
