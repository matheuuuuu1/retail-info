DROP TABLE IF EXISTS SALE;
DROP TABLE IF EXISTS TRANSACTIONS;
DROP TABLE IF EXISTS PRODUCT;
DROP TABLE IF EXISTS CUSTOMER;

CREATE TABLE CUSTOMER (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_gender VARCHAR(20),
    customer_age_group VARCHAR(50),
    customer_segment VARCHAR(50),
    region VARCHAR(100)
);

CREATE TABLE PRODUCT (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(250),
    unit_price NUMERIC(10, 2),
    category VARCHAR(100),
    brand VARCHAR(100)
);

CREATE TABLE TRANSACTIONS (
    transaction_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) REFERENCES CUSTOMER(customer_id),
    transaction_date DATE,
    payment_method VARCHAR(50),
    sales_channel VARCHAR(50)
);

CREATE TABLE SALE (
    transaction_id VARCHAR(50) REFERENCES TRANSACTIONS(transaction_id),
    product_id VARCHAR(50) REFERENCES PRODUCT(product_id),
    quantity INT,
    discount_pct NUMERIC(5, 2),
    sales_amount NUMERIC(10, 2),
    PRIMARY KEY (transaction_id, product_id) -- Llave primaria compuesta
);

-- Wrangling SQL Script for Retail Data Warehouse
-- Cambiar los IDs a números y sus columnas a numéricas después que estén en sus tablas. Cambiar brands por sus nombres
-- Crear sales_amount interactivo
-- Convertir date a date
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