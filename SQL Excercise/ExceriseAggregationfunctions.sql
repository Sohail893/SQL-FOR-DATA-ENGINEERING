--Excercise

/*Write a query that returns the total number of customers and the number with a non-NULL phone value*/
SELECT
  count(*) as total_customers
FROM sales.customers;

/*Group production.products by brand_id and return the product count and average list_price per brand, 
sorted by average price descending.*/

SELECT 
    brand_id,
    COUNT(product_id) AS product_count,
    ROUND(AVG(list_price),2) AS avg_price
FROM production.products
GROUP BY brand_id
ORDER BY avg_price DESC;

/*Using HAVING, find every brand with an average list_price above $1000.*/
SELECT
 brand_id,
 avg(list_price) as avg_list_price
 from production.products
 group by brand_id
 having avg(list_price)  > 1000;

/* The following query does not run. Explain the error and fix it:

SELECT customer_id, SUM(list_price) AS total
FROM sales.order_items
WHERE SUM(list_price) > 5000
GROUP BY customer_id;*/

SELECT 
 o.customer_id,
 sum(oi.list_price) as total
 from sales.order_items as oi
 inner join sales.orders as o
  on oi.order_id = o.order_id
 group by customer_id
 having sum(oi.list_price) > 5000;

/*Write a query that joins sales.orders, sales.order_items, and production.products,
then returns total quantity sold per product name, 
sorted from highest to lowest, limited to the top 10.*/
SELECT
 p.product_name,
 sum(oi.quantity) as total_quantity
 FROM sales.orders as o
 inner join sales.order_items as oi
 on o.order_id = oi.order_id 
 inner join production.products as p
 on oi.product_id = p.product_id
 group by p.product_name
 order by total_quantity desc
 offset 0 rows fetch next 10 rows only;

 
 /*Think About It: A colleague joins orders to order_items and reports "we received 4,658 orders last year." 
 Explain why this count is likely wrong and write the corrected version.*/

 SELECT count(*)  as total_orders
 FROM sales.orders as o
 inner join sales.order_items as oi
 on o.order_id = oi.order_id

/*because it one to mana relations in order table order_id are unique and in order_items order_id are 
repetied same in order_id so we used to avoid duplications problem used distinct o.order_id;*/
