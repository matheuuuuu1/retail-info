CREATE DATABASE IF NOT EXISTS ecommerce_orders;
USE ecommerce_orders;

-- 1. Tabla Raw/Staging
DROP TABLE IF EXISTS raw_data;

CREATE TABLE raw_data (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    year SMALLINT,
    month TINYINT,
    day TINYINT,
    day_of_week VARCHAR(10),
    quarter TINYINT,
    customer_age TINYINT,
    customer_gender VARCHAR(15),
    country VARCHAR(50),
    city VARCHAR(50),
    customer_segment VARCHAR(20),
    product_id VARCHAR(50) NOT NULL,
    product_category VARCHAR(50),
    product_subcategory VARCHAR(50),
    brand VARCHAR(50),
    unit_price DECIMAL(10, 2),
    quantity INT,
    discount_percent DECIMAL(5, 2),
    discount_amount DECIMAL(10, 2),
    coupon_used VARCHAR(5) DEFAULT 'No',
    shipping_cost DECIMAL(10, 2),
    tax_amount DECIMAL(10, 2),
    order_amount DECIMAL(10, 2),
    payment_method VARCHAR(20),
    device_type VARCHAR(20),
    traffic_source VARCHAR(50),
    membership_status VARCHAR(20),
    shipping_method VARCHAR(20),
    warehouse_region VARCHAR(50),
    delivery_days INT,
    order_status VARCHAR(20),
    returned VARCHAR(5) DEFAULT 'No',
    review_rating TINYINT,
    customer_lifetime_value DECIMAL(10, 2),
    profit_margin_percent DECIMAL(5, 2),
    profit_amount DECIMAL(10, 2),
    season VARCHAR(20),
    holiday_season VARCHAR(5) DEFAULT 'No',
    high_value_order VARCHAR(5) DEFAULT 'No',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id),
    INDEX idx_order_date (order_date),
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Inserción desde CSV (Sintaxis Estándar para MariaDB)
-- NOTA: Si usas DBeaver/DataGrip, utiliza el asistente de importación GUI apuntando a 'raw_data'.
-- Si usas CLI de MariaDB, activa local_infile y usa la siguiente consulta:

LOAD DATA LOCAL INFILE '/home/matheus/Git/retail-info/data/raw/ecommerce_orders_dataset.csv'
INTO TABLE raw_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

USE ecommerce_orders;