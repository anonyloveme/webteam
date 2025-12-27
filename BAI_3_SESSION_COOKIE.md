# 📘 BÀI 3: SESSION & COOKIE

## 🎯 Mục Đích Học
- Hiểu vấn đề "Stateless" của HTTP và cách giải quyết
- Biết cách sử dụng Session để lưu trữ thông tin người dùng
- Biết cách sử dụng Cookie để ghi nhớ người dùng
- Xây dựng chức năng Đăng nhập/Đăng xuất
- Xây dựng Giỏ hàng đơn giản

---

## 📖 3.1. VẤN ĐỀ STATELESS CỦA HTTP

### **HTTP là Stateless (Không trạng thái)**

```
Request 1: User đăng nhập      ->  Server: OK, đăng nhập thành công
Request 2: User xem sản phẩm   ->  Server: Bạn là ai? (Không nhớ)
Request 3: User thêm vào giỏ   ->  Server: Bạn là ai? (Không nhớ)
```

**Vấn đề:**
- Mỗi HTTP Request là **độc lập**, Server không nhớ Request trước đó
- Sau khi đăng nhập, Request tiếp theo Server vẫn không biết bạn là ai
- Không thể lưu trữ trạng thái người dùng (đã đăng nhập, giỏ hàng...)

**Giải pháp:**
1. **Cookie**: Lưu dữ liệu ở Client (trình duyệt)
2. **Session**: Lưu dữ liệu ở Server, dùng Cookie để định danh

---

## 📖 3.2. COOKIE LÀ GÌ?

### **Định nghĩa:**
- **Cookie**: File text nhỏ lưu trên trình duyệt của Client
- **Mục đích**: Lưu trữ thông tin nhỏ (username, theme, ngôn ngữ...)
- **Giới hạn**: Tối đa 4KB / cookie, tối đa 50 cookies / domain

### **Cách Cookie hoạt động:**

```
[CLIENT]                            [SERVER]
   |                                    |
   | 1. Request: GET /login            |
   |---------------------------------->|
   |                                    | 2. Xử lý đăng nhập
   |                                    | 3. Tạo Cookie
   |                                    |    Set-Cookie: username=john
   | 4. Response + Set-Cookie           |
   |<----------------------------------|
   | 5. Lưu Cookie vào trình duyệt     |
   |                                    |
   | 6. Request tiếp theo               |
   |    Cookie: username=john           |
   |---------------------------------->|
   |                                    | 7. Đọc Cookie -> Biết user là john
```

### **Tạo Cookie trong Java:**

```java
// 1. TẠO COOKIE
Cookie cookie = new Cookie("username", "john");
// Tham số 1: Tên cookie
// Tham số 2: Giá trị cookie

// 2. ĐẶT THỜI GIAN TỒN TẠI (Tuỳ chọn)
cookie.setMaxAge(7 * 24 * 60 * 60);  // 7 ngày (đơn vị: giây)
// Nếu không set: Cookie chỉ tồn tại trong phiên làm việc (đóng trình duyệt = mất)
// setMaxAge(0): Xóa cookie
// setMaxAge(-1): Cookie tồn tại tạm thời

// 3. ĐẶT ĐƯỜNG DẪN (Tuỳ chọn)
cookie.setPath("/");  // Cookie có hiệu lực cho toàn bộ ứng dụng
// Mặc định: Chỉ có hiệu lực cho URL hiện tại

// 4. GỬI COOKIE VỀ CLIENT
response.addCookie(cookie);
```

**Giải thích:**
- `setMaxAge(seconds)`: Thời gian cookie tồn tại (tính bằng giây)
  - `> 0`: Cookie tồn tại số giây đó
  - `= 0`: Xóa cookie ngay lập tức
  - `< 0` hoặc không set: Cookie tạm thời (đóng trình duyệt = mất)
- `setPath("/")`: Cookie có hiệu lực cho tất cả URL của domain

### **Đọc Cookie trong Java:**

```java
// Lấy tất cả cookies từ Request
Cookie[] cookies = request.getCookies();

// Duyệt qua các cookies để tìm cookie cần thiết
String username = null;
if (cookies != null) {
    for (Cookie cookie : cookies) {
        if ("username".equals(cookie.getName())) {
            username = cookie.getValue();
            break;
        }
    }
}

if (username != null) {
    System.out.println("User: " + username);
} else {
    System.out.println("Cookie không tồn tại");
}
```

