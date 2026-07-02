/*
==================================

DDL Script: Create Bronze Tables

==================================

Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables

*/

IF OBJECT_ID('bronze.customers', 'U') IS NOT NULL
    DROP TABLE bronze.customers;
GO

CREATE TABLE bronze.customers (
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
    subscription_status NVARCHAR(50),
    shipping_type NVARCHAR(50),
    discount_applied NVARCHAR(50),
    promo_code_used NVARCHAR(50),
    previous_purchases INT,
    payment_method NVARCHAR(50),
    frequency_of_purchases NVARCHAR(50)
);
GO