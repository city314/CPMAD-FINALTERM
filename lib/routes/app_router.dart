import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/user/login.dart';
import '../../screens/user/signup.dart';
import '../../screens/user/home.dart';
import '../../screens/user/otp.dart';
import '../../screens/user/productList.dart';
import '../screens/admin/AdminDashboardScreen.dart';
import '../screens/user/account/account_screen.dart';
import '../screens/user/account/edit_profile_screen.dart';
import '../screens/user/account/order_history_screen.dart';
import '../screens/user/account/change_password_after_login.dart';
import '../screens/user/change_password.dart';
import '../screens/user/forgot_password.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/account',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/forgot-password/otp',
      name: 'otp',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final email = data['email'] as String;
        final otp = data['otp'] as String;
        return OtpScreen(email: email, otp: otp);
      },
    ),
    GoRoute(
      path: '/forgot-password/otp/change-password',
      name: 'change_password',
      builder: (context, state) {
        final email = state.extra as String;
        return ChangePasswordScreen(email: email);
      },
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) => const ProductList(),
    ),
    GoRoute(
      path: '/account',
      name: 'account',
      builder: (context, state) => AccountScreen(),
    ),
    GoRoute(
      path: '/account/edit',
      name: 'edit_profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/account/order-histories',
      name: 'order_history',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/account/change-password-after-login',
      name: 'change_password_after_login',
      builder: (context, state) => const ChangePasswordAfterLoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot_password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);
