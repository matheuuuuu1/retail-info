USE ecommerce_orders;

-- Eliminar tablas en orden inverso si ya existían
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- 1. Tabla de Clientes
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_age TINYINT,
    customer_gender VARCHAR(15),
    country VARCHAR(50),
    city VARCHAR(50),
    customer_segment VARCHAR(20),
    membership_status VARCHAR(20),
    customer_lifetime_value DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO customers (
    customer_id, 
    customer_age, 
    customer_gender, 
    country, 
    city, 
    customer_segment, 
    membership_status, 
    customer_lifetime_value
)
SELECT 
    TRIM(customer_id) AS customer_id,
    MAX(customer_age),
    UPPER(TRIM(MAX(customer_gender))),
    UPPER(TRIM(MAX(country))),
    TRIM(MAX(city)),
    COALESCE(TRIM(MAX(customer_segment)), 'Unassigned'),
    COALESCE(TRIM(MAX(membership_status)), 'Standard'),
    MAX(customer_lifetime_value)
FROM raw_data
WHERE customer_id IS NOT NULL AND TRIM(customer_id) != ''
GROUP BY TRIM(customer_id);

-- 2. Tabla de Productos
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category VARCHAR(50),
    product_subcategory VARCHAR(50),
    brand VARCHAR(50),
    unit_price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO products (
    product_id, 
    product_category, 
    product_subcategory, 
    brand, 
    unit_price
)
SELECT 
    TRIM(product_id) AS product_id,
    COALESCE(TRIM(MAX(product_category)), 'General'),
    COALESCE(TRIM(MAX(product_subcategory)), 'General'),
    COALESCE(TRIM(MAX(brand)), 'Generic'),
    MAX(unit_price)
FROM raw_data
WHERE product_id IS NOT NULL AND TRIM(product_id) != ''
GROUP BY TRIM(product_id);

-- 3. Tabla Transaccional de Órdenes
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(10, 2),
    discount_percent DECIMAL(5, 2) DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    shipping_cost DECIMAL(10, 2) DEFAULT 0.00,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    order_amount DECIMAL(10, 2),
    profit_amount DECIMAL(10, 2),
    payment_method VARCHAR(20),
    device_type VARCHAR(20),
    traffic_source VARCHAR(50),
    shipping_method VARCHAR(20),
    warehouse_region VARCHAR(50),
    delivery_days INT,
    order_status VARCHAR(20),
    coupon_used TINYINT(1) DEFAULT 0,
    returned TINYINT(1) DEFAULT 0,
    review_rating TINYINT,
    season VARCHAR(20),
    holiday_season TINYINT(1) DEFAULT 0,
    high_value_order TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    INDEX idx_order_date (order_date),
    INDEX idx_customer_order (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO orders (
    order_id, customer_id, product_id, order_date, quantity, unit_price,
    discount_percent, discount_amount, shipping_cost, tax_amount, order_amount,
    profit_amount, payment_method, device_type, traffic_source, shipping_method,
    warehouse_region, delivery_days, order_status, coupon_used, returned,
    review_rating, season, holiday_season, high_value_order
)
SELECT 
    TRIM(ro.order_id),
    TRIM(ro.customer_id),
    TRIM(ro.product_id),
    ro.order_date,
    GREATEST(COALESCE(ro.quantity, 1), 1),
    ro.unit_price,
    COALESCE(ro.discount_percent, 0.00),
    COALESCE(ro.discount_amount, 0.00),
    COALESCE(ro.shipping_cost, 0.00),
    COALESCE(ro.tax_amount, 0.00),
    ro.order_amount,
    ro.profit_amount,
    COALESCE(TRIM(ro.payment_method), 'Unknown'),
    COALESCE(TRIM(ro.device_type), 'Unknown'),
    COALESCE(TRIM(ro.traffic_source), 'Direct'),
    COALESCE(TRIM(ro.shipping_method), 'Standard'),
    COALESCE(TRIM(ro.warehouse_region), 'Unassigned'),
    ro.delivery_days,
    COALESCE(TRIM(ro.order_status), 'Completed'),
    CASE WHEN TRIM(ro.coupon_used) = 'Yes' THEN 1 ELSE 0 END,
    CASE WHEN TRIM(ro.returned) = 'Yes' THEN 1 ELSE 0 END,
    ro.review_rating,
    COALESCE(TRIM(ro.season), 'N/A'),
    CASE WHEN TRIM(ro.holiday_season) = 'Yes' THEN 1 ELSE 0 END,
    CASE WHEN TRIM(ro.high_value_order) = 'Yes' THEN 1 ELSE 0 END
FROM raw_data ro
INNER JOIN customers c ON TRIM(ro.customer_id) = c.customer_id
INNER JOIN products p ON TRIM(ro.product_id) = p.product_id
WHERE ro.order_id IS NOT NULL AND TRIM(ro.order_id) != '';