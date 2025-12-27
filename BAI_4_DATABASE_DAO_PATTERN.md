# 📘 BÀI 4: DATABASE & DAO PATTERN

## 🎯 Mục Đích Học
- Hiểu JDBC (Java Database Connectivity) và cách kết nối MySQL
- Biết cách sử dụng PreparedStatement để tránh SQL Injection
- Hiểu Transaction và tầm quan trọng của nó
- Áp dụng DAO Pattern trong dự án thực tế
- Thay dữ liệu giả (HashMap) bằng Database thật

---

## 📖 4.1. LÝ THUYẾT JDBC (Java Database Connectivity)

### **JDBC là gì?**
- **Định nghĩa**: API chuẩn của Java để kết nối và thao tác với Database
- **Mục đích**: Thực thi câu lệnh SQL từ Java (SELECT, INSERT, UPDATE, DELETE)
- **Hỗ trợ**: MySQL, PostgreSQL, Oracle, SQL Server, SQLite...

### **Kiến trúc JDBC**

```
[Java Application]
        ↓
    [JDBC API]  ← Java cung cấp (java.sql.*)
        ↓
  [JDBC Driver]  ← MySQL cung cấp (mysql-connector-j-8.x.jar)
        ↓
  [MySQL Server]
```

**Giải thích:**
1. **JDBC API**: Interface chuẩn (Connection, Statement, ResultSet...)
2. **JDBC Driver**: Thư viện của từng loại Database (MySQL Driver, Oracle Driver...)
3. **Database Server**: MySQL, PostgreSQL...

### **Các bước kết nối Database**

```java
// BƯỚC 1: Load JDBC Driver
Class.forName("com.mysql.cj.jdbc.Driver");
// Tại sao cần? Đăng ký driver với DriverManager
// MySQL 8.x: com.mysql.cj.jdbc.Driver
// MySQL 5.x: com.mysql.jdbc.Driver

// BƯỚC 2: Tạo Connection (Kết nối)
String url = "jdbc:mysql://localhost:3306/snack_shop_db";
String user = "root";
String password = "123456";
Connection conn = DriverManager.getConnection(url, user, password);

// BƯỚC 3: Tạo Statement (Câu lệnh SQL)
Statement stmt = conn.createStatement();
// hoặc
PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM tblproduct");

// BƯỚC 4: Thực thi câu lệnh
ResultSet rs = stmt.executeQuery("SELECT * FROM tblproduct");
// hoặc
int rowsAffected = stmt.executeUpdate("INSERT INTO ...");

// BƯỚC 5: Xử lý kết quả
while (rs.next()) {
    int id = rs.getInt("id");
    String name = rs.getString("name");
    // ...
}

// BƯỚC 6: Đóng kết nối (Quan trọng!)
rs.close();
stmt.close();
conn.close();
```

**Giải thích chi tiết:**

1. **Connection URL Format:**
```
jdbc:mysql://[host]:[port]/[database]?[parameters]
```
- `jdbc:mysql://`: Protocol (bắt buộc)
- `localhost`: Máy chủ (localhost = máy local)
- `3306`: Port mặc định của MySQL
- `snack_shop_db`: Tên database
- `?useSSL=false&serverTimezone=UTC`: Tham số tuỳ chọn

2. **Statement vs PreparedStatement:**
```java
// STATEMENT (Không an toàn - SQL Injection)
String sql = "SELECT * FROM tbluser WHERE username='" + username + "'";
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery(sql);

// PREPAREDSTATEMENT (An toàn - Tránh SQL Injection)
String sql = "SELECT * FROM tbluser WHERE username=?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, username);  // Index bắt đầu từ 1
ResultSet rs = pstmt.executeQuery();
```

**Tại sao PreparedStatement an toàn hơn?**
```java
// Giả sử user nhập: admin' OR '1'='1
// STATEMENT:
String sql = "SELECT * FROM tbluser WHERE username='" + username + "'";
// Kết quả: SELECT * FROM tbluser WHERE username='admin' OR '1'='1'
// Lỗi SQL Injection! Trả về tất cả user

// PREPAREDSTATEMENT:
pstmt.setString(1, username);
// JDBC tự động escape ký tự đặc biệt
// Kết quả: SELECT * FROM tbluser WHERE username='admin\' OR \'1\'=\'1'
// An toàn! Không thể injection
```

