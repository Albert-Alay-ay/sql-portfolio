SELECT 'stg_categories'   AS table_name, COUNT(*) AS row_count FROM stg_categories
UNION ALL
SELECT 'stg_customers',   COUNT(*) FROM stg_customers
UNION ALL
SELECT 'stg_products',    COUNT(*) FROM stg_products
UNION ALL
SELECT 'stg_orders',      COUNT(*) FROM stg_orders
UNION ALL
SELECT 'stg_order_items', COUNT(*) FROM stg_order_items
UNION ALL
SELECT 'stg_payments',    COUNT(*) FROM stg_payments
UNION ALL
SELECT 'stg_reviews',     COUNT(*) FROM stg_reviews
UNION ALL
SELECT 'stg_returns',     COUNT(*) FROM stg_returns
UNION ALL
SELECT 'stg_inventory',   COUNT(*) FROM stg_inventory
ORDER BY table_name;

SELECT
    MIN(order_date)              AS earliest_order,
    MAX(order_date)              AS latest_order,
    COUNT(DISTINCT customer_id)  AS unique_customers,
    SUM(total_amount)            AS total_revenue
FROM stg_orders;