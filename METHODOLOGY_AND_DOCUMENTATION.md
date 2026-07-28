# Comprehensive Technical Methodology & Analytics Documentation

This document details the analytical methodologies, SQL transformations, DAX engine design, and operational findings for the E-Commerce BI Analytics suite.

---

## 1. Core Business Questions & Findings

| # | Domain | Business Question | Analytical Approach | Operational Finding |
|---|---|---|---|---|
| **1** | **Customer Retention** | Is customer churn driven by uncompetitive pricing or post-purchase friction? | RFM Quantile Segmentation & cohort AOV comparison. | Lost customers spent **$142 AOV** vs **$144 AOV** for active users. Churn is caused by operational/shipping friction, not price sensitivity. |
| **2** | **Logistics & CSAT** | At what exact delay threshold does shipping performance destroy customer satisfaction? | Evaluated transit delay days against review distributions (`03_vw_delivery_performance`). | Transit delays exceeding **7 days** cause average rating scores to crash from **4.21 to < 2.1 stars**. |
| **3** | **Vendor Risk** | How concentrated is overall platform revenue across the merchant base? | Built dynamic Pareto distribution models in DAX. | **Top 20% of sellers** control **82.50% of net revenue** (619 of 3,095 sellers), creating single-point merchant dependency. |
| **4** | **Payment Dynamics** | How do payment installment structures impact transaction volume? | Aggregated payment methods and installment counts (`04_vw_order_payment_summary`). | Installment plans account for **>63% of transaction volume**, directly driving higher order values in premium categories. |

---

## 2. RFM Segmentation Engine Architecture

To model churn risk, customers were evaluated on **Recency**, **Frequency**, and **Monetary** metrics using `customer_unique_id` (accounting for repeat buyers across different order IDs).

### A. Metric Definitions
1. **Recency ($R$):** Days elapsed between the snapshot reference date ($T_{max}$) and the customer's most recent order purchase timestamp.
2. **Frequency ($F$):** Total count of distinct delivered orders executed by the unique customer profile.
3. **Monetary ($M$):** Cumulative sum of item prices and freight values incurred by the unique customer profile.

### B. Quantile Scoring & Segment Mapping Logic
Metrics were converted into 1–5 scoring buckets ($1 = \text{Lowest}$, $5 = \text{Highest}$) and grouped into strategic customer segments:

* **Champions ($R \ge 4, F \ge 4, M \ge 4$):** High-value, frequent, and recently active buyers.
* **Loyal Customers ($R \ge 3, F \ge 3$):** Consistent purchasing history over time.
* **At Risk ($R \le 2, F \ge 3, M \ge 3$):** Formerly high-value buyers showing long periods of inactivity.
* **Lost / Churned ($R = 1, F \le 2, M \le 2$):** Single or low-frequency purchasers with no activity over $300+$ days.

### C. Key Finding: Monetary Neutrality in Churned Users
* **Active Cohort AOV:** $144.12
* **Lost Cohort AOV:** $142.85
* **Conclusion:** Price sensitivity is **not** the cause of churn. Customer drop-off correlates directly with shipping delays and SLA breaches documented in the logistics analysis.

---

## 3. SQL Pipeline Engineering & Transformation Logic

T-SQL views were built to normalize raw datasets, enforce consistent schema naming (`olist_` prefixes), resolve column typos, and pre-aggregate transactional metrics.

### A. Month-over-Month Revenue Growth (`01_mom_revenue_growth.sql`)
Prevents division-by-zero errors using `NULLIF()` when evaluating baseline periods:
```sql
SELECT 
    year_month,
    total_revenue,
    prev_revenue,
    CAST(
        (total_revenue - prev_revenue) * 100.0 / NULLIF(prev_revenue, 0) 
        AS DECIMAL(5,2)
    ) AS mom_growth_percentage
FROM MoM_Calculation;
