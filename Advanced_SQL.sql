-- Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?
-- Answer: A Common Table Expression (CTE) is a temporary named result set created using the WITH clause that can be used inside a SELECT, INSERT, UPDATE, or DELETE statement.
--         It improves readability by breaking complex queries into smaller, logical parts, making them easier to understand and maintain.
-- syntax: WITH cte_name AS (
-- 			SELECT ...
--                         )
-- 		  SELECT * FROM cte_name;

-- Q2. Why are some views updatable while others are read-only? Explain with an example.
-- Answer: A view is updatable only if it is based on a single table and does not contain:

-- JOIN
-- GROUP BY
-- DISTINCT
-- Aggregate functions (SUM, AVG, etc.)

-- Views become read-only when they include these because the database cannot map changes back to a single row in a base table.

-- Example:

-- Updatable view:
-- CREATE VIEW vw_simple AS
-- SELECT ProductID, ProductName, Price
-- FROM Products;

-- Read-only view:
-- CREATE VIEW vw_readonly AS
-- SELECT Category, AVG(Price)
-- FROM Products
-- GROUP BY Category;

-- Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?

-- Answer:

-- Stored procedures:
-- Improve performance (precompiled)
-- Reduce network traffic
-- Increase security (no direct table access)
-- Allow reuse of logic
-- Easier maintenance

-- Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.
-- Answer:
-- Triggers automatically execute when an event like INSERT, UPDATE, or DELETE happens on a table.

-- Use case:
-- When a product is deleted, automatically save it into an archive table for record keeping.

-- Q5. Explain the need for data modelling and normalization when designing a database.
-- Answer:
-- Data modeling organizes data structure before building the database.
-- Normalization removes data redundancy and improves data integrity by splitting data into related tables.

-- Benefits:
-- Avoids duplicate data
-- Reduces storage
-- Prevents update anomalies
-- Improves consistency

-- Dataset (Use for Q6–Q9)

CREATE DATABASE Advanced;
USE Advanced;


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(1, 'Keyboard', 'Electronics', 1200),
(2, 'Mouse', 'Electronics', 800),
(3, 'Chair', 'Furniture', 2500),
(4, 'Desk', 'Furniture', 5500);


CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Sales VALUES
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11');

-- Q6. Write a CTE to calculate the total revenue for each product
-- (Revenues = Price × Quantity), and return only products where  revenue > 3000.

WITH RevenueCTE AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        p.Price * s.Quantity AS Revenue
    FROM Products p
    JOIN Sales s
        ON p.ProductID = s.ProductID
)
SELECT *
FROM RevenueCTE
WHERE Revenue > 3000;

-- Q7. Create a view named  vw_CategorySummary that shows:
-- Category, TotalProducts, AveragePrice.

CREATE VIEW vw_CategorySummary AS
SELECT 
    Category,
    COUNT(ProductName) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Categvw_categorysummaryory;

-- Q8. Create an updatable view containing ProductID, ProductName, and Price.
-- Then update the price of ProductID = 1 using the view.

CREATE VIEW vw_ProductUpdate AS
SELECT ProductID, ProductName, Price
FROM Products;

-- Updation in price of productID=1

UPDATE vw_ProductUpdate
SET Price = Price + 100
WHERE ProductID = 1;

-- Q9. Create a stored procedure that accepts a category name and returns all products belonging to that 
-- category.

Delimiter //

create procedure CategoryName(cat_name VARCHAR(50))
begin

select *
from products
where Category=cat_name;

End//
   
Delimiter ;

CALL CategoryName('Electronics');

-- Q10. Create an AFTER DELETE trigger on the Products table that archives deleted product rows into a new table ProductArchive.
-- The archive should store ProductID, ProductName, Category, Price, and DeletedAt timestamp.

CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt DATETIME
);

DELIMITER //

CREATE TRIGGER trg_AfterDeleteProducts
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive
    (ProductID, ProductName, Category, Price, DeletedAt)
    VALUES
    (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price, NOW());
END//

DELIMITER ;

DELETE FROM Sales WHERE ProductID = 2;

DELETE FROM Products WHERE ProductID = 2;

SELECT * FROM ProductArchive;
