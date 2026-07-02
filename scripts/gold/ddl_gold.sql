/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/


-- =============================================================================
-- Create Dimension: gold.dim_customer
-- =============================================================================

IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
    DROP VIEW gold.dim_customer;
GO

CREATE VIEW gold.dim_customer AS
SELECT
    DENSE_RANK() OVER (ORDER BY customer_id) AS customer_key,
    customer_id,
    gender,
    location,
    age,
    CASE
        WHEN age BETWEEN 15 AND 20 THEN '15-20'
        WHEN age BETWEEN 20 AND 25 THEN '20-25'
        WHEN age BETWEEN 30 AND 35 THEN '30-35'
        WHEN age BETWEEN 35 AND 45 THEN '35-45'
        WHEN age BETWEEN 45 AND 55 THEN '45-55'
        WHEN age >= 55 THEN '55+'
        ELSE 'n/a'
    END AS age_group
FROM silver.customers;
GO

-- =============================================================================
-- Create Dimension: gold.dim_product
-- =============================================================================

IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
    DROP VIEW gold.dim_product;
GO
CREATE VIEW gold.dim_product AS
SELECT DISTINCT
    ABS(CHECKSUM(
        CONCAT(item_purchased, '|', category, '|', color, '|', size)
    )) AS product_key,

    item_purchased,
    category,
    color,
    size
FROM silver.customers;
GO

-- =============================================================================
-- Create Dimension: gold.dim_shipping
-- =============================================================================

IF OBJECT_ID('gold.dim_shipping', 'V') IS NOT NULL
    DROP VIEW gold.dim_shipping;
GO

CREATE VIEW gold.dim_shipping AS
SELECT DISTINCT
    shipping_type
FROM silver.customers;
GO

-- =============================================================================
-- Create Dimension: gold.dim_payment
-- =============================================================================

IF OBJECT_ID('gold.dim_payment', 'V') IS NOT NULL
    DROP VIEW gold.dim_payment;
GO

CREATE VIEW gold.dim_payment AS
SELECT DISTINCT
    payment_method
FROM silver.customers;
GO
-- =============================================================================
-- Create Dimension: gold.fact_sales
-- =============================================================================

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    dc.customer_key,
    dp.product_key,

    ds.shipping_type,
    dpm.payment_method,

    s.purchase_amount,
    s.review_rating,
    s.purchase_frequency_days,
    s.previous_purchases,
    s.subscription_status,
    s.discount_applied

FROM silver.customers s

JOIN gold.dim_customer dc
    ON dc.customer_id = s.customer_id

JOIN gold.dim_product dp
    ON dp.item_purchased = s.item_purchased
   AND dp.category = s.category
   AND dp.color = s.color
   AND dp.size = s.size

JOIN gold.dim_shipping ds
    ON ds.shipping_type = s.shipping_type

JOIN gold.dim_payment dpm
    ON dpm.payment_method = s.payment_method;