import 'package:flutter/material.dart';
import 'change_password.dart';
import 'order_history_screen.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản của tôi'),
        backgroundColor: Colors.blueAccent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  isWide
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cột trái: Thông tin cá nhân
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildProfileCard(context),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Cột phải: Tiện ích
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOptions(context),
                          ],
                        ),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      _buildProfileCard(context),
                      const SizedBox(height: 24),
                      _buildOptions(context),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
// Profile Card
Widget _buildProfileCard(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.indigo[50],
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                SizedBox(height: 8),
                Text(
                  'Nguyễn Văn A',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                Text(
                  'nguyenvana@example.com',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          buildInfoRow(Icons.location_on, 'Địa chỉ giao hàng', '123 Đường ABC, Quận 1, TP.HCM'),
          buildInfoRow(Icons.vpn_key, 'Mật khẩu', '********', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
          }),
          buildInfoRow(Icons.person, 'Vai trò', 'Khách hàng'),
          buildInfoRow(Icons.lock, 'Trạng thái tài khoản', 'Hoạt động'),
          buildInfoRow(Icons.edit, 'Chỉnh sửa thông tin', null, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            );
          }),
        ],
      ),
    ),
  );
}
// Info Row
Widget buildInfoRow(IconData icon, String title, String? subtitle, {VoidCallback? onTap}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    leading: Icon(icon, color: Colors.blueAccent),
    title: Text(title),
    subtitle: subtitle != null && subtitle.isNotEmpty ? Text(subtitle) : null,
    trailing: onTap != null
        ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent)
        : null,
    onTap: onTap,
  );
}
// Info Option
Widget _buildOptions(BuildContext context) {
  final vouchers = ['GIAM10%', 'FREESHIP', 'KMHE2025'];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        leading: const Icon(Icons.history),
        title: const Text('Xem lịch sử đơn hàng'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
          );
        },
      ),
      const SizedBox(height: 24),
      const Text(
        'Điểm thưởng của bạn',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Card(
        color: Colors.orange[100],
        child: ListTile(
          leading: const Icon(Icons.star, color: Colors.orange),
          title: const Text('280 điểm'),
          subtitle: const Text('Tích lũy từ các đơn hàng trước'),
          trailing: TextButton(
            onPressed: () {
              // TODO: Quy đổi điểm
            },
            child: const Text('Quy đổi'),
          ),
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        'Mã giảm giá hiện có',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      ...vouchers.map((code) {
        return ListTile(
          leading: const Icon(Icons.local_offer),
          title: Text(code),
          trailing: const Text('Sử dụng'),
          onTap: () {
            // TODO: Áp dụng mã
          },
        );
      }).toList(),
    ],
  );
}
