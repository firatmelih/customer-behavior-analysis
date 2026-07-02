# Customer Shopping Behavior Analytics Pipeline

## Project Overview

This project implements an end-to-end data warehouse pipeline using a Medallion Architecture (Bronze, Silver, Gold) to analyze customer shopping behavior. It combines SQL Server for data warehousing and Python (Pandas) for data cleaning and feature engineering.

The final output is a star schema optimized for reporting, analytics, and business intelligence use cases.

---

## Data Architecture

### Bronze Layer (Raw Data)
- Stores raw CSV data loaded from source
- No transformations applied
- Loaded using SQL Server BULK INSERT

### Silver Layer (Cleaned Data)
- Data cleansing and standardization
- Missing value handling
- Feature engineering
- Data type conversions
- Normalization of categorical values

### Gold Layer (Business Layer)
- Star schema design (fact + dimension tables)
- Optimized for analytics and reporting
- Business-ready aggregated views

---

## Database Structure

### Schemas
- bronze: raw ingestion layer
- silver: cleaned and transformed data
- gold: analytical reporting layer

---

## Star Schema (Gold Layer)

### Dimension Tables
- dim_customer: customer demographics and age grouping
- dim_product: product attributes (category, color, size)
- dim_shipping: shipping types
- dim_payment: payment methods

### Fact Table
- fact_sales: transactional sales data including:
  - purchase amount
  - review rating
  - discount usage
  - subscription status
  - foreign keys to dimensions

---

## ETL Process

### Bronze Layer Load
- Drops and recreates bronze.customers
- Loads CSV data using BULK INSERT
- Executed via stored procedure: bronze.load_bronze

### Silver Layer Transformation
- Standardizes categorical values (size, subscription, discount)
- Handles missing values using category-based averages
- Converts frequency to numeric values
- Outputs cleaned dataset into silver schema
- Executed via stored procedure: silver.load_silver

### Gold Layer Creation
- Builds star schema using SQL views
- Generates surrogate keys:
  - DENSE_RANK for customers
  - CHECKSUM for products

---

## Analytical Views (Gold Layer)

### Revenue Analysis
- Revenue by gender
- Revenue by age group
- Subscription vs revenue analysis

### Customer Analysis
- Customer segmentation (New, Returning, Loyal)
- High-value discount users
- Repeat buyer behavior

### Product Analysis
- Top products by rating
- Most purchased products per category
- Products with highest discount usage

---

## Python Data Processing

Python (Pandas) is used for preprocessing and exploratory analysis.

### Steps Performed
- Handling missing values using median per category
- Standardizing column names
- Feature engineering:
  - Age group creation using quantiles
  - Purchase frequency conversion to days
- Encoding categorical mappings
- Removing redundant columns
- Exporting cleaned dataset to CSV

---

## Technologies Used

- SQL Server
- T-SQL (Views, Stored Procedures, Window Functions)
- Python (Pandas)
- Data Warehousing Concepts
- ETL / ELT Pipelines
- Star Schema Design

---

## Project Structure
```CustomerBehaviorProject/
│
├── sql/
│ ├── bronze.sql
│ ├── silver.sql
│ ├── gold.sql
│ └── reports.sql
│
├── etl/
│ └── data_cleaning.py
│
├── data/
│ └── customer_shopping_behavior.csv
│
└── README.md
```

---

## How to Run

1. Create database

CREATE DATABASE CustomerBehavior;

2. Create schemas
- bronze
- silver
- gold

3. Load bronze layer

EXEC bronze.load_bronze;

4. Load silver layer

EXEC silver.load_silver;

5. Build gold layer
Run all SQL view scripts

6. Run analytics
Query gold.reports_* views

## Key Insights

- Revenue differs across age groups
- Discount usage increases purchase activity
- Subscription customers show higher retention
- Product performance varies by category

## Future Improvements

- Add Power BI dashboard layer
- Implement incremental loading (CDC)
- Add data quality checks
- Automate pipeline with Airflow
- Add Customer Lifetime Value (CLV) analysis