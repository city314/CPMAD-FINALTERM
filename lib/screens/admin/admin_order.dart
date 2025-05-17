import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../models/orderDetail.dart';
import '../../models/user.dart';
import 'component/SectionHeader.dart';
import '../../utils/format_utils.dart';

// Color palette
const Color kDark1    = Color.fromRGBO(11,  36,  51, 1);
const Color kDark2    = Color.fromRGBO(49,  68,  78, 1);
const Color kDark3    = Color.fromRGBO(73,  86,  98, 1);
const Color kLight1   = Color.fromRGBO(166, 188, 194,1);
const Color kLight2   = Color.fromRGBO(238, 249, 254,1);
const Color kAccent1  = Color.fromRGBO(76,  159, 195,1);
const Color kAccent2  = Color.fromRGBO(91,  241, 245,1);

// Extension to capitalize enum names
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
      id: 'o1001', userId: 'u01',
      totalPrice: 500000, loyaltyPointUsed: 10000, discount: 20000,
      tax: 30000, shippingFee: 15000, finalPrice: 515000,
      status: OrderStatus.pending,
      timeCreate: DateTime.now().subtract(const Duration(days: 2)), coupon: 0,
    ),
    Order(
      id: 'o1002', userId: 'u02',
      totalPrice: 1200000, loyaltyPointUsed: 0, discount: 0,
      tax: 60000, shippingFee: 20000, finalPrice: 1280000,
      status: OrderStatus.shipped,
      timeCreate: DateTime.now().subtract(const Duration(days: 1, hours: 5)), coupon: 0,
    ),
  ];
  final List<OrderDetail> _orderDetails = [
    OrderDetail(id: 'd1', orderId: 'o1001', productId: 'p1', quantity: 1, price: 500000),
    OrderDetail(id: 'd2', orderId: 'o1002', productId: 'p2', quantity: 2, price: 600000),
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
        backgroundColor: Colors.grey.shade100,
        body: Column(
          children: [
            // Section Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: const SectionHeader('Quản lý Danh mục'),
            ),
            // TabBar
            Container(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.white,
                tabs: _statuses.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(s.name.capitalize()),
                )).toList(),
              ),
            ),
            // Tab Views
            Expanded(
              child: TabBarView(
                children: _statuses.map((status) {
                  final list = _orders.where((o) => o.status == status).toList()
                    ..sort((a, b) => b.timeCreate.compareTo(a.timeCreate));
                  if (list.isEmpty) {
                    return const Center(
                      child: Text('Không có đơn hàng', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final o = list[i];
                      final user = _users.firstWhere(
                            (u) => u.id == o.userId,
                        orElse: () => User(
                          id: '', avatar: '', email: '', name: 'Unknown', gender: '', birthday: '',
                          phone: '', addresses: [], role: '', status: '', timeCreate: DateTime.now(),
                        ),
                      );
                      // For pending orders, show action buttons
                      if (status == OrderStatus.pending) {
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey.shade300,
                                      child: Text(user.name.isNotEmpty ? user.name[0] : '?'),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('#\${o.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text(user.name),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            final idx = _orders.indexWhere((e) => e.id == o.id);
                                            if (idx != -1) {
                                              _orders[idx] = o.copyWith(status: OrderStatus.canceled);
                                            }
                                          });
                                        },
                                        child: const Text('Từ chối'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            final idx = _orders.indexWhere((e) => e.id == o.id);
                                            if (idx != -1) {
                                              _orders[idx] = o.copyWith(status: OrderStatus.paid);
                                            }
                                          });
                                        },
                                        child: const Text('Duyệt đơn'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      // Other statuses: default card
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _showDetail(o),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  child: Text(user.name.isNotEmpty ? user.name[0] : '?'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('#\${o.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(user.name),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\${o.timeCreate.toLocal()}'.split('.')[0],
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(Order o) {
    OrderStatus selected = o.status;
    final user = _users.firstWhere(
          (u) => u.id == o.userId,
      orElse: () => User(
        id: '', avatar: '', email: '', name: 'Unknown', gender: '', birthday: '',
        phone: '', addresses: [], role: '', status: '', timeCreate: DateTime.now(),
      ),
    );
    final details = _orderDetails.where((d) => d.orderId == o.id).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kDark3,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Đơn #${o.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDark1)),
            const SizedBox(height: 8),
            Text('Khách hàng: ${user.name}', style: const TextStyle(fontSize: 14, color: kDark3)),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 14, color: kDark3)),
            const Divider(color: kDark2, height: 24),
            const Text('Chi tiết sản phẩm', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...details.map((d) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(d.productId, style: const TextStyle(color: kDark3)),
                  Text('x${d.quantity}', style: const TextStyle(color: kDark3)),
                  Text(formatPrice((d.price*d.quantity).toDouble()), style: const TextStyle(color: kDark3)),
                ],
              ),
            )),
            const Divider(color: kDark2, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formatPrice(o.finalPrice.toDouble()), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<OrderStatus>(
                    value: selected,
                    decoration: const InputDecoration(labelText: 'Trạng thái'),
                    items: _statuses.map((st) => DropdownMenuItem(
                      value: st,
                      child: Text(st.name.capitalize(), style: TextStyle(color: _statusColor(st))),
                    )).toList(),
                    onChanged: (v) => selected = v ?? selected,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final idx = _orders.indexWhere((o2) => o2.id == o.id);
                      _orders[idx] = o.copyWith(status: selected);
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: kAccent1),
                  child: const Text('Cập nhật'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.paid:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.complete:
        return Colors.green;
      case OrderStatus.canceled:
        return Colors.red;
    }
  }
}