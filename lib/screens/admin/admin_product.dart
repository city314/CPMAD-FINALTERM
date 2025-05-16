import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/variant.dart';
import '../../service/ProductService.dart';
import 'admin_product_detail.dart';
import 'package:cpmad_final/models/product.dart';
import 'package:cpmad_final/models/category.dart';
import 'package:cpmad_final/models/brand.dart';
import 'component/SectionHeader.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({Key? key}) : super(key: key);

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  final List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_allProducts);
    _loadProducts();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await ProductService.fetchAllProducts();
      setState(() {
        _allProducts.clear();
        _allProducts.addAll(products);
        _filteredProducts = List.from(products);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải sản phẩm: $e')));
    }
  }

  void _onSearch() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((p) => p.name.toLowerCase().contains(query)).toList();
    });
  }

  void _openDetail({Product? product}) async {
    final isNew = product == null;
    final p = product ?? Product(
      id: null,
      name: '',
      categoryId: '',
      categoryName: '',
      brandId: '',
      brandName: '',
      description: '',
      stock: 0,
      lowestPrice: 0,
      discountPercent: 0,
      images: [],
      timeAdd: DateTime.now(),
      variants: [],
    );

    final result = await context.push<Product>(
      '/admin/product-detail',
      extra: {
        'product': p,
        'isNew': isNew,
      },
    );

    if (result != null) {
      setState(() {
        if (isNew) {
          _allProducts.add(result);
        } else {
          final idx = _allProducts.indexWhere((e) => e.id == result.id);
          if (idx != -1) {
            _allProducts[idx] = result;
            _allProducts[idx].variantCount = result.variants.length; // Cập nhật lại count thủ công
          }
        }
        _onSearch();
      });
    }
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
              Text('Danh mục: ${p.categoryName}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 8),
              Text('Thương hiệu: ${p.brandName}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 8),
              Text('Giá: ₫${p.lowestPrice?.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 14, color: Colors.green)),
              const SizedBox(height: 8),
              Text('Kho: ${p.stock}', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 12),  // cách trước ButtonBar
              Text('Biến thể: ${p.variantCount}',
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
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Xác nhận xoá'),
                          content: Text('Bạn có chắc muốn xoá sản phẩm "${p.name}" không?'),
                          actions: [
                            TextButton(onPressed: () => context.pop(false), child: const Text('Huỷ')),
                            ElevatedButton(onPressed: () => context.pop(true), child: const Text('Xoá')),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await ProductService.deleteProduct(p.id!);
                          setState(() {
                            _allProducts.remove(p);
                            _onSearch();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã xoá sản phẩm.')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi xoá sản phẩm: $e')),
                          );
                        }
                      }
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
