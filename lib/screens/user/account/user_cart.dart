import 'package:flutter/material.dart';

// Models của bạn
import 'package:cpmad_final/models/cart.dart';     // Cart(id, productId, variantId, quantity…) :contentReference[oaicite:0]{index=0}:contentReference[oaicite:1]{index=1}
import 'package:cpmad_final/models/product.dart';  // Product với field variants :contentReference[oaicite:2]{index=2}:contentReference[oaicite:3]{index=3}
import 'package:cpmad_final/models/variant.dart';  // Variant (variantName, color, images…) :contentReference[oaicite:4]{index=4}:contentReference[oaicite:5]{index=5}
import 'package:cpmad_final/models/category.dart';
import 'package:cpmad_final/models/brand.dart';
import 'package:go_router/go_router.dart';

import '../CustomNavbar.dart';

// Dữ liệu mẫu
final List<Category> testCategories = [
  Category(id: 'laptop', name: 'Laptop'),
  Category(id: 'ssd',    name: 'SSD'),
];

final List<Brand> testBrands = [
  Brand(id: 'asus',    name: 'ASUS'),
  Brand(id: 'samsung', name: 'Samsung'),
];

final List<Product> testProducts = [
  Product(
    id: '1',
    name: 'Gaming Laptop ROG Strix',
    categoryId: 'laptop',
    brandId: 'asus',
    description: '',
    stock: 0,
    timeAdd: DateTime.now(),
    images: [],
    variants: [
      Variant(
        id: 'v001',
        productId: '1',
        variantName: '16GB RAM',
        color: 'Red',
        attributes: '{}',
        importPrice: 100,
        sellingPrice: 100,
        stock: 10,
        images: [],
      ),
      Variant(
        id: 'v002',
        productId: '1',
        variantName: '32GB RAM',
        color: 'Red',
        attributes: '{}',
        importPrice: 100,
        sellingPrice: 100,
        stock: 10,
        images: [],
      ),
    ],
  ),
  Product(
    id: '2',
    name: 'SSD Samsung 980 Pro 1TB',
    categoryId: 'ssd',
    brandId: 'samsung',
    description: '',
    stock: 0,
    timeAdd: DateTime.now(),
    images: [],
    variants: [
      Variant(
        id: 'v003',
        productId: '2',
        variantName: '1TB',
        color: 'Black',
        attributes: '{}',
        importPrice: 100,
        sellingPrice: 100,
        stock: 10,
        images: [],
      ),
    ],
  ),
];

final List<Cart> testCarts = [
  Cart(
    id: 'c1',
    userId: null,
    sessionId: 's1',
    productId: '1',
    variantId: 'v001',
    quantity: 1,
    timeAdd: DateTime.now(),
  ),
  Cart(
    id: 'c2',
    userId: null,
    sessionId: 's1',
    productId: '1',
    variantId: 'v002',
    quantity: 2,
    timeAdd: DateTime.now(),
  ),
  Cart(
    id: 'c3',
    userId: null,
    sessionId: 's1',
    productId: '2',
    variantId: 'v003',
    quantity: 1,
    timeAdd: DateTime.now(),
  ),
];

class UserCartPage extends StatefulWidget {
  const UserCartPage({Key? key}) : super(key: key);
  @override
  _UserCartPageState createState() => _UserCartPageState();
}

class _UserCartPageState extends State<UserCartPage> {
  final _selected = <String>{};
  final List<String> _allLaptops = List.generate(6, (index) => 'Laptop Model ${index + 1}');
  List<String> _filteredLaptops = [];
  bool isLoggedIn = true;
  String _searchKeyword = '';
  bool get _allSelected =>
      testCarts.isNotEmpty && _selected.length == testCarts.length;

