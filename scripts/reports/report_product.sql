/* =========================
   1. Top 5 Products With The Highest Average Review Rating
========================= */

IF OBJECT_ID('gold.reports_products_avg_rating_top5', 'V') IS NOT NULL
    DROP VIEW gold.reports_products_avg_rating_top5;
GO

CREATE VIEW gold.reports_products_avg_rating_top5 AS
SELECT *
    FROM(SELECT 
    *, 
    ROW_NUMBER() OVER(ORDER BY average_rating DESC)  as rank_rating
    FROM(
        SELECT 
            p.item_purchased,
            ROUND(AVG(s.review_rating),2) AS average_rating
        FROM gold.fact_sales s
        LEFT JOIN gold.dim_product p
        ON s.product_key = p.product_key
        GROUP BY p.item_purchased)t
        )t
    WHERE rank_rating < 6
GO

/* =========================
   2. Top 3 Products With The Highest Purchases Within Each Category
========================= */

IF OBJECT_ID('gold.reports_most_purchased_products_each_category_top3', 'V') IS NOT NULL
    DROP VIEW gold.reports_most_purchased_products_each_category_top3;
GO

CREATE VIEW gold.reports_most_purchased_products_each_category_top3 AS
SELECT * 
FROM (
    SELECT 
        *, 
        ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_orders) AS rank_item_by_category
    FROM (
    SELECT 
        p.category,
        p.item_purchased,
        COUNT(p.product_key) as total_orders
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_product p
    ON s.product_key = p.product_key
    GROUP BY p.category, p.item_purchased)t
    )t
WHERE rank_item_by_category < 4
GO

/* =========================
   2. Top 5 Products With The Highest Percentage of Purchases With Discounts Applied
========================= */
IF OBJECT_ID('gold.reports_products_highest_percentage_of_sales_top5', 'V') IS NOT NULL
    DROP VIEW gold.reports_products_highest_percentage_of_sales_top5;
GO

CREATE VIEW gold.reports_products_highest_percentage_of_sales_top5 AS
SELECT TOP 5
    p.item_purchased,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN s.discount_applied = 1 THEN 1 ELSE 0 END) AS discounted_orders,
    1.0 * SUM(CASE WHEN s.discount_applied = 1 THEN 1 ELSE 0 END) / COUNT(*) AS pct_discounted
FROM gold.fact_sales s
JOIN gold.dim_product p
    ON p.product_key = s.product_key
GROUP BY 
    p.item_purchased
ORDER BY 
    pct_discounted DESC;
GO