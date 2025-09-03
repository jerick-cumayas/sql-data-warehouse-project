/*
===========================================
STORED PROCEDURE: bronze.load_bronze
===========================================
Script purpose:
	- Populates the crm tables with data from CSV files
	- Populates the erp tables with data from CSV files
	- Truncates the tables before bulk inserting data 
	- Load duration is calculated for every data
	- Total load duration for entire bronze batch is calculated
	- Uses the following code: PROCEDURE, TRUNCATE, BULK INSERT, DATEDIFF, DECLARE
	- Procedure contains try-catch block for error handling
Usage example:
 EXEC bronze.load_bronze
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME
	DECLARE @total_start DATETIME, @total_end DATETIME
	BEGIN TRY
		SET @total_start = GETDATE()
		PRINT '=======================================';
		PRINT 'Loading the Bronze Layer';
		PRINT '=======================================';
		PRINT '---------------------------------------';
		PRINT 'Loading the CRM tables';
		PRINT '---------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating  table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting data into bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Jerick\Development\Repositories\my\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SELECT COUNT(*) FROM bronze.crm_cust_info;
		SET @end_time = GETDATE();

		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '---------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating  table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting data into bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Jerick\Development\Repositories\my\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SELECT COUNT(*) FROM bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time)AS NVARCHAR) + 'seconds';
		PRINT '---------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating  table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting data into bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Jerick\Development\Repositories\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SELECT COUNT(*) FROM bronze.crm_sales_details;
		SET @end_time = GETDATE()
		PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';

		PRINT '---------------------------------------';
		PRINT 'Loading the ERP tables';
		PRINT '---------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating  table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting data into bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Jerick\Development\Repositories\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SELECT COUNT(*) FROM bronze.erp_cust_az12;
		SET @end_time = GETDATE()
		PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';

		SET @start_time = GETDATE()
		PRINT '>> Truncating  table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting data into bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Jerick\Development\Repositories\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (FIRSTROW=2, FIELDTERMINATOR=',', TABLOCK);
		SELECT COUNT(*) FROM bronze.erp_cust_az12;
		SET @end_time = GETDATE()
		PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';

		SET @start_time = GETDATE()
		PRINT '>> Truncating  table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting data into bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Jerick\Development\Repositories\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (FIRSTROW=2,FIELDTERMINATOR=',',TABLOCK);
		SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE()
		PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		SET @total_end = GETDATE()
		PRINT '=======================================';
		PRINT 'BRONZE LAYER COMPLETED!';
		PRINT 'TOTAL BRONZE LAYER DURATION: ' + CAST(DATEDIFF(second, @total_start, @total_end) AS NVARCHAR) + 'seconds';
		PRINT '=======================================';
	END TRY
	BEGIN CATCH
        PRINT '=======================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=======================================';
    END CATCH
END