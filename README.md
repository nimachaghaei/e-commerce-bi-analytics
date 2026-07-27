# E-Commerce Revenue & Operational Intelligence Suite

[![Power BI](https://img.shields.io/badge/Power_BI-F2C94C?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/T--SQL-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![DAX](https://img.shields.io/badge/DAX-Data_Modeling-0078D4?style=for-the-badge)](https://learn.microsoft.com/power-bi/transform-model/)

An end-to-end business intelligence suite analyzing **$15.42M in net revenue** and **96K unique customer records** from a Brazilian e-commerce platform. This project transforms raw relational tables into an executive-level Power BI dashboard supported by production-grade SQL views, dynamic DAX modeling, and rigorous SLA tracking.

> ⚠️ **Database Schema & Naming Warning:**  
> If you are replicating this environment or executing these scripts on raw Olist database files, **verify your target schema first**. 

---

## 📌 Executive Summary & Key Results

Rather than simple static reporting, this solution diagnoses core operational bottlenecks and connects them directly to revenue impact and customer churn:

* **$6.17M Revenue at Risk (RFM Churn Analysis):** Built an RFM segmentation model identifying 37K "Lost" customers who share an Average Order Value ($142) nearly identical to active users ($144)—proving platform churn stems from post-purchase friction, not pricing sensitivity.
* **Extreme Vendor Risk (Pareto Distribution):** Engineered dynamic DAX calculations confirming that **82.50% of platform revenue** is controlled by just **20% of active sellers** (619 of 3,095).
* **Logistics SLA Failure Tipping Point:** Mapped delivery delays against customer review scores, proving that transit delays exceeding **7 days** cause CSAT ratings to collapse from a **4.21 baseline to below 2.1 stars**.

---

## 🏗️ System & Repository Architecture

```text
================================================================================
1. REPOSITORY STRUCTURE (File Layout)
================================================================================
e-commerce-bi-analytics/
├── .gitignore                           # OS & Power BI lock file exclusions
├── README.md                            # Executive project overview & quick start
├── METHODOLOGY_AND_DOCUMENTATION.md     # Technical deep-dive, SQL fixes, & DAX logic
├── sql_queries/
│   ├── 01_mom_revenue_growth.sql        # Month-over-Month revenue & growth % script
│   ├── 02_vw_revenue_by_category.sql    # Category performance & translation handling
│   ├── 03_vw_delivery_performance.sql   # SLA breach & order freight aggregation view
│   ├── 04_vw_order_payment_summary.sql  # Payment classification view (Cash vs Installments)
│   └── 05_vw_state_delivery_summary.sql # Regional SLA failure matrix view
├── dashboard/
│   ├── e_commerce_analytics.pbix        # Interactive Power BI report source
│   └── e_commerce_analytics_export.pdf # High-resolution executive PDF export
└── images/
    ├── page1_revenue.png                # Preview screenshot: Revenue Overview
    └── page2_insights.png               # Preview screenshot: Operational Insights


================================================================================
2. DATA PIPELINE FLOW (Technical Process)
================================================================================
[ Raw Relational Database ]
         │
         ▼
[ T-SQL Views & Pipeline Scripts ] ──► Data Cleaning, NULL Handling, Schema Normalization
         │
         ▼
[ Power BI Data Model ]            ──► Star Schema, Dynamic DAX Measures, Filter Controls
         │
         ▼
[ Executive BI Suite ]             ──► Cross-Filtering, Top N Rules, SLA Tooltips
