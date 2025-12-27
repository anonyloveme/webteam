# 📚 HỆ THỐNG TÀI LIỆU HỌC WEB ĐỒ ĂN VẶT - HOÀN CHỈNH

## 🎯 GIỚI THIỆU

Hệ thống tài liệu này được thiết kế theo phương pháp **"VỪA HỌC - VỪA CODE - VỪA HIỂU"**, kết hợp:
- ✅ **Lý thuyết nền tảng** (Định nghĩa, Ý nghĩa, Tại sao)
- ✅ **Code mẫu chi tiết** (Giải thích từng dòng)
- ✅ **Thực hành theo bước** (Làm thật, không chỉ đọc)
- ✅ **Bài tập rèn luyện** (Củng cố kiến thức)

---

## 📂 CẤU TRÚC TÀI LIỆU

### **PHẦN 1: NỀN TẢNG (Bài 1-4)**

#### 📘 [GIAO_TRINH_HOAN_CHINH_WEBSITE_DO_AN_VAT.md](computer:///mnt/user-data/outputs/GIAO_TRINH_HOAN_CHINH_WEBSITE_DO_AN_VAT.md)
**Nội dung:**
- **Bài 1: HTML, CSS, JavaScript Căn Bản**
  - Lý thuyết: HTML (Thẻ, Thuộc tính), CSS (Selector, Flexbox, Grid, Responsive), JavaScript (DOM, Event, Validation)
  - Thực hành: Trang danh sách sản phẩm với Modal đăng nhập
  - Bài tập: Thêm chức năng đăng ký, validate form nâng cao
- **Bài 2: JSP & Servlet Căn Bản**
  - Lý thuyết: Mô hình Client-Server, HTTP Request/Response, Servlet Lifecycle, JSP, JSTL
  - Thực hành: Xây dựng CRUD sản phẩm (không dùng DB)
  - Code mẫu: `Product.java`, `ProductServlet.java`, `list.jsp`, `form.jsp`
  - Bài tập: Thêm tìm kiếm, danh mục, validation

**Dung lượng:** 64KB (~1,500 dòng)

---

#### 📘 [BAI_3_SESSION_COOKIE.md](computer:///mnt/user-data/outputs/BAI_3_SESSION_COOKIE.md)
**Nội dung:**
- **Bài 3: Session & Cookie**
  - Lý thuyết: 
    - Vấn đề Stateless của HTTP
    - Cookie (Định nghĩa, Cách hoạt động, Tạo/Đọc/Xóa)
    - Session (Định nghĩa, Cách hoạt động, Session Scope)
    - So sánh Cookie vs Session
  - Thực hành:
    - **Đăng nhập/Đăng xuất**: `LoginServlet.java`, `LogoutServlet.java`
    - **Giỏ hàng**: `Cart.java`, `CartItem.java`, `CartServlet.java`
  - Code mẫu chi tiết:
    - `User.java`, `UserDAO.java` (Giả lập DB bằng HashMap)
    - `login.jsp`, `adminHome.jsp`, `cart.jsp`
  - Bài tập: Đăng ký, Role-based access, Wishlist, Lịch sử xem

**Dung lượng:** 48KB (~1,200 dòng)

---

#### 📘 [Bài 4 sẽ tạo tiếp: Database & DAO Pattern]
**Nội dung dự kiến:**
- Lý thuyết: JDBC, PreparedStatement, SQL Injection, Transaction, Connection Pooling
- Setup MySQL: Tạo Database, Tables, Foreign Key, Index
- DAO Pattern: `DatabaseConnection.java`, `ProductDAO.java`, `UserDAO.java`, `OrderDAO.java`
- Thực hành: Kết nối thật với MySQL, thay dữ liệu giả bằng DB thật

---

### **PHẦN 2: ỨNG DỤNG CHO 4 THÀNH VIÊN**

#### 📘 [phan_tich_source_code.md](computer:///mnt/user-data/outputs/phan_tich_source_code.md)
**Nội dung:**
- **Phân tích Source Code hiện tại** (DemoNewsWeb_Login_Filter_MySQL.war)
  - Giải thích từng file: Servlet, DAO, Model, Filter, JSP
  - Cấu trúc MVC, Request Flow
