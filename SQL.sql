-- RETRIEVING DATA FROM SINGLE TABLE
USE sql_store;

SELECT *
FROM customers;
-- WHERE customer_id=1
-- ORDER BY first_name;

-- 1.0 SELECT Clause

SELECT first_name, last_name, points
FROM customers;

SELECT first_name, last_name, points, points + 10
FROM customers;

SELECT first_name, 
	last_name, 
	points, 
	(points * 0.02) AS 'discount points'
FROM customers;

SELECT DISTINCT state
FROM customers;

-- Exercise
SELECT `name`, unit_price, unit_price * 1.1 AS 'new price'
FROM products;


-- 2.0 WHERE clause

SELECT * 
FROM customers
WHERE points > 3000;

-- >, >=, <, <=, =, != OR <> NOT EQUAL
SELECT * 
FROM customers
WHERE state = 'VA';

SELECT * 
FROM customers
WHERE state != 'va';

SELECT * 
FROM customers
WHERE birth_date > '1990-01-01';

-- Exercise
SELECT * 
FROM orders
WHERE order_date >= '2019-01-01';

-- 3.0 AND, OR and NOT operators

SELECT * 
FROM customers
WHERE birth_date >= '1990-01-01' AND points > 1000;

SELECT * 
FROM customers
WHERE birth_date >= '1990-01-01' OR (points > 1000 AND state = 'va');

-- AND is always evaluated first to override this use () 

SELECT * 
FROM customers
WHERE NOT (birth_date >= '1990-01-01' OR points > 1000);
-- ABOVE QUERY CAN ALSO BE WRITTEN AS
SELECT * 
FROM customers
WHERE birth_date <= '1990-01-01' AND points < 1000;

-- Exercise
SELECT *
FROM order_items
WHERE order_id = 6 AND (quantity*unit_price) >30;

-- 4.0 IN operator

SELECT * 
FROM customers
WHERE state='VA' OR state='ga' OR state='FL';

SELECT * 
FROM customers
WHERE state IN ('VA', 'GA','FL');

SELECT * 
FROM customers
WHERE state NOT IN ('VA', 'GA','FL');

-- Exercise

SELECT *
FROM products
WHERE quantity_in_stock IN (49,38,72);

-- 5.0 BETWEEN operator

SELECT * 
FROM customers
WHERE points >= 1000 AND points <= 3000;

-- this can be written as 
SELECT * 
FROM customers
WHERE points BETWEEN 1000 AND 3000;

-- Exercise

SELECT * 
FROM customers 
WHERE birth_date BETWEEN '1990-01-01' AND '2020-01-01';


-- 6.0 LIKE operator
SELECT * 
FROM customers
WHERE last_name LIKE 'b%';

SELECT * 
FROM customers
WHERE last_name LIKE 'brush%';

SELECT * 
FROM customers
WHERE last_name LIKE '%b%';

SELECT * 
FROM customers
WHERE last_name LIKE '%y';

SELECT * 
FROM customers
WHERE last_name LIKE '_y';
SELECT * 
FROM customers
WHERE last_name LIKE '_____y';

SELECT * 
FROM customers
WHERE last_name LIKE 'b____y';

-- % any no of character
-- _ single character

-- Exercise

SELECT * 
FROM customers
WHERE address LIKE '%trail%' OR 
      address LIKE '%avenue%';

SELECT * 
FROM customers
WHERE phone LIKE '%9';

SELECT * 
FROM customers
WHERE phone NOT LIKE '%9';

-- 7.0 REGEXP operator
SELECT *
FROM customers 
WHERE last_name LIKE '%field%';

-- this can also be written as
SELECT *
FROM customers 
WHERE last_name REGEXP 'field';

-- ^ BEGINNING 
-- $ ENDS WITH
-- | MULTIPLE SEARCH PATTERN/ LOGICAL OR
-- [abcd] MATCH SINGLE CHARACTER LISTED IN BRACKET
-- [a-h] RANGE

SELECT *
FROM customers 
WHERE last_name REGEXP 'field$';

SELECT *
FROM customers 
WHERE last_name REGEXP 'field|mac|rose';

SELECT *
FROM customers 
WHERE last_name REGEXP '^field|mac|rose';

SELECT *
FROM customers 
WHERE last_name REGEXP 'field$|mac|rose';

SELECT *
FROM customers 
WHERE last_name REGEXP 'field$|mac|rose';

SELECT *
FROM customers 
WHERE last_name REGEXP '[gim]e';  -- HAS ge, ie, me

SELECT *
FROM customers 
WHERE last_name REGEXP 'e[fmq]';

SELECT *
FROM customers 
WHERE last_name REGEXP '[a-h]e';

-- Exercise
SELECT * 
FROM customers
WHERE first_name REGEXP 'elka|ambur';

SELECT * 
FROM customers
WHERE last_name REGEXP 'ey$|on$';

SELECT * 
FROM customers
WHERE last_name REGEXP '^my|se';

SELECT * 
FROM customers
WHERE last_name REGEXP 'b[ru]'; -- 'br|bu'

-- 8.0 IS NULL operator
SELECT * 
FROM customers
WHERE PHONE IS NULL;

SELECT * 
FROM customers
WHERE PHONE IS NOT NULL;

