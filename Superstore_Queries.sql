create database superstore;
use superstore;
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(50),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postel_code INT,
    region VARCHAR(50)
);
select * from customers;

create table orders(
row_id varchar(50),
order_id varchar(50),
order_date varchar(50),
ship_date varchar(50),
ship_mode varchar(50),
customer_id varchar(50),
product_id varchar(50),
sales varchar(50),
quantity varchar(50),
discount varchar(50),
profit varchar(50)
);

select count(*) from orders;
CREATE TABLE orders_clean AS
SELECT
    CAST(row_id AS UNSIGNED) AS row_id,

    order_id,

    STR_TO_DATE(order_date, '%Y-%m-%d') AS order_date,

    STR_TO_DATE(ship_date, '%Y-%m-%d') AS ship_date,

    ship_mode,
    customer_id,
    product_id,

    CASE
        WHEN sales REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
        THEN CAST(sales AS DECIMAL(12,2))
        ELSE NULL
    END AS sales,

    CAST(quantity AS UNSIGNED) AS quantity,

    CASE
        WHEN discount REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
        THEN CAST(discount AS DECIMAL(5,2))
        ELSE NULL
    END AS discount,

    CASE
        WHEN profit REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
        THEN CAST(profit AS DECIMAL(12,2))
        ELSE NULL
    END AS profit

FROM orders;

select count(*) from orders_clean;

 CREATE TABLE products (
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT
);
 
DELETE FROM products
WHERE product_id = 'Product ID';
select * from products;
select count(*)from products;
select count(*) from customers;
select count(*) from orders_clean;

select * from customers;
select * from orders_clean;

select customer_id from customers
where customer_id is NUll
or customer_name is Null
or city is NULL;

select Distinct category
from products;
select * from products;


-- 1.Show all data from each table
select * from customers;
select * from orders_clean;
select * from products;
 
 -- 2.Count total rows in each table
 select count(*) from customers;
 select count(*) from orders_clean;
 select count(*) from products;
 
 -- 3.Find NULL values in important columns;
 select customer_id,customer_name,city
 from customers 
 where customer_id IS NULL
      OR customer_name IS NULL
      OR city IS NULL;
      
-- 4.Show distinct subcategory (if available)
select distinct sub_category
from products;

-- 5.Show all orders placed in the year 2017 and count the order
select count(*) AS total_order_2015
from orders_clean
where year(order_date) = 2015;

 -- 6.Show all orders where sales is greater than 1000
select * from orders_clean
where sales >1000;

-- 7.Get all customers from a specific city (you choose)
select customer_name as SanFrancisco_customers
from customers 
where city='San Francisco';

-- 8.Show all products in a specific category
select  Product_name 
from products
where category='Technology';

-- 9.Find the top 5 orders with highest sales 
select customer_id,sales,profit from orders_clean
order by sales desc
limit 5;

-- 10.Count total number of orders
select count(order_id) as Total_count_orders from orders_clean;


-- 11.Find all orders where profit is negative
select order_id,customer_id,sales, profit as Negative_profits 
from orders_clean 
where profit <0
limit 5;

-- 11.How many orders have negative profit?
select count(*)  as negative_profits from orders_clean
where profit  < 0;

-- 12.Find total sales by each customer
SELECT 
    c.customer_name, c.city, SUM(o.sales) AS total_sales
FROM
    orders_clean o
        JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY customer_name,city
ORDER BY total_sales DESC
limit 5;

-- 13. Find total sales by category
select p.category, sum(sales) as total_sales 
from orders_clean o
join products p on o.product_id=p.product_id
group by category
order by total_sales desc;

-- 14.Find number of orders per city
select 
c.city,
count(o.order_id) as Total_orders 
from orders_clean o
join customers c 
    on c.customer_id=o.customer_id
group by c.city
order by total_orders desc
limit 5;

