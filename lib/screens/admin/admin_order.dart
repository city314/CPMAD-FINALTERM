import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../models/orderDetail.dart';
import '../../models/user.dart';
import 'component/SectionHeader.dart';

// Helper extension to capitalize enum names
extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({Key? key}) : super(key: key);

  @override
  _AdminOrderScreenState createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  // Sample data; replace with real API fetch
  final List<Order> _orders = [
    Order(
      id: 'o1001', userId: 'u01', sessionId: 'sess_abc',
      totalPrice: 500000, loyaltyPointUsed: 10000, discount: 20000,
      tax: 30000, shippingFee: 15000, finalPrice: 515000,
      status: OrderStatus.pending,
      timeCreate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Order(
      id: 'o1002', userId: 'u02', sessionId: 'sess_def',
      totalPrice: 1200000, loyaltyPointUsed: 0, discount: 0,
      tax: 60000, shippingFee: 20000, finalPrice: 1280000,
      status: OrderStatus.shipped,
      timeCreate: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
  ];
  final List<OrderDetail> _orderDetails = [
    OrderDetail(id: 'd1', orderId: 'o1001', productId: 'p1', quantity: 1, price: 500000, total: 500000),
    OrderDetail(id: 'd2', orderId: 'o1002', productId: 'p2', quantity: 2, price: 600000, total: 1200000),
  ];
  final List<User> _users = [
    User(
      id: 'u01', avatar: '', email: 'alice@example.com', name: 'Alice', gender: 'F', birthday: '1990-01-01',
      phone: '0123456789', addresses: [], role: 'customer', status: 'active',
      timeCreate: DateTime.now().subtract(const Duration(days: 10)),
    ),
    User(
      id: 'u02', avatar: '', email: 'bob@example.com', name: 'Bob', gender: 'M', birthday: '1988-05-12',
      phone: '0987654321', addresses: [], role: 'customer', status: 'active',
      timeCreate: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  static const List<OrderStatus> _statuses = [
    OrderStatus.pending,
    OrderStatus.paid,
    OrderStatus.shipped,
    OrderStatus.complete,
    OrderStatus.canceled,
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _statuses.length,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SectionHeader('Quản lý Đơn hàng'),
              const SizedBox(height: 12),
              TabBar(
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: _statuses
                    .map((s) => Tab(text: s.name.capitalize()))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  children: _statuses.map((status) {
                    // Filter and sort orders by status and date
                    final list = _orders
                        .where((o) => o.status == status)
                        .toList()
                      ..sort((a, b) => b.timeCreate.compareTo(a.timeCreate));
                    return _buildOrderList(list);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('Không có đơn hàng'));}
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Divider(height: 32),
      itemBuilder: (context, i) {
        final o = orders[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          title: Text('#${o.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Ngày: ${o.timeCreate.toLocal().toString().split('.')[0]}'),
          trailing: Text(o.status.name.capitalize(), style: const TextStyle(fontSize: 12)),
          onTap: () => _showDetail(o),
        );
      },
    );
  }

  void _showDetail(Order order) {
    OrderStatus selected = order.status;
    // Fetch user and order details
    final user = _users.firstWhere((u) => u.id == order.userId, orElse: () => User(
      id: '',
      avatar: '',
      email: '',
      name: 'Unknown',
      gender: '',
      birthday: '',
      phone: '',
      addresses: [],
      role: '',
      status: '',
      timeCreate: DateTime.now(),
    ));
    final details = _orderDetails.where((d) => d.orderId == order.id).toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Đơn #${order.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Khách hàng: ${user.name} (${user.email})'),
              const SizedBox(height: 8),
              ...details.map((d) => Text('• ${d.productId} x${d.quantity} = ₫${d.total.toStringAsFixed(0)}')),
              const Divider(),
              Text('Tạm tính: ₫${order.totalPrice.toStringAsFixed(0)}'),
              Text('Giảm: ₫${order.discount.toStringAsFixed(0)}'),
              Text('Thuế: ₫${order.tax.toStringAsFixed(0)}'),
              Text('Ship: ₫${order.shippingFee.toStringAsFixed(0)}'),
              Text('Tổng: ₫${order.finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DropdownButtonFormField<OrderStatus>(
                value: selected,
                decoration: const InputDecoration(labelText: 'Trạng thái'),
                items: _statuses.map((st) {
                  return DropdownMenuItem(value: st, child: Text(st.name.capitalize()));
                }).toList(),
                onChanged: (v) => selected = v ?? selected,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final idx = _orders.indexWhere((o) => o.id == order.id);
                if (idx != -1) {
                  _orders[idx] = order.copyWith(status: selected);
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
