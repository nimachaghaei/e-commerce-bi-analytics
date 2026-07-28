WITH MonthlyRevenue AS (
    SELECT 
        YEAR(o.order_purchase_timestamp) AS purchase_year,
        MONTH(o.order_purchase_timestamp) AS purchase_month,
        SUM(i.price) AS total_revenue
    FROM dbo.olist_orders_dataset AS o
    INNER JOIN dbo.olist_order_items_dataset AS i 
        ON o.order_id = i.order_id
    WHERE o.order_status = 'delivered' 
    GROUP BY 
        YEAR(o.order_purchase_timestamp), 
        MONTH(o.order_purchase_timestamp)
),
RevenueWithLag AS (
    SELECT 
        purchase_year,
        purchase_month,
        total_revenue,
        LAG(total_revenue, 1) OVER (ORDER BY purchase_year, purchase_month) AS prev_revenue
    FROM MonthlyRevenue
)
SELECT 
    purchase_year,
    purchase_month,
    total_revenue,
    prev_revenue,
    CAST(
        (total_revenue - prev_revenue) * 100.0 / NULLIF(prev_revenue, 0) 
        AS DECIMAL(5,2)
    ) AS mom_growth_percentage
FROM RevenueWithLag
ORDER BY purchase_year, purchase_month;