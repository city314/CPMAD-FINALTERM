import 'package:flutter/material.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

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

  void _openProductForm({Product? product}) {
    final isEditing = product != null;
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final brandCtrl = TextEditingController(text: product?.brand ?? '');
    final priceCtrl = TextEditingController(text: product?.price.toString() ?? '');
    final discountCtrl = TextEditingController(text: product?.discount.toString() ?? '');
    final categoryCtrl = TextEditingController(text: product?.category ?? '');
    final descriptionCtrl = TextEditingController(text: product?.description ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'Sửa sản phẩm' : 'Thêm sản phẩm',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
                  TextField(controller: brandCtrl, decoration: const InputDecoration(labelText: 'Thương hiệu')),
                  TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Giá')),
                  TextField(controller: discountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Giảm giá (%)')),
                  TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Danh mục')),
                  TextField(controller: descriptionCtrl, decoration: const InputDecoration(labelText: 'Mô tả'), maxLines: 3),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Lưu'),
                    onPressed: () {
                      final newProduct = Product(
                        id: isEditing ? product!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameCtrl.text,
                        brand: brandCtrl.text,
                        price: double.tryParse(priceCtrl.text) ?? 0,
                        discount: double.tryParse(discountCtrl.text) ?? 0,
                        description: descriptionCtrl.text,
                        category: categoryCtrl.text,
                        images: ['placeholder.png'],
                        variants: product?.variants ?? [],
                        rating: 0,
                        reviews: [],
                        isPromotional: false,
                        isNew: false,
                        isBestSeller: false,
                        createdAt: DateTime.now(),
                      );

                      setState(() {
                        if (isEditing) {
                          final index = productList.indexWhere((p) => p.id == product!.id);
                          productList[index] = newProduct;
                        } else {
                          productList.add(newProduct);
                        }
                      });

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: productList.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final product = productList[index];
        final discountedPrice = product.price * (1 - product.discount / 100);

        return ListTile(
          leading: const Icon(Icons.devices_other, size: 36, color: Colors.indigo),
          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand: ${product.brand} • ${product.category}'),
              Text(
                'Variants: ${product.variants.map((v) => v.name).join(', ')}',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                product.discount > 0
                    ? '₫${discountedPrice.toStringAsFixed(0)} (Giảm ${product.discount.toInt()}%)'
                    : '₫${product.price.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              Row(
                children: [
                  if (product.isNew) _buildBadge('Mới', Colors.green),
                  if (product.isPromotional) _buildBadge('Khuyến mãi', Colors.orange),
                  if (product.isBestSeller) _buildBadge('Bán chạy', Colors.purple),
                ],
              )
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _openProductForm(product: product);
              } else if (value == 'delete') {
                setState(() {
                  productList.removeWhere((p) => p.id == product.id);
                });
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4, top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color)),
    );
  }

  Widget _buildWebTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                columnSpacing: 24,
                headingRowHeight: 50,
                dataRowHeight: 70,
                columns: const [
                  DataColumn(label: Text('Tên', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Thương hiệu')),
                  DataColumn(label: Text('Danh mục')),
                  DataColumn(label: Text('Biến thể')),
                  DataColumn(label: Text('Giá')),
                  DataColumn(label: Text('Gắn nhãn')),
                  DataColumn(label: Text('Thao tác')),
                ],
                rows: productList.map((product) {
                  final discountedPrice = product.price * (1 - product.discount / 100);
                  final tags = <Widget>[
                    if (product.isNew)
                      Chip(label: const Text('Mới'), backgroundColor: Colors.green[100]),
                    if (product.isPromotional)
                      Chip(label: const Text('KM'), backgroundColor: Colors.orange[100]),
                    if (product.isBestSeller)
                      Chip(label: const Text('Bán chạy'), backgroundColor: Colors.purple[100]),
                  ];

                  return DataRow(cells: [
                    DataCell(Text(product.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(product.brand)),
                    DataCell(Text(product.category)),
                    DataCell(Text(product.variants.map((v) => v.name).join(', '))),
                    DataCell(Text(
                      product.discount > 0
                          ? '₫${discountedPrice.toStringAsFixed(0)} (↓${product.discount.toInt()}%)'
                          : '₫${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: product.discount > 0 ? Colors.red : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    DataCell(Wrap(
                      spacing: 6,
                      children: tags,
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                          onPressed: () => _openProductForm(product: product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              productList.removeWhere((p) => p.id == product.id);
                            });
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Product Management'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/admin_avatar.png'),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openProductForm(); // Gọi modal thêm sản phẩm
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: isWeb ? _buildWebTable() : _buildMobileList(),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double discount;
  final String description;
  final String category;
  final List<String> images;
  final List<ProductVariant> variants;
  final double rating;
  final List<String> reviews;
  final bool isPromotional;
  final bool isNew;
  final bool isBestSeller;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.discount,
    required this.description,
    required this.category,
    required this.images,
    required this.variants,
    required this.rating,
    required this.reviews,
    required this.isPromotional,
    required this.isNew,
    required this.isBestSeller,
    required this.createdAt,
  });
}

class ProductVariant {
  final String id;
  final String name;
  final int stock;

  ProductVariant({
    required this.id,
    required this.name,
    required this.stock,
  });
}
