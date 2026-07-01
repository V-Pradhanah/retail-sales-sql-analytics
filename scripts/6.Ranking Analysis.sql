--Step: 6
--=============================================================================
--Ranking Analysis
--Which 5 products generate the highest revenue?
SELECT TOP 5
dp.product_name, 
SUM(fs.sales_amount) AS revenuebyproducts
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON fs.product_key = dp.product_key
GROUP BY  dp.product_name
ORDER BY revenuebyproducts DESC


--What are the 5 worst performing products in terms of sales?
SELECT TOP 5
dp.product_name, 
SUM(fs.sales_amount) AS revenuebyproducts
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON fs.product_key = dp.product_key
GROUP BY  dp.product_name
ORDER BY revenuebyproducts ASC

--Find the Top 10 customers who have generated the highest revenue and 3 customers with the fewest orders placed
SELECT TOP 10
dc.customer_key,
dc.first_name,
dc.last_name,
SUM(fs.sales_amount) AS totalrevenuebycustomers
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name,dc.last_name
ORDER BY totalrevenuebycustomers DESC


--Find the 3 customers with the fewest orders placed
SELECT TOP 3
dc.customer_key, 
dc.first_name,
dc.last_name,
COUNT(DISTINCT fs.order_number) AS Nr_of_ordersbycustomers
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name,dc.last_name
ORDER BY Nr_of_ordersbycustomers ASC
