-- ============================================
-- DATABASE SETUP: SNACK_SHOP
-- Website Bán Đồ Ăn Vặt - 6 bảng chính
-- ============================================

-- Tạo database
DROP DATABASE IF EXISTS snack_shop;
CREATE DATABASE snack_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE snack_shop;

-- ============================================
-- 1. Bảng CATEGORIES (Danh mục sản phẩm)
-- ============================================
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    image_path VARCHAR(255),
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category_name (category_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dữ liệu mẫu categories
INSERT INTO categories (category_name, description, image_path) VALUES
('Bánh ngọt', 'Các loại bánh kẹo, snack ngọt', 'images/categories/banh-ngot.jpg'),
('Bánh mặn', 'Snack vị mặn, chiên giòn', 'images/categories/banh-man.jpg'),
('Kẹo', 'Kẹo ngậm, kẹo dẻo các loại', 'images/categories/keo.jpg'),
('Đồ uống', 'Nước ngọt, nước trái cây', 'images/categories/do-uong.jpg'),
('Hạt dinh dưỡng', 'Hạt hạnh nhân, óc chó, điều', 'images/categories/hat.jpg');

-- ============================================
-- 2. Bảng PRODUCTS (Sản phẩm)
-- ============================================
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_path VARCHAR(255),
    category_id INT,
    stock_quantity INT DEFAULT 0,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    INDEX idx_product_name (product_name),
    INDEX idx_category_id (category_id),
    INDEX idx_price (price)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dữ liệu mẫu products
INSERT INTO products (product_name, description, price, image_path, category_id, stock_quantity) VALUES
-- Bánh ngọt
('Kitkat Matcha 35g', 'Chocolate kitkat vị trà xanh matcha', 12000, 'images/products/kitkat-matcha.jpg', 1, 50),
('Pocky Strawberry 39g', 'Bánh que Pocky vị dâu', 15000, 'images/products/pocky-strawberry.jpg', 1, 100),
('Oreo Original 137g', 'Bánh quy Oreo vị socola', 20000, 'images/products/oreo-original.jpg', 1, 80),
('Choco Pie 360g (12 cái)', 'Bánh Choco Pie hộp 12 cái', 45000, 'images/products/chocopie-box.jpg', 1, 60),

-- Bánh mặn
('Oishi Snack Sườn Nướng BBQ 42g', 'Snack vị sườn BBQ thơm ngon giòn tan', 8000, 'images/products/oishi-bbq.jpg', 2, 100),
('Lay\'s Bò Bít Tết 52g', 'Snack khoai tây vị bò bít tết', 10000, 'images/products/lays-beef.jpg', 2, 120),
('Poca Vị Tôm 45g', 'Snack khoai tây vị tôm', 9000, 'images/products/poca-tom.jpg', 2, 90),
('Swing Cheese 70g', 'Snack que phô mai', 12000, 'images/products/swing-cheese.jpg', 2, 70),

-- Kẹo
('Alpenliebe Cream Strawberry 32g', 'Kẹo kem dâu', 6000, 'images/products/alpenliebe-strawberry.jpg', 3, 150),
('Mentos Rainbow 37g', 'Kẹo Mentos nhiều màu', 8000, 'images/products/mentos-rainbow.jpg', 3, 200),
('Chupa Chups Cola 12g', 'Kẹo mút Chupa Chups vị cola', 5000, 'images/products/chupa-chups-cola.jpg', 3, 250),
('Haribo Goldbears 100g', 'Kẹo dẻo hình gấu', 35000, 'images/products/haribo-bears.jpg', 3, 80),

-- Đồ uống
('Coca Cola 330ml', 'Nước ngọt có ga Coca Cola', 10000, 'images/products/coca.jpg', 4, 200),
('Pepsi 330ml', 'Nước ngọt có ga Pepsi', 10000, 'images/products/pepsi.jpg', 4, 180),
('Sting Vàng 330ml', 'Nước tăng lực Sting', 12000, 'images/products/sting-yellow.jpg', 4, 150),
('C2 Trà Xanh 455ml', 'Trà xanh không độ C2', 10000, 'images/products/c2-green-tea.jpg', 4, 100),

-- Hạt dinh dưỡng
('Hạt Hạnh Nhân Mỹ 500g', 'Hạt hạnh nhân rang muối nhẹ', 150000, 'images/products/hanh-nhan.jpg', 5, 30),
('Hạt Điều Rang Muối 250g', 'Hạt điều rang muối thơm ngon', 120000, 'images/products/hat-dieu.jpg', 5, 25),
('Óc Chó Mỹ 250g', 'Óc chó Mỹ cao cấp', 180000, 'images/products/oc-cho.jpg', 5, 20),
('Hạt Macca Úc 200g', 'Hạt macca nhập khẩu Úc', 200000, 'images/products/macca.jpg', 5, 15);

-- ============================================
-- 3. Bảng USERS (Người dùng)
-- ============================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    role ENUM('user', 'admin') DEFAULT 'user',
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dữ liệu mẫu users (password: admin123, user123)
INSERT INTO users (username, password, full_name, email, phone, role) VALUES
('admin', 'admin123', 'Quản trị viên', 'admin@shop.vn', '0901234567', 'admin'),
('user1', 'user123', 'Nguyễn Văn A', 'vana@gmail.com', '0912345678', 'user'),
('user2', 'user123', 'Trần Thị B', 'thib@gmail.com', '0923456789', 'user'),
('user3', 'user123', 'Lê Văn C', 'lec@gmail.com', '0934567890', 'user');

-- ============================================
-- 4. Bảng CART_ITEMS (Giỏ hàng)
-- ============================================
CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    added_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_product_id (product_id),
    UNIQUE KEY unique_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dữ liệu mẫu cart_items (user2 có sẵn 3 sản phẩm trong giỏ)
INSERT INTO cart_items (user_id, product_id, quantity) VALUES
(2, 1, 2),  -- user1 thêm Kitkat x2
(2, 5, 1),  -- user1 thêm Oishi x1
(3, 13, 1); -- user2 thêm Coca x1

-- ============================================
-- 5. Bảng ORDERS (Đơn hàng)
-- ============================================
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_address VARCHAR(255),
    phone VARCHAR(20),
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_order_date (order_date),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dữ liệu mẫu orders
INSERT INTO orders (user_id, order_date, total_amount, shipping_address, phone, status, notes) VALUES
(2, '2024-12-20 10:30:00', 56000, '123 Lê Lợi, Quận 1, TP.HCM', '0912345678', 'Delivered', 'Giao nhanh giúp em'),
(2, '2024-12-22 14:15:00', 120000, '123 Lê Lợi, Quận 1, TP.HCM', '0912345678', 'Processing', ''),
(3, '2024-12-23 09:00:00', 45000, '456 Nguyễn Huệ, Quận 1, TP.HCM', '0923456789', 'Pending', 'Giao buổi chiều');

-- ============================================
-- 6. Bảng ORDER_ITEMS (Chi tiết đơn hàng)
-- ============================================
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dữ liệu mẫu order_items
-- Đơn hàng #1 (user1) - Delivered
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 2, 12000, 24000),  -- Kitkat x2
(1, 5, 4, 8000, 32000);   -- Oishi x4

