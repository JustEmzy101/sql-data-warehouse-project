/*
========================================================================
gold.products_report
========================================================================
Purpose : Create or edit a view that helps data analysts to have an insight on the products data 
after being cleaned and inclusive 
========================================================================
*/
CREATE OR ALTER VIEW gold.products_report AS
WITH basic_query AS(
	SELECT 
	p.product_key AS id,
	p.product_name AS title,
	p.product_category AS category,
	p.product_sub_category AS subcategory,
	p.product_cost AS cost,
	p.production_starting_date AS production_start,
	p.production_ending_date AS production_end,
	s.order_number AS order_number,
	s.order_date AS order_date,
	s.sales AS sales,
	s.quantity AS quantity,
	s.price AS price,
	s.customer_id AS customer_id
	FROM gold.dim_products_total p 
	LEFT JOIN gold.fact_sales s
	ON p.product_key = s.product_key
	WHERE s.order_date IS NOT NULL
)


SELECT

id,
title,
category,
subcategory,
cost,
price,
MAX(order_date) AS last_order,
COUNT(order_number) AS total_orders,
SUM(sales) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_id) AS total_customers_ordered,
DATEDIFF(month,production_start,GETDATE()) AS lifespan,
DATEDIFF(month,MAX(order_date),GETDATE()) AS recency,
SUM(sales)/COUNT(order_number) AS sale_avg,
SUM(sales) / (DATEDIFF(month,production_start,GETDATE())-DATEDIFF(month,MAX(order_date),GETDATE())) AS montly_avg,
CASE
	WHEN SUM(sales) >= 50000 THEN 'High-performer'
	WHEN SUM(sales) < 50000 AND SUM(sales) >= 20000 THEN 'Mid-performer'
	ELSE 'Low-performer'
END AS product_performance
FROM basic_query
GROUP BY 
	id,
	title,
	category,
	subcategory,
	cost,
	price,
	production_start
	
	
