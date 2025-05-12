import 'package:flutter/material.dart';
import 'home.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scrollController = ScrollController();
  List<int> _products = List.generate(20, (index) => index);
  bool _isLoading = false;

  // Dữ liệu mẫu cho filter
  final List<String> categories = [
    'Laptop',
    'PC',
    'Bàn phím',
    'Tai Nghe',
    'Đĩa game',
  ];
  final List<String> brands = [
    'Apple', 'Samsung', 'Sony', 'Xiaomi', 'Oppo'
  ];
  final List<String> priceRanges = [
    'Dưới 5 triệu', '5-10 triệu', '10-20 triệu', 'Trên 20 triệu'
  ];
  List<String> selectedCategories = [];
  List<String> selectedBrands = [];
  String? selectedPrice;
  String sortType = 'Mới nhất';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreIfNeeded);
  }

  void _loadMoreIfNeeded() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoading) {
      _loadMoreProducts();
    }
  }

  void _loadMoreProducts() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      final nextItems = List.generate(20, (index) => _products.length + index);
      _products.addAll(nextItems);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavbar(
        cartItemCount: 0,
        onHomeTap: () {},
        onCategoriesTap: () {},
        onCartTap: () {},
        onRegisterTap: () {},
        onLoginTap: () {},
        onSearch: (value) {},
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar
          Container(
            width: 270,
            color: Colors.grey[50],
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: ListView(
              children: [
                const Text('Tất Cả Danh Mục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                for (final c in categories)
                  ListTile(
                    title: Text(c),
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 8),
                    onTap: () {},
                  ),
                const Divider(height: 32),
                const Text('BỘ LỌC TÌM KIẾM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                const Text('Theo Danh Mục', style: TextStyle(fontWeight: FontWeight.w500)),
                ...categories.map((cat) => CheckboxListTile(
                  value: selectedCategories.contains(cat),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        selectedCategories.add(cat);
                      } else {
                        selectedCategories.remove(cat);
                      }
                    });
                  },
                  title: Text(cat),
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                )),
                const SizedBox(height: 8),
                const Text('Thương hiệu', style: TextStyle(fontWeight: FontWeight.w500)),
                ...brands.map((brand) => CheckboxListTile(
                  value: selectedBrands.contains(brand),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        selectedBrands.add(brand);
                      } else {
                        selectedBrands.remove(brand);
                      }
                    });
                  },
                  title: Text(brand),
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                )),
                const SizedBox(height: 8),
                const Text('Giá sản phẩm', style: TextStyle(fontWeight: FontWeight.w500)),
                ...priceRanges.map((price) => RadioListTile<String>(
                  value: price,
                  groupValue: selectedPrice,
                  onChanged: (v) {
                    setState(() {
                      selectedPrice = v;
                    });
                  },
                  title: Text(price),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                )),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Áp dụng filter
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text('Áp dụng', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Filter bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Text('Sắp xếp:', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: sortType,
                        items: const [
                          DropdownMenuItem(value: 'Mới nhất', child: Text('Mới nhất')),
                          DropdownMenuItem(value: 'Giá tăng dần', child: Text('Giá tăng dần')),
                          DropdownMenuItem(value: 'Giá giảm dần', child: Text('Giá giảm dần')),
                        ],
                        onChanged: (v) {
                          setState(() {
                            sortType = v!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(_products[index]);
                    },
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(int index) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                'assets/laptop.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  'Laptop #$index',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('999', style: TextStyle(color: Colors.blueAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
