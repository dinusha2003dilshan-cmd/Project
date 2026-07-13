-- =====================================================================
-- Smart Boys' Fashion Shop & Management System
-- Database Schema (MS SQL Server Migration)
-- =====================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'smartboysdb')
BEGIN
  CREATE DATABASE smartboysdb;
END
GO

USE smartboysdb;
GO

-- -------------------------------------------------------------------
-- CATEGORIES
-- -------------------------------------------------------------------
IF OBJECT_ID('categories', 'U') IS NOT NULL DROP TABLE categories;
CREATE TABLE categories (
    category_id     INT IDENTITY(1,1) PRIMARY KEY,
    category_name   VARCHAR(60)  NOT NULL UNIQUE,
    description     VARCHAR(255)
);

-- -------------------------------------------------------------------
-- PRODUCTS
-- -------------------------------------------------------------------
IF OBJECT_ID('products', 'U') IS NOT NULL DROP TABLE products;
CREATE TABLE products (
    product_id      INT IDENTITY(1,1) PRIMARY KEY,
    category_id     INT NOT NULL,
    product_name    VARCHAR(120) NOT NULL,
    description     NVARCHAR(MAX),
    price           DECIMAL(10,2) NOT NULL,
    color           VARCHAR(40),
    size_label      VARCHAR(20)  NOT NULL,
    min_age         INT NOT NULL,
    max_age         INT NOT NULL,
    stock_qty       INT NOT NULL DEFAULT 0,
    low_stock_limit INT NOT NULL DEFAULT 5,
    image_path      VARCHAR(255),
    is_active       BIT NOT NULL DEFAULT 1,
    created_at      DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

IF OBJECT_ID('product_images', 'U') IS NOT NULL DROP TABLE product_images;
CREATE TABLE product_images (
    image_id        INT IDENTITY(1,1) PRIMARY KEY,
    product_id      INT NOT NULL,
    image_path      VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- -------------------------------------------------------------------
-- SIZE CHART
-- -------------------------------------------------------------------
IF OBJECT_ID('size_chart', 'U') IS NOT NULL DROP TABLE size_chart;
CREATE TABLE size_chart (
    size_id     INT IDENTITY(1,1) PRIMARY KEY,
    size_label  VARCHAR(20) NOT NULL,
    min_age     INT NOT NULL,
    max_age     INT NOT NULL,
    min_height  INT NOT NULL,
    max_height  INT NOT NULL,
    min_weight  INT NOT NULL,
    max_weight  INT NOT NULL
);

-- -------------------------------------------------------------------
-- CUSTOMERS
-- -------------------------------------------------------------------
IF OBJECT_ID('customers', 'U') IS NOT NULL DROP TABLE customers;
CREATE TABLE customers (
    customer_id     INT IDENTITY(1,1) PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(120) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    phone           VARCHAR(20),
    address         VARCHAR(255),
    created_at      DATETIME DEFAULT GETDATE()
);

-- -------------------------------------------------------------------
-- ADMINS
-- -------------------------------------------------------------------
IF OBJECT_ID('admins', 'U') IS NOT NULL DROP TABLE admins;
CREATE TABLE admins (
    admin_id        INT IDENTITY(1,1) PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(120) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    role            VARCHAR(20) NOT NULL DEFAULT 'MANAGER' CHECK (role IN ('OWNER','MANAGER','WAREHOUSE')),
    created_at      DATETIME DEFAULT GETDATE()
);

-- -------------------------------------------------------------------
-- ORDERS
-- -------------------------------------------------------------------
IF OBJECT_ID('orders', 'U') IS NOT NULL DROP TABLE orders;
CREATE TABLE orders (
    order_id        INT IDENTITY(1,1) PRIMARY KEY,
    customer_id     INT NOT NULL,
    order_date      DATETIME DEFAULT GETDATE(),
    status          VARCHAR(20) NOT NULL DEFAULT 'PROCESSING' CHECK (status IN ('PROCESSING','SHIPPED','DELIVERED','CANCELLED')),
    shipping_address VARCHAR(255) NOT NULL,
    subtotal        DECIMAL(10,2) NOT NULL,
    shipping_fee    DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount    DECIMAL(10,2) NOT NULL,
    payment_method  VARCHAR(40) DEFAULT 'COD',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

IF OBJECT_ID('order_items', 'U') IS NOT NULL DROP TABLE order_items;
CREATE TABLE order_items (
    order_item_id   INT IDENTITY(1,1) PRIMARY KEY,
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    line_total      DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- -------------------------------------------------------------------
-- WISHLIST
-- -------------------------------------------------------------------
IF OBJECT_ID('wishlist', 'U') IS NOT NULL DROP TABLE wishlist;
CREATE TABLE wishlist (
    wishlist_id     INT IDENTITY(1,1) PRIMARY KEY,
    customer_id     INT NOT NULL,
    product_id      INT NOT NULL,
    added_at        DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    CONSTRAINT uq_wishlist UNIQUE (customer_id, product_id)
);

-- =====================================================================
-- SEED DATA
-- =====================================================================

INSERT INTO categories (category_name, description) VALUES
('Casual', 'Everyday casual wear for boys'),
('Formal', 'Formal shirts, trousers and suits'),
('Ethnic', 'Traditional and cultural wear'),
('Sportswear', 'Active and sports clothing');

INSERT INTO size_chart (size_label, min_age, max_age, min_height, max_height, min_weight, max_weight) VALUES
('18', 1, 2, 75, 86, 9, 12),
('20', 2, 3, 87, 96, 12, 14),
('22', 3, 4, 97, 104, 14, 16),
('24', 4, 5, 105, 110, 16, 18),
('26', 5, 6, 111, 116, 18, 20),
('28', 6, 7, 117, 122, 20, 23),
('30', 7, 8, 123, 128, 23, 26),
('32', 8, 9, 129, 134, 26, 29),
('34', 9, 10, 135, 140, 29, 33),
('36', 10, 12, 141, 152, 33, 40),
('S',  12, 14, 153, 160, 40, 48),
('M',  14, 16, 161, 168, 48, 56);

INSERT INTO products (category_id, product_name, description, price, color, size_label, min_age, max_age, stock_qty, low_stock_limit, image_path) VALUES
(1, 'Boys Casual Cotton T-Shirt', 'Soft breathable cotton t-shirt for daily wear', 1250.00, 'Blue', '24', 4, 5, 25, 5, 'images/products/tshirt_blue.jpg'),
(1, 'Denim Shorts', 'Durable denim shorts, adjustable waist', 1800.00, 'Denim', '26', 5, 6, 4, 5, 'images/products/shorts_denim.jpg'),
(2, 'Formal White Shirt', 'Slim-fit formal shirt for events', 2200.00, 'White', '30', 7, 8, 15, 5, 'images/products/shirt_white.jpg'),
(2, 'Formal Trouser', 'Classic tailored trouser', 2500.00, 'Black', '32', 8, 9, 3, 5, 'images/products/trouser_black.jpg'),
(3, 'Traditional Kurtha Set', 'Festive ethnic kurtha with pants', 3200.00, 'Maroon', '28', 6, 7, 10, 5, 'images/products/kurtha_maroon.jpg'),
(4, 'Sports Jersey', 'Moisture-wicking sports jersey', 1600.00, 'Red', '34', 9, 10, 18, 5, 'images/products/jersey_red.jpg'),
(4, 'Track Pants', 'Elastic waist track pants for sports', 1450.00, 'Grey', '36', 10, 12, 2, 5, 'images/products/track_grey.jpg'),
(1, 'Graphic Hoodie', 'Warm printed hoodie', 2800.00, 'Navy', 'S', 12, 14, 12, 5, 'images/products/hoodie_navy.jpg');

-- Default OWNER / MANAGER admin accounts. Password = "admin123" for both.
INSERT INTO admins (full_name, email, password_hash, role) VALUES
('System Owner', 'owner@smartboys.lk', '$2a$12$adMoIq.1/Dul5/y.PmdUGutovp8FFfqhVC.pIHXVSJ7xKlQ6qjuwO', 'OWNER'),
('Shop Manager', 'manager@smartboys.lk', '$2a$12$adMoIq.1/Dul5/y.PmdUGutovp8FFfqhVC.pIHXVSJ7xKlQ6qjuwO', 'MANAGER');

-- Sample customer login. Password = "customer123".
INSERT INTO customers (full_name, email, password_hash, phone, address) VALUES
('Test Parent', 'parent@example.com', '$2a$12$NYmLj.wRIk5cpM4Bba7Lq.JT09zX/LmH7X0KSWUYGU32MmFx06VNm', '0771234567', 'No 12, Galle Road, Colombo');
