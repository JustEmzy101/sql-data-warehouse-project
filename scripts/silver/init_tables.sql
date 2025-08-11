--Create Tables for Silver layer
-- We either ask the data provider experts about the data type or take a sample and explore it ourselves
/* here we followed each file data types so we can define the types in here */

IF OBJECT_ID ('silver.crm_cust_info','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE silver.crm_cust_info; -- drop the table if it exists
CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(10),
	cst_gndr NVARCHAR(10),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
IF OBJECT_ID ('silver.crm_prd_info','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE silver.crm_prd_info; -- drop the table if it exists
CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	prd_category_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(100),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
IF OBJECT_ID ('silver.crm_sales_details','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE silver.crm_sales_details; -- drop the table if it exists
CREATE TABLE silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_quantity INT,
	sls_price INT,
	sls_sales INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
IF OBJECT_ID ('silver.erp_cust_az12','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE silver.erp_cust_az12; -- drop the table if it exists
CREATE TABLE silver.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(10),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
IF OBJECT_ID ('silver.erp_loc_a101','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE silver.erp_loc_a101; -- drop the table if it exists
CREATE TABLE silver.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
IF OBJECT_ID ('silver.erp_px_cat_g1v2','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE silver.erp_px_cat_g1v2; -- drop the table if it exists
CREATE TABLE silver.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(20),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
