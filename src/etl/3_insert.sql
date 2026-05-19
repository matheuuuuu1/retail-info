-- 1. CARGA DE CLIENTES
INSERT INTO CUSTOMER (customer_id, customer_gender, customer_age_group, customer_segment, region)
SELECT DISTINCT ON (customer_id)
    substring(customer_id from '[0-9]+')::INTEGER,
    customer_gender,
    customer_age_group,
    customer_segment,
    region
FROM crudo
WHERE customer_id IS NOT NULL
ORDER BY customer_id, transaction_date DESC;

-- 2. CARGA DE PRODUCTO
INSERT INTO PRODUCT (product_id, product_name, unit_price, category, brand)
SELECT DISTINCT
    substring(product_id from '[0-9]+')::INTEGER,
    product_name,
    unit_price,
    category,
    brand
FROM crudo
WHERE product_id IS NOT NULL;

-- 3. CARGA DE TRANSACCIONES
INSERT INTO TRANSACTIONS (transaction_id, customer_id, transaction_date, payment_method, sales_channel)
SELECT DISTINCT ON (transaction_id)
    substring(transaction_id from '[0-9]+')::INTEGER,
    substring(customer_id from '[0-9]+')::INTEGER,
    transaction_date,
    payment_method,
    sales_channel
FROM crudo
WHERE transaction_id IS NOT NULL
ORDER BY transaction_id, transaction_date DESC;

-- 4. CARGA DE VENTAS
INSERT INTO SALE (transaction_id, product_id, quantity, discount_pct, sales_amount)
SELECT
    substring(transaction_id from '[0-9]+')::INTEGER,
    substring(product_id from '[0-9]+')::INTEGER,
    quantity,
    discount_pct,
    sales_amount
FROM crudo
WHERE transaction_id IS NOT NULL;