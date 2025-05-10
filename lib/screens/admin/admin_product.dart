import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class AdminProductManagementScreen extends StatefulWidget {
  const AdminProductManagementScreen({super.key});

  @override
  State<AdminProductManagementScreen> createState() => _AdminProductManagementScreenState();
}

class _AdminProductManagementScreenState extends State<AdminProductManagementScreen> {
  final List<Product> _products = [
    Product(
      name: 'Laptop ABC',
      price: 15000000,
      stock: 10,
      category: 'Laptop',
      discount: 20,
      imageUrl: 'assets/images/product/laptop.jpg',
    ),
    Product(
      name: 'Chuột XYZ',
      price: 500000,
      stock: 50,
      category: 'Phụ kiện',
      discount: 0,
      imageUrl: 'assets/images/product/laptop.jpg',
    ),
  ];

  void _showProductForm({Product? product, required bool isEditing}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final stockController = TextEditingController(text: product?.stock.toString() ?? '');
    final categoryController = TextEditingController(text: product?.category ?? '');
    final discountController = TextEditingController(text: product?.discount.toString() ?? '0');

    Uint8List? pickedImageBytes;
    File? pickedImageFile;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Sửa sản phẩm' : 'Thêm sản phẩm'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Giá (₫)'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Tồn kho'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Danh mục'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Khuyến mãi (%)'),
                      onChanged: (value) {
                        final intVal = int.tryParse(value) ?? 0;
                        if (intVal > 50) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('⚠️ Khuyến mãi tối đa là 50%'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(source: ImageSource.gallery);
                        if (picked != null) {
                          if (kIsWeb) {
                            final bytes = await picked.readAsBytes();
                            setState(() {
                              pickedImageBytes = bytes;
                              pickedImageFile = null; // clear for safety
                            });
                          } else {
                            setState(() {
                              pickedImageFile = File(picked.path);
                              pickedImageBytes = null; // clear for safety
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Chọn ảnh từ thư viện'),
                    ),
                    const SizedBox(height: 8),
                    pickedImageBytes != null
                        ? SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: Image.memory(
                        pickedImageBytes!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : pickedImageFile != null
                        ? SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: Image.file(
                        pickedImageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Text('Chưa chọn ảnh'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Huỷ'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final discount = (int.tryParse(discountController.text) ?? 0).clamp(0, 50);
                    final newProduct = Product(
                      name: nameController.text.trim(),
                      price: int.tryParse(priceController.text) ?? 0,
                      stock: int.tryParse(stockController.text) ?? 0,
                      category: categoryController.text.trim(),
                      discount: discount,
                      imageUrl: kIsWeb ? '' : pickedImageFile?.path ?? '',
                    );
                    setState(() {
                      if (isEditing && product != null) {
                        final index = _products.indexOf(product);
                        _products[index] = newProduct;
                      } else {
                        _products.add(newProduct);
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text('Bạn có chắc muốn xoá sản phẩm "${product.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() => _products.remove(product));
              Navigator.pop(context);
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        title: Row(
          children: [
            const Icon(Icons.inventory, size: 26),
            const SizedBox(width: 8),
            const Text('Quản lý sản phẩm', style: TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          Tooltip(
            message: 'Thêm sản phẩm mới',
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _showProductForm(isEditing: false),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];

              // Xử lý chọn imageProvider tương thích Web/Mobile
              final ImageProvider<Object> imageProvider = (() {
                if (kIsWeb && product.imageUrl.startsWith('http')) {
                  return NetworkImage(product.imageUrl) as ImageProvider<Object>;
                } else if (!kIsWeb && File(product.imageUrl).existsSync()) {
                  return FileImage(File(product.imageUrl)) as ImageProvider<Object>;
                } else {
                  return const AssetImage('assets/images/product/laptop.jpg') as ImageProvider<Object>;
                }
              })();

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWideScreen ? 600 : double.infinity),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            image: imageProvider,
                            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('₫${product.price} • ${product.category}'),
                                Text('Kho: ${product.stock}'),
                                if (product.discount > 0)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('-${product.discount}%', style: const TextStyle(color: Colors.white)),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showProductForm(product: product, isEditing: true),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteProduct(product),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Product {
  final String name;
  final int price;
  final int stock;
  final String category;
  final int discount;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.discount,
    required this.imageUrl,
  });
}
