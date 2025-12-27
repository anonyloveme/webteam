# 🎓 HƯỚNG DẪN HỌC VÀ CODE CHI TIẾT - WEBSITE BÁN ĐỒ ĂN VẶT

## MỤC LỤC

📚 **PHẦN 1: LÝ THUYẾT NỀN TẢNG**
- 1.1. Kiến trúc MVC
- 1.2. DAO Pattern
- 1.3. JDBC & Database
- 1.4. Servlet & JSP
- 1.5. Session & Cookie
- 1.6. Database Design

🚀 **PHẦN 2: THỰC HÀNH - CHỨC NĂNG QUẢN LÝ SẢN PHẨM**
- Bước 1: Setup Database
- Bước 2: Tạo Model (Product.java)
- Bước 3: Tạo DatabaseConnection
- Bước 4: Tạo DAO (ProductDAO.java)
- Bước 5: Tạo Servlet (AdminProductServlet.java)
- Bước 6: Tạo View (JSP)
- Bước 7: Test chức năng

📝 **PHẦN 3: BÀI TẬP VÀ THỰC HÀNH**

---

# 📚 PHẦN 1: ĐÃ GIẢI THÍCH Ở TRÊN

(Xem phần lý thuyết ở message trước)

---

# 🚀 PHẦN 2: THỰC HÀNH CODE

## 🔧 BƯỚC 1: SETUP DATABASE

### **📖 GIẢI THÍCH:**

Database (cơ sở dữ liệu) là nơi lưu trữ TẤT CẢ dữ liệu của website:
- Thông tin sản phẩm
- Thông tin người dùng
- Đơn hàng
- ...

### **💻 THỰC HÀNH:**

**File đã tạo:** `database_setup.sql`

**Cách chạy file SQL:**

1. Mở **MySQL Workbench** hoặc **phpMyAdmin**
2. Copy toàn bộ nội dung file `database_setup.sql`
3. Paste vào SQL Editor
4. Click **Execute** (hoặc nhấn Ctrl+Enter)

**Kết quả:**
- Tạo database `snack_shop_db`
- Tạo 6 bảng: tbluser, tblcategory, tblproduct, tblorder, tblorder_item
- Insert dữ liệu mẫu

### **🔍 GIẢI THÍCH CHI TIẾT CÁC LỆNH SQL:**

#### **1. Tạo Database:**

```sql
CREATE DATABASE snack_shop_db 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;
```

**Giải thích:**
- `CREATE DATABASE`: Tạo database mới
- `CHARACTER SET utf8mb4`: Bộ mã ký tự (hỗ trợ emoji, tiếng Việt đầy đủ)
- `COLLATE utf8mb4_unicode_ci`: Quy tắc so sánh (không phân biệt hoa thường)

**Tại sao utf8mb4?**
- `utf8` cũ chỉ hỗ trợ tối đa 3 bytes/ký tự
- `utf8mb4` hỗ trợ 4 bytes → Emoji được (😀, 🎉)

#### **2. Tạo Bảng Product:**

```sql
CREATE TABLE tblproduct (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES tblcategory(id)
);
```

**Giải thích từng dòng:**

```sql
id INT PRIMARY KEY AUTO_INCREMENT
└┬┘ └┬┘ └─────┬──────┘ └─────┬─────┘
 │   │        │               │
 │   │        │               └─ Tự động tăng (1, 2, 3...)
 │   │        └─ Khóa chính (duy nhất, không null)
 │   └─ Kiểu dữ liệu số nguyên (-2 tỷ → +2 tỷ)
 └─ Tên cột
```

```sql
name VARCHAR(255) NOT NULL
     └────┬────┘ └───┬───┘
          │          │
          │          └─ Không được để trống
          └─ Chuỗi có độ dài tối đa 255 ký tự
```

```sql
price DECIMAL(10,2) NOT NULL
      └────┬─────┘
           │
           └─ Số thập phân: 10 chữ số tổng, 2 chữ số sau dấu phẩy
              Ví dụ: 12345678.99
```

**Tại sao dùng DECIMAL thay vì FLOAT?**

```java
// FLOAT (❌ SAI):
float price = 19.99f;
float total = price * 3;
System.out.println(total); // 59.970001 (SAI!)

// DECIMAL (✅ ĐÚNG):
// Lưu chính xác 19.99, tính ra 59.97
```

#### **3. Foreign Key:**

```sql
FOREIGN KEY (category_id) REFERENCES tblcategory(id)
```

