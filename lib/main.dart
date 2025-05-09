import 'package:flutter/material.dart';
import 'package:cpmad_final/screens/user/login.dart';
import 'package:cpmad_final/screens/user/account/account_screen.dart';
import 'routes/app_router.dart';
// import 'package:cpmad_final/screens/user/account/account_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ứng dụng Đăng nhập',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoMono',
      ),
      routerConfig: appRouter, // sử dụng GoRouter
    );
  }
}