import 'package:flutter/material.dart';

// Make sure to import your Product model
import 'admin_product.dart';

class AdminProductDetail extends StatelessWidget {
  final Product product;
  // Accept an updated Product in callback
  final ValueChanged<Product> onEdit;
  final VoidCallback onDelete;

  const AdminProductDetail({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controllers initialized with existing values
    final nameController = TextEditingController(text: product.name);
    final brandController = TextEditingController(text: product.brand);
    final priceController = TextEditingController(text: product.price.toString());
    final discountController = TextEditingController(text: product.discount.toString());
    final categoryController = TextEditingController(text: product.category);
    final descriptionController = TextEditingController(text: product.description);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name.isEmpty ? 'Thêm sản phẩm' : 'Chỉnh sửa sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Lưu',
            onPressed: () {
              // Build updated product
              final updated = Product(
                id: product.id,
                name: nameController.text.trim(),
                brand: brandController.text.trim(),
                price: double.tryParse(priceController.text) ?? 0.0,
                discount: double.tryParse(discountController.text) ?? 0.0,
                category: categoryController.text.trim(),
                images: product.images,
                variants: product.variants,
                rating: product.rating,
                reviews: product.reviews,
                description: descriptionController.text.trim(),
                isNew: product.isNew,
                isPromotional: product.isPromotional,
                isBestSeller: product.isBestSeller,
                createdAt: product.createdAt,
              );
              onEdit(updated);
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Xóa',
            onPressed: () {
              onDelete();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: brandController,
              decoration: const InputDecoration(labelText: 'Thương hiệu'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Giá'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(labelText: 'Giảm giá (%)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Danh mục'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
              maxLines: 4,
            ),
            // You can add controls for images/variants if needed
          ],
        ),
      ),
    );
  }
}
