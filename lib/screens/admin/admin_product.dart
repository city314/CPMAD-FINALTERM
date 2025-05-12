import 'package:flutter/material.dart';

class AdminProductScreen extends StatefulWidget {
  final VoidCallback onAddProduct;

  const AdminProductScreen({
    Key? key,
    required this.onAddProduct,
  }) : super(key: key);

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

  void _onEdit(Product product) => widget.onAddProduct();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Updated threshold: treat <800 px as mobile
        if (width < 800) {
          // Mobile: detailed cards without images
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: productList.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _productCard(productList[i]),
            ),
          );
        } else if (width < 1200) {
          // Tablet: grid of cards
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2,
              ),
              itemCount: productList.length,
              itemBuilder: (_, i) => _productCard(productList[i]),
            ),
          );
        } else {
          // Desktop: full table
          final ctrl = ScrollController();
          return Scrollbar(
            controller: ctrl,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: ctrl,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.resolveWith((_) => const Color(0xFFF2F4F7)),
                    dataRowColor: WidgetStateProperty.resolveWith((_) => Colors.white),
                    columnSpacing: 32,
                    headingRowHeight: 56,
                    dataRowMinHeight: 64,
                    dataRowMaxHeight: 72,
                    columns: const [
                      DataColumn(label: Text('Tên', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Thương hiệu')),
                      DataColumn(label: Text('Danh mục')),
                      DataColumn(label: Text('Biến thể')),
                      DataColumn(label: Text('Giá')),
                      DataColumn(label: Text('Gắn nhãn')),
                      DataColumn(label: Text('Rating')),
                      DataColumn(label: Text('Ngày tạo')),
                      DataColumn(label: Text('')),
                    ],
                    rows: productList.map((p) {
                      final discountedPrice = p.price * (1 - p.discount / 100);
                      final tags = <Widget>[];
                      if (p.isNew) tags.add(_buildChip(Icons.fiber_new, 'Mới', Colors.green[50]!));
                      if (p.isPromotional) tags.add(_buildChip(Icons.local_offer, 'Khuyến mãi', Colors.orange[50]!));
                      if (p.isBestSeller) tags.add(_buildChip(Icons.star, 'Bán chạy', Colors.purple[50]!));
                      return DataRow(cells: [
                        DataCell(Text(p.name)),
                        DataCell(Text(p.brand)),
                        DataCell(Text(p.category)),
                        DataCell(Text(p.variants.map((v) => v.name).join(', '))),
                        DataCell(Text(p.discount > 0
                            ? '₫${discountedPrice.toStringAsFixed(0)} (↓${p.discount.toInt()}%)'
                            : '₫${p.price.toStringAsFixed(0)}')),
                        DataCell(Wrap(spacing: 6, children: tags)),
                        DataCell(Text(p.rating.toString())),
                        DataCell(Text('${p.createdAt.day}/${p.createdAt.month}/${p.createdAt.year}')),
                        DataCell(Row(children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _onEdit(p)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => productList.remove(p))),
                        ])),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _productCard(Product p) {
    final displayPrice = p.discount > 0
        ? '₫${(p.price * (1 - p.discount / 100)).toStringAsFixed(0)} (↓${p.discount.toInt()}%)'
        : '₫${p.price.toStringAsFixed(0)}';
    final tags = <Widget>[];
    if (p.isNew) tags.add(_buildChip(Icons.fiber_new, 'Mới', Colors.green[50]!));
    if (p.isPromotional) tags.add(_buildChip(Icons.local_offer, 'Khuyến mãi', Colors.orange[50]!));
    if (p.isBestSeller) tags.add(_buildChip(Icons.star, 'Bán chạy', Colors.purple[50]!));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${p.brand} • ${p.category}', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Text(displayPrice, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.discount > 0 ? Colors.red : Colors.black87)),
            const SizedBox(height: 8),
            Wrap(spacing: 6, children: tags),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rating: ${p.rating}', style: const TextStyle(color: Colors.black54)),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _onEdit(p)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => productList.remove(p))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color bg) => Chip(avatar: Icon(icon, size: 16), label: Text(label, style: const TextStyle(fontSize: 12)), backgroundColor: bg);
}

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double discount;
  final String category;
  final List<ProductVariant> variants;
  final double rating;
  final bool isPromotional;
  final bool isNew;
  final bool isBestSeller;
  final DateTime createdAt;
  final List<String> reviews;
  final List<String> images;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.discount,
    required this.category,
    required this.variants,
    required this.rating,
    required this.isPromotional,
    required this.isNew,
    required this.isBestSeller,
    required this.createdAt,
    required this.reviews,
    required this.images,
    required this.description,
  });
}

class ProductVariant {
  final String id;
  final String name;
  final int stock;

  ProductVariant({required this.id, required this.name, required this.stock});
}
