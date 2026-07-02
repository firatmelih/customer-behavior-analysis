/*
==================================

DDL Script: Create Silver Tables

==================================

Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables

*/

IF OBJECT_ID('silver.customers', 'U') IS NOT NULL
    DROP TABLE silver.customers;
GO

CREATE TABLE silver.customers (
	customer_id INT,
	age INT,
	gender NVARCHAR(50),
	item_purchased NVARCHAR(50),
	category NVARCHAR(50),
	purchase_amount INT,
	location NVARCHAR(50),
	size NVARCHAR(50),
	color NVARCHAR(50),
	season NVARCHAR(50),
	review_rating FLOAT,
	subscription_status INT,
	shipping_type NVARCHAR(50),
	discount_applied INT,
	previous_purchases INT,
	payment_method NVARCHAR(50),
	purchase_frequency_days INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO