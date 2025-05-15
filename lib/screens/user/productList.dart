import 'package:flutter/material.dart';

import 'CustomNavbar.dart';

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
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;

    return Scaffold(
      appBar: CustomNavbar(
        cartItemCount: 0,
        onHomeTap: () {},
        onCategoriesTap: () {},
        onCartTap: () {},
        onRegisterTap: () {},
        onLoginTap: () {},
        onSupportTap: () {},
        onSearch: (value) {},
      ),
      body: isAndroid
          ? Column(
              children: [
                // Search bar dưới navbar cho Android
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    onChanged: (value) {
                      // TODO: Xử lý search sản phẩm
                    },
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      suffixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => _buildFilterSheet(),
                          );
                        },
                        icon: const Icon(Icons.filter_list),
                        label: const Text('Bộ lọc'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton<String>(
                          value: sortType,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'Mới nhất', child: Text('Mới nhất')),
                            DropdownMenuItem(value: 'Giá tăng dần', child: Text('Giá tăng dần')),
                            DropdownMenuItem(value: 'Giá giảm dần', child: Text('Giá giảm dần')),
                            DropdownMenuItem(value: 'Sắp xếp theo tên từ A-Z', child: Text('Sắp xếp theo tên từ A-Z')),
                            DropdownMenuItem(value: 'Sắp xếp theo tên từ Z-A', child: Text('Sắp xếp theo tên từ Z-A')),
                          ],
                          onChanged: (v) {
                            setState(() {
                              sortType = v!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
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
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar cũ
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
                // Main content cũ
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
                                DropdownMenuItem(value: 'Sắp xếp theo tên từ A-Z', child: Text('Sắp xếp theo tên từ A-Z')),
                                DropdownMenuItem(value: 'Sắp xếp theo tên từ Z-A', child: Text('Sắp xếp theo tên từ Z-A')),
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
    // Danh sách ảnh mẫu cho mỗi sản phẩm
    final List<String> images = [
      'assets/images/product/laptop/acer/acer1.png',
      'assets/images/product/laptop/acer/acer2.png',
      'assets/images/product/laptop/acer/acer3.png',
    ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, imgIndex) {
                  return Image.asset(
                    images[imgIndex],
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Laptop #$index',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text('₫999', style: TextStyle(color: Colors.blueAccent)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSheet() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                Navigator.pop(context);
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
    );
  }
}
