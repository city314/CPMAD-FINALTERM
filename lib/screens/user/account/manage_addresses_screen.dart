import 'package:flutter/material.dart';

class AddressData {
  static List<String> addresses = [
    '123 Đường ABC, Quận 1, TP.HCM',
    '456 Đường DEF, Quận 3, TP.HCM',
  ];

  static int defaultIndex = 0;

  static String get defaultAddress => addresses[defaultIndex];
}

class ManageAddressesScreen extends StatefulWidget {
  const ManageAddressesScreen({super.key});

  @override
  State<ManageAddressesScreen> createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  List<String> addresses = AddressData.addresses;
  int defaultIndex = AddressData.defaultIndex;

  void _addAddress() async {
    final newAddress = await _showAddressDialog();
    if (newAddress != null && newAddress.trim().isNotEmpty) {
      setState(() {
        addresses.add(newAddress);
      });
    }
  }

  void _editAddress(int index) async {
    final edited = await _showAddressDialog(initial: addresses[index]);
    if (edited != null && edited.trim().isNotEmpty) {
      setState(() {
        AddressData.defaultIndex = index;
      });
    }
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá địa chỉ'),
        content: const Text('Bạn có chắc muốn xoá địa chỉ này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          TextButton(
            onPressed: () {
              setState(() {
                if (defaultIndex == index) defaultIndex = 0;
                addresses.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<String?> _showAddressDialog({String? initial}) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(initial == null ? 'Thêm địa chỉ' : 'Chỉnh sửa địa chỉ'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nhập địa chỉ'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Lưu')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý địa chỉ'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: addresses.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final isDefault = index == defaultIndex;
          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(addresses[index]),
            subtitle: isDefault ? const Text('Địa chỉ mặc định', style: TextStyle(color: Colors.green)) : null,
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') _editAddress(index);
                if (value == 'delete') _deleteAddress(index);
                if (value == 'default') {
                  setState(() {
                    defaultIndex = index;
                  });
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                const PopupMenuItem(value: 'delete', child: Text('Xoá')),
                if (!isDefault) const PopupMenuItem(value: 'default', child: Text('Đặt làm mặc định')),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAddress,
        child: const Icon(Icons.add),
      ),
    );
  }
}
