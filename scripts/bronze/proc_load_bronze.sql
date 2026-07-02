/*

======================================================

Stored Procedure: Load Bronze Layer (Source -> Bronze)

======================================================

Script Purpose:
	This stored procedure loads data into the 'bronze'
	schema from external CSV files.
	It performs the following actions:
		-	Truncates the bronze tables before
		loading data.
		-	Uses the 'BULK INSERT' command to load
		data from csv files to bronze tables.

Parameters:
	None.

This stored procedure does not accept any parameters
or return any values

Usage:
	EXEC bronze.load_bronze;

======================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	SET @batch_start_time = GETDATE();
	BEGIN TRY
		PRINT '======================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '======================================================';

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.customers';
	TRUNCATE TABLE bronze.customers;

	PRINT '>> Inserting Data Into: bronze.customers';
	BULK INSERT bronze.customers
	FROM 'C:\Users\fener\Documents\customer_shopping_behaviour_analysis\customer_shopping_behavior.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds' ;
	PRINT '------------------------------------------------------';

	PRINT '======================================================';
	PRINT 'Bronze Layer Load Completed';
	SET @batch_end_time = GETDATE();
	PRINT '>> Bronze Layer Batch Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds' ;

	END TRY
	BEGIN CATCH
		PRINT '======================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR) 
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR) 
		PRINT '======================================================';
	END CATCH
END