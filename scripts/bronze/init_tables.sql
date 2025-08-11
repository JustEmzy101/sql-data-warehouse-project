--Create Tables for bronze layer
-- We either ask the data provider experts about the data type or take a sample and explore it ourselves
/* here we followed each file data types so we can define the types in here 


=====================================================================
WARNING : THIS WILL DELETE ANY TABLE WITH THE NAMES BELOW SO PROCEED WITH CAUTION
=====================================================================
*/


IF OBJECT_ID ('bronze.crm_cust_info','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE bronze.crm_cust_info; -- drop the table if it exists
CREATE TABLE bronze.crm_cust_info(
	cst_id INT NOT NULL,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(10),
	cst_gndr NVARCHAR(10),
	cst_create_date DATE
);
IF OBJECT_ID ('bronze.crm_prd_info','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE bronze.crm_prd_info; -- drop the table if it exists
CREATE TABLE bronze.crm_prd_info(
	prd_id INT NOT NULL,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT NOT NULL,
	prd_line NVARCHAR(10),
	prd_start_dt DATE,
	prd_end_dt DATE
);
IF OBJECT_ID ('bronze.crm_sales_details','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE bronze.crm_sales_details; -- drop the table if it exists
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);
IF OBJECT_ID ('bronze.erp_cust_az12','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE bronze.erp_cust_az12; -- drop the table if it exists
CREATE TABLE bronze.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(10)
);
IF OBJECT_ID ('bronze.erp_loc_a101','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE bronze.erp_loc_a101; -- drop the table if it exists
CREATE TABLE bronze.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);
IF OBJECT_ID ('bronze.erp_px_cat_g1v2','U') IS NOT NULL  --here its a check if the table is existing or not 
	DROP TABLE bronze.erp_px_cat_g1v2; -- drop the table if it exists
CREATE TABLE bronze.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(20),
);
