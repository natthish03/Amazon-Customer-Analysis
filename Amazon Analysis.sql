CREATE DATABASE amazon_fresh;
USE amazon_fresh;
 
#Task 3: Queries
SELECT *
FROM customers
WHERE city = 'West Paula';


SELECT *
FROM products
WHERE category = 'Fruits';

# Task 4: DDL - Create Customers table with constraints

CREATE TABLE customers_new (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    age INT NOT NULL CHECK (age > 18),
    prime_member VARCHAR(10)
);


#Task 5: Insert 3 new rows into Products

INSERT INTO products (productID, productName, Category, SubCategory, PricePerUnit, StockQuantity, SupplierID)
VALUES
(201, 'Apple', 'Fruits', 'sub-Vegetables', 120.00, 100, '4548-jdhcv'),
(202, 'Milk', 'Dairy', 'sub-Meat', 60.00, 200, '7841-hysfty'),
(203, 'Rice', 'Grains', 'sub-grains', 55.00, 300, '9234-uqjkx');

# Task 6: Update stock quantity of a product (e.g., ProductID = 102)

SET SQL_SAFE_UPDATES = 0;
UPDATE products
SET StockQuantity = 150
WHERE ProductID = 201;

# Task 7: Delete a supplier where city matches a value (e.g., 'Delhi')

select * from suppliers;
DELETE FROM suppliers
WHERE city = 'Hullberg';

# Task 8: Add constraints

ALTER TABLE reviews
ADD CONSTRAINT ReviewText CHECK (Rating BETWEEN 1 AND 5);

ALTER TABLE customers
MODIFY PrimeMember VARCHAR(10) DEFAULT 'No';

#Task 9: Queries using clauses

SELECT *
FROM orders
WHERE OrderDate > '2024-01-01';

# b. Products with avg rating > 4
SELECT p.ProductName,
       SUM(od.Quantity * od.UnitPrice) AS total_sales
FROM order_details od
JOIN products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY total_sales DESC;

# c. Rank products by total sales
SELECT c.Name,
       SUM(od.Quantity * od.UnitPrice) AS total_spent
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
GROUP BY c.Name
HAVING total_spent > 5000
ORDER BY total_spent DESC;

# Task 10: Identifying High-Value Customers

SELECT c.CustomerID, c.Name, 
       SUM(od.Quantity * od.UnitPrice) AS TotalSpending,
       RANK() OVER (ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS SpendingRank
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.Name
HAVING TotalSpending > 5000;

# Task 11
SELECT o.OrderID,
       SUM(od.Quantity * od.UnitPrice) AS order_revenue
FROM orders o
JOIN order_details od ON o.OrderID = od.OrderID
GROUP BY o.OrderID;

SELECT c.Name,
       COUNT(o.OrderID) AS total_orders
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name
ORDER BY total_orders DESC
LIMIT 1;

SELECT s.SupplierName,
       SUM(p.StockQuantity) AS total_stock
FROM suppliers s
JOIN products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierName
ORDER BY total_stock DESC
LIMIT 1;

# TASK 12: Normalization to 3NF

CREATE TABLE categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);
ALTER TABLE products
ADD CategoryID INT,
ADD FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID);

# TASK 13: Subqueries

SELECT p.ProductName
FROM products p
JOIN (
    SELECT od.ProductID
    FROM order_details od
    GROUP BY od.ProductID
    ORDER BY SUM(od.Quantity * od.UnitPrice) DESC
    LIMIT 3
) top_products ON p.ProductID = top_products.ProductID;

SELECT *
FROM customers
WHERE CustomerID NOT IN (
    SELECT CustomerID FROM orders
);


# Task 14: Provide actionable insights:

SELECT City,
       COUNT(*) AS prime_count
FROM customers
WHERE PrimeMember = 'Yes'
GROUP BY City
ORDER BY prime_count DESC;


SELECT p.Category,
       COUNT(*) AS order_count
FROM order_details od
JOIN products p ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY order_count DESC
LIMIT 3;




