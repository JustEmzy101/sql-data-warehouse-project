/*
============================================
GOLD LAYER FOUNDATION 
============================================
Purpose : This script forms 3 view in the gold layer from the silver layer which handles the transformations and data cleansing
1- gold.dim_products
2- gold.dim_customers
3- gold.fact_sales

Usage : used diretly for reporting and analytics

*/
------ forming the gold.dim_products -------
CREATE OR ALTER VIEW gold.dim_products AS
SELECT 
ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt,pn.prd_key) as product_key,
pn.prd_id AS product_id,
pn.prd_key AS product_keys,
pn.prd_nm as product_name,
pn.prd_category_id as product_category_id,
px.cat as product_category,
px.subcat as product_sub_category,
px.maintenance as maintenance_need,
pn.prd_cost as product_cost,
pn.prd_line as product_line,
pn.prd_start_dt as production_starting_date

FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 px
ON pn.prd_category_id = px.id
--Filter out all historical data
WHERE pn.prd_end_dt IS NULL -- Null in the end date means that's the product is still in production 


------ forming the gold.dim_customers ---------

CREATE VIEW gold.dim_customers AS -- here we create the view so we access it later on for reporting
	 SELECT 
	 ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key, -- we created this column in order to use as a reference insted of relying on original cst_id from previous layer
	 ci.cst_id AS customer_id,
	 ci.cst_key AS customer_number,
	 ci.cst_firstname AS firstname,
	 ci.cst_lastname AS lastname,
	 loc.cntry AS country, 
	 ci.cst_marital_status AS marital_status,
	 CASE WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr -- Since we contacted the experts they verified that CRM is more reliable on Gender so we depend on its data
	 ELSE COALESCE(ca.gen,'Unknown')
	 END AS gender,
	 ca.bdate AS birthday,
	 ci.cst_create_date AS create_date
	 
	 /* Here we are joining multiple tables together since they belong to one criteria which is CUSTOMERS so we joined them
	 in order to form a MASTER TABLE OR VIEW to make it as a reference whoever wants data about customer revert to it */
	 FROM silver.crm_cust_info ci
	 LEFT JOIN silver.erp_cust_az12 ca
	 ON ci.cst_key = ca.cid
 
	 LEFT JOIN silver.erp_loc_a101 loc
	 ON ci.cst_key = loc.cid


-------- forming the gold.fact_sales ----------

CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
sd.sls_ord_num AS order_number,
cu.customer_id,
pr.product_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales,
sd.sls_quantity AS quantity,
sd.sls_price as price

FROM silver.crm_sales_details sd

LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id

LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_keys