- **Đề xuất 4 Chức năng cho 4 Thành viên:**
  1. **Member 1: Quản lý Sản phẩm** (CRUD `tblproduct`)
  2. **Member 2: Giỏ hàng** (Session-based)
  3. **Member 3: Quản lý Đơn hàng** (Transaction, `tblorder`, `tblorder_item`)
  4. **Member 4: Danh mục & Tìm kiếm** (`tblcategory`, SQL LIKE)
- **Database Schema đầy đủ** (SQL Script)
- **Roadmap 5 tuần** (Setup → Dev → Integration → Test → Deploy)
- **Code mẫu chi tiết** cho từng Member

**Dung lượng:** 53KB (~1,700 dòng)

---

#### 📘 [HUONG_DAN_HOC_VA_CODE_CHI_TIET.md](computer:///mnt/user-data/outputs/HUONG_DAN_HOC_VA_CODE_CHI_TIET.md)
**Nội dung:**
- **Lý thuyết nền tảng** (MVC, DAO, JDBC, Servlet/JSP Lifecycle, HTTP, Session & Cookie, Database Design)
- **Hướng dẫn từng bước**:
  - Setup Database (`database_setup.sql`)
  - Tạo Model (`Product.java`)
  - Kết nối DB (`DatabaseConnection.java`)
  - DAO (`ProductDAO.java` - Phần 1: `getAllProducts()`)
- **Giải thích cực kỳ chi tiết** theo nguyên tắc **5W1H** (What, Why, When, Where, Who, How)

**Dung lượng:** 37KB (~1,000 dòng)

---

### **PHẦN 3: TÀI LIỆU PHỤ TRỢ**

#### 📘 [database_setup.sql](computer:///mnt/user-data/outputs/database_setup.sql)
**Nội dung:**
- Script SQL hoàn chỉnh tạo 6 bảng:
  - `tbluser`: Người dùng
  - `tblcategory`: Danh mục sản phẩm
  - `tblproduct`: Sản phẩm (FK -> `tblcategory`)
  - `tblorder`: Đơn hàng (FK -> `tbluser`)
  - `tblorder_item`: Chi tiết đơn hàng (FK -> `tblorder`, `tblproduct`)
  - `tblcart`: Giỏ hàng (Tuỳ chọn, nếu muốn lưu DB)
- Dữ liệu mẫu (Sample Data)
- Foreign Key với `ON DELETE CASCADE` / `SET NULL`
- Index để tăng tốc query

**Dung lượng:** ~3KB

---

## 🎯 CÁCH HỌC HIỆU QUẢ

### **Bước 1: Đọc Lý thuyết (30%)**
```
GIAO_TRINH_HOAN_CHINH_WEBSITE_DO_AN_VAT.md (Bài 1-2)
↓
BAI_3_SESSION_COOKIE.md
↓
[Bài 4 sẽ tạo: Database & DAO]
```

### **Bước 2: Setup Môi trường (10%)**
- Cài đặt: JDK, Eclipse, Tomcat, MySQL (Xampp hoặc standalone)
- Import Source Code: `DemoNewsWeb_Login_Filter_MySQL.war`
- Chạy thử dự án mẫu

### **Bước 3: Code theo Hướng dẫn (50%)**
```
1. Tạo Database (chạy database_setup.sql)
2. Code Model (Product.java, User.java, Order.java...)
3. Code DAO (DatabaseConnection.java, ProductDAO.java...)
4. Code Servlet (ProductServlet.java, LoginServlet.java...)
5. Code JSP (list.jsp, form.jsp, login.jsp...)
6. Test từng chức năng
```

### **Bước 4: Làm Bài tập (10%)**
- Làm bài tập cuối mỗi bài
- Tự nghĩ thêm chức năng mới

---

## 🚀 LỘ TRÌNH HỌC (Dự kiến 5 tuần)

| **Tuần** | **Nội dung** | **Tài liệu** |
|----------|--------------|--------------|
| **Tuần 1** | HTML, CSS, JS + JSP/Servlet Căn bản | Bài 1-2 |
| **Tuần 2** | Session, Cookie, Đăng nhập, Giỏ hàng | Bài 3 |
| **Tuần 3** | Database, JDBC, DAO, Transaction | Bài 4 (sắp tạo) |
| **Tuần 4** | Phân công 4 Member, Code song song | phan_tich_source_code.md |
| **Tuần 5** | Tích hợp, Test, Hoàn thiện, Deploy | Tất cả |

---