3. **ResultSet Methods:**
```java
// Di chuyển con trỏ
rs.next();           // Di chuyển đến dòng tiếp theo (trả về true nếu còn dữ liệu)
rs.previous();       // Quay lại dòng trước (cần TYPE_SCROLL_SENSITIVE)
rs.first();          // Về dòng đầu tiên
rs.last();           // Đến dòng cuối cùng

// Lấy dữ liệu theo cột (Index hoặc Tên cột)
int id = rs.getInt(1);              // Cột thứ 1 (Index bắt đầu từ 1)
String name = rs.getString("name"); // Cột tên "name"
double price = rs.getDouble("price");
Date date = rs.getDate("created_date");

// Kiểm tra null
String desc = rs.getString("description");
if (rs.wasNull()) {
    desc = "Không có mô tả";
}
```

---

## 📖 4.2. SQL INJECTION - NGUY HIỂM & CÁCH PHÒNG TRÁNH

### **SQL Injection là gì?**
- **Định nghĩa**: Kỹ thuật tấn công bằng cách chèn mã SQL độc hại vào input
- **Nguy hiểm**: 
  - Đánh cắp toàn bộ dữ liệu (username, password, thông tin cá nhân)
  - Xóa dữ liệu (DROP TABLE, DELETE)
  - Chiếm quyền Admin

### **Ví dụ SQL Injection:**

```java
// CODE KHÔNG AN TOÀN (Dùng Statement)
String username = request.getParameter("username");  // User nhập: admin' OR '1'='1
String password = request.getParameter("password");  // User nhập: bất kỳ

String sql = "SELECT * FROM tbluser WHERE username='" + username + "' AND password='" + password + "'";
// Câu SQL thực tế:
// SELECT * FROM tbluser WHERE username='admin' OR '1'='1' AND password='bất kỳ'
// Điều kiện OR '1'='1' LUÔN ĐÚNG -> Trả về tất cả user -> Đăng nhập thành công!

Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery(sql);

if (rs.next()) {
    // Đăng nhập thành công (BỊ HACK!)
}
```

**Các kiểu tấn công SQL Injection:**

```sql
-- 1. BYPASS ĐĂNG NHẬP
Username: admin' OR '1'='1
Password: (bất kỳ)
Kết quả: SELECT * FROM tbluser WHERE username='admin' OR '1'='1' AND password='...'

-- 2. LẤY DỮ LIỆU NHẠY CẢM
Username: admin' UNION SELECT username, password FROM tbluser --
Kết quả: Lấy toàn bộ username, password

-- 3. XÓA DỮ LIỆU
Username: admin'; DROP TABLE tblproduct; --
Kết quả: Xóa toàn bộ bảng tblproduct!

-- 4. CHIẾM QUYỀN ADMIN
Username: admin' UPDATE tbluser SET role='admin' WHERE username='hacker'; --
Kết quả: Biến tài khoản 'hacker' thành Admin
```

### **Cách PHÒNG TRÁNH SQL Injection:**

#### **✅ Cách 1: Dùng PreparedStatement (KHUYẾN NGHỊ)**

```java
// CODE AN TOÀN
String username = request.getParameter("username");  // User nhập: admin' OR '1'='1
String password = request.getParameter("password");

String sql = "SELECT * FROM tbluser WHERE username=? AND password=?";
PreparedStatement pstmt = conn.prepareStatement(sql);

// JDBC tự động escape các ký tự đặc biệt
pstmt.setString(1, username);  // 'admin\' OR \'1\'=\'1' (escape tự động)
pstmt.setString(2, password);

ResultSet rs = pstmt.executeQuery();
// Câu SQL an toàn: SELECT * FROM tbluser WHERE username='admin\' OR \'1\'=\'1' AND password='...'
// Không tìm thấy user -> Đăng nhập thất bại (An toàn!)
```

**Tại sao PreparedStatement an toàn?**
1. Tách biệt SQL logic và dữ liệu
2. Dữ liệu được truyền qua tham số `?`, KHÔNG ghép trực tiếp vào chuỗi SQL
3. JDBC Driver tự động escape các ký tự đặc biệt (`'`, `"`, `--`, `;`...)
4. Hacker không thể can thiệp vào cấu trúc SQL

