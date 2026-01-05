use Joins;

## Create the following dummy tables in MySQL Workbench using CREATE FUNCTION-

## create customer table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);

## insert data in customer table
INSERT INTO 
Customers (CustomerID, CustomerName, City)
VALUES
(1, 'John Smith', 'New York'),
(2, 'Mary Johnson', 'Chicago'),
(3, 'Peter Adams', 'Los Angeles'),
(4, 'Nancy Miller', 'Houston'),
(5, 'Robert White', 'Miami');

select * from Customers;

## create orders table

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount INT
);

## insert data in orders

INSERT INTO Orders (OrderID, CustomerID, OrderDate, Amount) VALUES
(101, 1, '2024-10-01', 250),
(102, 2, '2024-10-05', 300),
(103, 1, '2024-10-07', 150),
(104, 3, '2024-10-10', 450),
(105, 6, '2024-10-12', 400);

select * from Orders;

## create table Payments

CREATE TABLE Payments (
    PaymentID VARCHAR(10) PRIMARY KEY,
    CustomerID INT,
    PaymentDate DATE,
    Amount INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

## insert data in Payments

INSERT INTO Payments (PaymentID, CustomerID, PaymentDate, Amount) VALUES
('P001', 1, '2024-10-02', 250),
('P002', 2, '2024-10-06', 300),
('P003', 3, '2024-10-11', 450),
('P004', 4, '2024-10-15', 200);

select * from Payments;

## create table Employees

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

## insert data in Employees

INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID) VALUES
(1, 'Alex Green', NULL);

INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID) VALUES
(2, 'Brian Lee', 1),
(3, 'Carol Ray', 1),
(4, 'David Kim', 2),
(5, 'Eva Smith', 2);

select * from Employees;

## Question 1. Retrieve all customers who have placed at least one order.

select distinct c.CustomerID, c.CustomerName, c.City from Customers c
inner join Orders o
on c.CustomerID=o.CustomerID;

## Question 2. Retrieve all customers and their orders, including customers who have not placed any orders.

select c.CustomerID, c.CustomerName, c.City, o.OrderID, o.OrderDate, o.Amount 
from Customers c
left join Orders o
on c.CustomerID=o.CustomerID;

## Question 3. Retrieve all orders and their corresponding customers, including orders placed by unknown customers.

select o.OrderID, o.OrderDate, o.Amount ,c.CustomerID, c.CustomerName, c.City
from Customers c
right join Orders o
on c.CustomerID=o.CustomerID;

## Question 4. Display all customers and orders, whether matched or not.

SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City,
    o.OrderID,
    o.OrderDate,
    o.Amount
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
UNION
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City,
    o.OrderID,
    o.OrderDate,
    o.Amount
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID;

## Question 5. Find customers who have not placed any orders.

SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

## Question 6. Retrieve customers who made payments but did not place any orders.

SELECT DISTINCT
    c.CustomerID,
    c.CustomerName,
    c.City
FROM Customers c
inner JOIN Payments p
ON c.CustomerID = p.CustomerID
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

## Question 7. Generate a list of all possible combinations between Customers and Orders.

SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    o.OrderID,
    o.OrderDate,
    o.Amount
FROM Customers c
CROSS JOIN Orders o
order by CustomerID;

## Question 8. Show all customers along with order and payment amounts in one table.

SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    o.OrderID,
    o.Amount AS OrderAmount,
    p.PaymentID,
    p.Amount AS PaymentAmount
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
LEFT JOIN Payments p
ON c.CustomerID = p.CustomerID;

## Question 9. Retrieve all customers who have both placed orders and made payments.

SELECT DISTINCT
    c.CustomerID,
    c.CustomerName,
    c.City
FROM Customers c
inner join Orders o
ON c.CustomerID = o.CustomerID
inner join Payments p
ON c.CustomerID = p.CustomerID;


