import 'package:flutter/material.dart';
import '../../models/coupon.dart'; // chỉnh path tuỳ project của bạn

class AdminCouponScreen extends StatefulWidget {
  const AdminCouponScreen({Key? key}) : super(key: key);

  @override
  State<AdminCouponScreen> createState() => _AdminCouponScreenState();
}

class _AdminCouponScreenState extends State<AdminCouponScreen> {
  final List<Coupon> _coupons = [
    // ví dụ khởi tạo vài coupon để test
    Coupon(
      id: 'c001',
      code: 'AB123',
      discountAmount: 10000,
      usageMax: 5,
      usageTimes: 2,
      timeCreate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Coupon(
      id: 'c002',
      code: 'XYZ99',
      discountAmount: 50000,
      usageMax: 10,
      usageTimes: 0,
      timeCreate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeCtrl;
  late TextEditingController _discountCtrl;
  late TextEditingController _maxUsesCtrl;

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController();
    _discountCtrl = TextEditingController();
    _maxUsesCtrl = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _discountCtrl.dispose();
    _maxUsesCtrl.dispose();
    super.dispose();
  }

  void _showCouponDialog({Coupon? coupon}) {
    final isNew = coupon == null;
    if (!isNew) {
      _codeCtrl.text = coupon.code;
      _discountCtrl.text = coupon.discountAmount.toString();
      _maxUsesCtrl.text = coupon.usageMax.toString();
    } else {
      _codeCtrl.clear();
      _discountCtrl.clear();
      _maxUsesCtrl.text = '1';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? 'Tạo Coupon mới' : 'Chỉnh sửa Coupon'),
        content: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _codeCtrl,
              decoration: const InputDecoration(labelText: 'Mã (5 ký tự)'),
              maxLength: 5,
              validator: (v) {
                if (v == null || v.trim().length != 5) {
                  return 'Mã phải đúng 5 ký tự';
                }
                if (!RegExp(r'^[A-Z0-9]+$').hasMatch(v.trim())) {
                  return 'Chỉ được dùng A–Z và 0–9';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _discountCtrl,
              decoration: const InputDecoration(labelText: 'Giá trị giảm (đ)'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = num.tryParse(v ?? '');
                if (n == null || n <= 0) {
                  return 'Giá trị phải > 0';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _maxUsesCtrl,
              decoration: const InputDecoration(labelText: 'Giới hạn dùng tối đa'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 1 || n > 10) {
                  return 'Phải từ 1 đến 10';
                }
                return null;
              },
            ),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newCoupon = Coupon(
                  id: isNew ? DateTime.now().millisecondsSinceEpoch.toString() : coupon.id,
                  code: _codeCtrl.text.trim(),
                  discountAmount: num.parse(_discountCtrl.text),
                  usageMax: int.parse(_maxUsesCtrl.text),
                  usageTimes: isNew ? 0 : coupon.usageTimes,
                  timeCreate: isNew ? DateTime.now() : coupon.timeCreate,
                );
                setState(() {
                  if (isNew) {
                    _coupons.add(newCoupon);
                  } else {
                    final idx = _coupons.indexWhere((c) => c.id == coupon.id);
                    if (idx != -1) _coupons[idx] = newCoupon;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(isNew ? 'Tạo' : 'Lưu'),
          ),
        ],
      ),
    );
  }

  void _deleteCoupon(Coupon c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text('Bạn có chắc muốn xoá coupon "${c.code}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() => _coupons.removeWhere((e) => e.id == c.id));
              Navigator.pop(context);
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Coupon')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCouponDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Tạo Coupon',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _coupons.length,
        separatorBuilder: (_, __) => const Divider(height: 32),
        itemBuilder: (_, i) {
          final c = _coupons[i];
          return ListTile(
            title: Text(c.code, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              'Giảm ${c.discountAmount}đ • ${c.usageTimes}/${c.usageMax} lượt\n'
                  'Ngày tạo: ${c.timeCreate.toLocal().toString().split(' ')[0]}',
            ),
            isThreeLine: true,
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showCouponDialog(coupon: c),
                tooltip: 'Chỉnh sửa',
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteCoupon(c),
                tooltip: 'Xoá',
              ),
            ]),
          );
        },
      ),
    );
  }
}