#### **✅ Cách 2: Validate Input (Bổ sung)**

```java
// Kiểm tra username chỉ chứa chữ, số, gạch dưới
String usernamePattern = "^[a-zA-Z0-9_]{3,20}$";
if (!username.matches(usernamePattern)) {
    throw new IllegalArgumentException("Username không hợp lệ!");
}

// Kiểm tra password độ dài
if (password.length() < 8 || password.length() > 50) {
    throw new IllegalArgumentException("Password phải từ 8-50 ký tự!");
}
```

#### **❌ KHÔNG BAO GIỜ LÀM:**
```java
// ❌ KHÔNG ghép chuỗi trực tiếp
String sql = "SELECT * FROM tbluser WHERE username='" + username + "'";

// ❌ KHÔNG dùng Statement với dữ liệu từ user
Statement stmt = conn.createStatement();
stmt.executeQuery(sql);

// ❌ KHÔNG tin tưởng input từ user
// (Luôn validate và dùng PreparedStatement)
```

---

## 📖 4.3. TRANSACTION (Giao Dịch Database)

### **Transaction là gì?**
- **Định nghĩa**: Nhóm nhiều câu lệnh SQL thành 1 đơn vị công việc
- **Đặc điểm ACID**:
  - **A**tomicity (Tính nguyên tử): Tất cả hoặc không (All or Nothing)
  - **C**onsistency (Tính nhất quán): Dữ liệu luôn đúng
  - **I**solation (Tính độc lập): Các transaction không ảnh hưởng lẫn nhau
  - **D**urability (Tính bền vững): Dữ liệu được lưu vĩnh viễn sau commit

### **Tại sao cần Transaction?**

**Ví dụ: Tạo đơn hàng**
```java
// KHÔNG DÙNG TRANSACTION (Nguy hiểm!)
// Bước 1: Thêm đơn hàng vào tblorder
INSERT INTO tblorder (user_id, total_price, status) VALUES (1, 100000, 'pending');
// Lấy order_id = 5

// Bước 2: Thêm chi tiết đơn hàng vào tblorder_item
INSERT INTO tblorder_item (order_id, product_id, quantity, price) VALUES (5, 10, 2, 25000);
INSERT INTO tblorder_item (order_id, product_id, quantity, price) VALUES (5, 12, 1, 50000);

// ⚠️ VẤN ĐỀ: Nếu Bước 2 bị lỗi (mất kết nối, lỗi SQL...)
// -> Đơn hàng được tạo NHƯNG KHÔNG CÓ chi tiết
// -> Dữ liệu SAI, không thể khôi phục!
```

**Giải pháp: Dùng Transaction**
```java
// DÙNG TRANSACTION (An toàn!)
conn.setAutoCommit(false);  // Tắt auto-commit

try {
    // Bước 1: Thêm đơn hàng
    INSERT INTO tblorder ...;
    
    // Bước 2: Thêm chi tiết đơn hàng
    INSERT INTO tblorder_item ...;
    INSERT INTO tblorder_item ...;
    
    conn.commit();  // ✅ Tất cả thành công -> Commit (Lưu vĩnh viễn)
    
} catch (SQLException e) {
    conn.rollback();  // ❌ Có lỗi -> Rollback (Hủy tất cả, quay về trạng thái ban đầu)
    throw e;
}
```

### **Cách sử dụng Transaction trong Java:**

