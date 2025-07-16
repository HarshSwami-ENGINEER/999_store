
-- SQLBook: Code
-- show table 
-- add entries in table 
-- delete entries in table
-- update entries in table
-- select entries in table
-- select entries in table with condition
-- select entries in table with condition and order by

-- relational queries
-- join queries
-- aggregate queries
-- nested queries
-- subqueries
-- set operations
-- group by
-- having
-- with clause
-- create view


-- -- 1. show table
-- SELECT * FROM Customer;
-- SELECT * FROM product;
-- SELECT * FROM Supplier;
-- SELECT * FROM Category;
-- SELECT * FROM Account;
-- SELECT * FROM Employee;
-- SELECT * FROM Orders;

-- SELECT product_id FROM chooses WHERE customer_id = 1;

-- -- 2. add entries in table
-- insert into Customer (Customer_ID, customer_name, DOB, Gender, customer_address, phone_no, customer_email) values (101, 'Sarthak Kumar', '2002-04-09', 'Male', 'IIITD', '101-387-5766', 'sarthak20241@iiitd.ac.in');

-- 3. delete entries in table
DELETE FROM customer WHERE Customer_ID = 15;
DELETE FROM product WHERE P_id = 10;


-- 4. update entries in table

-- Update the email address of a customer and name of a customer whose customer_id is 1:
UPDATE customer SET customer_email = 'sarthak20241@iiitd.ac.in' WHERE customer_id = 1;
UPDATE customer SET customer_name = 'Sarthak' WHERE customer_id = 1;

-- 5. select entries in table
-- Find the product name and price of the most expensive product.
SELECT Pname, Price
FROM product
WHERE Price = (
    SELECT MAX(p.Price)
    FROM product p
);

-- 6. Find the product name and price of the cheapest product.
SELECT Pname, Price
FROM product
WHERE Price = (
    SELECT MIN(p.Price)
    FROM product p
);

-- 7. Show the total price of an order by a specific customer:
SELECT SUM(Price) FROM product 
WHERE P_id IN (SELECT product_id FROM has WHERE Customer_ID = 1);

-- 8. Retrieve the names and email addresses of all customers who have a rating of 5 in the "Feedback" forum:
SELECT customer_name, customer_email
FROM Customer
JOIN has_rating ON Customer.Customer_ID = has_rating.Customer_ID
WHERE has_rating.forum = 'Feedback' AND has_rating.rating = 8;

-- 9. Show all the products and their corresponding categories (ERROR)
SELECT Pname, Category_Name FROM product 
INNER JOIN has_product ON product.P_id = has_product.product_id 
INNER JOIN has_category ON has_product.Supplier_ID = has_category.Supplier_ID AND has_product.category_id = has_category.category_id 
INNER JOIN Category ON has_category.category_id = Category.Cid;

-- 10. Show the employees and their corresponding resolved customer service issues:
SELECT Ename, forum FROM Employee 
INNER JOIN resolve ON Employee.Employee_ID = resolve.Employee_ID;

-- 11. Find the names of all customers who have placed an order for a product with a price greater than Rs 100 and a quantity greater than 5.
SELECT DISTINCT c.customer_name 
FROM customer c
JOIN has_order o ON c.Customer_ID = o.Customer_ID
JOIN product p, has hp Where hp.product_id = p.P_id
AND p.price > 100 AND hp.quantity > 5;

-- 12. This query retrieves all customer names such that for every product, the customer has ordered that product at least once. We achieve this by using the division operator, which finds all customers who have ordered every product in the database.
SELECT DISTINCT c.customer_name
FROM customer c
WHERE NOT EXISTS (
    SELECT p.Pname
    FROM product p
    WHERE NOT EXISTS (
        SELECT o.customer_id
        FROM chooses o, has hp
        WHERE o.product_id = hp.product_id
        AND o.customer_id = c.Customer_ID
    )
);

-- 13. Retrieve the names of all products and their prices, sorted by price in descending order:/
SELECT Pname, Price
FROM product
ORDER BY Price DESC;

-- 14. Retrieve the names of all customers who have made an order:
SELECT DISTINCT customer_name
FROM Customer
JOIN has_order ON Customer.Customer_ID = has_order.Customer_ID;

-- 15. Retrieve the names of all products in a specific category:
SELECT Pname
FROM product
JOIN chooses ON product.P_id = chooses.product_id
WHERE chooses.category_id = 2;

-- 16. Return the top 5 customers who have spent the most amount of money:
SELECT c.Customer_ID, c.customer_name, SUM(od.Order_Total) AS total_spent
FROM customer c
JOIN has_order o ON c.Customer_ID = o.Customer_ID
JOIN orders od ON o.O_id = od.O_id
GROUP BY c.Customer_ID, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- 17. Return the customer who has placed the most number of orders:
SELECT c.Customer_ID, c.customer_name, COUNT(o.O_id) AS total_orders
FROM customer c
JOIN has_order o ON c.Customer_ID = o.Customer_ID;


-- OLAP Queries 
-- Which customers have placed orders for products in multiple categories?
SELECT Customer_ID, COUNT(DISTINCT category_id) AS Total_Categories
FROM chooses
JOIN has ON has.product_id = chooses.product_id
GROUP BY Customer_ID
HAVING Total_Categories > 1;

-- What is the total revenue generated by each supplier?
SELECT Sname, SUM(Price*quantity*(100-Offer)/100) AS Revenue
FROM Supplier
JOIN has_product ON has_product.Supplier_ID = Supplier.S_id
JOIN product ON product.P_id = has_product.product_id
JOIN chooses ON chooses.product_id = product.P_id
GROUP BY Sname
ORDER BY Revenue DESC;

-- How many customers have made a purchase in each month?
SELECT MONTH(Expected_Delivry) AS Month, COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM Orders
JOIN has_order ON has_order.O_id = Orders.O_id
GROUP BY Month;

-- What are the top 10 best-selling products?
SELECT Pname, SUM(quantity) AS Total_Sales
FROM product
JOIN has ON has.product_id = product.P_id
GROUP BY Pname
ORDER BY Total_Sales DESC
LIMIT 10;

-- What is the total revenue generated by each category?
SELECT Category_Name, SUM(Price*quantity*(100-Offer)/100) AS Revenue
FROM Category
JOIN chooses ON chooses.category_id = Category.Cid
JOIN product ON product.P_id = chooses.product_id
GROUP BY Category_Name
ORDER BY Revenue DESC;


-- Triggers

-- Trigger to update stock of a product when a customer places an order: 
-- CREATE TRIGGER update_stock
-- AFTER INSERT ON has_order
-- FOR EACH ROW
-- BEGIN
--   UPDATE product
--   SET Stock = Stock - (SELECT quantity FROM has WHERE product_id = NEW.product_id AND Customer_ID = NEW.Customer_ID)
--   WHERE P_id = NEW.product_id
-- END;


-- CREATE TRIGGER update_order_total
-- AFTER INSERT ON has_order
-- FOR EACH ROW
-- BEGIN
--   UPDATE Orders
--   SET Order_Total = (SELECT SUM(Price * quantity) FROM has WHERE Customer_ID = NEW.Customer_ID)
--   WHERE O_id = NEW.O_id
-- END;
