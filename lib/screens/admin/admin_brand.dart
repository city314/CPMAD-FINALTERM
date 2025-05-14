import 'package:flutter/material.dart';
import '../../models/brand.dart';

class AdminBrandScreen extends StatefulWidget {
  const AdminBrandScreen({Key? key}) : super(key: key);

  @override
  State<AdminBrandScreen> createState() => _AdminBrandScreenState();
}

class _AdminBrandScreenState extends State<AdminBrandScreen> {
  final List<Brand> _brands = [
    // Test data
    Brand(id: 'b1', name: 'ASUS', imgUrl: 'https://example.com/asus.png'),
    Brand(id: 'b2', name: 'Samsung', imgUrl: 'https://example.com/samsung.png'),
    // … bạn có thể load từ API thay vào đây …
  ];

  void _showEditDialog({Brand? brand}) {
    final isNew = brand == null;
    final _nameCtrl = TextEditingController(text: brand?.name ?? '');
    final _imgCtrl  = TextEditingController(text: brand?.imgUrl ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? 'Tạo thương hiệu' : 'Chỉnh sửa thương hiệu'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Tên thương hiệu'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _imgCtrl,
            decoration: const InputDecoration(labelText: 'URL ảnh'),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              final name = _nameCtrl.text.trim();
              final url  = _imgCtrl.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tên không được để trống')),
                );
                return;
              }
              setState(() {
                if (isNew) {
                  _brands.add(Brand(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    imgUrl: url,
                  ));
                } else {
                  final idx = _brands.indexWhere((b) => b.id == brand.id);
                  _brands[idx] = Brand(id: brand.id, name: name, imgUrl: url);
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

  void _deleteBrand(Brand b) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text('Bạn có chắc muốn xoá “${b.name}”?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() => _brands.removeWhere((x) => x.id == b.id));
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
      appBar: AppBar(title: const Text('Quản lý Thương hiệu')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Tạo mới brand',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _brands.length,
        separatorBuilder: (_, __) => const Divider(height: 32),
        itemBuilder: (context, i) {
          final b = _brands[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: b.imgUrl.isNotEmpty
                  ? NetworkImage(b.imgUrl)
                  : null,
              child: b.imgUrl.isEmpty ? const Icon(Icons.branding_watermark) : null,
            ),
            title: Text(b.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Chỉnh sửa',
                onPressed: () => _showEditDialog(brand: b),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Xoá',
                onPressed: () => _deleteBrand(b),
              ),
            ]),
          );
        },
      ),
    );
  }
}
