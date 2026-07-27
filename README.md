# E-Commerce Revenue & Operational Intelligence Suite

[![Power BI](https://img.shields.io/badge/Power_BI-F2C94C?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/T--SQL-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![DAX](https://img.shields.io/badge/DAX-Data_Modeling-0078D4?style=for-the-badge)](https://learn.microsoft.com/power-bi/transform-model/)

An end-to-end business intelligence pipeline analyzing **$15.42M in net revenue** across **96K customer records** from the Olist Brazilian E-Commerce dataset. 

This repository pairs raw SQL data transformations with an interactive Power BI dashboard to connect fulfillment delays directly to churn and lost revenue.

> ⚠️ **Database Schema & Table Naming Warning:**  
> I renamed several source tables in this repository to standardize the schema (e.g., removing raw prefixes and converting names to English). If you are executing the scripts in `/sql_queries` directly against the raw Olist database files, you will need to either rename your database tables to match or update the table aliases in the SQL scripts. See `METHODOLOGY_AND_DOCUMENTATION.md` for the exact mapping.
---

## 📌 Executive Summary & Operational Findings

Rather than building standard revenue charts, this project isolates key fulfillment bottlenecks and measures their financial cost:

* **$6.17M Churn Risk (RFM Analysis):** RFM segmentation identified 37K churned customers. Notably, churned users have an Average Order Value ($142) nearly identical to active users ($144)—confirming that churn is driven by post-purchase fulfillment friction, not pricing sensitivity.
* **Seller Concentration Risk (Pareto Analysis):** Dynamic DAX modeling confirmed an extreme Pareto split: **82.50% of total revenue** relies on just **20% of active sellers** (619 out of 3,095).
* **The 7-Day Logistics Cliff:** Mapping shipping delays against customer review scores showed a sharp tipping point: shipping delays past **7 days** cause CSAT ratings to collapse from a **4.21 baseline to under 2.1 stars**.

---

## 🛠️ Technical Implementation Highlights

* **SQL Aggregations over DAX:** Pre-calculated month-over-month growth, state SLA rates, and payment methods inside SQL Server views to keep the Power BI model lightweight and performant.
* **Handling Delivery Edge Cases:** Built specific SQL logic to handle missing `order_delivered_customer_date` entries, preventing broken SLA metrics on canceled and in-transit orders.
* **Dynamic Pareto DAX:** Built dynamic ranking measures to allow real-time filtering of top sellers across custom date ranges and product categories.

---

## 🏗️ Repository Architecture & Data Flow

```text
================================================================================
1. REPOSITORY STRUCTURE 
================================================================================
e-commerce-bi-analytics/
├── .gitignore                         # OS & Power BI lock file exclusions
├── README.md                          # Executive project overview & quick start
├── METHODOLOGY_AND_DOCUMENTATION.md    # Schema mapping, SQL logic, & DAX formulas
├── sql_queries/
│   ├── 01_mom_revenue_growth.sql        # Month-over-Month revenue & growth %
│   ├── 02_vw_revenue_by_category.sql    # Category performance & translation handling
│   ├── 03_vw_delivery_performance.sql   # SLA breaches & shipping cost aggregations
│   ├── 04_vw_order_payment_summary.sql  # Payment split (Credit, Boleto, Installments)
│   └── 05_vw_state_delivery_summary.sql # Regional SLA failure matrix
├── dashboard/
│   ├── e_commerce_analytics.pbix        # Interactive Power BI dashboard file
│   └── e_commerce_analytics_export.pdf # Executive PDF export
└── images/
    ├── page1_revenue.png                # Dashboard preview: Revenue Overview
    └── page2_insights.png               # Dashboard preview: Operational Bottlenecks


================================================================================
2. DATA PIPELINE FLOW 
================================================================================
[ Raw Relational DB ] ──► [ T-SQL Views ] ──► [ Star Schema Data Model ] ──► [ Power BI Suite ]
(Olist Dataset)           • NULL Handling      • Dynamic DAX Measures        • Cross-Filtering
                          • Translation        • Fact / Dim Tables           • SLA Drift Metrics
                          • Aggregations       • Top N Rules                 • Drill-throughs
