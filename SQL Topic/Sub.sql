--Subquery
--Nested Query

--find New York order

SELECT 
  customer_id 
FROM sales.customers
where city = 'New York';

SELECT * FROM sales.orders
where customer_id in (16,178,327,411,854,927,1016)

SELECT
 order_id,
 order_date,
 customer_id
FROM 
 sales.orders
WHERE 
 customer_id in (
  select 
     customer_id
  from 
     sales.customers
where 
 city = 'New York'
 )
order by 
 order_date DESC;

 --Subquery in Where Clause

 --Scalar Subquery -Single value comparison

 --Products priced above the overall average

 SELECT
   product_name,
   list_price
  FROM production.products
  where list_price > (
  SELECT AVG(list_price)
  from production.products);

  --IN - List Membership

  -- Products in Mountain Bikes or Road Bikes categories
SELECT
    product_id,
    product_name
FROM production.products
WHERE category_id IN (
    SELECT category_id
    FROM production.categories
    WHERE category_name = 'Mountain Bikes'
       OR category_name = 'Road Bikes'
);

--NOT IN 
--Customer who have never palaced an order
SELECT
    customer_id,
    first_name,
    last_name
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM sales.orders
    WHERE customer_id IS NOT NULL
);

--Subquery in FROM Clause - Derived Table

--Average number of orders per staff member
SELECT
 AVG(order_count) AS average_order_count_per_staff
 from (
  select 
   staff_id,
   count(order_id) as order_count
   from sales.orders
   group by staff_id
   ) as staff_order_counts;

--Subquery in SELECT Clause
--Average number of orders per staff member

SELECT
 order_id,
 order_date,
 ( SELECT MAX(list_price)
 FROM sales.order_items i
 where i.order_id = o.order_id
 ) as max_item_price
 from sales.orders o
 order by order_date desc;

 --Correlated Subquery
--Product with the highest price in their category
SELECT
  product_name,
  list_price,
  category_id
FROM production.products as p1
where list_price in (
select max(p2.list_price) 
from production.products as p2
where p2.category_id = p1.category_id  
 group by p2.category_id)
 order by category_id,product_name;

--Exists

--Customers who placed at least one order in 2017
SELECT
 customer_id,
 first_name,
 last_name,
 city
FROM sales.customers as c
WHERE EXISTS (
 SELECT 1
 FROM sales.orders o
 WHERE o.customer_id = c.customer_id
 AND YEAR(o.order_date) = 2017
);

--NOT Exists
WHERE NOT EXISTS (
SELECT 1 FROM sales.orders o 
WHERE o.customer_id = c.customer_id
 and year(o.order_date) = 2017

 --ANY
 -- Products whose list price >= the average price of ANY brand
SELECT
 product_name,
 list_price
FROM production.products
where list_price >= ANY ( SELECT AVG(list_price) 
FROM production.products 
group by brand_id
);

--ALL
-- Products whose list price >= ALL brand averages (the highest bar)
SELECT
 product_name,
 list_price
FROM production.products
WHERE list_price >= ALL (
 SELECT AVG(list_price)
 FROM production.products
 GROUP BY brand_id
 );

 --CROSS apply
--Top 2 most expensive products per category
SELECT
 c.category_name,
 p.product_name,
 p.list_price
FROM production.categories c
CROSS APPLY (
  SELECT TOP 2
   product_name,
   list_price
 FROM production.products 
 WHERE category_id = c.category_id
 order by list_price ) as p
 order by c.category_name, p.list_price DESC;

 --outer apply
 -- All categories with their top 1 product (NULL if no products)
SELECT
    c.category_name,
    p.product_name,
    p.list_price
FROM production.categories c
OUTER APPLY (
    SELECT TOP 1
        product_name,
        list_price
    FROM production.products
    WHERE category_id = c.category_id
    ORDER BY list_price DESC
) AS p;

--Nested Subqueries
-- Products priced above the average for Strider and Trek brands
SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price > (
    SELECT AVG(list_price)
    FROM production.products
    WHERE brand_id IN (
        SELECT brand_id
        FROM production.brands
        WHERE brand_name = 'Strider'
           OR brand_name = 'Trek'
    )
)
ORDER BY list_price;
