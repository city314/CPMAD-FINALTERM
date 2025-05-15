import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'home.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // Danh sách danh mục và thương hiệu mẫu
  final Map<String, List<String>> categoryBrands = {
    'Laptop': ['Asus', 'Dell', 'HP', 'Apple'],
    'PC': ['Acer', 'Lenovo', 'MSI'],
    'Tai nghe': ['Sony', 'JBL', 'Sennheiser'],
    'Màn hình': ['Samsung', 'LG', 'ViewSonic'],
    'Bàn phím': ['Logitech', 'Razer'],
    'Chuột': ['Logitech', 'Razer', 'Fuhlen'],
    'Phụ kiện': ['Anker', 'Xiaomi'],
  };

  final Map<String, IconData> categoryIcons = {
    'Laptop': Icons.laptop,
    'PC': Icons.desktop_windows,
    'Tai nghe': Icons.headphones,
    'Màn hình': Icons.monitor,
    'Bàn phím': Icons.keyboard,
    'Chuột': Icons.mouse,
    'Phụ kiện': Icons.extension,
  };

  final Map<String, String> brandLogos = {
    'Asus': 'assets/images/brand/asus.png',
    'Dell': 'assets/images/brand/dell.png',
    'HP': 'assets/images/brand/hp.png',
    'Apple': 'assets/images/brand/apple.png',
    'Acer': 'assets/images/brand/acer.png',
    'Lenovo': 'assets/images/brand/lenovo.png',
    'MSI': 'assets/images/brand/msi.png',
    'Sony': 'assets/images/brand/sony.png',
    'JBL': 'assets/images/brand/jbl.png',
    'Sennheiser': 'assets/images/brand/sennheiser.png',
    'Samsung': 'assets/images/brand/samsung.png',
    'LG': 'assets/images/brand/lg.png',
    'ViewSonic': 'assets/images/brand/viewsonic.png',
    'Logitech': 'assets/images/brand/logitech.png',
    'Razer': 'assets/images/brand/razer.png',
    'Fuhlen': 'assets/images/brand/fuhlen.png',
    'Anker': 'assets/images/brand/anker.png',
    'Xiaomi': 'assets/images/brand/xiaomi.png',
  };

  int quantity = 1;
  int _currentImage = 0;
  final List<String> productImages = [
    'assets/images/product/laptop1.png',
    'assets/images/product/laptop2.jpg',
    'assets/images/product/laptop3.jpg',
  ];

  final PageController _imagePageController = PageController();

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Danh Mục Sản Phẩm',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    ...categoryBrands.entries.map((entry) => ExpansionTile(
                      title: Row(
                        children: [
                          Icon(categoryIcons[entry.key] ?? Icons.category),
                          const SizedBox(width: 12),
                          Text(entry.key),
                        ],
                      ),
                      children: entry.value.map((brand) => ListTile(
                        leading: brandLogos[brand] != null
                            ? Image.asset(brandLogos[brand]!, width: 24, height: 24)
                            : null,
                        title: Text(brand),
                        dense: true,
                        contentPadding: const EdgeInsets.only(left: 32),
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Xử lý khi chọn danh mục
                        },
                      )).toList(),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      body: isAndroid ? _buildAndroidLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildAndroidLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar và nút danh mục
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _showCategoryBottomSheet,
                  icon: const Icon(Icons.category),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          // Tên sản phẩm + đánh giá
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Laptop Gaming ROG Zephyrus',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 20)),
                    ),
                    const SizedBox(width: 8),
                    const Text('(120 đánh giá)', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Slide ảnh sản phẩm
          SizedBox(
            height: 300,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  controller: _imagePageController,
                  itemCount: productImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      productImages[index],
                      fit: BoxFit.contain,
                    );
                  },
                ),
                // Nút chuyển trái
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.black54, size: 32),
                    onPressed: () {
                      if (_currentImage > 0) {
                        _imagePageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      } else {
                        _imagePageController.jumpToPage(productImages.length - 1);
                      }
                    },
                  ),
                ),
                // Nút chuyển phải
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.black54, size: 32),
                    onPressed: () {
                      if (_currentImage < productImages.length - 1) {
                        _imagePageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      } else {
                        _imagePageController.jumpToPage(0);
                      }
                    },
                  ),
                ),
                // Indicator
                Positioned(
                  bottom: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(productImages.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentImage == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentImage == index ? Colors.blueAccent : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          // Giá + logo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '200.000.000 đ',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Row(
                  children: [
                    Image.asset('assets/images/brand/asus.png', width: 32, height: 32),
                    const SizedBox(width: 8),
                    const Icon(Icons.laptop),
                  ],
                ),
              ],
            ),
          ),
          // Điều chỉnh số lượng
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Số lượng:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) quantity--;
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Nút thêm giỏ hàng và mua ngay
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: const Text('Thêm giỏ hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Mua ngay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Mô tả sản phẩm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Laptop Gaming ROG Zephyrus sở hữu cấu hình mạnh mẽ, thiết kế mỏng nhẹ, màn hình 240Hz, phù hợp cho cả game thủ và dân sáng tạo nội dung. Pin trâu, tản nhiệt tốt, nhiều cổng kết nối.',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Đánh giá khách hàng
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đánh giá của khách hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildReview(
                  avatar: 'assets/images/avatar1.png',
                  name: 'Nguyễn Văn A',
                  rating: 5,
                  comment: 'Sản phẩm rất tốt, chơi game mượt, pin lâu, giao hàng nhanh!',
                ),
                const SizedBox(height: 16),
                _buildReview(
                  avatar: 'assets/images/avatar2.png',
                  name: 'Trần Thị B',
                  rating: 4,
                  comment: 'Máy đẹp, cấu hình mạnh, hơi nóng khi chơi lâu.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Sản phẩm gợi ý
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sản phẩm gợi ý',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.asset(
                                'assets/images/product/laptop1.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Laptop Gợi ý #${index + 1}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('19.990.000 đ', style: TextStyle(color: Colors.indigo, fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Footer
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
                      fontSize: 18,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.phone, color: Colors.black, size: 16),
                      SizedBox(width: 8),
                      Text('SĐT: 0123 456 789', style: TextStyle(color: Colors.black, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.location_on, color: Colors.black, size: 16),
                      SizedBox(width: 8),
                      Text('Địa chỉ: Tân Phong, Quận 7, TP HCM', style: TextStyle(color: Colors.black, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.email, color: Colors.black, size: 16),
                      SizedBox(width: 8),
                      Text('Email: info@lapizone.vn', style: TextStyle(color: Colors.black, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.support_agent, color: Colors.black, size: 16),
                      SizedBox(width: 8),
                      Text('Hotline: 1800 1234', style: TextStyle(color: Colors.black, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar danh mục
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF9FE),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: ListView(
            children: [
              const Text('Tất Cả Danh Mục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ...categoryBrands.entries.map((entry) => ExpansionTile(
                title: Text(entry.key),
                leading: Icon(categoryIcons[entry.key] ?? Icons.category),
                children: entry.value.map((brand) => ListTile(
                  leading: brandLogos[brand] != null
                      ? Image.asset(brandLogos[brand]!, width: 24, height: 24)
                      : null,
                  title: Text(brand),
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 32),
                  onTap: () {},
                )).toList(),
              )),
            ],
          ),
        ),
        // Nội dung chi tiết sản phẩm
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên sản phẩm + đánh giá
                Text(
                  'Laptop Gaming ROG Zephyrus',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 22)),
                    ),
                    const SizedBox(width: 8),
                    const Text('(120 đánh giá)', style: TextStyle(fontSize: 15, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 24),
                // Ảnh + giá + logo + nút
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Slide ảnh sản phẩm
                    SizedBox(
                      width: 320,
                      height: 320,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Nút chuyển trái
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: IconButton(
                              icon: const Icon(Icons.chevron_left, color: Colors.black54, size: 32),
                              onPressed: () {
                                if (_currentImage > 0) {
                                  _imagePageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                } else {
                                  _imagePageController.jumpToPage(productImages.length - 1);
                                }
                              },
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: PageView.builder(
                              controller: _imagePageController,
                              itemCount: productImages.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentImage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  productImages[index],
                                  fit: BoxFit.cover,
                                  width: 320,
                                  height: 320,
                                );
                              },
                            ),
                          ),
                          // Nút chuyển phải
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: IconButton(
                              icon: const Icon(Icons.chevron_right, color: Colors.black54, size: 32),
                              onPressed: () {
                                if (_currentImage < productImages.length - 1) {
                                  _imagePageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                } else {
                                  _imagePageController.jumpToPage(0);
                                }
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(productImages.length, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentImage == index ? 16 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentImage == index ? Colors.blueAccent : Colors.grey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Giá + logo + nút
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Logo thương hiệu
                              Image.asset('assets/images/brand/asus.png', width: 36, height: 36),
                              const SizedBox(width: 12),
                              // Logo danh mục
                              Icon(Icons.laptop),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '200.000.000 đ',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          const SizedBox(height: 24),
                          // Điều chỉnh số lượng
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Số lượng:', style: TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 1) quantity--;
                                  });
                                },
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add_shopping_cart, size: 18),
                                label: const Text('Thêm giỏ hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Mua ngay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Mô tả sản phẩm
                const Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Laptop Gaming ROG Zephyrus sở hữu cấu hình mạnh mẽ, thiết kế mỏng nhẹ, màn hình 240Hz, phù hợp cho cả game thủ và dân sáng tạo nội dung. Pin trâu, tản nhiệt tốt, nhiều cổng kết nối.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                // Đánh giá khách hàng
                const Text(
                  'Đánh giá của khách hàng',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Danh sách đánh giá mẫu
                Column(
                  children: [
                    _buildReview(
                      avatar: 'assets/images/avatar1.png',
                      name: 'Nguyễn Văn A',
                      rating: 5,
                      comment: 'Sản phẩm rất tốt, chơi game mượt, pin lâu, giao hàng nhanh!',
                    ),
                    const SizedBox(height: 16),
                    _buildReview(
                      avatar: 'assets/images/avatar2.png',
                      name: 'Trần Thị B',
                      rating: 4,
                      comment: 'Máy đẹp, cấu hình mạnh, hơi nóng khi chơi lâu.',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Sản phẩm gợi ý
                const Text(
                  'Sản phẩm gợi ý',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                              child: Image.asset(
                                'assets/images/product/laptop1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Laptop Gợi ý #${index + 1}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                const Text('19.990.000 đ', style: TextStyle(color: Colors.indigo, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                // Footer
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
        ),
      ],
    );
  }

  static Widget _buildReview({
    required String avatar,
    required String name,
    required int rating,
    required String comment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(avatar),
            radius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(
                        rating,
                        (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


