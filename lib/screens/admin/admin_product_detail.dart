import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cpmad_final/models/product.dart';
import 'package:cpmad_final/models/category.dart';
import 'package:cpmad_final/models/brand.dart';

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
  late TextEditingController _seriesCtrl;
  late TextEditingController _descCtrl;

  late Category _selectedCategory;
  late Brand _selectedBrand;
  List<PlatformFile> _images = [];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p.name);
    _priceCtrl = TextEditingController(text: p.price.toString());
    _stockCtrl = TextEditingController(text: p.stock.toString());
    _seriesCtrl = TextEditingController(text: p.series);
    _descCtrl = TextEditingController(text: p.description);

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
    _seriesCtrl.dispose();
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
      series: _seriesCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      imgUrl: firstPath,
      timeAdd: widget.product.timeAdd,
    );
    widget.onEdit(updated);
    Navigator.of(context).pop();
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _seriesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Series',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Image Picker
                    const Text('Ảnh sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
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
