import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Address {
  final String id;
  final String receiverName;
  final String phoneNumber;
  final String province;
  final String district;
  final String ward;
  final String streetDetail;

  Address({
    required this.id,
    required this.receiverName,
    required this.phoneNumber,
    required this.province,
    required this.district,
    required this.ward,
    required this.streetDetail,
  });

  String get fullAddress => '$streetDetail, $ward, $district, $province';
}

class ManageAddressesScreen extends StatefulWidget {
  const ManageAddressesScreen({super.key});

  @override
  State<ManageAddressesScreen> createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  List<Address> addresses = [
    Address(
      id: const Uuid().v4(),
      receiverName: 'Nguyễn Văn A',
      phoneNumber: '0901234567',
      province: 'TP.HCM',
      district: 'Quận 1',
      ward: 'Phường Bến Nghé',
      streetDetail: '123 Đường ABC',
    ),
    Address(
      id: const Uuid().v4(),
      receiverName: 'Trần Thị B',
      phoneNumber: '0987654321',
      province: 'TP.HCM',
      district: 'Quận 3',
      ward: 'Phường 7',
      streetDetail: '456 Đường DEF',
    ),
  ];

  String defaultAddressId = '';

  @override
  void initState() {
    super.initState();
    defaultAddressId = addresses.first.id;
  }

  void _addAddress() async {
    final newAddress = await _showAddressDialog();
    if (newAddress != null) {
      setState(() {
        addresses.add(newAddress);
      });
    }
  }

  void _editAddress(int index) async {
    final edited = await _showAddressDialog(initial: addresses[index]);
    if (edited != null) {
      setState(() {
        addresses[index] = edited.copyWith(id: addresses[index].id);
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
                if (defaultAddressId == addresses[index].id) {
                  defaultAddressId = addresses.first.id;
                }
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

  Future<Address?> _showAddressDialog({Address? initial}) {
    final nameController = TextEditingController(text: initial?.receiverName ?? '');
    final phoneController = TextEditingController(text: initial?.phoneNumber ?? '');
    final provinceController = TextEditingController(text: initial?.province ?? '');
    final districtController = TextEditingController(text: initial?.district ?? '');
    final wardController = TextEditingController(text: initial?.ward ?? '');
    final streetController = TextEditingController(text: initial?.streetDetail ?? '');

    return showDialog<Address>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(initial == null ? 'Thêm địa chỉ' : 'Chỉnh sửa địa chỉ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên người nhận'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: provinceController,
                decoration: const InputDecoration(labelText: 'Tỉnh/Thành phố'),
              ),
              TextField(
                controller: districtController,
                decoration: const InputDecoration(labelText: 'Quận/Huyện'),
              ),
              TextField(
                controller: wardController,
                decoration: const InputDecoration(labelText: 'Phường/Xã'),
              ),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(labelText: 'Số nhà / Chi tiết'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          TextButton(
            onPressed: () {
              final newAddress = Address(
                id: initial?.id ?? const Uuid().v4(),
                receiverName: nameController.text.trim(),
                phoneNumber: phoneController.text.trim(),
                province: provinceController.text.trim(),
                district: districtController.text.trim(),
                ward: wardController.text.trim(),
                streetDetail: streetController.text.trim(),
              );
              Navigator.pop(context, newAddress);
            },
            child: const Text('Lưu'),
          )
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
          final address = addresses[index];
          final isDefault = address.id == defaultAddressId;

          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(address.receiverName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SĐT: ${address.phoneNumber}'),
                Text('Địa chỉ: ${address.fullAddress}'),
                if (isDefault)
                  const Text('Địa chỉ mặc định', style: TextStyle(color: Colors.green)),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') _editAddress(index);
                if (value == 'delete') _deleteAddress(index);
                if (value == 'default') {
                  setState(() {
                    defaultAddressId = address.id;
                  });
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                const PopupMenuItem(value: 'delete', child: Text('Xoá')),
                if (!isDefault)
                  const PopupMenuItem(value: 'default', child: Text('Đặt làm mặc định')),
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

extension on Address {
  Address copyWith({
    String? id,
    String? receiverName,
    String? phoneNumber,
    String? province,
    String? district,
    String? ward,
    String? streetDetail,
  }) {
    return Address(
      id: id ?? this.id,
      receiverName: receiverName ?? this.receiverName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      streetDetail: streetDetail ?? this.streetDetail,
    );
  }
}
