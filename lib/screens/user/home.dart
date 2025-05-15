import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'CustomNavbar.dart';
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
      'image': 'assets/images/product/laptop1.png',
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

  final List<Map<String, dynamic>> promotionProducts = [
    {
      'name': 'Laptop Gaming MSI',
      'price': '24.990.000₫',
      'image': 'assets/images/product/laptop3.jpg',
    },
    {
      'name': 'PC Workstation',
      'price': '32.990.000₫',
      'image': 'assets/images/product/pc3.jpg',
    },
    {
      'name': 'Màn hình 4K 32"',
      'price': '8.990.000₫',
      'image': 'assets/images/product/monitor3.jpg',
    },
    {
      'name': 'Bàn phím Gaming RGB',
      'price': '2.490.000₫',
      'image': 'assets/images/product/keyboard2.jpg',
    },
    {
      'name': 'Chuột Gaming RGB',
      'price': '1.290.000₫',
      'image': 'assets/images/product/mouse2.jpg',
    },
  ];

  bool isLoggedIn = true; // Mặc định đã đăng nhập để test

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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMobile = screenSize.width < 400;
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;

    return Scaffold(
      appBar: CustomNavbar(
        cartItemCount: 0,
        onHomeTap: () {
          // TODO: Chuyển tới trang chủ
          context.go('/home');
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
          context.go('/');
        },
        onSupportTap: () {
          context.goNamed('admin_chat', extra: 'admin@gmail.com');
        },
        onProfileTap: isAndroid ? () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đi tới trang Profile')),
          );
        } : null,
        onLogoutTap: isAndroid ? () {
          setState(() {
            isLoggedIn = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã đăng xuất')),
          );
        } : null,
        onSearch: (value) {
          setState(() {
            _searchKeyword = value.toLowerCase();
            _filteredLaptops = _allLaptops
                .where((laptop) => laptop.toLowerCase().contains(_searchKeyword))
                .toList();
          });
        },
        isLoggedIn: isAndroid ? isLoggedIn : false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isAndroid)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 24, vertical: 8),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value.toLowerCase();
                      _filteredLaptops = _allLaptops
                          .where((laptop) => laptop.toLowerCase().contains(_searchKeyword))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sản phẩm...',
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
            SizedBox(
              height: isMobile ? 200 : (isSmallScreen ? 300 : 450),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8 : 16,
                          vertical: isMobile ? 8 : 16,
                        ),
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
              padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 16),
              child: SizedBox(
                height: isMobile ? 60 : (isSmallScreen ? 80 : 120),
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) => SizedBox(width: isMobile ? 8 : 18),
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            // TODO: Xử lý khi bấm vào danh mục
                          },
                          child: Container(
                            width: isMobile ? 60 : (isSmallScreen ? 80 : 100),
                            padding: EdgeInsets.all(isMobile ? 8 : 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  categories[index]['icon'],
                                  size: isMobile ? 20 : (isSmallScreen ? 24 : 36),
                                  color: Colors.blueAccent
                                ),
                                SizedBox(height: isMobile ? 4 : 8),
                                Flexible(
                                  child: Text(
                                    categories[index]['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isMobile ? 10 : 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
            // Hot Sale
            SizedBox(height: isMobile ? 16 : 32),
            Padding(
              padding: EdgeInsets.only(left: isMobile ? 16 : 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.red,
                      size: isMobile ? 24 : 28
                    ),
                    SizedBox(width: isMobile ? 8 : 13),
                    Text(
                      'Hot Sale',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isAndroid ? 1 : (isSmallScreen ? 2 : 5),
                  childAspectRatio: 1.1,
                  crossAxisSpacing: isAndroid ? 16 : 6,
                  mainAxisSpacing: isAndroid ? 16 : 6,
                ),
                itemCount: hotSaleProducts.length,
                itemBuilder: (context, index) {
                  final product = hotSaleProducts[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 16 : 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                product['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            product['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 18 : 14
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            product['price'],
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: isMobile ? 16 : 13
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: Icon(Icons.add_shopping_cart, size: isMobile ? 20 : 16),
                              label: Text(
                                'Thêm',
                                style: TextStyle(fontSize: isMobile ? 16 : 12)
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 16 : 8,
                                  vertical: isMobile ? 10 : 6
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
            SizedBox(width: 10),
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
            // Sản phẩm mới
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.new_releases, color: Colors.blueAccent, size: 28),
                    const SizedBox(width: 13),
                    const Text(
                      'Sản phẩm mới',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isAndroid ? 1 : (isSmallScreen ? 2 : 5),
                  childAspectRatio: 1.1,
                  crossAxisSpacing: isAndroid ? 16 : 6,
                  mainAxisSpacing: isAndroid ? 16 : 6,
                ),
                itemCount: newProducts.length,
                itemBuilder: (context, index) {
                  final product = newProducts[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                product['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            product['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            product['price'],
                            style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 20),
                              label: const Text('Thêm', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
            SizedBox(width: 10),
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
            // Sản phẩm khuyến mãi
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.local_offer, color: Colors.orange, size: 28),
                    const SizedBox(width: 13),
                    const Text(
                      'Sản phẩm khuyến mãi',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isAndroid ? 1 : (isSmallScreen ? 2 : 5),
                  childAspectRatio: 1.1,
                  crossAxisSpacing: isAndroid ? 16 : 6,
                  mainAxisSpacing: isAndroid ? 16 : 6,
                ),
                itemCount: promotionProducts.length,
                itemBuilder: (context, index) {
                  final product = promotionProducts[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                product['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            product['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            product['price'],
                            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 20),
                              label: const Text('Thêm', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xem tất cả sản phẩm khuyến mãi
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
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
            // Danh mục Laptop
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.laptop, color: Colors.indigo, size: 28),
                    const SizedBox(width: 13),
                    const Text(
                      'Laptop',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isAndroid ? 1 : (isSmallScreen ? 2 : 5),
                  childAspectRatio: 1.1,
                  crossAxisSpacing: isAndroid ? 16 : 6,
                  mainAxisSpacing: isAndroid ? 16 : 6,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/product/laptop${index + 1}.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Laptop Gaming ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${(index + 1) * 5}.990.000₫',
                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 20),
                              label: const Text('Thêm', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xem tất cả sản phẩm Laptop
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
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
            // Danh mục PC
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.desktop_windows, color: Colors.indigo, size: 28),
                    const SizedBox(width: 13),
                    const Text(
                      'PC',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isAndroid ? 1 : (isSmallScreen ? 2 : 5),
                  childAspectRatio: 1.1,
                  crossAxisSpacing: isAndroid ? 16 : 6,
                  mainAxisSpacing: isAndroid ? 16 : 6,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/product/pc${index + 1}.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'PC Gaming ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${(index + 1) * 7}.990.000₫',
                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 20),
                              label: const Text('Thêm', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xem tất cả sản phẩm PC
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
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
            // Danh mục Tai nghe
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.headphones, color: Colors.indigo, size: 28),
                    const SizedBox(width: 13),
                    const Text(
                      'Tai nghe',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isAndroid ? 1 : (isSmallScreen ? 2 : 5),
                  childAspectRatio: 1.1,
                  crossAxisSpacing: isAndroid ? 16 : 6,
                  mainAxisSpacing: isAndroid ? 16 : 6,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/product/headphone${index + 1}.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tai nghe Gaming ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${(index + 1) * 1}.990.000₫',
                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 20),
                              label: const Text('Thêm', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xem tất cả sản phẩm Tai nghe
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
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
            // Danh mục Màn hình
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.monitor, color: Colors.indigo, size: 28),
                    const SizedBox(width: 13),
                    const Text(
                      'Màn hình',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isAndroid ? 1 : (isSmallScreen ? 2 : 5),
                  childAspectRatio: 1.1,
                  crossAxisSpacing: isAndroid ? 16 : 6,
                  mainAxisSpacing: isAndroid ? 16 : 6,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/product/monitor${index + 1}.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Màn hình Gaming ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${(index + 1) * 3}.990.000₫',
                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 20),
                              label: const Text('Thêm', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xem tất cả sản phẩm Màn hình
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
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
            // Danh mục Bàn phím
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.keyboard, color: Colors.indigo, size: 28),
                    const SizedBox(width: 13),
                    const Text(
                      'Bàn phím',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isAndroid ? 1 : (isSmallScreen ? 2 : 5),
                  childAspectRatio: 1.1,
                  crossAxisSpacing: isAndroid ? 16 : 6,
                  mainAxisSpacing: isAndroid ? 16 : 6,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/product/keyboard${index + 1}.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Bàn phím Gaming ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${(index + 1) * 2}.990.000₫',
                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Thêm vào giỏ hàng
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 20),
                              label: const Text('Thêm', style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xem tất cả sản phẩm Bàn phím
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
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
                'assets/images/product/laptop1.png', // Đảm bảo có ảnh trong assets
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
