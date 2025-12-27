# TÀI LIỆU TOÀN TẬP: PHÂN TÍCH, ĐỀ XUẤT VÀ HƯỚNG DẪN CODE CHI TIẾT
## Website Bán Đồ Ăn Vặt - Phân Công 4 Thành Viên

---

## 📋 MỤC LỤC

### PHẦN 1: PHÂN TÍCH SOURCE CODE HIỆN CÓ
1.1. Tổng quan kiến trúc hệ thống  
1.2. Phân tích các Layer (Model - DAO - Servlet - JSP)  
1.3. Luồng xử lý HTTP Request-Response  
1.4. Phân tích chức năng hiện có  
1.5. Đánh giá điểm mạnh và hạn chế  

### PHẦN 2: ĐỀ XUẤT CHỨC NĂNG MỚI
2.1. Danh sách chức năng cho Website Bán Đồ Ăn Vặt  
2.2. Thiết kế Database (6 bảng chính)  
2.3. Use Case Diagram  
2.4. Sitemap & Navigation Flow  

### PHẦN 3: PHÂN CÔNG 4 THÀNH VIÊN
3.1. **Thành viên 1 - QUẢN LÝ SẢN PHẨM (Products Management)**  
3.2. **Thành viên 2 - GIỎ HÀNG (Shopping Cart)**  
3.3. **Thành viên 3 - ĐƠN HÀNG (Orders Management)**  
3.4. **Thành viên 4 - DANH MỤC & TÌM KIẾM (Categories & Search)**  

### PHẦN 4: GIẢI THÍCH MÃ CHI TIẾT
4.1. Setup Database & JDBC Connection  
4.2. Xây dựng Model Classes (Entity)  
4.3. Xây dựng DAO Layer (Data Access Object)  
4.4. Xây dựng Servlet Layer (Controller)  
4.5. Xây dựng JSP Layer (View)  
4.6. Session & Cookie Management  
4.7. Filter & Security  

---

# PHẦN 1: PHÂN TÍCH SOURCE CODE HIỆN CÓ

## 1.1. Tổng quan kiến trúc hệ thống

### Mô hình MVC (Model-View-Controller)

```
┌─────────────────────────────────────────────────┐
│              CLIENT (Browser)                    │
│          http://localhost:8080/news              │
└───────────────────┬─────────────────────────────┘
                    │ HTTP Request
                    ▼
┌─────────────────────────────────────────────────┐
│          WEB SERVER (Tomcat)                     │
│  ┌──────────────────────────────────────────┐   │
│  │     FILTER (LoginFilter, EncodingFilter) │   │
│  │  - Kiểm tra session                      │   │
│  │  - Xử lý encoding UTF-8                  │   │
│  └──────────────┬───────────────────────────┘   │
│                 │                                │
│                 ▼                                │
│  ┌──────────────────────────────────────────┐   │
│  │       SERVLET (Controller)               │   │
│  │  - NewsServlet                           │   │
│  │  - LoginServlet                          │   │
│  │  - LogoutServlet                         │   │
│  └──────────────┬───────────────────────────┘   │
│                 │                                │
│                 ▼                                │
│  ┌──────────────────────────────────────────┐   │
│  │         DAO (Data Access Object)         │   │
│  │  - NewsDAO                               │   │
│  │  - UserDAO                               │   │
│  │  - CategoryDAO                           │   │
│  └──────────────┬───────────────────────────┘   │
│                 │                                │
│                 ▼                                │
│  ┌──────────────────────────────────────────┐   │
│  │         DATABASE (MySQL)                 │   │
│  │  - news                                  │   │
│  │  - users                                 │   │
│  │  - categories                            │   │
│  └──────────────────────────────────────────┘   │
└─────────────────┬───────────────────────────────┘
                  │ HTTP Response
                  ▼
┌─────────────────────────────────────────────────┐
│              VIEW (JSP)                          │
│  - list.jsp, detail.jsp, login.jsp              │
└─────────────────────────────────────────────────┘
```

### Cấu trúc thư mục Project

```
DemoNewsWeb_Login_Filter_MySQL/
│
├── src/
│   ├── model/
│   │   ├── News.java           # Model: Tin tức
│   │   ├── User.java           # Model: Người dùng
│   │   └── Category.java       # Model: Danh mục
│   │
│   ├── dao/
│   │   ├── NewsDAO.java        # DAO: CRUD tin tức
│   │   ├── UserDAO.java        # DAO: Xác thực user
│   │   └── CategoryDAO.java    # DAO: Quản lý danh mục
│   │
│   ├── servlet/
│   │   ├── NewsServlet.java    # Controller: Xử lý tin tức
│   │   ├── LoginServlet.java   # Controller: Đăng nhập
│   │   └── LogoutServlet.java  # Controller: Đăng xuất
│   │
│   ├── filter/
│   │   ├── LoginFilter.java    # Filter: Kiểm tra đăng nhập
│   │   └── EncodingFilter.java # Filter: UTF-8 encoding
│   │
│   └── util/
│       └── DBConnection.java   # Utility: Kết nối DB
│
└── WebContent/
    ├── WEB-INF/
    │   ├── web.xml             # Cấu hình servlet mapping
    │   └── lib/
    │       ├── mysql-connector.jar
    │       └── jstl-1.2.jar
    │
    ├── views/
    │   ├── list.jsp            # View: Danh sách tin
    │   ├── detail.jsp          # View: Chi tiết tin
    │   ├── form.jsp            # View: Form thêm/sửa
    │   └── login.jsp           # View: Đăng nhập
    │
    ├── css/
    │   └── style.css
    │
    ├── js/
    │   └── script.js
    │
    └── index.html
```

---

## 1.2. Phân tích các Layer chi tiết

### 🔹 **MODEL LAYER** (Entity / POJO)

#### **News.java**
```java
package model;

public class News {
    // Thuộc tính (Attributes)
    private int newsId;           // ID tin tức (Primary Key)
    private String title;         // Tiêu đề
    private String content;       // Nội dung
    private String imagePath;     // Đường dẫn ảnh
    private int categoryId;       // ID danh mục (Foreign Key)
    private String author;        // Tác giả
    private Date createdDate;     // Ngày tạo

    // Constructor đầy đủ
    public News(int newsId, String title, String content, 
                String imagePath, int categoryId, String author, Date createdDate) {
        this.newsId = newsId;
        this.title = title;
        this.content = content;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
        this.author = author;
        this.createdDate = createdDate;
    }

    // Constructor không có newsId (dùng cho INSERT)
    public News(String title, String content, String imagePath, 
                int categoryId, String author) {
        this.title = title;
        this.content = content;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
        this.author = author;
    }

    // Getter và Setter
    public int getNewsId() { return newsId; }
    public void setNewsId(int newsId) { this.newsId = newsId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    // ... các getter/setter khác
}
```

**📝 Giải thích:**
- **Model** là đại diện cho 1 bản ghi (row) trong database
- Mỗi thuộc tính (field) tương ứng với 1 cột (column) trong bảng
- Constructor dùng để khởi tạo object khi đọc từ DB hoặc tạo mới
- Getter/Setter để truy cập và thay đổi giá trị thuộc tính

---

### 🔹 **DAO LAYER** (Data Access Object)

#### **NewsDAO.java**
```java
package dao;

import java.sql.*;
import java.util.*;
import model.News;
import util.DBConnection;

public class NewsDAO {
    private Connection conn;

    // Constructor: Lấy kết nối DB
    public NewsDAO() {
        this.conn = DBConnection.getConnection();
    }

    // 1️⃣ Lấy tất cả tin tức
    public List<News> getAllNews() {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news ORDER BY created_date DESC";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                News news = new News(
                    rs.getInt("news_id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getString("author"),
                    rs.getDate("created_date")
                );
                newsList.add(news);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newsList;
    }

    // 2️⃣ Lấy tin theo ID
    public News getNewsById(int newsId) {
        String sql = "SELECT * FROM news WHERE news_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, newsId);  // Gán tham số ? thứ 1
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new News(
                    rs.getInt("news_id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getString("author"),
                    rs.getDate("created_date")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3️⃣ Thêm tin mới
    public boolean addNews(News news) {
        String sql = "INSERT INTO news (title, content, image_path, category_id, author) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, news.getTitle());
            stmt.setString(2, news.getContent());
            stmt.setString(3, news.getImagePath());
            stmt.setInt(4, news.getCategoryId());
            stmt.setString(5, news.getAuthor());

            int rows = stmt.executeUpdate();  // Trả về số dòng bị ảnh hưởng
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4️⃣ Cập nhật tin
    public boolean updateNews(News news) {
        String sql = "UPDATE news SET title=?, content=?, image_path=?, category_id=?, author=? " +
                     "WHERE news_id=?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, news.getTitle());
            stmt.setString(2, news.getContent());
            stmt.setString(3, news.getImagePath());
            stmt.setInt(4, news.getCategoryId());
            stmt.setString(5, news.getAuthor());
            stmt.setInt(6, news.getNewsId());

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5️⃣ Xóa tin
    public boolean deleteNews(int newsId) {
        String sql = "DELETE FROM news WHERE news_id=?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, newsId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6️⃣ Tìm kiếm tin theo keyword
    public List<News> searchNews(String keyword) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM news WHERE title LIKE ? OR content LIKE ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                News news = new News(
                    rs.getInt("news_id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getString("author"),
                    rs.getDate("created_date")
                );
                newsList.add(news);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newsList;
    }
}
```

**📝 Giải thích DAO Pattern:**

1. **Tách biệt logic truy cập database** khỏi business logic
2. **PreparedStatement** ngăn chặn SQL Injection:
   ```java
   // ❌ KHÔNG AN TOÀN
   String sql = "SELECT * FROM news WHERE news_id = " + newsId;
   
   // ✅ AN TOÀN
   String sql = "SELECT * FROM news WHERE news_id = ?";
   stmt.setInt(1, newsId);
   ```
3. **CRUD Operations**:
   - **Create**: `INSERT INTO ...`
   - **Read**: `SELECT * FROM ...`
   - **Update**: `UPDATE ... SET ...`
   - **Delete**: `DELETE FROM ...`

---

### 🔹 **SERVLET LAYER** (Controller)

#### **NewsServlet.java**
```java
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import dao.NewsDAO;
import model.News;

public class NewsServlet extends HttpServlet {
    private NewsDAO newsDAO;

    @Override
    public void init() {
        newsDAO = new NewsDAO();  // Khởi tạo DAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";  // Mặc định hiển thị danh sách
        }

        switch (action) {
            case "list":
                listNews(request, response);
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
                deleteNews(request, response);
                break;
            default:
                listNews(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertNews(request, response);
                break;
            case "update":
                updateNews(request, response);
                break;
            default:
                listNews(request, response);
        }
    }

    // 📋 Hiển thị danh sách tin
    private void listNews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<News> newsList = newsDAO.getAllNews();
        request.setAttribute("newsList", newsList);  // Gửi dữ liệu sang JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/list.jsp");
        dispatcher.forward(request, response);
    }

    // 🔍 Hiển thị chi tiết tin
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int newsId = Integer.parseInt(request.getParameter("id"));
        News news = newsDAO.getNewsById(newsId);
        request.setAttribute("news", news);
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/detail.jsp");
        dispatcher.forward(request, response);
    }

    // ➕ Hiển thị form thêm tin
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/form.jsp");
        dispatcher.forward(request, response);
    }

    // ✏️ Hiển thị form sửa tin
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int newsId = Integer.parseInt(request.getParameter("id"));
        News news = newsDAO.getNewsById(newsId);
        request.setAttribute("news", news);
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/form.jsp");
        dispatcher.forward(request, response);
    }

    // 💾 Thêm tin mới
    private void insertNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String imagePath = request.getParameter("imagePath");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String author = request.getParameter("author");

        News newNews = new News(title, content, imagePath, categoryId, author);
        boolean success = newsDAO.addNews(newNews);

        if (success) {
            response.sendRedirect("news?action=list");  // Redirect về danh sách
        } else {
            response.getWriter().println("Thêm tin thất bại!");
        }
    }

    // 🔄 Cập nhật tin
    private void updateNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int newsId = Integer.parseInt(request.getParameter("newsId"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String imagePath = request.getParameter("imagePath");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String author = request.getParameter("author");

        News news = new News(newsId, title, content, imagePath, categoryId, author, null);
        boolean success = newsDAO.updateNews(news);

        if (success) {
            response.sendRedirect("news?action=list");
        } else {
            response.getWriter().println("Cập nhật tin thất bại!");
        }
    }

    // ❌ Xóa tin
    private void deleteNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int newsId = Integer.parseInt(request.getParameter("id"));
        boolean success = newsDAO.deleteNews(newsId);

        if (success) {
            response.sendRedirect("news?action=list");
        } else {
            response.getWriter().println("Xóa tin thất bại!");
        }
    }
}
```

