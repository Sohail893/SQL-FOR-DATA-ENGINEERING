--Excercises

/*2.1. Write a query that
lists every product with its brand name, using production.products and production.brands.*/

SELECT
  p.product_name,
  b.brand_name
FROM production.products AS p
INNER JOIN production.brands AS b
  on p.brand_id = b.brand_id;

/*2.2. Using a LEFT JOIN, write a query that finds every store with zero staff currently assigned to it.*/
SELECT 
 s.store_name ,
 st.staff_id
FROM sales.stores s
LEFT JOIN sales.staffs st
 ON s.store_id = st.store_id
 where staff_id is null;

/*2.3. Explain, in your own words, why the following query returns
every product regardless of stock level, and rewrite it so that it 
only returns products with fewer than 5 units in stock at store 1:*/

SELECT p.product_name, s.quantity
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id AND s.quantity < 5 AND s.store_id = 1;


SELECT p.product_name, s.quantity, s.store_id
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id where s.quantity < 5 AND s.store_id = 1;

    --INNER JOIN

/*2.4. Write a self join on sales.staffs that lists every manager along with a 
count placeholder column showing 1 for each employee they manage
(you will replace this with a real COUNT in Chapter 3);
for now, just produce one row per employee-manager pair.*/

SELECT 
  e.first_name + ' ' + e.last_name AS employee,
  m.first_name + ' ' + m.last_name AS manager
FROM sales.staffs AS e
LEFT JOIN sales.staffs as m
  on e.manager_id = m.staff_id

/*2.5. Write a three-table join across sales.orders, sales.order_items, and production.products 
that lists every item in order #1, including product name and quantity.*/

SELECT
  o.order_id,
  oi.quantity,
  p.product_name
 FROM sales.orders as o
 inner join sales.order_items as oi
  on o.order_id = oi.order_id
 inner join production.products as p
  on oi.product_id = p.product_id
  where o.order_id = 1;

 /*2.6. A colleague joins orders to order_items and reports "we received 4,658 orders last year."
 Explain what actually went wrong with 
 that number and how you would find the true order count instead.*/

SELECT COUNT( distinct o.order_id) AS total_orders
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id

/*Task 42: Find pairs of products from the same brand that have the exact same list price. 
Show both product names and the brand name.*/

SELECT
    p1.product_name AS product1,
    p2.product_name AS product2,
    b.brand_name
FROM production.products AS p1
INNER JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
INNER JOIN production.brands AS b
    ON p1.brand_id = b.brand_id;

/*Task 43: Find all pairs of customers who live in the same city and state.
Avoid duplicates (don't show A-B and B-A both).*/

SELECT
    c1.first_name + ' ' + c1.last_name AS customer_a,
    c2.first_name + ' ' + c2.last_name AS customer_b,
    c1.city,
    c1.state
FROM sales.customers AS c1
INNER JOIN sales.customers AS c2
    ON c1.city = c2.city 
    AND c1.state = c2.state 
    AND
    c1.customer_id < c2.customer_id;

/*Task 44: List staff members who were hired at the same store as their manager.*/

SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name,
    s.store_id
FROM sales.staffs AS s
INNER JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id
WHERE s.store_id = m.store_id; 

--CROSS JOIN

 /*Generate a list of every possible combination of brand and category.
 Show brand name and category name.*/
 
 SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c;

/*Task 46: Using the result of a CROSS JOIN between brands and categories, 
find brand-category combinations that have NO products 
(LEFT JOIN the cross join result against products and filter for NULLs).*/

SELECT
    b.brand_name,
    c.category_name,
    p.product_id
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON b.brand_id = p.brand_id
    AND c.category_id = p.category_id
WHERE p.product_id IS NULL;

/*Task 47: Generate a report showing every store paired with every product,
along with the stock quantity. If a store doesn't carry a product, show 0.
Hint: CROSS JOIN stores with products, then LEFT JOIN with production.stocks.*/

SELECT 
   s.store_name,
   p.product_name,
   ISNULL(st.quantity, 0) AS quantity
FROM sales.stores as s
cross join production.products as p
left join production.stocks as st
 on s.store_id = st.store_id
 and p.product_id = st.product_id;

