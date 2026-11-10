---CHAPTER 01 ASSIGNMENT 1
/*1.1. Write a query that selects product_name, list_price, and a calculated column
price_in_thousands (list_price divided by 1000) from production.products.*/
SELECT
  product_name,
  list_price,
  list_price / 1000 as price_in_thousands
FROM production.products;

/*1.2. Write a query that returns the distinct list of state values from sales.customers.*/

SELECT DISTINCT city FROM sales.customers;

/*1.3. Write a query that returns the 5 cheapest products,
showing product_name and list_price, sorted appropriately.*/

SELECT
   TOP 5 product_name,
   list_price
 FROM production.products
 ORDER BY list_price ASC;

/*1.4. Write a query that returns products priced between 200 and 600, 
 where the category is either 1 or 6. Use BETWEEN and IN together.*/

SELECT 
  product_name,
  category_id,
  list_price
FROM production.products
WHERE category_id in (1,6) AND list_price BETWEEN 200 AND 600;

/*1.5. The following query is meant to find affordable mountain or road bikes
(categories 1 and 6) under $1000,
but it has a bug. Identify it and rewrite it correctly:*/

SELECT product_name, category_id, list_price --Bug query
FROM production.products
WHERE category_id = 1 OR category_id = 6 AND list_price < 1000;

SELECT product_name,category_id,list_price  -- bug resolve correct query
FROM production.products
where (category_id = 1 OR category_id = 6) AND list_price <1000;

/*1.6. Write a query that finds all customers 
whose email ends in .com and whose last_name starts with the letter "M"*/

SELECT 
 first_name,
 last_name,
 email
 FROM sales.customers WHERE email LIKE '%.com' AND last_name LIKE 'M%';

 /*1.7. Write a query that returns the 11th through 20th most expensive products using OFFSET...FETCH.*/
 
 SELECT 
  product_name,
  list_price
 FROM production.products
 order by list_price desc
 offset 10 rows fetch next 10 rows only;

 /*1.8. Think About It: A junior engineer writes WHERE discount <> NULL to find order 
 items with a defined discount, and the query returns zero rows even though the table clearly has non-null discount values.
 Explain why, using three-valued logic, and write the correct version.*/

 /*NULL unknown ya missing value ko represent karta hai. SQL
 mein NULL ke saath <> ya = use karne par result UNKNOWN hota hai. Is liye defined discounts
 find karne ke liye IS NOT NULL use karna chahiye.*/

 WHERE discount is not null;
 
