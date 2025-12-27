# PHÂN TÍCH SOURCE CODE VÀ ĐỀ XUẤT PHÁT TRIỂN WEBSITE BÁN ĐỒ ĂN VẶT

## 1. TỔNG QUAN SOURCE CODE HIỆN CÓ

### Công nghệ sử dụng:
- **Backend**: Java Servlet/JSP
- **Database**: MySQL 
- **Architecture**: MVC (Model-View-Controller)
- **Web Server**: Servlet Container (Tomcat)

### Cấu trúc thư mục:
```
DemoNewsWeb_Login_Filter_MySQL/
├── WEB-INF/
│   ├── classes/
│   │   ├── controller/    # Các Servlet và Filter
│   │   ├── dao/          # Data Access Object - truy xuất database
│   │   └── model/        # Model - các entity class
│   ├── lib/              # Thư viện JAR
│   └── web.xml           # File cấu hình web application
├── *.jsp                 # Các trang giao diện
└── META-INF/
```

---

## 2. CÁC CHỨC NĂNG HIỆN CÓ TRONG SOURCE CODE

### 2.1. CHỨC NĂNG ĐĂNG NHẬP & AUTHENTICATION (Login System)

#### Files liên quan:
- `controller/LoginServlet.java`
- `controller/LoginFilter.java`
- `dao/UserDAO.java`
- `login.jsp`
- `logout.jsp`

#### Mô tả chi tiết:

**A. LoginServlet.java - Xử lý đăng nhập**

```java
@WebServlet("/login")
public class LoginServlet extends HttpServlet
```

**Chức năng chính:**

1. **doGet()** - Hiển thị trang đăng nhập:
   - Kiểm tra cookie "rememberedUser" (Remember Me)
   - Nếu có cookie, tự động điền username vào form
   - Forward đến login.jsp

2. **doPost()** - Xử lý submit form đăng nhập:
   - Nhận username, password từ form
   - Gọi `userDao.checkLogin(username, password)` để kiểm tra
   - Nếu đúng:
     + Tạo Session và lưu username
     + Xử lý checkbox "Remember Me":
       * Nếu chọn: tạo Cookie lưu username (7 ngày)
       * Nếu không: xóa Cookie cũ
     + Redirect đến trang adminHome
   - Nếu sai:
     + Set attribute "error" 
     + Forward lại login.jsp với thông báo lỗi

**B. LoginFilter.java - Bảo vệ các trang yêu cầu đăng nhập**

```java
@WebFilter(urlPatterns = {"/protected/*", "/adminHome/*"})
public class LoginFilter implements Filter
```

