--Step: 4
--Measures Exploration
--From Highest level of agg(measure) to lowest_level
--=======================================
--Highest
--Find Total Sales
SELECT SUM(sales_amount)  AS total_sales FROM gold.fact_sales; 

--Find how many quantities are sold
SELECT SUM(quantity) total_quantity FROM gold.fact_sales;

--Find the average selling price
SELECT AVG(price) avg_selling_price FROM gold.fact_sales;

--Find the total number of orders
SELECT COUNT(order_number) total_orders FROM gold.fact_sales;

SELECT COUNT(DISTINCT order_number) total_unique_orders FROM gold.fact_sales;

SELECT * FROM gold.fact_sales;

--Find the total number of products
SELECT COUNT(product_number) AS total_products  FROM gold.dim_products;

SELECT COUNT(DISTINCT product_number) AS total_unique_products  FROM gold.dim_products;

--Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

SELECT COUNT(DISTINCT customer_key) AS total_unique_customers FROM gold.dim_customers;

--Find the total number of customers  that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers_placed_an_order FROM gold.fact_sales;


--Generate  a report that shows all key metrics of the business in order to 

SELECT 'total_sales' AS measure_name ,  SUM(sales_amount)  AS 'measure_value' FROM gold.fact_sales
UNION ALL
SELECT 'total_quantity' , SUM(quantity)  FROM gold.fact_sales
UNION ALL
SELECT 'avg_selling_price' , AVG(price)  FROM gold.fact_sales
UNION ALL
SELECT 'total_orders' , COUNT(DISTINCT order_number)  FROM gold.fact_sales
UNION ALL
SELECT 'total_products' , COUNT(DISTINCT product_number)    FROM gold.dim_products
UNION ALL
SELECT 'total_customers' , COUNT(DISTINCT customer_key) FROM gold.dim_customers
UNION ALL
SELECT 'total_customers_placed_an_order' , COUNT(DISTINCT customer_key) AS total_customers_placed_an_order FROM gold.fact_sales;
