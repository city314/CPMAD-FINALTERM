import 'package:flutter/material.dart';
import '../../models/category.dart'; // Model Category :contentReference[oaicite:0]{index=0}:contentReference[oaicite:1]{index=1}

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({Key? key}) : super(key: key);

  @override
  _AdminCategoryScreenState createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  // Test data ban đầu, có thể load từ API sau này
  final List<Category> _categories = [
    Category(id: 'c1', name: 'Laptop'),
    Category(id: 'c2', name: 'SSD'),
    Category(id: 'c3', name: 'Mouse'),
  ];

  void _showEditDialog({Category? category}) {
    final isNew = category == null;
    final _nameCtrl = TextEditingController(text: category?.name ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? 'Tạo danh mục mới' : 'Chỉnh sửa danh mục'),
        content: TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(labelText: 'Tên danh mục'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              final name = _nameCtrl.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tên danh mục không được để trống')),
                );
                return;
              }
              setState(() {
                if (isNew) {
                  _categories.add(Category(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                  ));
                } else {
                  final idx = _categories.indexWhere((c) => c.id == category.id);
                  _categories[idx] = Category(id: category.id, name: name);
                }
              });
              Navigator.pop(context);
            },
            child: Text(isNew ? 'Tạo' : 'Lưu'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(Category c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text('Bạn có chắc muốn xoá danh mục "${c.name}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() => _categories.removeWhere((x) => x.id == c.id));
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
        title: const Text('Category Management'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Tạo danh mục mới',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const Divider(height: 32),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          return ListTile(
            title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Chỉnh sửa',
                  onPressed: () => _showEditDialog(category: cat),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Xoá',
                  onPressed: () => _deleteCategory(cat),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
