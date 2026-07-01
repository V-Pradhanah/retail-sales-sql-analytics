--9. Performance Analysis
--Comparing the current value to a target value
--..........................................................

--Analyse the yearly performance of products by comparing each  product's sales to both
--its average sales performance and the previous year's sales

WITH yearly_product_summary AS (
SELECT 
	dp.product_name,
	YEAR(fs.order_date) AS order_year,	
	SUM(fs.sales_amount) AS current_sales,
	AVG(SUM(fs.sales_amount)) OVER(PARTITION BY dp.product_name) AS avgsalesbyproduct,
	LAG(SUM(fs.sales_amount)) OVER(PARTITION BY dp.product_name ORDER BY YEAR(fs.order_date) ASC) AS previousyearsalesofproduct
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON fs.product_key = dp.product_key
WHERE order_date IS NOT NULL
GROUP BY 
	dp.product_name,
	YEAR(fs.order_date)
)
--Year over year analysis
SELECT 
	product_name,
	order_year,
	current_sales,
	avgsalesbyproduct,
	current_sales - avgsalesbyproduct AS current_diff_avg,
	CASE WHEN current_sales - avgsalesbyproduct > 0 THEN 'Above Avg'
		 WHEN current_sales - avgsalesbyproduct < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END AS avg_change,
	current_sales,
	previousyearsalesofproduct,
	current_sales - previousyearsalesofproduct AS current_diff_previous,
	CASE WHEN current_sales - previousyearsalesofproduct > 0 THEN 'Increase'
		 WHEN current_sales - previousyearsalesofproduct < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END AS py_change
FROM yearly_product_summary
ORDER BY product_name ASC ,	order_year ASC
