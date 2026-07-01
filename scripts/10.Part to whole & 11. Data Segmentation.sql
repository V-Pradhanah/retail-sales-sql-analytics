--10. Part to Whole Analysis
--To know the greatest contributor to the business and to know the contribution of individual part to the overall measure
--=========================================================================
--Which category contribute the most to overall sales

SELECT 
	dp.category,
	SUM(fs.sales_amount) AS sales_by_category,
	SUM(SUM(fs.sales_amount)) OVER() AS total_sales,
	CONCAT(CAST(SUM(fs.sales_amount) * 1.0 / SUM(SUM(fs.sales_amount)) OVER() * 100   AS DECIMAL(10,2)),'%') AS category_contribution
FROM gold.fact_sales AS  fs
LEFT JOIN gold.dim_products AS dp
ON fs.product_key = dp.product_key
GROUP BY dp.category
ORDER BY category_contribution DESC

--11. Data Segmentation
--=========================================================================
--Segment products into cost range and count how many products fall into each segment

WITH cost_range_summary AS (
SELECT 
product_key,
product_name,
cost,
CASE WHEN cost  < 100 THEN 'Below 100'
	 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN cost BETWEEN 500 AND 1000 THEN '500- 1000'
	 ELSE 'Above 1000'
END AS cost_range
FROM gold.dim_products 
) 
SELECT 
cost_range,
COUNT(product_key) AS total_products
FROM cost_range_summary 
GROUP BY cost_range
ORDER BY total_products DESC

/*
Group customers into three segments based on their spending behaviour:
	-VIP: Customers with at least 12 months of history and spending more than €5000 .
	-Regular: Cutomers with atleast 12 months of history but spending €5000 or less.
	-New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group 
*/
WITH customer_segment_summary AS (
SELECT 
customer_key,
lifespan,
total_sales,
CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	 ELSE 'New'
END AS customer_segment
FROM 
(
SELECT 
	customer_key,
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY customer_key
) sq
)
SELECT 
customer_segment,
COUNT(customer_key) AS total_customers
FROM customer_segment_summary 
GROUP BY customer_segment
ORDER BY total_customers DESC
