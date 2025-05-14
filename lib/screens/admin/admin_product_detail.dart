import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cpmad_final/models/product.dart';
import 'package:cpmad_final/models/category.dart';
import 'package:cpmad_final/models/brand.dart';

import '../../models/variant.dart';

// TODO: replace with dynamic data sources
final List<Category> categories = [Category(id: 'laptop', name: 'Laptop'), Category(id: 'ssd', name: 'SSD')];
final List<Brand> brands = [Brand(id: 'asus', name: 'ASUS', imgUrl: ''), Brand(id: 'samsung', name: 'Samsung', imgUrl: '')];

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
  _AdminProductDetailState createState() => _AdminProductDetailState();
}

class _AdminProductDetailState extends State<AdminProductDetail> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _descCtrl;

  late Category _selectedCategory;
  late Brand _selectedBrand;
  late List<Variant> _variants;
  List<PlatformFile> _images = [];
  List<PlatformFile> _editingVariantImages = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p.name);
    _priceCtrl = TextEditingController(text: p.price.toString());
    _stockCtrl = TextEditingController(text: p.stock.toString());
    _descCtrl = TextEditingController(text: p.description);
    _variants = List<Variant>.from(p.variants);
    _selectedCategory = categories.firstWhere(
          (c) => c.id == p.categoryId,
      orElse: () => categories.first,
    );
    _selectedBrand = brands.firstWhere(
          (b) => b.id == p.brandId,
      orElse: () => brands.first,
    );

    if (p.imgUrl.isNotEmpty) {
      _images.add(PlatformFile(
        name: p.imgUrl.split('/').last,
        path: p.imgUrl,
        bytes: null,
        size: 0,
      ));
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: kIsWeb,
    );
    if (result != null) {
      setState(() {
        _images.addAll(result.files);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _showVariantDetails(Variant variant) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 600, // hoặc double.infinity
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chi tiết biến thể', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('Tên: ${variant.variantName}'),
                    const SizedBox(height: 8),
                    Text('Màu: ${variant.color}'),
                    const SizedBox(height: 8),
                    Text('Thuộc tính: ${variant.attributes}'),
                    const SizedBox(height: 8),
                    Text('Giá: ₫${variant.price.toStringAsFixed(0)}'),
                    const SizedBox(height: 8),
                    Text('Tồn kho: ${variant.stock}'),
                    const SizedBox(height: 16),
                    const Text('Ảnh biến thể', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: variant.images.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final img = variant.images[index];
                        if (img.imageUrl.isEmpty) return const Icon(Icons.broken_image);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: !kIsWeb && File(img.imageUrl).existsSync()
                              ? Image.file(File(img.imageUrl), fit: BoxFit.cover)
                              : Image.network(img.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                            return const Icon(Icons.image_not_supported);
                          }),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Đóng'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageTile(int index) {
    final file = _images[index];
    Widget img;
    if (!kIsWeb && file.path != null) {
      img = Image.file(File(file.path!), fit: BoxFit.cover);
    } else if (file.bytes != null) {
      img = Image.memory(file.bytes!, fit: BoxFit.cover);
    } else {
      img = const Icon(Icons.broken_image, size: 40, color: Colors.grey);
    }
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Colors.grey[200],
            child: AspectRatio(aspectRatio: 1, child: img),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final firstPath = _images.isNotEmpty ? (_images.first.path ?? '') : '';
    final updated = Product(
      id: widget.product.id,
      name: _nameCtrl.text.trim(),
      categoryId: _selectedCategory.id!,
      brandId: _selectedBrand.id!,
      price: double.tryParse(_priceCtrl.text) ?? widget.product.price,
      stock: int.tryParse(_stockCtrl.text) ?? widget.product.stock,
      description: _descCtrl.text.trim(),
      variants:    _variants,
      imgUrl: firstPath,
      timeAdd: widget.product.timeAdd,
    );
    widget.onEdit(updated);
    Navigator.of(context).pop();
  }

  void _showAddVariantDialog() async {
    final nameCtrl = TextEditingController();
    final colorCtrl = TextEditingController(text: 'black');
    final attrCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();

    final variant = await showDialog<Variant>(
      context: context,
      builder: (context) {
        List<PlatformFile> variantImages = [];
        return AlertDialog(
          title: const Text('Thêm Variant'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Tên biến thể'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: colorCtrl,
                  decoration: const InputDecoration(labelText: 'Màu sắc'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: attrCtrl,
                  decoration: const InputDecoration(labelText: 'Thuộc tính'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Giá'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Số lượng tồn kho'),
                ),
                const SizedBox(height: 12),
                const Text('Ảnh biến thể', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GridView.builder(
                  itemCount: variantImages.length + 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, i) {
                    if (i < variantImages.length) {
                      final file = variantImages[i];
                      Widget img;
                      if (!kIsWeb && file.path != null) {
                        img = Image.file(File(file.path!), fit: BoxFit.cover);
                      } else if (file.bytes != null) {
                        img = Image.memory(file.bytes!, fit: BoxFit.cover);
                      } else {
                        img = const Icon(Icons.broken_image, size: 40);
                      }

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              color: Colors.grey[200],
                              child: AspectRatio(aspectRatio: 1, child: img),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => setState(() => variantImages.removeAt(i)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.close, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return GestureDetector(
                      onTap: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: true,
                          withData: kIsWeb,
                        );
                        if (result != null) {
                          setState(() => variantImages.addAll(result.files));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  final images = variantImages.map((f) {
                    return VariantImage(imageUrl: f.path ?? '');
                  }).toList();

                  final newVariant = Variant(
                    id: null,
                    productId: widget.product.id ?? '',
                    variantName: nameCtrl.text.trim(),
                    color: colorCtrl.text.trim(),
                    attributes: attrCtrl.text.trim(),
                    price: double.tryParse(priceCtrl.text.trim()) ?? 0,
                    stock: int.tryParse(stockCtrl.text.trim()) ?? 0,
                    images: images,
                  );
                  Navigator.pop(context, newVariant);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );

    if (variant != null) {
      setState(() => _variants.add(variant));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.product.id?.isEmpty ?? true) ? 'Thêm sản phẩm' : 'Chỉnh sửa sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: widget.onDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // Basic Info
                    const Text('Thông tin cơ bản', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tên sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Tên không được để trống' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Category>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Danh mục',
                              border: OutlineInputBorder(),
                            ),
                            items: categories
                                .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                                .toList(),
                            onChanged: (c) => setState(() => _selectedCategory = c!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<Brand>(
                            value: _selectedBrand,
                            decoration: const InputDecoration(
                              labelText: 'Thương hiệu',
                              border: OutlineInputBorder(),
                            ),
                            items: brands
                                .map((b) => DropdownMenuItem(value: b, child: Text(b.name)))
                                .toList(),
                            onChanged: (b) => setState(() => _selectedBrand = b!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Giá',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => double.tryParse(v!) == null ? 'Giá không hợp lệ' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _stockCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Kho',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => int.tryParse(v!) == null ? 'Kho không hợp lệ' : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Image Picker
                    const Text('Ảnh sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _images.length + 1,
                      itemBuilder: (context, i) {
                        if (i < _images.length) {
                          return _buildImageTile(i);
                        }
                        return GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Description
                    const Text('Mô tả chi tiết', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nhập mô tả...',
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 40),
                    const Text('Variants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ListView.builder(
                      itemCount: _variants.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final v = _variants[index];

                        if (_editingIndex == index) {
                          final nameCtrl = TextEditingController(text: v.variantName);
                          final colorCtrl = TextEditingController(text: v.color);
                          final attrCtrl = TextEditingController(text: v.attributes);
                          final priceCtrl = TextEditingController(text: v.price.toString());
                          final stockCtrl = TextEditingController(text: v.stock.toString());

                          _editingVariantImages = v.images.map((img) =>
                              PlatformFile(name: img.imageUrl.split('/').last, path: img.imageUrl, size: 0)).toList();

                          return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: Colors.grey[100],
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Expanded(
                                        child: TextField(
                                          controller: nameCtrl,
                                          decoration: const InputDecoration(labelText: 'Tên biến thể'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: colorCtrl,
                                          decoration: const InputDecoration(labelText: 'Màu sắc'),
                                        ),
                                      ),
                                    ]),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: attrCtrl,
                                      decoration: const InputDecoration(labelText: 'Thuộc tính'),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(children: [
                                      Expanded(
                                        child: TextField(
                                          controller: priceCtrl,
                                          decoration: const InputDecoration(labelText: 'Giá'),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: stockCtrl,
                                          decoration: const InputDecoration(labelText: 'Tồn kho'),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ]),
                                    const SizedBox(height: 12),
                                    const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Ảnh biến thể', style: TextStyle(fontWeight: FontWeight.bold))),
                                    const SizedBox(height: 8),
                                    GridView.builder(
                                      itemCount: _editingVariantImages.length + 1,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 1.2,
                                      ),
                                      itemBuilder: (context, i) {
                                        if (i < _editingVariantImages.length) {
                                          final file = _editingVariantImages[i];
                                          Widget img;
                                          if (!kIsWeb && file.path != null) {
                                            img = Image.file(File(file.path!), fit: BoxFit.cover);
                                          } else if (file.bytes != null) {
                                            img = Image.memory(file.bytes!, fit: BoxFit.cover);
                                          } else {
                                            img = const Icon(Icons.broken_image, size: 40);
                                          }

                                          return Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  child: AspectRatio(aspectRatio: 1, child: img),
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () => setState(() => _editingVariantImages.removeAt(i)),
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                      color: Colors.black54,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    padding: const EdgeInsets.all(4),
                                                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }

                                        // Add button
                                        return GestureDetector(
                                          onTap: () async {
                                            final result = await FilePicker.platform.pickFiles(
                                              type: FileType.image,
                                              allowMultiple: true,
                                              withData: kIsWeb,
                                            );
                                            if (result != null) {
                                              setState(() => _editingVariantImages.addAll(result.files));
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.grey),
                                            ),
                                            child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () => setState(() => _editingIndex = null),
                                          child: const Text('Hủy'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            final updated = v.copyWith(
                                              variantName: nameCtrl.text.trim(),
                                              color: colorCtrl.text.trim(),
                                              attributes: attrCtrl.text.trim(),
                                              price: double.tryParse(priceCtrl.text.trim()) ?? v.price,
                                              stock: int.tryParse(stockCtrl.text.trim()) ?? v.stock,
                                              images: _editingVariantImages
                                                  .map((f) => VariantImage(imageUrl: f.path ?? ''))
                                                  .toList(),
                                            );
                                            setState(() {
                                              _variants[index] = updated;
                                              _editingIndex = null;
                                              _editingVariantImages.clear();
                                            });
                                          },
                                          child: const Text('Lưu'),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          tooltip: 'Xoá biến thể',
                                          onPressed: () {
                                            setState(() {
                                              _variants.removeAt(index);
                                              _editingIndex = null;
                                              _editingVariantImages.clear();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          );
                        }

                        // Hiển thị tile mặc định khi không chỉnh
                        return Card(
                          child: ListTile(
                            title: Text(v.variantName.isNotEmpty ? v.variantName : '(Chưa đặt tên)'),
                            subtitle: Text('Giá: ₫${v.price.toStringAsFixed(0)}  •  Kho: ${v.stock}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.info_outline, color: Colors.grey),
                                  tooltip: 'Xem chi tiết',
                                  onPressed: () => _showVariantDetails(v),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Chỉnh sửa',
                                  onPressed: () => setState(() => _editingIndex = index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm variant'),
                        onPressed: _showAddVariantDialog,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu sản phẩm'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
