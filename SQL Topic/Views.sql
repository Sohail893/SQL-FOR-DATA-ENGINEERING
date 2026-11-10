--View
CREATE VIEW sales.vw_customer_orders AS 
SELECT 
 c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id

--Querying the view
SELECT * FROM sales.vw_customer_orders
WHERE order_status =1
ORDER BY order_date DESC;

--Altering and Dropping View
CREATE OR ALTER VIEW sales.vw_customer_orders AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.order_status,
    o.store_id
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;

-- PostgreSQL, Snowflake
CREATE OR REPLACE VIEW sales.vw_customer_orders AS
SELECT ...

--Updating Views
CREATE VIEW production.vw_active_products AS
SELECT product_id ,product_name,list_price
FROM production.products 
WHERE list_price >0;

UPDATE production.vw_active_products
SET list_price = 349.99
WHERE product_id = 1;

SELECT product_id, list_price FROM production.products WHERE product_id = 1;

--Putting it together
CREATE VIEW sales.vw_pending_order_items AS
SELECT
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 1;

SELECT * FROM sales.vw_pending_order_items
WHERE order_date >= '2018-12-01'
ORDER BY order_date DESC;








