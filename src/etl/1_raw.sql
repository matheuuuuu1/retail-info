-- Creo la tabla principal donde entrará el CSV
DROP TABLE IF EXISTS crudo;
CREATE TABLE crudo
(
    transaction_id VARCHAR PRIMARY KEY,
    transaction_date DATE,
    customer_id VARCHAR,
    customer_gender VARCHAR(10),
    customer_age_group VARCHAR(20),
    customer_segment VARCHAR(20),
    product_id VARCHAR,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10, 2),
    discount_pct DECIMAL(5, 2),
    sales_amount DECIMAL(10, 2),
    payment_method VARCHAR(20),
    sales_channel VARCHAR(20),
    region VARCHAR(50)
);
-- Inserto el CSV
COPY crudo
FROM 'C:/Git/Retail/data/raw/retail_sales_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');