### **Xóa Cookie:**

```java
// Tạo cookie cùng tên, set MaxAge = 0
Cookie cookie = new Cookie("username", "");
cookie.setMaxAge(0);  // Xóa ngay lập tức
cookie.setPath("/");  // Phải giống Path khi tạo
response.addCookie(cookie);
```

### **Ưu & Nhược điểm của Cookie:**

| **Ưu điểm** | **Nhược điểm** |
|-------------|----------------|
| Lưu trữ ở Client (giảm tải Server) | Dung lượng nhỏ (4KB) |
| Tồn tại lâu dài (có thể set) | Không bảo mật (user có thể xem/sửa) |
| Dùng cho "Ghi nhớ đăng nhập" | Gửi kèm mọi Request (tốn băng thông) |

---

## 📖 3.3. SESSION LÀ GÌ?

### **Định nghĩa:**
- **Session**: Vùng nhớ trên Server lưu trữ thông tin người dùng
- **Mục đích**: Lưu dữ liệu quan trọng, nhạy cảm (thông tin đăng nhập, giỏ hàng...)
- **Giới hạn**: Không giới hạn dung lượng (chỉ giới hạn bởi RAM Server)

### **Cách Session hoạt động:**

```
[CLIENT]                            [SERVER]
   |                                    |
   | 1. Request: GET /login            |
   |---------------------------------->|
   |                                    | 2. Tạo Session mới
   |                                    |    Session ID: ABC123
   |                                    |    Lưu: username=john
   |                                    | 3. Tạo Cookie chứa Session ID
   |                                    |    Set-Cookie: JSESSIONID=ABC123
   | 4. Response + Set-Cookie           |
   |<----------------------------------|
   | 5. Lưu Cookie JSESSIONID          |
   |                                    |
   | 6. Request tiếp theo               |
   |    Cookie: JSESSIONID=ABC123       |
   |---------------------------------->|
   |                                    | 7. Đọc Session ID từ Cookie
   |                                    | 8. Lấy Session tương ứng
   |                                    | 9. Biết user là john
```

**Giải thích:**
1. Server tạo Session mới cho mỗi người dùng
2. Mỗi Session có 1 **Session ID** duy nhất
3. Server gửi Session ID về Client qua Cookie `JSESSIONID`
4. Client gửi Cookie này trong mọi Request tiếp theo
5. Server dùng Session ID để tìm Session tương ứng

### **Sử dụng Session trong Java:**

```java
// 1. LẤY SESSION (Tạo mới nếu chưa có)
HttpSession session = request.getSession();
// getSession(): Lấy session hiện tại, nếu không có thì tạo mới
// getSession(false): Lấy session hiện tại, nếu không có thì return null

// 2. GHI DỮ LIỆU VÀO SESSION
session.setAttribute("username", "john");
session.setAttribute("role", "admin");
session.setAttribute("cart", cartObject);
// Có thể lưu bất kỳ Object nào

// 3. ĐỌC DỮ LIỆU TỪ SESSION
String username = (String) session.getAttribute("username");
// getAttribute trả về Object, cần ép kiểu (cast) về kiểu cần dùng

// Kiểm tra null trước khi dùng
if (username != null) {
    System.out.println("Xin chào, " + username);
} else {
    System.out.println("Chưa đăng nhập");
}

// 4. XÓA THUỘC TÍNH KHỎI SESSION
session.removeAttribute("username");

// 5. HỦY SESSION (Đăng xuất)
session.invalidate();
// Xóa toàn bộ dữ liệu trong session
```

**Các phương thức quan trọng:**

```java
// Lấy Session ID
String sessionId = session.getId();

// Kiểm tra Session mới tạo hay không
boolean isNew = session.isNew();

// Đặt thời gian timeout (giây)
session.setMaxInactiveInterval(30 * 60);  // 30 phút
// Sau 30 phút không hoạt động, Session tự động hủy

// Lấy thời gian tạo Session
long creationTime = session.getCreationTime();

// Lấy thời gian truy cập cuối
long lastAccessTime = session.getLastAccessedTime();
```

### **Session Scope:**

```
APPLICATION SCOPE
├── SESSION SCOPE (User A)
│   ├── REQUEST SCOPE (Request 1)
│   └── REQUEST SCOPE (Request 2)
└── SESSION SCOPE (User B)
    ├── REQUEST SCOPE (Request 3)
    └── REQUEST SCOPE (Request 4)
```

