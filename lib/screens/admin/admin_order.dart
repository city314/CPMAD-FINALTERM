import 'package:flutter/material.dart';
import '../../models/order.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({Key? key}) : super(key: key);

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  final List<Order> _orders = [
    Order(
      id: 'o1001',
      userId: 'u01',
      sessionId: 'sess_abc',
      totalPrice: 500000,
      loyaltyPointUsed: 10000,
      discount: 20000,
      tax: 30000,
      shippingFee: 15000,
      finalPrice: 515000,
      status: OrderStatus.pending,
      timeCreate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Order(
      id: 'o1002',
      userId: 'u02',
      sessionId: 'sess_def',
      totalPrice: 1200000,
      loyaltyPointUsed: 0,
      discount: 0,
      tax: 60000,
      shippingFee: 20000,
      finalPrice: 1280000,
      status: OrderStatus.shipped,
      timeCreate: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    Order(
      id: 'o1003',
      userId: 'u03',
      sessionId: 'sess_xyz',
      totalPrice: 750000,
      loyaltyPointUsed: 50000,
      discount: 50000,
      tax: 45000,
      shippingFee: 10000,
      finalPrice: 800000,
      status: OrderStatus.complete,
      timeCreate: DateTime.now().subtract(const Duration(hours: 10)),
    ),
  ];

  void _showOrderDetail(Order order) {
    OrderStatus selectedStatus = order.status;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Đơn hàng #${order.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ID: ${order.userId ?? "-"}'),
              const SizedBox(height: 8),
              Text('Tổng tiền: ₫${order.totalPrice.toStringAsFixed(0)}'),
              Text('Điểm dùng: ₫${order.loyaltyPointUsed.toStringAsFixed(0)}'),
              Text('Giảm giá: ₫${order.discount.toStringAsFixed(0)}'),
              Text('Thuế: ₫${order.tax.toStringAsFixed(0)}'),
              Text('Phí vận chuyển: ₫${order.shippingFee.toStringAsFixed(0)}'),
              Text(
                'Tổng thanh toán: ₫${order.finalPrice.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('Ngày tạo: ${order.timeCreate.toLocal()}'),
              const SizedBox(height: 12),
              DropdownButtonFormField<OrderStatus>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Trạng thái'),
                items: OrderStatus.values.map((st) {
                  return DropdownMenuItem(
                    value: st,
                    child: Text(st.name),
                  );
                }).toList(),
                onChanged: (st) {
                  if (st != null) selectedStatus = st;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // cập nhật trạng thái
                final idx = _orders.indexWhere((o) => o.id == order.id);
                if (idx != -1) {
                  _orders[idx] = Order(
                    id: order.id,
                    userId: order.userId,
                    sessionId: order.sessionId,
                    totalPrice: order.totalPrice,
                    loyaltyPointUsed: order.loyaltyPointUsed,
                    discount: order.discount,
                    tax: order.tax,
                    shippingFee: order.shippingFee,
                    finalPrice: order.finalPrice,
                    status: selectedStatus,
                    timeCreate: order.timeCreate,
                  );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Đơn hàng')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const Divider(height: 32),
        itemBuilder: (_, i) {
          final o = _orders[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            title: Text('#${o.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trạng thái: ${o.status.name}'),
                Text('Tổng thanh toán: ₫${o.finalPrice.toStringAsFixed(0)}'),
                Text('Ngày: ${o.timeCreate.toLocal().toString().split('.')[0]}'),
              ],
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              tooltip: 'Chi tiết',
              onPressed: () => _showOrderDetail(o),
            ),
          );
        },
      ),
    );
  }
}
