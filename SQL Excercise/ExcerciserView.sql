--EXCERCISES

/*3.1. Create a view called production.vw_product_catalog that joins products,
categories, and brands to show product_name,
category_name, brand_name, and list_price in one result.*/

CREATE VIEW production.vw_product_catalog AS
SELECT p.product_name,
       c.category_name,
       b.brand_name 
       from
 production.products as p
 inner join production.categories as c
  on p.category_id = c.category_id
 inner join production.brands as b
  on p.brand_id = b.brand_id

SELECT * FROM production.vw_product_catalog;

/*3.2. Using the view from 5.1, write a query that 
returns only products under $500, sorted by price ascending.*/

CREATE VIEW production.vw_product_name AS
 SELECT p.product_id,
    p.product_name,
    p.list_price
    from 
  production.products as p
  inner join sales.order_items as oi
  on p.product_id = oi.product_id

SELECT * FROM production.vw_product_name 
where list_price >500
order by list_price desc;

/*3.3. Create a view sales.vw_customer_contact that exposes only customer_id, first_name,
last_name, and city from sales.customers, explicitly excluding email and phone. 
Explain in one sentence what real-world problem this view solves.*/
SELECT * FROM sales.customers;

CREATE VIEW sales.vw_customer_contact as
SELECT
 customer_id,
 first_name,
 last_name,
 city ,
 email,
 phone
 from sales.customers 

SELECT customer_id,first_name,last_name,city from sales.vw_customer_contact;
--With the help of view we hidden the email ,phone when other person retrive columns its safe ;

/*3.4. Explain why the following view cannot be used in a simple UPDATE statement,
and identify exactly which part of its definition causes the restriction:

CREATE VIEW sales.vw_order_summary AS
SELECT o.order_id, c.first_name, c.last_name, o.order_status
FROM sales.orders AS o
INNER JOIN sales.customers AS c ON o.customer_id = c.customer_id; */

--b\c view store the quere not date so

/*3.5. A teammate says, "I made this report faster by turning the query into a view." 
Explain whether this claim is accurate, 
and what would actually need to happen for a view to improve performance.*/

/*Creating a normal view does not automatically improve query performance because it 
mainly stores the SQL query, not the result. Performance 
can improve through indexed views, proper indexing, and query optimization."*/


/*3.6. Think About It: Two different teams each maintain their own version of a
"completed orders" query, written independently, six months apart. One filters 
order_status = 4; the other accidentally filters order_status = 3 after misreading
the status codes from Chapter 1. What specific failure does a shared view prevent here tha
t code review and documentation alone do not?*/

-- both teams used one same view to avoid the mistake 
/*Yaad rakho: Shared view ka matlab query ko copy karke sab teams ko dena nahi, balkay database mein ek
common view banana hai jise sab authorized users access kar saken.*/
