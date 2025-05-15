import 'package:flutter/material.dart';
import 'CustomNavbar.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  int _selectedTab = 0;
  final List<String> _tabs = [
    'Tất cả',
    'Chờ xác nhận',
    'Đã xác nhận',
    'Đang vận chuyển',
    'Đã giao hàng',
    'Đã hủy',
  ];

  // Dữ liệu mẫu
  final String userName = 'Mai Nguyễn Phương Trang';
  final String userPhone = '03*****253';
  final String userAvatar = 'assets/images/avatar1.png';
  final int totalOrders = 2;
  final List<Map<String, dynamic>> orders = [
    {
      'image': 'assets/images/product/headphone.png',
      'name': 'Tai nghe chụp tai Dareu EH416-Đen',
      'price': 320000,
      'status': 'Đã giao hàng',
      'created': '02/04/2025 16:49',
    },
    {
      'image': 'assets/images/product/mouse.png',
      'name': 'Chuột Gaming có dây Rapoo VT30-Đen',
      'price': 480000,
      'status': 'Đã giao hàng',
      'created': '28/05/2024 18:20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavbar(
        cartItemCount: 0,
        onHomeTap: () {},
        onCategoriesTap: () {},
        onCartTap: () {},
        onRegisterTap: () {},
        onLoginTap: () {},
        onSupportTap: () {},
        onSearch: (value) {},
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu bên trái
          Container(
            width: 240,
            color: const Color(0xFFF7F7F7),
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuItem(Icons.home, 'Trang chủ', false, () {}),
                _buildMenuItem(Icons.history, 'Lịch sử mua hàng', true, () {}),
                _buildMenuItem(Icons.person, 'Tài khoản của bạn', false, () {}),
                _buildMenuItem(Icons.support_agent, 'Hỗ trợ', false, () {}),
                _buildMenuItem(Icons.logout, 'Đăng xuất', false, () {}),
              ],
            ),
          ),
          // Nội dung bên phải
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin user
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(userAvatar),
                        radius: 32,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(userPhone, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Tổng số lượng đơn
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text('$totalOrders', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                            const SizedBox(height: 4),
                            const Text('đơn hàng', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Tabs trạng thái đơn hàng
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_tabs.length, (index) {
                        final bool selected = _selectedTab == index;
                        Color selectedColor;
                        switch (index) {
                          case 0:
                            selectedColor = Colors.blue;
                            break;
                          case 1:
                            selectedColor = Colors.amber;
                            break;
                          case 2:
                            selectedColor = Colors.blue;
                            break;
                          case 3:
                            selectedColor = Colors.amber;
                            break;
                          case 4:
                            selectedColor = Colors.green;
                            break;
                          case 5:
                            selectedColor = Colors.red;
                            break;
                          default:
                            selectedColor = Colors.blue;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ChoiceChip(
                            label: Text(
                              _tabs[index],
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black87,
                                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            selected: selected,
                            selectedColor: selectedColor,
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.grey[200],
                            onSelected: (_) {
                              setState(() {
                                _selectedTab = index;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Danh sách đơn hàng
                  Expanded(
                    child: ListView.separated(
                      itemCount: orders.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  order['image'],
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 8),
                                    Text('${order['price'].toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}đ', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(order['created'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Xem chi tiết', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F6FA),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, bool selected, VoidCallback onTap) {
    return Material(
      color: selected ? const Color(0xFFFDECEC) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          child: Row(
            children: [
              Icon(icon, color: selected ? Colors.red : Colors.black54, size: 22),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: selected ? Colors.red : Colors.black87,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 