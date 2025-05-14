import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/variant.dart';
import 'admin_product_detail.dart';
import 'package:cpmad_final/models/product.dart';
import 'package:cpmad_final/models/category.dart';
import 'package:cpmad_final/models/brand.dart';
import 'component/SectionHeader.dart';

// TODO: Replace with real data sources
final List<Category> categories = [
  Category(id: 'laptop', name: 'Laptop'),
  Category(id: 'ssd', name: 'SSD'),
];
final List<Brand> brands = [
  Brand(id: 'asus', name: 'ASUS'),
  Brand(id: 'samsung', name: 'Samsung'),
];

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({Key? key}) : super(key: key);

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Gaming Laptop ROG Strix',
      categoryId: 'laptop',
      brandId: 'asus',
      price: 30000000,
      description: 'Laptop gaming hiệu năng cao.',
      stock: 12,
      imgUrl: 'assets/images/product/laptop/acer/acer1.png',
      timeAdd: DateTime.now().subtract(const Duration(days: 3)),
      variants: [
        Variant(
          id: 'v001',
          productId: '1',
          variantName: '16GB RAM',
          attributes: jsonEncode({'color': 'red', 'size': 'M'}),
          price: 30000000,
          stock: 10,
        ),
        Variant(
          id: 'v002',
          productId: '1',
          variantName: '32GB RAM',
          attributes: jsonEncode({'color': 'red', 'size': 'M'}),
          price: 35000000,
          stock: 5,
        ),
      ],
    ),
    // 2) SSD chỉ có 1 variant
    Product(
      id: '2',
      name: 'SSD Samsung 980 Pro 1TB',
      categoryId: 'ssd',
      brandId: 'samsung',
      price: 4500000,
      description: 'Ổ cứng SSD PCIe Gen4 1TB.',
      stock: 20,
      imgUrl: 'assets/images/product/laptop/acer/acer1.png',
      timeAdd: DateTime.now().subtract(const Duration(days: 10)),
      variants: [
        Variant(
          id: 'v003',
          productId: '2',
          variantName: '1TB',
          attributes: jsonEncode({'color': 'red', 'size': 'M'}),
          price: 4500000,
          stock: 20,
        ),
      ],
    ),
  ];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_allProducts);
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((p) => p.name.toLowerCase().contains(query)).toList();
    });
  }

  void _openDetail({Product? product}) {
    final isNew = product == null;
    final p = product ?? Product(
      id: null,
      name: '',
      categoryId: categories.first.id!,
      brandId: brands.first.id!,
      price: 0,
      description: '',
      stock: 0,
      imgUrl: '',
      timeAdd: DateTime.now(),
      variants:  [],
    );
    Future.microtask(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdminProductDetail(
            product: p,
            isNew: isNew,
            onEdit: (updated) {
              setState(() {
                if (isNew) {
                  _allProducts.add(updated);
                } else {
                  final idx = _allProducts.indexWhere((e) => e.id == updated.id);
                  if (idx != -1) _allProducts[idx] = updated;
                }
                _onSearch();
              });
            },
            onDelete: () {
              if (!isNew) {
                setState(() {
                  _allProducts.removeWhere((e) => e.id == p.id);
                  _onSearch();
                });
              }
              Navigator.pop(context);
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader('Quản lý sản phẩm'), // thêm SectionHeader :contentReference[oaicite:2]{index=2}:contentReference[oaicite:3]{index=3}
            const SizedBox(height: 16),

            // Search bar
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),

            // Product grid
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  int crossCount =
                  (totalWidth / 250).floor().clamp(1, 6);
                  final itemWidth =
                      (totalWidth - (crossCount - 1) * 16) /
                          crossCount;

                  return SingleChildScrollView(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: _filteredProducts.map((p) {
                        return SizedBox(
                          width: itemWidth,
                          child: _buildProductCard(p),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDetail(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Trong class _AdminProductScreenState:
  Widget _buildProductCard(Product p) {
    // Lấy tên category/brand từ list đã khai báo
    final catName   = categories.firstWhere((c) => c.id == p.categoryId).name;
    final brandName = brands.firstWhere((b) => b.id == p.brandId).name;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openDetail(product: p),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,            // cao vừa đủ nội dung
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Danh mục: $catName',
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 8),
              Text('Thương hiệu: $brandName',
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 8),
              Text('₫${p.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 14, color: Colors.green)),
              const SizedBox(height: 8),
              Text('Kho: ${p.stock}', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 12),  // cách trước ButtonBar
              Text('Biến thể: ${p.variants.length}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 12),
              OverflowBar(
                alignment: MainAxisAlignment.end,
                spacing: 0,         // khoảng cách giữa các button
                overflowSpacing: 0, // khi overflow thì khoảng cách
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _openDetail(product: p),
                    tooltip: 'Chỉnh sửa',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _allProducts.remove(p);
                        _onSearch();
                      });
                    },
                    tooltip: 'Xóa',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
