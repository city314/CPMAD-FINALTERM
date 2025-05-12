import 'package:go_router/go_router.dart';

import '../../screens/user/login.dart';
import '../../screens/user/signup.dart';
import '../../screens/user/home.dart';
import '../../screens/user/otp.dart';
import '../../screens/user/productList.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/admin_product.dart';
import '../screens/admin/admin_wrapper.dart';
import '../screens/user/account/account_screen.dart';
import '../screens/user/account/edit_profile_screen.dart';
import '../screens/user/account/order_history_screen.dart';
import '../screens/user/account/change_password_after_login.dart';
import '../screens/user/change_password.dart';
import '../screens/user/forgot_password.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/admin/dashboard',
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
    ShellRoute(
      // Wrapper duy nhất, quản lý AppBar/Sidebar/BottomNav
      builder: (context, state, child) {
        // chuyển state.location thành selectedIndex
        int _tabIndexFromLoc(String loc) {
          if (loc.startsWith('/admin/dashboard')) return 0;
          if (loc.startsWith('/admin/products'))  return 1;
          if (loc.startsWith('/admin/orders'))    return 2;
          if (loc.startsWith('/admin/users'))     return 3;
          if (loc.startsWith('/admin/coupons'))   return 4;
          if (loc.startsWith('/admin/chat'))      return 5;
          return 0;
        }

        return AdminHomeWrapper(
          child: child,
          selectedIndex: _tabIndexFromLoc(state.uri.toString()),
          onTabChanged: (i) {
            switch (i) {
              case 0: context.go('/admin/dashboard'); break;
              case 1: context.go('/admin/products');  break;
              case 2: context.go('/admin/orders');    break;
              case 3: context.go('/admin/users');     break;
              case 4: context.go('/admin/coupons');   break;
              case 5: context.go('/admin/chat');      break;
            }
          },
        );
      },
      routes: [
        GoRoute(
          path: '/admin/dashboard',
          name: 'admin_dashboard',
          builder: (c, s) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/products',
          name: 'admin_products',
          builder: (c, s) => AdminProductScreen(),
        ),
        // GoRoute(
        //   path: '/admin/orders',
        //   name: 'admin_orders',
        //   builder: (c, s) => const AdminOrderScreen(),
        // ),
        // GoRoute(
        //   path: '/admin/users',
        //   name: 'admin_users',
        //   builder: (c, s) => AdminUserScreen(),
        // ),
        // GoRoute(
        //   path: '/admin/coupons',
        //   name: 'admin_coupons',
        //   builder: (c, s) => const AdminCouponScreen(),
        // ),
        // GoRoute(
        //   path: '/admin/chat',
        //   name: 'admin_chat',
        //   builder: (c, s) => const AdminChatScreen(),
        // ),
      ],
    ),
  ],
);