-- Đơn hàng #2 (user1) - Processing
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(2, 17, 1, 150000, 150000); -- Hạt Hạnh Nhân

-- Đơn hàng #3 (user2) - Pending
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(3, 4, 1, 45000, 45000);  -- Choco Pie

-- ============================================
-- 7. VIEW: Thống kê tổng quan
-- ============================================

-- View: Tổng sản phẩm theo danh mục
CREATE VIEW vw_products_by_category AS
SELECT 
    c.category_id,
    c.category_name,
    COUNT(p.product_id) AS total_products,
    SUM(p.stock_quantity) AS total_stock
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name;

-- View: Thống kê đơn hàng theo người dùng
CREATE VIEW vw_orders_by_user AS
SELECT 
    u.user_id,
    u.username,
    u.full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username, u.full_name;

-- View: Top 10 sản phẩm bán chạy
CREATE VIEW vw_top_selling_products AS
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.subtotal) AS total_revenue
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.price
ORDER BY total_sold DESC
LIMIT 10;

-- ============================================
-- 8. STORED PROCEDURES
-- ============================================

DELIMITER //

-- Procedure: Tạo đơn hàng từ giỏ hàng
CREATE PROCEDURE sp_create_order_from_cart(
    IN p_user_id INT,
    IN p_shipping_address VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_notes TEXT,
    OUT p_order_id INT
)
BEGIN
    DECLARE v_total_amount DECIMAL(10, 2);
    
    -- Tính tổng tiền giỏ hàng
    SELECT SUM(p.price * c.quantity)
    INTO v_total_amount
    FROM cart_items c
    INNER JOIN products p ON c.product_id = p.product_id
    WHERE c.user_id = p_user_id;
    
    -- Kiểm tra giỏ hàng có sản phẩm không
    IF v_total_amount IS NULL OR v_total_amount = 0 THEN
        SET p_order_id = -1;  -- Giỏ hàng trống
    ELSE
        -- Tạo đơn hàng
        INSERT INTO orders (user_id, total_amount, shipping_address, phone, notes)
        VALUES (p_user_id, v_total_amount, p_shipping_address, p_phone, p_notes);
        
        SET p_order_id = LAST_INSERT_ID();
        
        -- Tạo order_items từ cart_items
        INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
        SELECT 
            p_order_id,
            c.product_id,
            c.quantity,
            p.price,
            p.price * c.quantity
        FROM cart_items c
        INNER JOIN products p ON c.product_id = p.product_id
        WHERE c.user_id = p_user_id;
        
        -- Xóa giỏ hàng
        DELETE FROM cart_items WHERE user_id = p_user_id;
    END IF;