**Giải thích:**
- `category_id` trong bảng `tblproduct` phải **tồn tại** trong cột `id` của bảng `tblcategory`
- Đảm bảo không có sản phẩm "ma" (có category_id không tồn tại)

**Ví dụ:**

```sql
-- Trong tblcategory:
id | name
1  | Snack
2  | Kẹo

-- Trong tblproduct:
-- ✅ ĐÚNG:
INSERT INTO tblproduct (name, category_id) VALUES ('Bánh', 1);

-- ❌ SAI - Lỗi Foreign Key:
INSERT INTO tblproduct (name, category_id) VALUES ('Bánh', 999);
                                                           ↑
                                               Không tồn tại!
```

#### **4. ON DELETE CASCADE vs SET NULL:**

```sql
-- CASCADE: Xóa cha → Xóa con
FOREIGN KEY (user_id) REFERENCES tbluser(id) ON DELETE CASCADE

-- Xóa user id=5 → Tất cả order của user 5 cũng bị xóa

-- SET NULL: Xóa cha → Con set NULL
FOREIGN KEY (category_id) REFERENCES tblcategory(id) ON DELETE SET NULL

-- Xóa category id=3 → Product có category_id=3 thành NULL (không thuộc danh mục nào)
```

**Khi nào dùng CASCADE, khi nào dùng SET NULL?**

| Quan hệ | Dùng gì | Lý do |
|---------|---------|-------|
| User → Order | CASCADE | Xóa user → Xóa luôn đơn hàng (vì đơn không thuộc ai) |
| Category → Product | SET NULL | Xóa category → Sản phẩm vẫn còn (chỉ mất danh mục) |
| Order → OrderItem | CASCADE | Xóa đơn hàng → Xóa luôn chi tiết (logic) |

#### **5. Index:**

```sql
CREATE INDEX idx_product_category ON tblproduct(category_id);
```

**Index là gì?**
- Giống như **mục lục sách**
- Giúp tìm kiếm NHANH hơn

**Không có Index:**
```
Tìm sản phẩm có category_id = 5
→ Database quét TOÀN BỘ 10,000 dòng
→ Mất 2 giây
```

**Có Index:**
```
Tìm sản phẩm có category_id = 5
→ Database dùng Index → Nhảy thẳng đến dòng cần tìm
→ Mất 0.01 giây
```

**Khi nào tạo Index?**
- Cột thường dùng trong `WHERE`, `JOIN`, `ORDER BY`
- VD: `WHERE category_id = ?` → Tạo index cho `category_id`

---

## 🏗️ BƯỚC 2: TẠO MODEL (Product.java)

### **📖 GIẢI THÍCH:**

**Model là gì?**
- Model là **Java class đại diện cho 1 dòng trong bảng database**
- Còn gọi là **Entity** (thực thể) hoặc **POJO** (Plain Old Java Object)

**Vai trò:**
- Lưu trữ dữ liệu tạm thời trong memory
- Truyền dữ liệu giữa các tầng (DAO → Servlet → JSP)

**Cấu trúc:**

```
┌─────────────────────────────────────────┐
│       BẢNG tblproduct (Database)        │
├────┬──────────┬─────┬───────┬──────────┤
│ id │ name     │price│ image │category_id│
├────┼──────────┼─────┼───────┼──────────┤
│ 1  │ Bánh Oreo│18000│abc.jpg│ 3         │
└────┴──────────┴─────┴───────┴──────────┘
           ↓ Mapping (Ánh xạ) ↓
┌─────────────────────────────────────────┐
│        Product.java (Java Object)       │
├─────────────────────────────────────────┤
│ private int id = 1;                    │
│ private String name = "Bánh Oreo";     │
│ private double price = 18000;          │
│ private String image = "abc.jpg";      │
│ private int categoryId = 3;            │
│                                         │
│ // Getters và Setters                  │
│ public int getId() { return id; }      │
│ public void setId(int id) {...}        │
└─────────────────────────────────────────┘
```

### **💻 CODE Product.java:**

