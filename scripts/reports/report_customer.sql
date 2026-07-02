/* =========================
   1. Revenue by Gender
========================= */

IF OBJECT_ID('gold.reports_revenue_by_gender', 'V') IS NOT NULL
    DROP VIEW gold.reports_revenue_by_gender;
GO

CREATE VIEW gold.reports_revenue_by_gender AS
SELECT 
    c.gender,
    SUM(s.purchase_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_customer c
    ON s.customer_key = c.customer_key
GROUP BY c.gender;
GO


/* =========================
   2. High Value Discount Users
========================= */

IF OBJECT_ID('gold.reports_high_value_discount_users', 'V') IS NOT NULL
    DROP VIEW gold.reports_high_value_discount_users;
GO

CREATE VIEW gold.reports_high_value_discount_users AS
WITH avg_cte AS (
    SELECT AVG(purchase_amount) AS avg_purchase_amount
    FROM gold.fact_sales
)
SELECT 
    s.customer_key,
    s.discount_applied,
    s.purchase_amount,
    a.avg_purchase_amount
FROM gold.fact_sales s
CROSS JOIN avg_cte a
WHERE s.discount_applied = 1
  AND s.purchase_amount > a.avg_purchase_amount;
GO


/* =========================
   3. Subscription Spend Analysis
========================= */

IF OBJECT_ID('gold.reports_subscription_spend', 'V') IS NOT NULL
    DROP VIEW gold.reports_subscription_spend;
GO

CREATE VIEW gold.reports_subscription_spend AS
SELECT 
    s.subscription_status,
    COUNT(DISTINCT s.customer_key) AS total_customers,
    SUM(s.purchase_amount) AS total_revenue,
    AVG(s.purchase_amount) AS avg_order_value
FROM gold.fact_sales s
LEFT JOIN gold.dim_customer c
    ON s.customer_key = c.customer_key
GROUP BY s.subscription_status;
GO


/* =========================
   4. Customer Segments
========================= */

IF OBJECT_ID('gold.reports_customer_segments', 'V') IS NOT NULL
    DROP VIEW gold.reports_customer_segments;
GO

CREATE VIEW gold.reports_customer_segments AS
SELECT 
    s.customer_key,
    CASE 
        WHEN s.previous_purchases >= 10 THEN 'Loyal'
        WHEN s.previous_purchases BETWEEN 2 AND 9 THEN 'Returning'
        ELSE 'New'
    END AS customer_segment,
    s.previous_purchases
FROM gold.fact_sales s;
GO


/* =========================
   5. Repeat Buyer vs Subscription
========================= */

IF OBJECT_ID('gold.reports_repeat_buyer_subscription', 'V') IS NOT NULL
    DROP VIEW gold.reports_repeat_buyer_subscription;
GO

CREATE VIEW gold.reports_repeat_buyer_subscription AS
SELECT 
    s.subscription_status,
    COUNT(*) AS repeat_buyer_count
FROM gold.fact_sales s
LEFT JOIN gold.dim_customer c
    ON s.customer_key = c.customer_key
WHERE s.previous_purchases > 5
GROUP BY s.subscription_status;
GO


/* =========================
   6. Revenue by Age Group
========================= */

IF OBJECT_ID('gold.reports_revenue_by_age_group', 'V') IS NOT NULL
    DROP VIEW gold.reports_revenue_by_age_group;
GO

CREATE VIEW gold.reports_revenue_by_age_group AS
SELECT 
    c.age_group,
    SUM(s.purchase_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_customer c
    ON s.customer_key = c.customer_key
GROUP BY c.age_group;
GO