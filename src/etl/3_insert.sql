INSERT INTO CUSTOMER
SELECT DISTINCT
    customer_id,
    customer_gender,
    customer_age_group,
    customer_segment,
    region
FROM crudo
WHERE customer_id IS NOT NULL;

INSERT INTO PRODUCT
SELECT DISTINCT
    product_id,
    product_name,
    unit_price,
    category,
    brand
FROM crudo
WHERE product_id IS NOT NULL;

INSERT INTO TRANSACTIONS
SELECT DISTINCT
    transaction_id,
    customer_id,
    transaction_date,
    payment_method,
    sales_channel
FROM crudo
WHERE transaction_id IS NOT NULL;

INSERT INTO SALE
SELECT
    transaction_id,
    product_id,
    quantity,
    discount_pct,
    sales_amount
FROM crudo
WHERE transaction_id IS NOT NULL;