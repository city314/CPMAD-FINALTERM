import 'package:cpmad_final/pattern/current_user.dart';
import 'package:flutter/material.dart';

// Models của bạn
import 'package:cpmad_final/models/cart.dart';     // Cart(id, productId, variantId, quantity…) :contentReference[oaicite:0]{index=0}:contentReference[oaicite:1]{index=1}
import 'package:cpmad_final/models/product.dart';  // Product với field variants :contentReference[oaicite:2]{index=2}:contentReference[oaicite:3]{index=3}
import 'package:cpmad_final/models/variant.dart';  // Variant (variantName, color, images…) :contentReference[oaicite:4]{index=4}:contentReference[oaicite:5]{index=5}
import 'package:cpmad_final/models/category.dart';
import 'package:cpmad_final/models/brand.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service/CartService.dart';
import '../../../service/ProductService.dart';
import '../CustomNavbar.dart';

class UserCartPage extends StatefulWidget {
  const UserCartPage({Key? key}) : super(key: key);
  @override
  _UserCartPageState createState() => _UserCartPageState();
}

class _UserCartPageState extends State<UserCartPage> {
  final Set<String> _selected = {};
  Cart? _cart;
  List<Product> _allProducts = [];
  List<Category> _categories = [];
  List<Brand> _brands = [];
  bool isLoading = true;
  bool isLoggedIn = CurrentUser().isLogin;
  String _searchKeyword = '';
  bool get _allSelected =>
      _cart != null && _selected.length == _cart!.items.length;

  double get _totalPrice {
    double sum = 0;
    if (_cart == null) return 0;
    for (var item in _cart!.items) {
      if (_selected.contains(item.variantId)) {
        final product = _allProducts.firstWhere(
                (p) => p.variants.any((v) => v.id == item.variantId),
            orElse: () => Product.empty());
        final variant = product.variants
            .firstWhere((v) => v.id == item.variantId, orElse: () => Variant.empty());
        sum += variant.sellingPrice * item.quantity;
      }
    }
    return sum;
  }

  List<Cart> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartId = prefs.getString('cartId');
    final id = CurrentUser().isLogin ? CurrentUser().email : cartId;
    final cart = await CartService.fetchCart('guest-123');
    final products = await ProductService.fetchAllProducts();
    final categories = await ProductService.fetchAllCategory();
    final brands = await ProductService.fetchAllBrand();

    setState(() {
      _cart = cart;
      _allProducts = products;
      _categories = categories;
      _brands = brands;
      isLoading = false;
    });
  }

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
          context.go('/account/cart');
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
          });
        },
        isLoggedIn: isAndroid ? isLoggedIn : false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildCartList()),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Checkbox(
          value: _allSelected,
          onChanged: (value) => setState(() {
            if (value == true) {
              _selected.clear();
              _selected.addAll(_cart!.items.map((e) => e.variantId));
            } else {
              _selected.clear();
            }
          }),
        ),
        const Text('Select All'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => setState(() {
            _cart!.items.removeWhere((e) => _selected.contains(e.variantId));
            _selected.clear();
          }),
        ),
      ],
    ),
  );

  Widget _buildCartList() => ListView.separated(
    itemCount: _cart!.items.length,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: (_, index) => _buildCartItem(_cart!.items[index]),
  );

  Widget _buildCartItem(CartItem item) {
    final product = _allProducts.firstWhere(
            (p) => p.variants.any((v) => v.id == item.variantId),
        orElse: () => Product.empty());
    final variant = product.variants.firstWhere(
            (v) => v.id == item.variantId,
        orElse: () => Variant.empty());
    final category = _categories.firstWhere((c) => c.id == product.categoryId,
        orElse: () => Category(id: '', name: ''));
    final brand = _brands.firstWhere((b) => b.id == product.brandId,
        orElse: () => Brand(id: '', name: ''));

    return ListTile(
      leading: Checkbox(
        value: _selected.contains(item.variantId),
        onChanged: (sel) => setState(() {
          if (sel == true) {
            _selected.add(item.variantId);
          } else {
            _selected.remove(item.variantId);
          }
        }),
      ),
      title: Text(product.name),
      subtitle: Text('${variant.variantName} | ${variant.color}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => setState(() {
              if (item.quantity > 1) item.quantity--;
            }),
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => item.quantity++),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() => Container(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total'),
            Text('\$${_totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Buy Now'),
        ),
      ],
    ),
  );
}