- **Application Scope**: Dùng chung cho toàn bộ ứng dụng (mọi user)
- **Session Scope**: Riêng cho mỗi user (user A khác user B)
- **Request Scope**: Riêng cho mỗi request (chỉ tồn tại trong 1 request)

### **So sánh Cookie vs Session:**

| **Tiêu chí** | **Cookie** | **Session** |
|--------------|------------|-------------|
| **Lưu trữ** | Client (Trình duyệt) | Server |
| **Dung lượng** | Nhỏ (4KB) | Lớn (giới hạn bởi RAM) |
| **Bảo mật** | Thấp (user có thể xem/sửa) | Cao (user không truy cập được) |
| **Thời gian tồn tại** | Lâu dài (có thể set) | Ngắn (timeout sau vài phút) |
| **Dùng cho** | Ghi nhớ đăng nhập, theme... | Đăng nhập, giỏ hàng... |

---

## 💻 3.4. THỰC HÀNH: XÂY DỰNG CHỨC NĂNG ĐĂNG NHẬP

### **Mục tiêu:**
- Xây dựng form đăng nhập
- Kiểm tra username/password (giả lập, chưa dùng Database)
- Lưu thông tin đăng nhập vào Session
- Sử dụng Cookie để "Ghi nhớ đăng nhập"
- Xây dựng trang Admin (chỉ user đã đăng nhập mới truy cập được)
- Xây dựng chức năng Đăng xuất

### **Bước 1: Tạo Model `User.java`**

```java
package model;

import java.io.Serializable;

/**
 * Class đại diện cho User (Người dùng)
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String username;
    private String password;
    private String fullName;
    private String role;  // "admin" hoặc "user"
    
    // Constructor
    public User() {
    }
    
    public User(String username, String password, String fullName, String role) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
    }
    
    // Getter & Setter
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
}
```

### **Bước 2: Tạo DAO `UserDAO.java` (Giả lập Database)**

```java
package dao;

import model.User;
import java.util.HashMap;
import java.util.Map;

/**
 * Data Access Object cho User
 * (Giả lập Database bằng HashMap)
 */
public class UserDAO {
    // Giả lập bảng User bằng HashMap
    // Key: username, Value: User object
    private static Map<String, User> userDatabase = new HashMap<>();
    
    // Khởi tạo dữ liệu giả (Static block - chạy 1 lần khi class được load)
    static {
        userDatabase.put("admin", new User("admin", "admin123", "Quản trị viên", "admin"));
        userDatabase.put("john", new User("john", "john123", "John Doe", "user"));
        userDatabase.put("mary", new User("mary", "mary123", "Mary Jane", "user"));
    }
    
    /**
     * Kiểm tra đăng nhập
     * @param username Tên đăng nhập
     * @param password Mật khẩu
     * @return User nếu đúng, null nếu sai
     */
    public User checkLogin(String username, String password) {
        // Lấy user từ "database"
        User user = userDatabase.get(username);
        
        // Kiểm tra:
        // 1. User có tồn tại không?
        // 2. Password có đúng không?
        if (user != null && user.getPassword().equals(password)) {
            return user;  // Đăng nhập thành công
        }
        
        return null;  // Đăng nhập thất bại
    }
    
    /**
     * Lấy User theo username (dùng cho "Ghi nhớ đăng nhập")
     */
    public User getUserByUsername(String username) {
        return userDatabase.get(username);
    }
}
```

**Giải thích:**
- `HashMap<String, User>`: Cấu trúc dữ liệu lưu cặp Key-Value
  - Key: username (String)
  - Value: User object
- `static`: Biến static được chia sẻ cho tất cả instance (giả lập database chung)
- Trong thực tế: Thay HashMap bằng câu lệnh SQL `SELECT * FROM tbluser WHERE username=? AND password=?`

### **Bước 3: Tạo Servlet `LoginServlet.java`**

