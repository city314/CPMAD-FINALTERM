# CPMAD-FINALTERM 🎓💬

Một ứng dụng chat đa nền tảng được phát triển bằng Flutter, sử dụng Firebase để quản lý xác thực, lưu trữ dữ liệu và đồng bộ hóa thời gian thực. Dự án được xây dựng như bài tập cuối kỳ môn **Cross-Platform Mobile App Development**.

## 🧠 Tính năng chính

- 🧾 **Đăng ký / Đăng nhập**
  - Xác thực người dùng qua email và mật khẩu sử dụng Firebase Authentication.

- 🤝 **Gửi và nhận lời mời kết bạn**
  - Tìm kiếm bạn bè bằng email.
  - Gửi yêu cầu kết bạn, xác nhận hoặc từ chối.

- 💬 **Nhắn tin thời gian thực**
  - Giao diện trò chuyện đơn giản và hiệu quả.
  - Tin nhắn được lưu trữ và đồng bộ qua Firebase Cloud Firestore.

- 🔔 **Thông báo trong ứng dụng**
  - Hiển thị thông báo khi có tin nhắn mới hoặc lời mời kết bạn mới.

- 📸 **Gửi ảnh trong trò chuyện**
  - Hỗ trợ gửi hình ảnh qua tin nhắn bằng cách mã hóa base64 (không sử dụng Firebase Storage).

## 🛠️ Công nghệ sử dụng

- [Flutter](https://flutter.dev/) – Framework UI đa nền tảng.
- [Firebase Authentication](https://firebase.google.com/products/auth)
- [Firebase Cloud Firestore](https://firebase.google.com/products/firestore)
- [Provider](https://pub.dev/packages/provider) – Quản lý trạng thái ứng dụng.
- [Base64](https://pub.dev/documentation/convert/latest/convert/base64.html) – Mã hóa hình ảnh trong tin nhắn.

## 🏁 Cài đặt và chạy ứng dụng

1. **Clone dự án**:
   ```bash
   git clone https://github.com/city314/CPMAD-FINALTERM.git
   cd CPMAD-FINALTERM