  double get _totalPrice => _selected.fold(0.0, (sum, id) {
    final c = testCarts.firstWhere((c) => c.id == id);
    final p = testProducts.firstWhere((p) => p.id == c.productId);
    final v = p.variants.firstWhere((v) => v.id == c.variantId);
    return sum + v.sellingPrice * c.quantity;
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMobile = screenSize.width < 400;
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return Scaffold(
      // offWhite background
      backgroundColor: const Color(0xFFEEF9FE),
      appBar: CustomNavbar(
        cartItemCount: 0,
        onHomeTap: () {
          // TODO: Chuyển tới trang chủ
          context.go('/home');
        },
        onCategoriesTap: () {
          // TODO: Chuyển tới trang categories
        },
        onCartTap: () {
          // TODO: Chuyển tới trang giỏ hàng
        },
        onRegisterTap: () {
          // TODO: Chuyển tới trang đăng ký
        },
        onLoginTap: () {
          // TODO: Chuyển tới trang đăng nhập
          context.go('/');
        },
        onSupportTap: () {
          context.goNamed('admin_chat', extra: 'admin@gmail.com');
        },
        onProfileTap: isAndroid ? () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đi tới trang Profile')),
          );
        } : null,
        onLogoutTap: isAndroid ? () {
          setState(() {
            isLoggedIn = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã đăng xuất')),
          );
        } : null,
        onSearch: (value) {
          setState(() {
            _searchKeyword = value.toLowerCase();
            _filteredLaptops = _allLaptops
                .where((laptop) => laptop.toLowerCase().contains(_searchKeyword))
                .toList();
          });
        },
        isLoggedIn: isAndroid ? isLoggedIn : false,
      ),
      body: Column(
        children: [
          // —— Header: Select All + Delete ——
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  // primary fill
                  fillColor: WidgetStateProperty.all(Color(0xFF4C9FC3)),
                  checkColor: Colors.white,
                  value: _allSelected,
                  onChanged: (all) => setState(() {
                    if (all == true) {
                      _selected
                        ..clear()
                        ..addAll(testCarts.map((c) => c.id));
                    } else {
                      _selected.clear();
                    }
                  }),
                ),
                const Text('Select All',
                    style: TextStyle(color: Color(0xFF0B2433))),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: const Color(0xFF31444E), // darkVariant
                  onPressed: () => setState(() {
                    testCarts.removeWhere((c) => _selected.contains(c.id));
                    _selected.clear();
                  }),
                ),
              ],
            ),
          ),

          // —— List of items ——
          Expanded(
            child: ListView.separated(
              itemCount: testCarts.length,
              separatorBuilder: (_, __) =>
              const Divider(color: Color(0xFFA6BCC2), height: 1), // light
              itemBuilder: (_, i) => _buildCartItem(testCarts[i]),
            ),
          ),

          // —— Footer: Total + Buy ——
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Price',
                        style:
                        TextStyle(fontSize: 14, color: Color(0xFF31444E))),
                    Text('\$${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B2433))),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {/* TODO: thanh toán */},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF5BF1F5), // accent
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Buy',
                        style: TextStyle(
                            fontSize: 16, color: Color(0xFF0B2433))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Cart cart) {
    final prod = testProducts.firstWhere((p) => p.id == cart.productId);
    final varnt = prod.variants.firstWhere((v) => v.id == cart.variantId);
    final cat = testCategories
        .firstWhere((c) => c.id == prod.categoryId, orElse: () => Category(id: '', name: ''));
    final brd = testBrands
        .firstWhere((b) => b.id == prod.brandId,    orElse: () => Brand(id: '', name: ''));
    final imgUrl = varnt.images.isNotEmpty ? varnt.images.first : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Checkbox item
          Checkbox(
            fillColor: WidgetStateProperty.all(const Color(0xFF4C9FC3)),
            checkColor: Colors.white,
            value: _selected.contains(cart.id),
            onChanged: (sel) => setState(() {
              if (sel == true) _selected.add(cart.id);
              else _selected.remove(cart.id);
            }),
          ),

          // Image variant
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: imgUrl != null
                ? Image.network(imgUrl as String,
                width: 64, height: 64, fit: BoxFit.cover)
                : const SizedBox(
                width: 64,
                height: 64,
                child: Icon(Icons.image_not_supported,
                    color: Color(0xFF495662))), // medium
          ),
          const SizedBox(width: 12),

          // Info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat.name,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF31444E))), // darkVariant
                const SizedBox(height: 4),
                Text(prod.name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B2433))), // dark
                const SizedBox(height: 4),
                Text(varnt.variantName,
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF495662))), // medium
                const SizedBox(height: 4),
                Text('Color: ${varnt.color}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFFA6BCC2))), // light
              ],
            ),
          ),

          // Price
          Text('\$${varnt.sellingPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C9FC3))), // primary
          const SizedBox(width: 16),

          // Quantity controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                color: const Color(0xFF4C9FC3), // primary
                onPressed: () {
                  if (cart.quantity > 1) setState(() => cart.quantity--);
                },
              ),
              Text('${cart.quantity}',
                  style: const TextStyle(color: Color(0xFF0B2433))),
              IconButton(
                icon: const Icon(Icons.add),
                color: const Color(0xFF4C9FC3), // primary
                onPressed: () => setState(() => cart.quantity++),
              ),
            ],
          ),

          // Delete single item
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: const Color(0xFF31444E), // darkVariant
            onPressed: () => setState(() {
              _selected.remove(cart.id);
              testCarts.removeWhere((c) => c.id == cart.id);
            }),
          ),
        ],
      ),
    );
  }
}