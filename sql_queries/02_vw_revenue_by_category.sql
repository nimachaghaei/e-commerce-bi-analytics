CREATE OR ALTER VIEW dbo.vw_revenue_by_category AS
SELECT 
    ISNULL(t.column2, 'Uncategorized') AS category_name,
    FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS purchase_month,
    SUM(i.price) AS total_revenue
FROM dbo.olist_orders_dataset AS o
LEFT JOIN dbo.olist_order_items_dataset AS i ON o.order_id = i.order_id
LEFT JOIN dbo.olist_products_dataset AS p ON i.product_id = p.product_id
LEFT JOIN dbo.product_category_name_translation AS t ON p.product_category_name = t.column1
WHERE o.order_status = 'delivered'
GROUP BY ISNULL(t.column2, 'Uncategorized'), FORMAT(o.order_purchase_timestamp, 'yyyy-MM');