**Chức năng:**
- Chặn các request đến URL pattern: /protected/*, /adminHome/*
- Kiểm tra Session có attribute "username" không
- Nếu có (đã đăng nhập): cho phép tiếp tục
- Nếu không: redirect về trang login

**C. UserDAO.java - Truy vấn database người dùng**

```java
public boolean checkLogin(String username, String password)
```

**Cách hoạt động:**
1. Tạo PreparedStatement với SQL:
   ```sql
   SELECT id FROM tbluser WHERE username = ? AND password = ?
   ```
2. Set parameters để tránh SQL Injection
3. Execute query
4. Nếu ResultSet có dữ liệu → return true (đăng nhập hợp lệ)
5. Ngược lại → return false

**⚠️ LƯU Ý BẢO MẬT:**
- Mật khẩu lưu dạng plain text (không mã hóa)
- Cần nâng cấp: hash password với BCrypt/PBKDF2

---

### 2.2. CHỨC NĂNG QUẢN LÝ TIN TỨC - ADMIN (News Management - CRUD)

#### Files liên quan:
- `controller/AdminHomeServlet.java`
- `dao/NewsDAO.java`
- `model/News.java`
- `list.jsp` (danh sách tin)
- `form.jsp` (thêm/sửa tin)
- `detail.jsp` (chi tiết tin)

#### Mô tả chi tiết:

**A. AdminHomeServlet.java - Controller quản lý tin tức**

**doGet()** - Xử lý các action dựa vào parameter "action":

1. **action=null hoặc "list"** (Mặc định - Hiển thị danh sách):
   ```java
   List<News> newsList = newsDao.getAllNews();
   req.setAttribute("newsList", newsList);
   req.getRequestDispatcher("list.jsp").forward(req, resp);
   ```
   - Lấy tất cả tin từ database
   - Gửi danh sách đến list.jsp để hiển thị

2. **action="create"** (Tạo tin mới):
   ```java
   req.getRequestDispatcher("form.jsp").forward(req, resp);
   ```
   - Hiển thị form trống để nhập tin mới

3. **action="edit"** (Sửa tin):
   ```java
   int idEdit = Integer.parseInt(idStr);
   News editNews = newsDao.getNewsById(idEdit);
   req.setAttribute("news", editNews);
   req.getRequestDispatcher("form.jsp").forward(req, resp);
   ```
   - Lấy tin theo id từ database
   - Gửi đến form.jsp (form sẽ có dữ liệu sẵn)

4. **action="delete"** (Xóa tin):
   ```java
   int idDelete = Integer.parseInt(idStr);
   newsDao.deleteNews(idDelete);
   resp.sendRedirect("adminHome");
   ```
   - Xóa tin theo id
   - Redirect về trang danh sách

5. **action="detail"** (Xem chi tiết):
   ```java
   int idDetail = Integer.parseInt(idStr);
   News detailNews = newsDao.getNewsById(idDetail);
   req.setAttribute("news", detailNews);
   req.getRequestDispatcher("detail.jsp").forward(req, resp);
   ```
   - Lấy tin theo id
   - Hiển thị trang detail.jsp

**doPost()** - Xử lý submit form (Thêm/Sửa tin):

```java
String idStr = req.getParameter("id");
String title = req.getParameter("title");
String content = req.getParameter("content");

if (idStr == null || idStr.isEmpty()) {
    // CREATE - Thêm mới
    News newNews = new News(title, content); 
    newsDao.addNews(newNews);
} else {
    // UPDATE - Cập nhật
    int id = Integer.parseInt(idStr);
    News updateNews = new News(id, title, content); 
    newsDao.updateNews(updateNews);
}
resp.sendRedirect("adminHome");
```

**B. NewsDAO.java - Data Access Object cho tin tức**

**1. getAllNews()** - Lấy tất cả tin:
```java
public List<News> getAllNews() {
    String sql = "SELECT * FROM tblnews ORDER BY id DESC";
    // Thực thi query và trả về List<News>
}
```

**2. getNewsById(int id)** - Lấy tin theo ID:
```java
public News getNewsById(int id) {
    String sql = "SELECT * FROM tblnews WHERE id = ?";
    // Sử dụng PreparedStatement để tránh SQL Injection
    stmt.setInt(1, id);
    // Trả về News object hoặc null
}
```

**3. addNews(News news)** - Thêm tin mới:
```java
public boolean addNews(News news) {
    String sql = "INSERT INTO tblnews (title, content) VALUES (?, ?)";
    stmt.setString(1, news.getTitle());
    stmt.setString(2, news.getContent());
    return stmt.executeUpdate() > 0;
}
```

**4. updateNews(News news)** - Cập nhật tin:
```java
public boolean updateNews(News news) {
    String sql = "UPDATE tblnews SET title = ?, content = ? WHERE id = ?";
    stmt.setString(1, news.getTitle());
    stmt.setString(2, news.getContent());
    stmt.setInt(3, news.getId());
    return stmt.executeUpdate() > 0;
}
```

**5. deleteNews(int id)** - Xóa tin:
```java
public boolean deleteNews(int id) {
    String sql = "DELETE FROM tblnews WHERE id = ?";
    stmt.setInt(1, id);
    return stmt.executeUpdate() > 0;
}
```

**C. News.java - Model đại diện cho tin tức**

```java
public class News {
    private int id;
    private String title;
    private String content;
    
    // Constructor cho INSERT (không có id)
    public News(String title, String content) {...}
    
    // Constructor cho SELECT/UPDATE (có id)
    public News(int id, String title, String content) {...}
    
    // Getters và Setters
}
```

---

### 2.3. CHỨC NĂNG HIỂN THỊ TIN TỨC - CLIENT (Public News Display)

#### Files liên quan:
- `controller/ClientHomeServlet.java`
- `index.jsp` (trang chủ khách hàng)
- `detail_client.jsp` (chi tiết tin cho khách)

#### Mô tả chi tiết:

**ClientHomeServlet.java**

```java
@WebServlet("/clientHome")
public class ClientHomeServlet extends HttpServlet
```

**doGet()** - Xử lý hiển thị cho phía khách hàng:

1. **action=null hoặc "list"** (Trang chủ):
   ```java
   List<News> newsList = newsDao.getAllNews();
   req.setAttribute("newsList", newsList);
   req.getRequestDispatcher("index.jsp").forward(req, resp);
   ```
   - Lấy tất cả tin tức
   - Hiển thị trên trang index.jsp (trang chủ)

2. **action="detail"** (Xem chi tiết tin):
   ```java
   int idDetail = Integer.parseInt(idStr);
   News detailNews = newsDao.getNewsById(idDetail);
   req.setAttribute("news", detailNews);
   req.getRequestDispatcher("detail_client.jsp").forward(req, resp);
   ```
   - Lấy tin theo id
   - Hiển thị chi tiết trên detail_client.jsp

**Đặc điểm:**
- Không cần đăng nhập (public)
- Chỉ có chức năng xem (READ-ONLY)
- Không có chức năng thêm/sửa/xóa

---

### 2.4. CÁC FILTER BẢO VỆ & XỬ LÝ

#### A. UTF8AndJSPBlockFilter.java
- Đặt encoding UTF-8 cho request/response
- Chặn truy cập trực tiếp các file JSP
- Áp dụng cho tất cả request (url-pattern: /*)

#### B. LoginFilter.java (Đã giải thích ở 2.1)

#### C. ExceptionHandlingFilter.java
- Xử lý ngoại lệ không kiểm soát được
- Redirect đến error.jsp khi có lỗi

---

### 2.5. KẾT NỐI DATABASE

**DatabaseConnection.java**

```java
public class DatabaseConnection {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/news_web_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "bacgiang@qlda2024";
    
    public static Connection getConnection() throws SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }
}
```

**Chức năng:**
- Cung cấp kết nối MySQL cho các DAO
- Sử dụng MySQL Connector/J driver
- Kết nối đến database: news_web_db

**Cấu trúc database hiện tại:**
```sql
-- Bảng tbluser (người dùng)
CREATE TABLE tbluser (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50),
    password VARCHAR(50)
);

-- Bảng tblnews (tin tức)
CREATE TABLE tblnews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    content TEXT
);
```

---

## 3. ĐỀ XUẤT PHÁT TRIỂN WEBSITE BÁN ĐỒ ĂN VẶT

### 3.1. PHÂN TÍCH YÊU CẦU

**Chuyển đổi từ Website Tin tức → Website Bán đồ ăn vặt**

**Cần thay đổi:**
- Model News → Product (Sản phẩm)
- Thêm các chức năng e-commerce:
  + Giỏ hàng (Shopping Cart)
  + Đơn hàng (Order Management)
  + Danh mục sản phẩm (Category)
  + Thanh toán (Payment)

---

### 3.2. ĐỀ XUẤT 4 CHỨC NĂNG CHO 4 THÀNH VIÊN

#### **THÀNH VIÊN 1: QUẢN LÝ SẢN PHẨM (Product Management)**

**Mô tả:**
- Thay thế chức năng quản lý tin tức bằng quản lý sản phẩm đồ ăn vặt
- CRUD đầy đủ cho sản phẩm

**Files cần tạo/chỉnh sửa:**
```
model/Product.java          (thay News.java)
dao/ProductDAO.java         (thay NewsDAO.java)
controller/AdminProductServlet.java  (thay AdminHomeServlet.java)
admin_products.jsp          (danh sách sản phẩm)
product_form.jsp            (thêm/sửa sản phẩm)
```

**Model Product.java:**
```java
public class Product {
    private int id;
    private String name;           // Tên sản phẩm
    private String description;    // Mô tả
    private double price;          // Giá
    private String image;          // Đường dẫn ảnh
    private int categoryId;        // ID danh mục
    private int stock;             // Số lượng tồn kho
    private Date createdDate;
    
    // Constructors, Getters, Setters
}
```

**ProductDAO.java - Các method:**
```java
// 1. Lấy tất cả sản phẩm
public List<Product> getAllProducts()

// 2. Lấy sản phẩm theo ID
public Product getProductById(int id)

// 3. Thêm sản phẩm mới
public boolean addProduct(Product product)

// 4. Cập nhật sản phẩm
public boolean updateProduct(Product product)

// 5. Xóa sản phẩm
public boolean deleteProduct(int id)

// 6. Lấy sản phẩm theo danh mục
public List<Product> getProductsByCategory(int categoryId)

// 7. Tìm kiếm sản phẩm theo tên
public List<Product> searchProducts(String keyword)
```

**Database Schema:**
```sql
CREATE TABLE tblproduct (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image VARCHAR(255),
    category_id INT,
    stock INT DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES tblcategory(id)
);
```

**AdminProductServlet.java - Các action:**
- **GET:**
  + `action=list`: Hiển thị danh sách sản phẩm
  + `action=create`: Hiển thị form thêm sản phẩm
  + `action=edit&id=X`: Hiển thị form sửa sản phẩm
  + `action=delete&id=X`: Xóa sản phẩm
  + `action=detail&id=X`: Xem chi tiết sản phẩm

- **POST:** 
  + Xử lý thêm/sửa sản phẩm từ form
  + Upload ảnh sản phẩm

**Giải thích code chi tiết:**

```java
@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    
    private ProductDAO productDao = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "list":
                // 1. Lấy danh sách sản phẩm từ database
                List<Product> products = productDao.getAllProducts();
                
                // 2. Đưa danh sách vào request scope
                req.setAttribute("products", products);
                
                // 3. Forward đến trang JSP hiển thị
                req.getRequestDispatcher("/admin_products.jsp")
                   .forward(req, resp);
                break;
                
            case "create":
                // Hiển thị form trống để thêm sản phẩm mới
                req.getRequestDispatcher("/product_form.jsp")
                   .forward(req, resp);
                break;
                
            case "edit":
                // 1. Lấy id từ parameter
                int editId = Integer.parseInt(req.getParameter("id"));
                
                // 2. Truy vấn sản phẩm từ database
                Product editProduct = productDao.getProductById(editId);
                
                // 3. Đưa vào request để JSP hiển thị
                req.setAttribute("product", editProduct);
                
                // 4. Forward đến form (form sẽ điền sẵn dữ liệu)
                req.getRequestDispatcher("/product_form.jsp")
                   .forward(req, resp);
                break;
                
            case "delete":
                // 1. Lấy id cần xóa
                int deleteId = Integer.parseInt(req.getParameter("id"));
                
                // 2. Gọi DAO xóa
                productDao.deleteProduct(deleteId);
                
                // 3. Redirect về trang danh sách
                resp.sendRedirect("products?action=list");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // 1. Lấy dữ liệu từ form
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        double price = Double.parseDouble(req.getParameter("price"));
        String image = req.getParameter("image");
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));
        int stock = Integer.parseInt(req.getParameter("stock"));
        
        // 2. Kiểm tra thêm mới hay cập nhật
        if (idStr == null || idStr.isEmpty()) {
            // THÊM MỚI
            Product newProduct = new Product(name, description, price, 
                                            image, categoryId, stock);
            productDao.addProduct(newProduct);
        } else {
            // CẬP NHẬT
            int id = Integer.parseInt(idStr);
            Product updateProduct = new Product(id, name, description, price,
                                               image, categoryId, stock);
            productDao.updateProduct(updateProduct);
        }
        
        // 3. Redirect về trang danh sách
        resp.sendRedirect("products?action=list");
    }
}
```

---

#### **THÀNH VIÊN 2: GIỎ HÀNG (Shopping Cart)**

**Mô tả:**
- Quản lý giỏ hàng cho khách hàng
- Thêm/xóa/cập nhật số lượng sản phẩm trong giỏ

**Files cần tạo:**
```
model/CartItem.java
model/Cart.java
controller/CartServlet.java
cart.jsp
```

**Model CartItem.java:**
```java
public class CartItem {
    private Product product;       // Sản phẩm
    private int quantity;          // Số lượng
    private double subtotal;       // Thành tiền
    
    // Constructor
    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        this.subtotal = product.getPrice() * quantity;
    }
    
    // Getters và Setters
    public void updateQuantity(int quantity) {
        this.quantity = quantity;
        this.subtotal = product.getPrice() * quantity;
    }
}
```

**Model Cart.java:**
```java
public class Cart {
    private Map<Integer, CartItem> items;  // Key: productId, Value: CartItem
    private double totalAmount;
    
    public Cart() {
        items = new HashMap<>();
        totalAmount = 0;
    }
    
    // 1. Thêm sản phẩm vào giỏ
    public void addItem(Product product, int quantity) {
        int productId = product.getId();
        
        if (items.containsKey(productId)) {
            // Sản phẩm đã có trong giỏ -> tăng số lượng
            CartItem item = items.get(productId);
            item.updateQuantity(item.getQuantity() + quantity);
        } else {
            // Sản phẩm mới -> thêm vào giỏ
            items.put(productId, new CartItem(product, quantity));
        }
        
        calculateTotal();
    }
    
    // 2. Xóa sản phẩm khỏi giỏ
    public void removeItem(int productId) {
        items.remove(productId);
        calculateTotal();
    }
    
    // 3. Cập nhật số lượng
    public void updateQuantity(int productId, int quantity) {
        if (items.containsKey(productId)) {
            if (quantity <= 0) {
                removeItem(productId);
            } else {
                items.get(productId).updateQuantity(quantity);
                calculateTotal();
            }
        }
    }
    
    // 4. Tính tổng tiền
    private void calculateTotal() {
        totalAmount = 0;
        for (CartItem item : items.values()) {
            totalAmount += item.getSubtotal();
        }
    }
    
    // 5. Lấy danh sách items
    public Collection<CartItem> getItems() {
        return items.values();
    }
    
    // 6. Làm rỗng giỏ hàng
    public void clear() {
        items.clear();
        totalAmount = 0;
    }
    
    // Getters
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public int getItemCount() {
        return items.size();
    }
}
```

**CartServlet.java:**
```java
@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    
    private ProductDAO productDao = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Lấy giỏ hàng từ Session
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        
        String action = req.getParameter("action");
        if (action == null) action = "view";
        
        switch (action) {
            case "view":
                // Hiển thị giỏ hàng
                req.getRequestDispatcher("cart.jsp").forward(req, resp);
                break;
                
            case "add":
                // Thêm sản phẩm vào giỏ
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                
                // Lấy thông tin sản phẩm từ database
                Product product = productDao.getProductById(productId);
                
                // Thêm vào giỏ hàng
                cart.addItem(product, quantity);
                
                // Redirect về trang giỏ hàng
                resp.sendRedirect("cart?action=view");
                break;
                
            case "remove":
                // Xóa sản phẩm khỏi giỏ
                int removeId = Integer.parseInt(req.getParameter("productId"));
                cart.removeItem(removeId);
                
                resp.sendRedirect("cart?action=view");
                break;
                
            case "update":
                // Cập nhật số lượng
                int updateId = Integer.parseInt(req.getParameter("productId"));
                int newQuantity = Integer.parseInt(req.getParameter("quantity"));
                
                cart.updateQuantity(updateId, newQuantity);
                
                resp.sendRedirect("cart?action=view");
                break;
                
            case "clear":
                // Làm rỗng giỏ hàng
                cart.clear();
                resp.sendRedirect("cart?action=view");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
```

**Giải thích chi tiết:**

1. **Giỏ hàng lưu ở đâu?**
   - Lưu trong Session (HttpSession)
   - Mỗi người dùng có một Session riêng
   - Session tồn tại trong suốt phiên làm việc

2. **Luồng hoạt động "Thêm vào giỏ":**
   ```
   Trang sản phẩm → Click "Thêm giỏ hàng" 
   → Gửi request: cart?action=add&productId=5&quantity=2
   → CartServlet xử lý:
      + Lấy Cart từ Session
      + Lấy Product từ database
      + Gọi cart.addItem(product, quantity)
      + Lưu lại Cart vào Session
      + Redirect đến trang giỏ hàng
   ```

3. **Ưu điểm lưu trong Session:**
   - Không cần database
   - Nhanh, dễ thao tác
   - Tự động hết hạn khi đóng browser

4. **Nhược điểm:**
   - Mất giỏ hàng khi Session hết hạn
   - Không lưu trữ lâu dài
   - (Có thể nâng cấp: lưu giỏ hàng vào database)

---

#### **THÀNH VIÊN 3: QUẢN LÝ ĐỬN HÀNG (Order Management)**

**Mô tả:**
- Xử lý đặt hàng từ giỏ hàng
- Quản lý trạng thái đơn hàng (Chờ xử lý, Đang giao, Hoàn thành, Hủy)
- Xem lịch sử đơn hàng

**Files cần tạo:**
```
model/Order.java
model/OrderItem.java
dao/OrderDAO.java
controller/OrderServlet.java
checkout.jsp                 (Thanh toán)
order_confirmation.jsp       (Xác nhận đơn)
order_history.jsp           (Lịch sử đơn hàng)
admin_orders.jsp            (Admin quản lý đơn)
```

**Model Order.java:**
```java
public class Order {
    private int id;
    private int userId;              // ID người đặt
    private Date orderDate;          // Ngày đặt
    private double totalAmount;      // Tổng tiền
    private String status;           // Trạng thái: PENDING, PROCESSING, DELIVERED, CANCELLED
    private String shippingAddress;  // Địa chỉ giao hàng
    private String phoneNumber;      // SĐT
    private String notes;            // Ghi chú
    
    // Constructors, Getters, Setters
}
```

**Model OrderItem.java:**
```java
public class OrderItem {
    private int id;
    private int orderId;        // ID đơn hàng
    private int productId;      // ID sản phẩm
    private String productName; // Tên sản phẩm (lưu lại để không bị ảnh hưởng khi sản phẩm thay đổi)
    private double price;       // Giá tại thời điểm đặt
    private int quantity;       // Số lượng
    private double subtotal;    // Thành tiền
    
    // Constructors, Getters, Setters
}
```

**Database Schema:**
```sql
CREATE TABLE tblorder (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'PENDING',
    shipping_address TEXT,
    phone_number VARCHAR(20),
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES tbluser(id)
);

CREATE TABLE tblorder_item (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    product_name VARCHAR(255),
    price DECIMAL(10,2),
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES tblorder(id),
    FOREIGN KEY (product_id) REFERENCES tblproduct(id)
);
```

**OrderDAO.java:**
```java
public class OrderDAO {
    
    // 1. Tạo đơn hàng mới (Transaction - quan trọng!)
    public int createOrder(Order order, List<OrderItem> items) {
        Connection conn = null;
        int orderId = -1;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            // BẮT ĐẦU TRANSACTION
            conn.setAutoCommit(false);
            
            // A. Insert vào bảng tblorder
            String orderSql = "INSERT INTO tblorder (user_id, total_amount, " +
                            "status, shipping_address, phone_number, notes) " +
                            "VALUES (?, ?, ?, ?, ?, ?)";
            
            PreparedStatement orderStmt = conn.prepareStatement(orderSql, 
                                         Statement.RETURN_GENERATED_KEYS);
            
            orderStmt.setInt(1, order.getUserId());
            orderStmt.setDouble(2, order.getTotalAmount());
            orderStmt.setString(3, order.getStatus());
            orderStmt.setString(4, order.getShippingAddress());
            orderStmt.setString(5, order.getPhoneNumber());
            orderStmt.setString(6, order.getNotes());
            
            orderStmt.executeUpdate();
            
            // Lấy ID vừa tạo
            ResultSet rs = orderStmt.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
            
            // B. Insert các items vào bảng tblorder_item
            String itemSql = "INSERT INTO tblorder_item (order_id, product_id, " +
                           "product_name, price, quantity, subtotal) " +
                           "VALUES (?, ?, ?, ?, ?, ?)";
            
            PreparedStatement itemStmt = conn.prepareStatement(itemSql);
            
            for (OrderItem item : items) {
                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, item.getProductId());
                itemStmt.setString(3, item.getProductName());
                itemItemStmt.setDouble(4, item.getPrice());
                itemStmt.setInt(5, item.getQuantity());
                itemStmt.setDouble(6, item.getSubtotal());
                
                itemStmt.addBatch();  // Thêm vào batch
            }
            
            itemStmt.executeBatch();  // Thực thi batch
            
            // COMMIT TRANSACTION
            conn.commit();
            
        } catch (SQLException e) {
            // Có lỗi → ROLLBACK
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return orderId;
    }
    
    // 2. Lấy đơn hàng theo ID
    public Order getOrderById(int orderId) {
        // SQL JOIN để lấy thông tin đầy đủ
        String sql = "SELECT * FROM tblorder WHERE id = ?";
        // ... thực thi query và trả về Order
    }
    
    // 3. Lấy danh sách OrderItem của một đơn hàng
    public List<OrderItem> getOrderItems(int orderId) {
        String sql = "SELECT * FROM tblorder_item WHERE order_id = ?";
        // ... thực thi query và trả về List<OrderItem>
    }
    
    // 4. Lấy đơn hàng theo user
    public List<Order> getOrdersByUserId(int userId) {
        String sql = "SELECT * FROM tblorder WHERE user_id = ? " +
                    "ORDER BY order_date DESC";
        // ... thực thi query
    }
    
    // 5. Lấy tất cả đơn hàng (Admin)
    public List<Order> getAllOrders() {
        String sql = "SELECT * FROM tblorder ORDER BY order_date DESC";
        // ... thực thi query
    }
    
    // 6. Cập nhật trạng thái đơn hàng
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE tblorder SET status = ? WHERE id = ?";
        // ... thực thi update
    }
    
    // 7. Hủy đơn hàng
    public boolean cancelOrder(int orderId) {
        return updateOrderStatus(orderId, "CANCELLED");
    }
}
```

**OrderServlet.java:**
```java
@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    
    private OrderDAO orderDao = new OrderDAO();
    private ProductDAO productDao = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        if (action == null) action = "history";
        
        switch (action) {
            case "checkout":
                // Hiển thị trang thanh toán
                req.getRequestDispatcher("checkout.jsp").forward(req, resp);
                break;
                
            case "history":
                // Lịch sử đơn hàng của user
                HttpSession session = req.getSession();
                Integer userId = (Integer) session.getAttribute("userId");
                
                if (userId == null) {
                    resp.sendRedirect("login");
                    return;
                }
                
                List<Order> orders = orderDao.getOrdersByUserId(userId);
                req.setAttribute("orders", orders);
                req.getRequestDispatcher("order_history.jsp").forward(req, resp);
                break;
                
            case "detail":
                // Chi tiết đơn hàng
                int orderId = Integer.parseInt(req.getParameter("id"));
                Order order = orderDao.getOrderById(orderId);
                List<OrderItem> items = orderDao.getOrderItems(orderId);
                
                req.setAttribute("order", order);
                req.setAttribute("items", items);
                req.getRequestDispatcher("order_detail.jsp").forward(req, resp);
                break;
                
            case "cancel":
                // Hủy đơn hàng
                int cancelId = Integer.parseInt(req.getParameter("id"));
                orderDao.cancelOrder(cancelId);
                resp.sendRedirect("order?action=history");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        
        if ("place".equals(action)) {
            // XỬ LÝ ĐẶT HÀNG
            
            // 1. Lấy thông tin từ form
            String shippingAddress = req.getParameter("address");
            String phoneNumber = req.getParameter("phone");
            String notes = req.getParameter("notes");
            
            // 2. Lấy giỏ hàng từ Session
            HttpSession session = req.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            Integer userId = (Integer) session.getAttribute("userId");
            
            if (cart == null || cart.getItems().isEmpty()) {
                resp.sendRedirect("cart");
                return;
            }
            
            // 3. Tạo Order object
            Order order = new Order();
            order.setUserId(userId);
            order.setTotalAmount(cart.getTotalAmount());
            order.setStatus("PENDING");
            order.setShippingAddress(shippingAddress);
            order.setPhoneNumber(phoneNumber);
            order.setNotes(notes);
            
            // 4. Tạo danh sách OrderItem từ CartItem
            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem cartItem : cart.getItems()) {
                OrderItem item = new OrderItem();
                item.setProductId(cartItem.getProduct().getId());
                item.setProductName(cartItem.getProduct().getName());
                item.setPrice(cartItem.getProduct().getPrice());
                item.setQuantity(cartItem.getQuantity());
                item.setSubtotal(cartItem.getSubtotal());
                
                orderItems.add(item);
            }
            
            // 5. Lưu đơn hàng vào database (Transaction)
            int orderId = orderDao.createOrder(order, orderItems);
            
            // 6. Xóa giỏ hàng sau khi đặt hàng thành công
            cart.clear();
            
            // 7. Redirect đến trang xác nhận
            resp.sendRedirect("order_confirmation.jsp?id=" + orderId);
        }
    }
}
```

**Giải thích chi tiết Transaction:**

**Tại sao cần Transaction?**
- Đặt hàng cần 2 bước:
  1. Insert vào bảng `tblorder`
  2. Insert nhiều records vào `tblorder_item`

- **Vấn đề nếu không dùng Transaction:**
  + Bước 1 thành công, bước 2 lỗi
  + → Có Order nhưng không có items
  + → Dữ liệu không nhất quán!

- **Transaction giải quyết:**
  + Cả 2 bước phải thành công
  + Nếu 1 bước lỗi → Rollback tất cả
  + → Đảm bảo tính toàn vẹn dữ liệu

**Cách hoạt động:**
```java
conn.setAutoCommit(false);  // Tắt auto-commit
try {
    // Thực hiện các lệnh SQL
    conn.commit();  // Commit nếu thành công
} catch (Exception e) {
    conn.rollback();  // Rollback nếu lỗi
}
```

---

#### **THÀNH VIÊN 4: QUẢN LÝ DANH MỤC & TÌM KIẾM (Category & Search)**

**Mô tả:**
- Quản lý danh mục sản phẩm (Snack, Kẹo, Bánh...)
- Lọc sản phẩm theo danh mục
- Tìm kiếm sản phẩm
- Hiển thị sản phẩm cho khách hàng

**Files cần tạo:**
```
model/Category.java
dao/CategoryDAO.java
controller/CategoryServlet.java
controller/ClientProductServlet.java
admin_categories.jsp         (Admin quản lý danh mục)
category_form.jsp            (Thêm/sửa danh mục)
client_products.jsp          (Khách xem sản phẩm)
product_detail.jsp           (Chi tiết sản phẩm)
```

**Model Category.java:**
```java
public class Category {
    private int id;
    private String name;        // Tên danh mục
    private String description; // Mô tả
    private String image;       // Ảnh đại diện
    
    // Constructors, Getters, Setters
}
```

**Database Schema:**
```sql
CREATE TABLE tblcategory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image VARCHAR(255)
);
```

**CategoryDAO.java:**
```java
public class CategoryDAO {
    
    // 1. Lấy tất cả danh mục
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM tblcategory ORDER BY name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("image")
                );
                categories.add(category);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
    
    // 2. Lấy danh mục theo ID
    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM tblcategory WHERE id = ?";
        // ... tương tự
    }
    
    // 3. Thêm danh mục
    public boolean addCategory(Category category) {
        String sql = "INSERT INTO tblcategory (name, description, image) " +
                    "VALUES (?, ?, ?)";
        // ... tương tự
    }
    
    // 4. Cập nhật danh mục
    public boolean updateCategory(Category category) {
        String sql = "UPDATE tblcategory SET name = ?, description = ?, " +
                    "image = ? WHERE id = ?";
        // ... tương tự
    }
    
    // 5. Xóa danh mục
    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM tblcategory WHERE id = ?";
        // ... tương tự
    }
}
```

**CategoryServlet.java (Admin quản lý danh mục):**
```java
@WebServlet("/admin/categories")
public class CategoryServlet extends HttpServlet {
    
    private CategoryDAO categoryDao = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "list":
                List<Category> categories = categoryDao.getAllCategories();
                req.setAttribute("categories", categories);
                req.getRequestDispatcher("/admin_categories.jsp")
                   .forward(req, resp);
                break;
                
            case "create":
                req.getRequestDispatcher("/category_form.jsp")
                   .forward(req, resp);
                break;
                
            case "edit":
                int editId = Integer.parseInt(req.getParameter("id"));
                Category editCategory = categoryDao.getCategoryById(editId);
                req.setAttribute("category", editCategory);
                req.getRequestDispatcher("/category_form.jsp")
                   .forward(req, resp);
                break;
                
            case "delete":
                int deleteId = Integer.parseInt(req.getParameter("id"));
                categoryDao.deleteCategory(deleteId);
                resp.sendRedirect("categories?action=list");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String image = req.getParameter("image");
        
        if (idStr == null || idStr.isEmpty()) {
            // Thêm mới
            Category newCategory = new Category(name, description, image);
            categoryDao.addCategory(newCategory);
        } else {
            // Cập nhật
            int id = Integer.parseInt(idStr);
            Category updateCategory = new Category(id, name, description, image);
            categoryDao.updateCategory(updateCategory);
        }
        
        resp.sendRedirect("categories?action=list");
    }
}
```

**ClientProductServlet.java (Khách hàng xem sản phẩm):**
```java
@WebServlet("/products")
public class ClientProductServlet extends HttpServlet {
    
    private ProductDAO productDao = new ProductDAO();
    private CategoryDAO categoryDao = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "list":
                // Lấy tham số lọc và tìm kiếm
                String categoryIdStr = req.getParameter("categoryId");
                String keyword = req.getParameter("keyword");
                
                List<Product> products;
                
                if (keyword != null && !keyword.isEmpty()) {
                    // TÌM KIẾM
                    products = productDao.searchProducts(keyword);
                    req.setAttribute("keyword", keyword);
                    
                } else if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                    // LỌC THEO DANH MỤC
                    int categoryId = Integer.parseInt(categoryIdStr);
                    products = productDao.getProductsByCategory(categoryId);
                    
                    Category category = categoryDao.getCategoryById(categoryId);
                    req.setAttribute("category", category);
                    
                } else {
                    // HIỂN THỊ TẤT CẢ
                    products = productDao.getAllProducts();
                }
                
                // Lấy danh sách danh mục cho sidebar
                List<Category> categories = categoryDao.getAllCategories();
                
                req.setAttribute("products", products);
                req.setAttribute("categories", categories);
                req.getRequestDispatcher("/client_products.jsp")
                   .forward(req, resp);
                break;
                
            case "detail":
                // Xem chi tiết sản phẩm
                int productId = Integer.parseInt(req.getParameter("id"));
                Product product = productDao.getProductById(productId);
                
                req.setAttribute("product", product);
                req.getRequestDispatcher("/product_detail.jsp")
                   .forward(req, resp);
                break;
        }
    }
}
```

**Bổ sung vào ProductDAO.java:**
```java
// 6. Lấy sản phẩm theo danh mục
public List<Product> getProductsByCategory(int categoryId) {
    List<Product> products = new ArrayList<>();
    String sql = "SELECT * FROM tblproduct WHERE category_id = ? " +
                "ORDER BY created_date DESC";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, categoryId);
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image"),
                    rs.getInt("category_id"),
                    rs.getInt("stock")
                );
                products.add(product);
            }
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return products;
}

// 7. Tìm kiếm sản phẩm theo tên
public List<Product> searchProducts(String keyword) {
    List<Product> products = new ArrayList<>();
    
    // Sử dụng LIKE để tìm kiếm gần đúng
    String sql = "SELECT * FROM tblproduct " +
                "WHERE name LIKE ? OR description LIKE ? " +
                "ORDER BY name";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        // Thêm % để tìm kiếm anywhere trong chuỗi
        String searchPattern = "%" + keyword + "%";
        stmt.setString(1, searchPattern);
        stmt.setString(2, searchPattern);
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image"),
                    rs.getInt("category_id"),
                    rs.getInt("stock")
                );
                products.add(product);
            }
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return products;
}
```

**Giải thích chi tiết tìm kiếm:**

**SQL LIKE:**
```sql
-- Tìm sản phẩm có tên hoặc mô tả chứa từ khóa
WHERE name LIKE '%keyword%' OR description LIKE '%keyword%'

Ví dụ: keyword = "kẹo"
- Khớp: "Kẹo dẻo", "Kẹo cao su", "Bánh kẹo"
- Không khớp: "Bánh quy", "Snack"
```

**PreparedStatement với LIKE:**
```java
String searchPattern = "%" + keyword + "%";
stmt.setString(1, searchPattern);

// SQL: WHERE name LIKE ?
// Giá trị: "%kẹo%"
```

**Luồng hoạt động:**
1. User nhập từ khóa vào ô search
2. Submit form → `products?action=list&keyword=kẹo`
3. Servlet nhận keyword
4. Gọi `productDao.searchProducts("kẹo")`
5. DAO thực thi query LIKE
6. Trả về danh sách sản phẩm khớp
7. Hiển thị kết quả trên JSP

---

## 4. CẤU TRÚC DATABASE HOÀN CHỈNH

```sql
-- 1. Bảng người dùng
CREATE TABLE tbluser (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,  -- Nên hash password
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    role VARCHAR(20) DEFAULT 'CUSTOMER',  -- ADMIN, CUSTOMER
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng danh mục
CREATE TABLE tblcategory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image VARCHAR(255)
);

-- 3. Bảng sản phẩm
CREATE TABLE tblproduct (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image VARCHAR(255),
    category_id INT,
    stock INT DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES tblcategory(id) ON DELETE SET NULL
);

-- 4. Bảng đơn hàng
CREATE TABLE tblorder (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',  -- PENDING, PROCESSING, DELIVERED, CANCELLED
    shipping_address TEXT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES tbluser(id) ON DELETE CASCADE
);

-- 5. Bảng chi tiết đơn hàng
CREATE TABLE tblorder_item (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    product_name VARCHAR(255),  -- Lưu tên để không bị ảnh hưởng khi sản phẩm đổi tên
    price DECIMAL(10,2),        -- Giá tại thời điểm đặt
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES tblorder(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES tblproduct(id) ON DELETE SET NULL
);

-- Index để tăng tốc query
CREATE INDEX idx_product_category ON tblproduct(category_id);
CREATE INDEX idx_order_user ON tblorder(user_id);
CREATE INDEX idx_order_status ON tblorder(status);
CREATE INDEX idx_orderitem_order ON tblorder_item(order_id);
```

---

## 5. PHÂN CHIA CÔNG VIỆC CHI TIẾT

### **THÀNH VIÊN 1: QUẢN LÝ SẢN PHẨM**
**Nhiệm vụ:**
- Tạo model Product
- Tạo ProductDAO với đầy đủ CRUD + filter category + search
- Tạo AdminProductServlet xử lý các action
- Thiết kế giao diện admin_products.jsp, product_form.jsp
- Test chức năng thêm/sửa/xóa sản phẩm

**Deliverables:**
- 1 Model class
- 1 DAO class
- 1 Servlet class
- 2 JSP files
- SQL script tạo bảng tblproduct

---

### **THÀNH VIÊN 2: GIỎ HÀNG**
**Nhiệm vụ:**
- Tạo model CartItem và Cart
- Tạo CartServlet xử lý thêm/xóa/cập nhật
- Thiết kế giao diện cart.jsp
- Tích hợp nút "Thêm vào giỏ" vào trang sản phẩm
- Test chức năng giỏ hàng

**Deliverables:**
- 2 Model classes
- 1 Servlet class
- 1 JSP file
- Không cần SQL (lưu trong Session)

---

### **THÀNH VIÊN 3: QUẢN LÝ ĐƠN HÀNG**
**Nhiệm vụ:**
- Tạo model Order và OrderItem
- Tạo OrderDAO với Transaction handling
- Tạo OrderServlet xử lý đặt hàng và xem lịch sử
- Thiết kế giao diện checkout.jsp, order_confirmation.jsp, order_history.jsp
- Test luồng đặt hàng end-to-end

**Deliverables:**
- 2 Model classes
- 1 DAO class
- 1 Servlet class
- 3 JSP files
- SQL script tạo bảng tblorder và tblorder_item

---

### **THÀNH VIÊN 4: DANH MỤC & TÌM KIẾM**
**Nhiệm vụ:**
- Tạo model Category
- Tạo CategoryDAO
- Tạo CategoryServlet (Admin) và ClientProductServlet (Client)
- Thiết kế giao diện admin_categories.jsp, client_products.jsp, product_detail.jsp
- Bổ sung search và filter vào ProductDAO
- Test chức năng lọc và tìm kiếm

**Deliverables:**
- 1 Model class
- 1 DAO class
- 2 Servlet classes
- 3 JSP files
- SQL script tạo bảng tblcategory

---

## 6. LỘ TRÌNH THỰC HIỆN

### **Giai đoạn 1: Setup (Tuần 1)**
- Tất cả thành viên: Setup project, database
- Cập nhật DatabaseConnection với database mới
- Tạo các bảng database

### **Giai đoạn 2: Phát triển song song (Tuần 2-3)**
- Mỗi thành viên làm chức năng của mình
- Daily standup để sync tiến độ

### **Giai đoạn 3: Tích hợp (Tuần 4)**
- Tích hợp các module lại với nhau
- Xử lý các dependency giữa các chức năng
- Testing tổng thể

### **Giai đoạn 4: Hoàn thiện (Tuần 5)**
- Fix bugs
- Cải thiện giao diện
- Chuẩn bị demo và tài liệu

---

## 7. DEPENDENCIES GIỮA CÁC CHỨC NĂNG

```
Thành viên 4 (Category) → Thành viên 1 (Product)
  └─> Category phải có trước để Product tham chiếu

Thành viên 1 (Product) → Thành viên 2 (Cart)
  └─> Product phải có để thêm vào giỏ

Thành viên 2 (Cart) → Thành viên 3 (Order)
  └─> Giỏ hàng phải có để tạo đơn hàng
```

**Giải pháp:**
- Tạo dữ liệu test/mock để làm việc song song
- Thành viên 4 hoàn thành Category trước để người khác dùng

---

## 8. CÁC CHỨC NĂNG BỔ SUNG (Nếu còn thời gian)

1. **Đăng ký tài khoản**
2. **Upload ảnh sản phẩm**
3. **Phân trang (Pagination)**
4. **Sắp xếp sản phẩm** (giá, tên, mới nhất)
5. **Đánh giá & bình luận sản phẩm**
6. **Báo cáo doanh thu (Admin)**
7. **Quản lý kho hàng**
8. **Email thông báo đơn hàng**
9. **Payment gateway integration**
10. **Responsive design (Mobile-friendly)**

---

## 9. KIẾN THỨC CẦN HỌC THÊM

1. **PreparedStatement** - Tránh SQL Injection
2. **Transaction** - Đảm bảo tính toàn vẹn dữ liệu
3. **Session Management** - Lưu trữ giỏ hàng, user
4. **Cookie** - Remember Me
5. **Filter** - Bảo mật, encoding
6. **Foreign Key** - Quan hệ giữa các bảng
7. **JOIN query** - Truy vấn nhiều bảng
8. **Exception Handling** - Xử lý lỗi
9. **MVC Pattern** - Tổ chức code rõ ràng

---

## 10. GỢI Ý CÁCH GIẢI THÍCH CODE

**Khi trình bày, mỗi thành viên nên:**

1. **Giới thiệu chức năng:**
   - Chức năng làm gì?
   - Tại sao cần chức năng này?

2. **Giải thích các thành phần:**
   - Model: Đại diện cho dữ liệu gì?
   - DAO: Các method làm gì? SQL như thế nào?
   - Servlet: Xử lý request ra sao? doGet vs doPost?
   - JSP: Hiển thị gì? Nhận dữ liệu từ đâu?

3. **Luồng hoạt động:**
   - User click vào đâu?
   - Request được gửi như thế nào?
   - Server xử lý ra sao?
   - Response trả về gì?

4. **Demo thực tế:**
   - Chạy chương trình
   - Thao tác trực tiếp
   - Kiểm tra database

5. **Xử lý lỗi:**
   - Trường hợp nào có thể lỗi?
   - Xử lý như thế nào?

---

## KẾT LUẬN

Source code hiện tại đã có nền tảng vững chắc:
- ✅ Cấu trúc MVC rõ ràng
- ✅ Kết nối database MySQL
- ✅ Authentication & Authorization
- ✅ CRUD operations

**Chuyển đổi sang website bán đồ ăn vặt:**
- 🔄 Thay đổi model (News → Product)
- ➕ Thêm giỏ hàng (Session-based)
- ➕ Thêm quản lý đơn hàng (Transaction)
- ➕ Thêm danh mục & tìm kiếm

**Phân công 4 người hợp lý, mỗi người 1 module độc lập!**

