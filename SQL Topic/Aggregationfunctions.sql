--Aggregation Function
SELECT COUNT(*) as total_products
FROM production.products;

SELECT
    AVG(list_price) AS avg_price,
    MIN(list_price) AS cheapest,
    MAX(list_price) AS priciest,
    SUM(list_price) AS catalog_value
FROM production.products;

SELECT
    COUNT(*)            AS total_orders,
    COUNT(shipped_date) AS shipped_orders
FROM sales.orders;

--Group by
SELECT 
  category_id,
  count(*) as product_count,
  AVG(list_price) as avg_price
FROM production.products
Group by category_id
order by product_count desc;

--Having
SELECT
    category_id,
    COUNT(*) AS product_count
FROM production.products
GROUP BY category_id
HAVING COUNT(*) > 50;

--Count (Distinct)

SELECT COUNT( o.order_id) AS total_orders --one to many relationship hotoo
FROM sales.orders AS o
INNER JOIN sales.order_items as oi
 on o.order_id = oi.order_id;

 SELECT COUNT(*) as total_orders
 from sales.orders;

 --GROUP BY multiple columns
 SELECT 
   category_id,
   brand_id,
   count(*) as product_count
FROM production.products
GROUP BY category_id, brand_id
order by category_id ,product_count DESC;

--Aggregation Across Joins

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.order_id)                                AS order_count,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount))      AS total_spent
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

--Putting it together
SELECT
    cat.category_name,
    COUNT(DISTINCT o.order_id)                                   AS order_count,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount))         AS total_revenue
FROM production.categories AS cat
INNER JOIN production.products AS p
    ON cat.category_id = p.category_id
INNER JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
INNER JOIN sales.orders AS o
    ON oi.order_id = o.order_id
GROUP BY cat.category_name
HAVING COUNT(DISTINCT o.order_id) >= 50
ORDER BY total_revenue DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