## 💡 ĐẶC ĐIỂM NỔI BẬT CỦA TÀI LIỆU

### ✅ **1. Giải thích CỰC KỲ chi tiết**
```java
// Ví dụ: KHÔNG CHỈ code
Cookie cookie = new Cookie("username", "john");

// MÀ CÒN GIẢI THÍCH
/**
 * Tạo Cookie:
 * - Tham số 1: Tên cookie (String)
 * - Tham số 2: Giá trị cookie (String)
 * - Cookie lưu trên trình duyệt Client
 * - Dùng để: Lưu thông tin nhỏ (username, theme...)
 */
```

### ✅ **2. Trả lời câu hỏi "Tại sao?"**
- Tại sao cần MVC? → Để tách biệt logic, dễ bảo trì
- Tại sao dùng PreparedStatement? → Tránh SQL Injection
- Tại sao cần Transaction? → Đảm bảo toàn vẹn dữ liệu
- Tại sao dùng Session thay vì Cookie? → Bảo mật hơn, dung lượng lớn hơn

### ✅ **3. Code có thể chạy ngay**
- Không code mẫu "ví dụ minh họa"
- Code thực tế, copy-paste được
- Có dữ liệu mẫu (sample data)

### ✅ **4. Bài tập rèn luyện**
- Mỗi bài có bài tập cuối
- Có gợi ý code
- Khuyến khích tự nghĩ thêm chức năng

---

## 📞 CÁCH SỬ DỤNG TÀI LIỆU

### **Đọc tuần tự:**
```
README_TAI_LIEU.md (file này)
↓
GIAO_TRINH_HOAN_CHINH_WEBSITE_DO_AN_VAT.md (Bài 1-2)
↓
BAI_3_SESSION_COOKIE.md
↓
[Bài 4: Database & DAO] (sẽ tạo tiếp)
↓
phan_tich_source_code.md (Phân tích dự án & 4 Member)
↓
HUONG_DAN_HOC_VA_CODE_CHI_TIET.md (Tham khảo bổ sung)
```

### **Tham khảo nhanh:**
- Cần hiểu Session/Cookie? → Đọc `BAI_3_SESSION_COOKIE.md`
- Cần code DAO? → Đọc `HUONG_DAN_HOC_VA_CODE_CHI_TIET.md`
- Cần phân công Member? → Đọc `phan_tich_source_code.md`
- Cần tạo Database? → Chạy `database_setup.sql`

---

## 🎓 KẾT QUẢ MONG ĐỢI

Sau khi học xong tài liệu này, bạn sẽ:

✅ **Hiểu rõ:**
- Mô hình MVC trong Web Java
- Cách HTTP Request/Response hoạt động
- Session & Cookie để quản lý trạng thái
- JDBC, PreparedStatement, Transaction
- DAO Pattern để truy cập Database

✅ **Làm được:**
- Xây dựng website Đồ ăn vặt hoàn chỉnh
- Đăng nhập/Đăng xuất
- Giỏ hàng (Session-based)
- CRUD sản phẩm, Danh mục, Đơn hàng
- Tìm kiếm, Phân trang
- Kết nối MySQL

✅ **Chuẩn bị:**
- Phân công 4 Member làm việc song song
- Deploy lên Server thật
- Mở rộng thêm chức năng

---

## 📬 HỖ TRỢ & CẬP NHẬT

**Tài liệu đang tiếp tục được hoàn thiện:**
- ⏳ **Bài 4**: Database & DAO Pattern (sẽ tạo tiếp theo)
- ⏳ **Bài 5-8**: Member 1-4 (Chi tiết từng chức năng)
- ⏳ **Bài 9**: Tìm kiếm & Phân trang
- ⏳ **Bài 10**: Tối ưu giao diện (Bootstrap, AJAX)
- ⏳ **Bài 11**: Deploy & Production

**Bạn cần tôi tiếp tục tạo phần nào tiếp theo?**
1. Bài 4: Database & DAO Pattern (Kết nối MySQL thật)
2. Bài 5-8: Chi tiết code cho 4 Member
3. Bài 9-11: Tìm kiếm, Phân trang, Tối ưu, Deploy

---

## 🎉 CHÚC BẠN HỌC TỐT!

Hãy nhớ: **"Học lập trình = Thực hành 70% + Lý thuyết 30%"**

👉 **Đừng chỉ đọc, hãy CODE theo!** 🚀