```java
Connection conn = null;
PreparedStatement pstmt1 = null;
PreparedStatement pstmt2 = null;

try {
    // Lấy kết nối
    conn = DatabaseConnection.getConnection();
    
    // === BẮT ĐẦU TRANSACTION ===
    conn.setAutoCommit(false);  // Tắt tự động commit
    
    // Bước 1: Thêm đơn hàng
    String sql1 = "INSERT INTO tblorder (user_id, total_price, status) VALUES (?, ?, ?)";
    pstmt1 = conn.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);
    pstmt1.setInt(1, userId);
    pstmt1.setDouble(2, totalPrice);
    pstmt1.setString(3, "pending");
    pstmt1.executeUpdate();
    
    // Lấy ID order vừa tạo
    ResultSet generatedKeys = pstmt1.getGeneratedKeys();
    int orderId = 0;
    if (generatedKeys.next()) {
        orderId = generatedKeys.getInt(1);
    }
    
    // Bước 2: Thêm chi tiết đơn hàng
    String sql2 = "INSERT INTO tblorder_item (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
    pstmt2 = conn.prepareStatement(sql2);
    
    for (CartItem item : cart.getItems()) {
        pstmt2.setInt(1, orderId);
        pstmt2.setInt(2, item.getProduct().getId());
        pstmt2.setInt(3, item.getQuantity());
        pstmt2.setDouble(4, item.getProduct().getPrice());
        pstmt2.executeUpdate();
    }
    
    // === COMMIT TRANSACTION ===
    conn.commit();  // ✅ Thành công -> Lưu vĩnh viễn
    System.out.println("Đơn hàng được tạo thành công!");
    
} catch (SQLException e) {
    // === ROLLBACK TRANSACTION ===
    if (conn != null) {
        try {
            conn.rollback();  // ❌ Lỗi -> Hủy tất cả thay đổi
            System.out.println("Lỗi! Đã rollback transaction.");
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    throw e;
    
} finally {
    // Đóng kết nối
    try {
        if (pstmt1 != null) pstmt1.close();
        if (pstmt2 != null) pstmt2.close();
        if (conn != null) {
            conn.setAutoCommit(true);  // Bật lại auto-commit
            conn.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
```

**Giải thích chi tiết:**

1. **`setAutoCommit(false)`:**
   - Tắt chế độ tự động commit (mặc định mỗi câu SQL tự động commit)
   - Bắt buộc phải gọi `commit()` thủ công

2. **`commit()`:**
   - Lưu tất cả thay đổi vào Database
   - Chỉ gọi khi TẤT CẢ câu lệnh thành công

3. **`rollback()`:**
   - Hủy TẤT CẢ thay đổi, quay về trạng thái trước khi bắt đầu transaction
   - Gọi khi có BẤT KỲ lỗi nào

4. **`Statement.RETURN_GENERATED_KEYS`:**
   - Lấy ID tự động tăng (AUTO_INCREMENT) sau khi INSERT
   - Dùng `getGeneratedKeys()` để lấy ID

### **Khi nào cần Transaction?**

| **CẦN** | **KHÔNG CẦN** |
|---------|---------------|
| Tạo đơn hàng (Order + OrderItem) | SELECT đơn giản |
| Chuyển tiền (Trừ A + Cộng B) | INSERT 1 dòng đơn lẻ |
| Cập nhật nhiều bảng liên quan | UPDATE 1 dòng |
| Xóa cascade (Parent + Child) | DELETE 1 dòng |

**Nguyên tắc:** Nếu có **2+ câu SQL phụ thuộc nhau**, phải dùng Transaction!

---

## 📖 4.4. DAO PATTERN (Data Access Object)

### **DAO Pattern là gì?**
- **Định nghĩa**: Mẫu thiết kế tách biệt logic truy cập Database khỏi Business Logic
- **Mục đích**: 
  - Tái sử dụng code (không viết lại SQL nhiều lần)
  - Dễ bảo trì (thay đổi Database không ảnh hưởng Servlet)
  - Tách biệt trách nhiệm (Servlet lo logic, DAO lo Database)

### **Cấu trúc DAO Pattern:**

```
[Servlet/Controller]  ← Business Logic
        ↓ gọi method
    [DAO Layer]       ← Data Access Logic
        ↓ thực thi SQL
    [Database]
```

**Ví dụ:**
```java
// SERVLET (Không quan tâm SQL như thế nào)
ProductDAO productDAO = new ProductDAO();
List<Product> products = productDAO.getAllProducts();  // Gọi method DAO
request.setAttribute("products", products);

// DAO (Lo việc SQL, trả về kết quả)
public List<Product> getAllProducts() {
    String sql = "SELECT * FROM tblproduct";
    // ... thực thi SQL, trả về List<Product>
}
```

### **Ưu điểm của DAO Pattern:**

1. **Tái sử dụng:** Method `getAllProducts()` dùng ở nhiều Servlet
2. **Dễ test:** Test riêng DAO, không cần Servlet
3. **Dễ đổi Database:** Chỉ sửa DAO, không sửa Servlet
4. **Rõ ràng:** Servlet lo logic, DAO lo Database

