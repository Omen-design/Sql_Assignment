create database subqueries;
use subqueries;

## Employee Dataset:

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id VARCHAR(5),
    salary INT
);

INSERT INTO Employee 
(emp_id, name, department_id, salary) 
VALUES
(101, 'Abhishek', 'D01', 62000),
(102, 'Shubham',  'D01', 58000),
(103, 'Priya',    'D02', 67000),
(104, 'Rohit',    'D02', 64000),
(105, 'Neha',     'D03', 72000),
(106, 'Aman',     'D03', 55000),
(107, 'Ravi',     'D04', 60000),
(108, 'Sneha',    'D04', 75000),
(109, 'Kiran',    'D05', 70000),
(110, 'Tanuja',   'D05', 65000);

select * from Employee;

## Department Dataset:

CREATE TABLE Department (
    department_id VARCHAR(5) PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO Department 
(department_id, department_name, location) 
VALUES
('D01', 'Sales',     'Mumbai'),
('D02', 'Marketing', 'Delhi'),
('D03', 'Finance',   'Pune'),
('D04', 'HR',        'Bengaluru'),
('D05', 'IT',        'Hyderabad');

## Sales Dataset:

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount INT,
    sale_date DATE,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

INSERT INTO Sales 
(sale_id, emp_id, sale_amount, sale_date) 
VALUES
(201, 101,  4500, '2025-01-05'),
(202, 102,  7800, '2025-01-10'),
(203, 103,  6700, '2025-01-14'),
(204, 104, 12000, '2025-01-20'),
(205, 105,  9800, '2025-02-02'),
(206, 106, 10500, '2025-02-05'),
(207, 107,  3200, '2025-02-09'),
(208, 108,  5100, '2025-02-15'),
(209, 109,  3900, '2025-02-20'),
(210, 110,  7200, '2025-03-01');

select max(sale_amount) from sales;

select * from Sales;

## Basic Level
## 1.Retrieve the names of employees who earn more than the average salary of all employees.

select name from Employee
where salary >(select avg(salary) as Avg_Salary from Employee);

## 2.Find the employees who belong to the department with the highest average salary.

SELECT e.emp_id, e.name, e.department_id, d.department_name, d.location FROM Employee e
JOIN Department d
    ON e.department_id = d.department_id
WHERE e.department_id = (SELECT department_id FROM Employee
						GROUP BY department_id
                        ORDER BY AVG(salary) DESC
                        limit 1);

## 3.List all employees who have made at least one sale.

SELECT e.emp_id, e.name, e.department_id,s.sale_id,s.sale_amount,s.sale_date FROM Employee e
inner join Sales s
on e.emp_id=s.emp_id;

## 4.Find the employee with the highest sale amount.

SELECT e.emp_id, e.name, e.department_id FROM Employee e
JOIN Sales s
    ON e.emp_id = s.emp_id
WHERE s.sale_amount = (
    SELECT MAX(sale_amount)
    FROM Sales
);

## 5.Retrieve the names of employees whose salaries are higher than Shubham’s salary.

select name from Employee
where salary>(select salary from Employee where name='Shubham');

## Intermediate Level
## 1.Find employees who work in the same department as Abhishek.

SELECT * FROM Employee e
WHERE e.department_id = (
    SELECT department_id
    FROM Employee
    WHERE name = 'Abhishek'
);

## 2.List departments that have at least one employee earning more than ₹60,000.

SELECT *
FROM Department d
WHERE d.department_id IN (
    SELECT department_id
    FROM Employee
    WHERE salary > 60000
);

## 3.Find the department name of the employee who made the highest sale.

SELECT department_name
FROM Department d
join Employee e
on d.department_id=e.department_id
join sales s
on e.emp_id=s.emp_id
where s.sale_amount=(select max(sale_amount) from sales);

## 4. Retrieve employees who have made sales greater than the average sale amount.

SELECT DISTINCT e.emp_id, e.name, e.department_id, e.salary
FROM Employee e
JOIN Sales s
    ON e.emp_id = s.emp_id
WHERE s.sale_amount > (
    SELECT AVG(sale_amount)
    FROM Sales
);

## 5.Find the total sales made by employees who earn more than the average salary.

SELECT SUM(s.sale_amount) AS total_sales
FROM Sales s
JOIN Employee e
    ON s.emp_id = e.emp_id
WHERE e.salary > (
    SELECT AVG(salary)
    FROM Employee
);

## Advanced Level
## 1.Find employees who have not made any sales.

SELECT e.emp_id, e.name, e.department_id, e.salary
FROM Employee e
LEFT JOIN Sales s
    ON e.emp_id = s.emp_id
WHERE s.emp_id IS NULL;

## 2.List departments where the average salary is above ₹55,000.

select d.department_id,d.department_name,d.location from department d
join Employee e
on d.department_id=e.department_id
GROUP BY d.department_id, d.department_name, d.location
HAVING AVG(e.salary) > 55000;

## 3. Retrieve department names where the total sales exceed ₹10,000.

SELECT d.department_name
FROM Department d
JOIN Employee e
    ON d.department_id = e.department_id
JOIN Sales s
    ON e.emp_id = s.emp_id
GROUP BY d.department_name
HAVING SUM(s.sale_amount) > 10000;

## 4.Find the employee who has made the second-highest sale.

SELECT e.emp_id, e.name, s.sale_amount
FROM Employee e
JOIN Sales s
    ON e.emp_id = s.emp_id
WHERE s.sale_amount = (
    SELECT MAX(sale_amount) FROM Sales
    WHERE sale_amount < (
        SELECT MAX(sale_amount)
        FROM Sales
    )
);

## 5.Retrieve the names of employees whose salary is greater than the highest sale amount recorded.

SELECT name
FROM Employee
WHERE salary > (SELECT MAX(sale_amount) FROM Sales);

