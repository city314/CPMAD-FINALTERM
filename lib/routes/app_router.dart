import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/user/login.dart';
import '../../screens/user/signup.dart';
import '../../screens/user/home.dart';
import '../../screens/user/otp.dart';
import '../../screens/user/productList.dart';
import '../screens/user/account/account_screen.dart';
import '../screens/user/account/edit_profile_screen.dart';
import '../screens/user/account/order_history_screen.dart';
import '../screens/user/account/change_password.dart';
import '../screens/user/account/forgot_password.dart';

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
      path: '/otp',
      name: 'otp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) => const ProductList(),
    ),
    GoRoute(
      path: '/account',
      name: 'account',
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(
      path: '/account/edit',
      name: 'edit_profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/account/orders',
      name: 'order_history',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/account/change-password',
      name: 'change_password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot_password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
);
