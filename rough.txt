# Advanced SQL & Database Design for Backend Engineering

---

## Part 7: DDL — Building and Managing Tables

**Data Definition Language (DDL)** defines the structure of your database.

### Creating Tables

```sql
CREATE TABLE LoyaltyProgram (
    LoyaltyID INT AUTO_INCREMENT,
    SPID VARCHAR(10),
    Points INT DEFAULT 0,
    Status VARCHAR(20),
    EnrollmentDate DATETIME,
    PRIMARY KEY (LoyaltyID)
);
```

### Altering Tables

Used to modify existing table structures.

```sql
-- Add a new column
ALTER TABLE LoyaltyProgram ADD COLUMN LastUpdated DATETIME;

-- Modify an existing column type
ALTER TABLE LoyaltyProgram MODIFY COLUMN Status VARCHAR(50);

-- Rename a column
ALTER TABLE LoyaltyProgram RENAME COLUMN Status TO TierLevel;
```

### Removing Data and Tables

* **DROP**: Deletes table structure + data (irreversible).
* **TRUNCATE**: Deletes data, keeps structure.
* **DELETE**: Removes rows (transaction-safe).

```sql
DROP TABLE OldSalesData;
TRUNCATE TABLE TempLog;
```

---

## Part 8: Data Integrity and Constraints

Constraints ensure **accuracy and reliability** of your data.

### Primary Key & Foreign Key

```sql
CREATE TABLE OrderAudit (
    AuditID INT PRIMARY KEY,
    SPID VARCHAR(10),
    ActionDate DATETIME,
    FOREIGN KEY (SPID) REFERENCES People(SPID)
);
```

### Unique & Check Constraints

```sql
ALTER TABLE LoyaltyProgram
ADD CONSTRAINT UQ_SPID UNIQUE (SPID);

ALTER TABLE LoyaltyProgram
ADD CONSTRAINT CHK_Points CHECK (Points >= 0);
```

---

## Part 9: Transactions and Concurrency (ACID)

A **transaction** is a single logical unit of work.

### ACID Properties

* **A**tomicity — All or nothing
* **C**onsistency — Always valid state
* **I**solation — No interference
* **D**urability — Permanent after commit

### Controlling Transactions

```sql
START TRANSACTION;

UPDATE Accounts SET Balance = Balance - 100 WHERE ID = 1;
UPDATE Accounts SET Balance = Balance + 100 WHERE ID = 2;

COMMIT;   -- or ROLLBACK;
```

### Isolation Levels

* **Read Uncommitted** — allows dirty reads
* **Read Committed** — prevents dirty reads
* **Repeatable Read** — consistent rows
* **Serializable** — highest safety, lowest performance

---

## Part 10: Advanced Analytics (Window Functions & CTEs)

### Window Functions

#### Ranking Functions

```sql
SELECT 
    Salesperson,
    Amount,
    ROW_NUMBER() OVER(ORDER BY Amount DESC) AS RowNum,
    RANK() OVER(ORDER BY Amount DESC) AS RankVal,
    DENSE_RANK() OVER(ORDER BY Amount DESC) AS DenseRankVal
FROM Sales;
```

#### Lag & Lead (Time-Series)

```sql
SELECT 
    SaleDate,
    Amount,
    LAG(Amount, 1) OVER(ORDER BY SaleDate) AS PreviousSale,
    LEAD(Amount, 1) OVER(ORDER BY SaleDate) AS NextSale
FROM Sales;
```

#### Running Totals

```sql
SELECT 
    SaleDate,
    Amount,
    SUM(Amount) OVER(ORDER BY SaleDate) AS RunningTotal
FROM Sales;
```

### CTEs (Common Table Expressions)

#### Simple CTE

```sql
WITH HighValueSales AS (
    SELECT * FROM Sales WHERE Amount > 5000
)
SELECT * FROM HighValueSales;
```

#### Recursive CTE (Hierarchies)

```sql
WITH RECURSIVE EmployeeTree AS (
    SELECT ID, Name, ManagerID 
    FROM Employees 
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.ID, e.Name, e.ManagerID
    FROM Employees e
    JOIN EmployeeTree et ON e.ManagerID = et.ID
)
SELECT * FROM EmployeeTree;
```