**📝 Giải thích Servlet Pattern:**

1. **Routing bằng parameter `action`**:
   ```
   /news?action=list    → Hiển thị danh sách
   /news?action=detail&id=1 → Chi tiết tin id=1
   /news?action=new     → Form thêm mới
   /news?action=edit&id=1 → Form sửa tin id=1
   /news?action=delete&id=1 → Xóa tin id=1
   ```

2. **doGet vs doPost**:
   - `doGet`: Xem dữ liệu (list, detail, form)
   - `doPost`: Thay đổi dữ liệu (insert, update)

3. **Forward vs Redirect**:
   - `forward`: Chuyển sang JSP (giữ request)
   - `redirect`: Chuyển hướng URL mới (request mới)

---

### 🔹 **VIEW LAYER** (JSP)

#### **list.jsp**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách tin tức</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>📰 DANH SÁCH TIN TỨC</h1>
        
        <a href="news?action=new" class="btn btn-primary">➕ Thêm tin mới</a>
        
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tiêu đề</th>
                    <th>Tác giả</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <!-- JSTL forEach để lặp qua danh sách tin -->
                <c:forEach var="news" items="${newsList}">
                    <tr>
                        <td>${news.newsId}</td>
                        <td>
                            <a href="news?action=detail&id=${news.newsId}">
                                ${news.title}
                            </a>
                        </td>
                        <td>${news.author}</td>
                        <td>${news.createdDate}</td>
                        <td>
                            <a href="news?action=edit&id=${news.newsId}" class="btn btn-warning">✏️ Sửa</a>
                            <a href="news?action=delete&id=${news.newsId}" 
                               class="btn btn-danger"
                               onclick="return confirm('Bạn có chắc muốn xóa?')">
                                🗑️ Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
```

**📝 Giải thích JSP & JSTL:**

1. **JSTL Core Tag Library**:
   ```jsp
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
   ```

2. **Expression Language (EL)**:
   ```jsp
   ${news.newsId}      ← Tương đương: news.getNewsId()
   ${news.title}       ← Tương đương: news.getTitle()
   ```

3. **JSTL `<c:forEach>`**:
   ```jsp
   <c:forEach var="news" items="${newsList}">
       <!-- Mỗi lần lặp, news là 1 đối tượng News -->
       ${news.title}
   </c:forEach>
   ```

4. **JavaScript confirm**:
   ```jsp
   onclick="return confirm('Bạn có chắc muốn xóa?')"
   ```

---

## 1.3. Luồng xử lý HTTP Request-Response

### 📊 Sequence Diagram: Hiển thị danh sách tin

```
Client Browser          Tomcat Server          NewsServlet          NewsDAO          MySQL Database
     |                        |                      |                  |                    |
     |--- GET /news?action=list -->|                 |                  |                    |
     |                        |                      |                  |                    |
     |                        |--- doGet() --------->|                  |                    |
     |                        |                      |                  |                    |
     |                        |                      |--- getAllNews() ->|                    |
     |                        |                      |                  |                    |
     |                        |                      |                  |--- SELECT * FROM news -->|
     |                        |                      |                  |                    |
     |                        |                      |                  |<--- ResultSet -----|
     |                        |                      |                  |                    |
     |                        |                      |<--- List<News> --|                    |
     |                        |                      |                  |                    |
     |                        |                      |--- setAttribute("newsList", list) ---|
     |                        |                      |                  |                    |
     |                        |                      |--- forward("list.jsp") ------------->|
     |                        |                      |                  |                    |
     |<--- HTML Response -----------------------------|                  |                    |
     |                        |                      |                  |                    |
