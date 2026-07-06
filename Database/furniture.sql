-- =========================
-- Create Database
-- =========================
DROP DATABASE IF EXISTS furnitureweb;
CREATE DATABASE furnitureweb;
USE furnitureweb;

-- =========================
-- USERS TABLE
-- =========================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash TEXT,
    phone VARCHAR(15),
    role ENUM('CUSTOMER','ADMIN','AGENT') NOT NULL DEFAULT 'CUSTOMER',
    auth_provider ENUM('LOCAL','GOOGLE') NOT NULL DEFAULT 'LOCAL',
    provider_id VARCHAR(255),
    is_verified BOOLEAN DEFAULT FALSE,
    status ENUM('ACTIVE','DEACTIVATED') DEFAULT 'ACTIVE',
    preferred_language VARCHAR(10) DEFAULT 'en',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================
-- LOGIN HISTORY
-- =========================
CREATE TABLE login_history (
    login_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(50),
    device_info TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =========================
-- PASSWORD RESET
-- =========================
CREATE TABLE password_reset (
    reset_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token TEXT NOT NULL,
    expiry_time TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =========================
-- EMAIL VERIFICATION
-- =========================
CREATE TABLE email_verification (
    verification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token TEXT NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    expiry_time TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =========================
-- SUPPORT TICKETS
-- =========================
CREATE TABLE support_tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('OPEN','IN_PROGRESS','RESOLVED','CLOSED') DEFAULT 'OPEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE ticket_replies (
    reply_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    sender_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =========================
-- OFFERS / DISCOUNTS
-- =========================
CREATE TABLE offers (
    offer_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    discount_percentage DECIMAL(5,2) CHECK (discount_percentage BETWEEN 0 AND 100),
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

-- =========================
-- CATEGORIES
-- =========================
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- =========================
-- PRODUCTS
-- =========================
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    material VARCHAR(50),
    color VARCHAR(50),
    dimensions VARCHAR(100),
    weight DECIMAL(10,2),
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- =========================
-- PRODUCT IMAGES
-- =========================
CREATE TABLE product_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url TEXT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- =========================
-- PRODUCT OFFERS
-- =========================
CREATE TABLE product_offers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    offer_id INT NOT NULL,
    UNIQUE(product_id, offer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (offer_id) REFERENCES offers(offer_id) ON DELETE CASCADE
);

-- =========================
-- CART
-- =========================
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    UNIQUE(cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- =========================
-- ADDRESSES
-- =========================
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    phone VARCHAR(15) NOT NULL,
    country VARCHAR(50) NOT NULL,
    province VARCHAR(50),
    district VARCHAR(50),
    city VARCHAR(50),
    street VARCHAR(100),
    house_no VARCHAR(20),
    apartment VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =========================
-- ORDERS
-- =========================
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status ENUM('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- =========================
-- PAYMENTS
-- =========================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    status ENUM('SUCCESS','FAILED','PENDING') DEFAULT 'PENDING',
    payment_method VARCHAR(50),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

CREATE TABLE saved_cards (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    card_token TEXT NOT NULL,
    last4 VARCHAR(4),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =========================
-- DELIVERY
-- =========================
CREATE TABLE deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    address_id INT NOT NULL,
    status ENUM('PENDING','SHIPPED','IN_TRANSIT','DELIVERED','CANCELLED') DEFAULT 'PENDING',
    delivery_date DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE CASCADE
);

-- =========================
-- REVIEWS
-- =========================
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- =========================
-- NOTIFICATIONS
-- =========================
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =========================
-- WISHLIST
-- =========================
CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    UNIQUE(user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

USE furnitureweb; 
-- Create an ADMIN user
INSERT INTO users (
    first_name, last_name, email, password_hash, phone, role, auth_provider, is_verified, status
) VALUES (
    'Admin', 'User', 'admin@furniture.com', 
    '$2a$12$TgD5fqV2.yR4VzZ0mY5lVuRqa/m205Kq6HrSGyWJAISyj68n72gPu',  -- ← see below how to generate
    '0771234567', 'ADMIN', 'LOCAL', true, 'ACTIVE'
);

-- Create an AGENT user
INSERT INTO users (
    first_name, last_name, email, password_hash, phone, role, auth_provider, is_verified, status
) VALUES (
    'Support', 'Agent', 'agent@furniture.com', 
    '$2a$12$vavleK9C0E6pVmTzbo/CiOSqqhmO1hjgvg3Lfq535SlL84AOfckT2',
    '0779876543', 'AGENT', 'LOCAL', true, 'ACTIVE'
);

USE furnitureweb;
ALTER TABLE payments 
MODIFY COLUMN status ENUM('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED') 
DEFAULT 'PENDING';

USE furnitureweb;
-- Add the two new columns for Delivery feature
ALTER TABLE deliveries 
ADD COLUMN delivery_partner VARCHAR(100) AFTER delivery_date;

ALTER TABLE deliveries 
ADD COLUMN tracking_code VARCHAR(50) AFTER delivery_partner;

-- Optional: Add index for faster lookups by tracking code (recommended)
CREATE INDEX idx_delivery_tracking_code ON deliveries(tracking_code);

-- Optional: Update existing deliveries with a default tracking code if you already have some records
UPDATE deliveries 
SET tracking_code = CONCAT('ANURA-DEL-', LPAD(delivery_id, 8, '0'))
WHERE tracking_code IS NULL;