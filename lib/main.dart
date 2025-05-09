import 'package:flutter/material.dart';
import 'package:cpmad_final/screens/user/home.dart';
import 'package:cpmad_final/screens/admin/AdminDashboardScreen.dart';

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
      // home: HomeScreen(),
      home: AdminDashboardScreen(),
    );
  }
}
