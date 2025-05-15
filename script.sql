-- SQL Retail sales Analysis

create database sql_project_01;
use sql_project_01;

-- create table
drop table  if exists retail_sales;
create table retail_sales(
	transactions_id	int primary key,
    sale_date date,
    sale_time	time,
    customer_id	int,
    gender varchar(20),
    age	int,
    category varchar(20),
    quantiy	int,
    price_per_unit	float,
    cogs float,
    total_sale float
);

select * from retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Data Exploration

-- How many sales we have?
select count(*) as total_sales 
from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id) as total_customers from retail_sales;
select distinct customer_id from retail_sales;

-- How many catogories we have?
select count(distinct category) as total_categories from retail_sales;
select distinct category from retail_sales;


-- Data Analysis & Business Key problems with answers
select * from retail_sales;

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales where sale_date = '2022-11-05';

-- 2.Write a SQL query to retrieve all transactions where 
-- the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select *
from retail_sales
where category = 'Clothing'
  and quantiy >=4
  and sale_date between '2022-11-01' and '2022-11-30';
  
-- 3.Write a SQL query to calculate the total sales (total_sale) for each category:
select category, sum(total_sale) as total_sales, count(*) as total_orders from retail_sales
	group by category;
    
-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:
select round(avg(age),2) as avg_age from retail_sales where category = 'Beauty';

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000:
select * from retail_sales where total_sale > 1000;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) 
-- made by each gender in each category:
select category,gender, count(*) from retail_sales
group by category,gender
order by 1;

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select* from retail_sales;
-- First, calculate the average total_sale per month per year
WITH monthly_avg_sales AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        ROUND(AVG(total_sale), 2) AS avg_monthly_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)

-- Now, find the best-selling month (highest avg) for each year
SELECT 
    sale_year,
    sale_month,
    avg_monthly_sale
FROM monthly_avg_sales AS m
WHERE avg_monthly_sale = (
    SELECT MAX(avg_monthly_sale)
    FROM monthly_avg_sales
    WHERE sale_year = m.sale_year
)
ORDER BY sale_year;
-- First, calculate the average total_sale per month per year
WITH monthly_avg_sales AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        ROUND(AVG(total_sale), 2) AS avg_monthly_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)

-- Now, find the best-selling month (highest avg) for each year
SELECT 
    sale_year,
    sale_month,
    avg_monthly_sale
FROM monthly_avg_sales AS m
WHERE avg_monthly_sale = (
    SELECT MAX(avg_monthly_sale)
    FROM monthly_avg_sales
    WHERE sale_year = m.sale_year
)
ORDER BY sale_year;

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id,sum(total_sale) from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category
select * from retail_sales;
select count(distinct(customer_id)), category from retail_sales
group by category;

-- 10.Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM
    retail_sales
GROUP BY
    shift
ORDER BY
    shift;