```java
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;

/**
 * Servlet xử lý Đăng nhập
 * URL: /login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO = new UserDAO();
    
    /**
     * doGet: Hiển thị trang đăng nhập
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra Cookie "rememberedUser" (Ghi nhớ đăng nhập)
        Cookie[] cookies = request.getCookies();
        String rememberedUsername = null;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUser".equals(cookie.getName())) {
                    rememberedUsername = cookie.getValue();
                    break;
                }
            }
        }
        
        // Nếu có cookie "ghi nhớ", tự động đăng nhập
        if (rememberedUsername != null) {
            User user = userDAO.getUserByUsername(rememberedUsername);
            
            if (user != null) {
                // Lưu user vào Session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Chuyển hướng về trang chủ Admin
                response.sendRedirect("adminHome");
                return;
            }
        }
        
        // Hiển thị trang đăng nhập
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    /**
     * doPost: Xử lý đăng nhập
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");  // Checkbox "Ghi nhớ"
        
        // Kiểm tra đăng nhập
        User user = userDAO.checkLogin(username, password);
        
        if (user != null) {
            // ===== ĐĂNG NHẬP THÀNH CÔNG =====
            
            // 1. Lưu User vào Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60);  // Timeout 30 phút
            
            // 2. Xử lý "Ghi nhớ đăng nhập"
            if ("on".equals(remember)) {
                // Tạo Cookie lưu username
                Cookie cookie = new Cookie("rememberedUser", username);
                cookie.setMaxAge(7 * 24 * 60 * 60);  // Lưu 7 ngày
                cookie.setPath("/");
                response.addCookie(cookie);
            } else {
                // Xóa Cookie nếu không chọn "Ghi nhớ"
                Cookie cookie = new Cookie("rememberedUser", "");
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);
            }
            
            // 3. Chuyển hướng về trang Admin
            response.sendRedirect("adminHome");
            
        } else {
            // ===== ĐĂNG NHẬP THẤT BẠI =====
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
```

**Giải thích chi tiết:**

1. **Kiểm tra Cookie "Ghi nhớ":**
```java
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        if ("rememberedUser".equals(cookie.getName())) {
            // Tìm thấy cookie -> Tự động đăng nhập
        }
    }
}
```

2. **Lưu User vào Session:**
```java
HttpSession session = request.getSession();
session.setAttribute("user", user);
```
- Lưu toàn bộ object User vào Session
- Key: `"user"` (dùng để lấy ra sau này)
- JSP có thể truy cập: `${user.fullName}`

3. **Xử lý Checkbox "Ghi nhớ":**
```java
String remember = request.getParameter("remember");
if ("on".equals(remember)) {
    // Checkbox được chọn -> Tạo Cookie
}
```
- Checkbox HTML: `<input type="checkbox" name="remember" />`
- Nếu được chọn: `value = "on"`
- Nếu không chọn: `value = null`

