# 🎓 GIÁO TRÌNH HOÀN CHỈNH: XÂY DỰNG WEBSITE BÁN ĐỒ ĂN VẶT
## 📚 Kết hợp Lý thuyết + Thực hành + Giải thích Code Chi tiết

---

## 📋 MỤC LỤC

### **PHẦN I: NỀN TẢNG LÝ THUYẾT** (Bài 1-3)
1. [HTML, CSS, JavaScript Căn Bản](#bai-1-html-css-js)
2. [JSP & Servlet Căn Bản](#bai-2-jsp-servlet)
3. [Session & Cookie](#bai-3-session-cookie)
4. [Kết Nối Database & DAO Pattern](#bai-4-database)

### **PHẦN II: ỨNG DỤNG CHO WEBSITE ĐỒ ĂN VẶT** (Bài 5-7)
5. [Quản Lý Sản Phẩm (Member 1)](#member-1-product)
6. [Giỏ Hàng (Member 2)](#member-2-cart)
7. [Quản Lý Đơn Hàng (Member 3)](#member-3-order)
8. [Danh Mục & Tìm Kiếm (Member 4)](#member-4-category-search)

### **PHẦN III: HOÀN THIỆN & TRIỂN KHAI** (Bài 8-10)
9. [Tìm Kiếm & Phân Trang](#bai-9-search-pagination)
10. [Tối Ưu Giao Diện](#bai-10-ui-optimization)
11. [Export & Deploy](#bai-11-deploy)

---

# PHẦN I: NỀN TẢNG LÝ THUYẾT

---

<a name="bai-1-html-css-js"></a>
## 📘 BÀI 1: HTML, CSS, JAVASCRIPT CĂN BẢN

### 🎯 Mục Đích Học
- Hiểu cấu trúc HTML và cách tổ chức layout
- Biết cách sử dụng CSS để định dạng (Layout Grid, Flexbox, Responsive)
- Thực hành JavaScript xử lý sự kiện và Validation

### 📖 1.1. LÝ THUYẾT HTML

#### **HTML là gì?**
- **Định nghĩa**: HyperText Markup Language - Ngôn ngữ đánh dấu siêu văn bản
- **Mục đích**: Tạo cấu trúc cho trang web (không phải ngôn ngữ lập trình)
- **Cú pháp**: Dùng các thẻ (tag) để đánh dấu nội dung

#### **Cấu trúc cơ bản của HTML**
```html
<!DOCTYPE html>          <!-- Khai báo phiên bản HTML5 -->
<html>                   <!-- Thẻ gốc của tài liệu HTML -->
<head>                   <!-- Phần đầu: chứa thông tin metadata -->
    <title>Tên trang</title>  <!-- Tiêu đề hiển thị trên tab trình duyệt -->
    <meta charset="UTF-8">    <!-- Khai báo bảng mã ký tự Unicode -->
    <!-- Nơi nhúng CSS, JavaScript, thư viện... -->
</head>
<body>                   <!-- Phần thân: chứa nội dung hiển thị -->
    <!-- Nội dung trang web của bạn -->
</body>
</html>
```

**Giải thích chi tiết:**
- `<!DOCTYPE html>`: Bắt buộc phải có ở đầu file, báo cho trình duyệt biết đây là HTML5
- `<html>`: Thẻ gốc, tất cả nội dung phải nằm trong cặp thẻ này
- `<head>`: Chứa metadata (dữ liệu về dữ liệu), không hiển thị trực tiếp
- `<body>`: Chứa nội dung hiển thị cho người dùng

#### **Các thẻ HTML quan trọng**

```html
<!-- 1. THẺ TIÊU ĐỀ (Heading) -->
<h1>Tiêu đề cấp 1</h1>   <!-- Quan trọng nhất, thường dùng 1 lần/trang -->
<h2>Tiêu đề cấp 2</h2>
<h3>Tiêu đề cấp 3</h3>   <!-- Từ h1 -> h6, độ quan trọng giảm dần -->

<!-- 2. THẺ ĐOẠN VĂN -->
<p>Đây là một đoạn văn bản.</p>

<!-- 3. THẺ LIÊN KẾT -->
<a href="https://google.com">Nhấn vào đây</a>
<!-- href = hyperlink reference: đường dẫn đến trang khác -->

<!-- 4. THẺ HÌNH ẢNH -->
<img src="images/product.jpg" alt="Sản phẩm đồ ăn vặt" />
<!-- src = source: đường dẫn file ảnh -->
<!-- alt = alternative text: văn bản thay thế khi ảnh không tải được -->

<!-- 5. THẺ DIV (Division - khối phân chia) -->
<div id="header">           <!-- id: định danh duy nhất -->
    <h1>Tiêu đề website</h1>
</div>

<div class="product-item">  <!-- class: nhóm các phần tử giống nhau -->
    <img src="snack1.jpg" />
    <p>Bánh snack ngon</p>
</div>

<!-- 6. THẺ FORM (Biểu mẫu) -->
<form action="/submitLogin" method="POST">
    <!-- action: URL xử lý dữ liệu khi submit -->
    <!-- method: GET (dữ liệu trên URL) hoặc POST (dữ liệu ẩn) -->
    
    <input type="text" name="username" placeholder="Nhập tên" />
    <input type="password" name="password" />
    <button type="submit">Đăng nhập</button>
</form>
```

**Tại sao cần thuộc tính `id` và `class`?**
- `id`: Định danh DUY NHẤT cho 1 phần tử (không được trùng trong cả trang)
  - Dùng để: JavaScript lấy phần tử (`getElementById`), CSS định dạng riêng
- `class`: Nhóm nhiều phần tử giống nhau
  - Dùng để: CSS định dạng chung cho nhiều phần tử

---

### 📖 1.2. LÝ THUYẾT CSS

#### **CSS là gì?**
- **Định nghĩa**: Cascading Style Sheets - Bảng định dạng tầng
- **Mục đích**: Làm đẹp giao diện HTML (màu sắc, kích thước, vị trí...)
- **Ý nghĩa "Cascading"**: Quy tắc CSS được áp dụng theo thứ tự ưu tiên (cha -> con, trước -> sau)

#### **3 Cách nhúng CSS vào HTML**

```html
<!-- CÁCH 1: Inline CSS (Trực tiếp trong thẻ) -->
<p style="color: red; font-size: 20px;">Chữ màu đỏ</p>
<!-- Ưu điểm: Nhanh, trực tiếp -->
<!-- Nhược điểm: Khó bảo trì, không tái sử dụng -->

<!-- CÁCH 2: Internal CSS (Trong thẻ <style>) -->
<head>
    <style>
        p {
            color: blue;
            font-size: 18px;
        }
    </style>
</head>
<!-- Ưu điểm: Áp dụng cho cả trang -->
<!-- Nhược điểm: Không dùng cho nhiều trang -->

<!-- CÁCH 3: External CSS (File riêng .css) -->
<head>
    <link rel="stylesheet" href="styles/main.css" />
</head>
<!-- Ưu điểm: Tái sử dụng cho nhiều trang, dễ bảo trì -->
<!-- Nhược điểm: Cần file riêng -->
```

**✅ Khuyến nghị: Dùng External CSS cho dự án thực tế**

#### **CSS Selectors (Bộ chọn)**

```css
/* 1. CHỌN THEO TÊN THẺ */
p {
    color: black;  /* Áp dụng cho TẤT CẢ thẻ <p> */
}

/* 2. CHỌN THEO CLASS */
.product-item {
    border: 1px solid #ccc;  /* Áp dụng cho mọi thẻ có class="product-item" */
}

/* 3. CHỌN THEO ID */
#header {
    background-color: #333;  /* Chỉ áp dụng cho 1 phần tử có id="header" */
}

/* 4. CHỌN CON (Descendant Selector) */
#content .product-item {
    margin: 10px;  /* Chỉ áp dụng cho .product-item BÊN TRONG #content */
}
```

**Thứ tự ưu tiên CSS (Specificity):**
```
Inline Style > ID > Class > Tag
```
Ví dụ:
```html
<style>
    p { color: black; }           /* Ưu tiên: 1 */
    .highlight { color: blue; }   /* Ưu tiên: 10 */
    #main { color: red; }         /* Ưu tiên: 100 */
</style>

<p style="color: green;">Chữ màu XANH LÁ</p>  <!-- Ưu tiên: 1000 -->
```

#### **CSS Flexbox (Căn chỉnh linh hoạt)**

```css
/* Container cha */
.flex-container {
    display: flex;              /* Kích hoạt Flexbox */
    justify-content: center;    /* Căn giữa theo chiều ngang */
    align-items: center;        /* Căn giữa theo chiều dọc */
    flex-wrap: wrap;            /* Xuống dòng khi hết chỗ */
}

/* Phần tử con */
.flex-item {
    flex: 1;                    /* Chia đều không gian */
    margin: 10px;
}
```

**Giải thích chi tiết:**
- `display: flex`: Biến phần tử thành Flex Container
- `justify-content`: Căn chỉnh theo trục chính (mặc định: ngang)
  - `center`: Căn giữa
  - `space-between`: Cách đều hai đầu
  - `space-around`: Cách đều xung quanh
- `align-items`: Căn chỉnh theo trục phụ (mặc định: dọc)
  - `center`: Căn giữa
  - `flex-start`: Căn trên
  - `flex-end`: Căn dưới

#### **CSS Grid (Bố cục lưới)**

```css
.grid-container {
    display: grid;              /* Kích hoạt Grid */
    grid-template-columns: repeat(3, 1fr);  /* 3 cột bằng nhau */
    grid-gap: 20px;             /* Khoảng cách giữa các ô */
}
```

**Giải thích:**
- `repeat(3, 1fr)`: Tạo 3 cột, mỗi cột chiếm 1 phần (`1fr = 1 fraction`)
- `grid-gap`: Khoảng cách giữa các ô lưới

#### **Responsive Design (Thiết kế đáp ứng)**

```css
/* Trên Desktop (mặc định) */
.grid-container {
    grid-template-columns: repeat(3, 1fr);  /* 3 cột */
}

/* Trên Tablet (màn hình <= 768px) */
@media screen and (max-width: 768px) {
    .grid-container {
        grid-template-columns: repeat(2, 1fr);  /* 2 cột */
    }
}

/* Trên Mobile (màn hình <= 480px) */
@media screen and (max-width: 480px) {
    .grid-container {
        grid-template-columns: 1fr;  /* 1 cột */
    }
}
```

**Tại sao cần Responsive?**
- Người dùng truy cập web từ nhiều thiết bị (Desktop, Tablet, Mobile)
- Giao diện phải tự động điều chỉnh để hiển thị tốt trên mọi màn hình

---

### 📖 1.3. LÝ THUYẾT JAVASCRIPT

#### **JavaScript là gì?**
- **Định nghĩa**: Ngôn ngữ lập trình kịch bản (Script Language) chạy trên trình duyệt
- **Mục đích**: Tạo tương tác động cho trang web (xử lý sự kiện, validation...)
- **Đặc điểm**: Chạy phía Client (trình duyệt), không cần Server

#### **Các cách nhúng JavaScript**

```html
<!-- CÁCH 1: Inline JavaScript -->
<button onclick="alert('Hello!')">Nhấn vào đây</button>

<!-- CÁCH 2: Internal JavaScript -->
<script>
    function showMessage() {
        alert('Xin chào!');
    }
</script>

<!-- CÁCH 3: External JavaScript -->
<script src="scripts/main.js"></script>
```

#### **Xử lý sự kiện (Event Handling)**

```html
<button id="myBtn">Nhấn vào đây</button>

<script>
    // CÁCH 1: Gán sự kiện trực tiếp
    document.getElementById('myBtn').onclick = function() {
        alert('Đã nhấn nút!');
    };

    // CÁCH 2: Dùng addEventListener (Khuyến nghị)
    document.getElementById('myBtn').addEventListener('click', function() {
        console.log('Button clicked!');
    });
</script>
```

**Tại sao dùng `addEventListener`?**
- Có thể gán NHIỀU hàm xử lý cho 1 sự kiện
- Dễ dàng gỡ bỏ sự kiện (`removeEventListener`)

#### **DOM Manipulation (Thao tác với DOM)**

```javascript
// 1. LẤY PHẦN TỬ
var element = document.getElementById('myId');        // Lấy theo ID
var elements = document.getElementsByClassName('myClass'); // Lấy theo Class
var element = document.querySelector('#myId');        // Lấy 1 phần tử
var elements = document.querySelectorAll('.myClass'); // Lấy nhiều phần tử

// 2. THAY ĐỔI NỘI DUNG
element.innerHTML = '<b>Nội dung mới</b>';  // Thay HTML
element.textContent = 'Chỉ văn bản';        // Thay text thuần

// 3. THAY ĐỔI THUỘC TÍNH
element.style.color = 'red';                // Đổi màu chữ
element.setAttribute('src', 'new.jpg');     // Đổi thuộc tính

// 4. THÊM/XÓA CLASS
element.classList.add('active');            // Thêm class
element.classList.remove('hidden');         // Xóa class
element.classList.toggle('show');           // Bật/tắt class
```

#### **Form Validation (Kiểm tra dữ liệu)**

```html
<form id="loginForm">
    <input type="text" id="username" name="username" placeholder="Tên đăng nhập" />
    <input type="password" id="password" name="password" placeholder="Mật khẩu" />
    <button type="submit">Đăng nhập</button>
</form>

<script>
    document.getElementById('loginForm').addEventListener('submit', function(event) {
        // Ngăn form submit mặc định (không reload trang)
        event.preventDefault();
        
        // Lấy giá trị input
        var username = document.getElementById('username').value;
        var password = document.getElementById('password').value;
        
        // Kiểm tra rỗng
        if (username === '' || password === '') {
            alert('Vui lòng nhập đầy đủ thông tin!');
            return false;
        }
        
        // Kiểm tra độ dài username (1-10 ký tự)
        if (username.length > 10) {
            alert('Tên đăng nhập không quá 10 ký tự!');
            return false;
        }
        
        // Kiểm tra username chỉ chứa chữ và số (Regex)
        var usernamePattern = /^[A-Za-z0-9]+$/;
        if (!usernamePattern.test(username)) {
            alert('Tên đăng nhập chỉ chứa chữ và số!');
            return false;
        }
        
        // Kiểm tra password (8-16 ký tự)
        if (password.length < 8 || password.length > 16) {
            alert('Mật khẩu phải từ 8-16 ký tự!');
            return false;
        }
        
        // Nếu hợp lệ, submit form
        alert('Đăng nhập thành công!');
        this.submit();  // Submit form
    });
</script>
```

**Giải thích chi tiết:**
- `event.preventDefault()`: Ngăn hành vi mặc định (submit form -> reload trang)
- `.value`: Lấy giá trị trong input
- Regex `/^[A-Za-z0-9]+$/`: 
  - `^`: Bắt đầu chuỗi
  - `[A-Za-z0-9]`: Chỉ chấp nhận chữ in hoa, in thường, số
  - `+`: Ít nhất 1 ký tự
  - `$`: Kết thúc chuỗi

---

### 💻 1.4. THỰC HÀNH: TRANG DANH SÁCH SẢN PHẨM ĐỒ ĂN VẶT

#### **Mục tiêu:**
- Xây dựng trang HTML hiển thị danh sách sản phẩm dạng lưới (Grid)
- Có chức năng đăng nhập dạng Modal (Pop-up)
- Validate form đăng nhập bằng JavaScript

#### **Bước 1: Tạo cấu trúc thư mục**

```
SnackWebsite/
│
├── index.html
├── css/
│   └── style.css
├── js/
│   └── main.js
└── images/
    ├── snack1.jpg
    ├── snack2.jpg
    └── snack3.jpg
```

#### **Bước 2: Tạo file `index.html`**

```html
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- meta viewport: Quan trọng cho Responsive, scale=1.0 nghĩa là không zoom -->
    <title>Website Đồ Ăn Vặt</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- HEADER (Phần đầu trang) -->
    <div id="header">
        <h1>🍿 Website Bán Đồ Ăn Vặt</h1>
        <a href="#" id="loginLink">Đăng nhập</a>
        <!-- # trong href nghĩa là link tới chính trang này (không reload) -->
    </div>

    <!-- CONTENT (Nội dung chính) -->
    <div id="content">
        <h2>Danh sách sản phẩm</h2>
        
        <!-- GRID CONTAINER (Lưới 3 cột) -->
        <div class="product-grid">
            <!-- SẢN PHẨM 1 -->
            <div class="product-item">
                <img src="images/snack1.jpg" alt="Snack 1">
                <h3>Bánh snack BBQ</h3>
                <p class="price">25.000 đ</p>
                <button class="btn-add-cart">Thêm vào giỏ</button>
            </div>

            <!-- SẢN PHẨM 2 -->
            <div class="product-item">
                <img src="images/snack2.jpg" alt="Snack 2">
                <h3>Kẹo dẻo trái cây</h3>
                <p class="price">18.000 đ</p>
                <button class="btn-add-cart">Thêm vào giỏ</button>
            </div>

            <!-- SẢN PHẨM 3 -->
            <div class="product-item">
                <img src="images/snack3.jpg" alt="Snack 3">
                <h3>Socola hạnh nhân</h3>
                <p class="price">35.000 đ</p>
                <button class="btn-add-cart">Thêm vào giỏ</button>
            </div>
        </div>
    </div>

    <!-- MODAL LOGIN (Ẩn mặc định) -->
    <div id="loginModal" class="modal">
        <!-- Lớp phủ mờ (Overlay) -->
        <div class="modal-overlay" id="modalOverlay"></div>
        
        <!-- Nội dung Modal -->
        <div class="modal-content">
            <span class="close-btn" id="closeBtn">&times;</span>
            <h2>Đăng nhập</h2>
            
            <form id="loginForm">
                <input type="text" id="username" name="username" 
                       placeholder="Tên đăng nhập" required />
                
                <input type="password" id="password" name="password" 
                       placeholder="Mật khẩu" required />
                
                <button type="submit">Đăng nhập</button>
            </form>
        </div>
    </div>

    <!-- Nhúng JavaScript -->
    <script src="js/main.js"></script>
</body>
</html>
```

**Giải thích cấu trúc:**
1. `<head>`: Chứa metadata, CSS
2. `<div id="header">`: Phần đầu trang (Logo, Menu)
3. `<div id="content">`: Nội dung chính (Danh sách sản phẩm)
4. `<div id="loginModal">`: Modal đăng nhập (ẩn mặc định)
5. `<script>`: Nhúng JavaScript cuối `<body>` để đảm bảo HTML load xong trước

#### **Bước 3: Tạo file `css/style.css`**

```css
/* ===== RESET CSS ===== */
* {
    margin: 0;       /* Xóa margin mặc định */
    padding: 0;      /* Xóa padding mặc định */
    box-sizing: border-box;  /* Tính kích thước bao gồm border & padding */
}

body {
    font-family: Arial, sans-serif;
    background-color: #f5f5f5;
}

/* ===== HEADER ===== */
#header {
    background-color: #333;
    color: white;
    padding: 20px;
    display: flex;                /* Dùng Flexbox */
    justify-content: space-between;  /* Logo bên trái, Login bên phải */
    align-items: center;          /* Căn giữa theo chiều dọc */
}

#header h1 {
    font-size: 24px;
    margin: 0;
}

#header a {
    color: white;
    text-decoration: none;  /* Bỏ gạch chân */
    padding: 10px 20px;
    background-color: #ff6600;
    border-radius: 5px;     /* Bo góc */
}

#header a:hover {
    background-color: #ff3300;  /* Màu khi di chuột qua */
}

/* ===== CONTENT ===== */
#content {
    max-width: 1200px;      /* Giới hạn độ rộng */
    margin: 40px auto;      /* Căn giữa trang (auto: tự động căn 2 bên) */
    padding: 0 20px;
}

#content h2 {
    text-align: center;
    margin-bottom: 30px;
    color: #333;
}

/* ===== PRODUCT GRID ===== */
.product-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);  /* 3 cột bằng nhau */
    grid-gap: 30px;                        /* Khoảng cách giữa các sản phẩm */
}

.product-item {
    background-color: white;
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 20px;
    text-align: center;
    transition: transform 0.3s, box-shadow 0.3s;  /* Hiệu ứng chuyển đổi */
}

.product-item:hover {
    transform: translateY(-5px);  /* Nổi lên khi hover */
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);  /* Đổ bóng */
}

.product-item img {
    width: 100%;
    height: 200px;
    object-fit: cover;  /* Cắt ảnh vừa khung, không méo */
    border-radius: 8px;
}

.product-item h3 {
    margin: 15px 0 10px;
    color: #333;
}

.product-item .price {
    font-size: 20px;
    color: #ff6600;
    font-weight: bold;
    margin-bottom: 15px;
}

.btn-add-cart {
    background-color: #28a745;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;  /* Con trỏ dạng tay khi hover */
    font-size: 16px;
}

.btn-add-cart:hover {
    background-color: #218838;
}

/* ===== MODAL ===== */
.modal {
    display: none;  /* Ẩn mặc định */
    position: fixed;  /* Cố định vị trí khi scroll */
    z-index: 1000;    /* Đè lên tất cả các phần tử khác */
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
}

.modal-overlay {
    position: absolute;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);  /* Đen trong suốt 50% */
}

.modal-content {
    position: relative;
    background-color: white;
    width: 400px;
    margin: 100px auto;  /* Căn giữa màn hình */
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
    z-index: 1001;  /* Đè lên overlay */
}

.close-btn {
    position: absolute;
    top: 10px;
    right: 20px;
    font-size: 30px;
    color: #aaa;
    cursor: pointer;
}

.close-btn:hover {
    color: #000;
}

.modal-content h2 {
    text-align: center;
    margin-bottom: 20px;
}

.modal-content input {
    width: 100%;
    padding: 12px;
    margin-bottom: 15px;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 16px;
}

.modal-content button {
    width: 100%;
    padding: 12px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    font-size: 18px;
    cursor: pointer;
}

.modal-content button:hover {
    background-color: #0056b3;
}

/* ===== RESPONSIVE (Thiết bị nhỏ hơn) ===== */

/* Tablet (768px trở xuống) */
@media screen and (max-width: 768px) {
    .product-grid {
        grid-template-columns: repeat(2, 1fr);  /* 2 cột */
    }
    
    .modal-content {
        width: 90%;  /* Chiếm 90% màn hình */
    }
}

/* Mobile (480px trở xuống) */
@media screen and (max-width: 480px) {
    .product-grid {
        grid-template-columns: 1fr;  /* 1 cột */
    }
    
    #header {
        flex-direction: column;  /* Xếp dọc */
        text-align: center;
    }
    
    #header a {
        margin-top: 10px;
    }
}
```

**Giải thích CSS quan trọng:**
- `box-sizing: border-box`: Tính kích thước bao gồm cả border & padding (dễ tính toán)
- `position: fixed`: Modal cố định trên màn hình khi scroll
- `z-index`: Xác định thứ tự chồng lớp (số càng cao càng đè lên trên)
- `rgba(0,0,0,0.5)`: Màu đen trong suốt 50%
- `transform: translateY(-5px)`: Di chuyển lên 5px (hiệu ứng hover)
- `@media`: Điều chỉnh CSS theo kích thước màn hình

#### **Bước 4: Tạo file `js/main.js`**

```javascript
// ===== XỬ LÝ MODAL LOGIN =====

// Lấy các phần tử
var loginModal = document.getElementById('loginModal');
var loginLink = document.getElementById('loginLink');
var closeBtn = document.getElementById('closeBtn');
var modalOverlay = document.getElementById('modalOverlay');

// Hàm mở Modal
function openModal() {
    loginModal.style.display = 'block';  // Hiển thị Modal
}

// Hàm đóng Modal
function closeModal() {
    loginModal.style.display = 'none';  // Ẩn Modal
}

// Sự kiện: Click vào "Đăng nhập" -> Mở Modal
loginLink.addEventListener('click', function(e) {
    e.preventDefault();  // Ngăn link reload trang
    openModal();
});

// Sự kiện: Click vào nút X -> Đóng Modal
closeBtn.addEventListener('click', closeModal);

// Sự kiện: Click vào Overlay (vùng tối) -> Đóng Modal
modalOverlay.addEventListener('click', closeModal);


// ===== XỬ LÝ FORM VALIDATION =====

var loginForm = document.getElementById('loginForm');

loginForm.addEventListener('submit', function(e) {
    e.preventDefault();  // Ngăn submit mặc định
    
    // Lấy giá trị input
    var username = document.getElementById('username').value.trim();
    var password = document.getElementById('password').value;
    
    // Kiểm tra rỗng
    if (username === '' || password === '') {
        alert('❌ Vui lòng nhập đầy đủ thông tin!');
        return;
    }
    
    // Kiểm tra username (Chỉ chữ và số, tối đa 10 ký tự)
    var usernamePattern = /^[A-Za-z0-9]{1,10}$/;
    if (!usernamePattern.test(username)) {
        alert('❌ Tên đăng nhập chỉ chứa chữ và số, không quá 10 ký tự!');
        return;
    }
    
    // Kiểm tra password (8-16 ký tự)
    if (password.length < 8 || password.length > 16) {
        alert('❌ Mật khẩu phải từ 8-16 ký tự!');
        return;
    }
    
    // Nếu hợp lệ
    alert('✅ Đăng nhập thành công!\n👤 Tên: ' + username);
    closeModal();  // Đóng Modal
    
    // Reset form
    loginForm.reset();
});


// ===== XỬ LÝ THÊM VÀO GIỎ HÀNG =====

// Lấy tất cả nút "Thêm vào giỏ"
var addCartButtons = document.querySelectorAll('.btn-add-cart');

// Gán sự kiện cho mỗi nút
addCartButtons.forEach(function(button) {
    button.addEventListener('click', function() {
        // Lấy tên sản phẩm (thẻ h3 cùng cấp)
        var productName = this.parentElement.querySelector('h3').textContent;
        
        alert('✅ Đã thêm "' + productName + '" vào giỏ hàng!');
    });
});
```

**Giải thích JavaScript chi tiết:**

1. **Lấy phần tử:**
```javascript
var loginModal = document.getElementById('loginModal');
```
- `document`: Đại diện cho toàn bộ trang HTML
- `getElementById('loginModal')`: Tìm phần tử có `id="loginModal"`
- Trả về: Đối tượng Element (có thể thao tác thuộc tính, style...)

2. **Event Listener:**
```javascript
loginLink.addEventListener('click', function(e) {
    e.preventDefault();
    openModal();
});
```
- `addEventListener('click', ...)`: Gán hàm xử lý khi click
- `e.preventDefault()`: Ngăn hành vi mặc định (link không reload trang)
- `openModal()`: Gọi hàm tự định nghĩa

3. **Regex Pattern:**
```javascript
var usernamePattern = /^[A-Za-z0-9]{1,10}$/;
if (!usernamePattern.test(username)) { ... }
```
- `/^[A-Za-z0-9]{1,10}$/`: Chỉ chấp nhận chữ, số, từ 1-10 ký tự
- `.test(username)`: Kiểm tra chuỗi có khớp pattern không (true/false)

4. **forEach Loop:**
```javascript
addCartButtons.forEach(function(button) {
    button.addEventListener('click', function() { ... });
});
```
- `querySelectorAll('.btn-add-cart')`: Lấy TẤT CẢ phần tử có class này
- `forEach`: Lặp qua từng phần tử và gán sự kiện

---

### ✅ BÀI TẬP THỰC HÀNH 1

**Yêu cầu:**
1. Thêm 6 sản phẩm đồ ăn vặt vào danh sách (tổng 9 sản phẩm)
2. Thêm chức năng "Đăng ký" bên cạnh "Đăng nhập"
3. Validate form Đăng ký:
   - Email hợp lệ (có @ và dấu chấm)
   - Số điện thoại (10 số)
   - Xác nhận mật khẩu (2 mật khẩu phải giống nhau)
4. Làm cho Modal hiển thị ở giữa màn hình theo chiều dọc (dùng Flexbox)
5. Thêm hiệu ứng fade-in khi mở Modal (dùng CSS animation)

**Gợi ý:**
- Email pattern: `/^\S+@\S+\.\S+$/`
- Phone pattern: `/^0[0-9]{9}$/`
- So sánh 2 password: `password === confirmPassword`
- CSS animation: `@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }`

---

<a name="bai-2-jsp-servlet"></a>
## 📘 BÀI 2: JSP & SERVLET CĂN BẢN

### 🎯 Mục Đích Học
- Hiểu mô hình Client-Server và cách hoạt động của Web Application
- Biết cách viết Servlet xử lý Request/Response
- Biết cách tạo JSP để hiển thị dữ liệu động
- Hiểu Request Scope và cách truyền dữ liệu giữa Servlet và JSP

### 📖 2.1. LÝ THUYẾT MÔ HÌNH CLIENT-SERVER

#### **Cách Web hoạt động?**

```
[CLIENT (Browser)]  ------------>  [SERVER (Tomcat)]
      |                                    |
      | 1. Gửi Request (URL)              |
      |    GET /products                   |
      |                                    |
      |              2. Server xử lý       |
      |                 - Servlet nhận     |
      |                 - Lấy dữ liệu DB   |
      |                 - Tạo Response     |
      |                                    |
      | 3. Nhận Response (HTML)           |
      |    <html>...</html>                |
      <--------------------------------------
```

**Giải thích:**
1. **Client (Trình duyệt)**: Gửi yêu cầu (Request) lên Server
2. **Server (Tomcat)**: Nhận Request, xử lý, trả về Response
3. **Response**: Thường là HTML, JSON, hoặc file

#### **HTTP Request có gì?**

```
GET /products?category=snack HTTP/1.1
Host: localhost:8080
User-Agent: Mozilla/5.0
```

- **Method**: GET (lấy dữ liệu), POST (gửi dữ liệu), PUT, DELETE...
- **URL**: `/products` (đường dẫn)
- **Query String**: `?category=snack` (tham số trên URL)
- **Headers**: Thông tin bổ sung (Host, User-Agent...)
- **Body** (chỉ có khi POST): Dữ liệu gửi lên (form data, JSON...)

#### **HTTP Response có gì?**

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8

<html>
    <body>Danh sách sản phẩm</body>
</html>
```

- **Status Code**: 200 (OK), 404 (Not Found), 500 (Server Error)...
- **Headers**: Content-Type, Set-Cookie...
- **Body**: Nội dung HTML, JSON...

---

### 📖 2.2. LÝ THUYẾT SERVLET

#### **Servlet là gì?**
- **Định nghĩa**: Java class chạy trên Server, xử lý Request và tạo Response
- **Mục đích**: Controller trong mô hình MVC (xử lý logic nghiệp vụ)
- **Vị trí**: Package `controller` trong project

#### **Cấu trúc Servlet cơ bản**

```java
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;           // Lớp cha của mọi Servlet
import javax.servlet.http.HttpServletRequest;    // Đại diện Request
import javax.servlet.http.HttpServletResponse;   // Đại diện Response

// Servlet PHẢI kế thừa HttpServlet
public class ProductServlet extends HttpServlet {
    
    // Xử lý GET Request (lấy dữ liệu)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Code xử lý GET
        response.getWriter().println("Xin chào từ Servlet!");
    }
    
    // Xử lý POST Request (gửi dữ liệu)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Code xử lý POST
    }
}
```

**Giải thích:**
- `HttpServlet`: Lớp cha cung cấp phương thức xử lý HTTP
- `doGet()`: Tự động được gọi khi có GET Request
- `doPost()`: Tự động được gọi khi có POST Request
- `request`: Chứa thông tin Request (param, header...)
- `response`: Dùng để gửi Response về Client

#### **Khi nào dùng GET vs POST?**

| **GET** | **POST** |
|---------|----------|
| Lấy dữ liệu (xem danh sách, chi tiết) | Gửi dữ liệu (đăng nhập, thêm sản phẩm) |
| Dữ liệu trên URL (không bảo mật) | Dữ liệu trong Body (bảo mật hơn) |
| Có thể bookmark (lưu vào bookmark) | Không thể bookmark |
| Giới hạn độ dài URL (~2000 ký tự) | Không giới hạn |
| Ví dụ: `/products?id=5` | Ví dụ: Form đăng nhập |

#### **Các phương thức quan trọng của HttpServletRequest**

```java
// 1. LẤY THAM SỐ TỪ URL (?key=value)
String id = request.getParameter("id");  
// URL: /products?id=5  ->  id = "5"

// 2. LẤY NHIỀU GIÁ TRỊ CÙNG KEY
String[] categories = request.getParameterValues("category");
// URL: /products?category=snack&category=drink

// 3. GHI DỮ LIỆU VÀO REQUEST SCOPE
request.setAttribute("productList", list);
// Dùng để truyền dữ liệu từ Servlet sang JSP

// 4. CHUYỂN HƯỚNG (Forward) ĐẾN JSP
request.getRequestDispatcher("list.jsp").forward(request, response);
// Forward: Chuyển Request tới JSP, URL không đổi
```

**So sánh Forward vs Redirect:**

```java
// FORWARD (Chuyển tiếp Request)
request.getRequestDispatcher("list.jsp").forward(request, response);
// - Request cũ được giữ nguyên
// - URL không đổi
// - Dữ liệu trong request.setAttribute vẫn còn
// - Dùng khi: Hiển thị dữ liệu, xử lý lỗi

// REDIRECT (Chuyển hướng mới)
response.sendRedirect("products");
// - Tạo Request mới
// - URL thay đổi
// - Dữ liệu request.setAttribute BỊ MẤT
// - Dùng khi: Sau khi thêm/sửa/xóa, tránh submit lại form
```

#### **Cấu hình Servlet trong `web.xml`**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app>
    <!-- Khai báo Servlet -->
    <servlet>
        <servlet-name>ProductServlet</servlet-name>
        <servlet-class>controller.ProductServlet</servlet-class>
    </servlet>
    
    <!-- Ánh xạ URL tới Servlet -->
    <servlet-mapping>
        <servlet-name>ProductServlet</servlet-name>
        <url-pattern>/products</url-pattern>
    </servlet-mapping>
</web-app>
```

**Giải thích:**
- `<servlet>`: Khai báo Servlet (tên + class đầy đủ)
- `<servlet-mapping>`: Ánh xạ URL `/products` tới Servlet
- Khi truy cập `http://localhost:8080/products` -> Servlet được gọi

**✅ Lưu ý:** Từ Servlet 3.0+, có thể dùng `@WebServlet("/products")` thay cho `web.xml`

---

### 📖 2.3. LÝ THUYẾT JSP (JavaServer Pages)

#### **JSP là gì?**
- **Định nghĩa**: Trang HTML có thể nhúng code Java (View trong MVC)
- **Mục đích**: Hiển thị dữ liệu động (dữ liệu từ Servlet)
- **Vị trí**: Thư mục `WebContent` hoặc `WEB-INF`

#### **Cú pháp JSP cơ bản**

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<!-- Khai báo kiểu nội dung và encoding -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Nhúng thư viện JSTL (JavaServer Pages Standard Tag Library) -->

<!DOCTYPE html>
<html>
<head>
    <title>Danh sách sản phẩm</title>
</head>
<body>
    <h1>Sản phẩm đồ ăn vặt</h1>
    
    <!-- Duyệt danh sách bằng JSTL -->
    <c:forEach items="${productList}" var="product">
        <div>
            <h3>${product.name}</h3>
            <p>Giá: ${product.price} đ</p>
        </div>
    </c:forEach>
</body>
</html>
```

**Giải thích:**
- `<%@ page %>`: Chỉ thị trang (định nghĩa thuộc tính)
- `<%@ taglib %>`: Nhúng thư viện JSTL
- `${productList}`: Expression Language (EL) - Lấy dữ liệu từ Request Scope
- `<c:forEach>`: Vòng lặp JSTL (giống for-each trong Java)

#### **JSTL Core Tags (Thẻ JSTL quan trọng)**

```jsp
<!-- 1. XUẤT BIẾN (Output) -->
<c:out value="${username}" />
<!-- Xuất giá trị biến, tự động escape HTML (an toàn) -->

<!-- 2. ĐẶT BIẾN (Set Variable) -->
<c:set var="tax" value="0.1" />
<!-- Tạo biến tax = 0.1 -->

<!-- 3. ĐIỀU KIỆN IF -->
<c:if test="${user != null}">
    <p>Xin chào, ${user.name}!</p>
</c:if>

<!-- 4. ĐIỀU KIỆN IF-ELSE -->
<c:choose>
    <c:when test="${user.role == 'admin'}">
        <p>Bạn là Admin</p>
    </c:when>
    <c:otherwise>
        <p>Bạn là User thường</p>
    </c:otherwise>
</c:choose>

<!-- 5. VÒNG LẶP FOREACH -->
<c:forEach items="${productList}" var="product" varStatus="status">
    <p>${status.count}. ${product.name}</p>
</c:forEach>
<!-- varStatus.count: Thứ tự phần tử (bắt đầu từ 1) -->
<!-- varStatus.index: Chỉ số phần tử (bắt đầu từ 0) -->
```

**Tại sao dùng JSTL thay vì code Java trong JSP?**
- ❌ Code Java trong JSP: Khó đọc, khó bảo trì, vi phạm MVC
- ✅ JSTL: Rõ ràng, dễ đọc, tách biệt logic và giao diện

---

### 💻 2.4. THỰC HÀNH: XÂY DỰNG CHỨC NĂNG QUẢN LÝ SẢN PHẨM (CRUD)

#### **Mục tiêu:**
- Xây dựng ứng dụng Quản lý sản phẩm đồ ăn vặt (không dùng Database, dùng dữ liệu giả)
- Các chức năng:
  1. **Hiển thị danh sách** sản phẩm
  2. **Xem chi tiết** sản phẩm
  3. **Thêm mới** sản phẩm
  4. **Chỉnh sửa** sản phẩm
  5. **Xóa** sản phẩm

#### **Bước 1: Tạo Project Web trên Eclipse**

1. Mở Eclipse -> File -> New -> Dynamic Web Project
2. Tên project: `SnackWebCRUD`
3. Target Runtime: Apache Tomcat 9.0
4. Finish

#### **Bước 2: Cấu trúc thư mục**

```
SnackWebCRUD/
│
├── src/
│   ├── model/
│   │   └── Product.java           (Model - Đối tượng Sản phẩm)
│   └── controller/
│       └── ProductServlet.java    (Controller - Xử lý logic)
│
└── WebContent/
    ├── WEB-INF/
    │   ├── web.xml                 (Cấu hình Servlet)
    │   └── lib/
    │       └── jstl-1.2.jar        (Thư viện JSTL)
    ├── list.jsp                    (View - Danh sách)
    ├── detail.jsp                  (View - Chi tiết)
    └── form.jsp                    (View - Form thêm/sửa)
```

#### **Bước 3: Tạo Model `Product.java`**

```java
package model;

import java.io.Serializable;

/**
 * Class đại diện cho 1 Sản phẩm
 * implements Serializable: Cho phép lưu vào Session/File
 */
public class Product implements Serializable {
    private static final long serialVersionUID = 1L;  // Phiên bản class
    
    // ===== THUỘC TÍNH (Properties) =====
    private int id;             // Mã sản phẩm
    private String name;        // Tên sản phẩm
    private String description; // Mô tả
    private double price;       // Giá
    private String imagePath;   // Đường dẫn ảnh
    
    // ===== CONSTRUCTOR (Hàm khởi tạo) =====
    
    /**
     * Constructor không tham số (bắt buộc phải có)
     * Dùng khi: Tạo object rỗng, sau đó set từng thuộc tính
     */
    public Product() {
    }
    
    /**
     * Constructor đầy đủ tham số
     * Dùng khi: Tạo object và gán giá trị ngay
     */
    public Product(int id, String name, String description, double price, String imagePath) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
    }
    
    // ===== GETTER & SETTER =====
    // Tại sao cần Getter/Setter?
    // - Đóng gói (Encapsulation): Che giấu dữ liệu, chỉ truy cập qua method
    // - Kiểm soát: Có thể thêm logic validation trong Setter
    // - JSP/JSTL: Tự động gọi Getter khi dùng ${product.name}
    
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
        // Ví dụ validation: Giá phải > 0
        if (price < 0) {
            throw new IllegalArgumentException("Giá không được âm!");
        }
        this.price = price;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    // ===== PHƯƠNG THỨC BỔ SUNG =====
    
    /**
     * toString(): Dùng để in thông tin object ra console (Debug)
     */
    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                '}';
    }
}
```

**Giải thích chi tiết:**

1. **`implements Serializable`:**
   - Cho phép object được chuyển đổi thành byte stream
   - Cần thiết khi: Lưu vào Session, File, hoặc truyền qua mạng

2. **`serialVersionUID`:**
   - ID phiên bản class (dùng khi Serialization)
   - Nếu class thay đổi, ID cũng thay đổi -> tránh lỗi khi deserialize

3. **Thuộc tính `private`:**
   - Chỉ truy cập được trong class (Encapsulation)
   - Bắt buộc phải dùng Getter/Setter để truy cập từ bên ngoài

4. **Constructor:**
   - Hàm đặc biệt, tự động gọi khi tạo object: `new Product(...)`
   - Có thể có nhiều Constructor (Overloading)

5. **Getter/Setter:**
   - Getter: Lấy giá trị (prefix `get` + tên thuộc tính viết hoa)
   - Setter: Gán giá trị (prefix `set` + tên thuộc tính viết hoa)
   - JSP/JSTL tự động gọi Getter: `${product.name}` -> gọi `product.getName()`

#### **Bước 4: Tạo Controller `ProductServlet.java`**

```java
package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Product;

/**
 * Servlet xử lý CRUD cho Sản phẩm
 * URL Pattern: /products
 */
@WebServlet("/products")  // Annotation: Ánh xạ URL (thay cho web.xml)
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // ===== DỮ LIỆU GIẢ (Thay cho Database) =====
    // static: Dùng chung cho tất cả request (giả lập database)
    private static List<Product> productList = new ArrayList<>();
    private static int nextId = 1;  // ID tự động tăng
    
    // Khởi tạo dữ liệu mẫu (gọi 1 lần khi Servlet được tạo)
    static {
        productList.add(new Product(nextId++, "Bánh snack BBQ", "Vị BBQ đậm đà", 25000, "images/snack1.jpg"));
        productList.add(new Product(nextId++, "Kẹo dẻo trái cây", "Nhiều vị trái cây", 18000, "images/snack2.jpg"));
        productList.add(new Product(nextId++, "Socola hạnh nhân", "Socola nguyên chất", 35000, "images/snack3.jpg"));
    }
    
    // ===== XỬ LÝ GET REQUEST =====
    /**
     * doGet() được gọi khi:
     * - Truy cập URL trực tiếp từ trình duyệt
     * - Click vào link <a href="/products">
     * - Submit form với method="GET"
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đặt encoding UTF-8 cho Request (Tiếng Việt không bị lỗi font)
        request.setCharacterEncoding("UTF-8");
        
        // Lấy tham số "action" từ URL
        // Ví dụ: /products?action=list  ->  action = "list"
        String action = request.getParameter("action");
        
        // Nếu không có action, mặc định là "list"
        if (action == null) {
            action = "list";
        }
        
        // Xử lý theo action
        switch (action) {
            case "list":
                showList(request, response);  // Hiển thị danh sách
                break;
            case "detail":
                showDetail(request, response);  // Xem chi tiết
                break;
            case "new":
                showNewForm(request, response);  // Form thêm mới
                break;
            case "edit":
                showEditForm(request, response);  // Form chỉnh sửa
                break;
            case "delete":
                deleteProduct(request, response);  // Xóa sản phẩm
                break;
            default:
                showList(request, response);
        }
    }
    
    // ===== XỬ LÝ POST REQUEST =====
    /**
     * doPost() được gọi khi:
     * - Submit form với method="POST"
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "insert";
        }
        
        switch (action) {
            case "insert":
                insertProduct(request, response);  // Thêm mới
                break;
            case "update":
                updateProduct(request, response);  // Cập nhật
                break;
            default:
                showList(request, response);
        }
    }
    
    // ===== CÁC PHƯƠNG THỨC XỬ LÝ =====
    
    /**
     * Hiển thị danh sách sản phẩm
     */
    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Ghi dữ liệu vào Request Scope
        // - Key: "productList"
        // - Value: danh sách sản phẩm
        // JSP sẽ lấy ra bằng ${productList}
        request.setAttribute("productList", productList);
        
        // Forward (chuyển tiếp) tới list.jsp
        // - Request giữ nguyên (dữ liệu setAttribute vẫn còn)
        // - URL không đổi
        request.getRequestDispatcher("list.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị chi tiết sản phẩm
     */
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy ID từ URL: /products?action=detail&id=5
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            // Nếu thiếu ID, quay lại danh sách
            response.sendRedirect("products?action=list");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);  // Chuyển String -> int
            
            // Tìm sản phẩm theo ID
            Product product = findProductById(id);
            
            if (product == null) {
                // Không tìm thấy
                request.setAttribute("errorMessage", "Không tìm thấy sản phẩm!");
                showList(request, response);
            } else {
                // Tìm thấy, gửi sang JSP
                request.setAttribute("product", product);
                request.getRequestDispatcher("detail.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            // ID không hợp lệ (không phải số)
            response.sendRedirect("products?action=list");
        }
    }
    
    /**
     * Hiển thị form thêm mới
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Gửi flag để JSP biết đây là form "Thêm mới" (không phải "Chỉnh sửa")
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("form.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form chỉnh sửa
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("products?action=list");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            Product product = findProductById(id);
            
            if (product == null) {
                response.sendRedirect("products?action=list");
            } else {
                // Gửi sản phẩm hiện tại và flag "Chỉnh sửa"
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
        
        // Lấy dữ liệu từ form
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceParam = request.getParameter("price");
        String imagePath = request.getParameter("imagePath");
        
        // Validation (Kiểm tra dữ liệu)
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên sản phẩm không được rỗng!");
            showNewForm(request, response);
            return;
        }
        
        try {
            double price = Double.parseDouble(priceParam);
            
            if (price < 0) {
                request.setAttribute("errorMessage", "Giá phải >= 0!");
                showNewForm(request, response);
                return;
            }
            
            // Tạo sản phẩm mới
            Product product = new Product(nextId++, name, description, price, imagePath);
            
            // Thêm vào danh sách
            productList.add(product);
            
            // Redirect về danh sách (Tránh submit lại form khi F5)
            // sendRedirect: Tạo Request mới, URL thay đổi
            response.sendRedirect("products?action=list");
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Giá không hợp lệ!");
            showNewForm(request, response);
        }
    }
    
    /**
     * Cập nhật sản phẩm
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceParam = request.getParameter("price");
        String imagePath = request.getParameter("imagePath");
        
        try {
            int id = Integer.parseInt(idParam);
            double price = Double.parseDouble(priceParam);
            
            // Tìm sản phẩm cần update
            Product product = findProductById(id);
            
            if (product == null) {
                response.sendRedirect("products?action=list");
                return;
            }
            
            // Cập nhật thông tin
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setImagePath(imagePath);
            
            // Redirect về danh sách
            response.sendRedirect("products?action=list");
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
            response.sendRedirect("products?action=list");
        }
    }
    
    /**
     * Xóa sản phẩm
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("products?action=list");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            
            // Xóa sản phẩm khỏi danh sách
            productList.removeIf(p -> p.getId() == id);
            // removeIf: Xóa phần tử thỏa điều kiện (Java 8 Lambda)
            
            // Redirect về danh sách
            response.sendRedirect("products?action=list");
            
        } catch (NumberFormatException e) {
            response.sendRedirect("products?action=list");
        }
    }
    
    /**
     * Tìm sản phẩm theo ID
     */
    private Product findProductById(int id) {
        for (Product product : productList) {
            if (product.getId() == id) {
                return product;
            }
        }
        return null;  // Không tìm thấy
    }
}
```

**Giải thích chi tiết:**

1. **`@WebServlet("/products")`:**
   - Annotation (Java 5+): Ghi chú để cấu hình
   - Thay thế cho cấu hình trong `web.xml`
   - URL `/products` sẽ gọi Servlet này

2. **`static` list:**
   - Biến `static` được chia sẻ cho tất cả instance của class
   - Giả lập Database: Dữ liệu không bị mất giữa các request
   - **Lưu ý**: Trong thực tế, dùng Database thật, không dùng static

3. **`doGet()` vs `doPost()`:**
   - `doGet`: Xử lý GET (xem, tìm kiếm, phân trang...)
   - `doPost`: Xử lý POST (thêm, sửa, xóa...)
   - Cùng Servlet, khác method -> Tách biệt logic

4. **`request.setAttribute(key, value)`:**
   - Ghi dữ liệu vào Request Scope
   - Scope: Phạm vi tồn tại của dữ liệu
   - Request Scope: Chỉ tồn tại trong 1 request (forward giữ được, redirect mất)

5. **`forward` vs `sendRedirect`:**
   ```java
   // FORWARD
   request.getRequestDispatcher("list.jsp").forward(request, response);
   // - Chuyển tiếp request hiện tại tới JSP
   // - URL không đổi
   // - Dữ liệu setAttribute vẫn còn
   
   // REDIRECT
   response.sendRedirect("products?action=list");
   // - Tạo request mới
   // - URL thay đổi thành URL mới
   // - Dữ liệu setAttribute mất hết
   ```

#### **Bước 5: Tạo View `list.jsp` (Danh sách)**

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        h1 {
            text-align: center;
            color: #333;
        }
        
        .toolbar {
            margin-bottom: 20px;
        }
        
        .btn {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
        }
        
        .btn:hover {
            background-color: #0056b3;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        th {
            background-color: #333;
            color: white;
            padding: 12px;
            text-align: left;
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        .action-link {
            margin-right: 10px;
            text-decoration: none;
            color: #007bff;
        }
        
        .action-link.delete {
            color: #dc3545;
        }
        
        .error {
            color: red;
            background-color: #ffe6e6;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <h1>🍿 Quản Lý Sản Phẩm Đồ Ăn Vặt</h1>
    
    <!-- THANH CÔNG CỤ -->
    <div class="toolbar">
        <a href="products?action=new" class="btn">➕ Thêm sản phẩm mới</a>
    </div>
    
    <!-- HIỂN THỊ LỖI (Nếu có) -->
    <c:if test="${not empty errorMessage}">
        <div class="error">
            ❌ ${errorMessage}
        </div>
    </c:if>
    
    <!-- BẢNG DANH SÁCH -->
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên sản phẩm</th>
                <th>Mô tả</th>
                <th>Giá (đ)</th>
                <th>Hình ảnh</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <!-- VÒNG LẶP DANH SÁCH -->
            <c:forEach items="${productList}" var="product">
                <tr>
                    <td>${product.id}</td>
                    <td><strong>${product.name}</strong></td>
                    <td>${product.description}</td>
                    <td><strong style="color: #ff6600;">${product.price}</strong></td>
                    <td>
                        <img src="${product.imagePath}" alt="${product.name}" 
                             width="80" height="60" style="object-fit: cover;" />
                    </td>
                    <td>
                        <a href="products?action=detail&id=${product.id}" class="action-link">👁️ Xem</a>
                        <a href="products?action=edit&id=${product.id}" class="action-link">✏️ Sửa</a>
                        <a href="products?action=delete&id=${product.id}" 
                           class="action-link delete" 
                           onclick="return confirm('Bạn chắc chắn muốn xóa?');">🗑️ Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            
            <!-- TRƯỜNG HỢP DANH SÁCH RỖNG -->
            <c:if test="${empty productList}">
                <tr>
                    <td colspan="6" style="text-align: center; color: #999;">
                        Chưa có sản phẩm nào.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
```

**Giải thích JSP chi tiết:**

1. **`<%@ page ... %>`:**
   - Chỉ thị trang: Cấu hình JSP
   - `contentType`: Loại nội dung trả về (HTML + UTF-8)
   - `pageEncoding`: Encoding của file JSP

2. **`<%@ taglib ... %>`:**
   - Nhúng thư viện JSTL
   - `uri`: Địa chỉ thư viện
   - `prefix="c"`: Tiền tố (dùng `<c:...>`)

3. **Expression Language `${...}`:**
   - Lấy dữ liệu từ Scope (Request, Session, Application...)
   - `${productList}`: Lấy dữ liệu từ `request.setAttribute("productList", ...)`
   - `${product.name}`: Gọi `product.getName()`

4. **`<c:if test="${...}">`:**
   - Kiểm tra điều kiện
   - `not empty`: Kiểm tra không rỗng
   - Chỉ hiển thị nội dung bên trong nếu điều kiện đúng

5. **`<c:forEach items="${...}" var="...">`:**
   - Vòng lặp qua danh sách
   - `items`: Danh sách cần lặp
   - `var`: Biến đại diện cho mỗi phần tử

6. **`onclick="return confirm(...)"` (JavaScript inline):**
   - Hiển thị hộp thoại xác nhận trước khi xóa
   - `return confirm(...)`: Nếu user nhấn "Cancel" -> return false -> Link không chạy

#### **Bước 6: Tạo View `detail.jsp` (Chi tiết)**

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .product-detail {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .product-detail img {
            width: 100%;
            max-width: 400px;
            height: auto;
            border-radius: 10px;
            display: block;
            margin: 0 auto 20px;
        }
        
        .product-info {
            margin-top: 20px;
        }
        
        .product-info h1 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .product-info p {
            font-size: 16px;
            line-height: 1.6;
            color: #666;
        }
        
        .product-info .price {
            font-size: 28px;
            color: #ff6600;
            font-weight: bold;
            margin: 15px 0;
        }
        
        .btn-group {
            margin-top: 30px;
            text-align: center;
        }
        
        .btn {
            padding: 12px 25px;
            margin: 0 10px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            font-size: 16px;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="product-detail">
        <!-- KIỂM TRA XEM CÓ DỮ LIỆU KHÔNG -->
        <c:choose>
            <c:when test="${not empty product}">
                <!-- CÓ DỮ LIỆU: Hiển thị chi tiết -->
                <img src="${product.imagePath}" alt="${product.name}" />
                
                <div class="product-info">
                    <h1>${product.name}</h1>
                    <p><strong>Mã sản phẩm:</strong> #${product.id}</p>
                    <p><strong>Mô tả:</strong> ${product.description}</p>
                    <div class="price">${product.price} đ</div>
                </div>
                
                <div class="btn-group">
                    <a href="products?action=edit&id=${product.id}" class="btn btn-primary">✏️ Chỉnh sửa</a>
                    <a href="products?action=list" class="btn btn-secondary">⬅️ Quay lại</a>
                </div>
            </c:when>
            
            <c:otherwise>
                <!-- KHÔNG CÓ DỮ LIỆU -->
                <h2 style="text-align: center; color: #999;">Không tìm thấy sản phẩm!</h2>
                <div class="btn-group">
                    <a href="products?action=list" class="btn btn-secondary">⬅️ Quay lại</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
```

**Giải thích:**
- `<c:choose>`: Giống `switch-case` hoặc `if-else`
- `<c:when test="${...}">`: Nhánh `if` (kiểm tra điều kiện)
- `<c:otherwise>`: Nhánh `else` (khi không điều kiện nào đúng)

#### **Bước 7: Tạo View `form.jsp` (Form Thêm/Sửa)**

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${isEdit}">Chỉnh sửa sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm mới</c:otherwise>
        </c:choose>
    </title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .form-container h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
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
        
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        
        .form-group textarea {
            resize: vertical;  /* Cho phép kéo dọc */
            min-height: 100px;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #007bff;
            outline: none;  /* Bỏ viền mặc định */
        }
        
        .btn-group {
            display: flex;
            justify-content: center;
            gap: 15px;  /* Khoảng cách giữa các nút */
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background-color: #28a745;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
        
        .error {
            color: red;
            background-color: #ffe6e6;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <!-- TIÊU ĐỀ ĐỘNG (Thêm mới hoặc Chỉnh sửa) -->
        <h1>
            <c:choose>
                <c:when test="${isEdit}">✏️ Chỉnh sửa sản phẩm</c:when>
                <c:otherwise>➕ Thêm sản phẩm mới</c:otherwise>
            </c:choose>
        </h1>
        
        <!-- HIỂN THỊ LỖI (Nếu có) -->
        <c:if test="${not empty errorMessage}">
            <div class="error">
                ❌ ${errorMessage}
            </div>
        </c:if>
        
        <!-- FORM -->
        <form action="products" method="POST">
            <!-- HIDDEN INPUT: Gửi action và ID -->
            <input type="hidden" name="action" value="${isEdit ? 'update' : 'insert'}" />
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${product.id}" />
            </c:if>
            
            <!-- TÊN SẢN PHẨM -->
            <div class="form-group">
                <label for="name">Tên sản phẩm: <span style="color: red;">*</span></label>
                <input type="text" id="name" name="name" 
                       value="${product.name}" 
                       placeholder="Nhập tên sản phẩm" 
                       required />
            </div>
            
            <!-- MÔ TẢ -->
            <div class="form-group">
                <label for="description">Mô tả:</label>
                <textarea id="description" name="description" 
                          placeholder="Nhập mô tả sản phẩm">${product.description}</textarea>
            </div>
            
            <!-- GIÁ -->
            <div class="form-group">
                <label for="price">Giá (đ): <span style="color: red;">*</span></label>
                <input type="number" id="price" name="price" 
                       value="${product.price}" 
                       placeholder="Nhập giá" 
                       step="1000"
                       min="0"
                       required />
            </div>
            
            <!-- ĐƯỜNG DẪN HÌNH ẢNH -->
            <div class="form-group">
                <label for="imagePath">Đường dẫn hình ảnh:</label>
                <input type="text" id="imagePath" name="imagePath" 
                       value="${product.imagePath}" 
                       placeholder="Ví dụ: images/product.jpg" />
            </div>
            
            <!-- NÚT HÀNH ĐỘNG -->
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${isEdit}">💾 Cập nhật</c:when>
                        <c:otherwise>✅ Thêm mới</c:otherwise>
                    </c:choose>
                </button>
                <a href="products?action=list" class="btn btn-secondary">❌ Hủy</a>
            </div>
        </form>
    </div>
</body>
</html>
```

**Giải thích chi tiết:**

1. **`<input type="hidden">`:**
   - Ẩn, không hiển thị trên form
   - Dùng để gửi dữ liệu ngầm (action, id...)

2. **Toán tử 3 ngôi trong EL:**
   ```jsp
   ${isEdit ? 'update' : 'insert'}
   ```
   - Giống `isEdit ? 'update' : 'insert'` trong Java/JavaScript
   - Nếu `isEdit = true` -> `'update'`, ngược lại -> `'insert'`

3. **`value="${product.name}"`:**
   - Điền giá trị có sẵn vào input (dùng khi Chỉnh sửa)
   - Nếu Thêm mới: `product` = null -> `value` rỗng

4. **HTML5 Validation:**
   - `required`: Bắt buộc nhập
   - `type="number"`: Chỉ cho phép nhập số
   - `min="0"`: Giá trị tối thiểu
   - `step="1000"`: Tăng/giảm mỗi bước 1000

---

### ✅ BÀI TẬP THỰC HÀNH 2

**Yêu cầu:**
1. Thêm chức năng **Tìm kiếm** sản phẩm theo tên (dùng `String.contains()`)
2. Thêm trường **Category** (Danh mục) vào Product:
   - Ví dụ: "Snack", "Candy", "Chocolate"
   - Thêm dropdown chọn danh mục trong form
3. Validate form ở Servlet:
   - Giá phải >= 0
   - Tên không được rỗng
   - Nếu lỗi, hiển thị thông báo lỗi (không submit)
4. Thêm số lượng sản phẩm hiện có vào đầu trang danh sách
5. (Nâng cao) Thêm chức năng **Sắp xếp** theo giá (tăng/giảm dần)

**Gợi ý:**
- Tìm kiếm: 
  ```java
  String keyword = request.getParameter("keyword");
  List<Product> filtered = productList.stream()
      .filter(p -> p.getName().toLowerCase().contains(keyword.toLowerCase()))
      .collect(Collectors.toList());
  ```
- Sắp xếp:
  ```java
  productList.sort(Comparator.comparingDouble(Product::getPrice));  // Tăng dần
  productList.sort(Comparator.comparingDouble(Product::getPrice).reversed());  // Giảm dần
  ```

---

**PHẦN TIẾP THEO sẽ là:**
- **Bài 3**: Session & Cookie (Đăng nhập, Giỏ hàng)
- **Bài 4**: Kết nối Database & DAO Pattern

Bạn có muốn tôi tiếp tục giải thích các phần còn lại không? 🚀