import 'package:flutter/material.dart';
import 'admin_top_navbar.dart';
import 'admin_bottom_navbar.dart';

/// A wrapper widget that provides the common Scaffold layout for the admin section,
/// including AppBar (mobile), Sidebar (web), and BottomNavBar (mobile).
class AdminHomeWrapper extends StatelessWidget {
  /// The main content to display (e.g., Dashboard, Products, etc.)
  final Widget child;

  /// The current navigation index, used to highlight the active tab/item.
  final int selectedIndex;

  /// Callback when the user selects a new tab/item.
  final ValueChanged<int> onTabChanged;

  const AdminHomeWrapper({
    Key? key,
    required this.child,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      // Mobile: show AppBar with dynamic title; Web: hide AppBar
      appBar: isMobile
          ? AppBar(title: Text(_getTitle(selectedIndex)))
          : null,

      // Body: mobile shows the child directly; web shows sidebar + child
      body: isMobile
          ? child
          : Row(
        children: [
          AdminTopNavbar(
            selectedIndex: selectedIndex,
            onItemSelected: onTabChanged,
            userAvatarUrl: 'https://your-avatar-url.png',
            userName: 'Admin',
            userRole: 'Administrator',
          ),
          Expanded(child: child),
        ],
      ),

      // Mobile: show bottom navigation bar; Web: none
      bottomNavigationBar: isMobile
          ? AnimatedBottomNavBar(onItemSelected: onTabChanged)
          : null,
    );
  }

  /// Returns the AppBar title for each index (mobile view).
  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Product Management';
      case 2:
        return 'User Management';
      case 3:
        return 'Order Management';
      case 4:
        return 'Coupon Management';
      case 5:
        return 'Customer Support';
      default:
        return '';
    }
  }
}