### **Bước 4: Tạo View `login.jsp`**

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        
        .login-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            width: 350px;
        }
        
        .login-container h1 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: bold;
        }
        
        .form-group input[type="text"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        
        .form-group input:focus {
            border-color: #667eea;
            outline: none;
        }
        
        .remember-group {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .remember-group input[type="checkbox"] {
            margin-right: 8px;
        }
        
        .btn-login {
            width: 100%;
            padding: 12px;
            background-color: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            font-weight: bold;
        }
        
        .btn-login:hover {
            background-color: #5568d3;
        }
        
        .error {
            background-color: #ffe6e6;
            color: #d8000c;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .hint {
            margin-top: 20px;
            padding: 15px;
            background-color: #e7f3ff;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .hint strong {
            color: #0066cc;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>🔐 Đăng Nhập</h1>
        
        <!-- HIỂN THỊ LỖI -->
        <c:if test="${not empty errorMessage}">
            <div class="error">
                ❌ ${errorMessage}
            </div>
        </c:if>
        
        <!-- FORM ĐĂNG NHẬP -->
        <form action="login" method="POST">
            <div class="form-group">
                <label for="username">Tên đăng nhập:</label>
                <input type="text" id="username" name="username" 
                       placeholder="Nhập tên đăng nhập" required />
            </div>
            
            <div class="form-group">
                <label for="password">Mật khẩu:</label>
                <input type="password" id="password" name="password" 
                       placeholder="Nhập mật khẩu" required />
            </div>
            
            <div class="remember-group">
                <input type="checkbox" id="remember" name="remember" />
                <label for="remember">Ghi nhớ đăng nhập</label>
            </div>
            
            <button type="submit" class="btn-login">Đăng nhập</button>
        </form>
        
        <!-- HƯỚNG DẪN -->
        <div class="hint">
            <strong>💡 Tài khoản Demo:</strong><br>
            👤 Admin: <code>admin / admin123</code><br>
            👤 User: <code>john / john123</code>
        </div>
    </div>
</body>
</html>
```

**Giải thích:**
- Checkbox "Ghi nhớ": `<input type="checkbox" name="remember" />`
  - Nếu được chọn: gửi `remember=on`
  - Nếu không chọn: không gửi tham số `remember`
- CSS Gradient: `background: linear-gradient(...)` tạo hiệu ứng màu gradient

### **Bước 5: Tạo Servlet `AdminHomeServlet.java` (Trang chỉ dành cho user đã đăng nhập)**

```java
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;

/**
 * Trang Admin (Chỉ user đã đăng nhập mới truy cập được)
 */
@WebServlet("/adminHome")
public class AdminHomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);  // false: Không tạo mới nếu chưa có
        
        if (session == null || session.getAttribute("user") == null) {
            // Chưa đăng nhập -> Chuyển về trang login
            response.sendRedirect("login");
            return;
        }
        
        // Đã đăng nhập -> Lấy thông tin user
        User user = (User) session.getAttribute("user");
        
        // Chuyển tiếp tới trang adminHome.jsp
        request.setAttribute("user", user);
        request.getRequestDispatcher("adminHome.jsp").forward(request, response);
    }
}
```

**Giải thích:**
- `getSession(false)`: Lấy Session hiện tại, **KHÔNG** tạo mới nếu chưa có
  - Nếu chưa đăng nhập: `session = null`
  - Nếu đã đăng nhập: `session != null`
- Kiểm tra `session.getAttribute("user")`: 
  - Nếu `null`: Chưa đăng nhập
  - Nếu `!= null`: Đã đăng nhập

### **Bước 6: Tạo View `adminHome.jsp`**

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Admin</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        
        .header {
            background-color: #333;
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            margin: 0;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info span {
            font-size: 16px;
        }
        
        .btn-logout {
            padding: 10px 20px;
            background-color: #dc3545;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        
        .btn-logout:hover {
            background-color: #c82333;
        }
        
        .content {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .welcome-box {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .welcome-box h2 {
            color: #333;
            margin-bottom: 20px;
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            grid-gap: 20px;
            margin-top: 30px;
        }
        
        .menu-item {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            text-decoration: none;
            color: #333;
            transition: transform 0.3s;
        }
        
        .menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        }
        
        .menu-item h3 {
            margin-top: 15px;
            color: #667eea;
        }
    </style>
</head>
<body>
    <!-- HEADER -->
    <div class="header">
        <h1>🏠 Trang Quản Trị</h1>
        <div class="user-info">
            <span>👤 Xin chào, <strong>${user.fullName}</strong> (${user.role})</span>
            <a href="logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </div>
    
    <!-- CONTENT -->
    <div class="content">
        <div class="welcome-box">
            <h2>Chào mừng đến với hệ thống quản lý đồ ăn vặt! 🍿</h2>
            <p>Bạn đang đăng nhập với tài khoản: <strong>${user.username}</strong></p>
        </div>
        
        <div class="menu-grid">
            <a href="products?action=list" class="menu-item">
                <div style="font-size: 48px;">📦</div>
                <h3>Quản lý Sản phẩm</h3>
                <p>Thêm, sửa, xóa sản phẩm</p>
            </a>
            
            <a href="categories?action=list" class="menu-item">
                <div style="font-size: 48px;">📂</div>
                <h3>Quản lý Danh mục</h3>
                <p>Quản lý danh mục sản phẩm</p>
            </a>
            
            <a href="orders?action=list" class="menu-item">
                <div style="font-size: 48px;">📋</div>
                <h3>Quản lý Đơn hàng</h3>
                <p>Xem và xử lý đơn hàng</p>
            </a>
        </div>
    </div>
</body>
</html>
```

### **Bước 7: Tạo Servlet `LogoutServlet.java` (Đăng xuất)**

```java
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Xử lý Đăng xuất
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Hủy Session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();  // Xóa toàn bộ dữ liệu trong Session
        }
        
        // 2. Xóa Cookie "Ghi nhớ đăng nhập" (Nếu có)
        Cookie cookie = new Cookie("rememberedUser", "");
        cookie.setMaxAge(0);  // Xóa ngay
        cookie.setPath("/");
        response.addCookie(cookie);
        
        // 3. Chuyển về trang login
        response.sendRedirect("login");
    }
}
```