-- Exercise

SELECT *
FROM orders
WHERE shipper_id IS NULL; -- shipped_date IS NULL

-- 9.0 ORDER BY clause
SELECT *
FROM customers
ORDER BY first_name;

SELECT *
FROM customers
ORDER BY first_name DESC; -- SORT IN DESCENDING ORDER

SELECT *
FROM customers
ORDER BY state, first_name;

SELECT *
FROM customers
ORDER BY state DESC, first_name;

SELECT first_name, last_name
FROM customers
ORDER BY birth_date;

SELECT first_name, last_name, 10 AS points
FROM customers
ORDER BY points, first_name;

SELECT *
FROM customers
ORDER BY 1,2; -- COLUMN POSITION, 1- customer_id, 2- first_name

-- Exercise
SELECT * 
FROM order_items
WHERE order_id = 2
ORDER BY quantity*unit_price DESC;
-- OR FOR CLARITY
SELECT *,  quantity*unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;

-- 10.0 LIMIT clause

SELECT * 
FROM customers
LIMIT 3;

SELECT * 
FROM customers
LIMIT 300;  

SELECT * 
FROM customers
LIMIT 300; 

-- PAGE 1: 1-3
-- PAGE 2: 4-6
-- PAGE 3: 7-9

SELECT * 
FROM customers
LIMIT 6,3; -- SKIP 6 AND SHOW 3

-- Exercise

SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

-- RETRIEVING DATA FROM MULTIPLE TABLE

-- 1.0 INNER JOINS
SELECT order_id, orders.customer_id, first_name, last_name
FROM orders
JOIN customers    -- BY DEFAULT JOIN IN INNER JOIN
ON orders.customer_id = customers.customer_id;

SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c    -- BY DEFAULT JOIN IN INNER JOIN
ON o.customer_id = c.customer_id;

-- Exercise
SELECT p.product_id, p.name, oi.quantity, oi.unit_price
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;

-- 2.0 JOIN across databases 

SELECT *
FROM order_items oi
JOIN sql_inventory.products p
ON oi.product_id = p.product_id;

-- 3.0 SELF JOINS
USE sql_hr;

SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
join employees m
ON e.reports_to = m.employee_id;

-- 4.0 joining multiple tables
USE sql_store;

SELECT o.order_id, o.order_date,
	c.first_name, c.last_name,
    os.name AS `status`
FROM orders o
JOIN customers c
	ON o.customer_id=c.customer_id
JOIN order_statuses os
	ON o.status= os.order_status_id;

-- Exercise
USE sql_invoicing;

SELECT  p.payment_id, p.client_id, c.name, 
		p.invoice_id, p.date, p.amount, 
		pm.name AS payment_method
FROM payments p
JOIN clients c
	ON p.client_id=c.client_id
JOIN payment_methods pm
	ON p.payment_method=pm.payment_method_id;

-- 5.0 Compound joins
USE sql_store;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id= oin.order_id
    AND oi.product_id=oin.product_id;


-- 6.0 IMPLICIT JOIN SYNTAX

SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id=c.customer_id;

-- CAN BE WRITTEN USING IMPLICIT JOIN SYNTAX (DONT USE THIS)
SELECT *
FROM orders o, customers c
WHERE o.customer_id=c.customer_id;

-- 7.0 OUTER JOIN

SELECT c.customer_id, c.first_name,
	o.order_id
FROM customers c
LEFT JOIN orders o -- LEFT JOIN CONSIDERS ALL RECORDS FROM FIRST TABLE IRRESPECTIVE OF ON CONDITION
	ON c.customer_id=o.customer_id
ORDER BY c.customer_id;

SELECT c.customer_id, c.first_name,
	o.order_id
FROM customers c
RIGHT JOIN orders o -- RIGHT JOIN CONSIDERS ALL RECORDS FROM SECOND TABLE IRRESPECTIVE OF ON CONDITION
	ON c.customer_id=o.customer_id
ORDER BY c.customer_id;

-- Exercise
SELECT p.product_id, p.name, oi.quantity 
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id;
    
-- CAN ALSO BE WRITTEN AS

SELECT p.product_id, p.name, oi.quantity 
FROM order_items oi
RIGHT JOIN products p
	ON p.product_id = oi.product_id;
    
-- 8.0 OUTER JOIN BETWEEN MULTIPLE TABLES

SELECT c.customer_id, c.first_name,
	o.order_id, sh.name AS shipper
FROM customers c
LEFT JOIN orders o 
	ON c.customer_id=o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id=sh.shipper_id
ORDER BY c.customer_id;

-- Exercise

SELECT o.order_date, o.order_id, c.first_name AS customer, sh.name AS shipper, os.name AS `status`
FROM orders o
JOIN customers c
	ON o.customer_id= c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id=sh.shipper_id
LEFT JOIN order_statuses os
	ON o.status=os.order_status_id
ORDER BY os.name;

-- 9.0 SELF OUTER JOINS

USE sql_hr;

SELECT e.employee_id,
	e.first_name,
    m.first_name
FROM employees e
LEFT JOIN employees m
	ON e.reports_to= m.employee_id;
    
-- 9.0 USING CLAUSE

    
    
    
    
    
    
    