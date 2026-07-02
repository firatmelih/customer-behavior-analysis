/*

======================================================

Stored Procedure: Load Silver Layer (Bronze -> Silver)

======================================================

Script Purpose:
	This stored procedure performs the ETL (Extract, 
	Transform, Load) process to 
    populate the 'silver' schema tables from the 
	'bronze' schema.


	It performs the following actions:

		-	Truncates the silver tables before
		loading data.

		- Inserts transformed and cleansed data from 
		Bronze into Silver tables.

Parameters:
	None.

This stored procedure does not accept any parameters
or return any values

Usage:
	EXEC silver.load_silver;

======================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY  	
        SET @batch_start_time = GETDATE();
		PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';


        -- Loading silver.customers
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.customers';
		TRUNCATE TABLE silver.customers;
		PRINT '>> Inserting Data Into: silver.customers';
		INSERT INTO silver.customers (
		customer_id,
		age,
		gender,
		item_purchased,
		category,
		purchase_amount,
		location,
        size,
        color,
        season,
        review_rating,
        subscription_status,
        shipping_type,
        discount_applied,
        previous_purchases,
        payment_method,
        purchase_frequency_days
		)
        SELECT
            c.customer_id,
            c.age,
            c.gender,
            c.item_purchased,
            c.category,
            c.purchase_amount,
            c.location,
            CASE c.size
                WHEN 'S' THEN 'Small'
                WHEN 'M' THEN 'Medium'
                WHEN 'L' THEN 'Large'
                WHEN 'XL' THEN 'Extra Large'
                ELSE 'n/a'
            END AS size,
            c.color,
            c.season,
            COALESCE(c.review_rating, ROUND(a.avg_rating, 1)) AS review_rating,
            CASE c.subscription_status
                WHEN 'Yes' THEN 1
                ELSE 0
            END AS subscription_status,
            c.shipping_type,
            CASE c.discount_applied
                WHEN 'Yes' THEN 1
                ELSE 0
            END AS discount_applied,
            c.previous_purchases,
            c.payment_method,
            CASE c.frequency_of_purchases
            WHEN 'Weekly' THEN 7
            WHEN 'Bi-Weekly' THEN 14
            WHEN 'Fortnightly' THEN 14
            WHEN 'Monthly' THEN 30
            WHEN 'Quarterly' THEN 90
            WHEN 'Every 3 Months' THEN 90
            WHEN 'Annually' THEN 365
        END AS purchase_frequency_days
        FROM bronze.customers c
        JOIN (
            SELECT
                category,
                AVG(review_rating) AS avg_rating
            FROM bronze.customers
            WHERE review_rating IS NOT NULL
            GROUP BY category
        ) a
        ON c.category = a.category
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        	
	
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END