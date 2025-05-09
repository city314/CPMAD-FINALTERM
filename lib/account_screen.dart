import 'package:flutter/material.dart';
import 'change_password.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': '#001', 'date': '2024-05-01', 'total': '\$1,200'},
      {'id': '#002', 'date': '2024-05-05', 'total': '\$980'},
    ];

    final vouchers = ['GIAM10%', 'FREESHIP', 'KMHE2025'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản của tôi'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Thông tin cá nhân
          Card(
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
                  buildInfoRow(Icons.comment, 'Bình luận đã viết', '12 bình luận'),
                  buildInfoRow(Icons.star, 'Sản phẩm đã đánh giá', '8 sản phẩm'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Lịch sử đơn hàng
          const Text(
            'Lịch sử đơn hàng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...orders.map((order) {
            return ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text('Đơn hàng ${order['id']}'),
              subtitle: Text('Ngày: ${order['date']}'),
              trailing: Text('${order['total']}'),
              onTap: () {
                // TODO: Xem chi tiết đơn hàng
              },
            );
          }).toList(),

          const SizedBox(height: 24),

          // Điểm thưởng
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

          // Mã giảm giá
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
      ),
    );
  }
}

Widget buildInfoRow(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    leading: Icon(icon, color: Colors.blueAccent),
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: onTap != null
        ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent)
        : null,
    onTap: onTap,
  );
}