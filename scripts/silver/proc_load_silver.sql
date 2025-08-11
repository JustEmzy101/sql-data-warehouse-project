/*
Execution Call : EXEC silver.load_silver
------------------------------------------------------------
Purpose : Stored procedure to load the data from the bronze layer into the silver layer applying multiple transformations across all tables
==================================================================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'========================================';
		PRINT'Loading Silver Layer';
		PRINT'========================================';
		PRINT'----------------------------------------';
		PRINT'Loading CRM Files';
		PRINT'----------------------------------------';
		SET @start_time = GETDATE();
		PRINT'>> Truncating table: silver.crm_cust_info';
		TRUNCATE TABLE [silver].[crm_cust_info];
		PRINT'>> Inserting into table: silver.crm_cust_info';
		INSERT INTO [silver].[crm_cust_info](
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)

		SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			 WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			 ELSE 'Unknown'
		END cst_marital_status,
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			 WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			 ELSE 'Unknown'
		END cst_gndr,
		cst_create_date

		FROM(SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL 
		)t WHERE flag_last =1
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';

		---------------------------------------------------
		SET @start_time = GETDATE();
		PRINT'>> Truncating table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT'>> Inserting into table: silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info(
			prd_id,
			prd_category_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT 
		prd_id,
		--Deriving new column containing category_id 
		REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS prd_category_id,
		--made the product id more reliable
		SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
		prd_nm,
		--replaced all nulls with 0 as cost can't be unknown
		COALESCE(prd_cost,0) AS prd_cost,
		--mapped every abbreviation to a user-friendly format
		CASE UPPER(TRIM(prd_line)) 
			 WHEN 'M' THEN 'Mountain'
			 WHEN 'R' THEN 'Road'
			 WHEN 'S' THEN 'Other Sales'
			 WHEN 'T' THEN 'Touring'
			 ELSE 'Unknown'
		END prd_line,
		--Got the date of end production using the next production date
		prd_start_dt,
		--Here we used DATEADD() to subtract the date by 1 day since 1 is integer and we have a date already
		DATEADD(day,-1,LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt )) AS prd_end_dt
		FROM bronze.crm_prd_info
		--WHERE REPLACE(SUBSTRING(prd_key,1,5),'-','_') NOT IN
		--(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2)
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';
		--------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT'>> Truncating table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT'>> Inserting into table: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_quantity,
			sls_price,
			sls_sales
		)
		SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN LEN(sls_order_dt) != 8 OR sls_order_dt = 0 THEN NULL --Handling invalid data like nulls or wrong date in int form
			 ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) --SQL is dumb we have to change date from INT to VARCHAR then make it to DATE
		END sls_order_dt,
		CASE WHEN LEN(sls_ship_dt) != 8 OR sls_ship_dt = 0 THEN NULL --Handling invalid data like nulls or wrong date in int form
			 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)--SQL is dumb we have to change date from INT to VARCHAR then make it to DATE
		END sls_ship_dt,
		CASE WHEN LEN(sls_due_dt) != 8 OR sls_due_dt = 0 THEN NULL --Handling invalid data like nulls or wrong date in int form
			 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)--SQL is dumb we have to change date from INT to VARCHAR then make it to DATE
		END sls_due_dt,
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <= 0 -- Here we derving the price from the sales and quantity if it's NULL or -ve Value
			 THEN sls_sales / NULLIF(sls_quantity,0)
			 ELSE sls_price
		END AS sls_price,
		-- Sales is Null or less or equal than zero or negative we drive the price from quantity and price
		CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != ABS(sls_price) * sls_quantity THEN ABS(sls_price) * sls_quantity
			 ELSE sls_sales
		END AS  sls_sales

		FROM bronze.crm_sales_details
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';
		------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT'>> Truncating table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT'>> Inserting into table: silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12 (cid,bdate,gen)

		SELECT 
		CASE WHEN cid  LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
			 ELSE cid
		END cid,
		CASE WHEN bdate > GETDATE() THEN NULL
			 ELSE bdate
		END bdate,
		CASE WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			 WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			 ELSE 'Unknown'
		END gen
		FROM bronze.erp_cust_az12
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';
		-------------------------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT'>> Truncating table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT'>> Inserting into table: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101(cid,cntry)
		SELECT 
		REPLACE(cid,'-','') AS cid, --Here we removed the '-' between the numbers
		CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			 WHEN TRIM(cntry) IN('US','USA') THEN 'United States'
			 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unknown'
			 ELSE TRIM(cntry)
		END AS cntry
		FROM bronze.erp_loc_a101;
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';
		-----------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT'>> Truncating table:  [silver].[erp_px_cat_g1v2]';
		TRUNCATE TABLE  [silver].[erp_px_cat_g1v2];
		PRINT'>> Inserting into table:  [silver].[erp_px_cat_g1v2]1';
		INSERT INTO [silver].[erp_px_cat_g1v2]
		(id,
		cat,
		subcat,
		maintenance
		)
		SELECT 
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_px_cat_g1v2
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';
	END TRY
	BEGIN CATCH
		PRINT'========================================';
		PRINT'ERROR OCCURED DURING LOADING SILVER LAYER';
		PRINT'ERROR MESSAGE'+ ERROR_MESSAGE();
		PRINT'ERROR MESSAGE'+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'========================================';
	END CATCH
END

