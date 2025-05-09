import 'package:flutter/material.dart';
import 'productList.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _allLaptops = List.generate(6, (index) => 'Laptop Model ${index + 1}');
  List<String> _filteredLaptops = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _searchKeyword = '';
  final List<String> _sliderImages = [
  'assets/images/slider/slider1.png',
  'assets/images/slider/slider2.png',
  'assets/images/slider/slider3.jpg',
  ];
  final List<Map<String, dynamic>> categories = [
    {'name': 'Laptop', 'icon': Icons.laptop},
    {'name': 'PC', 'icon': Icons.desktop_windows},
    {'name': 'Phụ kiện', 'icon': Icons.headphones},
    {'name': 'Màn hình', 'icon': Icons.monitor},
    {'name': 'Bàn phím', 'icon': Icons.keyboard},
    {'name': 'Chuột', 'icon': Icons.mouse},
  ];
  final List<Map<String, dynamic>> hotSaleProducts = [
    {
      'name': 'Laptop Gaming ROG',
      'price': '29.990.000₫',
      'image': 'assets/images/product/laptop.jpg',
    },
    {
      'name': 'PC Đồ họa',
      'price': '19.990.000₫',
      'image': 'assets/images/product/pc.jpg',
    },
    {
      'name': 'Màn hình 27"',
      'price': '5.990.000₫',
      'image': 'assets/images/product/monitor.jpg',
    },
    {
      'name': 'Chuột Gaming',
      'price': '990.000₫',
      'image': 'assets/images/product/mouse.jpg',
    },
    {
      'name': 'Bàn phím Cơ',
      'price': '1.490.000₫',
      'image': 'assets/images/product/keyboard.jpg',
    },
  ];
  final List<Map<String, dynamic>> newProducts = [
    {
      'name': 'Laptop Văn phòng',
      'price': '15.990.000₫',
      'image': 'assets/images/product/laptop2.jpg',
    },
    {
      'name': 'PC Gaming',
      'price': '22.990.000₫',
      'image': 'assets/images/product/pc2.jpg',
    },
    {
      'name': 'Màn hình cong 24"',
      'price': '3.990.000₫',
      'image': 'assets/images/product/monitor2.jpg',
    },
    {
      'name': 'Tai nghe Bluetooth',
      'price': '790.000₫',
      'image': 'assets/images/product/headphone.jpg',
    },
    {
      'name': 'Webcam Full HD',
      'price': '1.190.000₫',
      'image': 'assets/images/product/webcam.jpg',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _filteredLaptops = List.from(_allLaptops); // ban đầu hiện toàn bộ
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavbar(
        cartItemCount: 0,
        onHomeTap: () {
          // TODO: Chuyển tới trang chủ
        },
        onCategoriesTap: () {
          // TODO: Chuyển tới trang categories
        },
        onCartTap: () {
          // TODO: Chuyển tới trang giỏ hàng
        },
        onRegisterTap: () {
          // TODO: Chuyển tới trang đăng ký
        },
        onLoginTap: () {
          // TODO: Chuyển tới trang đăng nhập
        },
        onSearch: (value) {
          setState(() {
            _searchKeyword = value.toLowerCase();
            _filteredLaptops = _allLaptops
                .where((laptop) => laptop.toLowerCase().contains(_searchKeyword))
                .toList();
          });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 450,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _sliderImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            _sliderImages[index],
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                  ),
                  // Nút điều hướng trái
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                      onPressed: () {
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // Nếu đang ở slide đầu, chuyển về slide cuối
                          _pageController.jumpToPage(_sliderImages.length - 1);
                          setState(() {
                            _currentPage = _sliderImages.length - 1;
                          });
                        }
                      },
                    ),
                  ),
                  // Nút điều hướng phải
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.white, size: 30),
                      onPressed: () {
                        if (_currentPage < _sliderImages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // Nếu đang ở slide cuối, chuyển về slide đầu
                          _pageController.jumpToPage(0);
                          setState(() {
                            _currentPage = 0;
                          });
                        }
                      },
                    ),
                  ),
                  // Indicator
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_sliderImages.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? Colors.blueAccent : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 120,
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            // TODO: Xử lý khi bấm vào danh mục
                          },
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(categories[index]['icon'], size: 36, color: Colors.blueAccent),
                                const SizedBox(height: 8),
                                Text(
                                  categories[index]['name'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.local_fire_department, color: Colors.red, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'Hot Sale',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Center(
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: hotSaleProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final product = hotSaleProducts[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  product['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['price'],
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 16),
                              label: const Text('Thêm', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xem tất cả sản phẩm hot sale
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Xem tất cả', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.new_releases, color: Colors.blueAccent, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'Sản phẩm mới',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Center(
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: newProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final product = newProducts[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  product['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['price'],
                              style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 16),
                              label: const Text('Thêm', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xem tất cả sản phẩm mới
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Xem tất cả', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFF43A7C6),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'CỬA HÀNG LAPIZONE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.phone, color: Colors.black, size: 18),
                        SizedBox(width: 8),
                        Text('SĐT: 0123 456 789', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.location_on, color: Colors.black, size: 18),
                        SizedBox(width: 8),
                        Text('Địa chỉ: Tân Phong, Quận 7, TP HCM', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.email, color: Colors.black, size: 18),
                        SizedBox(width: 8),
                        Text('Email: info@lapizone.vn', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.support_agent, color: Colors.black, size: 18),
                        SizedBox(width: 8),
                        Text('Hotline: 1800 1234', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaptopCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                'assets/images/product/laptop.jpg', // Đảm bảo có ảnh trong assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Laptop Model ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '\$999',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Thêm vào giỏ hàng
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Thêm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNavbar extends StatelessWidget implements PreferredSizeWidget {
  final int cartItemCount;
  final VoidCallback onHomeTap;
  final VoidCallback onCategoriesTap;
  final VoidCallback onCartTap;
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginTap;
  final ValueChanged<String> onSearch;

  const CustomNavbar({
    Key? key,
    this.cartItemCount = 0,
    required this.onHomeTap,
    required this.onCategoriesTap,
    required this.onCartTap,
    required this.onRegisterTap,
    required this.onLoginTap,
    required this.onSearch,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF43A7C6),
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo/logo_with_title-removebg-preview.png', // Đổi thành đường dẫn logo của bạn
            height: 70,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'search',
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                suffixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20),
          TextButton(
            onPressed: onHomeTap,
            child: const Text('HOME', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: onCategoriesTap,
            child: const Text('CATEGORIES', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: onCartTap,
            child: Row(
              children: [
                const Text('CART', style: TextStyle(color: Colors.black)),
                const SizedBox(width: 4),
                Text('$cartItemCount', style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          PopupMenuButton<int>(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 32),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: const Icon(Icons.app_registration),
                  title: const Text('Register'),
                  onTap: () {
                    Navigator.pop(context);
                    onRegisterTap();
                  },
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Login'),
                  onTap: () {
                    Navigator.pop(context);
                    onLoginTap();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
