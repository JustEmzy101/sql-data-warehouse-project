/*
========================================================================
gold.customers_report
========================================================================
Purpose : Create or edit a view that helps data analysts to have an insight on the data of customers
after being cleaned and inclusive 
========================================================================
*/
CREATE OR ALTER VIEW gold.customers_report AS
WITH basic_query AS (
	SELECT 
	c.customer_id AS cust_id,
	CONCAT(c.firstname,' ',c.lastname) AS fullname,
	DATEDIFF(year,birthday,GETDATE()) AS age,
	c.customer_number AS cust_num,
	s.order_number AS ord_num,
	s.order_date AS ord_dt,
	s.sales AS sales,
	s.quantity AS quant,
	s.product_key AS product_key
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_id = c.customer_id
	WHERE s.order_date IS NOT NULL
)
, aggregation_query AS
(
	SELECT 
	cust_id,
	fullname,
	age,
	cust_num,
	
	COUNT(DISTINCT ord_num) AS total_orders,
	SUM(sales) AS total_sales,
	COUNT(DISTINCT product_key) AS total_goods_bought,
	SUM(quant) total_products,
	DATEDIFF(month,MIN(ord_dt),MAX(ord_dt)) AS lifespan,
	DATEDIFF(month,MAX(ord_dt),GETDATE()) AS recency
	FROM basic_query
	GROUP BY 
		cust_id,
		fullname,
		age,
		cust_num

)
SELECT 
cust_id,
cust_num,
fullname,
age,
recency,
total_orders,
total_sales,
total_sales / total_orders AS avg_per_order,
total_goods_bought,
total_products,
lifespan,
CASE
	WHEN lifespan = 0 THEN total_sales
	ELSE total_sales / total_orders
END monthly_spendature,
CASE
	WHEN lifespan >= 12 AND total_sales >5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_sales < 5000 THEN 'Regular'
	ELSE 'New'
END cust_category
FROM aggregation_query
