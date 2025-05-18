# CPMAD – Đồ Án Cuối Kỳ

> **Môn học**: CPMAD – Phát triển Ứng dụng Di động đa nền tảng
> **Học kỳ**: Cuối Kỳ  
> **Đề tài**: Quản lý cửa hàng Lapizone bán laptop và phụ kiện 
> **Tác giả**:
> - Lê Công Tuấn - 52200033
> - Mai Nguyễn Phương Trang - 52200051
> - Đoàn Thống Lĩnh - 52200013

## 📖 Tổng Quan

Kho code này chứa toàn bộ mã nguồn của đồ án cuối kỳ môn CPMAD. Ứng dụng là một hệ thống đa nền tảng (mobile & web) xây dựng bằng **Flutter**, kết nối với API **Node.js/Express** và cơ sở dữ liệu **MongoDB**.  
Ứng dụng minh họa:

- Xác thực phân quyền (Khách hàng & Phục vụ/Admin)
- Đặt đơn hàng & quản lý đơn hàng theo thời gian thực
- Khả năng hoạt động đồng bộ khi có mạng
- Giao diện sạch, responsive trên các kích thước màn hình

## 🚀 Tính Năng

- **Xác thực người dùng**
  - Đăng ký/Đăng nhập bằng email & mật khẩu
  - Phân quyền: Khách hàng và Phục vụ/Admin

- **Thực đơn & Giỏ hàng**
  - Duyệt sản phẩm và biến thể
  - Thêm/Xóa món, điều chỉnh số lượng
  - Giỏ hàng hiển thị cố định bên cạnh

- **Xử lý đơn hàng**
  - Đặt đơn
  - Xem lịch sử đơn và cập nhật trạng thái

- **Bảng điều khiển Admin**
  - Xem tất cả đơn hàng
  - Duyệt/Từ chối đơn đang chờ
  - Quản lý sản phẩm, danh mục, biến thể

- **Chế độ Offline**
  - Lưu cache thực đơn & đơn đặt
  - Tự động đồng bộ khi có kết nối

## 📁 Cấu Trúc Thư Mục

CPMAD-FINALTERM/
├── client/ # Ứng dụng Flutter (front-end)
│ ├── lib/
│ │ ├── main.dart
│ │ ├── screens/ # Các màn hình (Home, Cart, Admin,…)
│ │ ├── services/ # Service gọi API & lưu dữ liệu local
│ │ ├── models/ # Các lớp mô hình (Product, Order, User,…)
│ │ └── widgets/ # Component tái sử dụng
│ └── pubspec.yaml
│
├── server/ # API Node.js/Express (back-end)
│ ├── src/
│ │ ├── controllers/ # Xử lý route
│ │ ├── models/ # Schema Mongoose
│ │ ├── routes/ # Định nghĩa route
│ │ └── utils/ # Helper, middleware, config
│ ├── .env.example # Mẫu biến môi trường
│ └── package.json
│
└── README.md # Tập tin này


## 🔧 Bắt Đầu

### Yêu Cầu

- **Flutter SDK** ≥ 3.7.2
- **Node.js** ≥ 16.x & **npm**
- **MongoDB** (cục bộ hoặc cloud)

### 1. Mở database MongoDB Compass
- Tạo Connection mới
- Nhập URI: mongodb+srv://thonglinhiq:linhim0028@finalflutter.bfjgcda.mongodb.net/?retryWrites=true&w=majority&appName=FinalFlutter

### 2. Mở Android sutdio
- Mở dự án qua thư mục CPMAD-FINALTERM

### 3. Cài Đặt Front-end
- flutter pub get

### 3. Cài Đặt Back-end
- cd server
- npm install express mongoose body-parser cors dotenv uuid axios bcrypt jsonwebtoken nodemailer moment socket.io nodemon concurrently
- npm install --save-dev concurrently
  - sửa trong package.json
    {
      "dependencies": {
      "axios": "^1.9.0",
      "bcrypt": "^5.1.1",
      "body-parser": "^2.2.0",
      "cors": "^2.8.5",
      "dotenv": "^16.5.0",
      "express": "^5.1.0",
      "jsonwebtoken": "^9.0.2",
      "moment": "^2.30.1",
      "mongoose": "^8.14.2",
      "nodemailer": "^7.0.3",
      "uuid": "^11.1.0"
      },
  
      "scripts": {
        "dev:user": "nodemon UserService/server.js",
        "dev:product": "nodemon ProductService/server.js",
        "dev:order": "nodemon OrderService/server.js",
        "dev": "concurrently \"npm run dev:user\" \"npm run dev:product\" \"npm run dev:order\""
        }
      }
    }
- npm run dev (ở folder service)

### Công Nghệ Sử Dụng
- Flutter & Dart cho mobile/web đa nền tảng
- Node.js, Express cho RESTful API
- MongoDB & Mongoose cho lưu trữ dữ liệu
- GoRouter cho điều hướng trong app
- Provider / Riverpod (hoặc thư viện bạn chọn) cho quản lý state