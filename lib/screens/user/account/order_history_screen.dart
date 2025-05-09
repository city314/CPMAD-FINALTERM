import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': '#001', 'date': '2024-05-01', 'total': '\$1,200'},
      {'id': '#002', 'date': '2024-05-05', 'total': '\$980'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            leading: const Icon(Icons.receipt),
            title: Text('Đơn hàng ${order['id']}'),
            subtitle: Text('Ngày: ${order['date']}'),
            trailing: Text('${order['total']}'),
            onTap: () {
              // TODO: Xem chi tiết đơn hàng
            },
          );
        },
      ),
    );
  }
}
