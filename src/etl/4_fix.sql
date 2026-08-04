USE ecommerce_orders;

-- 1. Vista Base Unificada para Consumo desde Python
CREATE OR REPLACE VIEW vw_orders_ml_base AS
SELECT 
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_age,
    c.customer_gender,
    c.country,
    c.city,
    c.customer_segment,
    c.membership_status,
    p.product_id,
    p.product_category,
    p.product_subcategory,
    p.brand,
    o.quantity,
    o.unit_price,
    o.discount_amount,
    o.shipping_cost,
    o.order_amount,
    o.profit_amount,
    o.payment_method,
    o.device_type,
    o.traffic_source,
    o.order_status,
    o.coupon_used,
    o.returned,
    o.review_rating
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id;

-- 2. Resumen Ejecutivo (KPIs Globales)
CREATE OR REPLACE VIEW vw_kpi_global_summary AS
SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    SUM(o.quantity) AS total_units_sold,
    SUM(o.order_amount) AS total_revenue,
    SUM(o.profit_amount) AS total_profit,
    ROUND(AVG(o.order_amount), 2) AS average_order_value_aov,
    ROUND((SUM(o.profit_amount) / SUM(o.order_amount)) * 100, 2) AS overall_profit_margin_pct,
    ROUND((SUM(CASE WHEN o.returned = 1 THEN 1 ELSE 0 END) / COUNT(o.order_id)) * 100, 2) AS return_rate_pct,
    ROUND((SUM(CASE WHEN o.coupon_used = 1 THEN 1 ELSE 0 END) / COUNT(o.order_id)) * 100, 2) AS coupon_usage_pct
FROM orders o;

-- 3. Agregaciones por Cliente (Para RFM y K-Means)
CREATE OR REPLACE VIEW vw_customer_aggregations AS
SELECT 
    c.customer_id,
    c.customer_age,
    c.customer_gender,
    c.country,
    c.city,
    c.customer_segment,
    c.membership_status,
    COUNT(o.order_id) AS total_orders_count,
    SUM(o.quantity) AS total_items_purchased,
    SUM(o.order_amount) AS total_spend_lifetime,
    SUM(o.profit_amount) AS total_profit_generated,
    ROUND(AVG(o.order_amount), 2) AS avg_ticket_size,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF((SELECT MAX(order_date) FROM orders), MAX(o.order_date)) AS days_since_last_order,
    SUM(CASE WHEN o.returned = 1 THEN 1 ELSE 0 END) AS total_returned_orders,
    ROUND(AVG(o.review_rating), 1) AS avg_review_given
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.customer_age, c.customer_gender, 
    c.country, c.city, c.customer_segment, c.membership_status;

-- 4. Rendimiento por Producto/Categoría
CREATE OR REPLACE VIEW vw_product_performance AS
SELECT 
    p.product_category,
    p.product_subcategory,
    p.brand,
    COUNT(DISTINCT p.product_id) AS total_skus,
    COUNT(DISTINCT o.order_id) AS orders_count,
    SUM(o.quantity) AS units_sold,
    SUM(o.order_amount) AS total_sales,
    SUM(o.profit_amount) AS total_profit,
    ROUND((SUM(o.profit_amount) / SUM(o.order_amount)) * 100, 2) AS profit_margin_pct,
    ROUND(AVG(o.discount_amount), 2) AS avg_discount_applied,
    SUM(CASE WHEN o.returned = 1 THEN 1 ELSE 0 END) AS units_returned,
    ROUND((SUM(CASE WHEN o.returned = 1 THEN 1 ELSE 0 END) / COUNT(o.order_id)) * 100, 2) AS return_rate_pct
FROM products p
INNER JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_category, p.product_subcategory, p.brand;

-- 5. Ventas Mensuales por Canal de Tráfico y Dispositivo
CREATE OR REPLACE VIEW vw_monthly_sales_channels AS
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_year_month,
    YEAR(o.order_date) AS year_num,
    MONTH(o.order_date) AS month_num,
    o.payment_method,
    o.device_type,
    o.traffic_source,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS monthly_revenue,
    SUM(o.profit_amount) AS monthly_profit,
    ROUND(AVG(o.delivery_days), 1) AS avg_delivery_days
FROM orders o
GROUP BY 
    DATE_FORMAT(o.order_date, '%Y-%m'),
    YEAR(o.order_date),
    MONTH(o.order_date),
    o.payment_method,
    o.device_type,
    o.traffic_source;