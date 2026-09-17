CREATE DATABASE IF NOT EXISTS easy_order;
USE easy_order;

CREATE TABLE IF NOT EXISTS sellers (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  google_id VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  avatar_url VARCHAR(500),
  username VARCHAR(80) NOT NULL UNIQUE,
  momo_number VARCHAR(20),
  paystack_recipient_code VARCHAR(120),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  seller_id INT UNSIGNED NOT NULL,
  name VARCHAR(160) NOT NULL,
  price_rwf INT UNSIGNED NOT NULL,
  image_url VARCHAR(500),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_seller FOREIGN KEY (seller_id) REFERENCES sellers(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  seller_id INT UNSIGNED NOT NULL,
  buyer_name VARCHAR(150) NOT NULL,
  buyer_phone VARCHAR(20) NOT NULL,
  delivery_address VARCHAR(500) NOT NULL,
  items_json JSON NOT NULL,
  total_amount INT UNSIGNED NOT NULL,
  payment_status ENUM('pending', 'paid', 'failed') NOT NULL DEFAULT 'pending',
  reference VARCHAR(120) NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_seller FOREIGN KEY (seller_id) REFERENCES sellers(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Safe upgrades for databases created by an earlier Easy Order MVP.
ALTER TABLE sellers ADD COLUMN IF NOT EXISTS paystack_recipient_code VARCHAR(120);
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE;
