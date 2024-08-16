--Create Table
CREATE TABLE retail_sales
			(transactions_id INT,	
			 sale_date	DATE,
			 sale_time	TIME,
			 customer_id	INT,
			 gender	VARCHAR(15),
			 age	INT,
			 category VARCHAR(15),	
			 quantiy	INT,
			 price_per_unit	FLOAT,
			 cogs	FLOAT,
			 total_sale FLOAT
			);
			
SELECT * FROM retail_sales;

SELECT * FROM public.retail_sales
LIMIT 100

SELECT 
    COUNT(*)
FROM retail_sales

--Data Cleaning

SELECT * FROM public.retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;  
 
 
--Data Exploration

--How Many sales
SELECT COUNT(*) as total_sale From retail_sales

-- How unique Many Customer 
SELECT COUNT( DISTINCT customer_id) as total_sale From retail_sales
 
SELECT  DISTINCT category From retail_sales
 
--Data Analysis & Business Key Problems & Answers
--A SQL query to retrieve all columns for sales made on 
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--A SQL query to retrieve all transaction where the category is 'closing' and the quantity sold is more than 4 in the month of NOV-2022

SELECT
   *
FROM  retail_sales
WHERE category = 'Clothing'
     AND
	 TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
     AND
	 quantiy>= 4
   
--Write a SQL Query to calculate the total sales (total_sale) for each category.

SELECT 
     category,
	 SUM(total_sale) as net_sale,
	 COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Write A SQL query to Find the average age of customers who purchased items from the 'Beauty' category.

SELECT
   ROUND (AVG (age), 2) as avg_age
FROM retail_sales
Where category = 'Beauty'

--Write a SQL query to find all transactions where the total sale is greater than 1000.
SELECT * From retail_sales
Where total_sale > 1000


--Find the Total number of transactions(transaction_id) made by each gender in each category
SELECT 
   category,
   gender,
   COUNT(*) as total_trans
FROM retail_sales
GROUP
   BY
   category,
   gender
Order BY 1   

-- Calculate the average sale for each month. Find the best selling month in each year
SELECT
       year,
	   month,
	 avg_sale  
FROM
(
SELECT
    EXTRACT(YEAR FROM sale_date) as year,
	 EXTRACT(MONTH FROM sale_date) as month,
	 AVG(total_sale) as avg_sale,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1 


--ORDER BY 1,3 DESC

--Find the top 5 customers based on the highest total sales
SELECT
     customer_id,
	 SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Find number of unique customers who purchased items from each category
SELECT
    category,
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

--Create each shift and number of orders (Example Morning, Afternoon, Evening)
WITH hourly_sale
AS
(
SELECT *,
     CASE
	     WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'AFTERNOON'
		 ELSE 'Evening'
	  END as shift
From retail_sales	  
)
SELECT 
    shift,
	COUNT(*) as total_orders	
FROM hourly_sale
GROUP BY shift


--END OF PROJECT