```java
package model;

import java.util.Date;

/**
 * Model đại diện cho 1 sản phẩm trong database
 * Tương ứng với 1 dòng trong bảng tblproduct
 */
public class Product {
    
    // =============================================
    // ATTRIBUTES (Thuộc tính)
    // =============================================
    
    /**
     * id: Primary Key (khóa chính)
     * - Duy nhất cho mỗi sản phẩm
     * - Tự động tăng (AUTO_INCREMENT)
     */
    private int id;
    
    /**
     * name: Tên sản phẩm
     * - VARCHAR(255) trong database
     * - String trong Java
     */
    private String name;
    
    /**
     * description: Mô tả chi tiết sản phẩm
     * - TEXT trong database (không giới hạn độ dài)
     * - String trong Java
     */
    private String description;
    
    /**
     * price: Giá sản phẩm
     * - DECIMAL(10,2) trong database
     * - double trong Java
     * 
     * Tại sao dùng double?
     * - Lưu số thập phân (19.99, 25.50...)
     * - Tính toán số học (cộng, trừ, nhân, chia)
     */
    private double price;
    
    /**
     * image: Đường dẫn đến file ảnh
     * - VARCHAR(255) trong database
     * - VD: "products/oreo.jpg", "images/snack01.png"
     */
    private String image;
    
    /**
     * categoryId: ID của danh mục (Foreign Key)
     * - Trỏ đến id trong bảng tblcategory
     * - VD: categoryId = 3 → Thuộc danh mục "Bánh"
     */
    private int categoryId;
    
    /**
     * stock: Số lượng tồn kho
     * - INT trong database
     * - Dùng để kiểm tra còn hàng hay hết
     */
    private int stock;
    
    /**
     * createdDate: Ngày tạo sản phẩm
     * - TIMESTAMP trong database
     * - Date trong Java
     */
    private Date createdDate;
    
    // =============================================
    // CONSTRUCTORS (Hàm khởi tạo)
    // =============================================
    
    /**
     * Constructor 1: Không tham số (Default Constructor)
     * 
     * Dùng khi nào?
     * - Khi tạo object rỗng, sau đó dùng setter để set giá trị
     * 
     * Ví dụ:
     *   Product p = new Product();
     *   p.setName("Bánh Oreo");
     *   p.setPrice(18000);
     */
    public Product() {
        // Constructor rỗng
    }
    
    /**
     * Constructor 2: Cho INSERT (không có id)
     * 
     * Dùng khi nào?
     * - Khi THÊM sản phẩm mới vào database
     * - Không cần id vì database tự động tạo (AUTO_INCREMENT)
     * 
     * Ví dụ:
     *   Product p = new Product("Bánh Oreo", "Ngon", 18000, 
     *                           "oreo.jpg", 3, 50);
     *   productDao.addProduct(p);
     */
    public Product(String name, String description, double price,
                   String image, int categoryId, int stock) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.image = image;
        this.categoryId = categoryId;
        this.stock = stock;
    }
    
    /**
     * Constructor 3: Cho SELECT/UPDATE (có id)
     * 
     * Dùng khi nào?
     * - Khi LẤY sản phẩm từ database (đã có id)
     * - Khi CẬP NHẬT sản phẩm (cần id để biết update dòng nào)
     * 
     * Ví dụ:
     *   Product p = new Product(5, "Bánh Oreo", "Ngon", 18000,
     *                           "oreo.jpg", 3, 50);
     *   productDao.updateProduct(p);
     */
    public Product(int id, String name, String description, double price,
                   String image, int categoryId, int stock) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.image = image;
        this.categoryId = categoryId;
        this.stock = stock;
    }
    
    // =============================================
    // GETTERS (Lấy giá trị)
    // =============================================
    
    /**
     * Tại sao cần Getter?
     * 
     * 1. ENCAPSULATION (Đóng gói):
     *    - Thuộc tính là private (không truy cập trực tiếp từ bên ngoài)
     *    - Getter là public (cho phép đọc giá trị)
     * 
     * 2. Kiểm soát truy cập:
     *    - Có thể thêm logic kiểm tra trong getter
     *    - VD: public String getName() {
     *            return name == null ? "N/A" : name;
     *          }
     * 
     * 3. Read-Only property:
     *    - Có getter nhưng không có setter → Chỉ đọc, không sửa
     */
    
    public int getId() {
        return id;
    }
    
    public String getName() {
        return name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public double getPrice() {
        return price;
    }
    
    public String getImage() {
        return image;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public int getStock() {
        return stock;
    }
    
    public Date getCreatedDate() {
        return createdDate;
    }
    
    // =============================================
    // SETTERS (Gán giá trị)
    // =============================================
    
    /**
     * Tại sao cần Setter?
     * 
     * 1. ENCAPSULATION:
     *    - Cho phép THAY ĐỔI giá trị thuộc tính private
     * 
     * 2. Validation (Kiểm tra dữ liệu):
     *    - Có thể thêm logic kiểm tra
     *    - VD: public void setPrice(double price) {
     *            if (price < 0) {
     *                throw new Exception("Giá không được âm!");
     *            }
     *            this.price = price;
     *          }
     * 
     * 3. Trigger side-effects:
     *    - Khi set giá trị, có thể thực hiện hành động khác
     *    - VD: setStock() → Nếu stock = 0, gửi email thông báo hết hàng
     */
    
    public void setId(int id) {
        this.id = id;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public void setPrice(double price) {
        // TODO: Có thể thêm validation
        // if (price < 0) throw new IllegalArgumentException("Giá phải >= 0");
        this.price = price;
    }
    
    public void setImage(String image) {
        this.image = image;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public void setStock(int stock) {
        this.stock = stock;
    }
    
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
    
    // =============================================
    // UTILITY METHODS (Phương thức tiện ích)
    // =============================================
    
    /**
     * toString(): Chuyển object thành String
     * 
     * Dùng khi nào?
     * - In ra console để debug
     * - Log thông tin object
     * 
     * Ví dụ:
     *   Product p = new Product(...);
     *   System.out.println(p); // Tự động gọi toString()
     *   // Output: Product{id=1, name='Bánh Oreo', price=18000.0}
     */
    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", categoryId=" + categoryId +
                '}';
    }
}
```

