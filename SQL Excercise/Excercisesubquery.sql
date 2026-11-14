--Excercise Subquery

/*Write a query using a scalar subquery that returns all products with a 
list_price above the average price in their brand.
Use a correlated subquery in WHERE.*/

SELECT
 product_name,
 list_price,
 brand_id
 
FROM production.products as p 
where list_price > (
SELECT AVG(list_price) from production.products p2
where p2.brand_id =  p.brand_id
)

/* Write a query using IN that returns all orders placed by customers living in New York or California.*/

SELECT
 order_id
 
FROM sales.orders
WHERE customer_id in (select 
 customer_id from sales.customers
 where city = 'New York' or city = 'California'
 );

SELECT
    order_id,
    customer_id,
    (
        SELECT city
        FROM sales.customers c
        WHERE c.customer_id = o.customer_id
    ) AS city
FROM sales.orders o
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE city IN ('New York', 'California')


/*The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:

SELECT customer_id FROM sales.customers
WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);*/

SELECT customer_id FROM sales.customers as c
where  not exists (select customer_id from sales.orders as o
where o.customer_id = c.customer_id);

 /*Using a derived table in FROM,
 write a query that finds the average number of items per order across all orders.*/

 SELECT 
 Avg(item_count* 1.0) as average_item_count_per_order --*1.0 for show decimal
 FROM (
 SELECT 
  order_id,
  sum(quantity) as item_count
  from sales.order_items
  group by order_id
  ) as item_order_count;

 /*Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?*/
 SELECT
  customer_id,
  first_name,
  last_name,
  city
FROM sales.customers c
where customer_id in ( select
customer_id from sales.orders  as o
where year(o.order_date)  = 2017);

--EXISTS version safer hai, especially jab subquery NULL values return kar sakti ho.

/*Use CROSS APPLY to return the top 3 most recent orders for each customer.
Show customer_id, first_name, order_id, and order_date.*/

SELECT
 c.customer_id,
 c.first_name,
 p.order_id,
 p.order_date
 FROM sales.customers as c
 cross apply ( 
 select top 3 
  order_id,
  order_date
  from sales.orders as o 
  where o.customer_id = c.customer_id 
  order by order_date desc)

  /* Think About It: = ANY (subquery) is functionally identical to IN (subquery).
  Given that, when would you choose ANY over IN, and when would you choose ALL?
  What business question naturally maps to ALL that*/

  --Simple matching ke liye in use karo
  -- Kisi ek ya tamam values ke saath comparison ke liye ANY ya ALL use karo.




  cannot be expressed cleanly with IN?
  as p














);