-- 15.Find orders joined with product names and category
select 
o.order_id,
p.product_name,
p.category,
o.sales,
o.order_date
from orders_clean o
join products p on p.product_id=o.product_id;

-- 16.Find customers who placed more than 5 orders
select
 c.customer_name , 
 count(o.order_id) as total_order
from orders_clean o
join customers c
 on c.customer_id=o.customer_id
group by customer_name 
having count(*) >5
limit 6;


-- 17.Find customers from the same city
select  A.customer_name as customer_1 ,
B.customer_name as customer_2,
A.city
from customers A
join customers B on A.city=b.city
where A.customer_id <> B.customer_id
limit 10;

-- 18.Find pairs of customers who placed orders on the same date
SELECT 
    c1.customer_name AS customer_1,
    c2.customer_name AS customer_2,
    o1.order_date
FROM
    orders_clean o1
        JOIN
    customers c1 ON o1.customer_id = c1.customer_id
        JOIN
    orders_clean o2 ON o1.order_date = o2.order_date
        JOIN
    customers c2 ON o2.customer_id = c2.customer_id
WHERE
    o1.customer_id <> o2.customer_id;
    
-- 19.Find orders where sales are greater than average sales
select order_id,sales
from orders_clean 
where sales > (select  avg(sales) from orders_clean); 

-- 20.Find customers who generated sales greater than overall average sales
select c.customer_name,
sum(o.sales) as total_sales
from orders_clean o
join customers c 
on o.customer_id=c.customer_id 
group by c.customer_name
Having sum(o.sales) > (select avg(sales) from orders_clean);

-- 21.Find second highest sales value
select max(sales) as second_Highest_sales
from orders_clean 
where sales < ( select max(sales) from orders_clean);

-- 22.Find top-selling product category
select  p.category ,
sum(o.sales) as total_sales 
from orders_clean  o
join products p  on p.product_id = o.product_id 
group by p.category 
order by total_sales desc 
limit 1;


-- 23.Rank customers based on total sales
select customer_id,
sum(sales)  as total_sales,
RANK() OVER ( order by sum(sales) desc ) AS customer_rank
from orders_clean
group by customer_id
limit 5;

--  24.Find running total of sales over time
select order_date , sales ,
 sum(sales)  over (order by order_date desc) as Running_total
from orders_clean
limit 15;

-- 25.Find top 3 products in each category
select * 
from (
select p.category ,
       p.product_name , 
       sum(sales) as Total_sales,
RANK() OVER (PARTITION BY  p.category order by sum(sales) desc) as rank_products 
from orders_clean o 
join products p  on o.product_id = p.product_id 
group by p.category , p.product_name 
) ranked_products
where rank_products <= 3 ;

-- 26.Show previous order date for each customer
select order_date , customer_id ,
lag (order_date) over ( PARTITION BY customer_id order by order_date ) as previous_order_date 
from orders_clean;

-- 27.Categorize sales performance
SELECT  
    sales,
    customer_id,
    CASE
        WHEN sales <= 30000 THEN 'Low Sales'
        WHEN sales BETWEEN 30000 AND 50000 THEN 'Medium Sales'
        WHEN sales BETWEEN 50001 AND 90000 THEN 'High Sales'
        WHEN sales > 90000 THEN 'Super Sales'
        ELSE 'Very Low Sales'
    END AS sales_performance
FROM orders_clean
LIMIT 100;

-- 28.. Classify profit status
SELECT 
      profit , 
	case
        when profit > 0 then 'Profit'
        when profit <0  then 'loss profit'
        else 'no profit no loss'
        end as profit_status
        from orders_clean
        limit 20;
        
-- 29.Customer segment grouping
SELECT 
    segment,
    CASE
        WHEN segment = 'Consumer' THEN 'Retail'
        WHEN segment = 'Corporate' THEN 'Dealer'
        WHEN segment = 'Home Office' THEN 'House Owner'
        ELSE 'Other'
    END AS segment_position
FROM customers
LIMIT 10;