END//

DELIMITER ;

-- ============================================
-- 9. TRIGGERS
-- ============================================

DELIMITER //

-- Trigger: Tự động cập nhật tồn kho khi tạo order_item
CREATE TRIGGER trg_update_stock_after_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END//

-- Trigger: Hoàn trả kho khi hủy đơn hàng
CREATE TRIGGER trg_restore_stock_after_cancel
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.status = 'Cancelled' AND OLD.status != 'Cancelled' THEN
        UPDATE products p
        INNER JOIN order_items oi ON p.product_id = oi.product_id
        SET p.stock_quantity = p.stock_quantity + oi.quantity
        WHERE oi.order_id = NEW.order_id;
    END IF;
END//

DELIMITER ;

-- ============================================
-- 10. SAMPLE QUERIES (để test)
-- ============================================

-- Query 1: Lấy tất cả sản phẩm với tên danh mục
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.stock_quantity,
    c.category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
ORDER BY p.created_date DESC;

-- Query 2: Lấy giỏ hàng của user
SELECT 
    ci.cart_item_id,
    p.product_name,
    p.price,
    ci.quantity,
    (p.price * ci.quantity) AS subtotal
FROM cart_items ci
INNER JOIN products p ON ci.product_id = p.product_id
WHERE ci.user_id = 2;

-- Query 3: Lấy lịch sử đơn hàng của user
SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    o.status
FROM orders o
WHERE o.user_id = 2
ORDER BY o.order_date DESC;

-- Query 4: Lấy chi tiết đơn hàng
SELECT 
    oi.order_item_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.subtotal
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1;

-- Query 5: Tìm kiếm sản phẩm
SELECT * FROM products
WHERE product_name LIKE '%kitkat%' OR description LIKE '%kitkat%';

-- Query 6: Sắp xếp sản phẩm theo giá
SELECT * FROM products
ORDER BY price ASC
LIMIT 10;

-- Query 7: Thống kê doanh thu theo ngày
SELECT 
    DATE(order_date) AS order_day,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS daily_revenue
FROM orders
WHERE status != 'Cancelled'
GROUP BY DATE(order_date)
ORDER BY order_day DESC;

-- ============================================
-- HOÀN TẤT SETUP DATABASE
-- ============================================

SELECT 'Database snack_shop đã được tạo thành công!' AS message;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_users FROM users;
SELECT COUNT(*) AS total_orders FROM orders;
