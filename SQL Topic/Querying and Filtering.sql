-- CHAPTER 01 Querying and Filtering

--SELECT
SELECT * FROM production.products;

SELECT product_name, list_price
FROM production.products

SELECT 
    product_name,
    list_price,
    list_price * 0.9 as discounted_price
FROM production.products;

---Columns Aliases
SELECT
   product_name as product,
   list_price as price
FROM production.products;

SELECT list_price as "retail price" from production.products;

SELECT list_price  * 0.9 as discounted_price
from production.products
where discounted_price >500; --error

--Removing Duplicates with Distinct
SELECT DISTINCT category_id FROM production.products;

---Sorting with Orderby
SELECT product_name,list_price
FROM production.products
order by list_price desc;

SELECT product_name, category_id, list_price
FROM production.products
order by category_id asc, list_price desc;

---Limiting Rows
SELECT TOP 3 product_name ,list_price
from production.products
order by list_price DESC;

SELECT product_name, list_price
FROM production.products
order by list_price desc
offset 3 rows fetch next 3 rows only;

--Filtering with where
SELECT product_name, list_price
FROM production.products
WHERE list_price >1000;

---Combining Condition: AND , OR ,NOT
SELECT product_name, category_id, list_price
FROM production.products
where category_id =6 and list_price >1000;

SELECT product_name, category_id
FROM production.products
WHERE category_id =1 OR category_id =3;

--Intention: category 6 or 3 , but only under 1000
SELECT product_name, category_id, list_price
FROM production.products
WHERE category_id = 6 OR category_id = 3 and list_price <1000;

SELECT product_name, category_id, list_price
FROM production.products
WHERE ( category_id = 6 OR category_id =3) AND list_price <1000;

--Filtering Ranges with Between 
SELECT product_name, list_price FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

SELECT order_id , order_date
FROM sales.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-03-31';

--Filtering List with IN
SELECT product_name , category_id
FROM production.products
WHERE category_id in (1,3,6)

SELECT first_name, last_name
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id FROM sales.orders WHERE order_status = 4
);

--Pattern Matching with LIKE
SELECT product_name FROM production.products
where product_name LIKE 'Trek%';

--Handling Null values
SELECT order_id, shipped_date
FROM sales.orders 
WHERE shipped_date is NULL;

--Putting it together 

/*The merchandising team wants a curated list for the holiday catalog: 
mid-to-high-end bikes priced between $300 and $3,000,
excluding bare frames, sorted from most to least expensive, top 10 only.*/
SELECT 
 product_name,
 category_id,
 list_price
FROM production.products
WHERE list_price BETWEEN 300 AND 3000
  AND category_id in (1,6)
  AND product_name NOT LIKE '%Frame%'
ORDER BY list_price DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;