**Giải thích:**
1. `session.invalidate()`: Hủy Session hiện tại (xóa tất cả dữ liệu)
2. Xóa Cookie "rememberedUser": Người dùng sẽ phải đăng nhập lại lần sau
3. `sendRedirect("login")`: Chuyển hướng về trang đăng nhập

---

## 💻 3.5. THỰC HÀNH: XÂY DỰNG GIỎ HÀNG ĐƠN GIẢN

### **Mục tiêu:**
- Tạo Model `Cart` (Giỏ hàng) và `CartItem` (Mục trong giỏ)
- Lưu giỏ hàng vào Session
- Thêm sản phẩm vào giỏ
- Xem giỏ hàng
- Cập nhật số lượng
- Xóa sản phẩm khỏi giỏ

### **Bước 1: Tạo Model `CartItem.java`**

```java
package model;

import java.io.Serializable;

/**
 * Đại diện cho 1 mục trong giỏ hàng
 */
public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Product product;  // Sản phẩm
    private int quantity;     // Số lượng
    
    public CartItem() {
    }
    
    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }
    
    // Getter & Setter
    public Product getProduct() {
        return product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    /**
     * Tính tổng tiền = Giá * Số lượng
     */
    public double getSubtotal() {
        return product.getPrice() * quantity;
    }
}
```

### **Bước 2: Tạo Model `Cart.java`**

```java
package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Đại diện cho Giỏ hàng
 */
public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Danh sách các mục trong giỏ
    private List<CartItem> items = new ArrayList<>();
    
    /**
     * Thêm sản phẩm vào giỏ
     * - Nếu sản phẩm đã có: Tăng số lượng
     * - Nếu sản phẩm chưa có: Thêm mới
     */
    public void addProduct(Product product, int quantity) {
        // Tìm xem sản phẩm đã có trong giỏ chưa
        for (CartItem item : items) {
            if (item.getProduct().getId() == product.getId()) {
                // Đã có -> Tăng số lượng
                item.setQuantity(item.getQuantity() + quantity);
                return;
            }
        }
        
        // Chưa có -> Thêm mới
        items.add(new CartItem(product, quantity));
    }
    
    /**
     * Cập nhật số lượng sản phẩm
     */
    public void updateQuantity(int productId, int quantity) {
        for (CartItem item : items) {
            if (item.getProduct().getId() == productId) {
                if (quantity <= 0) {
                    // Số lượng <= 0 -> Xóa khỏi giỏ
                    items.remove(item);
                } else {
                    item.setQuantity(quantity);
                }
                return;
            }
        }
    }
    
    /**
     * Xóa sản phẩm khỏi giỏ
     */
    public void removeProduct(int productId) {
        items.removeIf(item -> item.getProduct().getId() == productId);
    }
    
    /**
     * Xóa toàn bộ giỏ hàng
     */
    public void clear() {
        items.clear();
    }
    
    /**
     * Tính tổng tiền
     */
    public double getTotalPrice() {
        double total = 0;
        for (CartItem item : items) {
            total += item.getSubtotal();
        }
        return total;
    }
    
    /**
     * Đếm tổng số lượng sản phẩm
     */
    public int getTotalQuantity() {
        int total = 0;
        for (CartItem item : items) {
            total += item.getQuantity();
        }
        return total;
    }
    
    /**
     * Lấy danh sách items
     */
    public List<CartItem> getItems() {
        return items;
    }
    
    /**
     * Kiểm tra giỏ hàng rỗng
     */
    public boolean isEmpty() {
        return items.isEmpty();
    }
}
```

**Giải thích:**
- `List<CartItem>`: Danh sách các mục trong giỏ
- Logic "Thêm sản phẩm":
  - Nếu sản phẩm đã có: Tăng số lượng (không tạo mục mới)
  - Nếu sản phẩm chưa có: Thêm mục mới
- `removeIf(...)`: Xóa phần tử thỏa điều kiện (Java 8 Lambda)

### **Bước 3: Tạo Servlet `CartServlet.java`**

