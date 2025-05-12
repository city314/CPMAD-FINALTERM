import 'package:flutter/material.dart';
import 'admin_product.dart'; // Model của bạn

class AdminProductDetail extends StatefulWidget {
  final Product product;
  final ValueChanged<Product> onEdit;
  final VoidCallback onDelete;

  const AdminProductDetail({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<AdminProductDetail> createState() => _AdminProductDetailState();
}

class _AdminProductDetailState extends State<AdminProductDetail> {
  late TextEditingController nameController;
  late TextEditingController brandController;
  late TextEditingController priceController;
  late TextEditingController discountController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;
  late TextEditingController variantController;

  // Mỗi controller cho 1 URL ảnh
  late List<TextEditingController> imageControllers;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller từ product hiện tại
    nameController       = TextEditingController(text: widget.product.name);
    brandController      = TextEditingController(text: widget.product.brand);
    priceController      = TextEditingController(text: widget.product.price.toString());
    discountController   = TextEditingController(text: widget.product.discount.toString());
    categoryController   = TextEditingController(text: widget.product.category);
    descriptionController= TextEditingController(text: widget.product.description);
    variantController    = TextEditingController(text: widget.product.variants[0].toString());

    imageControllers = widget.product.images
        .map((url) => TextEditingController(text: url))
        .toList();
  }

  @override
  void dispose() {
    // Giải phóng tất cả controller
    nameController.dispose();
    brandController.dispose();
    priceController.dispose();
    discountController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    variantController.dispose();
    for (var c in imageControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addImageField() {
    setState(() {
      imageControllers.add(TextEditingController());
    });
  }

  void _removeImageField(int i) {
    setState(() {
      imageControllers[i].dispose();
      imageControllers.removeAt(i);
    });
  }

  void _save() {
    // Gom dữ liệu từ tất cả controllers
    final updated = widget.product.copyWith(
      name:        nameController.text.trim(),
      brand:       brandController.text.trim(),
      price:       double.tryParse(priceController.text)     ?? widget.product.price,
      discount:    double.tryParse(discountController.text)  ?? widget.product.discount,
      category:    categoryController.text.trim(),
      description: descriptionController.text.trim(),
      images:      imageControllers
          .map((c) => c.text.trim())
          .where((u) => u.isNotEmpty)
          .toList(),
      variants:    [],
      createdAt:   widget.product.createdAt ?? DateTime.now(),
    );

    widget.onEdit(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name.isEmpty ? 'Thêm sản phẩm' : 'Chỉnh sửa sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: widget.onDelete,
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.green),
            onPressed: _save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Carousel preview ảnh
            if (imageControllers.isNotEmpty)
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageControllers.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final url = imageControllers[i].text.trim();
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: url.isEmpty
                          ? Container(
                        width: 180,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 60, color: Colors.grey),
                      )
                          : Image.network(
                        url,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 180,
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (imageControllers.isNotEmpty) const SizedBox(height: 24),

            // 2. Danh sách TextField nhập URL ảnh
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ảnh sản phẩm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _addImageField,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm ảnh'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(imageControllers.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: imageControllers[i],
                        decoration: InputDecoration(labelText: 'URL ảnh ${i + 1}'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeImageField(i),
                    ),
                  ],
                ),
              );
            }),

            const Divider(height: 32),

            // 3. Các trường còn lại
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
          ],
        ),
      ),
    );
  }
}