---

## 💻 4.5. THỰC HÀNH: KẾT NỐI MYSQL THẬT

### **Bước 1: Cài đặt MySQL**

#### **Option 1: Dùng XAMPP (Khuyến nghị cho người mới)**
1. Download XAMPP: https://www.apachefriends.org/
2. Cài đặt và chạy XAMPP Control Panel
3. Start **Apache** và **MySQL**
4. Mở trình duyệt: http://localhost/phpmyadmin

#### **Option 2: MySQL Standalone**
1. Download MySQL Community Server: https://dev.mysql.com/downloads/mysql/
2. Cài đặt, ghi nhớ password root
3. Download MySQL Workbench để quản lý: https://dev.mysql.com/downloads/workbench/

### **Bước 2: Tạo Database**

Mở **phpMyAdmin** hoặc **MySQL Workbench**, chạy script SQL:

```sql
-- Tạo Database
CREATE DATABASE IF NOT EXISTS snack_shop_db
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE snack_shop_db;

-- Bảng User
CREATE TABLE tbluser (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100),
    email VARCHAR(100),
    role VARCHAR(20) DEFAULT 'user',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Category
CREATE TABLE tblcategory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Product
CREATE TABLE tblproduct (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_path VARCHAR(255),
    category_id INT,
    stock INT DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES tblcategory(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Order
CREATE TABLE tblorder (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES tbluser(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Order Item
CREATE TABLE tblorder_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES tblorder(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES tblproduct(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Thêm dữ liệu mẫu
INSERT INTO tbluser (username, password, fullname, email, role) VALUES
('admin', 'admin123', 'Quản trị viên', 'admin@snackshop.com', 'admin'),
('john', 'john123', 'John Doe', 'john@gmail.com', 'user'),
('mary', 'mary123', 'Mary Jane', 'mary@gmail.com', 'user');

INSERT INTO tblcategory (name, description) VALUES
('Snack', 'Đồ ăn vặt giòn'),
('Candy', 'Kẹo các loại'),
('Chocolate', 'Socola cao cấp'),
('Drink', 'Nước uống');

INSERT INTO tblproduct (name, description, price, image_path, category_id, stock) VALUES
('Bánh snack BBQ', 'Vị BBQ đậm đà', 25000, 'images/snack1.jpg', 1, 100),
('Kẹo dẻo trái cây', 'Nhiều vị trái cây', 18000, 'images/candy1.jpg', 2, 150),
('Socola hạnh nhân', 'Socola nguyên chất', 35000, 'images/choco1.jpg', 3, 80),
('Coca Cola', 'Nước ngọt có ga', 12000, 'images/drink1.jpg', 4, 200);

-- Index để tăng tốc query
CREATE INDEX idx_product_category ON tblproduct(category_id);
CREATE INDEX idx_order_user ON tblorder(user_id);
CREATE INDEX idx_orderitem_order ON tblorder_item(order_id);
```

**Giải thích:**
- `utf8mb4`: Hỗ trợ đầy đủ Unicode (emoji, tiếng Việt...)
- `AUTO_INCREMENT`: ID tự động tăng
- `FOREIGN KEY`: Ràng buộc khóa ngoại
- `ON DELETE CASCADE`: Xóa cha -> Tự động xóa con
- `ON DELETE SET NULL`: Xóa cha -> Con set NULL
- `INDEX`: Tăng tốc truy vấn (đánh chỉ mục)

### **Bước 3: Thêm MySQL Driver vào Project**

1. Download MySQL Connector/J: https://dev.mysql.com/downloads/connector/j/
2. Giải nén, lấy file `mysql-connector-j-8.4.0.jar`
3. Copy vào thư mục `WebContent/WEB-INF/lib/` của project Eclipse
4. Refresh project (F5)

### **Bước 4: Tạo Class `DatabaseConnection.java`**

