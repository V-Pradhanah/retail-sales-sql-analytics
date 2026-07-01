--==========================================================================================================
--Run this query to know the impact of NULL order date columns in overall contribution and decide whether to exclude the NULL rows or not
--Data quality check to how many order_date are NULL, to impact of those rows to overall sales
SELECT SUM(sales_amount) AS overall_revenue -- overall revenue    --29356250
FROM gold.fact_sales

SELECT SUM(sales_amount)  --total sales where order date IS NULL   --4992
FROM gold.fact_sales
WHERE order_date IS NULL

--percent_of_sales_where_order_date_is_null
SELECT 
(SELECT SUM(sales_amount)  --total sales where order date IS NULL   --4992
FROM gold.fact_sales
WHERE order_date IS NULL) * 1.0 / 
(SELECT SUM(sales_amount)  -- overall revenue    --29356250
FROM gold.fact_sales)  * 100   AS percent_of_sales_where_order_date_is_null


SELECT COUNT(*) FROM gold.fact_sales -- total rows  --60398
SELECT COUNT(*) FROM gold.fact_sales  -- Number of rows where orde date is NULL   --19
WHERE  order_date IS NULL

--percent_of_rows_where_order_date_is_null

SELECT (SELECT COUNT(*) FROM gold.fact_sales  WHERE  order_date IS NULL) * 1.0 / (SELECT COUNT(*) FROM gold.fact_sales) * 100
--=============================================================================================================================

/*
As one single product have different  price at different times, computing Average of price  [Avg(price)] on whole will lead to incorrect result.
Hence, we compute average selling price by AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0))
*/
--Quality check
SELECT
 product_key,
 COUNT(DISTINCT price)
 FROM gold.fact_sales 
 GROUP BY product_key
 HAVING  COUNT(DISTINCT price) > 1
