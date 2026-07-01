--Exploratory Data Analysis 
--Step: 1
--Database exploration
--==================================================
--Explore all tables in Database
SELECT * FROM INFORMATION_SCHEMA.TABLES
--..........
--Explore all columns in Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS


--Step: 2
--Dimension Exploration
--DISTINCT [Dimension column]
--==========================================
--Explore geographical spread
SELECT DISTINCT country FROM gold.dim_customers

--Explore all categories 'The Major Division'
SELECT DISTINCT category , subcategory, product_name from gold.dim_products
ORDER BY 1,2,3

--Step: 3 
--Date Exploration
--=============================================
--Identify the earliest and latest dates (boundaries)
SELECT MIN(order_date) first_order_date, MAX(order_date) last_order_date FROM gold.fact_sales

--How many years of sales are available in the table to know the scope of data
SELECT DATEDIFF(YEAR, MIN(order_date),MAX(order_date)) AS order_range_in_years FROM gold.fact_sales

--Find the youngest and oldest customer
SELECT 
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age,

	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age
FROM gold.dim_customers