### **🔍 GIẢI THÍCH CHI TIẾT:**

#### **1. Tại sao thuộc tính là `private`?**

```java
// ❌ BAD - public:
public class Product {
    public String name;
    public double price;
}

// Vấn đề:
Product p = new Product();
p.price = -100; // Giá âm! Không hợp lý!
p.name = null;  // Null! Lỗi khi hiển thị!

// ✅ GOOD - private + setter có validation:
public class Product {
    private double price;
    
    public void setPrice(double price) {
        if (price < 0) {
            throw new IllegalArgumentException("Giá phải >= 0");
        }
        this.price = price;
    }
}

// Bây giờ:
Product p = new Product();
p.setPrice(-100); // EXCEPTION! Không cho phép!
```

#### **2. Tại sao có nhiều Constructor?**

**Mục đích:** Tạo object với **các tình huống khác nhau**

```java
// Tình huống 1: Tạo object rỗng, sau đó set từng thuộc tính
Product p1 = new Product();
p1.setName("Bánh Oreo");
p1.setPrice(18000);

// Tình huống 2: INSERT - Không có id (database tự tạo)
Product p2 = new Product("Bánh Oreo", "Ngon", 18000, "oreo.jpg", 3, 50);
productDao.addProduct(p2);

// Tình huống 3: SELECT - Có id (lấy từ database)
// Trong ProductDAO.java:
ResultSet rs = stmt.executeQuery("SELECT * FROM tblproduct WHERE id=5");
if (rs.next()) {
    Product p3 = new Product(
        rs.getInt("id"),          // 5
        rs.getString("name"),     // "Bánh Oreo"
        rs.getString("description"), // "Ngon"
        rs.getDouble("price"),    // 18000
        rs.getString("image"),    // "oreo.jpg"
        rs.getInt("category_id"), // 3
        rs.getInt("stock")        // 50
    );
}
```

#### **3. Getter vs Setter:**

**Getter:** READ (Đọc)
**Setter:** WRITE (Ghi)

```java
// Getter - READ
double price = product.getPrice();
System.out.println("Giá: " + price);

// Setter - WRITE
product.setPrice(20000);
```

**Có thể có Getter mà không có Setter (Read-Only):**

```java
public class Product {
    private final int id; // final = không đổi được
    
    public Product(int id) {
        this.id = id;
    }
    
    public int getId() {
        return id; // Có getter
    }
    
    // KHÔNG có setter → Read-Only
    // Không thể thay đổi id sau khi tạo object
}
```

---

## 📡 BƯỚC 3: TẠO DATABASE CONNECTION

### **📖 GIẢI THÍCH:**

**DatabaseConnection là gì?**
- Class **tiện ích** (Utility Class) cung cấp kết nối MySQL
- Dùng **Singleton Pattern** → Chỉ có 1 cách kết nối cho toàn bộ app

**Tại sao tách riêng class này?**
- ✅ **Tập trung:** Thông tin kết nối ở 1 chỗ duy nhất
- ✅ **Dễ sửa:** Đổi database chỉ sửa 1 file
- ✅ **Tái sử dụng:** Tất cả DAO đều dùng class này

### **💻 CODE DatabaseConnection.java:**

