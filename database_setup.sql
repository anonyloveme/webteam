-- ========================================
-- DATABASE SETUP - WEBSITE BÁN ĐỒ ĂN VẶT
-- ========================================

-- 1. TẠO DATABASE MỚI
-- DROP DATABASE nếu đã tồn tại (để reset)
DROP DATABASE IF EXISTS snack_shop_db;

-- CREATE DATABASE với charset utf8mb4 (hỗ trợ emoji + tiếng Việt)
CREATE DATABASE snack_shop_db 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

-- Sử dụng database vừa tạo
USE snack_shop_db;

-- ========================================
-- 2. BẢNG USER (Người dùng)
-- ========================================
CREATE TABLE tbluser (
    -- id: Primary Key, tự động tăng
    id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- username: Tên đăng nhập (duy nhất, không null)
    username VARCHAR(50) UNIQUE NOT NULL,
    
    -- password: Mật khẩu (TODO: nên hash bằng BCrypt)
    password VARCHAR(255) NOT NULL,
    
    -- full_name: Họ tên đầy đủ
    full_name VARCHAR(100),
    
    -- email: Email (có thể null)
    email VARCHAR(100),
    
    -- phone: Số điện thoại
    phone VARCHAR(20),
    
    -- address: Địa chỉ
    address TEXT,
    
    -- role: Vai trò (ADMIN hoặc CUSTOMER)
    role VARCHAR(20) DEFAULT 'CUSTOMER',
    
    -- created_date: Ngày tạo tài khoản (tự động)
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- 3. BẢNG CATEGORY (Danh mục sản phẩm)
-- ========================================
CREATE TABLE tblcategory (
    -- id: Primary Key
    id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- name: Tên danh mục (duy nhất, không null)
    name VARCHAR(100) NOT NULL UNIQUE,
    
    -- description: Mô tả danh mục
    description TEXT,
    
    -- image: Đường dẫn ảnh đại diện
    image VARCHAR(255)
);

-- ========================================
-- 4. BẢNG PRODUCT (Sản phẩm)
-- ========================================
CREATE TABLE tblproduct (
    -- id: Primary Key
    id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- name: Tên sản phẩm (không null)
    name VARCHAR(255) NOT NULL,
    
    -- description: Mô tả chi tiết sản phẩm
    description TEXT,
    
    -- price: Giá (DECIMAL để tránh lỗi làm tròn)
    -- DECIMAL(10,2) = tối đa 10 chữ số, 2 số thập phân
    -- Ví dụ: 12345678.99
    price DECIMAL(10,2) NOT NULL,
    
    -- image: Đường dẫn ảnh sản phẩm
    image VARCHAR(255),
    
    -- category_id: Foreign Key trỏ đến tblcategory
    category_id INT,
    
    -- stock: Số lượng tồn kho (mặc định 0)
    stock INT DEFAULT 0,
    
    -- created_date: Ngày tạo sản phẩm
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- FOREIGN KEY constraint
    -- ON DELETE SET NULL: Khi xóa category → set category_id = NULL
    FOREIGN KEY (category_id) REFERENCES tblcategory(id) 
        ON DELETE SET NULL
);

-- ========================================
-- 5. BẢNG ORDER (Đơn hàng)
-- ========================================
CREATE TABLE tblorder (
    -- id: Primary Key
    id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- user_id: Foreign Key trỏ đến tbluser
    user_id INT,
    
    -- order_date: Ngày đặt hàng (tự động)
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- total_amount: Tổng tiền đơn hàng
    total_amount DECIMAL(10,2) NOT NULL,
    
    -- status: Trạng thái đơn hàng
    -- PENDING: Chờ xử lý
    -- PROCESSING: Đang xử lý
    -- DELIVERED: Đã giao
    -- CANCELLED: Đã hủy
    status VARCHAR(20) DEFAULT 'PENDING',
    
    -- shipping_address: Địa chỉ giao hàng
    shipping_address TEXT NOT NULL,
    
    -- phone_number: SĐT người nhận
    phone_number VARCHAR(20) NOT NULL,
    
    -- notes: Ghi chú của khách hàng
    notes TEXT,
    
    -- FOREIGN KEY constraint
    -- ON DELETE CASCADE: Khi xóa user → xóa luôn đơn hàng
    FOREIGN KEY (user_id) REFERENCES tbluser(id) 
        ON DELETE CASCADE
);

-- ========================================
-- 6. BẢNG ORDER_ITEM (Chi tiết đơn hàng)
-- ========================================
CREATE TABLE tblorder_item (
    -- id: Primary Key
    id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- order_id: Foreign Key trỏ đến tblorder
    order_id INT,
    
    -- product_id: Foreign Key trỏ đến tblproduct
    product_id INT,
    
    -- product_name: Tên sản phẩm (lưu lại để backup)
    -- Tại sao? Vì nếu sản phẩm đổi tên sau này, đơn hàng vẫn giữ tên cũ
    product_name VARCHAR(255),
    
    -- price: Giá tại thời điểm đặt hàng
    -- Tại sao? Vì giá sản phẩm có thể thay đổi, cần lưu giá cũ
    price DECIMAL(10,2),
    
    -- quantity: Số lượng mua
    quantity INT,
    
    -- subtotal: Thành tiền (price * quantity)
    subtotal DECIMAL(10,2),
    
    -- FOREIGN KEY constraints
    -- ON DELETE CASCADE: Xóa order → xóa luôn order items
    -- ON DELETE SET NULL: Xóa product → chỉ set product_id = NULL
    FOREIGN KEY (order_id) REFERENCES tblorder(id) 
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES tblproduct(id) 
        ON DELETE SET NULL
);

-- ========================================
-- 7. TẠO INDEX (Tăng tốc truy vấn)
-- ========================================

-- Index cho tblproduct.category_id
-- Tại sao? Vì thường query: WHERE category_id = ?
CREATE INDEX idx_product_category ON tblproduct(category_id);

-- Index cho tblorder.user_id
-- Tại sao? Vì thường query: WHERE user_id = ?
CREATE INDEX idx_order_user ON tblorder(user_id);

-- Index cho tblorder.status
-- Tại sao? Vì thường query: WHERE status = 'PENDING'
CREATE INDEX idx_order_status ON tblorder(status);

-- Index cho tblorder_item.order_id
-- Tại sao? Vì thường query: WHERE order_id = ?
CREATE INDEX idx_orderitem_order ON tblorder_item(order_id);

-- ========================================
-- 8. INSERT DỮ LIỆU MẪU (Sample Data)
-- ========================================

-- 8.1. Insert Users
INSERT INTO tbluser (username, password, full_name, email, phone, address, role) VALUES
('admin', '123456', 'Quản trị viên', 'admin@snackshop.com', '0123456789', 'Hà Nội', 'ADMIN'),
('customer1', '123456', 'Nguyễn Văn A', 'vana@gmail.com', '0987654321', 'TP HCM', 'CUSTOMER'),
('customer2', '123456', 'Trần Thị B', 'thib@gmail.com', '0912345678', 'Đà Nẵng', 'CUSTOMER');

-- 8.2. Insert Categories
INSERT INTO tblcategory (name, description, image) VALUES
('Snack', 'Đồ ăn vặt giòn tan', 'snack.jpg'),
('Kẹo', 'Kẹo các loại', 'candy.jpg'),
('Bánh', 'Bánh ngọt, bánh quy', 'cake.jpg'),
('Nước giải khát', 'Nước ngọt, trà', 'drink.jpg');

-- 8.3. Insert Products
INSERT INTO tblproduct (name, description, price, image, category_id, stock) VALUES
-- Snack
('Bim bim Ostar', 'Bim bim phô mai 50g', 5000, 'ostar.jpg', 1, 100),
('Poca vị gà', 'Snack vị gà giòn tan 40g', 6000, 'poca.jpg', 1, 150),
('Lay\'s vị kem chua hành', 'Khoai tây chiên 48g', 12000, 'lays.jpg', 1, 80),

-- Kẹo
('Kẹo dẻo Haribo', 'Kẹo gấu dẻo 100g', 25000, 'haribo.jpg', 2, 60),
('Mentos vị bạc hà', 'Kẹo viên ngậm 35g', 8000, 'mentos.jpg', 2, 120),
('Kẹo mút Chupa Chups', 'Kẹo mút nhiều vị', 3000, 'chupachups.jpg', 2, 200),

-- Bánh
('Oreo', 'Bánh quy socola kem 133g', 18000, 'oreo.jpg', 3, 90),
('Bánh quy Cosy', 'Bánh quy bơ 144g', 15000, 'cosy.jpg', 3, 70),
('Chocopie', 'Bánh socola marshmallow 30g', 5000, 'chocopie.jpg', 3, 150),

-- Nước giải khát
('Coca Cola', 'Nước ngọt có ga 330ml', 10000, 'coca.jpg', 4, 200),
('Trà xanh C2', 'Trà xanh không độ 500ml', 8000, 'c2.jpg', 4, 180),
('Sting dâu', 'Nước tăng lực 330ml', 12000, 'sting.jpg', 4, 100);

-- 8.4. Insert Sample Orders (để test)
INSERT INTO tblorder (user_id, total_amount, status, shipping_address, phone_number, notes) VALUES
(2, 50000, 'PENDING', '123 Nguyễn Huệ, Q.1, TP.HCM', '0987654321', 'Giao giờ hành chính'),
(3, 75000, 'PROCESSING', '456 Lê Lợi, Hải Châu, Đà Nẵng', '0912345678', 'Gọi trước khi giao');

-- 8.5. Insert Sample Order Items
-- Đơn hàng 1: 2 Ostar + 3 Poca
INSERT INTO tblorder_item (order_id, product_id, product_name, price, quantity, subtotal) VALUES
(1, 1, 'Bim bim Ostar', 5000, 2, 10000),
(1, 2, 'Poca vị gà', 6000, 3, 18000);

-- Đơn hàng 2: 1 Oreo + 2 Coca
INSERT INTO tblorder_item (order_id, product_id, product_name, price, quantity, subtotal) VALUES
(2, 7, 'Oreo', 18000, 1, 18000),
(2, 10, 'Coca Cola', 10000, 2, 20000);

-- ========================================
-- 9. KIỂM TRA DỮ LIỆU
-- ========================================

-- Xem tất cả categories
SELECT * FROM tblcategory;

-- Xem tất cả products với tên category
SELECT 
    p.id,
    p.name AS product_name,
    p.price,
    p.stock,
    c.name AS category_name
FROM tblproduct p
LEFT JOIN tblcategory c ON p.category_id = c.id;

-- Xem chi tiết đơn hàng
SELECT 
    o.id AS order_id,
    u.full_name,
    o.order_date,
    o.total_amount,
    o.status
FROM tblorder o
JOIN tbluser u ON o.user_id = u.id;

SELECT 
    oi.order_id,
    oi.product_name,
    oi.price,
    oi.quantity,
    oi.subtotal
FROM tblorder_item oi
WHERE oi.order_id = 1;

-- ========================================
-- KẾT THÚC DATABASE SETUP
-- ========================================