```java
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Class quản lý kết nối Database
 * Singleton Pattern: Chỉ 1 instance duy nhất
 */
public class DatabaseConnection {
    
    // === CẤU HÌNH DATABASE ===
    private static final String URL = "jdbc:mysql://localhost:3306/snack_shop_db";
    private static final String USER = "root";
    private static final String PASSWORD = "";  // XAMPP mặc định password rỗng
    
    // Tham số bổ sung để tránh lỗi
    private static final String PARAMS = "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    
    // === JDBC DRIVER ===
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    /**
     * Load JDBC Driver (Gọi 1 lần khi class được load)
     */
    static {
        try {
            Class.forName(DRIVER);
            System.out.println("✅ JDBC Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ JDBC Driver NOT FOUND!");
            System.err.println("📌 Check: mysql-connector-j-8.x.jar in WEB-INF/lib/");
            e.printStackTrace();
        }
    }
    
    /**
     * Lấy kết nối Database
     * @return Connection object
     * @throws SQLException nếu không kết nối được
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL + PARAMS, USER, PASSWORD);
            System.out.println("✅ Database connected!");
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Cannot connect to Database!");
            System.err.println("📌 Check: MySQL is running? Database exists? User/Password correct?");
            throw e;
        }
    }
    
    /**
     * Test kết nối Database
     */
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            System.out.println("🎉 Connection test SUCCESS!");
            System.out.println("Database: " + conn.getCatalog());
            conn.close();
        } catch (SQLException e) {
            System.out.println("💥 Connection test FAILED!");
            e.printStackTrace();
        }
    }
}
```

**Giải thích:**

1. **`static` block:**
   - Chạy 1 lần khi class được load vào JVM
   - Dùng để load JDBC Driver sớm

2. **`Class.forName(DRIVER)`:**
   - Đăng ký JDBC Driver với DriverManager
   - Bắt buộc với MySQL 5.x, tuỳ chọn với 8.x

3. **URL Parameters:**
   - `useSSL=false`: Tắt SSL (không cần mã hóa trên localhost)
   - `serverTimezone=UTC`: Đặt timezone (tránh lỗi timezone)
   - `allowPublicKeyRetrieval=true`: Cho phép lấy public key (MySQL 8.x)

4. **Method `getConnection()`:**
   - `static`: Gọi được mà không cần tạo object
   - Trả về `Connection` mới mỗi lần gọi

5. **Method `main()`:**
   - Test kết nối Database
   - Chạy: Right-click -> Run As -> Java Application

**Chạy test:**
```
✅ JDBC Driver loaded successfully!
✅ Database connected!
🎉 Connection test SUCCESS!
Database: snack_shop_db
```

### **Bước 5: Tạo DAO `ProductDAO.java` (Kết nối DB thật)**