```java
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Class tiện ích để tạo kết nối MySQL
 * Utility class - Chỉ có static method, không cần tạo instance
 */
public class DatabaseConnection {
    
    // =============================================
    // CONNECTION PARAMETERS (Thông số kết nối)
    // =============================================
    
    /**
     * JDBC URL Format:
     * jdbc:mysql://[host]:[port]/[database_name]?[parameters]
     * 
     * Giải thích:
     * - jdbc:mysql:// → Protocol (giao thức)
     * - localhost → Host (máy chủ database, localhost = máy local)
     * - 3306 → Port mặc định của MySQL
     * - snack_shop_db → Tên database
     */
    private static final String JDBC_URL = 
        "jdbc:mysql://localhost:3306/snack_shop_db";
    
    /**
     * JDBC_USER: Tên đăng nhập MySQL
     * Mặc định: root
     */
    private static final String JDBC_USER = "root";
    
    /**
     * JDBC_PASSWORD: Mật khẩu MySQL
     * TODO: QUAN TRỌNG - Đổi password thành password của bạn!
     */
    private static final String JDBC_PASSWORD = "your_password_here";
    
    // =============================================
    // PUBLIC METHOD - Lấy kết nối
    // =============================================
    
    /**
     * getConnection(): Tạo và trả về Connection object
     * 
     * @return Connection object
     * @throws SQLException nếu không kết nối được
     * 
     * Cách dùng:
     *   try {
     *       Connection conn = DatabaseConnection.getConnection();
     *       // Sử dụng connection...
     *   } catch (SQLException e) {
     *       e.printStackTrace();
     *   }
     */
    public static Connection getConnection() throws SQLException {
        
        // BƯỚC 1: Load Driver (Nạp trình điều khiển)
        try {
            /**
             * Class.forName() làm gì?
             * - Nạp (load) class Driver vào JVM
             * - Driver tự động đăng ký với DriverManager
             * 
             * MySQL 5.x: com.mysql.jdbc.Driver
             * MySQL 8.x: com.mysql.cj.jdbc.Driver (mới)
             * 
             * Tại sao cần load?
             * - Một số môi trường không tự động tìm Driver
             * - Load thủ công đảm bảo Driver có sẵn
             */
            Class.forName("com.mysql.cj.jdbc.Driver");
            
        } catch (ClassNotFoundException e) {
            /**
             * ClassNotFoundException xảy ra khi:
             * - Thiếu file mysql-connector-java.jar trong WEB-INF/lib
             * - Driver name sai (gõ nhầm tên class)
             * 
             * Giải pháp:
             * - Download mysql-connector-java.jar
             * - Copy vào WEB-INF/lib
             */
            System.err.println("❌ KHÔNG TÌM THẤY MySQL DRIVER!");
            System.err.println("   Hãy thêm mysql-connector-java.jar vào WEB-INF/lib");
            e.printStackTrace();
            throw new SQLException("Driver không tìm thấy", e);
        }
        
        // BƯỚC 2: Tạo Connection
        /**
         * DriverManager.getConnection() làm gì?
         * 1. Tìm Driver phù hợp (dựa vào URL)
         * 2. Tạo kết nối TCP/IP đến MySQL Server
         * 3. Xác thực username/password
         * 4. Trả về Connection object
         * 
         * Connection là gì?
         * - Đại diện cho 1 kết nối đến database
         * - Dùng để tạo Statement, PreparedStatement
         * - Quản lý transaction (commit, rollback)
         */
        Connection conn = DriverManager.getConnection(
            JDBC_URL,      // URL database
            JDBC_USER,     // Username
            JDBC_PASSWORD  // Password
        );
        
        /**
         * Nếu đến đây không lỗi → Kết nối THÀNH CÔNG!
         * Trả về Connection để sử dụng
         */
        return conn;
    }
    
    // =============================================
    // MAIN METHOD - Test kết nối
    // =============================================
    
    /**
     * main(): Test kết nối database
     * 
     * Cách chạy:
     * 1. Right-click file DatabaseConnection.java
     * 2. Run As → Java Application
     * 3. Xem console:
     *    - Thành công: "✅ Kết nối thành công!"
     *    - Thất bại: Error message
     */
    public static void main(String[] args) {
        System.out.println("🔌 ĐANG TEST KẾT NỐI DATABASE...\n");
        
        Connection conn = null;
        
        try {
            // Thử kết nối
            conn = DatabaseConnection.getConnection();
            
            // Nếu đến đây → Kết nối OK
            System.out.println("✅ KẾT NỐI THÀNH CÔNG!");
            System.out.println("   Database: " + conn.getCatalog());
            System.out.println("   URL: " + conn.getMetaData().getURL());
            System.out.println("   User: " + conn.getMetaData().getUserName());
            
        } catch (SQLException e) {
            // Có lỗi → In ra thông tin lỗi
            System.err.println("❌ KẾT NỐI THẤT BẠI!");
            System.err.println("   Lỗi: " + e.getMessage());
            System.err.println("\n💡 NGUYÊN NHÂN CÓ THỂ:");
            System.err.println("   1. MySQL Server chưa chạy");
            System.err.println("   2. Username/Password sai");
            System.err.println("   3. Database 'snack_shop_db' chưa tạo");
            System.err.println("   4. Port 3306 bị chiếm");
            e.printStackTrace();
            
        } finally {
            // QUAN TRỌNG: Đóng connection
            if (conn != null) {
                try {
                    conn.close();
                    System.out.println("\n🔒 Đã đóng kết nối.");
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```

