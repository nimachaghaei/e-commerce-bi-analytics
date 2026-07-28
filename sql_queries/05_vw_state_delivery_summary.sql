CREATE VIEW v_state_delivery_summary AS
SELECT
    customer_state AS [state],
    COUNT(order_id) AS [total_orders],
    SUM(CASE WHEN delayed_delivery = 'yes' THEN 1 ELSE 0 END) AS [delayed_orders],
    
    -- محاسبه درصد تاخیر
    CAST(
        SUM(CASE WHEN delayed_delivery = 'yes' THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(order_id) 
        AS DECIMAL(5,2)
    ) AS [delay_rate_pct],
    
    -- میانگین روزهای دیرکرد (فقط سفارش‌های دیر رسیده)
    CAST(
        AVG(CASE WHEN delay_days > 0 THEN delay_days ELSE NULL END) 
        AS DECIMAL(5,1)
    ) AS [avg_delay_days]

-- فیلترینگ و مرتب سازی
FROM dbo.v_delivery_performance
WHERE order_delivered_customer_date IS NOT NULL 
GROUP BY customer_state
HAVING COUNT(order_id) >= 100;
