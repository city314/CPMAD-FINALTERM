import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/coupon.dart';
import '../../models/product.dart';
import '../../models/variant.dart';
import 'CustomNavbar.dart';

class CheckoutPage extends StatefulWidget {
  // final Product product;
  // final Variant variant;
  final int quantity=1;
  // final Coupon? coupon;
  //
  // const CheckoutPage({
  //   Key? key,
  //   required this.product,
  //   required this.variant,
  //   this.quantity = 1,
  //   this.coupon,
  // }) : super(key: key);
  // 1. Tạo Product
  final product = Product(
    id: 'p1',
    name: 'Laptop Gaming ROG Strix',
    categoryId: 'laptop',
    brandId: 'asus',
    description: 'Laptop gaming hiệu năng cao với Intel i7, RAM 16GB, SSD 512GB.',
    stock: 10,
    images: [
      {'url': 'https://example.com/images/rog_strix.png'},
    ],
    timeAdd: DateTime.now(),
    variants: [], // không bắt buộc
  );

  // 2. Tạo Variant ứng với sản phẩm trên
  final variant = Variant(
    id: 'v1',
    productId: 'p1',
    variantName: 'RAM 16GB',
    attributes: '{"ram":"16GB","color":"black"}',
    importPrice: 25000000.0,
    sellingPrice: 27000000.0,
    stock: 5,
    images: [],
  );

  // 3. Tạo Coupon (nếu cần test phần giảm giá)
  final coupon = Coupon(
    id: 'c1',
    code: 'NEWYEAR2025',
    discountAmount: 1000000,  // giảm 1.000.000₫
    usageMax: 100,
    usageTimes: 0,
    timeCreate: DateTime.now().subtract(const Duration(days: 1)),
  );
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  double get _subtotal => widget.variant.importPrice * widget.quantity;
  double get _discount => widget.coupon.discountAmount.toDouble();
  double get _shippingFee => 30000.0;
  double get _total => _subtotal - _discount + _shippingFee;

  InputDecoration _inputDecoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.grey.shade100,
    prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  List<Step> get _steps => [
    Step(
      title: const Text('Ship'),
      content: _buildShippingForm(),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
    ),
    Step(
      title: const Text('Pay'),
      content: _buildPaymentForm(),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
    ),
    Step(
      title: const Text('Done'),
      content: _buildConfirmation(),
      isActive: _currentStep >= 2,
      state: _currentStep == 2 ? StepState.editing : StepState.indexed,
    ),
  ];

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

  Widget _buildPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _cardNumberCtrl,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration('Số thẻ', Icons.credit_card),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryCtrl,
                decoration: _inputDecoration('MM/YY', Icons.date_range),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('CVV', Icons.lock),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.local_offer),
          label: const Text('Áp dụng mã giảm giá'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            // TODO validate coupon
          },
        ),
      ],
    );
  }

  Widget _buildConfirmation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _row('Sản phẩm', '${widget.product.name} x${widget.quantity}'),
                _row('Variant', widget.variant.variantName),
                const Divider(),
                _row('Tạm tính', '₫${_subtotal.toStringAsFixed(0)}'),
                _row('Giảm giá', '₫${_discount.toStringAsFixed(0)}'),
                _row('Phí vận chuyển', '₫${_shippingFee.toStringAsFixed(0)}'),
                const Divider(),
                _row('Tổng cộng', '₫${_total.toStringAsFixed(0)}', bold: true),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                context.go('/order-success');
              },
              child: const Text('Xác nhận đặt hàng', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 1200;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomNavbar(
            onHomeTap: () => context.go('/home'),
            onCartTap: () => context.go('/cart'),
            onProfileTap: () => context.go('/profile'),
            onCategoriesTap: () {  },
            onRegisterTap: () {  },
            onLoginTap: () {  },
            onSearch: (String value) {  },
            onSupportTap: () {  },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isWide
            ? Row(
          children: [
            Expanded(
              flex: 2,
              child: Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                steps: _steps,
                onStepContinue: () {
                  setState(() => _currentStep = (_currentStep + 1).clamp(0, _steps.length - 1));
                },
                onStepCancel: () {
                  setState(() => _currentStep = (_currentStep - 1).clamp(0, _steps.length - 1));
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Quay lại'),
                          ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(_currentStep == _steps.length - 1 ? 'Hoàn tất' : 'Tiếp theo'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 24),
            Expanded(flex: 1, child: _buildConfirmation()),
          ],
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                steps: _steps,
                onStepContinue: () {
                  setState(() => _currentStep = (_currentStep + 1).clamp(0, _steps.length - 1));
                },
                onStepCancel: () {
                  setState(() => _currentStep = (_currentStep - 1).clamp(0, _steps.length - 1));
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Quay lại'),
                          ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(_currentStep == _steps.length - 1 ? 'Hoàn tất' : 'Tiếp theo'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _buildConfirmation(),
            ],
          ),
        ),
      ),
    );
  }
}