/*Task 48: Create all possible staff-store assignments (every staff paired with every store), 
then show which ones are the actual current assignments.*/
select
    s.first_name + ' ' + s.last_name as staff_name,
    st.store_name,
    case
        when s.store_id = st.store_id then 'Actual Assignment'
        else 'Not Assigned'
    end as assignment_status
from sales.staffs as s
cross join sales.stores as st;

--Right Join

/*Task 49: List all brands and the products that belong to them.
Ensure ALL brands appear, even if they have no products. 
Use a RIGHT JOIN (products RIGHT JOIN brands).*/

SELECT
  b.brand_name,
  p.product_name
FROM production.products as p
RIGHT JOIN production.brands as b
 on b.brand_id = p.brand_id;

/*Task 50: Show all stores and the orders placed at each store.
Use a RIGHT JOIN so that stores with zero orders still appear.*/
SELECT
 o.order_id,
 s.store_name,
 s.store_id
FROM sales.orders as o
RIGHT JOIN sales.stores as s
on o.store_id = s.store_id;

/*Task 51: List all categories with their product count.
Use a RIGHT JOIN to ensure categories with no products show a count of 0.*/

 select
    c.category_name,
    count(p.product_id) as product_count
from production.products as p
right join production.categories as c
    on p.category_id = c.category_id
group by c.category_name;

/*Task 52: Show all staff members and the orders they handled. Use a RIGHT JOIN on orders RIGHT JOIN staffs,
so staff who handled zero orders still appear.*/


SELECT 
 s.staff_id,
 o.order_id
FROM sales.orders as o
RIGHT JOIN sales.staffs as s
 on o.staff_id = s.staff_id

 --Left Anti Join (LEFT JOIN + WHERE IS NULL)

 /*Task 53: Find all customers who have NEVER placed an order.
Hint: LEFT JOIN sales.customers with sales.orders, then filter WHERE order_id IS NULL.*/
SELECT
 c.customer_id,
 o.order_id
 FROM sales.customers as c
 LEFT JOIN sales.orders as o
 on c.customer_id = o.customer_id 
 where o.order_id is null;

/*Task 54: Find all products that are NOT currently in stock at ANY store.
Hint: LEFT JOIN production.products with production.stocks, filter WHERE store_id IS NULL.
*/
SELECT 
 p.product_name,
 s.store_id
 from
 production.products as p
 left join production.stocks as s
 on p.product_id = s.product_id 
 where s.store_id is null;

/*Task 55: Find brands that have NO products in the database.*/
SELECT
b.brand_name,
p.product_name
FROM production.brands as b
LEFT JOIN production.products as p
 on b.brand_id = p.brand_id
where p.product_id is null;

/*Task 56: Find all products that have never been ordered.
Hint: LEFT JOIN production.products with sales.order_items, filter WHERE order_id IS NULL.*/
SELECT
p.product_name,
o.order_id
FROM production.products as p
LEFT JOIN sales.order_items as o
on p.product_id = o.product_id
where o.order_id is null;

/*Task 57: Find stores that have never had any staff assigned to them.*/

SELECT
    s.store_id,
    s.store_name
FROM sales.stores AS s
LEFT JOIN sales.staffs AS st
    ON s.store_id = st.store_id
WHERE st.staff_id IS NULL;

/*Task 58: Find staff members who have never handled a single order.*/
SELECT
    st.staff_id,
    st.first_name,
    st.last_name
FROM sales.staffs AS st
LEFT JOIN sales.orders AS o
    ON st.staff_id = o.staff_id
WHERE o.order_id IS NULL;

/*Task 59: Find categories where no product has a list price above 2000.
Hint: LEFT anti-join categories against a subquery of categories that DO have products above 2000.*/

SELECT
    c.category_id,
    c.category_name
FROM production.categories AS c
LEFT JOIN
(
    SELECT DISTINCT
        p.category_id
    FROM production.products AS p
    WHERE p.list_price > 2000
) AS expensive
    ON c.category_id = expensive.category_id
WHERE expensive.category_id IS NULL;

/*Task 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.
Hint: This combines a regular join (customers who ordered) 
with a left anti pattern (never ordered Trek).*/

SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c

INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id

LEFT JOIN
(
    SELECT DISTINCT
        o.customer_id
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    INNER JOIN production.products AS p
        ON oi.product_id = p.product_id
    INNER JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS trek_customers
    ON c.customer_id = trek_customers.customer_id

WHERE trek_customers.customer_id IS NULL;
