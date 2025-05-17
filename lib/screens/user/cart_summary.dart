import 'dart:convert';

import 'package:cpmad_final/pattern/current_user.dart';
import 'package:cpmad_final/service/OrderService.dart';
import 'package:cpmad_final/service/UserService.dart';
import 'package:flutter/material.dart';
import '../../utils/format_utils.dart';

import '../../models/selectedproduct.dart';
import 'CustomNavbar.dart';

class CartSummary extends StatefulWidget {
  final List<SelectedProduct> selectedItems;

  const CartSummary({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CartSummary> {
  bool _useCoins = false;
  final TextEditingController _voucherController = TextEditingController();
  double _voucherDiscount = 0;
  String? _voucherMessage;
  bool _isVoucherApplied = false;
  final TextEditingController _coinController = TextEditingController();
  int loyalty = 0;
  int lyt = 0;

  // Controllers
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  // Khai báo form key để validate
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadExternalData();
  }

  void _loadExternalData() async {
    try {
      final productIds = widget.selectedItems
          .map((e) => e.variant.productId)
          .toList();

      loyalty = await UserService.getLoyaltyPoint(CurrentUser().email ?? '');
      lyt = loyalty;
      setState(() {
        _coinController.text = loyalty.toString();
      });
    } catch (e) {
      print('❌ Lỗi khi load dữ liệu checkout: $e');
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(icon, color: Theme
            .of(context)
            .primaryColor),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    // Tính toán trước totalPrice, totalDiscount, finalAmount
    double totalPrice = 0;
    double totalDiscount = 0;

    for (var item in widget.selectedItems) {
      final price = item.variant.sellingPrice;
      final discount = item.discount;
      totalPrice += price * item.quantity;
      totalDiscount += price * item.quantity * (discount / 100);
    }

    double finalAmount = totalPrice - totalDiscount - loyalty * 1000 - _voucherDiscount;

    // Xác định layout rộng hay hẹp
    final isWide = MediaQuery.of(context).size.width >= 800;

    // Chiều cao dành cho list trên mobile (40% màn hình)
    final screenHeight = MediaQuery.of(context).size.height;
    final listHeight = screenHeight * 0.4;

    return Scaffold(
      appBar: CustomNavbar(
        onHomeTap: () {},
        onCategoriesTap: () {},
        onCartTap: () {},
        onRegisterTap: () {},
        onLoginTap: () {},
        onSupportTap: () {},
        onSearch: (value) {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isWide
        // ---- Web/Desktop: 2 cột ----
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildProductList(),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSummary(totalPrice, totalDiscount, finalAmount),
                    const SizedBox(height: 24),
                    Text(
                      'Thông tin giao hàng',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildShippingForm(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _onConfirmPressed,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Xác nhận thanh toán'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
        // ---- Mobile: xếp dọc, cuộn được ----
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: listHeight,
                child: _buildProductList(),
              ),
              const SizedBox(height: 24),
              _buildSummary(totalPrice, totalDiscount, finalAmount),
              const SizedBox(height: 24),
              Text(
                'Thông tin giao hàng',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildShippingForm(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onConfirmPressed,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Xác nhận thanh toán'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildProductList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.selectedItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = widget.selectedItems[index];
        final variant = item.variant;
        final imageUrl = variant.images.isNotEmpty ? variant
            .images[0]['base64'] ?? '' : '';

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.memory(base64Decode(imageUrl), width: 50,
                  height: 50,
                  fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 40),
            ),
            title: Text(variant.variantName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Số lượng: ${item.quantity}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatPrice(variant.sellingPrice),
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummary(double total, double discount, double finalAmount) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on, color: Colors.orange),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _coinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Sử dụng Điểm khách hàng thân thiết (tối đa: ${lyt
                        .toStringAsFixed(0)})',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final input = double.tryParse(value) ?? 0;
                    setState(() {
                      loyalty = input as int;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.discount, color: Colors.orange),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _voucherController,
                  decoration: InputDecoration(
                    labelText: 'Mã phiếu giảm giá',
                    suffixIcon: TextButton(
                        child: const Text('Áp dụng'),
                        onPressed: () async {
                          final code = _voucherController.text.trim();
                          final info = await OrderService.checkCoupon(code);
                          if (info != null) {
                            final remaining = info.usageMax - info.usageTimes;

                            // Tính lại total price và total discount hiện tại
                            double totalPrice = 0;
                            double totalDiscount = 0;
                            for (var item in widget.selectedItems) {
                              final price = item.variant.sellingPrice;
                              final discount = item.discount;
                              totalPrice += price * item.quantity;
                              totalDiscount +=
                                  price * item.quantity * (discount / 100);
                            }

                            double subtotalAfterDiscounts = totalPrice -
                                totalDiscount - loyalty * 1000;

                            // Kiểm tra hiệu lực mã
                            if (info.discountAmount <= subtotalAfterDiscounts) {
                              setState(() {
                                _voucherDiscount =
                                    info.discountAmount.toDouble();
                                _isVoucherApplied = true;
                                _voucherMessage =
                                'Mã ${info.code} áp dụng thành công (-${info
                                    .discountAmount.toStringAsFixed(0)} đ)\n'
                                    'Số lượt còn lại: $remaining / ${info
                                    .usageMax}';
                              });
                            } else {
                              setState(() {
                                _voucherDiscount = 0;
                                _voucherMessage =
                                'Mã không hợp lệ: Giá trị đơn hàng phải >= ${info
                                    .discountAmount} để áp dụng mã này.';
                                _isVoucherApplied = false;
                              });
                            }
                          } else {
                            setState(() {
                              _voucherDiscount = 0;
                              _voucherMessage =
                              'Mã không hợp lệ hoặc đã hết lượt dùng';
                              _isVoucherApplied = false;
                            });
                          }
                        }
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (_voucherMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _voucherMessage!,
                style: TextStyle(
                  color: _isVoucherApplied ? Colors.green : Colors.red,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
          const SizedBox(height: 12),
          _priceRow('Tạm tính', total),
          _priceRow('Giảm giá ($discount%)', discount),
          _priceRow('Giảm từ điểm KHTT', loyalty * 1000 as double),
          _priceRow('Giảm từ mã phiếu', _voucherDiscount),
          const Divider(),
          _priceRow('Thành tiền', finalAmount, bold: true),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
                'Xác nhận thanh toán', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${value.toStringAsFixed(0)} đ',
            style: bold
                ? const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.red)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameCtrl,
          decoration: _inputDecoration('Họ và tên', Icons.person),
          validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: _inputDecoration('Số điện thoại', Icons.phone),
          validator: (v) => v!.length < 9 ? 'Số điện thoại không hợp lệ' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressCtrl,
          decoration: _inputDecoration('Địa chỉ', Icons.location_on),
          maxLines: 2,
          validator: (v) => v!.isEmpty ? 'Nhập địa chỉ' : null,
        ),
      ],
    );
  }

  void _onConfirmPressed() {
    // 1) Validate form
    if (!_formKey.currentState!.validate()) {
      // nếu còn lỗi validate thì dừng, các TextFormField sẽ show message
      return;
    }

    // 2) Thu thập dữ liệu giao hàng
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final address = _addressCtrl.text.trim();

    // 3) Tạo payload đơn hàng
    final orderPayload = {
      'customerName': name,
      'phone': phone,
      'address': address,
      'items': widget.selectedItems
          .map((p) =>
      {
        'variantId': p.variant.id,
        'quantity': p.quantity,
      })
          .toList(),
      'voucherDiscount': _voucherDiscount,
      'loyaltyPointsUsed': loyalty,
      // ... thêm các trường cần thiết như totalPrice, finalAmount
    };
  }
}