```java
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Product;

/**
 * Data Access Object cho Product
 * Xử lý tất cả thao tác Database liên quan đến Product
 */
public class ProductDAO {
    
    /**
     * Lấy tất cả sản phẩm
     * @return List<Product>
     */
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        
        // Câu SQL
        String sql = "SELECT * FROM tblproduct ORDER BY created_date DESC";
        
        // Kết nối và thực thi
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            // 1. Lấy kết nối
            conn = DatabaseConnection.getConnection();
            
            // 2. Tạo Statement
            stmt = conn.createStatement();
            
            // 3. Thực thi query
            rs = stmt.executeQuery(sql);
            
            // 4. Xử lý kết quả
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setImagePath(rs.getString("image_path"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setStock(rs.getInt("stock"));
                
                products.add(product);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in getAllProducts()");
            e.printStackTrace();
        } finally {
            // 5. Đóng kết nối (Quan trọng!)
            closeResources(conn, stmt, rs);
        }
        
        return products;
    }
    
    /**
     * Lấy sản phẩm theo ID
     * @param id ID sản phẩm
     * @return Product hoặc null nếu không tìm thấy
     */
    public Product getProductById(int id) {
        Product product = null;
        
        String sql = "SELECT * FROM tblproduct WHERE id=?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);  // Set tham số
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setImagePath(rs.getString("image_path"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setStock(rs.getInt("stock"));
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in getProductById()");
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return product;
    }
    
    /**
     * Thêm sản phẩm mới
     * @param product Sản phẩm cần thêm
     * @return true nếu thành công
     */
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO tblproduct (name, description, price, image_path, category_id, stock) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            // Set tham số
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setString(4, product.getImagePath());
            pstmt.setInt(5, product.getCategoryId());
            pstmt.setInt(6, product.getStock());
            
            // Thực thi
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;  // Thành công nếu có dòng bị ảnh hưởng
            
        } catch (SQLException e) {
            System.err.println("❌ Error in addProduct()");
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * Cập nhật sản phẩm
     * @param product Sản phẩm cần cập nhật
     * @return true nếu thành công
     */
    public boolean updateProduct(Product product) {
        String sql = "UPDATE tblproduct SET name=?, description=?, price=?, " +
                     "image_path=?, category_id=?, stock=? WHERE id=?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setString(4, product.getImagePath());
            pstmt.setInt(5, product.getCategoryId());
            pstmt.setInt(6, product.getStock());
            pstmt.setInt(7, product.getId());  // WHERE id=?
            
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error in updateProduct()");
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * Xóa sản phẩm
     * @param id ID sản phẩm cần xóa
     * @return true nếu thành công
     */
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM tblproduct WHERE id=?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error in deleteProduct()");
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * Tìm kiếm sản phẩm theo tên
     * @param keyword Từ khóa tìm kiếm
     * @return List<Product>
     */
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        
        String sql = "SELECT * FROM tblproduct WHERE name LIKE ? OR description LIKE ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setImagePath(rs.getString("image_path"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setStock(rs.getInt("stock"));
                
                products.add(product);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error in searchProducts()");
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return products;
    }
    
    /**
     * Đóng tài nguyên Database (Quan trọng để tránh memory leak!)
     */
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

**Giải thích chi tiết:**

1. **Method `getAllProducts()`:**
   - Dùng `Statement` (vì không có tham số)
   - `ORDER BY created_date DESC`: Sắp xếp mới nhất lên đầu

2. **Method `getProductById()`:**
   - Dùng `PreparedStatement` (có tham số `?`)
   - `rs.next()` trả về `true` nếu tìm thấy dòng

3. **Method `addProduct()`:**
   - Dùng `executeUpdate()` (INSERT, UPDATE, DELETE)
   - Trả về số dòng bị ảnh hưởng (`rowsAffected`)

4. **Method `searchProducts()`:**
   - Dùng `LIKE '%keyword%'`: Tìm kiếm gần đúng
   - `%`: Đại diện cho 0 hoặc nhiều ký tự

5. **Method `closeResources()`:**
   - Đóng `ResultSet`, `Statement`, `Connection` theo thứ tự
   - Gọi trong `finally` để đảm bảo luôn đóng (dù có lỗi hay không)

**Tại sao phải đóng kết nối?**
```java
// KHÔNG ĐÓNG KẾT NỐI (Memory Leak!)
for (int i = 0; i < 1000; i++) {
    Connection conn = DatabaseConnection.getConnection();
    // Không đóng -> 1000 kết nối mở -> Hết bộ nhớ!
}

// ĐÚNG: LUÔN ĐÓNG TRONG FINALLY
Connection conn = null;
try {
    conn = DatabaseConnection.getConnection();
    // ...
} finally {
    if (conn != null) conn.close();  // Luôn đóng
}
```

### **Bước 6: Sửa Model `Product.java` (Thêm categoryId, stock)**

```java
package model;

import java.io.Serializable;

