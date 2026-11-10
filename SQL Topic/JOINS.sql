--Joins

SELECT product_name, category_id FROM production.products;

SELECT category_id , category_name FROM production.categories;

--INNER JOIN 
SELECT
  p.product_name,
  c.category_name,
  p.list_price
FROM production.products AS p
INNER JOIN production.categories AS c
  ON p.category_id = c.category_id

SELECT 
  o.order_id ,
  o.order_date,
  s.store_name,
  s.city
FROM sales.orders AS o
INNER JOIN sales.stores AS s
  ON o.store_id = s.store_id
WHERE o.order_id in (1,2,3)

--LEFT JOIN
SELECT
  p.product_name,
  oi.order_id
FROM production.products as p
LEFT JOIN sales.order_items as oi
   on  p.product_id = oi.product_id
WHERE oi.order_id is null;


SELECT
    c.first_name,
    c.last_name,
    o.order_id
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--RIGHT JOIN
SELECT
   p.product_name,
   oi.order_id
FROM sales.order_items AS oi
RIGHT JOIN production.products AS p
   ON oi.product_id = p.product_id

SELECT
    st.store_name,
    s.first_name,
    s.last_name
FROM sales.staffs AS s
RIGHT JOIN sales.stores AS st
    ON s.store_id = st.store_id;

--Full outer JOIN
SELECT
    p.product_name,
    s.quantity
FROM production.products AS p
FULL OUTER JOIN production.stocks AS s
    ON p.product_id = s.product_id AND s.store_id = 1;

SELECT
    b.brand_name,
    p.product_name
FROM production.brands AS b
FULL OUTER JOIN production.products AS p
    ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL OR b.brand_id IS NULL;

--CROSS JOIN
SELECT
    s.store_name,
    c.category_name
FROM sales.stores AS s
CROSS JOIN production.categories AS c;

SELECT
    st.store_name,
    b.brand_name
FROM sales.stores AS st
CROSS JOIN production.brands AS b
WHERE st.store_id = 1;


--SELF JOIN
SELECT
    e.first_name + ' ' + e.last_name AS employee,
    m.first_name + ' ' + m.last_name AS manager
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id;

SELECT
    c1.first_name + ' ' + c1.last_name AS customer_a,
    c2.first_name + ' ' + c2.last_name AS customer_b,
    c1.city
FROM sales.customers AS c1
INNER JOIN sales.customers AS c2
    ON c1.city = c2.city AND c1.customer_id < c2.customer_id;

SELECT
    o.order_id,
    o.order_date,
    oi.product_id,
    oi.quantity
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_id = 1;

-- Joining more than two tables
SELECT
    c.first_name,
    c.last_name,
    p.product_name,
    oi.quantity,
    o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id
WHERE c.customer_id = 42;