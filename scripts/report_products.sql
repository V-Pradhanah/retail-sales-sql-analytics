/*
--......................................................................................................
PRODUCTS REPORT
---Build a business ready report about object products that gives a holistic view of it 
--........................................................................................................
-----Step 1: Build a base query by combining fact sales and dimension product to get the essential columns in order to do aggregation and derive new information
-----Step 2: Aggregate product level metrics:
			# Total Sales
			# Total customers 
			# Total quantity
			# Average Selling Price
			# last order date
-----Step 3: Segment the date based on cost and revenue 
-----Step 4: Calculate KPI's
					1. average order revenue 
					2. average monthly revenue
					3. recency in months (How long has it been since the last order in months)
					4. timespan of the product (Duration between the first order date and last order date in months)
					5. time of the product in market in years (how long has it been since it was first introduced in years)
-----Step 5: Build a view to avoid redundancy across different different queries and users
*/

IF OBJECT_ID('gold.report_products' ,'V' ) IS NOT NULL
	DROP VIEW gold.report_products;

GO

CREATE VIEW gold.report_products AS

WITH base_query AS(
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--Base query 
--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SELECT
	fs.order_number,
	dp.product_key,
	dp.product_number,
	dp.product_name,
	dp.category,
	dp.subcategory,
	dp.cost,
	fs.quantity,
	fs.sales_amount,
	fs.customer_key,
	fs.order_date,
	dp.product_line,
	dp.start_date
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON fs.product_key = dp.product_key
WHERE fs.order_date IS NOT NULL --only consider valid order date
)
, product_aggregation AS(
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--Aggregating measures by dimension from product table
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SELECT 
	category,
	subcategory,
	product_key,
	product_name,
	product_line,
	cost,
	start_date,
	COUNT(DISTINCT order_number) AS total_orders, 
	SUM(quantity) AS total_quantity,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	ROUND(AVG(CAST(sales_amount AS FLOAT)/ NULLIF(quantity, 0)), 2) AS avg_selling_price,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS timespan
FROM  base_query
GROUP BY
	category,
	subcategory,
	product_key,
	product_name,
	cost,
	product_line,
	start_date
)
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--Main query
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	product_line,	
	cost,
	CASE WHEN cost < 100 THEN 'Under 100'
		 WHEN cost BETWEEN 100 AND 499 THEN '100 - 499'
		 WHEN cost BETWEEN 500 AND 999 THEN '500 - 999'
		 ELSE '1000 and above'
	END AS cost_range,
	start_date,
	DATEDIFF(YEAR, start_date, GETDATE()) AS time_on_market_in_years,
	total_customers,
	total_orders, 
	total_quantity,
	total_sales,

	--total_sales_range
	CASE WHEN total_sales > 50000 THEN 'High-Performer'
		 WHEN total_sales >= 10000 THEN 'Mid-Performer'
		 ELSE 'Low-Performer'
	END AS total_sales_range, 

	--Average Order Revenue
	CASE WHEN total_orders = 0 THEN 0 ELSE  total_sales /total_orders END AS avg_order_revenue,

	--Average monthly revenue
	CASE WHEN timespan = 0 THEN total_sales ELSE total_sales/ timespan END AS avg_monthly_revenue,
	avg_selling_price,
	last_order_date,

	--when was the last time, the product was ordered from the current date -- recency
	DATEDIFF(MONTH, last_order_date , GETDATE()) AS last_active_in_months,
	timespan
FROM product_aggregation;
