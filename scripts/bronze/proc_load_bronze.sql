-- Since we do this everyday. why don't we use Stored Procedures ??
/*
==============================================================
STORED PROCEDURE : Importing Data From Source to Bronze Layer
==============================================================
Purpose : this script is use to load data as CSV file from source
to the bronze later schema 
it does TURNCATE the existing tables and BULK INSERT data into new formed ones

NO PARAMETER NEEDED
CALL CODE:
EXEC bronze.load_bronze;
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS


BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'========================================';
		PRINT'Loading Bronze Layer';
		PRINT'========================================';
		PRINT'----------------------------------------';
		PRINT'Loading CRM Files';
		PRINT'----------------------------------------';
		/* since we use the method of truncate and insert we should start with truncating the table to avoid double-inserting */
		SET @start_time = GETDATE();
		PRINT'>>Truncating :bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT'>>Inserting Data: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info --Fast insert not row by row
		FROM 'F:\Data Analysis\Learning\SQL\Data_Warehousing_Project\Data_Set\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2, --In order to avoid headers "if they exists" in the file
			FIELDTERMINATOR = ',', -- This comes from the file as what seperate each field from others
			TABLOCK --lock down the table to ease the import
		);
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';
	
		SET @start_time = GETDATE();
		PRINT'>>Truncating :bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT'>>Inserting Data: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info --Fast insert not row by row
		FROM 'F:\Data Analysis\Learning\SQL\Data_Warehousing_Project\Data_Set\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2, --In order to avoid headers "if they exists" in the file
			FIELDTERMINATOR = ',', -- This comes from the file as what seperate each field from others
			TABLOCK --lock down the table to ease the import
		);
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>>Truncating :bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT'>>Inserting Data:bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details --Fast insert not row by row
		FROM 'F:\Data Analysis\Learning\SQL\Data_Warehousing_Project\Data_Set\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2, --In order to avoid headers "if they exists" in the file
			FIELDTERMINATOR = ',', -- This comes from the file as what seperate each field from others
			TABLOCK --lock down the table to ease the import
		);
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';

		PRINT'----------------------------------------';
		PRINT'Loading ERP Files';
		PRINT'----------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>>Truncating :bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT'>>Inserting Data:bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12 --Fast insert not row by row
		FROM 'F:\Data Analysis\Learning\SQL\Data_Warehousing_Project\Data_Set\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2, --In order to avoid headers "if they exists" in the file
			FIELDTERMINATOR = ',', -- This comes from the file as what seperate each field from others
			TABLOCK --lock down the table to ease the import
		);
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>>Truncating :bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT'>>Inserting Data:bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101 --Fast insert not row by row
		FROM 'F:\Data Analysis\Learning\SQL\Data_Warehousing_Project\Data_Set\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2, --In order to avoid headers "if they exists" in the file
			FIELDTERMINATOR = ',', -- This comes from the file as what seperate each field from others
			TABLOCK --lock down the table to ease the import
		);
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>>Truncating :bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT'>>Inserting Data:bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2 --Fast insert not row by row
		FROM 'F:\Data Analysis\Learning\SQL\Data_Warehousing_Project\Data_Set\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2, --In order to avoid headers "if they exists" in the file
			FIELDTERMINATOR = ',', -- This comes from the file as what seperate each field from others
			TABLOCK --lock down the table to ease the import
		);
		SET @end_time = GETDATE();
		PRINT'>> Loading Time is '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds';
		PRINT'----------------------------------------------------';
		SET @batch_end_time = GETDATE();
		PRINT'>> Batch Load Time is '+CAST(DATEDIFF(second,@batch_start_time,@batch_end_time)AS NVARCHAR)+' Seconds';
	END TRY
	BEGIN CATCH -- This Spit out error message and number if for a reason we failed to load the data files
		PRINT'========================================';
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT'ERROR MESSAGE'+ ERROR_MESSAGE();
		PRINT'ERROR MESSAGE'+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'========================================';
	END CATCH
END


