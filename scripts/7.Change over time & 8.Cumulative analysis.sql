--Advanced Analytics Project
--Change over time (To know the long term business growth patterns and short term seasonality and trends)
--Agg(metrics/measure) by Date
--................................................................................

--7. Change over Time Analysis (By year, month, quarter)
--What is the total sales trend and total customers growth trend by year?
SELECT 
	DATETRUNC(month, order_date) AS order_year_month ,
	SUM(sales_amount) AS total_sales,
	COUNT( DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY  DATETRUNC(month, order_date) 
ORDER BY DATETRUNC(month, order_date)  


--8. Cumulative Analysis --Aggregate the data progressively over the time
--Helps us to undersand whether our business is growing or declining over the time
--Running total/Moving Average
--Default frame Rows between unbounded preceding and current row
--''''''''''''''''''''''''''''''''''''''''''''''''''
-- Calculate the total sales per month and the running total of sales  over time
SELECT 
	sq. order_year_month,
	sq.total_sales,
	SUM(sq.total_sales) OVER ( ORDER BY order_year_month ASC) AS running_total,
	sq.avg_price,
	AVG(sq.avg_price) OVER(ORDER BY order_year_month ASC) AS moving_avg_price
FROM (
SELECT 
	DATETRUNC(month, order_date) AS order_year_month ,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY  DATETRUNC(month, order_date) )sq
ORDER BY sq. order_year_month ASC