public class Product implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String name;
    private String description;
    private double price;
    private String imagePath;
    private int categoryId;     // ← Thêm mới
    private int stock;          // ← Thêm mới
    
    // Constructor rỗng
    public Product() {
    }
    
    // Constructor đầy đủ
    public Product(int id, String name, String description, double price, 
                   String imagePath, int categoryId, int stock) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
        this.stock = stock;
    }
    
    // Getter & Setter (Generate bằng Eclipse: Source -> Generate Getters and Setters)
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public int getStock() {
        return stock;
    }
    
    public void setStock(int stock) {
        this.stock = stock;
    }
}
```

### **Bước 7: Sửa `ProductServlet.java` (Dùng ProductDAO thay vì List giả)**

```java
package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ProductDAO;
import model.Product;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // DAO thay cho List giả
    private ProductDAO productDAO = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                showList(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            case "search":
                searchProducts(request, response);
                break;
            default:
                showList(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("insert".equals(action)) {
            insertProduct(request, response);
        } else if ("update".equals(action)) {
            updateProduct(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách sản phẩm
     */
    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Gọi DAO lấy dữ liệu từ Database
        List<Product> products = productDAO.getAllProducts();
        
        request.setAttribute("productList", products);
        request.getRequestDispatcher("list.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị chi tiết sản phẩm
     */
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Gọi DAO lấy sản phẩm theo ID
            Product product = productDAO.getProductById(id);
            
            if (product == null) {
                request.setAttribute("errorMessage", "Không tìm thấy sản phẩm!");
                showList(request, response);
            } else {
                request.setAttribute("product", product);
                request.getRequestDispatcher("detail.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("products?action=list");
        }
    }
    
    /**
     * Hiển thị form thêm mới
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("form.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form chỉnh sửa
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(id);
            
            if (product == null) {
                response.sendRedirect("products?action=list");
            } else {
                request.setAttribute("product", product);
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("form.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("products?action=list");
        }
    }
    
    /**
     * Thêm sản phẩm mới
     */
    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            String imagePath = request.getParameter("imagePath");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            
            // Tạo Product object
            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setImagePath(imagePath);
            product.setCategoryId(categoryId);
            product.setStock(stock);
            
            // Gọi DAO thêm vào Database
            boolean success = productDAO.addProduct(product);
            
            if (success) {
                response.sendRedirect("products?action=list");
            } else {
                request.setAttribute("errorMessage", "Thêm sản phẩm thất bại!");
                showNewForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
            showNewForm(request, response);
        }
    }
    
    /**
     * Cập nhật sản phẩm
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            String imagePath = request.getParameter("imagePath");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            
            Product product = new Product();
            product.setId(id);
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setImagePath(imagePath);
            product.setCategoryId(categoryId);
            product.setStock(stock);
            
            boolean success = productDAO.updateProduct(product);
            
            if (success) {
                response.sendRedirect("products?action=list");
            } else {
                request.setAttribute("errorMessage", "Cập nhật thất bại!");
                response.sendRedirect("products?action=list");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("products?action=list");
        }
    }
    
    /**
     * Xóa sản phẩm
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            productDAO.deleteProduct(id);
            response.sendRedirect("products?action=list");
        } catch (NumberFormatException e) {
            response.sendRedirect("products?action=list");
        }
    }
    
    /**
     * Tìm kiếm sản phẩm
     */
    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            showList(request, response);
            return;
        }
        
        List<Product> products = productDAO.searchProducts(keyword);
        
        request.setAttribute("productList", products);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("list.jsp").forward(request, response);
    }
}
```

**Thay đổi chính:**
- ❌ Xóa: `static List<Product> productList`
- ✅ Thêm: `private ProductDAO productDAO = new ProductDAO()`
- ✅ Gọi DAO thay vì thao tác List:
  - `productDAO.getAllProducts()` thay `productList`
  - `productDAO.addProduct(product)` thay `productList.add(product)`
  - ...

---

## ✅ BÀI TẬP THỰC HÀNH 4

**Yêu cầu:**

1. **Tạo `UserDAO.java`:**
   - Method `checkLogin(username, password)`: Kiểm tra đăng nhập từ DB
   - Method `registerUser(user)`: Đăng ký user mới
   - Method `getUserByUsername(username)`: Lấy user theo username

2. **Tạo `CategoryDAO.java`:**
   - CRUD đầy đủ cho Category
   - Method `getCategoryById(id)`
   - Method `getAllCategories()`

3. **Sửa `LoginServlet.java`:**
   - Dùng `UserDAO.checkLogin()` thay HashMap
   - Lưu password dạng hash (SHA-256 hoặc BCrypt)

4. **Thêm chức năng "Quên mật khẩu":**
   - Form nhập email
   - Gửi mã xác nhận (giả lập bằng in ra console)
   - Đổi mật khẩu mới

5. **(Nâng cao) Connection Pooling:**
   - Dùng Apache Commons DBCP hoặc HikariCP
   - Tăng hiệu suất khi có nhiều request đồng thời

**Gợi ý:**

```java
// Hash password bằng SHA-256
import java.security.MessageDigest;

public String hashPassword(String password) {
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    } catch (Exception e) {
        throw new RuntimeException(e);
    }
}
```

---

**TIẾP THEO: Bài 5-8 - Chi tiết code cho 4 Member** 🚀

Bài 4 đã xong! Bạn có muốn tôi tiếp tục tạo Bài 5-8 không? 😊