---

## Part 11: Subqueries and Set Operations

### Correlated Subquery

```sql
SELECT * FROM People p
WHERE EXISTS (
    SELECT 1 FROM Sales s
    WHERE s.SPID = p.SPID AND s.Amount > 10000
);
```

### Set Operators

* `UNION` — distinct
* `UNION ALL` — includes duplicates
* `INTERSECT` — common rows
* `EXCEPT / MINUS` — rows in A not in B

---

## Part 12: Advanced Grouping

#### ROLLUP, CUBE, GROUPING SETS

```sql
SELECT 
    GeoID,
    PID,
    SUM(Amount)
FROM Sales
GROUP BY GeoID, PID WITH ROLLUP;
```

* **ROLLUP** → hierarchical subtotals
* **CUBE** → all combinations
* **GROUPING SETS** → custom combinations

---

## Part 13: Performance Tuning (Indexes & Explain Plans)

### Index Types

* **Clustered Index** — sorts actual rows
* **Non-Clustered Index** — separate structure pointing to data

#### When indexes help:

* WHERE
* JOIN
* ORDER BY

#### When indexes hurt:

* Frequent INSERT/UPDATE/DELETE
* Large storage cost

### EXPLAIN

```sql
EXPLAIN SELECT * FROM Sales WHERE Amount > 5000;
```

Look for:

* **Table Scan (bad)**
* **Index Seek / Range Scan (good)**

---

## Part 14: Programmable SQL (Procedures, Functions, Triggers)

### Stored Procedure

```sql
DELIMITER //
CREATE PROCEDURE GetSalesByRegion(IN regionName VARCHAR(50))
BEGIN
    SELECT * FROM Sales s
    JOIN Geo g ON s.GeoID = g.GeoID
    WHERE g.Geo = regionName;
END //
DELIMITER ;
```

### Function (UDF)

```sql
CREATE FUNCTION CalculateTax(amount DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
RETURN amount * 0.15;
```

### Trigger

```sql
CREATE TRIGGER BeforeSalesInsert
BEFORE INSERT ON Sales
FOR EACH ROW
BEGIN
    IF NEW.Amount < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Amount cannot be negative';
    END IF;
END;
```

---

## Part 15: Modern SQL & Data Modeling

### JSON Support

```sql
CREATE TABLE ProductsJSON (
    ID INT,
    Attributes JSON
);

SELECT 
    ID,
    JSON_EXTRACT(Attributes, '$.color') AS Color
FROM ProductsJSON;
```

### Star Schema (Data Warehousing)

* **Fact Tables:** Sales, Metrics
* **Dimension Tables:** People, Products, Geo

#### Slowly Changing Dimensions (SCD)

* **Type 1:** overwrite
* **Type 2:** add rows with `StartDate`, `EndDate`

### Partitioning

Useful for large time-series datasets.

---

## Part 16: Administration & Security

### Users & Permissions

```sql
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'password123';

GRANT SELECT, INSERT ON AwesomeChocolates.* 
TO 'app_user'@'localhost';

REVOKE DELETE ON AwesomeChocolates.* 
FROM 'app_user'@'localhost';
```

### Backup Types

* **Logical** — mysqldump
* **Physical** — underlying files

---

## Part 17: Best Practices & Anti-Patterns

### Best Practices

* Use **explicit column names**
* Avoid `SELECT *`
* Use meaningful aliases
* Comment complex logic

### SQL Anti-Patterns

#### 1. Implied Joins

❌ Bad

```sql
SELECT * FROM A, B WHERE A.id = B.id;
```

✔️ Good

```sql
SELECT * FROM A JOIN B ON A.id = B.id;
```

#### 2. N+1 Query Issue

Use JOIN instead of performing queries inside loops.

#### 3. Storing lists in columns

Break out into normalized tables.

#### 4. Using functions on indexed columns

Avoid:

```sql
WHERE YEAR(SaleDate) = 2022;
```

Use:

```sql
WHERE SaleDate BETWEEN '2022-01-01' AND '2022-12-31';
```

---

> **“The goal is to turn data into information, and information into insight.” — Carly Fiorina**

---