```

### 📝 Giải thích từng bước:

1. **Client gửi request**: `GET /news?action=list`
2. **Tomcat nhận request** và gọi `doGet()` của NewsServlet
3. **NewsServlet gọi DAO**: `newsDAO.getAllNews()`
4. **NewsDAO truy vấn DB**: `SELECT * FROM news`
5. **DB trả về ResultSet** → DAO chuyển thành `List<News>`
6. **Servlet set attribute**: `request.setAttribute("newsList", list)`
7. **Forward sang JSP**: `dispatcher.forward(request, response)`
8. **JSP render HTML** với JSTL và gửi về Client

---

## 1.4. Phân tích chức năng hiện có

### ✅ Các chức năng đã có trong DemoNewsWeb

| STT | Chức năng | URL Pattern | Servlet | DAO Method | JSP View |
|-----|-----------|-------------|---------|------------|----------|
| 1 | Hiển thị danh sách tin | `/news?action=list` | NewsServlet.listNews() | getAllNews() | list.jsp |
| 2 | Xem chi tiết tin | `/news?action=detail&id=1` | NewsServlet.showDetail() | getNewsById() | detail.jsp |
| 3 | Thêm tin mới | `/news?action=new` (GET) <br> `/news?action=insert` (POST) | showNewForm() <br> insertNews() | addNews() | form.jsp |
| 4 | Sửa tin | `/news?action=edit&id=1` (GET) <br> `/news?action=update` (POST) | showEditForm() <br> updateNews() | updateNews() | form.jsp |
| 5 | Xóa tin | `/news?action=delete&id=1` | NewsServlet.deleteNews() | deleteNews() | - |
| 6 | Đăng nhập | `/login` (GET/POST) | LoginServlet | UserDAO.authenticate() | login.jsp |
| 7 | Đăng xuất | `/logout` | LogoutServlet | - | - |
| 8 | Quản lý Session | Filter | LoginFilter | - | - |
| 9 | Encoding UTF-8 | Filter | EncodingFilter | - | - |

### 📋 Chi tiết các chức năng

#### 1️⃣ **Chức năng Đăng nhập**

**LoginServlet.java**
```java
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    UserDAO userDAO = new UserDAO();
    User user = userDAO.authenticate(username, password);

    if (user != null) {
        // Đăng nhập thành công
        HttpSession session = request.getSession();
        session.setAttribute("currentUser", user);  // Lưu user vào session
        response.sendRedirect("news?action=list");
    } else {
        // Đăng nhập thất bại
        request.setAttribute("errorMessage", "Sai tên đăng nhập hoặc mật khẩu!");
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
    }
}
```

**UserDAO.java**
```java
public User authenticate(String username, String password) {
    String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
    try {
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, username);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            return new User(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("password"),
                rs.getString("full_name"),
                rs.getString("email")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
```

#### 2️⃣ **Chức năng Filter kiểm tra đăng nhập**

**LoginFilter.java**
```java
@Override
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {
    
    HttpServletRequest req = (HttpServletRequest) request;
    HttpServletResponse res = (HttpServletResponse) response;
    HttpSession session = req.getSession(false);  // false = không tạo session mới

    String uri = req.getRequestURI();
    
    // Các trang không cần đăng nhập
    if (uri.endsWith("login.jsp") || uri.endsWith("/login") || uri.endsWith("/logout")) {
        chain.doFilter(request, response);
        return;
    }

    // Kiểm tra session
    if (session != null && session.getAttribute("currentUser") != null) {
        chain.doFilter(request, response);  // Cho phép tiếp tục
    } else {
        res.sendRedirect(req.getContextPath() + "/login.jsp");  // Chuyển về login
    }
}
```

**web.xml**
```xml
<filter>
    <filter-name>LoginFilter</filter-name>
    <filter-class>filter.LoginFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>LoginFilter</filter-name>
    <url-pattern>/*</url-pattern>  <!-- Áp dụng cho tất cả URL -->
</filter-mapping>
```

---

## 1.5. Đánh giá điểm mạnh và hạn chế

### ✅ Điểm mạnh

1. **Kiến trúc MVC rõ ràng**: Tách biệt Model, View, Controller
2. **Sử dụng PreparedStatement**: An toàn với SQL Injection
3. **Có Filter**: Xử lý authentication và encoding
4. **Sử dụng JSTL**: Code JSP sạch, không lẫn Java code
5. **Có quản lý Session**: Đăng nhập, đăng xuất

### ❌ Hạn chế cần cải thiện

1. **Không có Connection Pool**: Mỗi DAO tạo connection riêng
2. **Không có Transaction Management**: Không xử lý rollback
3. **Không validate input**: Chưa kiểm tra dữ liệu đầu vào
4. **Không có Pagination**: Hiển thị tất cả tin cùng lúc
5. **Không có Error Handling**: Chưa có trang lỗi tùy chỉnh
6. **Password không mã hóa**: Lưu plain text trong DB
7. **Không có Upload file**: Ảnh chỉ là đường dẫn text

---

# PHẦN 2: ĐỀ XUẤT CHỨC NĂNG MỚI

## 2.1. Danh sách chức năng cho Website Bán Đồ Ăn Vặt

### 🎯 Mục tiêu Project
Xây dựng website thương mại điện tử bán đồ ăn vặt (snacks) với các chức năng:
- Xem danh sách sản phẩm
- Tìm kiếm, lọc sản phẩm
- Thêm vào giỏ hàng
- Đặt hàng
- Quản lý đơn hàng (admin)

### 📋 Các Module chính

#### **MODULE 1: QUẢN LÝ SẢN PHẨM (Products Management)**
| STT | Chức năng | Mô tả | Vai trò |
|-----|-----------|-------|---------|
| 1.1 | Hiển thị danh sách sản phẩm | Xem tất cả sản phẩm theo danh mục | User, Admin |
| 1.2 | Xem chi tiết sản phẩm | Hiển thị thông tin chi tiết, giá, mô tả | User, Admin |
| 1.3 | Thêm sản phẩm mới | Admin thêm sản phẩm mới | Admin |
| 1.4 | Sửa thông tin sản phẩm | Admin cập nhật giá, mô tả, hình ảnh | Admin |
| 1.5 | Xóa sản phẩm | Admin xóa sản phẩm khỏi hệ thống | Admin |
| 1.6 | Upload hình ảnh sản phẩm | Tải ảnh sản phẩm lên server | Admin |

#### **MODULE 2: GIỎ HÀNG (Shopping Cart)**
| STT | Chức năng | Mô tả | Vai trò |
|-----|-----------|-------|---------|
| 2.1 | Thêm sản phẩm vào giỏ | Thêm sản phẩm với số lượng | User |
| 2.2 | Xem giỏ hàng | Hiển thị danh sách sản phẩm trong giỏ | User |
| 2.3 | Cập nhật số lượng | Tăng/giảm số lượng sản phẩm | User |
| 2.4 | Xóa sản phẩm khỏi giỏ | Xóa 1 hoặc nhiều sản phẩm | User |
| 2.5 | Tính tổng tiền | Tự động tính tổng giá trị giỏ hàng | User |

#### **MODULE 3: ĐƠN HÀNG (Orders Management)**
| STT | Chức năng | Mô tả | Vai trò |
|-----|-----------|-------|---------|
| 3.1 | Đặt hàng | Tạo đơn hàng từ giỏ hàng | User |
| 3.2 | Nhập thông tin giao hàng | Địa chỉ, số điện thoại, ghi chú | User |
| 3.3 | Xem lịch sử đơn hàng | Xem danh sách đơn hàng đã đặt | User |
| 3.4 | Xem chi tiết đơn hàng | Xem sản phẩm, tổng tiền, trạng thái | User, Admin |
| 3.5 | Cập nhật trạng thái đơn | Đang xử lý, Đang giao, Hoàn thành | Admin |
| 3.6 | Hủy đơn hàng | User hủy đơn nếu chưa xử lý | User, Admin |

#### **MODULE 4: DANH MỤC & TÌM KIẾM (Categories & Search)**
| STT | Chức năng | Mô tả | Vai trò |
|-----|-----------|-------|---------|
| 4.1 | Hiển thị danh mục | Xem danh sách các danh mục | User, Admin |
| 4.2 | Lọc sản phẩm theo danh mục | Xem sản phẩm thuộc 1 danh mục | User |
| 4.3 | Tìm kiếm sản phẩm | Tìm theo tên, mô tả | User |
| 4.4 | Sắp xếp sản phẩm | Giá tăng/giảm, tên A-Z | User |
| 4.5 | Phân trang | Hiển thị 12 sản phẩm/trang | User |
| 4.6 | Quản lý danh mục | Thêm/sửa/xóa danh mục | Admin |

#### **MODULE 5: NGƯỜI DÙNG (User Management)**
| STT | Chức năng | Mô tả | Vai trò |
|-----|-----------|-------|---------|
| 5.1 | Đăng ký tài khoản | User tạo tài khoản mới | Guest |
| 5.2 | Đăng nhập | User đăng nhập vào hệ thống | Guest |
| 5.3 | Đăng xuất | User đăng xuất | User |
| 5.4 | Xem thông tin cá nhân | Xem profile, lịch sử đơn hàng | User |
| 5.5 | Cập nhật thông tin | Đổi tên, email, số điện thoại | User |
| 5.6 | Đổi mật khẩu | Đổi password | User |
| 5.7 | Quản lý user (Admin) | Xem, khóa/mở khóa user | Admin |

---

## 2.2. Thiết kế Database (6 bảng chính)

### 📊 ERD (Entity Relationship Diagram)

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│   categories    │         │     products     │         │   order_items   │
├─────────────────┤         ├──────────────────┤         ├─────────────────┤
│ category_id (PK)│ 1     ∞ │ product_id (PK)  │ 1     ∞ │ order_item_id   │
│ category_name   │────────>│ product_name     │────────>│ order_id (FK)   │
│ description     │         │ description      │         │ product_id (FK) │
│ image_path      │         │ price            │         │ quantity        │
└─────────────────┘         │ image_path       │         │ unit_price      │
                            │ category_id (FK) │         │ subtotal        │
                            │ stock_quantity   │         └─────────────────┘
                            │ created_date     │                 ▲
                            └──────────────────┘                 │
                                                                 │
┌─────────────────┐         ┌──────────────────┐                │
│      users      │         │      orders      │                │
├─────────────────┤         ├──────────────────┤                │
│ user_id (PK)    │ 1     ∞ │ order_id (PK)    │ 1            ∞ │
│ username        │────────>│ user_id (FK)     │────────────────┘
│ password        │         │ order_date       │
│ full_name       │         │ total_amount     │
│ email           │         │ shipping_address │
│ phone           │         │ status           │
│ role            │         │ notes            │
│ created_date    │         └──────────────────┘
└─────────────────┘

┌─────────────────┐
│   cart_items    │
├─────────────────┤
│ cart_item_id(PK)│
│ user_id (FK)    │
│ product_id (FK) │
│ quantity        │
│ added_date      │
└─────────────────┘
```

### 📝 Chi tiết các bảng

#### **1. Bảng `categories` (Danh mục sản phẩm)**
```sql
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    image_path VARCHAR(255),
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Dữ liệu mẫu
INSERT INTO categories (category_name, description, image_path) VALUES
('Bánh ngọt', 'Các loại bánh kẹo, snack ngọt', 'images/categories/banh-ngot.jpg'),
('Bánh mặn', 'Snack vị mặn, chiên giòn', 'images/categories/banh-man.jpg'),
('Kẹo', 'Kẹo ngậm, kẹo dẻo các loại', 'images/categories/keo.jpg'),
('Đồ uống', 'Nước ngọt, nước trái cây', 'images/categories/do-uong.jpg'),
('Hạt dinh dưỡng', 'Hạt hạnh nhân, óc chó, điều', 'images/categories/hat.jpg');
```

#### **2. Bảng `products` (Sản phẩm)**
```sql
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_path VARCHAR(255),
    category_id INT,
    stock_quantity INT DEFAULT 0,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- Dữ liệu mẫu
INSERT INTO products (product_name, description, price, image_path, category_id, stock_quantity) VALUES
('Oishi Snack Sườn Nướng BBQ 42g', 'Snack vị sườn BBQ thơm ngon giòn tan', 8000, 'images/products/oishi-bbq.jpg', 2, 100),
('Kitkat Matcha 35g', 'Chocolate kitkat vị trà xanh matcha', 12000, 'images/products/kitkat-matcha.jpg', 1, 50),
('Hạt Hạnh Nhân Mỹ 500g', 'Hạt hạnh nhân rang muối nhẹ', 150000, 'images/products/hanh-nhan.jpg', 5, 30),
('Coca Cola 330ml', 'Nước ngọt có ga Coca Cola', 10000, 'images/products/coca.jpg', 4, 200);
```

#### **3. Bảng `users` (Người dùng)**
```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    role ENUM('user', 'admin') DEFAULT 'user',
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Dữ liệu mẫu
INSERT INTO users (username, password, full_name, email, phone, role) VALUES
('admin', 'admin123', 'Quản trị viên', 'admin@shop.vn', '0901234567', 'admin'),
('user1', 'user123', 'Nguyễn Văn A', 'vana@gmail.com', '0912345678', 'user'),
('user2', 'user123', 'Trần Thị B', 'thib@gmail.com', '0923456789', 'user');
```

#### **4. Bảng `cart_items` (Giỏ hàng)**
```sql
CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    added_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);
```

#### **5. Bảng `orders` (Đơn hàng)**
```sql
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_address VARCHAR(255),
    phone VARCHAR(20),
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
```

#### **6. Bảng `order_items` (Chi tiết đơn hàng)**
```sql
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);
```

---

## 2.3. Use Case Diagram

```
                   ┌─────────────────────────────────────────┐
                   │        HỆ THỐNG BÁN ĐỒ ĂN VẶT          │
                   └─────────────────────────────────────────┘

┌──────────┐             ┌─────────────────────────────────────┐
│  Guest   │             │ ● Xem danh sách sản phẩm            │
│ (Khách)  │────────────>│ ● Xem chi tiết sản phẩm             │
└──────────┘             │ ● Tìm kiếm sản phẩm                 │
                         │ ● Lọc theo danh mục                 │
                         │ ● Đăng ký tài khoản                 │
                         │ ● Đăng nhập                         │
                         └─────────────────────────────────────┘

┌──────────┐             ┌─────────────────────────────────────┐
│   User   │             │ ● Tất cả quyền của Guest            │
│ (Người   │────────────>│ ● Thêm vào giỏ hàng                 │
│  dùng)   │             │ ● Xem giỏ hàng                      │
└──────────┘             │ ● Đặt hàng                          │
                         │ ● Xem lịch sử đơn hàng              │
                         │ ● Cập nhật thông tin cá nhân        │
                         │ ● Đổi mật khẩu                      │
                         │ ● Đăng xuất                         │
                         └─────────────────────────────────────┘

┌──────────┐             ┌─────────────────────────────────────┐
│  Admin   │             │ ● Tất cả quyền của User             │
│ (Quản trị│────────────>│ ● Quản lý sản phẩm (CRUD)           │
│   viên)  │             │ ● Quản lý danh mục (CRUD)           │
└──────────┘             │ ● Quản lý đơn hàng                  │
                         │ ● Cập nhật trạng thái đơn hàng      │
                         │ ● Quản lý người dùng                │
                         │ ● Xem thống kê doanh thu            │
                         └─────────────────────────────────────┘
```

---

## 2.4. Sitemap & Navigation Flow

```
🏠 HOME (index.jsp)
├── 🔍 TÌM KIẾM
│   └── /search?keyword=xyz
│
├── 📂 DANH MỤC
│   ├── /products?categoryId=1 (Bánh ngọt)
│   ├── /products?categoryId=2 (Bánh mặn)
│   ├── /products?categoryId=3 (Kẹo)
│   └── /products?categoryId=4 (Đồ uống)
│
├── 🛍️ SẢN PHẨM
│   ├── /products (Danh sách tất cả)
│   └── /products?action=detail&id=1 (Chi tiết)
│
├── 🛒 GIỎ HÀNG
│   ├── /cart (Xem giỏ hàng)
│   ├── /cart?action=add&productId=1 (Thêm vào giỏ)
│   ├── /cart?action=update (Cập nhật số lượng)
│   └── /cart?action=remove&itemId=1 (Xóa khỏi giỏ)
│
├── 📦 ĐẶT HÀNG
│   ├── /checkout (Form đặt hàng)
│   └── /orders?action=create (Tạo đơn hàng)
│
├── 👤 TÀI KHOẢN
│   ├── /login (Đăng nhập)
│   ├── /register (Đăng ký)
│   ├── /profile (Thông tin cá nhân)
│   ├── /orders (Lịch sử đơn hàng)
│   └── /logout (Đăng xuất)
│
└── 🔐 ADMIN
    ├── /admin/products (Quản lý sản phẩm)
    ├── /admin/categories (Quản lý danh mục)
    ├── /admin/orders (Quản lý đơn hàng)
    └── /admin/users (Quản lý người dùng)
```

---

# PHẦN 3: PHÂN CÔNG 4 THÀNH VIÊN

## 🎯 Nguyên tắc phân chia

1. **Mỗi thành viên phụ trách 1 module hoàn chỉnh** (Model + DAO + Servlet + JSP)
2. **Có sự phụ thuộc lẫn nhau** giữa các module (cần integration)
3. **Mỗi module có độ khó tương đương** để công bằng

---

## 3.1. Thành viên 1 - QUẢN LÝ SẢN PHẨM (Products Management)

### 📋 Nhiệm vụ
Xây dựng module quản lý sản phẩm, bao gồm:
- Hiển thị danh sách sản phẩm (có phân trang)
- Xem chi tiết sản phẩm
- Thêm/Sửa/Xóa sản phẩm (Admin)
- Upload hình ảnh sản phẩm

### 📂 Các file cần tạo

#### **Model: Product.java**
```java
package model;

import java.util.Date;

public class Product {
    private int productId;
    private String productName;
    private String description;
    private double price;
    private String imagePath;
    private int categoryId;
    private int stockQuantity;
    private Date createdDate;

    // Constructor đầy đủ
    public Product(int productId, String productName, String description, 
                   double price, String imagePath, int categoryId, 
                   int stockQuantity, Date createdDate) {
        this.productId = productId;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
        this.stockQuantity = stockQuantity;
        this.createdDate = createdDate;
    }

    // Constructor không có productId (dùng cho INSERT)
    public Product(String productName, String description, double price, 
                   String imagePath, int categoryId, int stockQuantity) {
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
        this.stockQuantity = stockQuantity;
    }

    // Getter và Setter
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
}
```

#### **DAO: ProductDAO.java**
```java
package dao;

import java.sql.*;
import java.util.*;
import model.Product;
import util.DBConnection;

public class ProductDAO {
    private Connection conn;

    public ProductDAO() {
        this.conn = DBConnection.getConnection();
    }

    // 1️⃣ Lấy tất cả sản phẩm
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY created_date DESC";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getInt("stock_quantity"),
                    rs.getDate("created_date")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // 2️⃣ Lấy sản phẩm theo ID
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Product(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getInt("stock_quantity"),
                    rs.getDate("created_date")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3️⃣ Lấy sản phẩm theo danh mục
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id = ? ORDER BY product_name";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getInt("stock_quantity"),
                    rs.getDate("created_date")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // 4️⃣ Thêm sản phẩm mới
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (product_name, description, price, image_path, " +
                     "category_id, stock_quantity) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getImagePath());
            stmt.setInt(5, product.getCategoryId());
            stmt.setInt(6, product.getStockQuantity());

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5️⃣ Cập nhật sản phẩm
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET product_name=?, description=?, price=?, " +
                     "image_path=?, category_id=?, stock_quantity=? WHERE product_id=?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getImagePath());
            stmt.setInt(5, product.getCategoryId());
            stmt.setInt(6, product.getStockQuantity());
            stmt.setInt(7, product.getProductId());

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6️⃣ Xóa sản phẩm
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id=?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 7️⃣ Phân trang sản phẩm
    public List<Product> getProductsPaginated(int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products ORDER BY created_date DESC LIMIT ? OFFSET ?";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, pageSize);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getInt("stock_quantity"),
                    rs.getDate("created_date")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // 8️⃣ Đếm tổng số sản phẩm (dùng cho phân trang)
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) AS total FROM products";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
```

#### **Servlet: ProductServlet.java**
```java
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.util.*;
import dao.ProductDAO;
import dao.CategoryDAO;
import model.Product;
import model.Category;

@WebServlet("/products")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5,   // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listProducts(request, response);
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
            default:
                listProducts(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            default:
                listProducts(request, response);
        }
    }

    // 📋 Hiển thị danh sách sản phẩm với phân trang
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int page = 1;
        int pageSize = 12;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        List<Product> productList = productDAO.getProductsPaginated(page, pageSize);
        int totalProducts = productDAO.getTotalProducts();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        request.setAttribute("productList", productList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/product-list.jsp");
        dispatcher.forward(request, response);
    }

    // 🔍 Hiển thị chi tiết sản phẩm
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productId);
        request.setAttribute("product", product);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/product-detail.jsp");
        dispatcher.forward(request, response);
    }

    // ➕ Hiển thị form thêm sản phẩm
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/product-form.jsp");
        dispatcher.forward(request, response);
    }

    // ✏️ Hiển thị form sửa sản phẩm
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productId);
        List<Category> categoryList = categoryDAO.getAllCategories();
        
        request.setAttribute("product", product);
        request.setAttribute("categoryList", categoryList);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/product-form.jsp");
        dispatcher.forward(request, response);
    }

    // 💾 Thêm sản phẩm mới
    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));

        // Xử lý upload file ảnh
        Part filePart = request.getPart("image");
        String imagePath = uploadFile(filePart);

        Product newProduct = new Product(productName, description, price, imagePath, 
                                         categoryId, stockQuantity);
        boolean success = productDAO.addProduct(newProduct);

        if (success) {
            response.sendRedirect("products?action=list");
        } else {
            response.getWriter().println("Thêm sản phẩm thất bại!");
        }
    }

    // 🔄 Cập nhật sản phẩm
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));

        // Xử lý upload file ảnh (nếu có)
        Part filePart = request.getPart("image");
        String imagePath = request.getParameter("currentImage");
        
        if (filePart != null && filePart.getSize() > 0) {
            imagePath = uploadFile(filePart);
        }

        Product product = new Product(productId, productName, description, price, 
                                      imagePath, categoryId, stockQuantity, null);
        boolean success = productDAO.updateProduct(product);

        if (success) {
            response.sendRedirect("products?action=list");
        } else {
            response.getWriter().println("Cập nhật sản phẩm thất bại!");
        }
    }

    // ❌ Xóa sản phẩm
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int productId = Integer.parseInt(request.getParameter("id"));
        boolean success = productDAO.deleteProduct(productId);

        if (success) {
            response.sendRedirect("products?action=list");
        } else {
            response.getWriter().println("Xóa sản phẩm thất bại!");
        }
    }

    // 📤 Xử lý upload file
    private String uploadFile(Part filePart) throws IOException {
        String fileName = getFileName(filePart);
        String uploadPath = getServletContext().getRealPath("") + "images/products";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        return "images/products/" + fileName;
    }

    // Lấy tên file từ Part
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
```

#### **View: product-list.jsp**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>🛍️ DANH SÁCH SẢN PHẨM</h1>
        
        <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.role == 'admin'}">
            <a href="products?action=new" class="btn btn-primary">➕ Thêm sản phẩm mới</a>
        </c:if>

        <div class="product-grid">
            <c:forEach var="product" items="${productList}">
                <div class="product-card">
                    <img src="${product.imagePath}" alt="${product.productName}">
                    <h3>${product.productName}</h3>
                    <p class="price">
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                    </p>
                    <p class="stock">Kho: ${product.stockQuantity}</p>
                    <div class="actions">
                        <a href="products?action=detail&id=${product.productId}" class="btn btn-info">Xem chi tiết</a>
                        <c:if test="${sessionScope.currentUser != null}">
                            <a href="cart?action=add&productId=${product.productId}" class="btn btn-success">Thêm vào giỏ</a>
                        </c:if>
                        <c:if test="${sessionScope.currentUser.role == 'admin'}">
                            <a href="products?action=edit&id=${product.productId}" class="btn btn-warning">Sửa</a>
                            <a href="products?action=delete&id=${product.productId}" 
                               class="btn btn-danger"
                               onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Phân trang -->
        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <a href="products?page=${currentPage - 1}">&laquo; Trước</a>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="active">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="products?page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <a href="products?page=${currentPage + 1}">Sau &raquo;</a>
            </c:if>
        </div>
    </div>
</body>
</html>
```

### 📝 Checklist công việc Thành viên 1

- [ ] Tạo bảng `products` trong database
- [ ] Tạo class `Product.java` (Model)
- [ ] Tạo class `ProductDAO.java` với 8 methods CRUD
- [ ] Tạo Servlet `ProductServlet.java` xử lý routing
- [ ] Tạo JSP `product-list.jsp` hiển thị danh sách + phân trang
- [ ] Tạo JSP `product-detail.jsp` hiển thị chi tiết
- [ ] Tạo JSP `product-form.jsp` cho thêm/sửa
- [ ] Implement upload file ảnh trong Servlet
- [ ] Viết CSS cho giao diện product card
- [ ] Test tất cả chức năng CRUD
- [ ] Tích hợp với Module 4 (CategoryDAO) để lấy danh sách categories

---

## 3.2. Thành viên 2 - GIỎ HÀNG (Shopping Cart)

### 📋 Nhiệm vụ
Xây dựng module giỏ hàng, bao gồm:
- Thêm sản phẩm vào giỏ hàng (lưu trong Session hoặc Database)
- Xem giỏ hàng
- Cập nhật số lượng sản phẩm
- Xóa sản phẩm khỏi giỏ
- Tính tổng tiền tự động

### 📂 Các file cần tạo

#### **Model: CartItem.java**
```java
package model;

public class CartItem {
    private int cartItemId;
    private int userId;
    private int productId;
    private String productName;  // Thông tin bổ sung
    private double price;        // Giá sản phẩm
    private String imagePath;    // Ảnh sản phẩm
    private int quantity;

    // Constructor đầy đủ
    public CartItem(int cartItemId, int userId, int productId, String productName, 
                    double price, String imagePath, int quantity) {
        this.cartItemId = cartItemId;
        this.userId = userId;
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.imagePath = imagePath;
        this.quantity = quantity;
    }

    // Constructor đơn giản (dùng cho thêm vào giỏ)
    public CartItem(int userId, int productId, int quantity) {
        this.userId = userId;
        this.productId = productId;
        this.quantity = quantity;
    }

    // Getter và Setter
    public int getCartItemId() { return cartItemId; }
    public void setCartItemId(int cartItemId) { this.cartItemId = cartItemId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    // Tính tổng tiền item này
    public double getSubtotal() {
        return price * quantity;
    }
}
```

#### **DAO: CartDAO.java**
```java
package dao;

import java.sql.*;
import java.util.*;
import model.CartItem;
import util.DBConnection;

public class CartDAO {
    private Connection conn;

    public CartDAO() {
        this.conn = DBConnection.getConnection();
    }

    // 1️⃣ Lấy giỏ hàng của user
    public List<CartItem> getCartByUserId(int userId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT c.*, p.product_name, p.price, p.image_path " +
                     "FROM cart_items c " +
                     "JOIN products p ON c.product_id = p.product_id " +
                     "WHERE c.user_id = ?";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem(
                    rs.getInt("cart_item_id"),
                    rs.getInt("user_id"),
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("quantity")
                );
                cartItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    // 2️⃣ Thêm sản phẩm vào giỏ
    public boolean addToCart(int userId, int productId, int quantity) {
        // Kiểm tra xem sản phẩm đã có trong giỏ chưa
        CartItem existingItem = getCartItem(userId, productId);

        if (existingItem != null) {
            // Nếu đã có, tăng số lượng
            return updateQuantity(existingItem.getCartItemId(), 
                                  existingItem.getQuantity() + quantity);
        } else {
            // Nếu chưa có, thêm mới
            String sql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
            try {
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setInt(2, productId);
                stmt.setInt(3, quantity);

                int rows = stmt.executeUpdate();
                return rows > 0;
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    // 3️⃣ Lấy 1 item trong giỏ (dùng để kiểm tra)
    private CartItem getCartItem(int userId, int productId) {
        String sql = "SELECT * FROM cart_items WHERE user_id = ? AND product_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new CartItem(
                    rs.getInt("cart_item_id"),
                    rs.getInt("user_id"),
                    rs.getInt("product_id"),
                    null, 0, null,  // Không cần thông tin chi tiết
                    rs.getInt("quantity")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 4️⃣ Cập nhật số lượng
    public boolean updateQuantity(int cartItemId, int newQuantity) {
        if (newQuantity <= 0) {
            return removeFromCart(cartItemId);  // Nếu số lượng <= 0 thì xóa
        }

        String sql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, newQuantity);
            stmt.setInt(2, cartItemId);

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5️⃣ Xóa item khỏi giỏ
    public boolean removeFromCart(int cartItemId) {
        String sql = "DELETE FROM cart_items WHERE cart_item_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, cartItemId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6️⃣ Xóa toàn bộ giỏ hàng của user (sau khi đặt hàng)
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 7️⃣ Tính tổng tiền giỏ hàng
    public double getCartTotal(int userId) {
        List<CartItem> cartItems = getCartByUserId(userId);
        double total = 0;
        for (CartItem item : cartItems) {
            total += item.getSubtotal();
        }
        return total;
    }
}
```

#### **Servlet: CartServlet.java**
```java
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.util.*;
import dao.CartDAO;
import model.CartItem;
import model.User;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO;

    @Override
    public void init() {
        cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "view":
                viewCart(request, response);
                break;
            case "add":
                addToCart(request, response);
                break;
            case "remove":
                removeFromCart(request, response);
                break;
            default:
                viewCart(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            updateCart(request, response);
        } else {
            viewCart(request, response);
        }
    }

    // 🛒 Xem giỏ hàng
    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartByUserId(currentUser.getUserId());
        double cartTotal = cartDAO.getCartTotal(currentUser.getUserId());

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);

        RequestDispatcher dispatcher = request.getRequestDispatcher("views/cart.jsp");
        dispatcher.forward(request, response);
    }

    // ➕ Thêm vào giỏ
    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = 1;  // Mặc định thêm 1

        String qtyParam = request.getParameter("quantity");
        if (qtyParam != null) {
            quantity = Integer.parseInt(qtyParam);
        }

        boolean success = cartDAO.addToCart(currentUser.getUserId(), productId, quantity);

        if (success) {
            response.sendRedirect("cart?action=view");
        } else {
            response.getWriter().println("Thêm vào giỏ thất bại!");
        }
    }

    // 🔄 Cập nhật số lượng
    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String[] itemIds = request.getParameterValues("cartItemId");
        String[] quantities = request.getParameterValues("quantity");

        if (itemIds != null && quantities != null) {
            for (int i = 0; i < itemIds.length; i++) {
                int cartItemId = Integer.parseInt(itemIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                cartDAO.updateQuantity(cartItemId, quantity);
            }
        }

        response.sendRedirect("cart?action=view");
    }

    // ❌ Xóa khỏi giỏ
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int cartItemId = Integer.parseInt(request.getParameter("itemId"));
        boolean success = cartDAO.removeFromCart(cartItemId);

        if (success) {
            response.sendRedirect("cart?action=view");
        } else {
            response.getWriter().println("Xóa thất bại!");
        }
    }
}
```

#### **View: cart.jsp**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>🛒 GIỎ HÀNG CỦA BẠN</h1>

        <c:choose>
            <c:when test="${empty cartItems}">
                <p>Giỏ hàng của bạn đang trống.</p>
                <a href="products" class="btn btn-primary">Tiếp tục mua sắm</a>
            </c:when>
            <c:otherwise>
                <form method="post" action="cart?action=update">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Hình ảnh</th>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cartItems}">
                                <tr>
                                    <td>
                                        <img src="${item.imagePath}" alt="${item.productName}" width="80">
                                    </td>
                                    <td>${item.productName}</td>
                                    <td>
                                        <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/>
                                    </td>
                                    <td>
                                        <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                        <input type="number" name="quantity" value="${item.quantity}" min="1" max="99">
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫"/>
                                    </td>
                                    <td>
                                        <a href="cart?action=remove&itemId=${item.cartItemId}" 
                                           class="btn btn-danger"
                                           onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="4" class="text-right"><strong>TỔNG CỘNG:</strong></td>
                                <td colspan="2">
                                    <strong>
                                        <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="₫"/>
                                    </strong>
                                </td>
                            </tr>
                        </tfoot>
                    </table>

                    <div class="cart-actions">
                        <button type="submit" class="btn btn-warning">🔄 Cập nhật giỏ hàng</button>
                        <a href="products" class="btn btn-secondary">Tiếp tục mua sắm</a>
                        <a href="checkout" class="btn btn-success">Đặt hàng</a>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
```

### 📝 Checklist công việc Thành viên 2

- [ ] Tạo bảng `cart_items` trong database
- [ ] Tạo class `CartItem.java` (Model)
- [ ] Tạo class `CartDAO.java` với 7 methods
- [ ] Tạo Servlet `CartServlet.java` xử lý giỏ hàng
- [ ] Tạo JSP `cart.jsp` hiển thị giỏ hàng
- [ ] Implement logic cập nhật số lượng (tăng/giảm)
- [ ] Implement tính tổng tiền tự động
- [ ] Viết CSS cho bảng giỏ hàng
- [ ] Test chức năng thêm/xóa/cập nhật
- [ ] Tích hợp với Module 1 (ProductDAO) để lấy thông tin sản phẩm
- [ ] Tích hợp với Module 3 (OrderDAO) để chuyển giỏ hàng thành đơn hàng

---

*(Tiếp tục phần 3.3 và 3.4...)*


## 3.3. Thành viên 3 - ĐƠN HÀNG (Orders Management)

### 📋 Nhiệm vụ
Xây dựng module quản lý đơn hàng, bao gồm:
- Tạo đơn hàng từ giỏ hàng
- Xem lịch sử đơn hàng
- Xem chi tiết đơn hàng
- Cập nhật trạng thái đơn hàng (Admin)
- Hủy đơn hàng

### 📂 Các file cần tạo

#### **Model: Order.java**
```java
package model;

import java.util.Date;

public class Order {
    private int orderId;
    private int userId;
    private Date orderDate;
    private double totalAmount;
    private String shippingAddress;
    private String phone;
    private String status;  // Pending, Processing, Shipped, Delivered, Cancelled
    private String notes;

    // Constructor đầy đủ
    public Order(int orderId, int userId, Date orderDate, double totalAmount,
                 String shippingAddress, String phone, String status, String notes) {
        this.orderId = orderId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.phone = phone;
        this.status = status;
        this.notes = notes;
    }

    // Constructor cho tạo đơn mới
    public Order(int userId, double totalAmount, String shippingAddress, 
                 String phone, String notes) {
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.phone = phone;
        this.notes = notes;
        this.status = "Pending";  // Mặc định
    }

    // Getter và Setter
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
```

#### **Model: OrderItem.java**
```java
package model;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int productId;
    private String productName;  // Thông tin bổ sung
    private int quantity;
    private double unitPrice;
    private double subtotal;

    // Constructor đầy đủ
    public OrderItem(int orderItemId, int orderId, int productId, String productName,
                     int quantity, double unitPrice, double subtotal) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
    }

    // Constructor cho tạo order item mới
    public OrderItem(int orderId, int productId, int quantity, double unitPrice) {
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = quantity * unitPrice;
    }

    // Getter và Setter
    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
}
```

#### **DAO: OrderDAO.java**
```java
package dao;

import java.sql.*;
import java.util.*;
import model.Order;
import model.OrderItem;
import model.CartItem;
import util.DBConnection;

public class OrderDAO {
    private Connection conn;
    private CartDAO cartDAO;

    public OrderDAO() {
        this.conn = DBConnection.getConnection();
        this.cartDAO = new CartDAO();
    }

    // 1️⃣ Tạo đơn hàng từ giỏ hàng (với Transaction)
    public boolean createOrder(int userId, String shippingAddress, String phone, String notes) {
        try {
            // Bắt đầu transaction
            conn.setAutoCommit(false);

            // Lấy giỏ hàng của user
            List<CartItem> cartItems = cartDAO.getCartByUserId(userId);
            if (cartItems.isEmpty()) {
                return false;  // Giỏ hàng trống
            }

            // Tính tổng tiền
            double totalAmount = cartDAO.getCartTotal(userId);

            // Tạo order
            String sqlOrder = "INSERT INTO orders (user_id, total_amount, shipping_address, phone, notes) " +
                              "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmtOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            stmtOrder.setInt(1, userId);
            stmtOrder.setDouble(2, totalAmount);
            stmtOrder.setString(3, shippingAddress);
            stmtOrder.setString(4, phone);
            stmtOrder.setString(5, notes);

            int rowsOrder = stmtOrder.executeUpdate();
            if (rowsOrder == 0) {
                conn.rollback();
                return false;
            }

            // Lấy order_id vừa tạo
            ResultSet rsKeys = stmtOrder.getGeneratedKeys();
            int orderId = 0;
            if (rsKeys.next()) {
                orderId = rsKeys.getInt(1);
            }

            // Tạo order_items từ cart_items
            String sqlOrderItem = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) " +
                                  "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmtItem = conn.prepareStatement(sqlOrderItem);

            for (CartItem cartItem : cartItems) {
                stmtItem.setInt(1, orderId);
                stmtItem.setInt(2, cartItem.getProductId());
                stmtItem.setInt(3, cartItem.getQuantity());
                stmtItem.setDouble(4, cartItem.getPrice());
                stmtItem.setDouble(5, cartItem.getSubtotal());
                stmtItem.addBatch();  // Batch insert
            }

            stmtItem.executeBatch();

            // Xóa giỏ hàng
            cartDAO.clearCart(userId);

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
            return true;

        } catch (SQLException e) {
            try {
                conn.rollback();  // Rollback nếu lỗi
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        }
    }

    // 2️⃣ Lấy danh sách đơn hàng của user
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order(
                    rs.getInt("order_id"),
                    rs.getInt("user_id"),
                    rs.getDate("order_date"),
                    rs.getDouble("total_amount"),
                    rs.getString("shipping_address"),
                    rs.getString("phone"),
                    rs.getString("status"),
                    rs.getString("notes")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // 3️⃣ Lấy tất cả đơn hàng (Admin)
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order(
                    rs.getInt("order_id"),
                    rs.getInt("user_id"),
                    rs.getDate("order_date"),
                    rs.getDouble("total_amount"),
                    rs.getString("shipping_address"),
                    rs.getString("phone"),
                    rs.getString("status"),
                    rs.getString("notes")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // 4️⃣ Lấy đơn hàng theo ID
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Order(
                    rs.getInt("order_id"),
                    rs.getInt("user_id"),
                    rs.getDate("order_date"),
                    rs.getDouble("total_amount"),
                    rs.getString("shipping_address"),
                    rs.getString("phone"),
                    rs.getString("status"),
                    rs.getString("notes")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 5️⃣ Lấy chi tiết đơn hàng (order_items)
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT oi.*, p.product_name " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.product_id " +
                     "WHERE oi.order_id = ?";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem(
                    rs.getInt("order_item_id"),
                    rs.getInt("order_id"),
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getInt("quantity"),
                    rs.getDouble("unit_price"),
                    rs.getDouble("subtotal")
                );
                orderItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderItems;
    }

    // 6️⃣ Cập nhật trạng thái đơn hàng
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newStatus);
            stmt.setInt(2, orderId);

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 7️⃣ Hủy đơn hàng (chỉ được phép nếu trạng thái là Pending)
    public boolean cancelOrder(int orderId) {
        Order order = getOrderById(orderId);
        if (order != null && "Pending".equals(order.getStatus())) {
            return updateOrderStatus(orderId, "Cancelled");
        }
        return false;
    }
}
```

#### **Servlet: OrderServlet.java**
```java
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.util.*;
import dao.OrderDAO;
import model.Order;
import model.OrderItem;
import model.User;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listOrders(request, response);
                break;
            case "detail":
                showOrderDetail(request, response);
                break;
            case "cancel":
                cancelOrder(request, response);
                break;
            default:
                listOrders(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        switch (action) {
            case "create":
                createOrder(request, response);
                break;
            case "updateStatus":
                updateStatus(request, response);
                break;
            default:
                listOrders(request, response);
        }
    }

    // 📋 Hiển thị danh sách đơn hàng
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Order> orderList;
        if ("admin".equals(currentUser.getRole())) {
            // Admin xem tất cả đơn
            orderList = orderDAO.getAllOrders();
        } else {
            // User chỉ xem đơn của mình
            orderList = orderDAO.getOrdersByUserId(currentUser.getUserId());
        }

        request.setAttribute("orderList", orderList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/order-list.jsp");
        dispatcher.forward(request, response);
    }

    // 🔍 Xem chi tiết đơn hàng
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);
        List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);

        RequestDispatcher dispatcher = request.getRequestDispatcher("views/order-detail.jsp");
        dispatcher.forward(request, response);
    }

    // 💳 Tạo đơn hàng từ giỏ hàng
    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String shippingAddress = request.getParameter("shippingAddress");
        String phone = request.getParameter("phone");
        String notes = request.getParameter("notes");

        boolean success = orderDAO.createOrder(currentUser.getUserId(), 
                                               shippingAddress, phone, notes);

        if (success) {
            response.sendRedirect("orders?action=list");
        } else {
            response.getWriter().println("Đặt hàng thất bại!");
        }
    }

    // 🔄 Cập nhật trạng thái đơn hàng (Admin)
    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String newStatus = request.getParameter("status");

        boolean success = orderDAO.updateOrderStatus(orderId, newStatus);

        if (success) {
            response.sendRedirect("orders?action=detail&id=" + orderId);
        } else {
            response.getWriter().println("Cập nhật thất bại!");
        }
    }

    // ❌ Hủy đơn hàng
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        boolean success = orderDAO.cancelOrder(orderId);

        if (success) {
            response.sendRedirect("orders?action=list");
        } else {
            response.getWriter().println("Không thể hủy đơn hàng!");
        }
    }
}
```

#### **View: checkout.jsp** (Form đặt hàng)
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>📦 ĐẶT HÀNG</h1>

        <form method="post" action="orders?action=create">
            <div class="form-group">
                <label>Địa chỉ giao hàng: *</label>
                <textarea name="shippingAddress" rows="3" required></textarea>
            </div>

            <div class="form-group">
                <label>Số điện thoại: *</label>
                <input type="text" name="phone" required>
            </div>

            <div class="form-group">
                <label>Ghi chú:</label>
                <textarea name="notes" rows="2"></textarea>
            </div>

            <button type="submit" class="btn btn-success">Xác nhận đặt hàng</button>
            <a href="cart" class="btn btn-secondary">Quay lại giỏ hàng</a>
        </form>
    </div>
</body>
</html>
```

#### **View: order-list.jsp**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đơn hàng</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>📦 LỊCH SỬ ĐƠN HÀNG</h1>

        <table class="table">
            <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orderList}">
                    <tr>
                        <td>#${order.orderId}</td>
                        <td>
                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td>
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                        </td>
                        <td>
                            <span class="badge badge-${order.status}">${order.status}</span>
                        </td>
                        <td>
                            <a href="orders?action=detail&id=${order.orderId}" class="btn btn-info">Chi tiết</a>
                            <c:if test="${order.status == 'Pending'}">
                                <a href="orders?action=cancel&id=${order.orderId}" 
                                   class="btn btn-danger"
                                   onclick="return confirm('Bạn có chắc muốn hủy đơn?')">Hủy</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
```

### 📝 Checklist công việc Thành viên 3

- [ ] Tạo bảng `orders` và `order_items` trong database
- [ ] Tạo class `Order.java` và `OrderItem.java` (Model)
- [ ] Tạo class `OrderDAO.java` với 7 methods
- [ ] Implement Transaction trong `createOrder()` (ACID)
- [ ] Tạo Servlet `OrderServlet.java`
- [ ] Tạo JSP `checkout.jsp` (form đặt hàng)
- [ ] Tạo JSP `order-list.jsp` (lịch sử đơn)
- [ ] Tạo JSP `order-detail.jsp` (chi tiết đơn)
- [ ] Viết CSS cho các trạng thái đơn hàng
- [ ] Test chức năng đặt hàng
- [ ] Tích hợp với Module 2 (CartDAO) để lấy giỏ hàng

---

## 3.4. Thành viên 4 - DANH MỤC & TÌM KIẾM (Categories & Search)

### 📋 Nhiệm vụ
Xây dựng module danh mục và tìm kiếm, bao gồm:
- Quản lý danh mục (CRUD)
- Lọc sản phẩm theo danh mục
- Tìm kiếm sản phẩm (theo tên, mô tả)
- Sắp xếp sản phẩm (giá, tên)
- Phân trang sản phẩm

### 📂 Các file cần tạo

#### **Model: Category.java**
```java
package model;

import java.util.Date;

public class Category {
    private int categoryId;
    private String categoryName;
    private String description;
    private String imagePath;
    private Date createdDate;

    // Constructor đầy đủ
    public Category(int categoryId, String categoryName, String description, 
                    String imagePath, Date createdDate) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.imagePath = imagePath;
        this.createdDate = createdDate;
    }

    // Constructor không có categoryId (dùng cho INSERT)
    public Category(String categoryName, String description, String imagePath) {
        this.categoryName = categoryName;
        this.description = description;
        this.imagePath = imagePath;
    }

    // Getter và Setter
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
}
```

#### **DAO: CategoryDAO.java**
```java
package dao;

import java.sql.*;
import java.util.*;
import model.Category;
import util.DBConnection;

public class CategoryDAO {
    private Connection conn;

    public CategoryDAO() {
        this.conn = DBConnection.getConnection();
    }

    // 1️⃣ Lấy tất cả danh mục
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY category_name";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("category_id"),
                    rs.getString("category_name"),
                    rs.getString("description"),
                    rs.getString("image_path"),
                    rs.getDate("created_date")
                );
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    // 2️⃣ Lấy danh mục theo ID
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Category(
                    rs.getInt("category_id"),
                    rs.getString("category_name"),
                    rs.getString("description"),
                    rs.getString("image_path"),
                    rs.getDate("created_date")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3️⃣ Thêm danh mục mới
    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (category_name, description, image_path) " +
                     "VALUES (?, ?, ?)";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setString(3, category.getImagePath());

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4️⃣ Cập nhật danh mục
    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET category_name=?, description=?, image_path=? " +
                     "WHERE category_id=?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setString(3, category.getImagePath());
            stmt.setInt(4, category.getCategoryId());

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5️⃣ Xóa danh mục
    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id=?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
```

#### **DAO: SearchDAO.java** (Bổ sung vào ProductDAO)
```java
package dao;

import java.sql.*;
import java.util.*;
import model.Product;
import util.DBConnection;

public class SearchDAO {
    private Connection conn;

    public SearchDAO() {
        this.conn = DBConnection.getConnection();
    }

    // 🔍 Tìm kiếm sản phẩm theo keyword
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE product_name LIKE ? OR description LIKE ?";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getInt("stock_quantity"),
                    rs.getDate("created_date")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // 🔢 Sắp xếp sản phẩm
    public List<Product> getProductsSorted(String sortBy, String order, int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String orderByClause = "";
        switch (sortBy) {
            case "price":
                orderByClause = "price";
                break;
            case "name":
                orderByClause = "product_name";
                break;
            default:
                orderByClause = "created_date";
        }

        String orderDirection = "ASC".equalsIgnoreCase(order) ? "ASC" : "DESC";
        String sql = "SELECT * FROM products ORDER BY " + orderByClause + " " + orderDirection + 
                     " LIMIT ? OFFSET ?";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, pageSize);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getInt("stock_quantity"),
                    rs.getDate("created_date")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // 📂 Lọc sản phẩm theo danh mục với sắp xếp và phân trang
    public List<Product> getProductsByCategoryWithSort(int categoryId, String sortBy, String order, 
                                                        int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String orderByClause = "";
        switch (sortBy) {
            case "price":
                orderByClause = "price";
                break;
            case "name":
                orderByClause = "product_name";
                break;
            default:
                orderByClause = "created_date";
        }

        String orderDirection = "ASC".equalsIgnoreCase(order) ? "ASC" : "DESC";
        String sql = "SELECT * FROM products WHERE category_id = ? ORDER BY " + orderByClause + " " + 
                     orderDirection + " LIMIT ? OFFSET ?";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            stmt.setInt(2, pageSize);
            stmt.setInt(3, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getInt("stock_quantity"),
                    rs.getDate("created_date")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // 📊 Đếm số sản phẩm theo danh mục
    public int countProductsByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) AS total FROM products WHERE category_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
```

#### **Servlet: CategoryServlet.java**
```java
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.util.*;
import dao.CategoryDAO;
import model.Category;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listCategories(request, response);
                break;
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            default:
                listCategories(request, response);
        }
    }

    // 📋 Hiển thị danh sách danh mục
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/category-list.jsp");
        dispatcher.forward(request, response);
    }

    // ➕ Hiển thị form thêm danh mục
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/category-form.jsp");
        dispatcher.forward(request, response);
    }

    // ✏️ Hiển thị form sửa danh mục
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int categoryId = Integer.parseInt(request.getParameter("id"));
        Category category = categoryDAO.getCategoryById(categoryId);
        request.setAttribute("category", category);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/category-form.jsp");
        dispatcher.forward(request, response);
    }

    // 💾 Thêm danh mục mới
    private void insertCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String imagePath = request.getParameter("imagePath");

        Category newCategory = new Category(categoryName, description, imagePath);
        boolean success = categoryDAO.addCategory(newCategory);

        if (success) {
            response.sendRedirect("categories?action=list");
        } else {
            response.getWriter().println("Thêm danh mục thất bại!");
        }
    }

    // 🔄 Cập nhật danh mục
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String imagePath = request.getParameter("imagePath");

        Category category = new Category(categoryId, categoryName, description, imagePath, null);
        boolean success = categoryDAO.updateCategory(category);

        if (success) {
            response.sendRedirect("categories?action=list");
        } else {
            response.getWriter().println("Cập nhật danh mục thất bại!");
        }
    }

    // ❌ Xóa danh mục
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        int categoryId = Integer.parseInt(request.getParameter("id"));
        boolean success = categoryDAO.deleteCategory(categoryId);

        if (success) {
            response.sendRedirect("categories?action=list");
        } else {
            response.getWriter().println("Xóa danh mục thất bại!");
        }
    }
}
```

#### **Servlet: SearchServlet.java**
```java
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.util.*;
import dao.SearchDAO;
import model.Product;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private SearchDAO searchDAO;

    @Override
    public void init() {
        searchDAO = new SearchDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String categoryIdParam = request.getParameter("categoryId");
        String sortBy = request.getParameter("sortBy");  // price, name, date
        String order = request.getParameter("order");    // asc, desc

        int page = 1;
        int pageSize = 12;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        // Mặc định sắp xếp
        if (sortBy == null) sortBy = "date";
        if (order == null) order = "desc";

        List<Product> productList;
        int totalProducts = 0;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Tìm kiếm theo keyword
            productList = searchDAO.searchProducts(keyword);
        } else if (categoryIdParam != null) {
            // Lọc theo danh mục
            int categoryId = Integer.parseInt(categoryIdParam);
            productList = searchDAO.getProductsByCategoryWithSort(categoryId, sortBy, order, page, pageSize);
            totalProducts = searchDAO.countProductsByCategory(categoryId);
        } else {
            // Hiển thị tất cả với sắp xếp
            productList = searchDAO.getProductsSorted(sortBy, order, page, pageSize);
            // totalProducts = ... (gọi method đếm tổng)
        }

        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        request.setAttribute("productList", productList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("order", order);

        RequestDispatcher dispatcher = request.getRequestDispatcher("views/search-results.jsp");
        dispatcher.forward(request, response);
    }
}
```

#### **View: search-results.jsp**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>🔍 KẾT QUẢ TÌM KIẾM</h1>

        <c:if test="${not empty keyword}">
            <p>Tìm kiếm: "<strong>${keyword}</strong>" - Có ${productList.size()} kết quả</p>
        </c:if>

        <!-- Bộ lọc và sắp xếp -->
        <div class="filter-bar">
            <label>Sắp xếp:</label>
            <select onchange="window.location.href='search?keyword=${keyword}&sortBy=' + this.value + '&order=${order}'">
                <option value="date" ${sortBy == 'date' ? 'selected' : ''}>Mới nhất</option>
                <option value="price" ${sortBy == 'price' ? 'selected' : ''}>Giá</option>
                <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Tên A-Z</option>
            </select>

            <select onchange="window.location.href='search?keyword=${keyword}&sortBy=${sortBy}&order=' + this.value">
                <option value="asc" ${order == 'asc' ? 'selected' : ''}>Tăng dần</option>
                <option value="desc" ${order == 'desc' ? 'selected' : ''}>Giảm dần</option>
            </select>
        </div>

        <div class="product-grid">
            <c:forEach var="product" items="${productList}">
                <div class="product-card">
                    <img src="${product.imagePath}" alt="${product.productName}">
                    <h3>${product.productName}</h3>
                    <p class="price">
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                    </p>
                    <a href="products?action=detail&id=${product.productId}" class="btn btn-info">Xem chi tiết</a>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>
```

### 📝 Checklist công việc Thành viên 4

- [ ] Tạo bảng `categories` trong database
- [ ] Tạo class `Category.java` (Model)
- [ ] Tạo class `CategoryDAO.java` với 5 methods CRUD
- [ ] Tạo class `SearchDAO.java` với methods tìm kiếm, lọc, sắp xếp
- [ ] Tạo Servlet `CategoryServlet.java` và `SearchServlet.java`
- [ ] Tạo JSP `category-list.jsp` (danh sách danh mục)
- [ ] Tạo JSP `search-results.jsp` (kết quả tìm kiếm)
- [ ] Implement sắp xếp sản phẩm (giá, tên, ngày)
- [ ] Implement phân trang kết quả
- [ ] Viết CSS cho filter bar
- [ ] Tích hợp với Module 1 (ProductDAO)

---

# PHẦN 4: GIẢI THÍCH MÃ CHI TIẾT

## 4.1. Setup Database & JDBC Connection

### 📊 Tạo Database

```sql
-- Tạo database
CREATE DATABASE snack_shop;
USE snack_shop;

-- Set charset UTF-8
ALTER DATABASE snack_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 🔌 Kết nối JDBC

#### **util/DBConnection.java**
```java
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/snack_shop";
    private static final String USER = "root";
    private static final String PASSWORD = "your_password";

    // 1️⃣ Lấy kết nối đơn giản (không dùng Connection Pool)
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Tạo kết nối
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy MySQL JDBC Driver!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối database!");
            e.printStackTrace();
        }
        return conn;
    }

    // 2️⃣ Test kết nối
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("✅ Kết nối database thành công!");
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("❌ Kết nối database thất bại!");
        }
    }
}
```

**📝 Giải thích:**

1. **DriverManager**: Quản lý các driver JDBC
2. **Class.forName()**: Load driver vào bộ nhớ
3. **getConnection()**: Tạo kết nối tới MySQL
4. **Thông số kết nối**:
   - `localhost:3306`: Máy chủ và cổng MySQL
   - `snack_shop`: Tên database
   - `root` / `password`: Tài khoản MySQL

---

## 4.2. Xây dựng Model Classes (Entity)

### 🎯 Nguyên tắc thiết kế Model

1. **Một Model = Một Bảng** trong database
2. **Mỗi thuộc tính = Một cột** trong bảng
3. **Constructor đầy đủ**: Dùng khi đọc từ DB
4. **Constructor rút gọn**: Dùng khi INSERT (không có ID)
5. **Getter/Setter**: Để truy cập private fields

### 📝 Ví dụ chi tiết: Product.java

```java
package model;

import java.util.Date;

public class Product {
    // 🔹 Private fields (encapsulation)
    private int productId;           // Tự động tăng (AUTO_INCREMENT)
    private String productName;      // NOT NULL
    private String description;      // TEXT
    private double price;            // DECIMAL(10,2)
    private String imagePath;        // VARCHAR(255)
    private int categoryId;          // FOREIGN KEY
    private int stockQuantity;       // INT
    private Date createdDate;        // DATETIME

    // 🔸 Constructor 1: Đầy đủ (dùng cho SELECT)
    public Product(int productId, String productName, String description, 
                   double price, String imagePath, int categoryId, 
                   int stockQuantity, Date createdDate) {
        this.productId = productId;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
        this.stockQuantity = stockQuantity;
        this.createdDate = createdDate;
    }

    // 🔸 Constructor 2: Không có ID (dùng cho INSERT)
    public Product(String productName, String description, double price, 
                   String imagePath, int categoryId, int stockQuantity) {
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
        this.categoryId = categoryId;
        this.stockQuantity = stockQuantity;
        // ID và createdDate sẽ do MySQL tự tạo
    }

    // 🔹 Getter: Trả về giá trị
    public int getProductId() { 
        return productId; 
    }

    // 🔹 Setter: Gán giá trị mới
    public void setProductId(int productId) { 
        this.productId = productId; 
    }

    // ... các getter/setter khác ...

    // 🔸 Method bổ sung: Tính giá sau giảm giá
    public double getDiscountedPrice(double discountPercent) {
        return price * (1 - discountPercent / 100);
    }

    // 🔸 Override toString(): Hiển thị thông tin object
    @Override
    public String toString() {
        return "Product{" +
                "productId=" + productId +
                ", productName='" + productName + '\'' +
                ", price=" + price +
                '}';
    }
}
```

**📝 Giải thích chi tiết:**

1. **Private Fields**: Ẩn dữ liệu, chỉ truy cập qua getter/setter
2. **Constructor đầy đủ**: Dùng khi tạo object từ ResultSet
   ```java
   Product p = new Product(rs.getInt("product_id"), rs.getString("product_name"), ...);
   ```
3. **Constructor rút gọn**: Dùng khi INSERT
   ```java
   Product newProduct = new Product("Snack ABC", "Ngon", 10000, "image.jpg", 1, 100);
   ```

---

## 4.3. Xây dựng DAO Layer (Data Access Object)

### 🎯 DAO Pattern là gì?

DAO Pattern tách biệt **logic truy cập dữ liệu** khỏi **business logic**:

```
┌────────────────┐         ┌────────────────┐         ┌────────────────┐
│    Servlet     │ ------> │      DAO       │ ------> │    Database    │
│ (Business      │  gọi    │ (Data Access)  │  SQL    │    (MySQL)     │
│  Logic)        │  method │                │  Query  │                │
└────────────────┘         └────────────────┘         └────────────────┘
```

### 📝 Ví dụ chi tiết: ProductDAO.java

```java
package dao;

import java.sql.*;
import java.util.*;
import model.Product;
import util.DBConnection;

public class ProductDAO {
    private Connection conn;

    // Constructor: Lấy kết nối DB
    public ProductDAO() {
        this.conn = DBConnection.getConnection();
    }

    // ======== CREATE (INSERT) ========
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (product_name, description, price, " +
                     "image_path, category_id, stock_quantity) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            // 1. Chuẩn bị câu lệnh SQL
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            // 2. Gán giá trị cho các tham số ? (bắt đầu từ 1)
            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getImagePath());
            stmt.setInt(5, product.getCategoryId());
            stmt.setInt(6, product.getStockQuantity());

            // 3. Thực thi câu lệnh
            int rows = stmt.executeUpdate();  // Trả về số dòng bị ảnh hưởng
            
            return rows > 0;  // True nếu thêm thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ======== READ (SELECT ALL) ========
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY created_date DESC";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();  // Thực thi SELECT

            // Duyệt qua từng dòng kết quả
            while (rs.next()) {
                // Tạo object Product từ 1 dòng ResultSet
                Product product = new Product(
                    rs.getInt("product_id"),           // Lấy cột product_id
                    rs.getString("product_name"),      // Lấy cột product_name
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getInt("stock_quantity"),
                    rs.getDate("created_date")
                );
                products.add(product);  // Thêm vào List
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // ======== READ (SELECT BY ID) ========
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);  // Gán tham số ? thứ 1
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {  // Nếu tìm thấy
                return new Product(
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_path"),
                    rs.getInt("category_id"),
                    rs.getInt("stock_quantity"),
                    rs.getDate("created_date")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;  // Không tìm thấy
    }

    // ======== UPDATE ========
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET product_name=?, description=?, price=?, " +
                     "image_path=?, category_id=?, stock_quantity=? WHERE product_id=?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getImagePath());
            stmt.setInt(5, product.getCategoryId());
            stmt.setInt(6, product.getStockQuantity());
            stmt.setInt(7, product.getProductId());  // WHERE product_id = ?

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ======== DELETE ========
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id=?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
```

**📝 Giải thích chi tiết:**

### 🔹 **PreparedStatement vs Statement**

```java
// ❌ Statement (KHÔNG AN TOÀN - SQL Injection)
String sql = "SELECT * FROM products WHERE product_id = " + productId;
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery(sql);

// ✅ PreparedStatement (AN TOÀN)
String sql = "SELECT * FROM products WHERE product_id = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setInt(1, productId);  // Tự động escape ký tự đặc biệt
ResultSet rs = stmt.executeQuery();
```

### 🔹 **executeUpdate() vs executeQuery()**

| Method | Công dụng | Câu lệnh SQL | Trả về |
|--------|-----------|--------------|--------|
| `executeUpdate()` | Thay đổi dữ liệu | INSERT, UPDATE, DELETE | `int` (số dòng bị ảnh hưởng) |
| `executeQuery()` | Truy vấn dữ liệu | SELECT | `ResultSet` (tập kết quả) |

### 🔹 **ResultSet: Duyệt kết quả**

```java
ResultSet rs = stmt.executeQuery();

// Duyệt từng dòng
while (rs.next()) {  // Di chuyển con trỏ xuống dòng tiếp theo
    int id = rs.getInt("product_id");           // Lấy theo tên cột
    String name = rs.getString(2);              // Hoặc lấy theo index (bắt đầu từ 1)
    double price = rs.getDouble("price");
}
```

---

## 4.4. Xây dựng Servlet Layer (Controller)

### 🎯 Servlet là gì?

Servlet là **Java class** xử lý HTTP requests từ client:

```
Browser (GET /products?action=list)
   │
   ▼
Tomcat Server
   │
   ▼
ProductServlet.doGet()
   │
   ▼
ProductDAO.getAllProducts()
   │
   ▼
Database
```

### 📝 Ví dụ chi tiết: ProductServlet.java

```java
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import dao.ProductDAO;
import model.Product;

// Annotation: Map URL /products tới servlet này
@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    // ============ init(): Khởi tạo khi servlet load ============
    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    // ============ doGet(): Xử lý GET requests ============
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy tham số action từ URL
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";  // Mặc định hiển thị danh sách
        }

        // Routing: Gọi method tương ứng
        switch (action) {
            case "list":
                listProducts(request, response);
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
            default:
                listProducts(request, response);
        }
    }

    // ============ doPost(): Xử lý POST requests ============
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");  // Xử lý tiếng Việt
        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            default:
                listProducts(request, response);
        }
    }

    // ======== LIST: Hiển thị danh sách sản phẩm ========
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Gọi DAO để lấy dữ liệu
        List<Product> productList = productDAO.getAllProducts();
        
        // 2. Đưa dữ liệu vào request scope
        request.setAttribute("productList", productList);
        
        // 3. Forward sang JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/product-list.jsp");
        dispatcher.forward(request, response);
    }

    // ======== DETAIL: Hiển thị chi tiết sản phẩm ========
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy tham số id từ URL
        int productId = Integer.parseInt(request.getParameter("id"));
        
        // 2. Gọi DAO
        Product product = productDAO.getProductById(productId);
        
        // 3. Đưa dữ liệu vào request
        request.setAttribute("product", product);
        
        // 4. Forward sang JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/product-detail.jsp");
        dispatcher.forward(request, response);
    }

    // ======== INSERT: Thêm sản phẩm mới ========
    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        // 1. Lấy dữ liệu từ form
        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
        String imagePath = request.getParameter("imagePath");

        // 2. Tạo object Product
        Product newProduct = new Product(productName, description, price, imagePath, 
                                         categoryId, stockQuantity);

        // 3. Gọi DAO để lưu vào DB
        boolean success = productDAO.addProduct(newProduct);

        // 4. Redirect về danh sách
        if (success) {
            response.sendRedirect("products?action=list");
        } else {
            response.getWriter().println("Thêm sản phẩm thất bại!");
        }
    }

    // ... các method khác tương tự ...
}
```

**📝 Giải thích chi tiết:**

### 🔹 **doGet vs doPost**

| Method | Mục đích | Ví dụ |
|--------|----------|-------|
| `doGet()` | **Xem** dữ liệu | Hiển thị danh sách, chi tiết, form |
| `doPost()` | **Thay đổi** dữ liệu | Thêm, sửa, xóa |

### 🔹 **Request Parameters**

```java
// URL: /products?action=detail&id=5
String action = request.getParameter("action");  // "detail"
String idStr = request.getParameter("id");       // "5" (String!)
int id = Integer.parseInt(idStr);                // Chuyển sang int
```

### 🔹 **Request Attributes**

```java
// Servlet: Đưa dữ liệu vào request
request.setAttribute("productList", productList);

// JSP: Lấy dữ liệu ra
${productList}  // Expression Language
```

### 🔹 **Forward vs Redirect**

| | Forward | Redirect |
|---|---------|----------|
| **Cách dùng** | `dispatcher.forward(request, response)` | `response.sendRedirect("url")` |
| **URL thay đổi?** | ❌ Không | ✅ Có |
| **Request mới?** | ❌ Giữ request cũ | ✅ Tạo request mới |
| **Dùng khi nào?** | Chuyển sang JSP | Chuyển sang Servlet khác |

```java
// Forward: URL vẫn là /products
RequestDispatcher dispatcher = request.getRequestDispatcher("views/list.jsp");
dispatcher.forward(request, response);

// Redirect: URL đổi thành /products?action=list
response.sendRedirect("products?action=list");
```

---

## 4.5. Xây dựng JSP Layer (View)

### 🎯 JSP là gì?

JSP (JavaServer Pages) = **HTML + Java code** để hiển thị dữ liệu động:

```jsp
<!-- HTML tĩnh -->
<h1>Danh sách sản phẩm</h1>

<!-- JSTL: Lặp qua danh sách -->
<c:forEach var="product" items="${productList}">
    <p>${product.productName}</p>  <!-- Expression Language -->
</c:forEach>
```

### 📝 Ví dụ chi tiết: product-list.jsp

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>🛍️ DANH SÁCH SẢN PHẨM</h1>
        
        <!-- Kiểm tra điều kiện -->
        <c:if test="${sessionScope.currentUser.role == 'admin'}">
            <a href="products?action=new" class="btn btn-primary">➕ Thêm sản phẩm mới</a>
        </c:if>

        <!-- Lặp qua danh sách -->
        <div class="product-grid">
            <c:forEach var="product" items="${productList}">
                <div class="product-card">
                    <img src="${product.imagePath}" alt="${product.productName}">
                    <h3>${product.productName}</h3>
                    <p>${product.description}</p>
                    <p class="price">
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
                    </p>
                    <p class="stock">Kho: ${product.stockQuantity}</p>
                    
                    <div class="actions">
                        <a href="products?action=detail&id=${product.productId}" class="btn btn-info">Chi tiết</a>
                        
                        <c:if test="${sessionScope.currentUser != null}">
                            <a href="cart?action=add&productId=${product.productId}" class="btn btn-success">Thêm giỏ</a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>
```

**📝 Giải thích chi tiết:**

### 🔹 **JSTL Core Tags**

```jsp
<!-- 1. Khai báo JSTL -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 2. Kiểm tra điều kiện -->
<c:if test="${condition}">
    <!-- Code chỉ chạy nếu condition = true -->
</c:if>

<!-- 3. If-else -->
<c:choose>
    <c:when test="${user.role == 'admin'}">
        <p>Bạn là Admin</p>
    </c:when>
    <c:otherwise>
        <p>Bạn là User thường</p>
    </c:otherwise>
</c:choose>

<!-- 4. Vòng lặp forEach -->
<c:forEach var="product" items="${productList}">
    <p>${product.productName}</p>
</c:forEach>

<!-- 5. Set variable -->
<c:set var="total" value="${price * quantity}" />
```

### 🔹 **Expression Language (EL)**

```jsp
<!-- Cú pháp: ${expression} -->

${product.productName}           ← Tương đương: product.getProductName()
${productList[0].price}          ← Lấy phần tử đầu tiên
${empty productList}             ← Kiểm tra list rỗng
${product.price * 0.9}           ← Tính toán

<!-- Scope -->
${requestScope.productList}      ← Lấy từ request scope
${sessionScope.currentUser}      ← Lấy từ session scope
${applicationScope.appName}      ← Lấy từ application scope
```

### 🔹 **JSTL Format Tags**

```jsp
<!-- Khai báo -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- Format số tiền -->
<fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/>
<!-- Output: 10,000₫ -->

<!-- Format ngày tháng -->
<fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
<!-- Output: 25/12/2024 14:30 -->
```

---

## 4.6. Session & Cookie Management

### 🎯 Session là gì?

Session lưu trữ dữ liệu **tạm thời** của 1 user trên **server**:

```
┌─────────────┐         ┌─────────────┐
│   Browser   │ ------> │   Tomcat    │
│             │  JSESSIONID │ Session  │
│             │ <------ │ {user: ...} │
└─────────────┘         └─────────────┘
```

### 📝 Ví dụ: LoginServlet.java

```java
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import dao.UserDAO;
import model.User;

public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy username/password từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 2. Xác thực với DAO
        User user = userDAO.authenticate(username, password);

        if (user != null) {
            // ✅ Đăng nhập thành công

            // 3. Tạo session (hoặc lấy session hiện tại)
            HttpSession session = request.getSession();

            // 4. Lưu user vào session
            session.setAttribute("currentUser", user);

            // 5. Redirect về trang chủ
            response.sendRedirect("products?action=list");
        } else {
            // ❌ Đăng nhập thất bại

            // 6. Đưa thông báo lỗi vào request
            request.setAttribute("errorMessage", "Sai tên đăng nhập hoặc mật khẩu!");

            // 7. Forward về trang login
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
}
```

### 📝 LogoutServlet.java

```java
package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        // 1. Lấy session hiện tại (không tạo mới)
        HttpSession session = request.getSession(false);

        if (session != null) {
            // 2. Hủy session
            session.invalidate();
        }

        // 3. Redirect về trang login
        response.sendRedirect("login.jsp");
    }
}
```

### 📝 Sử dụng Session trong JSP

```jsp
<%-- Kiểm tra user đã đăng nhập chưa --%>
<c:if test="${sessionScope.currentUser != null}">
    <p>Xin chào, ${sessionScope.currentUser.fullName}!</p>
    <a href="logout">Đăng xuất</a>
</c:if>

<c:if test="${sessionScope.currentUser == null}">
    <a href="login.jsp">Đăng nhập</a>
</c:if>
```

### 🔹 **Session Methods**

| Method | Mô tả |
|--------|-------|
| `request.getSession()` | Lấy session hiện tại hoặc tạo mới |
| `request.getSession(false)` | Lấy session hiện tại, không tạo mới |
| `session.setAttribute(key, value)` | Lưu dữ liệu vào session |
| `session.getAttribute(key)` | Lấy dữ liệu từ session |
| `session.removeAttribute(key)` | Xóa 1 attribute |
| `session.invalidate()` | Hủy session (đăng xuất) |
| `session.setMaxInactiveInterval(seconds)` | Set thời gian sống session |

---

## 4.7. Filter & Security

### 🎯 Filter là gì?

Filter chặn **tất cả requests** trước khi tới Servlet:

```
Browser
   │
   ▼
┌──────────────────┐
│ LoginFilter      │  ← Kiểm tra session
│ EncodingFilter   │  ← Set UTF-8
└──────────────────┘
   │
   ▼
Servlet
```

### 📝 Ví dụ: LoginFilter.java

```java
package filter;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LoginFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);  // Không tạo session mới

        String uri = req.getRequestURI();
        
        // ✅ Các trang không cần đăng nhập
        if (uri.endsWith("login.jsp") || 
            uri.endsWith("/login") || 
            uri.endsWith("/logout") ||
            uri.endsWith(".css") ||
            uri.endsWith(".js")) {
            
            chain.doFilter(request, response);  // Cho phép tiếp tục
            return;
        }

        // ❌ Kiểm tra session
        if (session != null && session.getAttribute("currentUser") != null) {
            chain.doFilter(request, response);  // Đã đăng nhập → Cho phép
        } else {
            res.sendRedirect(req.getContextPath() + "/login.jsp");  // Chưa đăng nhập → Redirect
        }
    }

    @Override
    public void destroy() {
        // Dọn dẹp khi filter bị hủy
    }
}
```

### 📝 Cấu hình Filter trong web.xml

```xml
<filter>
    <filter-name>LoginFilter</filter-name>
    <filter-class>filter.LoginFilter</filter-class>
</filter>

<filter-mapping>
    <filter-name>LoginFilter</filter-name>
    <url-pattern>/*</url-pattern>  <!-- Áp dụng cho tất cả URL -->
</filter-mapping>

<!-- Encoding Filter -->
<filter>
    <filter-name>EncodingFilter</filter-name>
    <filter-class>filter.EncodingFilter</filter-class>
</filter>

<filter-mapping>
    <filter-name>EncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

### 📝 EncodingFilter.java (Xử lý tiếng Việt)

```java
package filter;

import java.io.*;
import javax.servlet.*;

public class EncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // Set encoding UTF-8 cho request và response
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        chain.doFilter(request, response);  // Tiếp tục xử lý
    }
}
```

---

# 🎉 KẾT LUẬN

## ✅ Tổng kết tài liệu

Tài liệu này cung cấp:

1. **Phần 1**: Phân tích chi tiết source code DemoNewsWeb (MVC, DAO Pattern, Servlet, JSP)
2. **Phần 2**: Đề xuất 5 module cho Website Bán Đồ Ăn Vặt
3. **Phần 3**: Phân công 4 thành viên với code mẫu đầy đủ
4. **Phần 4**: Giải thích mã chi tiết từng layer (Database, Model, DAO, Servlet, JSP, Session, Filter)

## 📚 Tài liệu tham khảo

- Giáo trình JSP/Servlet cơ bản (từ 9 PDF đã phân tích)
- DemoNewsWeb_Login_Filter_MySQL.war (source code mẫu)
- Database schema đã thiết kế

## 🚀 Các bước tiếp theo

1. Setup môi trường (JDK, Eclipse, Tomcat, MySQL)
2. Tạo database và import schema
3. Mỗi thành viên code module của mình
4. Tích hợp 4 modules lại với nhau
5. Test toàn bộ hệ thống
6. Deploy lên server thực tế

---

**📧 Liên hệ hỗ trợ:**
- Email: support@example.com
- Slack: #web-project-team

**✨ Chúc các bạn code thành công!**

