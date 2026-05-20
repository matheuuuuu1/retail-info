CREATE VIEW vista_reporte_total AS
SELECT 
    t.transaction_id,
    t.transaction_date,
    t.payment_method,
    t.sales_channel,
    c.customer_id,
    c.customer_gender,
    c.customer_age_group,
    c.customer_segment,
    c.region,
    p.product_id,
    p.product_name,
    p.unit_price,
    p.category,
    p.brand,
    s.quantity,
    s.discount_pct,
    s.sales_amount
FROM SALE AS s
JOIN TRANSACTIONS AS t ON s.transaction_id = t.transaction_id
JOIN CUSTOMER AS c ON t.customer_id = c.customer_id
JOIN PRODUCT AS p ON s.product_id = p.product_id;