### **🔍 GIẢI THÍCH CHI TIẾT:**

#### **1. Tại sao dùng `static`?**

```java
public static Connection getConnection() { ... }
        ↑
     static
```

**static nghĩa là gì?**
- Thuộc về **CLASS**, không thuộc về **OBJECT**
- Gọi trực tiếp qua tên class, không cần tạo instance

```java
// ❌ Không dùng static:
DatabaseConnection db = new DatabaseConnection();
Connection conn = db.getConnection();

// ✅ Dùng static:
Connection conn = DatabaseConnection.getConnection();
                  └────────┬────────┘
                    Gọi qua class name
```

**Khi nào dùng static?**
- Utility methods (phương thức tiện ích)
- Không cần trạng thái (state) của object
- VD: Math.max(), Integer.parseInt(), Arrays.sort()

#### **2. Class.forName() hoạt động thế nào?**

```java
Class.forName("com.mysql.cj.jdbc.Driver");
```

**Bên trong JVM:**

```
1️⃣ JVM tìm file com/mysql/cj/jdbc/Driver.class

2️⃣ Load class vào memory

3️⃣ Chạy static block của Driver:
   static {
       // Tự động đăng ký Driver với DriverManager
       DriverManager.registerDriver(new Driver());
   }

4️⃣ Driver sẵn sàng để sử dụng
```

**Tại sao cần?**
- JDBC 4.0+ (MySQL 5.1.6+) tự động load Driver
- Nhưng một số môi trường (Tomcat cũ) không tự động
- → Load thủ công để chắc chắn

#### **3. DriverManager.getConnection() làm gì?**

```java
Connection conn = DriverManager.getConnection(url, user, pass);
```

**Các bước:**

```
1️⃣ Parse URL:
   "jdbc:mysql://localhost:3306/snack_shop_db"
   → Protocol: mysql
   → Host: localhost
   → Port: 3306
   → Database: snack_shop_db

2️⃣ Tìm Driver phù hợp:
   DriverManager hỏi tất cả Driver đã đăng ký:
   "Ai xử lý được jdbc:mysql:// không?"
   → MySQL Driver: "Tôi!"

3️⃣ Tạo kết nối TCP/IP:
   Java App ────TCP/IP────> MySQL Server (port 3306)

4️⃣ Handshake (Bắt tay):
   - Gửi username/password
   - MySQL kiểm tra
   - Nếu đúng → Kết nối thành công

5️⃣ Trả về Connection object:
   Connection là "đường ống" giữa Java và MySQL
```

#### **4. Try-Catch-Finally:**

```java
try {
    // Code có thể gây lỗi
    Connection conn = getConnection();
    
} catch (SQLException e) {
    // Xử lý lỗi
    e.printStackTrace();
    
} finally {
    // LUÔN chạy (dù có lỗi hay không)
    // Dùng để cleanup (đóng connection, giải phóng tài nguyên)
    conn.close();
}
```

**Tại sao cần finally?**

```java
// ❌ Không dùng finally:
try {
    Connection conn = getConnection();
    // Nếu có exception ở đây → conn.close() không chạy!
    doSomething();
    conn.close(); // Có thể không chạy được!
}

// ✅ Dùng finally:
Connection conn = null;
try {
    conn = getConnection();
    doSomething();
} finally {
    if (conn != null) {
        conn.close(); // LUÔN chạy!
    }
}
```

---

## 📊 BƯỚC 4: TẠO DAO (ProductDAO.java)

### **📖 GIẢI THÍCH:**

**DAO (Data Access Object) là gì?**
- Lớp chuyên trách **TƯƠNG TÁC VỚI DATABASE**
- Chứa tất cả SQL queries
- Trả về Java objects

