CREATE OR ALTER VIEW v_delivery_performance AS
SELECT 
    o.order_id,
    o.customer_id,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    
    
    DATEDIFF(day, o.order_estimated_delivery_date, o.order_delivered_customer_date) AS delay_days,
    
    -- منطق تشخیص تاخیر
    CASE
        WHEN DATEDIFF(day, o.order_estimated_delivery_date, o.order_delivered_customer_date) > 0 THEN 'yes'
        ELSE 'no' 
    END AS delayed_delivery,
    
    -- ایالت مشتری از جدول مشتریان
    c.customer_state,
    
    -- مجموع هزینه پست سفارش 
    ISNULL(i.total_freight_value, 0) AS total_freight_value

FROM dbo.olist_orders_dataset AS o

-- ۱. اتصال به جدول مشتریان برای پیدا کردن ایالت خریدار
LEFT JOIN dbo.customers_dataset AS c 
    ON o.customer_id = c.customer_id

-- ۲. اتصال به زیرکوئریِ تجمیع‌شده‌ی هزینه پست
LEFT JOIN (
    SELECT order_id, SUM(freight_value) AS total_freight_value
    FROM dbo.order_items_dataset
    GROUP BY order_id
) AS i ON o.order_id = i.order_id;