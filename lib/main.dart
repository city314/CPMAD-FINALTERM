import 'package:flutter/material.dart';
import 'login.dart'; // nhớ đúng đường dẫn nếu file login.dart nằm cùng thư mục

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Đăng nhập',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoMono', // nếu bạn muốn dùng font mặc định khác
      ),
      home: const LoginScreen(),
    );
  }
}
