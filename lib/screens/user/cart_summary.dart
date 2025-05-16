import 'package:flutter/material.dart';
import 'package:cpmad_final/models/cart.dart';
import 'package:cpmad_final/models/product.dart';
import 'package:cpmad_final/models/coupon.dart';

class CartSummaryPage extends StatefulWidget {
  final List<Cart> cartItems;
  final List<Product> products;
  final List<Coupon> vouchers;
  final double coinBalance;

  const CartSummaryPage({
    Key? key,
    required this.cartItems,
    required this.products,
    this.vouchers = const [],
    this.coinBalance = 0,
  }) : super(key: key);

  @override
  _CartSummaryPageState createState() => _CartSummaryPageState();
}

class _CartSummaryPageState extends State<CartSummaryPage> {
  late Map<String, bool> _selected;
  bool _useCoins = false;

  @override
  void initState() {
    super.initState();
    _selected = {for (var c in widget.cartItems) c.id: true};
  }

  @override
  Widget build(BuildContext context) {
    // Nhóm cart theo tên thương hiệu
    final grouped = <String, List<Cart>>{};
    for (var cart in widget.cartItems) {
      final product = widget.products.firstWhere((p) => p.id == cart.productId);
      final brandKey = (product.brandName != null && product.brandName!.isNotEmpty)
          ? product.brandName!
          : product.brandId;
      grouped.putIfAbsent(brandKey, () => []).add(cart);
    }

    // Tính toán tổng giá và giảm giá sản phẩm
    double totalPrice = 0;
    double totalProdDiscount = 0;
    grouped.forEach((brand, carts) {
      for (var cart in carts) {
        if (!_selected[cart.id]!) continue;
        final product = widget.products.firstWhere((p) => p.id == cart.productId);
        final variant = product.variants.firstWhere((v) => v.id == cart.variantId);
        final price = variant.sellingPrice;
        final discount = product.discountPercent ?? 0;
        totalPrice += price * cart.quantity;
        totalProdDiscount += price * (discount / 100) * cart.quantity;
      }
    });

    // Voucher và Shopee Koin
    final totalVoucher = widget.vouchers.fold<double>(0,
            (sum, v) => sum + v.discountAmount.toDouble());
    // Khởi tạo luôn là double
    final double coinDiscount = _useCoins
        ? widget.coinBalance    // đã là double
        : 0.0;                  // dùng 0.0 thay vì 0
    final finalAmount = totalPrice - totalProdDiscount - totalVoucher - coinDiscount;

    return Scaffold(
      appBar: AppBar(title: Text('Thanh toán')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return isWide
              ? Row(
            children: [
              Expanded(flex: 2, child: _buildCartList(grouped)),
              VerticalDivider(width: 1),
              Expanded(
                flex: 1,
                child: _buildSummary(
                    totalPrice,
                    totalProdDiscount,
                    totalVoucher,
                    coinDiscount,
                    finalAmount),
              ),
            ],
          )
              : Column(
            children: [
              Expanded(child: _buildCartList(grouped)),
              Divider(height: 1),
              SizedBox(
                height: 300,
                child: _buildSummary(
                    totalPrice,
                    totalProdDiscount,
                    totalVoucher,
                    coinDiscount,
                    finalAmount),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartList(Map<String, List<Cart>> groups) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: groups.entries.map((e) {
        final brand = e.key;
        final items = e.value;
        final allSel = items.every((c) => _selected[c.id]!);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: allSel,
                  onChanged: (v) => setState(() {
                    for (var c in items) _selected[c.id] = v!;
                  }),
                ),
                Text(brand,
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            ...items.map(_buildCartItem).toList(),
            SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCartItem(Cart cart) {
    final sel = _selected[cart.id]!;
    final product = widget.products.firstWhere((p) => p.id == cart.productId);
    final variant = product.variants
        .firstWhere((v) => v.id == cart.variantId);
    final price = variant.sellingPrice;
    final discount = product.discountPercent ?? 0;
    final original = discount > 0
        ? (price / (1 - discount / 100)).round()
        : price.round();

    final imageUrl = variant.images.isNotEmpty
        ? variant.images.first['url'] ?? ''
        : (product.images.isNotEmpty
        ? product.images.first['url'] ?? ''
        : '');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(value: sel, onChanged: (v) => setState(() => _selected[cart.id] = v!)),
          Image.network(imageUrl,
              width: 60, height: 60, fit: BoxFit.cover),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                if (discount > 0)
                  Row(
                    children: [
                      Text('Rp \$original',
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                              color: Colors.grey)),
                      SizedBox(width: 4),
                      Text('-\$discount%',
                          style:
                          TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                Text('Rp ${price.toStringAsFixed(0)}',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          SizedBox(width: 8),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => setState(() {
                    if (cart.quantity > 1) cart.quantity--;
                  })),
              Text('${cart.quantity}'),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() => cart.quantity++)),
            ],
          ),
          SizedBox(width: 8),
          Column(
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
              IconButton(icon: Icon(Icons.delete), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(double totalPrice, double prodDiscount,
      double voucher, double coinDiscount, double finalAmount) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Icon(Icons.local_shipping, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child:
              Text('Bạn có thể nhận voucher miễn phí vận chuyển')),
              Icon(Icons.info_outline, size: 16),
            ]),
          ),
          SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Voucher & Promo'),
            subtitle: Text('Bạn có ${widget.vouchers.length} voucher'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.monetization_on, color: Colors.orange),
            title:
            Text('Shopee Koin (Số dư: ${widget.coinBalance.toStringAsFixed(0)})'),
            trailing: Switch(
                value: _useCoins,
                onChanged: (v) => setState(() => _useCoins = v)),
          ),
          Divider(),
          Text('Chi tiết đơn hàng',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _priceRow('Tạm tính', totalPrice),
          _priceRow('Giảm SP', prodDiscount),
          _priceRow('Giảm Voucher', voucher),
          _priceRow('Giảm Koin', coinDiscount),
          Divider(),
          _priceRow('Thành tiền', finalAmount, bold: true),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text('Thanh toán'),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16)),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('${value.toStringAsFixed(0)}',
              style: bold ? TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