```java
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Cart;
import model.Product;

/**
 * Xử lý Giỏ hàng
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
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
            case "remove":
                removeFromCart(request, response);
                break;
            case "clear":
                clearCart(request, response);
                break;
            default:
                viewCart(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addToCart(request, response);
        } else if ("update".equals(action)) {
            updateCart(request, response);
        }
    }
    
    /**
     * Thêm sản phẩm vào giỏ
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy thông tin sản phẩm từ form
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity <= 0) {
                quantity = 1;
            }
            
            // Tìm sản phẩm (Giả sử đã có ProductServlet.findProductById())
            // Ở đây tạm thời tạo sản phẩm giả
            Product product = new Product(productId, "Sản phẩm " + productId, "Mô tả", 25000, "images/product.jpg");
            
            // Lấy giỏ hàng từ Session (hoặc tạo mới nếu chưa có)
            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            
            if (cart == null) {
                cart = new Cart();
            }
            
            // Thêm sản phẩm vào giỏ
            cart.addProduct(product, quantity);
            
            // Lưu lại giỏ hàng vào Session
            session.setAttribute("cart", cart);
            
            // Quay lại trang trước đó
            String referer = request.getHeader("Referer");
            if (referer != null) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect("products?action=list");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("products?action=list");
        }
    }
    
    /**
     * Xem giỏ hàng
     */
    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy giỏ hàng từ Session
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new Cart();
        }
        
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
    
    /**
     * Cập nhật số lượng
     */
    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart != null) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                cart.updateQuantity(productId, quantity);
                session.setAttribute("cart", cart);
                
            } catch (NumberFormatException e) {
                // Bỏ qua lỗi
            }
        }
        
        response.sendRedirect("cart?action=view");
    }
    
    /**
     * Xóa sản phẩm khỏi giỏ
     */
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart != null) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                cart.removeProduct(productId);
                session.setAttribute("cart", cart);
            } catch (NumberFormatException e) {
                // Bỏ qua lỗi
            }
        }
        
        response.sendRedirect("cart?action=view");
    }
    
    /**
     * Xóa toàn bộ giỏ hàng
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart != null) {
            cart.clear();
            session.setAttribute("cart", cart);
        }
        
        response.sendRedirect("cart?action=view");
    }
}
```

**Giải thích:**

1. **Lấy giỏ hàng từ Session:**
```java
Cart cart = (Cart) session.getAttribute("cart");
if (cart == null) {
    cart = new Cart();  // Tạo mới nếu chưa có
}
```

2. **Lưu giỏ hàng vào Session:**
```java
session.setAttribute("cart", cart);
```
- Giỏ hàng được lưu trong Session
- Mỗi user có giỏ hàng riêng
- Giỏ hàng tồn tại cho đến khi Session hết hạn hoặc user đăng xuất

3. **Quay lại trang trước:**
```java
String referer = request.getHeader("Referer");
response.sendRedirect(referer);
```
- `Referer`: HTTP header chứa URL trang trước đó
- Giúp user quay lại trang đang xem sau khi thêm vào giỏ