**Vai trò:**

```
Servlet (Controller)
    │
    │ Gọi method
    ↓
ProductDAO
    │
    │ Execute SQL
    ↓
MySQL Database
```

### **💻 CODE ProductDAO.java (PHẦN 1 - getAllProducts):**

Tôi sẽ giải thích TỪ TỪNG DÒNG CODE:

```java
package dao;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ProductDAO - Data Access Object cho bảng tblproduct
 * Chứa tất cả logic truy xuất database liên quan đến Product
 */
public class ProductDAO {
    
    /**
     * Method 1: getAllProducts()
     * Lấy TẤT CẢ sản phẩm từ database
     * 
     * @return List<Product> - Danh sách sản phẩm
     * 
     * SQL tương ứng:
     * SELECT * FROM tblproduct ORDER BY id DESC
     */
    public List<Product> getAllProducts() {
        
        // BƯỚC 1: Tạo List rỗng để chứa kết quả
        List<Product> products = new ArrayList<>();
        
        // BƯỚC 2: Chuẩn bị câu SQL
        /**
         * SELECT *: Lấy tất cả cột
         * FROM tblproduct: Từ bảng tblproduct
         * ORDER BY id DESC: Sắp xếp theo id giảm dần (mới nhất trước)
         */
        String sql = "SELECT * FROM tblproduct ORDER BY id DESC";
        
        // BƯỚC 3: Try-with-resources (Tự động đóng connection)
        /**
         * Cú pháp: try (Resource r = ...) { }
         * 
         * Lợi ích:
         * - Tự động gọi r.close() khi kết thúc try block
         * - Không cần finally
         * - Code ngắn gọn hơn
         * 
         * Yêu cầu:
         * - Resource phải implement AutoCloseable interface
         * - Connection, Statement, ResultSet đều implement
         */
        try (
            // Tạo connection
            Connection conn = DatabaseConnection.getConnection();
            
            // Tạo Statement
            Statement stmt = conn.createStatement();
            
            // Thực thi query → Nhận ResultSet
            ResultSet rs = stmt.executeQuery(sql)
        ) {
            
            // BƯỚC 4: Duyệt qua từng dòng kết quả
            /**
             * rs.next() làm gì?
             * - Di chuyển con trỏ đến dòng tiếp theo
             * - Trả về true nếu còn dòng, false nếu hết
             * 
             * Ban đầu: Con trỏ ở TRƯỚC dòng đầu tiên
             * ┌─────────────────┐
             * │ (Cursor ở đây) │ ← Vị trí ban đầu
             * ├─────────────────┤
             * │ Dòng 1          │
             * ├─────────────────┤
             * │ Dòng 2          │
             * └─────────────────┘
             * 
             * Lần 1: rs.next() → Di chuyển đến Dòng 1 → true
             * Lần 2: rs.next() → Di chuyển đến Dòng 2 → true
             * Lần 3: rs.next() → Không còn dòng → false
             */
            while (rs.next()) {
                
                // BƯỚC 5: Lấy dữ liệu từ ResultSet
                /**
                 * rs.getXxx("column_name") hoặc rs.getXxx(column_index)
                 * 
                 * Xxx tùy theo kiểu dữ liệu:
                 * - getInt("id") → int
                 * - getString("name") → String
                 * - getDouble("price") → double
                 * - getTimestamp("created_date") → Timestamp → Date
                 * 
                 * 2 cách:
                 * - rs.getInt("id") → Dùng tên cột (KHUYẾN KHÍCH)
                 * - rs.getInt(1) → Dùng index (từ 1, không phải 0)
                 */
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                String image = rs.getString("image");
                int categoryId = rs.getInt("category_id");
                int stock = rs.getInt("stock");
                // createdDate có thể null → Không lấy trong constructor này
                
                // BƯỚC 6: Tạo Product object từ dữ liệu
                /**
                 * Dùng constructor có id (SELECT)
                 */
                Product product = new Product(
                    id,
                    name,
                    description,
                    price,
                    image,
                    categoryId,
                    stock
                );
                
                // BƯỚC 7: Thêm vào List
                products.add(product);
            }
            
            // KẾT THÚC WHILE → Đã duyệt hết ResultSet
            
        } catch (SQLException e) {
            // BƯỚC 8: Xử lý lỗi
            /**
             * SQLException xảy ra khi:
             * - Không kết nối được database
             * - SQL syntax sai
             * - Bảng/cột không tồn tại
             * - Kiểu dữ liệu không khớp
             */
            System.err.println("❌ LỖI KHI LẤY DANH SÁCH SẢN PHẨM!");
            e.printStackTrace();
        }
        // Try-with-resources TỰ ĐỘNG đóng conn, stmt, rs ở đây!
        
        // BƯỚC 9: Trả về List
        /**
         * Nếu có lỗi → List rỗng (size = 0)
         * Nếu không có sản phẩm nào → List rỗng
         * Nếu có N sản phẩm → List có N phần tử
         */
        return products;
    }
    
    // ... Các method khác sẽ code tiếp ...
}
```

