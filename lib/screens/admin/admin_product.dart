import 'package:flutter/material.dart';
import 'admin_product_detail.dart';  // import the detail page

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({Key? key}) : super(key: key);

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  final List<Product> productList = [
    Product(
      id: 'p001',
      name: 'Gaming Laptop ROG Strix',
      brand: 'ASUS',
      price: 30000000,
      discount: 10,
      description:
      'Laptop gaming hiệu năng cao, chip Intel Gen 13, card RTX 4060, phù hợp cho cả học tập và giải trí.',
      category: 'Laptop',
      images: ['laptop1.png', 'laptop2.png', 'laptop3.png'],
      variants: [
        ProductVariant(id: 'v001', name: '16GB RAM', stock: 10),
        ProductVariant(id: 'v002', name: '32GB RAM', stock: 5),
      ],
      rating: 4.8,
      reviews: ['Sản phẩm rất tốt', 'Hiệu năng ổn định'],
      isPromotional: true,
      isNew: true,
      isBestSeller: true,
      createdAt: DateTime.now(),
    ),
    Product(
      id: 'p002',
      name: 'SSD Samsung 980 Pro',
      brand: 'Samsung',
      price: 4500000,
      discount: 0,
      description:
      'SSD tốc độ cao chuẩn PCIe Gen4, dung lượng 1TB, phù hợp cho nhu cầu chơi game và làm việc chuyên sâu.',
      category: 'SSD',
      images: ['ssd1.png', 'ssd2.png', 'ssd3.png'],
      variants: [
        ProductVariant(id: 'v003', name: '500GB', stock: 12),
        ProductVariant(id: 'v004', name: '1TB', stock: 20),
      ],
      rating: 4.5,
      reviews: ['Tốc độ cực nhanh', 'Đáng tiền'],
      isPromotional: false,
      isNew: false,
      isBestSeller: true,
      createdAt: DateTime.now(),
    ),
  ];

  void _openDetail({Product? product}) {
    final isNew = product == null;
    final p = product ??
        Product(
          id: '',
          name: '',
          brand: '',
          price: 0,
          discount: 0,
          category: '',
          variants: [],
          rating: 0,
          reviews: [],
          images: [],
          description: '',
          isNew: false,
          isPromotional: false,
          isBestSeller: false,
          createdAt: DateTime.now(),
        );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminProductDetail(
          product: p,
          onEdit: (updated) {
            setState(() {
              if (isNew) {
                // generate a real id, then:
                productList.add(updated);
              } else {
                final idx = productList.indexWhere((e) => e.id == updated.id);
                productList[idx] = updated;
              }
            });
          },
          onDelete: () {
            if (!isNew) {
              setState(() => productList.removeWhere((e) => e.id == p.id));
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Add Product button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _openDetail(),
              icon: const Icon(Icons.add),
              label: const Text('Thêm sản phẩm'),
            ),
          ),
          const SizedBox(height: 16),
          // Responsive content
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                if (width < 800) {
                  return ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _productCard(productList[i]),
                    ),
                  );
                } else if (width < 1200) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (_, i) => _productCard(productList[i]),
                  );
                } else {
                  final ctrl = ScrollController();
                  return Scrollbar(
                    controller: ctrl,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: ctrl,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.resolveWith((_) => const Color(0xFFF2F4F7)),
                          dataRowColor: WidgetStateProperty.resolveWith((_) => Colors.white),
                          columnSpacing: 32,
                          columns: const [
                            DataColumn(label: Text('Tên', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Thương hiệu')),
                            DataColumn(label: Text('Danh mục')),
                            DataColumn(label: Text('Giá')),
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: productList.map((p) {
                            return DataRow(cells: [
                              DataCell(Text(p.name)),
                              DataCell(Text(p.brand)),
                              DataCell(Text(p.category)),
                              DataCell(Text(p.discount > 0
                                  ? '₫${(p.price * (1 - p.discount/100)).toStringAsFixed(0)}'
                                  : '₫${p.price.toStringAsFixed(0)}')),
                              DataCell(Row(children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _openDetail(product: p),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => setState(() => productList.remove(p)),
                                ),
                              ])),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(Product p) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${p.brand} • ${p.category}', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Text(
              p.discount > 0
                  ? '₫${(p.price * (1 - p.discount / 100)).toStringAsFixed(0)} (↓${p.discount.toInt()}%)'
                  : '₫${p.price.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: p.discount > 0 ? Colors.red : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.visibility, color: Colors.grey),
                tooltip: 'Chi tiết',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminProductDetail(
                        product: p,
                        onEdit: (updated) => _openDetail(product: updated),
                        onDelete: () {
                          setState(() => productList.remove(p));
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Product and ProductVariant definitions
class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double discount;
  final String category;
  final List<String> images;
  final List<ProductVariant> variants;
  final double rating;
  final List<String> reviews;
  final String description;
  final bool isNew;
  final bool isPromotional;
  final bool isBestSeller;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.discount,
    required this.category,
    required this.images,
    required this.variants,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.isNew,
    required this.isPromotional,
    required this.isBestSeller,
    required this.createdAt,
  });

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    double? discount,
    String? category,
    String? description,
    List<String>? images,
    List<ProductVariant>? variants,
    DateTime? createdAt,
    double? rating,
    List<String>? reviews,
    bool? isNew,
    bool? isPromotional,
    bool? isBestSeller,
  }) {
    return Product(
      id:          id        ?? this.id,
      name:        name      ?? this.name,
      brand:       brand     ?? this.brand,
      price:       price     ?? this.price,
      discount:    discount  ?? this.discount,
      category:    category  ?? this.category,
      description: description ?? this.description,
      images:      images    ?? this.images,
      variants:    variants  ?? this.variants,
      createdAt:   createdAt ?? this.createdAt,
      rating: 0,
      reviews: [],
      isNew: false,
      isPromotional: false,
      isBestSeller: false,
    );
  }
}

class ProductVariant {
  final String id;
  final String name;
  final int stock;

  ProductVariant({required this.id, required this.name, required this.stock});
}