### **Bước 4: Tạo View `cart.jsp`**

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        h1 {
            text-align: center;
            color: #333;
        }
        
        .cart-table {
            width: 100%;
            background-color: white;
            border-collapse: collapse;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .cart-table th {
            background-color: #333;
            color: white;
            padding: 15px;
            text-align: left;
        }
        
        .cart-table td {
            padding: 15px;
            border-bottom: 1px solid #ddd;
        }
        
        .cart-table tr:hover {
            background-color: #f9f9f9;
        }
        
        .product-img {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .quantity-input {
            width: 60px;
            padding: 5px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 3px;
        }
        
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-update {
            background-color: #28a745;
            color: white;
        }
        
        .btn-remove {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-clear {
            background-color: #ffc107;
            color: #333;
        }
        
        .btn-continue {
            background-color: #007bff;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
        
        .cart-footer {
            margin-top: 20px;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .total-price {
            font-size: 24px;
            color: #ff6600;
            font-weight: bold;
        }
        
        .empty-cart {
            text-align: center;
            padding: 50px;
            background-color: white;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <h1>🛒 Giỏ Hàng Của Bạn</h1>
    
    <c:choose>
        <c:when test="${cart.isEmpty()}">
            <!-- GIỎ HÀNG RỖNG -->
            <div class="empty-cart">
                <h2>Giỏ hàng trống</h2>
                <p>Bạn chưa có sản phẩm nào trong giỏ hàng.</p>
                <a href="products?action=list" class="btn btn-continue">🛍️ Tiếp tục mua sắm</a>
            </div>
        </c:when>
        
        <c:otherwise>
            <!-- BẢNG GIỎ HÀNG -->
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Tổng</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${cart.items}" var="item">
                        <tr>
                            <td>
                                <img src="${item.product.imagePath}" alt="${item.product.name}" class="product-img" />
                            </td>
                            <td><strong>${item.product.name}</strong></td>
                            <td><fmt:formatNumber value="${item.product.price}" pattern="#,###" /> đ</td>
                            <td>
                                <form action="cart" method="POST" style="display: inline;">
                                    <input type="hidden" name="action" value="update" />
                                    <input type="hidden" name="productId" value="${item.product.id}" />
                                    <input type="number" name="quantity" value="${item.quantity}" 
                                           min="1" class="quantity-input" />
                                    <button type="submit" class="btn btn-update">Cập nhật</button>
                                </form>
                            </td>
                            <td><strong><fmt:formatNumber value="${item.subtotal}" pattern="#,###" /> đ</strong></td>
                            <td>
                                <a href="cart?action=remove&productId=${item.product.id}" 
                                   class="btn btn-remove" 
                                   onclick="return confirm('Bạn muốn xóa sản phẩm này?');">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <!-- TỔNG TIỀN -->
            <div class="cart-footer">
                <div>
                    <a href="cart?action=clear" class="btn btn-clear" 
                       onclick="return confirm('Bạn muốn xóa toàn bộ giỏ hàng?');">🗑️ Xóa giỏ hàng</a>
                    <a href="products?action=list" class="btn btn-continue">⬅️ Tiếp tục mua sắm</a>
                </div>
                <div>
                    <span>Tổng cộng: </span>
                    <span class="total-price">
                        <fmt:formatNumber value="${cart.totalPrice}" pattern="#,###" /> đ
                    </span>
                    <a href="checkout" class="btn" style="background-color: #28a745; color: white; margin-left: 15px;">
                        💳 Thanh toán
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</body>
</html>
```

**Giải thích:**

1. **JSTL `<fmt:formatNumber>`:**
```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:formatNumber value="${cart.totalPrice}" pattern="#,###" />
```
- Định dạng số (thêm dấu phẩy ngăn cách hàng nghìn)
- Ví dụ: `25000` -> `25,000`

2. **Form update số lượng:**
```jsp
<form action="cart" method="POST">
    <input type="hidden" name="action" value="update" />
    <input type="hidden" name="productId" value="${item.product.id}" />
    <input type="number" name="quantity" value="${item.quantity}" />
    <button type="submit">Cập nhật</button>
</form>
```
- Mỗi sản phẩm có 1 form riêng
- Gửi `action=update`, `productId`, `quantity`

---

## ✅ BÀI TẬP THỰC HÀNH 3

**Yêu cầu:**
1. Thêm chức năng "Đăng ký" (Register):
   - Form nhập: username, password, fullName, email
   - Validate: username chưa tồn tại, password >= 8 ký tự
   - Lưu user mới vào UserDAO (HashMap)
2. Thêm role-based access control:
   - Admin: Truy cập được trang quản lý sản phẩm
   - User: Chỉ xem được danh sách, không được thêm/sửa/xóa
3. Hiển thị số lượng sản phẩm trong giỏ hàng ở Header (Badge):
   - Ví dụ: 🛒 (3)
4. Thêm chức năng "Yêu thích" (Wishlist):
   - Lưu danh sách sản phẩm yêu thích vào Session
   - Hiển thị trang Wishlist riêng
5. (Nâng cao) Thêm chức năng "Lịch sử xem sản phẩm":
   - Lưu danh sách ID sản phẩm đã xem vào Cookie
   - Hiển thị danh sách "Sản phẩm đã xem" ở trang chủ

**Gợi ý:**
- Kiểm tra role:
  ```java
  User user = (User) session.getAttribute("user");
  if (!"admin".equals(user.getRole())) {
      response.sendRedirect("accessDenied.jsp");
      return;
  }
  ```
- Lưu danh sách ID vào Cookie:
  ```java
  Cookie cookie = new Cookie("viewedProducts", "1,5,8,12");
  cookie.setMaxAge(7 * 24 * 60 * 60);
  response.addCookie(cookie);
  ```

---

**TIẾP THEO: Bài 4 - Kết nối Database & DAO Pattern** 🚀