### **🔍 GIẢI THÍCH CHI TIẾT:**

#### **1. Try-with-resources:**

**Cách cũ (❌ Dài dòng):**

```java
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

try {
    conn = DatabaseConnection.getConnection();
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    // ...
} catch (SQLException e) {
    e.printStackTrace();
} finally {
    // Phải đóng thủ công
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
}
```

**Cách mới (✅ Ngắn gọn):**

```java
try (Connection conn = DatabaseConnection.getConnection();
     Statement stmt = conn.createStatement();
     ResultSet rs = stmt.executeQuery(sql)) {
    
    // Sử dụng conn, stmt, rs
    
} // Tự động close() cả 3!
```

#### **2. ResultSet hoạt động thế nào?**

**ResultSet = Bảng kết quả truy vấn:**

```
SQL: SELECT * FROM tblproduct WHERE category_id = 3

ResultSet:
┌────┬──────────┬─────┬───────┬─────────────┬──────┐
│ id │ name     │price│ image │ category_id │stock │
├────┼──────────┼─────┼───────┼─────────────┼──────┤
│ 7  │ Oreo     │18000│oeo.jpg│ 3           │ 90   │ ← Dòng 1
├────┼──────────┼─────┼───────┼─────────────┼──────┤
│ 8  │ Cosy     │15000│csy.jpg│ 3           │ 70   │ ← Dòng 2
├────┼──────────┼─────┼───────┼─────────────┼──────┤
│ 9  │Chocopie  │ 5000│chp.jpg│ 3           │ 150  │ ← Dòng 3
└────┴──────────┴─────┴───────┴─────────────┴──────┘
 ↑
Cursor (Con trỏ)
```

**Cách duyệt:**

```java
// Ban đầu: Cursor ở TRƯỚC dòng 1
while (rs.next()) { // Lần 1: Cursor → Dòng 1
    int id = rs.getInt("id"); // 7
    String name = rs.getString("name"); // "Oreo"
    // ... Tạo Product từ dòng 1
}
// Lần 2: Cursor → Dòng 2
// Lần 3: Cursor → Dòng 3
// Lần 4: rs.next() = false → Thoát while
```

#### **3. Tại sao cần while loop?**

**Không dùng while (❌ SAI):**

```java
ResultSet rs = stmt.executeQuery(sql);
// Không gọi rs.next() → Cursor vẫn ở trước dòng 1!
int id = rs.getInt("id"); // ERROR: Before start of result set
```

**Dùng while (✅ ĐÚNG):**

```java
while (rs.next()) {
    // rs.next() di chuyển cursor + return true/false
    int id = rs.getInt("id"); // OK!
}
```

#### **4. getInt() vs getString():**

| Kiểu SQL | Method Java | Ví dụ |
|----------|-------------|-------|
| INT | rs.getInt("id") | 123 |
| VARCHAR | rs.getString("name") | "Bánh Oreo" |
| TEXT | rs.getString("description") | "Rất ngon" |
| DECIMAL | rs.getDouble("price") | 18000.50 |
| DATE | rs.getDate("created_date") | 2024-01-15 |
| TIMESTAMP | rs.getTimestamp("created_date") | 2024-01-15 10:30:00 |

**Lưu ý:**
- Nếu cột NULL → rs.getString() trả về null
- Nếu cột NULL → rs.getInt() trả về 0
- Kiểm tra null: `rs.wasNull()`

```java
String description = rs.getString("description");
if (rs.wasNull()) {
    description = "Không có mô tả";
}
```

---

Tài liệu này đã rất dài! Tôi sẽ tạm dừng ở đây.

**Tiếp theo chúng ta sẽ code:**
- Các method khác của ProductDAO (getById, add, update, delete, search...)
- Tạo Servlet
- Tạo JSP
- Test chức năng

**Bạn có muốn tiếp tục không?** 

Hoặc bạn có câu hỏi nào về phần đã giải thích không?

