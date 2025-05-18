import 'package:flutter/material.dart';
import '../../../models/order.dart';
import '../../../service/OrderService.dart';
import '../../../utils/format_utils.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    final userId = '123'; // Hoặc load từ SharedPreferences
    _futureOrders = OrderService().fetchUserOrders(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
      body: FutureBuilder<List<Order>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final orders = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              return ExpansionTile(
                leading: const Icon(Icons.receipt_long),
                title: Text('Đơn hàng ${order.id}'),
                subtitle: Text(
                  'Ngày: ${order.timeCreate.toLocal().toString().split(' ')[0]}\n'
                      'Trạng thái: ${order.status}',
                ),
                trailing: Text(formatPrice(order.finalPrice)),
                children: order.items
                    .map((item) => ListTile(
                  title: Text(item.productName),
                  trailing: Text('x${item.quantity}'),
                ))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}

